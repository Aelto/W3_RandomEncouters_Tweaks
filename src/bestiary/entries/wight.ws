
class RER_BestiaryWight extends RER_BestiaryEntry {
  public function init() {
    var influences: RER_ConstantInfluences;
    influences = RER_ConstantInfluences();

    this.type = CreatureWIGHT;
    this.species = SpeciesTypes_CURSED;
    this.menu_name = 'Wights';
    this.localized_name = 'option_rer_wight';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\spooncollector.w2ent",1,,
      "dlc\bob\journal\bestiary\wicht.journal"
    )
  );  // spoon
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\wicht.w2ent",2,,
      "dlc\bob\journal\bestiary\wicht.journal"
    )
  );     // wight

    this.template_list.difficulty_factor.minimum_count_easy = 1;
    this.template_list.difficulty_factor.maximum_count_easy = 1;
    this.template_list.difficulty_factor.minimum_count_medium = 1;
    this.template_list.difficulty_factor.maximum_count_medium = 1;
    this.template_list.difficulty_factor.minimum_count_hard = 1;
    this.template_list.difficulty_factor.maximum_count_hard = 1;

  

    this.trophy_names.PushBack('modrer_wight_trophy_low');
    this.trophy_names.PushBack('modrer_wight_trophy_medium');
    this.trophy_names.PushBack('modrer_wight_trophy_high');

    this.ecosystem_delay_multiplier = 4.5;
    this.ecosystem_impact = (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(influences.low_bad_influence) //CreatureHUMAN
      .influence(influences.no_influence) //CreatureARACHAS
      .influence(influences.no_influence) //CreatureENDREGA
      .influence(influences.friend_with) //CreatureGHOUL
      .influence(influences.friend_with) //CreatureALGHOUL
      .influence(influences.no_influence) //CreatureNEKKER
      .influence(influences.no_influence) //CreatureDROWNER
      .influence(influences.friend_with) //CreatureROTFIEND
      .influence(influences.no_influence) //CreatureWOLF
      .influence(influences.friend_with) //CreatureWRAITH
      .influence(influences.no_influence) //CreatureHARPY
      .influence(influences.no_influence) //CreatureSPIDER
      .influence(influences.no_influence) //CreatureCENTIPEDE
      .influence(influences.friend_with) //CreatureDROWNERDLC
      .influence(influences.no_influence) //CreatureBOAR
      .influence(influences.no_influence) //CreatureBEAR
      .influence(influences.no_influence) //CreaturePANTHER
      .influence(influences.friend_with) //CreatureSKELETON
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
      .influence(influences.no_influence) //CreatureWEREWOLF
      .influence(influences.no_influence) //CreatureFIEND
      .influence(influences.no_influence) //CreatureEKIMMARA
      .influence(influences.no_influence) //CreatureKATAKAN
      .influence(influences.no_influence) //CreatureGOLEM
      .influence(influences.no_influence) //CreatureELEMENTAL
      .influence(influences.friend_with) //CreatureNIGHTWRAITH
      .influence(influences.friend_with) //CreatureNOONWRAITH
      .influence(influences.no_influence) //CreatureCHORT
      .influence(influences.no_influence) //CreatureCYCLOP
      .influence(influences.no_influence) //CreatureTROLL
      .influence(influences.no_influence) //CreatureHAG
      .influence(influences.no_influence) //CreatureFOGLET
      .influence(influences.no_influence) //CreatureBRUXA
      .influence(influences.no_influence) //CreatureFLEDER
      .influence(influences.no_influence) //CreatureGARKAIN
      .influence(influences.no_influence) //CreatureDETLAFF
      .influence(influences.no_influence) //CreatureGIANT
      .influence(influences.no_influence) //CreatureSHARLEY
      .influence(influences.self_influence) //CreatureWIGHT
      .influence(influences.no_influence) //CreatureGRYPHON
      .influence(influences.no_influence) //CreatureCOCKATRICE
      .influence(influences.no_influence) //CreatureBASILISK
      .influence(influences.no_influence) //CreatureWYVERN
      .influence(influences.no_influence) //CreatureFORKTAIL
      .influence(influences.no_influence) //CreatureSKELTROLL
      .build();

    this.possible_compositions.PushBack(CreatureBARGHEST);
    this.possible_compositions.PushBack(CreatureWRAITH);
  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addLikedBiome(BiomeSwamp)
    .addLikedBiome(BiomeWater)
    .addDislikedBiome(BiomeForest);
  }
}
