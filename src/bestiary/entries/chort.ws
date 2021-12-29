
class RER_BestiaryChort extends RER_BestiaryEntry {
  public function init() {
    var influences: RER_ConstantInfluences;
    influences = RER_ConstantInfluences();

    this.type = CreatureCHORT;
    this.species = SpeciesTypes_RELICTS;
    this.menu_name = 'Chorts';
    this.localized_name = 'option_rer_chort';

    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\czart_lvl1.w2ent",,,
        "gameplay\journal\bestiary\czart.journal"
      )
    );

      this.template_list.difficulty_factor.minimum_count_easy = 1;
      this.template_list.difficulty_factor.maximum_count_easy = 1;
      this.template_list.difficulty_factor.minimum_count_medium = 1;
      this.template_list.difficulty_factor.maximum_count_medium = 1;
      this.template_list.difficulty_factor.minimum_count_hard = 1;
      this.template_list.difficulty_factor.maximum_count_hard = 1;

    this.trophy_names.PushBack('modrer_fiend_trophy_low');
    this.trophy_names.PushBack('modrer_fiend_trophy_medium');
    this.trophy_names.PushBack('modrer_fiend_trophy_high');

    this.ecosystem_delay_multiplier = 10;
    this.ecosystem_impact = (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(influences.kills_them) //CreatureHUMAN
      .influence(influences.friend_with) //CreatureARACHAS
      .influence(influences.friend_with) //CreatureENDREGA
      .influence(influences.low_bad_influence) //CreatureGHOUL
      .influence(influences.low_bad_influence) //CreatureALGHOUL
      .influence(influences.low_indirect_influence) //CreatureNEKKER
      .influence(influences.low_bad_influence) //CreatureDROWNER
      .influence(influences.low_bad_influence) //CreatureROTFIEND
      .influence(influences.kills_them) //CreatureWOLF
      .influence(influences.no_influence) //CreatureWRAITH
      .influence(influences.no_influence) //CreatureHARPY
      .influence(influences.friend_with) //CreatureSPIDER
      .influence(influences.friend_with) //CreatureCENTIPEDE
      .influence(influences.low_bad_influence) //CreatureDROWNERDLC
      .influence(influences.kills_them) //CreatureBOAR
      .influence(influences.kills_them) //CreatureBEAR
      .influence(influences.kills_them) //CreaturePANTHER
      .influence(influences.no_influence) //CreatureSKELETON
      .influence(influences.low_indirect_influence) //CreatureECHINOPS
      .influence(influences.low_indirect_influence) //CreatureKIKIMORE
      .influence(influences.no_influence) //CreatureBARGHEST
      .influence(influences.kills_them) //CreatureSKELWOLF
      .influence(influences.kills_them) //CreatureSKELBEAR
      .influence(influences.kills_them) //CreatureWILDHUNT
      .influence(influences.kills_them) //CreatureBERSERKER
      .influence(influences.no_influence) //CreatureSIREN

      // large creatures below
      .influence(influences.low_bad_influence) //CreatureDRACOLIZARD
      .influence(influences.low_bad_influence) //CreatureGARGOYLE
      .influence(influences.friend_with) //CreatureLESHEN
      .influence(influences.low_bad_influence) //CreatureWEREWOLF
      .influence(influences.kills_them) //CreatureFIEND
      .influence(influences.no_influence) //CreatureEKIMMARA
      .influence(influences.no_influence) //CreatureKATAKAN
      .influence(influences.low_bad_influence) //CreatureGOLEM
      .influence(influences.low_bad_influence) //CreatureELEMENTAL
      .influence(influences.no_influence) //CreatureNIGHTWRAITH
      .influence(influences.no_influence) //CreatureNOONWRAITH
      .influence(influences.self_influence) //CreatureCHORT
      .influence(influences.no_influence) //CreatureCYCLOP
      .influence(influences.no_influence) //CreatureTROLL
      .influence(influences.kills_them) //CreatureHAG
      .influence(influences.kills_them) //CreatureFOGLET
      .influence(influences.no_influence) //CreatureBRUXA
      .influence(influences.no_influence) //CreatureFLEDER
      .influence(influences.no_influence) //CreatureGARKAIN
      .influence(influences.no_influence) //CreatureDETLAFF
      .influence(influences.high_bad_influence) //CreatureGIANT
      .influence(influences.high_bad_influence) //CreatureSHARLEY
      .influence(influences.no_influence) //CreatureWIGHT
      .influence(influences.low_bad_influence) //CreatureGRYPHON
      .influence(influences.low_bad_influence) //CreatureCOCKATRICE
      .influence(influences.low_bad_influence) //CreatureBASILISK
      .influence(influences.low_bad_influence) //CreatureWYVERN
      .influence(influences.low_bad_influence) //CreatureFORKTAIL
      .influence(influences.no_influence) //CreatureSKELTROLL
      .build();

    this.possible_compositions.PushBack(CreatureFIEND);
    this.possible_compositions.PushBack(CreatureNEKKER);
  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addLikedBiome(BiomeSwamp);
  }
}
