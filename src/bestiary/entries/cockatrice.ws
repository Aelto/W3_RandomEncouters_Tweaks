
class RER_BestiaryCockatrice extends RER_BestiaryEntry {
  public function init() {
    var influences: RER_ConstantInfluences;
    influences = RER_ConstantInfluences();

    this.type = CreatureCOCKATRICE;
    this.species = SpeciesTypes_DRACONIDS;
    this.menu_name = 'Cockatrices';
    this.localized_name = 'option_rer_cockatrice';

    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\cockatrice_lvl1.w2ent",,,
        "gameplay\journal\bestiary\bestiarycockatrice.journal"
      )
    );

    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\cockatrice_mh.w2ent",,,
        "gameplay\journal\bestiary\bestiarycockatrice.journal"
      )
    );

      this.template_list.difficulty_factor.minimum_count_easy = 1;
      this.template_list.difficulty_factor.maximum_count_easy = 1;
      this.template_list.difficulty_factor.minimum_count_medium = 1;
      this.template_list.difficulty_factor.maximum_count_medium = 1;
      this.template_list.difficulty_factor.minimum_count_hard = 1;
      this.template_list.difficulty_factor.maximum_count_hard = 1;

    this.trophy_names.PushBack('modrer_cockatrice_trophy_low');
    this.trophy_names.PushBack('modrer_cockatrice_trophy_medium');
    this.trophy_names.PushBack('modrer_cockatrice_trophy_high');

    this.ecosystem_delay_multiplier = 13.5;
    this.ecosystem_impact = (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(influences.kills_them) //CreatureHUMAN
      .influence(influences.no_influence) //CreatureARACHAS
      .influence(influences.no_influence) //CreatureENDREGA
      .influence(influences.no_influence) //CreatureGHOUL
      .influence(influences.no_influence) //CreatureALGHOUL
      .influence(influences.no_influence) //CreatureNEKKER
      .influence(influences.no_influence) //CreatureDROWNER
      .influence(influences.no_influence) //CreatureROTFIEND
      .influence(influences.kills_them) //CreatureWOLF
      .influence(influences.no_influence) //CreatureWRAITH
      .influence(influences.no_influence) //CreatureHARPY
      .influence(influences.no_influence) //CreatureSPIDER
      .influence(influences.kills_them) //CreatureCENTIPEDE
      .influence(influences.no_influence) //CreatureDROWNERDLC
      .influence(influences.kills_them) //CreatureBOAR
      .influence(influences.kills_them) //CreatureBEAR
      .influence(influences.kills_them) //CreaturePANTHER
      .influence(influences.no_influence) //CreatureSKELETON
      .influence(influences.no_influence) //CreatureECHINOPS
      .influence(influences.no_influence) //CreatureKIKIMORE
      .influence(influences.no_influence) //CreatureBARGHEST
      .influence(influences.kills_them) //CreatureSKELWOLF
      .influence(influences.kills_them) //CreatureSKELBEAR
      .influence(influences.no_influence) //CreatureWILDHUNT
      .influence(influences.kills_them) //CreatureBERSERKER
      .influence(influences.no_influence) //CreatureSIREN

      // large creatures below
      .influence(influences.low_bad_influence) //CreatureDRACOLIZARD
      .influence(influences.no_influence) //CreatureGARGOYLE
      .influence(influences.low_bad_influence) //CreatureLESHEN
      .influence(influences.low_bad_influence) //CreatureWEREWOLF
      .influence(influences.low_bad_influence) //CreatureFIEND
      .influence(influences.low_bad_influence) //CreatureEKIMMARA
      .influence(influences.low_bad_influence) //CreatureKATAKAN
      .influence(influences.no_influence) //CreatureGOLEM
      .influence(influences.no_influence) //CreatureELEMENTAL
      .influence(influences.no_influence) //CreatureNIGHTWRAITH
      .influence(influences.no_influence) //CreatureNOONWRAITH
      .influence(influences.no_influence) //CreatureCHORT
      .influence(influences.high_indirect_influence) //CreatureCYCLOP
      .influence(influences.no_influence) //CreatureTROLL
      .influence(influences.no_influence) //CreatureHAG
      .influence(influences.no_influence) //CreatureFOGLET
      .influence(influences.no_influence) //CreatureBRUXA
      .influence(influences.no_influence) //CreatureFLEDER
      .influence(influences.no_influence) //CreatureGARKAIN
      .influence(influences.no_influence) //CreatureDETLAFF
      .influence(influences.high_indirect_influence) //CreatureGIANT
      .influence(influences.high_bad_influence) //CreatureSHARLEY
      .influence(influences.no_influence) //CreatureWIGHT
      .influence(influences.low_bad_influence) //CreatureGRYPHON
      .influence(influences.self_influence) //CreatureCOCKATRICE
      .influence(influences.low_bad_influence) //CreatureBASILISK
      .influence(influences.low_bad_influence) //CreatureWYVERN
      .influence(influences.low_bad_influence) //CreatureFORKTAIL
      .influence(influences.no_influence) //CreatureSKELTROLL
      .build();

    this.possible_compositions.PushBack(CreatureWYVERN);
    this.possible_compositions.PushBack(CreatureFORKTAIL);
    this.possible_compositions.PushBack(CreatureHARPY);
    this.possible_compositions.PushBack(CreatureSIREN);
  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}
