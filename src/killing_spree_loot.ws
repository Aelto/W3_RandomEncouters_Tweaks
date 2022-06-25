
// The ecosystem strength is a value that goes from 0 to 1, and 1 means 100%
function RER_addKillingSpreeCustomLootToEntities(entities: array<CEntity>, loot_tables: array<RER_KillingSpreeLootTable>, ecosystem_strength: float) {
  var table: RER_KillingSpreeLootTable;
  var entity: CEntity;
  var i: int;
  var k: int;

  NLOG("RER_addKillingSpreeCustomLootToEntities: ecosystem strength = " + ecosystem_strength * 100);


  // when it's a value in the ]0;1[ range, we bring it back to the [1;inf] range
  // For example if it is a 0.5, so a 50% ecosystem strength it should be considered
  // the same as a 200% ecosystem strength, so 2. And 1 / 0.5 = 2.
  if (ecosystem_strength < 1 && ecosystem_strength != 0) {
    ecosystem_strength = 1 / ecosystem_strength;
  } 

  NLOG("RER_addKillingSpreeCustomLootToEntities: ecosystem strength = " + ecosystem_strength * 100);

  for (i = 0; i < loot_tables.Size(); i += 1) {
    table = loot_tables[i];

    // the table unlock level was not reached yet, skip it.
    // the -100 to the ecosystem strength is because want to unlock new loot tables
    // only if the strength is above 100, so an unlock level of 50 should unlock
    // at 50% which is in reality a 150% ecosystem strength
    if (table.unlock_level > ecosystem_strength * 100 - 100) {
      continue;
    }

    NLOG("loot table unlocked: " + table.table_name + ", table.unlock_level " + table.unlock_level + " ecosystem strength = " + ecosystem_strength * 100);

    for (k = 0; k < entities.Size(); k += 1) {
      if (RandRange(100) <= table.droprate * (1 + ecosystem_strength)) {
        RER_addLootTableToEntity(entities[i], table);
      }
    }
  }
}

function RER_addLootTableToEntity(entity: CEntity, loot_table: RER_KillingSpreeLootTable) {
  NLOG("loot table applied to entity: " + loot_table.table_name);

  ((CGameplayEntity)entity).GetInventory().AddItemsFromLootDefinition(loot_table.table_name);
  ((CGameplayEntity)entity).GetInventory().UpdateLoot();
}


class RER_KillingSpreeLootTable {
  var table_name: name;
  var unlock_level: float;
  var droprate: float;
}

function RER_makeKillingSpreeLootTable(table_name: name, unlock_level: float, droprate: float): RER_KillingSpreeLootTable {
  var table: RER_KillingSpreeLootTable;

  table = new RER_KillingSpreeLootTable in thePlayer;
  table.table_name = table_name;
  table.unlock_level = unlock_level;
  table.droprate = droprate;

  return table;
}

function RER_getKillingSpreeLootTables(inGameConfigWrapper: CInGameConfigWrapper): array<RER_KillingSpreeLootTable> {
  var loot_tables: array<RER_KillingSpreeLootTable>;

  loot_tables.PushBack(
    RER_makeKillingSpreeLootTable(
      '_generic food_everywhere',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock__generic_food_everywhere')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate__generic_food_everywhere'))
    )
  );

  loot_tables.PushBack(
    RER_makeKillingSpreeLootTable(
      '_generic alco_everywhere',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock__generic_alco_everywhere')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate__generic_alco_everywhere'))
    )
  );

  loot_tables.PushBack(
    RER_makeKillingSpreeLootTable(
      '_generic gold_everywhere',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock__generic_gold_everywhere')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate__generic_gold_everywhere'))
    )
  );

  loot_tables.PushBack(
    RER_makeKillingSpreeLootTable(
      '_loot dwarven body_everywhere',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock__loot_dwarven_body_everywhere')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate__loot_dwarven_body_everywhere'))
    )
  );

  loot_tables.PushBack(
    RER_makeKillingSpreeLootTable(
      '_loot badit body_everywhere',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock__loot_badit_body_everywhere')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate__loot_badit_body_everywhere'))
    )
  );

  loot_tables.PushBack(
    RER_makeKillingSpreeLootTable(
      '_generic chest_everywhere',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock__generic_chest_everywhere')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate__generic_chest_everywhere'))
    )
  );

  loot_tables.PushBack(
    RER_makeKillingSpreeLootTable(
      '_herbalist area_prolog',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock__herbalist_area_prolog')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate__herbalist_area_prolog'))
    )
  );

  loot_tables.PushBack(
    RER_makeKillingSpreeLootTable(
      '_herbalist area_nml',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock__herbalist_area_nml')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate__herbalist_area_nml'))
    )
  );

  loot_tables.PushBack(
    RER_makeKillingSpreeLootTable(
      '_herbalist area_novigrad',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock__herbalist_area_novigrad')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate__herbalist_area_novigrad'))
    )
  );

  loot_tables.PushBack(
    RER_makeKillingSpreeLootTable(
      '_herbalist area_skelige',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock__herbalist_area_skelige')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate__herbalist_area_skelige'))
    )
  );

  loot_tables.PushBack(
    RER_makeKillingSpreeLootTable(
      '_dungeon_everywhere',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock__dungeon_everywhere')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate__dungeon_everywhere'))
    )
  );

  loot_tables.PushBack(
    RER_makeKillingSpreeLootTable(
      '_treasure_q1',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock__treasure_q1')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate__treasure_q1'))
    )
  );

  loot_tables.PushBack(
    RER_makeKillingSpreeLootTable(
      '_treasure_q2',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock__treasure_q2')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate__treasure_q2'))
    )
  );

  loot_tables.PushBack(
    RER_makeKillingSpreeLootTable(
      '_treasure_q3',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock__treasure_q3')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate__treasure_q3'))
    )
  );

  loot_tables.PushBack(
    RER_makeKillingSpreeLootTable(
      '_treasure_q4',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock__treasure_q4')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate__treasure_q4'))
    )
  );

  loot_tables.PushBack(
    RER_makeKillingSpreeLootTable(
      '_treasure_q5',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock__treasure_q5')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate__treasure_q5'))
    )
  );

  loot_tables.PushBack(
    RER_makeKillingSpreeLootTable(
      '_unique_runes',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock__unique_runes')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate__unique_runes'))
    )
  );

  loot_tables.PushBack(
    RER_makeKillingSpreeLootTable(
      '_unique_armorupgrades',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock__unique_armorupgrades')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate__unique_armorupgrades'))
    )
  );

  loot_tables.PushBack(
    RER_makeKillingSpreeLootTable(
      '_unique_ingr',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock__unique_ingr')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate__unique_ingr'))
    )
  );

  loot_tables.PushBack(
    RER_makeKillingSpreeLootTable(
      '_weapons_nml',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock__weapons_nml')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate__weapons_nml'))
    )
  );

  loot_tables.PushBack(
    RER_makeKillingSpreeLootTable(
      '_unique_weapons_epic_dungeon_nml',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock__unique_weapons_epic_dungeon_nml')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate__unique_weapons_epic_dungeon_nml'))
    )
  );

  loot_tables.PushBack(
    RER_makeKillingSpreeLootTable(
      '_uniqe_weapons_epic_dungeon_skelige',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock__uniqe_weapons_epic_dungeon_skelige')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate__uniqe_weapons_epic_dungeon_skelige'))
    )
  );

  loot_tables.PushBack(
    RER_makeKillingSpreeLootTable(
      '_loot_monster_treasure_uniq_swords',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock__loot_monster_treasure_uniq_swords')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate__loot_monster_treasure_uniq_swords'))
    )
  );

  loot_tables.PushBack(
    RER_makeKillingSpreeLootTable(
      '_uniq_armors',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock__uniq_armors')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate__uniq_armors'))
    )
  );


  return loot_tables;
}