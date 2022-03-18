
class RER_BestiaryGhoul extends RER_BestiaryEntry {
  public function init() {
    var influences: RER_ConstantInfluences;
    influences = RER_ConstantInfluences();

    this.type = CreatureGHOUL;
    this.species = SpeciesTypes_NECROPHAGES;
    this.menu_name = 'Ghouls';
    this.localized_name = 'option_rer_ghoul';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\ghoul_lvl1.w2ent",,,
      "gameplay\journal\bestiary\bestiaryghoul.journal"
    )
  );          // normal ghoul   spawns from the ground
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\ghoul_lvl2.w2ent",,,
      "gameplay\journal\bestiary\bestiaryghoul.journal"
    )
  );          // red ghoul   spawns from the ground
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\ghoul_lvl3.w2ent",,,
      "gameplay\journal\bestiary\bestiaryghoul.journal"
    )
  );

    this.template_list.difficulty_factor.minimum_count_easy = 2;
    this.template_list.difficulty_factor.maximum_count_easy = 3;
    this.template_list.difficulty_factor.minimum_count_medium = 3;
    this.template_list.difficulty_factor.maximum_count_medium = 4;
    this.template_list.difficulty_factor.minimum_count_hard = 3;
    this.template_list.difficulty_factor.maximum_count_hard = 5;

  

    this.trophy_names.PushBack('modrer_necrophage_trophy_low');
    this.trophy_names.PushBack('modrer_necrophage_trophy_medium');
    this.trophy_names.PushBack('modrer_necrophage_trophy_high');

    LogChannel('RER', "constant influence, " + influences.kills_them);
    this.ecosystem_delay_multiplier = 2.5;

    this.ecosystem_impact = (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(influences.kills_them) //CreatureHUMAN
      .influence(influences.no_influence) //CreatureARACHAS
      .influence(influences.no_influence) //CreatureENDREGA
      .influence(influences.self_influence) //CreatureGHOUL
      .influence(influences.friend_with) //CreatureALGHOUL
      .influence(influences.kills_them) //CreatureNEKKER
      .influence(influences.friend_with) //CreatureDROWNER
      .influence(influences.friend_with) //CreatureROTFIEND
      .influence(influences.low_bad_influence) //CreatureWOLF
      .influence(influences.no_influence) //CreatureWRAITH
      .influence(influences.no_influence) //CreatureHARPY
      .influence(influences.no_influence) //CreatureSPIDER
      .influence(influences.no_influence) //CreatureCENTIPEDE
      .influence(influences.no_influence) //CreatureDROWNERDLC
      .influence(influences.low_bad_influence) //CreatureBOAR
      .influence(influences.low_bad_influence) //CreatureBEAR
      .influence(influences.no_influence) //CreaturePANTHER
      .influence(influences.low_indirect_influence) //CreatureSKELETON
      .influence(influences.no_influence) //CreatureECHINOPS
      .influence(influences.no_influence) //CreatureKIKIMORE
      .influence(influences.no_influence) //CreatureBARGHEST
      .influence(influences.low_bad_influence) //CreatureSKELWOLF
      .influence(influences.low_bad_influence) //CreatureSKELBEAR
      .influence(influences.no_influence) //CreatureWILDHUNT
      .influence(influences.no_influence) //CreatureBERSERKER
      .influence(influences.friend_with) //CreatureSIREN

      // large creatures below
      .influence(influences.no_influence) //CreatureDRACOLIZARD
      .influence(influences.no_influence) //CreatureGARGOYLE
      .influence(influences.no_influence) //CreatureLESHEN
      .influence(influences.low_indirect_influence) //CreatureWEREWOLF
      .influence(influences.no_influence) //CreatureFIEND
      .influence(influences.low_indirect_influence) //CreatureEKIMMARA
      .influence(influences.low_indirect_influence) //CreatureKATAKAN
      .influence(influences.no_influence) //CreatureGOLEM
      .influence(influences.no_influence) //CreatureELEMENTAL
      .influence(influences.no_influence) //CreatureNIGHTWRAITH
      .influence(influences.no_influence) //CreatureNOONWRAITH
      .influence(influences.no_influence) //CreatureCHORT
      .influence(influences.no_influence) //CreatureCYCLOP
      .influence(influences.no_influence) //CreatureTROLL
      .influence(influences.friend_with) //CreatureHAG
      .influence(influences.friend_with) //CreatureFOGLET
      .influence(influences.no_influence) //CreatureBRUXA
      .influence(influences.low_indirect_influence) //CreatureFLEDER
      .influence(influences.low_indirect_influence) //CreatureGARKAIN
      .influence(influences.no_influence) //CreatureDETLAFF
      .influence(influences.no_influence) //CreatureGIANT
      .influence(influences.no_influence) //CreatureSHARLEY
      .influence(influences.no_influence) //CreatureWIGHT
      .influence(influences.no_influence) //CreatureGRYPHON
      .influence(influences.no_influence) //CreatureCOCKATRICE
      .influence(influences.no_influence) //CreatureBASILISK
      .influence(influences.no_influence) //CreatureWYVERN
      .influence(influences.no_influence) //CreatureFORKTAIL
      .influence(influences.no_influence) //CreatureSKELTROLL
      .build();

    this.possible_compositions.PushBack(CreatureALGHOUL);
    this.possible_compositions.PushBack(CreatureDROWNER);
    this.possible_compositions.PushBack(CreatureDROWNERDLC);
    this.possible_compositions.PushBack(CreatureROTFIEND);
  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}
