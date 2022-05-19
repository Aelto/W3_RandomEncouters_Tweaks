
class RER_StaticEncounter {

  var bestiary_entry: RER_BestiaryEntry;

  var position: Vector;

  var region_constraint: RER_RegionConstraint;

  // used to fetch the spawning chance from the menu.
  var type: RER_StaticEncounterType;
  default type = StaticEncounterType_SMALL;

  var radius: float;
  default radius = 0.01;

  public latent function getBestiaryEntry(master: CRandomEncounters): RER_BestiaryEntry {
    return this.bestiary_entry;
  }

  public function isInRegion(region: string): bool {
    if (this.region_constraint == RER_RegionConstraint_NO_VELEN && (region == "no_mans_land" || region == "novigrad")
    ||  this.region_constraint == RER_RegionConstraint_NO_SKELLIGE && (region == "skellige" || region == "kaer_morhen")
    ||  this.region_constraint == RER_RegionConstraint_NO_TOUSSAINT && region == "bob"
    ||  this.region_constraint == RER_RegionConstraint_NO_WHITEORCHARD && region == "prolog_village"
    ||  this.region_constraint == RER_RegionConstraint_ONLY_TOUSSAINT && region != "bob"
    ||  this.region_constraint == RER_RegionConstraint_ONLY_WHITEORCHARD && region != "prolog_village"
    ||  this.region_constraint == RER_RegionConstraint_ONLY_SKELLIGE && region != "skellige" && region != "kaer_morhen"
    ||  this.region_constraint == RER_RegionConstraint_ONLY_VELEN && region != "no_mans_land" && region != "novigrad") {
      return false;
    }

    return true;
  }

  public function canSpawn(player_position: Vector, small_chance: float, large_chance: float, max_distance: float, current_region: string): bool {
    var entities: array<CGameplayEntity>;
    var radius: float;
    var i: int;

    if (!this.isInRegion(current_region)) {
      return false;
    }

    if (!this.rollSpawningChance(small_chance, large_chance)) {
      return false;
    }

    // first if the player is too far
    radius = this.radius * this.radius;
      if (VecDistanceSquared(player_position, this.position) > max_distance * max_distance) {
      return false;
    }

    // then check if the player is nearby, cancel spawn.
    radius = MinF(
      this.radius * this.radius * 2,
      max_distance * 0.5
    );

    if (VecDistanceSquared(player_position, this.position) < radius) {
      return false;
    }

    // check if an enemy from the `bestiary_entry` is nearby, cancel spawn.
    FindGameplayEntitiesCloseToPoint(
      entities,
      this.position,
      this.radius + 20, // the +20 is to still catch monster on small radius in case they move
      1 * (int)this.radius,
      , // tags
      , // queryflags
      , // target
      'CNewNPC'
    );

    if (areThereEntitiesWithSameTemplate(entities)) {
      return false;
    }

    LogChannel('modRandomEncounters', "StaticEncounter can spawn");

    return true;
  }

  private function areThereEntitiesWithSameTemplate(entities: array<CGameplayEntity>): bool {
    var hashed_name: string;
    var i: int;

    for (i = 0; i < entities.Size(); i += 1) {
      hashed_name = entities[i].GetReadableName();

      // we found a nearby enemy that is from the same template
      if (this.isTemplateInEntry(hashed_name)) {
        LogChannel('modRandomEncounters', "StaticEncounter already spawned");

        return true;
      }
    }
    
    return false;
  }

  private function isTemplateInEntry(template: string): bool {
    var i: int;

    for (i = 0; i < this.bestiary_entry.template_list.templates.Size(); i += 1) {
      if (this.bestiary_entry.template_list.templates[i].template == template) {
        return true;
      }
    }

    return false;
  }

  public function getSpawningPosition(): Vector {
    var max_attempt_count: int;
    var current_spawn_position: Vector;
    var i: int;

    max_attempt_count = 10;

    for (i = 0; i < max_attempt_count; i += 1) {
      current_spawn_position = this.position
        + VecRingRand(0, this.radius);

      if (getGroundPosition(current_spawn_position, , this.radius)) {
        return current_spawn_position;
      }
    }

    return this.position;
  }

  //
  // return `true` if the roll succeeded, and false if it didn't.
  private function rollSpawningChance(small_chance: float, large_chance: float): bool {
    var spawn_chance: float;

    if (this.type == StaticEncounterType_LARGE) {
      spawn_chance = large_chance;
    }
    else {
      spawn_chance = small_chance;
    }

    if (RandRangeF(100) < spawn_chance) {
      return true;
    }

    return false;
  }

}
