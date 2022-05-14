
class RER_ContractModuleDialog extends CR4HudModuleDialog {

  var contract_manager: RER_ContractManager;
  
  function DialogueSliderDataPopupResult(value: float, optional isItemReward: bool) {
    super.DialogueSliderDataPopupResult(0,false);

    theGame.CloseMenu('PopupMenu');
    theInput.SetContext(thePlayer.GetExplorationInputContext());
    theGame.SetIsDialogOrCutscenePlaying(false);
    theGame.GetGuiManager().RequestMouseCursor(false);

    this.contract_manager.contractHaggleDifficultySelected(RER_ContractDifficulty((int)value));
  }

  function openDifficultySelectorWindow(contract_manager: RER_ContractManager, noticeboard: RER_NoticeboardIdentifier) {
    var noticeboard_reputation: int;
    var data: BettingSliderData;

    this.contract_manager = contract_manager;

    noticeboard_reputation = contract_manager.getNoticeboardReputation(noticeboard);

    data = new BettingSliderData in this;
    data.ScreenPosX = 0.62;
    data.ScreenPosY = 0.65;

    data.SetMessageTitle(GetLocStringByKey("rer_difficulty"));
		data.dialogueRef = this;
		data.BlurBackground = false;

    data.minValue = 0;
		data.maxValue = contract_manager.getMaximumDifficultyForReputation(noticeboard_reputation);
    data.currentValue = RoundF(data.maxValue / 2);

    theGame.RequestMenu('PopupMenu', data);
  }
}