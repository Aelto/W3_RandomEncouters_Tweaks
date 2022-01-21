
// When the player enters a swamp, there is a small chance for drowners or hags to appear
class RER_ListenerMeditationAmbush extends RER_EventsListener {
  var trigger_chance: float;

  public latent function loadSettings() {
    var inGameConfigWrapper: CInGameConfigWrapper;

    inGameConfigWrapper = theGame.GetInGameConfigWrapper();

    this.trigger_chance = StringToFloat(
      inGameConfigWrapper
      .GetVarValue('RERevents', 'eventMeditationAmbush')
    );

    // the event is only active if its chances to trigger are greater than 0
    this.active = this.trigger_chance > 0;
  }

  var time_before_other_spawn: float;
  default time_before_other_spawn = 0;

  var time_spent_meditating: int;
  var last_meditation_time: GameTime;

  public latent function onInterval(was_spawn_already_triggered: bool, master: CRandomEncounters, delta: float, chance_scale: float): bool {
    var current_state: CName;
    var is_meditating: bool;
    
    if (was_spawn_already_triggered) {
      return false;
    }

    current_state = thePlayer.GetCurrentStateName();
    is_meditating = current_state == 'Meditation' || current_state == 'MeditationWaiting';

    // LogChannel('modRandomEncounters', "current state = " + current_state);

    // if the player is not meditating right now
    // we can early cancel the event here.
    if (!is_meditating) {
      // the player was meditating and is no longer meditating
      if (this.time_spent_meditating > 0) {
        master.static_encounter_manager.startSpawning();
      }

      time_spent_meditating = 0;

      return false;
    }

    // to avoid triggering this event too frequently
    if (this.time_before_other_spawn > 0) {
      time_before_other_spawn -= delta;

      return false;
    }

    // at this point it means the player is meditating

    // the player just started meditating
    if (time_spent_meditating == 0) {
      time_spent_meditating = CeilF(delta);
    }
    else {
      time_spent_meditating += GameTimeToSeconds(theGame.GetGameTime() - last_meditation_time);
    }

    last_meditation_time = theGame.GetGameTime();

    // LogChannel('modRandomEncounters', "chance  = "
    //   + this.trigger_chance + " increase = "
    //   + (float)(time_spent_meditating / 3600) + " final = "
    //   + (this.trigger_chance * (0.8f + (float)(time_spent_meditating / 3600) / 12.0f)) * chance_scale);
    
    // once we know how many seconds the player meditated, 
    // we can increase the chances
    // 12 hours increase the chances by 100%, 24h by 200%.
    // the default value is 80% of what the user set in the settings
    // so when starting a meditation we're at 80%
    // 12 hours later it's at 180%
    // 24 hours later it's at 280%
    if (RandRangeF(100) < (this.trigger_chance * (0.8f + (float)(time_spent_meditating / 3600) / 12.0f)) * chance_scale) {
      LogChannel('modRandomEncounters', "RER_ListenerMeditationAmbush - triggered, % increased by meditation = " + time_spent_meditating / 3600);

      // this check is done only when the event has triggered to avoid doing it too often
      if (shouldAbortCreatureSpawn(master.settings, master.rExtra, master.bestiary)) {
        LogChannel('modRandomEncounters', "RER_ListenerMeditationAmbush - cancelled");

        return false;
      }

      this.time_before_other_spawn += master.events_manager.internal_cooldown;

      // create a random ambush with no creature type chosen, let RER pick one
      // randomly.
      createRandomCreatureAmbush(master, CreatureNONE);

      return true;
    }

    return false;
  }
}
