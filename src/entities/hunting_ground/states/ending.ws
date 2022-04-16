
state Ending in RandomEncountersReworkedHuntingGroundEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "RandomEncountersReworkedHuntingGroundEntity - State Ending");

    this.Ending_main();
  }

  entry function Ending_main() {
    if (parent.is_bounty) {
      if (parent.bounty_group_index < 0) {
        parent.bounty_manager.notifyMainGroupKilled();
      }
      else {
        parent.bounty_manager.notifySideGroupKilled(parent.bounty_group_index);
      }
    }

    if (VecDistanceSquared(thePlayer.GetWorldPosition(), parent.bait_entity.GetWorldPosition()) < 50 * 50) {
      RER_tryRefillRandomContainer(parent.master);
    }

    if (!parent.manual_destruction) {
      parent.clean();
    }
  }
}
