
class RER_BestiaryFleder extends RER_BestiaryEntry {
  public function init() {
    var influences: RER_ConstantInfluences;
    influences = RER_ConstantInfluences();

    this.type = CreatureFLEDER;
    this.species = SpeciesTypes_VAMPIRES;
    this.menu_name = 'Fleders';
    this.localized_name = 'option_rer_fleder';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\fleder.w2ent", 1,,
      "dlc\bob\journal\bestiary\fleder.journal"
    )
  );this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\quests\main_quests\quest_files\q704_truth\characters\q704_protofleder.w2ent", 1,,
      "dlc\bob\journal\bestiary\protofleder.journal"
    )
  );

    this.template_list.difficulty_factor.minimum_count_easy = 1;
    this.template_list.difficulty_factor.maximum_count_easy = 1;
    this.template_list.difficulty_factor.minimum_count_medium = 1;
    this.template_list.difficulty_factor.maximum_count_medium = 1;
    this.template_list.difficulty_factor.minimum_count_hard = 1;
    this.template_list.difficulty_factor.maximum_count_hard = 1;

  

    this.trophy_names.PushBack('modrer_garkain_trophy_low');
    this.trophy_names.PushBack('modrer_garkain_trophy_medium');
    this.trophy_names.PushBack('modrer_garkain_trophy_high');

    this.ecosystem_delay_multiplier = 7;
    this.ecosystem_impact = (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(influences.kills_them) //CreatureHUMAN
      .influence(influences.no_influence) //CreatureARACHAS
      .influence(influences.no_influence) //CreatureENDREGA
      .influence(influences.low_bad_influence) //CreatureGHOUL
      .influence(influences.low_bad_influence) //CreatureALGHOUL
      .influence(influences.no_influence) //CreatureNEKKER
      .influence(influences.low_bad_influence) //CreatureDROWNER
      .influence(influences.low_bad_influence) //CreatureROTFIEND
      .influence(influences.no_influence) //CreatureWOLF
      .influence(influences.friend_with) //CreatureWRAITH
      .influence(influences.no_influence) //CreatureHARPY
      .influence(influences.no_influence) //CreatureSPIDER
      .influence(influences.no_influence) //CreatureCENTIPEDE
      .influence(influences.no_influence) //CreatureDROWNERDLC
      .influence(influences.no_influence) //CreatureBOAR
      .influence(influences.no_influence) //CreatureBEAR
      .influence(influences.no_influence) //CreaturePANTHER
      .influence(influences.no_influence) //CreatureSKELETON
      .influence(influences.no_influence) //CreatureECHINOPS
      .influence(influences.no_influence) //CreatureKIKIMORE
      .influence(influences.no_influence) //CreatureBARGHEST
      .influence(influences.no_influence) //CreatureSKELWOLF
      .influence(influences.no_influence) //CreatureSKELBEAR
      .influence(influences.no_influence) //CreatureWILDHUNT
      .influence(influences.no_influence) //CreatureBERSERKER
      .influence(influences.no_influence) //CreatureSIREN

      // large creatures below
      .influence(influences.no_influence) //CreatureDRACOLIZARD
      .influence(influences.no_influence) //CreatureGARGOYLE
      .influence(influences.no_influence) //CreatureLESHEN
      .influence(influences.low_bad_influence) //CreatureWEREWOLF
      .influence(influences.no_influence) //CreatureFIEND
      .influence(influences.friend_with) //CreatureEKIMMARA
      .influence(influences.friend_with) //CreatureKATAKAN
      .influence(influences.no_influence) //CreatureGOLEM
      .influence(influences.no_influence) //CreatureELEMENTAL
      .influence(influences.high_indirect_influence) //CreatureNIGHTWRAITH
      .influence(influences.high_indirect_influence) //CreatureNOONWRAITH
      .influence(influences.no_influence) //CreatureCHORT
      .influence(influences.no_influence) //CreatureCYCLOP
      .influence(influences.no_influence) //CreatureTROLL
      .influence(influences.no_influence) //CreatureHAG
      .influence(influences.no_influence) //CreatureFOGLET
      .influence(influences.friend_with) //CreatureBRUXA
      .influence(influences.self_influence) //CreatureFLEDER
      .influence(influences.friend_with) //CreatureGARKAIN
      .influence(influences.friend_with) //CreatureDETLAFF
      .influence(influences.no_influence) //CreatureGIANT
      .influence(influences.no_influence) //CreatureSHARLEY
      .influence(influences.no_influence) //CreatureWIGHT
      .influence(influences.kills_them) //CreatureGRYPHON
      .influence(influences.no_influence) //CreatureCOCKATRICE
      .influence(influences.no_influence) //CreatureBASILISK
      .influence(influences.no_influence) //CreatureWYVERN
      .influence(influences.no_influence) //CreatureFORKTAIL
      .influence(influences.no_influence) //CreatureSKELTROLL
      .build();

    this.possible_compositions.PushBack(CreatureGHOUL);
    this.possible_compositions.PushBack(CreatureALGHOUL);
    this.possible_compositions.PushBack(CreatureROTFIEND);
  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}
