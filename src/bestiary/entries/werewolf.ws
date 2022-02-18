
class RER_BestiaryWerewolf extends RER_BestiaryEntry {
  public function init() {
    var influences: RER_ConstantInfluences;
    influences = RER_ConstantInfluences();

    this.type = CreatureWEREWOLF;
    this.species = SpeciesTypes_CURSED;
    this.menu_name = 'Werewolves';
    this.localized_name = 'option_rer_werewolf';

    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\werewolf_lvl1.w2ent",,,
        "gameplay\journal\bestiary\bestiarywerewolf.journal"
      )
    );
    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\werewolf_lvl2.w2ent",,,
        "gameplay\journal\bestiary\bestiarywerewolf.journal"
      )
    );
    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\werewolf_lvl3__lycan.w2ent",,,
        "gameplay\journal\bestiary\lycanthrope.journal"
      )
    );  
    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\werewolf_lvl4__lycan.w2ent",,,
        "gameplay\journal\bestiary\lycanthrope.journal"
      )
    );  
    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\werewolf_lvl5__lycan.w2ent",,,
        "gameplay\journal\bestiary\lycanthrope.journal"
      )
    ); 
    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\_quest__werewolf.w2ent",,,
        "gameplay\journal\bestiary\bestiarywerewolf.journal"
      )
    ); 
    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\_quest__werewolf_01.w2ent",,,
        "gameplay\journal\bestiary\bestiarywerewolf.journal"
      )
    ); 
    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\_quest__werewolf_02.w2ent",,,
        "gameplay\journal\bestiary\bestiarywerewolf.journal"
      )
    );

    this.template_list.difficulty_factor.minimum_count_easy = 1;
    this.template_list.difficulty_factor.maximum_count_easy = 1;
    this.template_list.difficulty_factor.minimum_count_medium = 1;
    this.template_list.difficulty_factor.maximum_count_medium = 1;
    this.template_list.difficulty_factor.minimum_count_hard = 1;
    this.template_list.difficulty_factor.maximum_count_hard = 1;

    this.trophy_names.PushBack('modrer_werewolf_trophy_low');
    this.trophy_names.PushBack('modrer_werewolf_trophy_medium');
    this.trophy_names.PushBack('modrer_werewolf_trophy_high');

    this.ecosystem_delay_multiplier = 10;
    this.ecosystem_impact = (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(influences.friend_with) //CreatureHUMAN
      .influence(influences.friend_with) //CreatureARACHAS
      .influence(influences.friend_with) //CreatureENDREGA
      .influence(influences.kills_them) //CreatureGHOUL
      .influence(influences.kills_them) //CreatureALGHOUL
      .influence(influences.kills_them) //CreatureNEKKER
      .influence(influences.kills_them) //CreatureDROWNER
      .influence(influences.kills_them) //CreatureROTFIEND
      .influence(influences.friend_with) //CreatureWOLF
      .influence(influences.no_influence) //CreatureWRAITH
      .influence(influences.friend_with) //CreatureHARPY
      .influence(influences.friend_with) //CreatureSPIDER
      .influence(influences.kills_them) //CreatureCENTIPEDE
      .influence(influences.kills_them) //CreatureDROWNERDLC
      .influence(influences.kills_them) //CreatureBOAR
      .influence(influences.kills_them) //CreatureBEAR
      .influence(influences.kills_them) //CreaturePANTHER
      .influence(influences.no_influence) //CreatureSKELETON
      .influence(influences.no_influence) //CreatureECHINOPS
      .influence(influences.no_influence) //CreatureKIKIMORE
      .influence(influences.no_influence) //CreatureBARGHEST
      .influence(influences.friend_with) //CreatureSKELWOLF
      .influence(influences.kills_them) //CreatureSKELBEAR
      .influence(influences.no_influence) //CreatureWILDHUNT
      .influence(influences.no_influence) //CreatureBERSERKER
      .influence(influences.no_influence) //CreatureSIREN

      // large creatures below
      .influence(influences.no_influence) //CreatureDRACOLIZARD
      .influence(influences.no_influence) //CreatureGARGOYLE
      .influence(influences.no_influence) //CreatureLESHEN
      .influence(influences.self_influence) //CreatureWEREWOLF
      .influence(influences.no_influence) //CreatureFIEND
      .influence(influences.no_influence) //CreatureEKIMMARA
      .influence(influences.no_influence) //CreatureKATAKAN
      .influence(influences.no_influence) //CreatureGOLEM
      .influence(influences.no_influence) //CreatureELEMENTAL
      .influence(influences.no_influence) //CreatureNIGHTWRAITH
      .influence(influences.no_influence) //CreatureNOONWRAITH
      .influence(influences.no_influence) //CreatureCHORT
      .influence(influences.no_influence) //CreatureCYCLOP
      .influence(influences.no_influence) //CreatureTROLL
      .influence(influences.kills_them) //CreatureHAG
      .influence(influences.kills_them) //CreatureFOGLET
      .influence(influences.no_influence) //CreatureBRUXA
      .influence(influences.no_influence) //CreatureFLEDER
      .influence(influences.no_influence) //CreatureGARKAIN
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

    this.possible_compositions.PushBack(CreatureWOLF);
    this.possible_compositions.PushBack(CreatureSKELWOLF);
    this.possible_compositions.PushBack(CreatureBERSERKER);
  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}
