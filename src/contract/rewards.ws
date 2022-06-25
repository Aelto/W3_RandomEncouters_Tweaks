
function RER_contractRewardTypeToItemName(type: RER_ContractRewardType): name {
  var item_name: name;

  switch (type) {
    case ContractRewardType_GEAR:
      item_name = 'rer_token_gear';
      break;

    case ContractRewardType_MATERIALS:
      item_name = 'rer_token_materials';
      break;

    case ContractRewardType_CONSUMABLES:
      item_name = 'rer_token_consumables';
      break;

    case ContractRewardType_EXPERIENCE:
      item_name = 'rer_token_experience';
      break;

    case ContractRewardType_GOLD:
      item_name = 'rer_token_gold';
      break;
  }

  return item_name;
}

latent function RER_applyLootFromContractTokenName(master: CRandomEncounters, inventory: CInventoryComponent, loot_table_container: W3AnimatedContainer, item: name, optional amount: int): array<RER_LootTableItemResult> {
  var results: array<RER_LootTableItemResult>;
  var output: array<RER_LootTableItemResult>;
  var loot_table: name;
  var index: int;

  amount = Max(1, amount);
  inventory.RemoveItemByName(item, amount);

  if (item == 'rer_token_experience') {
    // re-use the index variable here
    index =  RER_getPlayerLevel() * 10;

    GetWitcherPlayer()
    .AddPoints(EExperiencePoint, index, true);

    thePlayer.DisplayItemRewardNotification('experience', index);

    return output;
  }

  switch (item) {
    case 'rer_token_gear':
      loot_table = 'rer_gear';

      theSound.SoundEvent("gui_inventory_weapon_attach");
      break;
    
    case 'rer_token_consumables':
      loot_table = 'rer_consumables';

      theSound.SoundEvent("gui_pick_up_herbs");
      break;
    
    case 'rer_token_gold':
      loot_table = 'rer_gold';

      theSound.SoundEvent("gui_inventory_buy");
      break;
    
    case 'rer_token_materials':
      loot_table = 'rer_materials';

      theSound.SoundEvent("gui_inventory_potion_attach");
      break;
  }

  while (amount > 0) {
    amount -= 1;

    Sleep(0.2);

    results = RER_addItemsFromLootTable(loot_table_container, inventory, loot_table);

    // re use the index variable here:
    for (index = 0; index < results.Size(); index += 1) {
      output.PushBack(results[index]);
    }
  }

  return output;
}

function RER_getLocalizedRewardType(type: RER_ContractRewardType): string {
  var item_name: string;

  item_name = NameToString(RER_contractRewardTypeToItemName(type)) + "_short";

  return GetLocStringByKey(item_name);
}

function RER_getLocalizedRewardTypesFromFlag(flag: RER_ContractRewardType): string {
  var output: string;

  if (RER_flagEnabled(flag, ContractRewardType_GEAR)) {
    output += RER_getLocalizedRewardType(ContractRewardType_GEAR);
  }

  if (RER_flagEnabled(flag, ContractRewardType_CONSUMABLES)) {
    if (StrLen(output) > 0) {
      output += ", ";
    }

    output += RER_getLocalizedRewardType(ContractRewardType_CONSUMABLES);
  }

  if (RER_flagEnabled(flag, ContractRewardType_EXPERIENCE)) {
    if (StrLen(output) > 0) {
      output += ", ";
    }

    output += RER_getLocalizedRewardType(ContractRewardType_EXPERIENCE);
  }

  if (RER_flagEnabled(flag, ContractRewardType_GOLD)) {
    if (StrLen(output) > 0) {
      output += ", ";
    }

    output += RER_getLocalizedRewardType(ContractRewardType_GOLD);
  }

  if (RER_flagEnabled(flag, ContractRewardType_MATERIALS)) {
    if (StrLen(output) > 0) {
      output += ", ";
    }

    output += RER_getLocalizedRewardType(ContractRewardType_MATERIALS);
  }

  return output;
}

function RER_getRandomContractRewardTypeFromFlag(flag: RER_ContractRewardType, rng: RandomNumberGenerator): RER_ContractRewardType {
  var enabled_types: array<RER_ContractRewardType>;
  var index: int;

  if (RER_flagEnabled(flag, ContractRewardType_GEAR)) {
    enabled_types.PushBack(ContractRewardType_GEAR);
  }

  if (RER_flagEnabled(flag, ContractRewardType_CONSUMABLES)) {
    enabled_types.PushBack(ContractRewardType_CONSUMABLES);
  }

  if (RER_flagEnabled(flag, ContractRewardType_EXPERIENCE)) {
    enabled_types.PushBack(ContractRewardType_EXPERIENCE);
  }

  if (RER_flagEnabled(flag, ContractRewardType_GOLD)) {
    enabled_types.PushBack(ContractRewardType_GOLD);
  }

  if (RER_flagEnabled(flag, ContractRewardType_MATERIALS)) {
    enabled_types.PushBack(ContractRewardType_MATERIALS);
  }

  index = (int)rng.nextRange(enabled_types.Size(), 0);

  return enabled_types[index];
}

function RER_getAllowedContractRewardsMaskFromRegion(): RER_ContractRewardType {
  var region: string;
  var position: Vector;
  region = SUH_getCurrentRegion();

  NLOG("RER_getAllowedContractRewardsMaskFromRegion, region = " + region);

  if (region == "prolog_village_winter") {
    region = "prolog_village";
  }

  if (region == "no_mans_land") {
    position = thePlayer.GetWorldPosition();

    // novigrad, higher than oxenfurt on the map
    if (position.X < 1150) {
      return ContractRewardType_GOLD
         | ContractRewardType_GEAR;
    }
    else {
      return ContractRewardType_EXPERIENCE
         | ContractRewardType_MATERIALS;
    }
  }
  // should never enter this one, but left just in case it happens
  else if (region == "novigrad") {
    return ContractRewardType_GOLD
         | ContractRewardType_GEAR;
  }
  else if (region == "skellige") {
    return ContractRewardType_CONSUMABLES
         | ContractRewardType_GEAR;
  }
  else if (region == "bob") {
    return ContractRewardType_CONSUMABLES
         | ContractRewardType_GOLD;
  }
  // kaer_morhen, spiral, isle of mysts, etc...
  // places where contracts cannot happen without mods
  
  return ContractRewardType_ALL;
}

/**
 * contracts rewards are subject to region based restrictions
 * but some noticeboards break the rules, this adds some nice
 * variation.
 */
function RER_getRandomAllowedRewardType(contract_manager: RER_ContractManager, noticeboard_identifier: RER_NoticeboardIdentifier): RER_ContractRewardType {
  var allowed_reward: RER_ContractRewardType;
  var rng: RandomNumberGenerator;
  var roll: int;
  
  rng = (new RandomNumberGenerator in contract_manager).setSeed(RER_identifierToInt(noticeboard_identifier.identifier))
    .useSeed(true);

  allowed_reward = ContractRewardType_NONE;
  roll = (int)rng.nextRange(15, 0);

  switch (roll) {
    case 0:
      allowed_reward = ContractRewardType_GEAR;
      break;

    case 1:
      allowed_reward = ContractRewardType_MATERIALS;
      break;

    case 2:
      allowed_reward = ContractRewardType_EXPERIENCE;
      break;

    case 3:
      allowed_reward = ContractRewardType_CONSUMABLES;
      break;
    
    case 4:
      allowed_reward = ContractRewardType_GOLD;
  }

  NLOG("RER_getRandomAllowedRewardType, allowed_reward = " + allowed_reward);

  return allowed_reward;
}

function RER_getRandomJewelName(rng: RandomNumberGenerator): name {
  var names: array<name>;
  var output: name;

  names.PushBack('Ruby');
  names.PushBack('Amber');
  names.PushBack('Amethyst');
  names.PushBack('Diamond');
  names.PushBack('Emerald');
  names.PushBack('Sapphire');

  output = names[(int)rng.nextRange(names.Size(), 0)];

  return output;
}