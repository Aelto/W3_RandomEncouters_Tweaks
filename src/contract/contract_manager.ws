
/**
 * Summary of the whole Contract system:
 *  - An errand injector adds a notice to every noticeboard in the game
 *  - When the errand is picked, it notifies the ContractManager which
 *    displays a list of contracts the user can start.
 *  - There is a limited amount of contracts per hour (by default)
 *  - For contracts to be restricted per noticeboard, the noticeboards as
 *    well as the contract have a unique identifier.
 *  - These identifiers are used to determine if the same contract was
 *    already completed from the same noticeboard.
 *  - When a contract is started, it selects a random location in the
 *    world, as well a random reward and a random species.
 *  - Every thing random in contracts are generated from a seeded RNG
 *  - The seed is obtained from the noticeboard and the current
 *    generation time.
 *  - Contracts do not persist in the save, but are regenerated every
 *    the player is nearby.
 *  - The available rewards depend on the region and also on the
 *    noticeboard.
 */
statemachine class RER_ContractManager {
  var master: CRandomEncounters;

  function init(_master: CRandomEncounters) {
    this.master = _master;

    this.GotoState('Waiting');
  }

  function pickedContractNoticeFromNoticeboard(errand_name: string) {
    this.GotoState('DialogChoice');
  }

  public function getGenerationTime(time: int): RER_GenerationTime {
    var required_time_elapsed: float;

    required_time_elapsed = StringToFloat(
      theGame.GetInGameConfigWrapper()
      .GetVarValue('RERcontracts', 'RERhoursBeforeNewContracts')
    );

    return RER_GenerationTime(time / required_time_elapsed);
  }

  public function isItTimeToRegenerateContracts(generation_time: RER_GenerationTime): bool {
    return this.master.storages.contract.last_generation_time.time != generation_time.time;
  }

  public function updateStorageGenerationTime(generation_time: RER_GenerationTime) {
    this.master.storages.contract.last_generation_time = generation_time;
    this.master.storages.contract.completed_contracts.Clear();
    this.master.storages.contract.save();
  }

  public function isContractInStorageCompletedContracts(contract: RER_ContractIdentifier): bool {
    var i: int;

    for (i = 0; i < this.master.storages.contract.completed_contracts.Size(); i += 1) {
      if (this.master.storages.contract.completed_contracts[i].identifier == contract.identifier) {
        return true;
      }
    }

    return false;
  }

  public function getUniqueIdFromNoticeboard(noticeboard: W3NoticeBoard): RER_NoticeboardIdentifier {
    var position: Vector;
    var heading: float;

    position = noticeboard.GetWorldPosition();
    heading = noticeboard.GetHeading();

    // a random formula to limit the chances of collision, nothing too fancy
    return RER_NoticeboardIdentifier(
      position.X * heading
      - position.Y / heading
      + position.Z + heading
    );
  }

  public function getUniqueIdFromContract(noticeboard: RER_NoticeboardIdentifier, is_far: bool, is_hard: bool, species: RER_SpeciesTypes, generation_time: RER_GenerationTime): RER_ContractIdentifier {
    var output: float;

    output = noticeboard.identifier;

    if (is_far) {
      output /= generation_time.time;
    }
    else {
      output *= generation_time.time;
    }

    if (is_hard) {
      output -= generation_time.time;
    }
    else {
      output += generation_time.time;
    }

    return RER_ContractIdentifier(output);
  }

  public function generateContract(data: RER_ContractGenerationData): RER_ContractRepresentation {
    var contract: RER_ContractRepresentation;
    var bestiary_entry: RER_BestiaryEntry;
    var rng: RandomNumberGenerator;

    contract = RER_ContractRepresentation();
    rng = (new RandomNumberGenerator in this).setSeed(data.rng_seed)
      .useSeed(true);

    contract.identifier = data.identifier;
    contract.destination_point = this.getRandomDestinationAroundPoint(data.starting_point, data.distance, rng);
    contract.destination_radius = 100;

    bestiary_entry = this.master.bestiary.getRandomEntryFromSpeciesType(data.species, rng);
    contract.creature_type = bestiary_entry.type;
    contract.region_name = data.region_name;
    contract.rng_seed = data.rng_seed;
    contract.reward_type = RER_getAllowedContractRewardsMaskFromRegion()
                         | RER_getRandomAllowedRewardType(this, data.noticeboard_identifier);

    if (data.difficulty == ContractDifficulty_EASY) {
      if (rng.nextRange(10, 0) < 5) {
        contract.event_type = ContractEventType_HORDE;
      }
      else {
        contract.event_type = ContractEventType_NEST;
      }
    }
    else {
      contract.event_type = ContractEventType_BOSS;
    }

    return contract;
  }

  public function getRandomDestinationAroundPoint(starting_point: Vector, distance: RER_ContractDistance, rng: RandomNumberGenerator): Vector {
    var closest_points: array<Vector>;
    var index: int;
    var size: int;

    if (distance == ContractDistance_CLOSE) {
      closest_points = this.getClosestDestinationPoints(starting_point, 5);
    }
    else {
      closest_points = this.getClosestDestinationPoints(starting_point, 10);
    }

    // since it can return less than what we asked for
    size = closest_points.Size();
    if (size <= 0) {
      NDEBUG("ERROR: no available location for contract was found");
    }

    index = (int)rng.nextRange(size, 0);

    return closest_points[index];
  }

  public function getClosestDestinationPoints(starting_point: Vector, amount_of_points: int): array<Vector> {
    var sorter_data: array<SU_ArraySorterData>;
    var output: array<Vector>;

    current_region = AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea());

    for (i = 0; i < this.master.static_encounter_manager.encounters.Size(); i += 1) {
      if (!this.master.static_encounter_manager.encounters[i].isInRegion(current_region)) {
        continue;
      }

      current_position = this.master.static_encounter_manager.encounters[i].position;
      current_distance = VecDistanceSquared2D(starting_point, current_position);

      sorter_data.PushBack((new RER_ContractLocation in this).init(current_position, current_distance));
    }

    // we re-use the same variable here
    sorter_data = SU_sortArray(sorter_data);

    for (i = 0; i < sorter_data.Size() && i < amount_of_points; i += 1) {
      output.PushBack(sorter_data[i].position);
    }

    return output;
  }

  public function completeCurrentContract() {
    var storage: RER_ContractStorage;
    var token_name: name;

    storage = this.master.storages.contract;

    if (!storage.has_ongoing_contract) {
      return;
    }

    storage.completed_contracts.PushBack(storage.ongoing_contract.identifier);
    storage.has_ongoing_contract = false;

    token_name = RER_contractRewardTypeToItemName(
      RER_getRandomContractRewardTypeFromFlag(storage.ongoing_contract.reward_type)
    );

    if (IsNameValid(token_name)) {
      thePlayer
        .GetInventory()
        .AddAnItem(token_name);

      // TODO: maybe give more tokens for harder contracts
      thePlayer.DisplayItemRewardNotification(token_name, 1);
    }

    storage.save();
  }
}