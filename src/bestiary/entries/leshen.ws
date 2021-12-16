
class RER_BestiaryLeshen extends RER_BestiaryEntry {
  public function init() {
    var influences: RER_ConstantInfluences;
    influences = RER_ConstantInfluences();

    this.type = CreatureLESHEN;
    this.species = SpeciesTypes_RELICTS;
    this.menu_name = 'Leshens';
    this.localized_name = 'option_rer_leshen';

    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\lessog_lvl1.w2ent",,,
        "gameplay\journal\bestiary\leshy1.journal"
      )
    );
    
    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\lessog_lvl2__ancient.w2ent",,,
        "gameplay\journal\bestiary\sq204ancientleszen.journal" // TODO: seems bugged
      )
    );

    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\lessog_mh.w2ent",,,
        "gameplay\journal\bestiary\bestiarymonsterhuntmh302.journal" // TODO: seems bugged
      )
    );
    
    if(theGame.GetDLCManager().IsEP2Available() && theGame.GetDLCManager().IsEP2Enabled()){
      this.template_list.templates.PushBack(
        makeEnemyTemplate(
          "dlc\bob\data\characters\npc_entities\monsters\spriggan.w2ent",,,
          "dlc\bob\journal\bestiary\mq7002spriggan.journal"
        )
      );
    }

    this.ecosystem_delay_multiplier = 15;
    this.ecosystem_impact = (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(influences.kills_them) //CreatureHUMAN
      .influence(influences.friend_with) //CreatureARACHAS
      .influence(influences.friend_with) //CreatureENDREGA
      .influence(influences.kills_them) //CreatureGHOUL
      .influence(influences.kills_them) //CreatureALGHOUL
      .influence(influences.kills_them) //CreatureNEKKER
      .influence(influences.kills_them) //CreatureDROWNER
      .influence(influences.kills_them) //CreatureROTFIEND
      .influence(influences.friend_with) //CreatureWOLF
      .influence(influences.kills_them) //CreatureWRAITH
      .influence(influences.kills_them) //CreatureHARPY
      .influence(influences.friend_with) //CreatureSPIDER
      .influence(influences.friend_with) //CreatureCENTIPEDE
      .influence(influences.kills_them) //CreatureDROWNERDLC
      .influence(influences.friend_with) //CreatureBOAR
      .influence(influences.friend_with) //CreatureBEAR
      .influence(influences.friend_with) //CreaturePANTHER
      .influence(influences.kills_them) //CreatureSKELETON
      .influence(influences.friend_with) //CreatureECHINOPS
      .influence(influences.friend_with) //CreatureKIKIMORE
      .influence(influences.kills_them) //CreatureBARGHEST
      .influence(influences.friend_with) //CreatureSKELWOLF
      .influence(influences.friend_with) //CreatureSKELBEAR
      .influence(influences.kills_them) //CreatureWILDHUNT
      .influence(influences.friend_with) //CreatureBERSERKER
      .influence(influences.kills_them) //CreatureSIREN

      // large creatures below
      .influence(influences.kills_them) //CreatureDRACOLIZARD
      .influence(influences.kills_them) //CreatureGARGOYLE
      .influence(influences.self_influence) //CreatureLESHEN
      .influence(influences.kills_them) //CreatureWEREWOLF
      .influence(influences.kills_them) //CreatureFIEND
      .influence(influences.kills_them) //CreatureEKIMMARA
      .influence(influences.kills_them) //CreatureKATAKAN
      .influence(influences.kills_them) //CreatureGOLEM
      .influence(influences.kills_them) //CreatureELEMENTAL
      .influence(influences.kills_them) //CreatureNIGHTWRAITH
      .influence(influences.kills_them) //CreatureNOONWRAITH
      .influence(influences.kills_them) //CreatureCHORT
      .influence(influences.kills_them) //CreatureCYCLOP
      .influence(influences.kills_them) //CreatureTROLL
      .influence(influences.kills_them) //CreatureHAG
      .influence(influences.kills_them) //CreatureFOGLET
      .influence(influences.kills_them) //CreatureBRUXA
      .influence(influences.kills_them) //CreatureFLEDER
      .influence(influences.kills_them) //CreatureGARKAIN
      .influence(influences.kills_them) //CreatureDETLAFF
      .influence(influences.kills_them) //CreatureGIANT
      .influence(influences.kills_them) //CreatureSHARLEY
      .influence(influences.kills_them) //CreatureWIGHT
      .influence(influences.kills_them) //CreatureGRYPHON
      .influence(influences.kills_them) //CreatureCOCKATRICE
      .influence(influences.kills_them) //CreatureBASILISK
      .influence(influences.kills_them) //CreatureWYVERN
      .influence(influences.kills_them) //CreatureFORKTAIL
      .influence(influences.kills_them) //CreatureSKELTROLL
      .build();

    this.template_list.difficulty_factor.minimum_count_easy = 1;
    this.template_list.difficulty_factor.maximum_count_easy = 1;
    this.template_list.difficulty_factor.minimum_count_medium = 1;
    this.template_list.difficulty_factor.maximum_count_medium = 1;
    this.template_list.difficulty_factor.minimum_count_hard = 1;
    this.template_list.difficulty_factor.maximum_count_hard = 1;

    this.trophy_names.PushBack('modrer_leshen_trophy_low');
    this.trophy_names.PushBack('modrer_leshen_trophy_medium');
    this.trophy_names.PushBack('modrer_leshen_trophy_high');

    this.possible_compositions.PushBack(CreatureWOLF);
    this.possible_compositions.PushBack(CreatureSKELWOLF);
  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addOnlyBiome(BiomeForest);
  }
}
