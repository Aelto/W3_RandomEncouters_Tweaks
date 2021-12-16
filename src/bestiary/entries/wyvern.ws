
class RER_BestiaryWyvern extends RER_BestiaryEntry {
  public function init() {
    var influences: RER_ConstantInfluences;
    influences = RER_ConstantInfluences();

    this.type = CreatureWYVERN;
    this.species = SpeciesTypes_DRACONIDS;
    this.menu_name = 'Wyverns';
    this.localized_name = 'option_rer_wyvern';

    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\wyvern_lvl1.w2ent",,,
        "gameplay\journal\bestiary\bestiarywyvern.journal"
      )
    );
    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\wyvern_lvl2.w2ent",,,
        "gameplay\journal\bestiary\bestiarywyvern.journal"
      )
    );

      this.template_list.difficulty_factor.minimum_count_easy = 1;
      this.template_list.difficulty_factor.maximum_count_easy = 1;
      this.template_list.difficulty_factor.minimum_count_medium = 1;
      this.template_list.difficulty_factor.maximum_count_medium = 1;
      this.template_list.difficulty_factor.minimum_count_hard = 1;
      this.template_list.difficulty_factor.maximum_count_hard = 1;

    this.trophy_names.PushBack('modrer_wyvern_trophy_low');
    this.trophy_names.PushBack('modrer_wyvern_trophy_medium');
    this.trophy_names.PushBack('modrer_wyvern_trophy_high');

    this.ecosystem_delay_multiplier = 7.5;
    this.ecosystem_impact = (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(influences.kills_them) //CreatureHUMAN
      .influence(influences.no_influence) //CreatureARACHAS
      .influence(influences.no_influence) //CreatureENDREGA
      .influence(influences.low_indirect_influence) //CreatureGHOUL
      .influence(influences.low_indirect_influence) //CreatureALGHOUL
      .influence(influences.kills_them) //CreatureNEKKER
      .influence(influences.no_influence) //CreatureDROWNER
      .influence(influences.no_influence) //CreatureROTFIEND
      .influence(influences.kills_them) //CreatureWOLF
      .influence(influences.high_indirect_influence) //CreatureWRAITH
      .influence(influences.friend_with) //CreatureHARPY
      .influence(influences.no_influence) //CreatureSPIDER
      .influence(influences.no_influence) //CreatureCENTIPEDE
      .influence(influences.no_influence) //CreatureDROWNERDLC
      .influence(influences.kills_them) //CreatureBOAR
      .influence(influences.kills_them) //CreatureBEAR
      .influence(influences.kills_them) //CreaturePANTHER
      .influence(influences.low_indirect_influence) //CreatureSKELETON
      .influence(influences.no_influence) //CreatureECHINOPS
      .influence(influences.no_influence) //CreatureKIKIMORE
      .influence(influences.no_influence) //CreatureBARGHEST
      .influence(influences.kills_them) //CreatureSKELWOLF
      .influence(influences.kills_them) //CreatureSKELBEAR
      .influence(influences.no_influence) //CreatureWILDHUNT
      .influence(influences.no_influence) //CreatureBERSERKER
      .influence(influences.friend_with) //CreatureSIREN

      // large creatures below
      .influence(influences.high_indirect_influence) //CreatureDRACOLIZARD
      .influence(influences.friend_with) //CreatureGARGOYLE
      .influence(influences.high_indirect_influence) //CreatureLESHEN
      .influence(influences.high_indirect_influence) //CreatureWEREWOLF
      .influence(influences.high_indirect_influence) //CreatureFIEND
      .influence(influences.high_indirect_influence) //CreatureEKIMMARA
      .influence(influences.high_indirect_influence) //CreatureKATAKAN
      .influence(influences.high_indirect_influence) //CreatureGOLEM
      .influence(influences.high_indirect_influence) //CreatureELEMENTAL
      .influence(influences.high_indirect_influence) //CreatureNIGHTWRAITH
      .influence(influences.high_indirect_influence) //CreatureNOONWRAITH
      .influence(influences.high_indirect_influence) //CreatureCHORT
      .influence(influences.no_influence) //CreatureCYCLOP
      .influence(influences.friend_with) //CreatureTROLL
      .influence(influences.no_influence) //CreatureHAG
      .influence(influences.no_influence) //CreatureFOGLET
      .influence(influences.no_influence) //CreatureBRUXA
      .influence(influences.no_influence) //CreatureFLEDER
      .influence(influences.no_influence) //CreatureGARKAIN
      .influence(influences.high_indirect_influence) //CreatureDETLAFF
      .influence(influences.high_indirect_influence) //CreatureGIANT
      .influence(influences.high_indirect_influence) //CreatureSHARLEY
      .influence(influences.high_indirect_influence) //CreatureWIGHT
      .influence(influences.high_indirect_influence) //CreatureGRYPHON
      .influence(influences.high_indirect_influence) //CreatureCOCKATRICE
      .influence(influences.high_indirect_influence) //CreatureBASILISK
      .influence(influences.self_influence) //CreatureWYVERN
      .influence(influences.friend_with) //CreatureFORKTAIL
      .influence(influences.friend_with) //CreatureSKELTROLL
      .build();

    this.possible_compositions.PushBack(CreatureFORKTAIL);
    this.possible_compositions.PushBack(CreatureWYVERN);
    this.possible_compositions.PushBack(CreatureHARPY);
    this.possible_compositions.PushBack(CreatureSIREN);
  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}
