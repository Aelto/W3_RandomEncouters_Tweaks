
state Starting in RER_EventsManager {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    LogChannel('modRandomEncounters', "RER_EventsManager - State Starting");

    this.Starting_main();
  }

  entry function Starting_main() {
    var inGameConfigWrapper: CInGameConfigWrapper;
    var listener: RER_EventsListener;
    var i: int;


    for (i = 0; i < parent.listeners.Size(); i += 1) {
      listener = parent.listeners[i];

      if (!listener.is_ready) {
        listener.onReady(parent);
      }

      listener.loadSettings();
    }

    inGameConfigWrapper = theGame.GetInGameConfigWrapper();

    parent.internal_cooldown = StringToFloat(
      inGameConfigWrapper
      .GetVarValue('RERevents', 'eventSystemICD')
    );

    // the chance_scale also scales with the mod power
    parent.chance_scale = parent.delay / parent.internal_cooldown * RER_getModPower();

    LogChannel('modRandomEncounters', "RER_EventsManager - chance_scale = " + parent.chance_scale + ", delay =" + parent.delay);
    
    parent.GotoState('Waiting');
  }
}
