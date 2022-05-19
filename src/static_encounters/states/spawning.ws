
state Spawning in RER_StaticEncounterManager {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    NLOG("RER_StaticEncounterManager - state Spawning");

    this.Spawning_main();
  }

  entry function Spawning_main() {
    this.spawnStaticEncounters(parent.master);
    parent.GotoState('Waiting');
  }

  public latent function spawnStaticEncounters(master: CRandomEncounters) {
    var player_position: Vector;
    var current_region: string;
    var max_distance: float;
    var large_chance: float;
    var small_chance: float;
    var has_spawned: bool;
    var i: int;

    if (isPlayerBusy()) {
      return;
    }

    current_region = AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea());

    max_distance = StringToFloat(theGame.GetInGameConfigWrapper().GetVarValue('RERencountersGeneral', 'minSpawnDistance'))
                 + StringToFloat(theGame.GetInGameConfigWrapper().GetVarValue('RERencountersGeneral', 'spawnDiameter'));

    small_chance = StringToFloat(theGame.GetInGameConfigWrapper().GetVarValue('RERencountersGeneral', 'RERstaticEncounterSmallSpawnChance'));
    large_chance = StringToFloat(theGame.GetInGameConfigWrapper().GetVarValue('RERencountersGeneral', 'RERstaticEncounterLargeSpawnChance'));

    player_position = thePlayer.GetWorldPosition();

    for (i = 0; i < parent.static_encounters.Size(); i += 1) {
      has_spawned = this.trySpawnStaticEncounter(
        master,
        parent.static_encounters[i],
        player_position,
        max_distance,
        small_chance,
        large_chance,
        current_region
      );

      SleepOneFrame();
    }

    // every time the spawning triggers, we loop over the nearby POIs and we spawn
    // any new placeholder static encounter. They are then added to the persistent
    // storage and finally they are manually triggered
    this.spawnPlaceholderStaticEncounters(
      master,
      player_position,
      max_distance,
      small_chance,
      large_chance,
      current_region
    );
  }

  private latent function trySpawnStaticEncounter(master: CRandomEncounters, encounter: RER_StaticEncounter, player_position: Vector, max_distance: float, small_chance: float, large_chance: float, current_region: string): bool {
    var composition: CreatureHuntingGroundComposition;

    if (!encounter.canSpawn(player_position, small_chance, large_chance, max_distance, current_region)) {
      return false;
    }

    composition = new CreatureHuntingGroundComposition in master;

    composition.init(master.settings);
    composition.setBestiaryEntry(encounter.getBestiaryEntry(master))
      .setSpawnPosition(encounter.getSpawningPosition())
      .spawn(master);

    return true;
  }

  private latent function spawnPlaceholderStaticEncounters(master: CRandomEncounters, player_position: Vector, max_distance: float, small_chance: float, large_chance: float, current_region: string) {
    var placeholder_static_encounter: RER_PlaceholderStaticEncounter;
    var rng: RandomNumberGenerator;
    var positions: array<Vector>;
    var current_position: Vector;
    var can_spawn: bool;
    var i: int;

    positions = this.getNearbyPointOfInterests(player_position, max_distance);
    rng = new RandomNumberGenerator in this;

    NLOG("spawnPlaceholderStaticEncounters(), found " + positions.Size() + " available point of interests for placeholder static encounters");

    for (i = 0; i < positions.Size(); i += 1) {
      SleepOneFrame();

      current_position = positions[i];

      can_spawn = RER_placeholderStaticEncounterCanSpawnAtPosition(
        current_position,
        rng,
        master.storages.general.playthrough_seed
      );

      if (!can_spawn) {
        continue;
      }

      NLOG("spawnPlaceholderStaticEncounters(), placeholder static encounter can spawn at " + VecToString(current_position));

      placeholder_static_encounter = parent.getOrStorePlaceholderStaticEncounterForPosition(current_position);

      this.trySpawnStaticEncounter(
        master,
        placeholder_static_encounter,
        player_position,
        max_distance,
        small_chance,
        large_chance,
        current_region
      );
    }

    // we now save the storage where placeholders are stored since they may
    // have copied a creature from their surrounding
    parent.master.storages.general.save();
  }

  private function getNearbyPointOfInterests(player_position: Vector, max_distance: float): array<Vector> {
    var point_of_interests: array<SEntityMapPinInfo>;
    var entities: array<CGameplayEntity>;
    var current_position: Vector;
    var current_distance: float;
    var output: array<Vector>;
    var i: int;

    // We also fetch entities with a custom tag to support
    // custom point of interests. This can prove useful in
    // new maps from mods that may want to add support for RER
    // placeholders
    FindGameplayEntitiesInRange(
      entities,
      thePlayer,
      max_distance, // range
      500, // maxresults
      'RER_contractPointOfInterest', // tag
    );

    for (i = 0; i < entities.Size(); i += 1) {
      output.PushBack(entities[i].GetWorldPosition());
    }

    point_of_interests = getPointOfInterests();

    for (i = 0; i < point_of_interests.Size(); i += 1) {
      current_position = point_of_interests[i].entityPosition;
      current_distance = VecDistanceSquared2D(player_position, current_position);

      if (current_distance > max_distance) {
        continue;
      }

      output.PushBack(current_position);
    }

    return output;
  }

  private function getPointOfInterests(): array<SEntityMapPinInfo> {
    var output: array<SEntityMapPinInfo>;
    var all_pins: array<SEntityMapPinInfo>;
    var i: int;

    all_pins = theGame.GetCommonMapManager().GetEntityMapPins(theGame.GetWorld().GetDepotPath());

    for (i = 0; i < all_pins.Size(); i += 1) {
      if (all_pins[i].entityType == 'MonsterNest'
       || all_pins[i].entityType == 'InfestedVineyard'
      //  || all_pins[i].entityType == 'PlaceOfPower'
       || all_pins[i].entityType == 'BanditCamp'
       || all_pins[i].entityType == 'BanditCampfire'
       || all_pins[i].entityType == 'BossAndTreasure'
       || all_pins[i].entityType == 'RescuingTown'
       || all_pins[i].entityType == 'DungeonCrawl'
       || all_pins[i].entityType == 'Hideout'
       || all_pins[i].entityType == 'Plegmund'
       || all_pins[i].entityType == 'KnightErrant'
       || all_pins[i].entityType == 'WineContract'
       || all_pins[i].entityType == 'SignalingStake'
       || all_pins[i].entityType == 'MonsterNest'
       || all_pins[i].entityType == 'TreasureHuntMappin'
       || all_pins[i].entityType == 'PointOfInterestMappin'
        // the same pins but with Disabled at the end
       || all_pins[i].entityType == 'MonsterNestDisabled'
       || all_pins[i].entityType == 'InfestedVineyardDisabled'
      //  || all_pins[i].entityType == 'PlaceOfPowerDisabled'
       || all_pins[i].entityType == 'BanditCampDisabled'
       || all_pins[i].entityType == 'BanditCampfireDisabled'
       || all_pins[i].entityType == 'BossAndTreasureDisabled'
       || all_pins[i].entityType == 'RescuingTownDisabled'
       || all_pins[i].entityType == 'DungeonCrawlDisabled'
       || all_pins[i].entityType == 'HideoutDisabled'
       || all_pins[i].entityType == 'PlegmundDisabled'
       || all_pins[i].entityType == 'KnightErrantDisabled'
       || all_pins[i].entityType == 'WineContractDisabled'
       || all_pins[i].entityType == 'SignalingStakeDisabled'
       || all_pins[i].entityType == 'MonsterNestDisabled'
       || all_pins[i].entityType == 'TreasureHuntMappinDisabled'
       || all_pins[i].entityType == 'PointOfInterestMappinDisabled'
       || all_pins[i].entityType == 'PointOfInterestMappinDisabled') {
        output.PushBack(all_pins[i]);
      }
    }

    return output;
  }
}
