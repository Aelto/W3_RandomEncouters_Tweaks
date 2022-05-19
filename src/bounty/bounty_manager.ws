

statemachine class RER_BountyManager extends CEntity {
  var master: CRandomEncounters;
  var bounty_master_manager: RER_BountyMasterManager;

  public function init(master: CRandomEncounters) {
    this.master = master;
    this.bounty_master_manager = new RER_BountyMasterManager in this;
    this.GotoState('Processing');
  }

  //#region bounty settings & constants

  // returns the steps at which the seed gains difficulty points
  public function getSeedDifficultyStep(): int {
    return 1000;
  }

  public function getDifficultyForSeed(seed: int): int {
    // when using the 0 seed, which means the bounty is completely random. The
    // difficulty no longer scales on the seed as there is no seed but instead
    // on the player's level.
    if (seed == 0) {
      // there is still a level of randomness here, it uses the settings values
      // to get the difficulty relative to the player's level.
      return getRandomLevelBasedOnSettings(this.master.settings);
    }

    return (int)(seed / this.getSeedDifficultyStep());
  }

  // returns how much the seed cap is increased by bounty level
  public function getSeedBountyLevelStep(): int {
    return 500;
  }

  public function getMaximumSeed(): int {
    return this.master.storages.bounty.bounty_level * this.getSeedBountyLevelStep();
  }

  //#endregion bounty settings & constants

  //#region bounty creation

  // create a new bounty struct with all the data we need to know about the new
  // bounty.
  private latent function getNewBounty(seed: int): RER_Bounty {
    var bounty: RER_Bounty;

    bounty = RER_Bounty();
    bounty.seed = seed;
    bounty.is_active = true;
    bounty.random_data = this.generateRandomDataForBounty(seed);

    return bounty;
  }

  private latent function generateRandomDataForBounty(seed: int): RER_BountyRandomData {
    var current_group_data: RER_BountyRandomMonsterGroupData;
    var point_of_interests_positions: array<Vector>;
    var current_bestiary_entry: RER_BestiaryEntry;
    var main_bestiary_entry: RER_BestiaryEntry;
    var creature_type: CreatureType;
    var rng: RandomNumberGenerator;
    var data: RER_BountyRandomData;
    var number_of_groups: int;
    var constants: RER_ConstantCreatureTypes;
    var i: int;
    var k: int;

    constants = RER_ConstantCreatureTypes();

    // the seed 0 means the bounty will be completely random and won't use the
    // seed in the RNG
    rng = (new RandomNumberGenerator in this).setSeed(seed)
      .useSeed(seed != 0);

    data = RER_BountyRandomData();
    number_of_groups = this.getNumberOfGroupsForSeed(rng, seed);

    NLOG("generateRandomDataForBounty(), number of groups = " + number_of_groups);

    // 0.
    // prepare the data we'll need while generating stuff
    
    // get a sorted list of the different POIs in the game
    point_of_interests_positions = this.master.contract_manager.getClosestDestinationPoints(thePlayer.GetWorldPosition());

    // bounties are composed of 1 main target and multiple side targets.
    // The main target is a large monster, something supposedly hard to kill,
    // while the side targets are small creatures.
    
    // 1.
    // we start by adding the main group
    current_group_data = RER_BountyRandomMonsterGroupData();

    if (seed == 0) {
      main_bestiary_entry = this.master.bestiary.getRandomEntryFromBestiary(
        this.master,
        EncounterType_CONTRACT,
        RER_BREF_IGNORE_BIOMES | RER_BREF_IGNORE_SETTLEMENT | RER_BREF_IGNORE_BESTIARY,
        (new RER_SpawnRollerFilter in this)
          .init()
          // we multiply everyone by 100, so that 0.01 * 100 = 1
          // since the resulting creature chances are integers, 50 * 0.01 results
          // in 0 and would cause a crash. This will instead multiply everyone
          // by 100 and leave the creatures we don't want to their initial tiny
          // values.
          .multiplyEveryone(100)
          .setOffsets(
            constants.large_creature_begin,
            constants.large_creature_max,
            // creature outside the offset have 1% chance to appear
            // 1% and not 0% to avoid crashes if all creatures to be disabled
            // in the settings.
            0.01
          )
      );

      current_group_data.type = main_bestiary_entry.type;
    }
    else {
      current_group_data.type = (int)(rng.next() * (int)CreatureMAX);
      
      main_bestiary_entry = this.master.bestiary.entries[current_group_data.type];
    }

    current_group_data.count = Max(1,
        rollDifficultyFactorWithRng(
          main_bestiary_entry.template_list.difficulty_factor,
          this.master.settings.selectedDifficulty,
          this.master.settings.enemy_count_multiplier
          * main_bestiary_entry.creature_type_multiplier
          // double the amount of creatures at level 100
          * (1 + this.getDifficultyForSeed(seed) * 0.01),
          rng
        )
      );

    k = (int)rng.nextRange(point_of_interests_positions.Size(), 0);
    current_group_data.position = point_of_interests_positions[k];
    point_of_interests_positions.EraseFast(k);

    data.main_group = current_group_data;

    // 2.
    // we generate the side groups
    for (i = 0; i < number_of_groups; i += 1) {
      current_group_data = RER_BountyRandomMonsterGroupData();

      if (seed == 0) {
        creature_type = main_bestiary_entry.getRandomCompositionCreature(
          this.master,
          EncounterType_CONTRACT,
          (new RER_SpawnRollerFilter in this)
            .init()
            .multiplyEveryone(100)
            .setOffsets(
              constants.small_creature_begin_no_humans,
              constants.small_creature_max,
              // creature outside the offset have 1% chance to appear
              // 1% and not 0% to avoid crashes if all creatures to be disabled
              // in the settings.
              0.01
            )
        );

        current_bestiary_entry = this.master.bestiary.getEntry(
          this.master,
          creature_type
        );

        current_group_data.type = current_bestiary_entry.type;
      }
      else {
        current_group_data.type = (int)(rng.next() * (int)CreatureMAX);
        
        current_bestiary_entry = this.master.bestiary.entries[current_group_data.type];
      }

      current_group_data.count = Max(1,
          rollDifficultyFactorWithRng(
            current_bestiary_entry.template_list.difficulty_factor,
            this.master.settings.selectedDifficulty,
            this.master.settings.enemy_count_multiplier
            * current_bestiary_entry.creature_type_multiplier
            // double the amount of creatures at level 100
            * (1 + this.getDifficultyForSeed(seed) * 0.01),
            rng
          )
        );

      k = (int)rng.nextRange(point_of_interests_positions.Size(), 0);
      current_group_data.position = point_of_interests_positions[k];
      point_of_interests_positions.EraseFast(k);

      data.side_groups.PushBack(current_group_data);
    }

    return data;
  }
  //#endregion bounty creation


  //#region bounty workflow
  public latent function startBounty(seed: int) {
    this.master.storages.bounty.current_bounty = this.getNewBounty(seed);

    this.master
        .storages
        .bounty
        .save();

    theSound.SoundEvent("gui_ingame_quest_active");

    Sleep(0.2);
    RER_tutorialTryShowBounty();
    Sleep(0.5);

    RER_openPopup(
      "Bounty information",
      this.getInformationMessageAboutCurrentBounty()
    );

    this.displayMarkersForCurrentBounty();
  }

  public function endBounty() {
    var message: string;
    var new_level: int;
    var bonus: int;

    bonus = this.getNumberOfSideGroupsKilled();
    new_level = this.increaseBountyLevel(bonus);

    this.abandonBounty();

    message = GetLocStringByKey("rer_bounty_finished_notification");
    message = StrReplace(
      message,
      "{{side_groups_killed}}",
      RER_yellowFont(bonus)
    );
    message = StrReplace(
      message,
      "{{bounty_level}}",
      RER_yellowFont(new_level)
    );

    NDEBUG(message);

    theSound.SoundEvent("gui_inventory_buy");
  }

  public function abandonBounty() {
    this.master.storages.bounty.current_bounty.is_active = false;
    this.master.storages.bounty.save();

    this.displayMarkersForCurrentBounty();
  }

  public function displayMarkersForCurrentBounty() {
    var map_pin: SU_MapPin;
    var i: int;

    SU_removeCustomPinByTag("RER_bounty_target");

    if (!isBountyActive()) {
      return;
    }

    if (!theGame.GetInGameConfigWrapper()
        .GetVarValue('RERoptionalFeatures', 'RERmarkersBountyHunting')) {
      return;
    }

    map_pin = new SU_MapPin in this;
    map_pin.tag = "RER_bounty_target";
    map_pin.position = this.master.storages.bounty.current_bounty.random_data.main_group.position;
    map_pin.description = StrReplace(
      GetLocStringByKey("rer_mappin_bounty_main_target_description"),
      "{{creature_type}}",
      getCreatureNameFromCreatureType(
        this.master.bestiary,
        this.master
          .storages
          .bounty
          .current_bounty
          .random_data
          .main_group
          .type
      )
    );
    map_pin.label = GetLocStringByKey("rer_mappin_bounty_main_target_title");
    map_pin.type = "MonsterQuest";
    map_pin.radius = 100;
    map_pin.region = AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea());
    map_pin.appears_on_minimap = theGame.GetInGameConfigWrapper()
      .GetVarValue('RERoptionalFeatures', 'RERminimapMarkerBounties');

    thePlayer.addCustomPin(map_pin);

    for (i = 0; i < this.master.storages.bounty.current_bounty.random_data.side_groups.Size(); i += 1) {
      if (this.master.storages.bounty.current_bounty.random_data.side_groups[i].was_killed) {
        continue;
      }

      map_pin = new SU_MapPin in this;
      map_pin.tag = "RER_bounty_target";
      map_pin.position = this.master.storages.bounty.current_bounty.random_data.side_groups[i].position;
      map_pin.description = StrReplace(
        GetLocStringByKey("rer_mappin_bounty_side_target_description"),
        "{{creature_type}}",
        getCreatureNameFromCreatureType(
          this.master.bestiary,
          this.master
            .storages
            .bounty
            .current_bounty
            .random_data
            .side_groups[i]
            .type
        )
      );
      map_pin.label = GetLocStringByKey("rer_mappin_bounty_side_target_title");
      map_pin.type = "MonsterQuest";
      map_pin.radius = 50;
      map_pin.region = AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea());
      map_pin.appears_on_minimap = theGame.GetInGameConfigWrapper()
        .GetVarValue('RERoptionalFeatures', 'RERminimapMarkerBounties');

      thePlayer.addCustomPin(map_pin);
    }

    SU_updateMinimapPins();
  }

  public function isBountyActive(): bool {
    return this.master.storages.bounty.current_bounty.is_active;
  }

  public function isMainGroupDead(): bool {
    if (!this.isBountyActive()) {
      NDEBUG("RER warning: isMainGroupDead() was called but no active bounty was found.");
      
      return false;
    }

    return this.master.storages.bounty.current_bounty.random_data.main_group.was_killed;
  }

  public function getNumberOfSideGroupsKilled(): int {
    var count: int;
    var i: int;

    if (!this.isBountyActive()) {
      NDEBUG("RER warning: getNumberOfSideGroupsKilled() was called but no active bounty was found.");

      return 0;
    }

    count = 0;

    for (i = 0; i < this.master.storages.bounty.current_bounty.random_data.side_groups.Size(); i += 1) {
      count += (int)this.master.storages.bounty.current_bounty.random_data.side_groups[i].was_killed;
    }

    return count;
  }

  public function notifyMainGroupKilled() {
    if (!this.isBountyActive()) {
      NDEBUG("RER warning: notifyMainGroupKilled() was called but no active bounty was found.");
    }

    this.endBounty();
  }

  public function notifySideGroupKilled(index: int) {
    if (!this.isBountyActive()) {
      NDEBUG("RER warning: notifySideGroupKilled(" + index + ") was called but no active bounty was found.");

      return;
    }

    if (index >= this.master.storages.bounty.current_bounty.random_data.side_groups.Size()) {
      NDEBUG(
        "RER warning: out of bound index, notifySideGroupKilled("
        + index
        + ") but there are only "
        + this.master.storages.bounty.current_bounty.random_data.side_groups.Size()
        + " side groups"
      );


      return;
    }

    this.master.storages.bounty.current_bounty.random_data.side_groups[index].was_killed = true;
    this.master.storages.bounty.save();

    this.displayMarkersForCurrentBounty();

    thePlayer.DisplayHudMessage(GetLocStringByKeyExt("rer_bounty_side_target_killed"));
  }

  public function getInformationMessageAboutCurrentBounty(): string {
    var group: RER_BountyRandomMonsterGroupData;
    var segment: string;
    var message: string;
    var i: int;

    if (!this.isBountyActive()) {
      NDEBUG("RER warning: getInformationMessageAboutCurrentBounty() was called but no active bounty was found");

      return "";
    }

    message = GetLocStringByKey("rer_bounty_start_popup");

    // 1.
    // first the main target
    message = StrReplace(
      message,
      "{{main_creature_listing}}",
      " - " + getCreatureNameFromCreatureType(
        this.master.bestiary,
        this.master.storages.bounty.current_bounty.random_data.main_group.type
      )
    );

    // 2
    // then the side targets
    for (i = 0; i < this.master.storages.bounty.current_bounty.random_data.side_groups.Size(); i += 1) {
      group = this.master.storages.bounty.current_bounty.random_data.side_groups[i];

      segment += " - " + getCreatureNameFromCreatureType(this.master.bestiary, group.type) + "<br />";
    }

    message = StrReplace(
      message,
      "{{side_creature_listing}}",
      segment
    );

    return message;
  }

  //#endregion bounty workflow

  // return the maximum progress the bounty will have for this seed. Each progress
  // level is a group of creatures.
  public function getNumberOfGroupsForSeed(rng: RandomNumberGenerator, seed: int): int {
    var min: int;
    var max: int;

    min = 1;
    // for every 10 levels bounties have a chance to get 1 more group
    max = 2 + (int)(this.getDifficultyForSeed(seed) * 0.1) + min;

    NLOG("getNumberOfGroupsForSeed(" + seed + ") - " + RandNoiseF(seed, max, min) + " " + max);

    // a difficulty 0 seed has maximum 5 monster groups in it
    // the difficulty seed step divided by 100 means that a difficulty 100 seed
    // will double the amount of creatures.
    return (int)rng.nextRange(max, min);
  }

  public function increaseBountyLevel(optional multiplier: int): int {
    var i: int;

    multiplier = Max(1, multiplier);

    this.master
      .storages
      .bounty
      .bounty_level += multiplier;

    this.master
      .storages
      .bounty
      .save();

    for (i = this.master.storages.bounty.bounty_level - multiplier; i < this.master.storages.bounty.bounty_level; i += 1) {
      this.giveBountyLevelupItemToPlayer(i);
    }

    return this.master
      .storages
      .bounty
      .bounty_level;
  }

  public function giveBountyLevelupItemToPlayer(bounty_level: int) {
    var possible_items: array<name>;
    var index: int;

    possible_items.PushBack('Dwimeryte ingot');
    possible_items.PushBack('Meteorite ingot');
    possible_items.PushBack('Silver ingot');
    possible_items.PushBack('Steel ingot');
    possible_items.PushBack('Orichalcum ingot');
    possible_items.PushBack('Dwimeryte enriched ingot');
    possible_items.PushBack('Iron ingot');
    possible_items.PushBack('Glowing ingot');
    possible_items.PushBack('Copper ingot');
    possible_items.PushBack('Green gold ingot');
    possible_items.PushBack('Dark iron ingot');
    possible_items.PushBack('Meteorite silver ingot');
    possible_items.PushBack('Dark steel ingot');

    index = RandRange(possible_items.Size());

    thePlayer.inv.AddAnItem(possible_items[index], 2 + (int)(bounty_level / 50));
  }
}

state Processing in RER_BountyManager {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    NLOG("RER_BountyManager - Processing");

    this.Processing_main();
  }

  entry function Processing_main() {
    // we also call it instantly to handle cases where the player teleported near
    // a group that was picked but not spawned yet
    parent.displayMarkersForCurrentBounty();

    while (true) {
      // no active bounty, do nothing
      if (!parent.isBountyActive()) {
        Sleep(20);

        continue;
      }

      this.spawnNearbyBountyGroups();

      Sleep(10);
    }
  }

  latent function spawnNearbyBountyGroups() {
    var groups: array<RER_BountyRandomMonsterGroupData>;
    var player_position: Vector;
    var i: int;

    if (!parent.isBountyActive()) {
      NDEBUG("RER warning: spawnNearbyBountyGroups() was called but no active bounty was found");

      return;
    }

    player_position = thePlayer.GetWorldPosition();

    // 1.
    // we start by checking for the main group
    this.trySpawnBountyGroup(
      parent.master.storages.bounty.current_bounty.random_data.main_group,
      100,
      player_position,
      -1 // -1 is a special case to identify the main group
    );


    groups = parent.master.storages.bounty.current_bounty.random_data.side_groups;

    for (i = 0; i < groups.Size(); i += 1) {
      if (groups[i].was_killed) {
        continue;
      }

      NLOG("spawnNearbyBountyGroups(), side group " + i);

      // here, we know the group we currently have was not killed
      this.trySpawnBountyGroup(
        groups[i],
        50,
        player_position,
        i
      );
    }
  }

  latent function trySpawnBountyGroup(group: RER_BountyRandomMonsterGroupData, radius: float, player_position: Vector, index: int) {
    var distance_from_player: float;
    var max_distance: float;
    var position: Vector;

    max_distance = radius * radius;
    position = group.position;
    position.Z = player_position.Z;

    distance_from_player = VecDistanceSquared2D(
      player_position,
      position
    );

    NLOG("trySpawnBountyGroup(), distance from player = " + distance_from_player);

    if (distance_from_player > max_distance) {
      return;
    }

    if (this.areThereBountyCreaturesNearby(player_position)) {
      return;
    }

    this.spawnBountyGroup(group, index);

    if (!parent.master.hasJustBooted()) {
      theGame.SaveGame( SGT_QuickSave, -1 );
    }

    theSound.SoundEvent("gui_ingame_new_journal");
  }

  public latent function spawnBountyGroup(group_data: RER_BountyRandomMonsterGroupData, group_index: int): RandomEncountersReworkedHuntingGroundEntity {
    var rer_entity: RandomEncountersReworkedHuntingGroundEntity;
    var current_group: RER_BountyRandomMonsterGroupData;
    var side_bestiary_entry: RER_BestiaryEntry;
    var damage_modifier: SU_BaseDamageModifier;
    var rer_entity_template: CEntityTemplate;
    var bestiary_entry: RER_BestiaryEntry;
    var side_entities: array<CEntity>;
    var entities: array<CEntity>;
    var player_position: Vector;
    var position: Vector;
    var i: int;

    NLOG("spawnBountyGroup()" + group_index);

    bestiary_entry = parent.master.bestiary.entries[group_data.type];

    // to get it closer to the real ground position. It works because bounty
    // groups are spawned only when the player gets close.
    position = group_data.position;

    if (position.Z == 0) {
      player_position = thePlayer.GetWorldPosition();
      position.Z = player_position.Z;
    }

    if (!getGroundPosition(position, 2, 50) || position.Z <= 0) {
      FixZAxis(position);

      NLOG("spawnBountyGroup, could not find a safe ground position. Defaulting to marker position");
    }

    damage_modifier = new SU_BaseDamageModifier in parent;
    damage_modifier.damage_received_modifier = 0.7;
    damage_modifier.damage_dealt_modifier = 1.05;

    entities = bestiary_entry.spawn(
      parent.master,
      position,
      group_data.count,
      , // density
      EncounterType_CONTRACT,
      RER_BESF_NO_BESTIARY_FEATURE | RER_BESF_NO_PERSIST,
      'RandomEncountersReworked_BountyCreature',,
      damage_modifier
    );

    // group index -1 is a way to identify the main group
    // in that case we add 1 of each side group killed into the main group
    if (group_index < 0) {
      for (i = 0; i < parent.master.storages.bounty.current_bounty.random_data.side_groups.Size(); i += 1) {
        current_group = parent.master.storages.bounty.current_bounty.random_data.side_groups[i];

        if (!current_group.was_killed) {
          continue;
        }

        side_bestiary_entry = parent.master
          .bestiary
          .getEntry(parent.master, current_group.type);

        side_entities = side_bestiary_entry.spawn(
          parent.master,
          position,
          1, // only 1 creature
          , // density
          EncounterType_CONTRACT,
          RER_BESF_NO_BESTIARY_FEATURE | RER_BESF_NO_PERSIST,
          'RandomEncountersReworked_BountyCreature',,
          damage_modifier
        );

        if (side_entities.Size() > 0) {
          entities.PushBack(side_entities[0]);
        }
      }
    }

    NLOG("bounty group " + group_index + " spawned " + entities.Size() + " entities at " + VecToString(position));

    rer_entity_template = (CEntityTemplate)LoadResourceAsync(
      "dlc\modtemplates\randomencounterreworkeddlc\data\rer_hunting_ground_entity.w2ent",
      true
    );

    rer_entity = (RandomEncountersReworkedHuntingGroundEntity)theGame.CreateEntity(rer_entity_template, position, thePlayer.GetWorldRotation());
    rer_entity.activateBountyMode(parent, group_index);
    rer_entity.startEncounter(parent.master, entities, bestiary_entry);

    for (i = 0; i < entities.Size(); i += 1) {
      if (!entities[i].HasTag('RER_BountyEntity')) {
        entities[i].AddTag('RER_BountyEntity');
      }
    }

    parent.master
        .storages
        .bounty
        .save();

    theSound.SoundEvent("gui_journal_track_quest");

    return rer_entity;
  }

  function areThereBountyCreaturesNearby(player_position: Vector): bool {
    var entities: array<CEntity>;
    var distance: float;
    var i: int;

    theGame.GetEntitiesByTag('RER_BountyEntity', entities);

    for (i = 0; i < entities.Size(); i += 1) {
      distance = VecDistanceSquared2D(
        entities[i].GetWorldPosition(),
        player_position
      );

      if (distance <= 200 * 200) {
        return true;
      }
    }

    return false;
  }
}