
state DifficultySelection in RER_ContractManager {

  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    NLOG("RER_ContractManager - state DifficultySelection");

    this.DifficultySelection_main();
  }

  entry function DifficultySelection_main() {
    this.DifficultySelection_displayDifficultyHaggleModule();
  }

  private function DifficultySelection_displayDifficultyHaggleModule() {
    var noticeboard_identifier: RER_NoticeboardIdentifier;
    var haggle_module_dialog: RER_ContractModuleDialog;

    theGame.CloseMenu('NoticeBoardMenu');
    theInput.SetContext(thePlayer.GetExplorationInputContext());
    theGame.SetIsDialogOrCutscenePlaying(false);
    theGame.GetGuiManager().RequestMouseCursor(false);

    noticeboard_identifier = parent.getUniqueIdFromNoticeboard(parent.getNearbyNoticeboard());

    haggle_module_dialog = new RER_ContractModuleDialog in parent;
    haggle_module_dialog.openDifficultySelectorWindow(parent, noticeboard_identifier);
  }
}