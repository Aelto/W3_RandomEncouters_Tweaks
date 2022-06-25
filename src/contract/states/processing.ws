
state Processing in RER_ContractManager {
  var is_spawned: bool;

  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    NLOG("RER_ContractManager - Processing");

    this.Processing_main();
  }

  entry function Processing_main() {
    this.waitForPlayerToReachDestination();
    this.waitForPlayerToFinishContract();
    parent.completeCurrentContract();
    parent.GotoState('Waiting');
  }

  latent function waitForPlayerToReachDestination() {
    var active_contract: RER_ContractRepresentation;
    var has_added_pins: bool;
    var map_pin: SU_MapPin;

    if (!parent.master.storages.contract.has_ongoing_contract) {
      parent.GotoState('Waiting');
      
      return;
    }

    RER_tutorialTryShowNoticeboard();

    active_contract = parent.master.storages.contract.active_contract;

    SU_removeCustomPinByTag("RER_contract_target");

    map_pin = new SU_MapPin in parent;
    map_pin.tag = "RER_contract_target";
    map_pin.position = active_contract.destination_point;
    map_pin.description = GetLocStringByKey("rer_mappin_regular_description");
    map_pin.label = GetLocStringByKey("rer_mappin_regular_title");
    map_pin.type = "MonsterQuest";
    map_pin.radius = active_contract.destination_radius;
    map_pin.region = AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea());
    map_pin.appears_on_minimap = theGame.GetInGameConfigWrapper()
      .GetVarValue('RERoptionalFeatures', 'RERminimapMarkerBounties');

    thePlayer.addCustomPin(map_pin);

    SU_updateMinimapPins();
    theSound.SoundEvent("gui_hubmap_mark_pin");


    while (true) {
      if (!parent.master.storages.contract.has_ongoing_contract) {
        parent.GotoState('Waiting');
        
        return;
      }

      active_contract = parent.master.storages.contract.active_contract;

      // this part is pretty much useless since the storage is unique per region
      // meaning you get only the contract for the current region.
      if (!SUH_isPlayerInRegion(active_contract.region_name)) {
        parent.GotoState('Waiting');
      }

      if (VecDistanceSquared2D(active_contract.destination_point, thePlayer.GetWorldPosition()) <= active_contract.destination_radius * active_contract.destination_radius) {
        break;
      }

      Sleep(10);
    }

    if (!parent.master.hasJustBooted()) {
      theGame.SaveGame( SGT_QuickSave, -1 );
    }

    theSound.SoundEvent("gui_ingame_new_journal");
  }

  latent function waitForPlayerToFinishContract() {
    var active_contract: RER_ContractRepresentation;
    if (!parent.master.storages.contract.has_ongoing_contract) {
      return;
    }

    active_contract = parent.master.storages.contract.active_contract;


    // if (active_contract.event_type == ContractEventType_NEST) {
    //  this.createNestEncounterAndWaitForEnd(active_contract);
    // }
    // else if (active_contract.event_type == ContractEventType_HORDE) {
    //   this.sendHordeRequestAndWaitForEnd(active_contract);
    // }
    // else if (active_contract.event_type == ContractEventType_BOSS) {
    this.createHuntingGroundAndWaitForEnd(active_contract);
    // }
  }

  latent function createHuntingGroundAndWaitForEnd(active_contract: RER_ContractRepresentation) {
    var rer_entity: RandomEncountersReworkedHuntingGroundEntity;
    var damage_modifier: SU_BaseDamageModifier;
    var rer_entity_template: CEntityTemplate;
    var composition_entities: array<CEntity>;
    var composition_entry: RER_BestiaryEntry;
    var bestiary_entry: RER_BestiaryEntry;
    var composition_type: CreatureType;
    var rng: RandomNumberGenerator;
    var entities: array<CEntity>;
    var buff_multiplier: float;
    var impact_points: float;
    var position: Vector;
    var enemy_count: int;
    var npc: CNewNPC;
    var sign: int;
    var i: int;
    
    bestiary_entry = parent.master.bestiary.getEntry(parent.master, active_contract.creature_type);
    rng = (new RandomNumberGenerator in this).setSeed(active_contract.rng_seed)
      .useSeed(true);

    for (i = 0; i < 15; i += 1) {
      rng.next();
      position = active_contract.destination_point
        + VecRingRandStatic((int)rng.previous_number, 5, active_contract.destination_radius * 0.5 + 5);

      // try to see if the position is valid. If it returns true then it means
      // it found a valid position.
      if (getGroundPosition(position, 1, 10)) {
        i = -1;

        break;
      }
    }

    // since i is set to -1 when a position is found, this means no position was
    // found.    
    if (i >= 0) {
      // spawn the monster on the player directly as a last resort.
      position = thePlayer.GetWorldPosition();
      getGroundPosition(position, 1, 20);
    }

    impact_points = parent.getImpactPointsForDifficulty(active_contract.difficulty_level);
    impact_points = rng.nextRange(
      impact_points + 2,
      impact_points - 2
    );

    entities = bestiary_entry.spawn(
      parent.master,
      position,
      bestiary_entry.template_list.difficulty_factor.maximum_count_medium, //count
      , // density
      EncounterType_CONTRACT,
      RER_BESF_NO_BESTIARY_FEATURE | RER_BESF_NO_PERSIST,
      'RandomEncountersReworked_ContractCreature',
      // a high number to make sure there is no composition as we'll spawn them
      // manually.
      10000
    );

    enemy_count = entities.Size();
    impact_points -= bestiary_entry.ecosystem_delay_multiplier * enemy_count;

    if (impact_points > 0) {
      buff_multiplier = 1.01;
      sign = -1;
    }
    else {
      buff_multiplier = 0.99;
      sign = 1;
    }

    impact_points = RoundF(impact_points);
    if (impact_points != 0) {
      damage_modifier = new SU_BaseDamageModifier in parent;
      damage_modifier.damage_received_modifier = 1;
      damage_modifier.damage_dealt_modifier = 1;

      while (impact_points != 0) {
        // the higher the amount of enemies, the higher the chances of them
        // getting a damage boost. Smaller enemies often deal less damages,
        // so it is perfectly safe to give them more damage boosts than large
        // monsters who already inflict big hits.
        if (rng.next() < 0.2 + (enemy_count * 0.1)) {
          damage_modifier.damage_dealt_modifier *= PowF(buff_multiplier, 1);
        }
        else {
          // so here we add 10% more damage received, but below...
          damage_modifier.damage_received_modifier *= PowF(2 - buff_multiplier, 10);
        }

        NLOG("impact_points = " + impact_points + " damage_received_modifier = " + damage_modifier.damage_received_modifier + ", damage_dealt_modifier = " + damage_modifier.damage_dealt_modifier);

        impact_points = RoundF(impact_points + sign);
      }

      for (i = 0; i < entities.Size(); i += 1) {
        npc = (CNewNPC)entities[i];

        npc.sharedutils_damage_modifiers.PushBack(damage_modifier);
      }
    }


    rer_entity_template = (CEntityTemplate)LoadResourceAsync(
      "dlc\modtemplates\randomencounterreworkeddlc\data\rer_hunting_ground_entity.w2ent",
      true
    );

    rer_entity = (RandomEncountersReworkedHuntingGroundEntity)theGame.CreateEntity(rer_entity_template, position, thePlayer.GetWorldRotation());
    rer_entity.manual_destruction = true;
    rer_entity.startEncounter(parent.master, entities, bestiary_entry);

		thePlayer.DisplayHudMessage(
      StrReplace(
        GetLocStringByKeyExt("rer_kill_target"),
        "{{type}}",
        getCreatureNameFromCreatureType(parent.master.bestiary, active_contract.creature_type)
      )
    );

    while (rer_entity.GetCurrentStateName() != 'Ending') {
      Sleep(1);
    }

    rer_entity.clean();
  }

  latent function createNestEncounterAndWaitForEnd(active_contract: RER_ContractRepresentation) {
    var current_template: CEntityTemplate;
    var nests: array<RER_MonsterNest>;
    var are_all_nests_destroyed: bool;
    var rng: RandomNumberGenerator;
    var nest: RER_MonsterNest;
    var position: Vector;
    var path: string;
    var i: int;
    var k: int;

    rng = (new RandomNumberGenerator in this).setSeed(active_contract.rng_seed)
      .useSeed(true);

    path = "dlc\modtemplates\randomencounterreworkeddlc\data\rer_monster_nest.w2ent";

    if (!RER_isCreatureTypeAllowedForNest(active_contract.creature_type)) {
      // the monster doesn't fit a nest, in that case we spawn a boss fight
      // instead.
      this.createHuntingGroundAndWaitForEnd(active_contract);

      return;
    }

    // amount of nests:
    i = RoundF(rng.nextRange(1 + active_contract.difficulty_level.value / 20, 1));

    while (i > 0) {
      i -= 1;

      for (k = 0; k < 15; k += 1) {
        rng.next();
        position = active_contract.destination_point
          + VecRingRandStatic((int)rng.previous_number, 5, active_contract.destination_radius);

        FixZAxis(position);

        // try to see if the position is valid. If it returns true then it means
        // it found a valid position.
        if (getGroundPosition(position, 2, 10)) {
          k = -1;

          break;
        }
      }

      // since i is set to -1 when a position is found, this means no position was
      // found.    
      // if (k >= 0) {
      //   // spawn the monster on the player directly as a last resort.
      //   position = thePlayer.GetWorldPosition();
      //   getGroundPosition(position, 1, 20);
      // }

      current_template = (CEntityTemplate)LoadResourceAsync(path, true);
      nest = (RER_MonsterNest)theGame.CreateEntity(
        current_template,
        position,
        thePlayer.GetWorldRotation(),,,,
        PM_DontPersist
      );

      nest.bestiary_entry = parent.master.bestiary.entries[active_contract.creature_type];
      nest.forced_bestiary_entry = true;
      nest.startEncounter(parent.master);

      nests.PushBack(nest);
    }

    if (nests.Size() <= 1) {
      thePlayer.DisplayHudMessage(
        StrReplace(
          GetLocStringByKeyExt("rer_find_nest"),
          "{{type}}",
          getCreatureNameFromCreatureType(parent.master.bestiary, active_contract.creature_type)
        )
      );
    }
    else {
      thePlayer.DisplayHudMessage(
        StrReplace(
          GetLocStringByKeyExt("rer_find_nests"),
          "{{type}}",
          getCreatureNameFromCreatureType(parent.master.bestiary, active_contract.creature_type)
        )
      );
    }

    do {
      are_all_nests_destroyed = true;

      for (i = 0; i < nests.Size(); i += 1) {
        are_all_nests_destroyed = are_all_nests_destroyed && nests[i].HasTag('WasDestroyed');
      }

      Sleep(1);
    } while (!are_all_nests_destroyed);
  }

  latent function sendHordeRequestAndWaitForEnd(active_contract: RER_ContractRepresentation) {
    var request: RER_HordeRequest;
    var bestiary_entry: RER_BestiaryEntry;
    var rng: RandomNumberGenerator;
    var enemy_count: int;

    bestiary_entry = parent.master.bestiary.getEntry(parent.master, active_contract.creature_type);
    rng = (new RandomNumberGenerator in this).setSeed(active_contract.rng_seed)
      .useSeed(true);

    enemy_count = bestiary_entry.template_list.difficulty_factor.maximum_count_medium;

    if (enemy_count < 3) {
      // the amount of enemies would be too low for it to be a good horde, in
      // that case we spawn a bossfight instead
      this.createHuntingGroundAndWaitForEnd(active_contract);

      return;
    }

    request = new RER_HordeRequest in parent;
    request.init();
    request.setCreatureCounter(
      active_contract.creature_type,
      enemy_count
    );
    request.spawning_flags = RER_flag(RER_BESF_NO_ECOSYSTEM_EFFECT, true)
                           | RER_flag(RER_BESF_NO_PERSIST, true)
                           | RER_flag(RER_BESF_NO_BESTIARY_FEATURE, true);

    parent.master.horde_manager.sendRequest(request);

    // the statemachine may not enter the processing state right away,
    // in this case we wait for it to leave the waiting state.
    while (parent.master.horde_manager.GetCurrentStateName() == 'Waiting') {
      Sleep(1);
    }

    thePlayer.DisplayHudMessage(
      StrReplace(
        GetLocStringByKeyExt("rer_survive_horde"),
        "{{type}}",
        getCreatureNameFromCreatureType(parent.master.bestiary, active_contract.creature_type)
      )
    );

    while (parent.master.horde_manager.GetCurrentStateName() == 'Processing') {
      Sleep(1);
    }
  }
}