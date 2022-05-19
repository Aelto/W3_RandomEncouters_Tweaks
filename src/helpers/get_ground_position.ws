
function getGroundPosition(out input_position: Vector, optional personal_space: float, optional radius: float): bool {
  var found_viable_position: bool;
  var collision_normal: Vector;
  var max_height_check: float;
  var output_position: Vector;
  var point_z: float;
  var attempts: int;

  attempts = 10;
  output_position = input_position;
  personal_space = MaxF(personal_space, 1.0);
  max_height_check = 30.0;

  if (radius == 0) {
    radius = 10.0;
  }

  do {
    attempts -= 1;

    // first search for ground based on navigation data.
    theGame
    .GetWorld()
    .NavigationComputeZ(
      output_position,
      output_position.Z - max_height_check,
      output_position.Z + max_height_check,
      point_z
    );

    output_position.Z = point_z;

    if (!theGame.GetWorld().NavigationFindSafeSpot(output_position, personal_space, radius, output_position)) {
      continue;
    }

    // then do a static trace to find the position on ground
    // ... okay i'm not sure anymore, is the static trace needed?
    // theGame
    // .GetWorld()
    // .StaticTrace(
    //   output_position + Vector(0,0,1.5),// + 5,// Vector(0,0,5),
    //   output_position - Vector(0,0,1.5),// - 5,//Vector(0,0,5),
    //   output_position,
    //   collision_normal
    // );

    // finally, return if the position is above water level
    if (output_position.Z < theGame.GetWorld().GetWaterLevel(output_position, true)) {
      continue;
    }

    found_viable_position = true;
    break;
  } while (attempts > 0);


  if (found_viable_position) {
    input_position = output_position;

    return true;
  }

  return false;
}
