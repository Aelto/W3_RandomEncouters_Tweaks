
// File containing helper functions used for creatures levels.
// It uses values from the settings to calculate their levels.
//

function getRandomLevelBasedOnSettings(settings: RE_Settings): int {
  var player_level: int;
  var max_level_allowed: int;
  var min_level_allowed: int;
  var level: int;

  player_level = RER_getPlayerLevel();

  // if for some reason the user set the max lower than the min value
  if (settings.max_level_allowed >= settings.min_level_allowed) {
    max_level_allowed = settings.max_level_allowed;
    min_level_allowed = settings.min_level_allowed;
  }
  else {
    max_level_allowed = settings.min_level_allowed;
    min_level_allowed = settings.max_level_allowed;
  }

  level = RandRange(player_level + max_level_allowed, player_level + min_level_allowed);

  LogChannel('modRandomEnocunters', "random creature level = " + level);

  return Max(level, 1);
}

function RER_getPlayerLevel(): int {
  if (RER_playerUsesEnhancedEditionRedux()) {
    // every 4 hours of gameplay is equal to 1 level in vanilla
    return GameTimeHours(theGame.CalculateTimePlayed()) / 4;
  }

  return thePlayer.GetLevel();
}