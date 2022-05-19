
state Loading in CRandomEncounters {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    LogChannel('modRandomEncounters', "Entering state LOADING");

    this.startLoading();
  }

  entry function startLoading() {
    if (theGame.GetInGameConfigWrapper().GetVarValue('RERoptionalFeatures', 'RERdelayLoadingStart')) {
      NLOG("Delaying RER loading start");

      Sleep(5);
    }

    parent.bounty_manager.bounty_master_manager.init(parent.bounty_manager);

    parent.static_encounter_manager.init(parent);

    RER_addNoticeboardInjectors();

    parent.refreshEcosystemFrequencyMultiplier();

    // give time for other mods to register their static encounters
    Sleep(10);

    // it's super important the mod takes control of the creatures BEFORE spawning
    // the static encounters, or else RER will consider creatures from static encounters
    // like HuntingGround encounters and because of the death threshold distance
    // it will kill them instantly. We don't want them to be killed.
    this.takeControlOfEntities();

    parent.static_encounter_manager.startSpawning();

    SU_updateMinimapPins();

    parent.addon_manager.init(parent);

    parent.GotoState('Waiting');
  }

  // the mod loses control of the previously spawned entities when the player
  // reloads. So when the mod is initialized it loops through all the RER entities
  // (thanks to a tag) and then finds groups of creatures and links them to a
  // HuntEntity manager that will control them again.
  private latent function takeControlOfEntities() {
    var rer_entity: RandomEncountersReworkedHuntingGroundEntity;
    var rer_entity_template: CEntityTemplate;
    var surrounding_entities: array<CGameplayEntity>;
    var entity_group: array<CEntity>;
    var entities: array<CEntity>;
    var entity: CEntity;
    var i, k: int;

    LogChannel('RER', "takeControlOfEntities()");


    theGame.GetEntitiesByTag('RandomEncountersReworked_Entity', entities);

    for (i = 0; i < entities.Size(); i += 1) {
      entity = entities[i];

      if (entity.HasTag('RandomEncountersReworked_ContractCreature')) {
        continue;
      }

      ((CNewNPC)entity).SetLevel(getRandomLevelBasedOnSettings(parent.settings));
      entity.RemoveTag('RER_controlled');
    }

    rer_entity_template = (CEntityTemplate)LoadResourceAsync(
      "dlc\modtemplates\randomencounterreworkeddlc\data\rer_hunting_ground_entity.w2ent",
      true
    );

    for (i = 0; i < entities.Size(); i += 1) {
      entity = entities[i];
      
      // RER has already taken control of this creature so we ignore it.
      if (entity.HasTag('RER_controlled') || entity.HasTag('RandomEncountersReworked_ContractCreature')) {
        continue;
      }

      surrounding_entities.Clear();

      FindGameplayEntitiesInRange(
        surrounding_entities,
        entity,
        20, // radius
        20, // max number of entities
        'RandomEncountersReworked_Entity', // tag
        FLAG_ExcludePlayer,
        thePlayer, // target
        'CNewNPC'
      );

      entity_group.Clear();

      // the goal here is to create a list of entities in the surrounding areas
      // that RER will take control of.
      for (k = 0; k < surrounding_entities.Size(); k += 1) {
        // RER has already taken control of this creature so we ignore it.
        if (entity.HasTag('RER_controlled')) {
          continue;
        }

        entity_group.PushBack(surrounding_entities[k]);

        surrounding_entities[k].AddTag('RER_controlled');
      }

      if (entity_group.Size() > 0) {
        rer_entity = (RandomEncountersReworkedHuntingGroundEntity)theGame.CreateEntity(rer_entity_template, entity.GetWorldPosition(), entity.GetWorldRotation());
        rer_entity.startEncounter(parent, entity_group, parent.bestiary.entries[parent.bestiary.getCreatureTypeFromEntity(entity)]);
        LogChannel('modRandomEncounters', "created a HuntingGround with " + entity_group.Size() + " RER entities");
      }
    }

    for (i = 0; i < entities.Size(); i += 1) {
      entities[i].RemoveTag('RER_controlled');
    }

    LogChannel('modRandomEncounters', "found " + entities.Size() + " RER entities");
  }
}

class SU_CustomPinRemoverPredicateFromRER extends SU_PredicateInterfaceRemovePin {
  function predicate(pin: SU_MapPin): bool {
    return StrStartsWith(pin.tag, "RER_");
  }
}

class SU_CustomPinRemovePredicateFromRERAndRegion extends SU_PredicateInterfaceRemovePin {
  var starts_with: string;
  default starts_with = "RER_";

  var position: Vector;

  var radius: float;
  default radius = 50;

  function predicate(pin: SU_MapPin): bool {
    return StrStartsWith(pin.tag, this.starts_with)
        && VecDistanceSquared2D(this.position, pin.position) < this.radius * this.radius;
  }
}

function RER_removePinsInAreaAndWithTag(tag_start: string, center: Vector, radius: float) {
  var predicate: SU_CustomPinRemovePredicateFromRERAndRegion;

  predicate = new SU_CustomPinRemovePredicateFromRERAndRegion in thePlayer;
  predicate.position = center;
  predicate.radius = radius;
  predicate.starts_with = tag_start;

  SU_removeCustomPinByPredicate(predicate);
}