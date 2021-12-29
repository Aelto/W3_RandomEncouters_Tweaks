
/**
 * Unique identifier used to differentiate one noticeboard from another
 */
struct RER_NoticeboardIdentifier {
  var identifier: float;
}

/**
 * Unique identifier used to differentiate one contract from another
 */
struct RER_ContractIdentifier {
  var identifier: float;
}

/**
 * Represents the time when the contracts were generated
 */
struct RER_GenerationTime {
  var time: float;
}

enum RER_ContractDistance {
  ContractDistance_CLOSE = 0,
  ContractDistance_FAR = 1,
}

enum RER_ContractDifficulty {
  ContractDifficulty_EASY = 0,
  ContractDifficulty_HARD = 1
}

/**
 * Represents a contract and all the needed information to create it.
 * The struct should be enough to make the exact same contract from scratch using
 * the helper functions.
 */
struct RER_ContractGenerationData {
  /**
   * the position of the noticeboard when the contract was accepted
   */
  var starting_point: Vector;

  var distance: RER_ContractDistance;

  var difficulty: RER_ContractDifficulty;

  var species: RER_SpeciesTypes;

  var identifier: RER_ContractIdentifier;

  var noticeboard_identifier: RER_NoticeboardIdentifier;

  var region_name: string;

  /**
   * the seed of the random number generator before doing any rand call for
   * generating the contract.
   */
  var rng_seed: int;
}

enum RER_ContractEventType {
  ContractEventType_NEST = 0,
  ContractEventType_HORDE = 1,
  ContractEventType_BOSS = 2,
}

enum RER_ContractRewardType {
  ContractRewardType_NONE = 000000,
  ContractRewardType_GEAR = 000001,
  ContractRewardType_MATERIALS = 000010,
  ContractRewardType_EXPERIENCE = 000100,
  ContractRewardType_CONSUMABLES = 001000,
  ContractRewardType_GOLD = 010000,
  ContractRewardType_ALL = 111111
}

/**
 * Represents a contract and the needed data to identify the contract.
 *
 * It also contains the needed data to run the contract and restore it in-between
 * loading screens.
 */
struct RER_ContractRepresentation {
  /**
   * where the player needs to go to trigger the contract
   */
  var destination_point: Vector;

  var destination_radius: float;

  /**
   * what should happen once the player has reached the destination
   */
  var event_type: RER_ContractEventType;

  var creature_type: CreatureType;

  var identifier: RER_ContractIdentifier;

  var noticeboard_identifier: RER_NoticeboardIdentifier;

  /**
   * the possible rewards the player can get from completing the contract.
   * This value is a flag and can contain multiple reward types
   */
  var reward_type: RER_ContractRewardType;

  var region_name: string;

  var rng_seed: int;
}

/**
 * It's a class because structs are copied in this language
 */
class RER_ContractLocation extends SU_ArraySorterData {
  var position: Vector;

  public function init(position: Vector, distance: float): RER_ContractLocation {
    this.position = position;

    // we use the distance as the value used during the sorting
    this.value = distance;

    return this;
  }
}