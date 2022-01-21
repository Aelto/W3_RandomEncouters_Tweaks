
function getRandomPositionBehindCamera(out initial_pos: Vector, optional distance: float, optional minimum_distance: float, optional attempts: int): bool {
  var player_position: Vector;
  var point_z: float;
  var attempts_left: int;

  if (minimum_distance == 0.0) {
    minimum_distance = 20.0;
  }

  // value of `0.0` means the parameter was not supplied
  if (distance == 0.0) {
    distance = 40;
  }

  else if (distance < minimum_distance) {
    distance = minimum_distance; // meters
  }

  player_position = thePlayer.GetWorldPosition();
  attempts_left = Max(attempts, 3);

  for (attempts_left; attempts_left > 0; attempts_left -= 1) {
    initial_pos = player_position + VecConeRand(theCamera.GetCameraHeading(), 270, -minimum_distance, -distance);

    if (getGroundPosition(initial_pos)) {
      LogChannel('modRandomEncounters', initial_pos.X + " " + initial_pos.Y + " " + initial_pos.Z);

      if (initial_pos.X == 0
       || initial_pos.Y == 0
       || initial_pos.Z == 0) {
        return false;
      }

      return true;
    }
  }

  return false;
}

function getRandomPositionAroundPlayer(out initial_pos: Vector, optional distance: float, optional minimum_distance: float, optional attempts: int): bool {
  var player_position: Vector;
  var point_z: float;
  var attempts_left: int;

  if (minimum_distance == 0.0) {
    minimum_distance = 20.0;
  }

  // value of `0.0` means the parameter was not supplied
  if (distance == 0.0) {
    distance = 40;
  }

  else if (distance < minimum_distance) {
    distance = minimum_distance; // meters
  }

  player_position = thePlayer.GetWorldPosition();
  attempts_left = Max(attempts, 3);

  for (attempts_left; attempts_left > 0; attempts_left -= 1) {
    initial_pos = player_position + VecRingRand(minimum_distance, distance);

    if (getGroundPosition(initial_pos)) {
      LogChannel('modRandomEncounters', initial_pos.X + " " + initial_pos.Y + " " + initial_pos.Z);

      if (initial_pos.X == 0
       || initial_pos.Y == 0
       || initial_pos.Z == 0) {
        return false;
      }

      return true;
    }
  }

  return false;
}