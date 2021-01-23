
// It's an event that detects creatures killed by the player and that notifies
// the ecosystem manager about it.
class RER_ListenerEcosystemKills extends RER_EventsListener {
  var time_before_next_checkup: float;
  default time_before_next_checkup = 0;

  var was_player_in_combat: bool;

  var last_checkup: array<CreatureType>;

  public latent function loadSettings() {
    this.active = true;
  }

  public latent function onInterval(was_spawn_already_triggered: bool, master: CRandomEncounters, delta: float, chance_scale: float): bool {
    var is_player_in_combat: bool;
    var new_checkup: array<CreatureType>;
    var checkup_difference: array<CreatureType>;

    // to save performances we do a ckeckup only every few seconds and if the time
    // is still greater than 0 than no need to go further.
    if (this.time_before_next_checkup > 0) {
      time_before_next_checkup -= delta;

      return false;
    }

    is_player_in_combat = thePlayer.IsInCombat();

    // the player was not in combat before and is still not in combat, we leave.
    if (!is_player_in_combat && !this.was_player_in_combat) {
      return false;
    }

    // now it means the player is in combat and there is no ICD so do we a checkup
    if (is_player_in_combat) {
      this.last_checkup = this.getCreatureTypesAroundPlayer(master);

      // do not checkup more than once every 5 seconds.
      this.time_before_next_checkup += 5;
    }
    // because of the check about we know that if the player is not in combat now
    // it means he was in combat before, so it's time to notify about the creatures
    // he killed by doing a new checkup, comparing the old checkup with the new
    // and by excluding all alive creatures. Which gives us all creatures who were
    // there before and are not anymore and that we couldn't find alive.
    //
    // This method has a flaw, if the player runs away from a creature. So far away
    // that the checkup doesn't find the creature it will consider it dead.
    // But i don't think it matters, i don't think players often flee or atleast
    // not frequently enough to break the system. And increasing the range could
    // severely impact performances so i still want to keep the checkup radius
    // as small as possible.
    else {
      new_checkup = this.getCreatureTypesAroundPlayer(master);

      // we get here the create that were here before but are no longer here and
      // alive now.
      checkup_difference = getDifferenceBetweenCheckups(
        this.last_checkup,
        new_checkup
      );

      this.notifyEcosystemManager(master, checkup_difference);
    }

    this.was_player_in_combat = is_player_in_combat;

    
    return false;
  }

  private latent function getCreatureTypesAroundPlayer(master: CRandomEncounters): array<CreatureType> {
    var entities: array<CGameplayEntity>;
    var output: array<CreatureType>;
    var current_type: CreatureType;
    var i: int;

    FindGameplayEntitiesInRange(
      entities,
      thePlayer,
      25, // radius
      10, // max number of entities
      , // tag
      FLAG_Attitude_Hostile + FLAG_ExcludePlayer + FLAG_OnlyAliveActors + FLAG_OnlyActors,
      thePlayer, // target
      'CNewNPC'
    );

    for (i = 0; i < entities.Size(); i += 1) {
      if (((CNewNPC)entities[i])
      && ((CNewNPC)entities[i]).GetNPCType() == ENGT_Enemy) {
        continue;
      }

      current_type = master
        .bestiary
        .getCreatureTypeFromEntity((CEntity)entities[i]);

      if (current_type < CreatureMAX) {
        output.PushBack(current_type);
      }
    }

    return output;
  }

  // returns creatures that were in `before` and are no longer in `after`
  private function getDifferenceBetweenCheckups(before: array<CreatureType>, after: array<CreatureType>): array<CreatureType> {
    var i, j: int;
    var was_found: bool;
    var output: array<CreatureType>;

    for (i = 0; i < after.Size(); i += 1) {
      was_found = false;

      for (j = 0; j < before.Size(); i += 1) {
        if (after[i] == before[j]) {
          // so that it doesn't match for other creatures. It's easier to set it
          // to CreatureNONE than to remove it, it is more efficient. And we know
          // that there are supposedly no CreatureNONE in after so we're good.
          before[j] = CreatureNONE;

          was_found = true;
        }
      }

      if (!was_found) {
        output.PushBack(after[i]);
      }
    }

    return output;
  }

  private function notifyEcosystemManager(master: CRandomEncounters, difference: array<CreatureType>) {
    // uses CreatureType as the index
    var power_changes: array<float>;
    var i: int;

    for (i = 0; i < CreatureMAX; i += 1) {
      power_changes.PushBack(0);
    }

    for (i = 0; i < difference.Size(); i += 1) {
      power_changes[difference[i]] += 1;
    }

    for (i = 0; i < CreatureMAX; i += 1) {
      if (power_changes[i] != 0) {
        master.ecosystem_manager
          .updatePowerForCreatureInCurrentEcosystemAreas(i, power_changes[i]);
      }
    }
  }
}