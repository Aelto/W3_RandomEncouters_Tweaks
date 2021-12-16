
state Ending in RER_MonsterNest {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    NLOG("RER_MonsterNest - State Ending");

    this.Ending_main();
  }

  entry function Ending_main() {
    Sleep(1);

    if (VecDistanceSquared(parent.GetWorldPosition(), thePlayer.GetWorldPosition()) < 50 * 50) {
      RER_tryRefillRandomContainer();
    }

    parent.clean();
  }
}
