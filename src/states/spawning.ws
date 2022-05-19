
state Spawning in CRandomEncounters {
  private var is_spawn_forced: bool;

  event OnEnterState(previous_state_name: name) {
    parent.RemoveTimer('randomEncounterTick');

    super.OnEnterState(previous_state_name);

    // Set is_spawn_forced if the previous state was SpawningForced
    this.is_spawn_forced = previous_state_name == 'SpawningForced';


    LogChannel('modRandomEncounters', "Entering state SPAWNING");

    triggerCreaturesSpawn();
  }

  entry function triggerCreaturesSpawn() {
    var picked_encounter_type: EncounterType;

    LogChannel('modRandomEncounters', "creatures spawning triggered");

    picked_encounter_type = this.getRandomEncounterType();
    
    // we start by checking if the creature spawn should be cancelled.
    if (
       // first if RER is disabled, any spawn should be cancelled
       !parent.settings.is_enabled

       // or if there is not enough mod power to enable the system
    || !RER_modPowerIsEncounterSystemEnabled()

       // then, if the spawn is not forced we check if the player
       // is in a place where a spawn in accepted.
    || !this.is_spawn_forced
    && shouldAbortCreatureSpawn(parent.settings, parent.rExtra, parent.bestiary)) {
      parent.GotoState('SpawningCancelled');

      return;
    }

    LogChannel('modRandomEncounters', "picked encounter type: " + picked_encounter_type);

    makeGroupComposition(
      picked_encounter_type,
      parent
    );

    parent.static_encounter_manager.startSpawning();

    parent.GotoState('Waiting');
  }

  function getRandomEncounterType(): EncounterType {
    var monster_ambush_chance: int;
    var monster_hunt_chance: int;
    var monster_contract_chance: int;
    var monster_hunting_ground_chance: int;

    var max_roll: int;
    var roll: int;

    if (theGame.envMgr.IsNight()) {
      monster_ambush_chance = parent.settings.all_monster_ambush_chance_night;
      monster_hunt_chance = parent.settings.all_monster_hunt_chance_night;
      monster_hunting_ground_chance = parent.settings.all_monster_hunting_ground_chance_night;
    } else {
      monster_ambush_chance = parent.settings.all_monster_ambush_chance_day;
      monster_hunt_chance = parent.settings.all_monster_hunt_chance_day;
      monster_hunting_ground_chance = parent.settings.all_monster_hunting_ground_chance_day;
    }

    max_roll = monster_hunt_chance
             + monster_ambush_chance
             + monster_hunting_ground_chance;

    roll = RandRange(max_roll);
    if (roll < monster_hunt_chance) {
      return EncounterType_HUNT;
    }

    roll -= monster_hunt_chance;
    if (roll < monster_hunting_ground_chance) {
      return EncounterType_HUNTINGGROUND;
    }

    return EncounterType_DEFAULT;
  }
}
