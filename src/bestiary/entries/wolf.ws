
class RER_BestiaryWolf extends RER_BestiaryEntry {
  public function init() {
    var influences: RER_ConstantInfluences;
    influences = RER_ConstantInfluences();

    this.type = CreatureWOLF;
    this.species = SpeciesTypes_BEASTS;
    this.menu_name = 'Wolves';
    this.localized_name = 'option_rer_wolf';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\wolf_lvl1.w2ent",,,
      "gameplay\journal\bestiary\wolf.journal"
    )
  );        // +4 lvls  grey/black wolf STEEL
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\wolf_lvl1__alpha.w2ent", 1,,
      "gameplay\journal\bestiary\wolf.journal"
    )
  );    // +4 lvls brown warg      STEEL

    this.template_list.difficulty_factor.minimum_count_easy = 2;
    this.template_list.difficulty_factor.maximum_count_easy = 3;
    this.template_list.difficulty_factor.minimum_count_medium = 2;
    this.template_list.difficulty_factor.maximum_count_medium = 4;
    this.template_list.difficulty_factor.minimum_count_hard = 3;
    this.template_list.difficulty_factor.maximum_count_hard = 6;

  

    this.trophy_names.PushBack('modrer_beast_trophy_low');
    this.trophy_names.PushBack('modrer_beast_trophy_medium');
    this.trophy_names.PushBack('modrer_beast_trophy_high');

    this.ecosystem_delay_multiplier = 1.25;
    this.ecosystem_impact = (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(influences.high_indirect_influence) //CreatureHUMAN
      .influence(influences.low_indirect_influence) //CreatureARACHAS
      .influence(influences.low_indirect_influence) //CreatureENDREGA
      .influence(influences.low_bad_influence) //CreatureGHOUL
      .influence(influences.low_bad_influence) //CreatureALGHOUL
      .influence(influences.high_indirect_influence) //CreatureNEKKER
      .influence(influences.low_bad_influence) //CreatureDROWNER
      .influence(influences.low_bad_influence) //CreatureROTFIEND
      .influence(influences.self_influence) //CreatureWOLF
      .influence(influences.no_influence) //CreatureWRAITH
      .influence(influences.no_influence) //CreatureHARPY
      .influence(influences.low_indirect_influence) //CreatureSPIDER
      .influence(influences.low_indirect_influence) //CreatureCENTIPEDE
      .influence(influences.no_influence) //CreatureDROWNERDLC
      .influence(influences.friend_with) //CreatureBOAR
      .influence(influences.friend_with) //CreatureBEAR
      .influence(influences.friend_with) //CreaturePANTHER
      .influence(influences.no_influence) //CreatureSKELETON
      .influence(influences.friend_with) //CreatureECHINOPS
      .influence(influences.friend_with) //CreatureKIKIMORE
      .influence(influences.no_influence) //CreatureBARGHEST
      .influence(influences.self_influence) //CreatureSKELWOLF
      .influence(influences.friend_with) //CreatureSKELBEAR
      .influence(influences.low_bad_influence) //CreatureWILDHUNT
      .influence(influences.friend_with) //CreatureBERSERKER
      .influence(influences.no_influence) //CreatureSIREN

      // large creatures below
      .influence(influences.no_influence) //CreatureDRACOLIZARD
      .influence(influences.friend_with) //CreatureGARGOYLE
      .influence(influences.friend_with) //CreatureLESHEN
      .influence(influences.friend_with) //CreatureWEREWOLF
      .influence(influences.no_influence) //CreatureFIEND
      .influence(influences.low_bad_influence) //CreatureEKIMMARA
      .influence(influences.low_bad_influence) //CreatureKATAKAN
      .influence(influences.low_indirect_influence) //CreatureGOLEM
      .influence(influences.low_indirect_influence) //CreatureELEMENTAL
      .influence(influences.no_influence) //CreatureNIGHTWRAITH
      .influence(influences.no_influence) //CreatureNOONWRAITH
      .influence(influences.high_indirect_influence) //CreatureCHORT
      .influence(influences.low_bad_influence) //CreatureCYCLOP
      .influence(influences.friend_with) //CreatureTROLL
      .influence(influences.low_bad_influence) //CreatureHAG
      .influence(influences.low_bad_influence) //CreatureFOGLET
      .influence(influences.low_bad_influence) //CreatureBRUXA
      .influence(influences.low_bad_influence) //CreatureFLEDER
      .influence(influences.low_bad_influence) //CreatureGARKAIN
      .influence(influences.low_bad_influence) //CreatureDETLAFF
      .influence(influences.low_bad_influence) //CreatureGIANT
      .influence(influences.low_bad_influence) //CreatureSHARLEY
      .influence(influences.low_bad_influence) //CreatureWIGHT
      .influence(influences.friend_with) //CreatureGRYPHON
      .influence(influences.friend_with) //CreatureCOCKATRICE
      .influence(influences.friend_with) //CreatureBASILISK
      .influence(influences.friend_with) //CreatureWYVERN
      .influence(influences.friend_with) //CreatureFORKTAIL
      .influence(influences.friend_with) //CreatureSKELTROLL
      .build();
  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addLikedBiome(BiomeForest);
  }
}
