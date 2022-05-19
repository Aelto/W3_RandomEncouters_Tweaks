state Talking in RER_BountyMasterManager {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    NLOG("RER_BountyMasterManager - Talking");

    this.Talking_main();
  }

  entry function Talking_main() {
    this.runConversation();
    parent.GotoState('Waiting');
  }

  latent function runConversation() {
    var npc_actor: CActor;
    var distance_from_player: float;
    var radius: float;
    var max_radius: float;
    var should_continue: bool;
    var shorten_conversation: bool;
    var grounded_position: Vector;

    npc_actor = (CActor)(parent.bounty_master_entity);
    max_radius = 10 * 10;

    // 1. first we wait for the player to get near enough so that the bounty master
    //    starts calling him.
    radius = 3 * 3;
    distance_from_player = VecDistanceSquared(
      thePlayer.GetWorldPosition(),
      parent.bounty_master_entity.GetWorldPosition()
    );

    while (distance_from_player > radius) {
      distance_from_player = VecDistanceSquared(
        thePlayer.GetWorldPosition(),
        parent.bounty_master_entity.GetWorldPosition()
      );

      SleepOneFrame();

      if (distance_from_player > max_radius) {
        return;
      }
    }

    if (false) { // graden dialogs
      shorten_conversation = theGame.GetInGameConfigWrapper()
        .GetVarValue('RERoptionalFeatures', 'RERshortenBountyMasterConversation');

      // we make sure the bounty master is perfectly visible and looks at the player
      grounded_position = npc_actor.GetWorldPosition();
      FixZAxis(grounded_position);
      npc_actor.TeleportWithRotation(
        grounded_position,
        VecToRotation(
          thePlayer.GetWorldPosition() - grounded_position
        )
      );

      // plays the voicelines only the first time the player meets Graden
      if (parent.bounty_manager.master.storages.bounty.bounty_level == 0) {
        should_continue = this.playDialogue(
          (new RER_RandomDialogBuilder in thePlayer).start()
          .dialog(new REROL_graden_youre_a_witcher_will_you_help in thePlayer, true),
          npc_actor,
          thePlayer
        );

        if (!should_continue) {
          return;
        }

        should_continue = this.playDialogue(
          (new RER_RandomDialogBuilder in thePlayer).start()
          .dialog(new REROL_i_am_dont_seen_notice in thePlayer, true),,
          npc_actor
        );

        if (!should_continue) {
          return;
        }

        should_continue = this.playDialogue(
          (new RER_RandomDialogBuilder in thePlayer).start()
          .dialog(new REROL_graden_noble_of_you_thank_you in thePlayer, true),
          npc_actor,
          thePlayer
        );

        if (!should_continue) {
          return;
        }

        should_continue = this.playDialogue(
          (new RER_RandomDialogBuilder in thePlayer).start()
          .dialog(new REROL_glad_you_know_who_i_am in thePlayer, true),,
          npc_actor
        );

        if (!should_continue) {
          return;
        }

        should_continue = this.playDialogue(
          (new RER_RandomDialogBuilder in thePlayer).start()
          .dialog(new REROL_graden_certain_youve_heard_of_us in thePlayer, true),
          npc_actor,
          thePlayer
        );

        if (!should_continue) {
          return;
        }

        should_continue = this.playDialogue(
          (new RER_RandomDialogBuilder in thePlayer).start()
          .dialog(new REROL_rings_a_bell in thePlayer, true),,
          npc_actor
        );

        if (!should_continue) {
          return;
        }

        should_continue = this.playDialogue(
          (new RER_RandomDialogBuilder in thePlayer).start()
        .dialog(new REROL_graden_matter_to_resolve in thePlayer, true),
          npc_actor,
          thePlayer
        );

        if (!should_continue) {
          return;
        }

        should_continue = this.playDialogue(
          (new RER_RandomDialogBuilder in thePlayer).start()
          .dialog(new REROL_mhm_2 in thePlayer, true),,
          npc_actor
        );

        if (!should_continue) {
          return;
        }
      }
      else {
        should_continue = this.playDialogue(
          (new RER_RandomDialogBuilder in thePlayer).start()
          .dialog(new REROL_graden_witcher in thePlayer, true),
          npc_actor,
          thePlayer
        );

        if (!should_continue) {
          return;
        }

        should_continue = this.playDialogue(
          (new RER_RandomDialogBuilder in thePlayer).start()
          .dialog(new REROL_greetings in thePlayer, true),,
          npc_actor
        );

        if (!should_continue) {
          return;
        }
      }

      should_continue = this.playDialogue(
        (new RER_RandomDialogBuilder in thePlayer).start()
        .either(new REROL_what_surprise_new_monster_to_kill in thePlayer, true, 1)
        .either(new REROL_lemme_guess_monster_needs_killing in thePlayer, true, 1),,
        npc_actor
      );

      if (!should_continue) {
        return;
      }

      if (!shorten_conversation) {
        should_continue = this.playDialogue(
          (new RER_RandomDialogBuilder in thePlayer).start()
          .dialog(new REROL_graden_ive_lost_five_men in thePlayer, true),
          npc_actor,
          thePlayer
        );

        if (!should_continue) {
          return;
        }

        should_continue = this.playDialogue(
          (new RER_RandomDialogBuilder in thePlayer).start()
          .dialog(new REROL_i_see_the_wounds in thePlayer, true)
          .dialog(new REROL_any_witnesses in thePlayer, true),,
          npc_actor
        );

        if (!should_continue) {
          return;
        }

        should_continue = this.playDialogue(
          (new RER_RandomDialogBuilder in thePlayer).start()
          .either(new REROL_graden_didnt_sound_like_wolves in thePlayer, true, 1)
          .either(new REROL_graden_looked_a_fiend in thePlayer, true, 1),
          npc_actor,
          thePlayer
        );

        if (!should_continue) {
          return;
        }
      }

      should_continue = this.playDialogue(
        (new RER_RandomDialogBuilder in thePlayer).start()
        .dialog(new REROL_mhm_2 in thePlayer, true)
        .then(0.2),,
        npc_actor
      );

      if (!should_continue) {
        return;
      }

      if (!shorten_conversation && RandRange(10) > 5) {
        should_continue = this.playDialogue(
          (new RER_RandomDialogBuilder in thePlayer).start()
          .dialog(new REROL_really_helpful_that in thePlayer, true),,
          npc_actor
        );

        if (!should_continue) {
          return;
        }
      }

      should_continue = this.playDialogue(
        (new RER_RandomDialogBuilder in thePlayer).start()
        .either(new REROL_fine_show_me_where_monsters in thePlayer, true, 1)
        .either(new REROL_fine_ill_see_what_i_can_do in thePlayer, true, 1),,
        npc_actor
      );

      if (!should_continue) {
        return;
      }

      should_continue = this.playDialogue(
        (new RER_RandomDialogBuilder in thePlayer).start()
        .dialog(new REROL_graden_eternal_fire_protect_you in thePlayer, true),
        npc_actor,
        thePlayer
      );

      if (!should_continue) {
        return;
      }

      should_continue = this.playDialogue(
        (new RER_RandomDialogBuilder in thePlayer).start()
        .dialog(new REROL_farewell in thePlayer, true),,
        npc_actor
      );

      if (!should_continue) {
        return;
      }
    }

    parent.GotoState('SeedSelection');
  }

  private function shouldCancelDialogue(squared_radius: float): bool {
    return VecDistanceSquared(
      thePlayer.GetWorldPosition(),
      parent.bounty_master_entity.GetWorldPosition()
    ) > squared_radius;
  }

  private latent function playDialogue(dialog_builder: RER_RandomDialogBuilder, optional npc: CActor, optional interlocutor: CActor): bool {
    if (this.shouldCancelDialogue(3 * 3)) {
      (new RER_RandomDialogBuilder in thePlayer).start()
        .dialog(new REROL_graden_eternal_fire_protect_you in thePlayer, true)
        .play((CActor)(parent.bounty_master_entity), false, thePlayer);

      (new RER_RandomDialogBuilder in thePlayer).start()
        .dialog(new REROL_farewell in thePlayer, true)
        .play(, false, (CActor)(parent.bounty_master_entity));

      return false;
    }

    dialog_builder
    // the .then() is to add a small delay between the talking actors
    .then(RandF())
    .play(npc, false, interlocutor);

    return true;
  }
}