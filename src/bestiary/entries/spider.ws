
class RER_BestiarySpider extends RER_BestiaryEntry {
  public function init() {
    var influences: RER_ConstantInfluences;
    influences = RER_ConstantInfluences();

    this.type = CreatureSPIDER;
    this.species = SpeciesTypes_INSECTOIDS;
    this.menu_name = 'Spiders';
    this.localized_name = 'option_rer_spider';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\ep1\data\characters\npc_entities\monsters\black_spider.w2ent",,,
      "gameplay\journal\bestiary\bestiarycrabspider.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\ep1\data\characters\npc_entities\monsters\black_spider_large.w2ent",2,,
      "gameplay\journal\bestiary\bestiarycrabspider.journal"
    )
  );

    this.template_list.difficulty_factor.minimum_count_easy = 2;
    this.template_list.difficulty_factor.maximum_count_easy = 3;
    this.template_list.difficulty_factor.minimum_count_medium = 2;
    this.template_list.difficulty_factor.maximum_count_medium = 3;
    this.template_list.difficulty_factor.minimum_count_hard = 3;
    this.template_list.difficulty_factor.maximum_count_hard = 4;

  

    this.trophy_names.PushBack('modrer_insectoid_trophy_low');
    this.trophy_names.PushBack('modrer_insectoid_trophy_medium');
    this.trophy_names.PushBack('modrer_insectoid_trophy_high');

    this.ecosystem_delay_multiplier = 4;
    this.ecosystem_impact = (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(influences.low_indirect_influence) //CreatureHUMAN
      .influence(influences.friend_with) //CreatureARACHAS
      .influence(influences.friend_with) //CreatureENDREGA
      .influence(influences.kills_them) //CreatureGHOUL
      .influence(influences.kills_them) //CreatureALGHOUL
      .influence(influences.kills_them) //CreatureNEKKER
      .influence(influences.kills_them) //CreatureDROWNER
      .influence(influences.kills_them) //CreatureROTFIEND
      .influence(influences.high_indirect_influence) //CreatureWOLF
      .influence(influences.no_influence) //CreatureWRAITH
      .influence(influences.no_influence) //CreatureHARPY
      .influence(influences.self_influence) //CreatureSPIDER
      .influence(influences.friend_with) //CreatureCENTIPEDE
      .influence(influences.kills_them) //CreatureDROWNERDLC
      .influence(influences.friend_with) //CreatureBOAR
      .influence(influences.friend_with) //CreatureBEAR
      .influence(influences.friend_with) //CreaturePANTHER
      .influence(influences.no_influence) //CreatureSKELETON
      .influence(influences.friend_with) //CreatureECHINOPS
      .influence(influences.friend_with) //CreatureKIKIMORE
      .influence(influences.no_influence) //CreatureBARGHEST
      .influence(influences.high_indirect_influence) //CreatureSKELWOLF
      .influence(influences.friend_with) //CreatureSKELBEAR
      .influence(influences.kills_them) //CreatureWILDHUNT
      .influence(influences.no_influence) //CreatureBERSERKER
      .influence(influences.no_influence) //CreatureSIREN

      // large creatures below
      .influence(influences.high_indirect_influence) //CreatureDRACOLIZARD
      .influence(influences.high_indirect_influence) //CreatureGARGOYLE
      .influence(influences.friend_with) //CreatureLESHEN
      .influence(influences.kills_them) //CreatureWEREWOLF
      .influence(influences.low_indirect_influence) //CreatureFIEND
      .influence(influences.low_indirect_influence) //CreatureEKIMMARA
      .influence(influences.low_indirect_influence) //CreatureKATAKAN
      .influence(influences.low_indirect_influence) //CreatureGOLEM
      .influence(influences.low_indirect_influence) //CreatureELEMENTAL
      .influence(influences.no_influence) //CreatureNIGHTWRAITH
      .influence(influences.no_influence) //CreatureNOONWRAITH
      .influence(influences.low_indirect_influence) //CreatureCHORT
      .influence(influences.low_indirect_influence) //CreatureCYCLOP
      .influence(influences.no_influence) //CreatureTROLL
      .influence(influences.kills_them) //CreatureHAG
      .influence(influences.kills_them) //CreatureFOGLET
      .influence(influences.kills_them) //CreatureBRUXA
      .influence(influences.low_indirect_influence) //CreatureFLEDER
      .influence(influences.low_indirect_influence) //CreatureGARKAIN
      .influence(influences.kills_them) //CreatureDETLAFF
      .influence(influences.low_indirect_influence) //CreatureGIANT
      .influence(influences.friend_with) //CreatureSHARLEY
      .influence(influences.no_influence) //CreatureWIGHT
      .influence(influences.low_indirect_influence) //CreatureGRYPHON
      .influence(influences.low_indirect_influence) //CreatureCOCKATRICE
      .influence(influences.low_indirect_influence) //CreatureBASILISK
      .influence(influences.low_indirect_influence) //CreatureWYVERN
      .influence(influences.low_indirect_influence) //CreatureFORKTAIL
      .influence(influences.low_indirect_influence) //CreatureSKELTROLL
      .build();
  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addDislikedBiome(BiomeSwamp)
    .addDislikedBiome(BiomeWater)
    .addLikedBiome(BiomeForest);
  }
}
