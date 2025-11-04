package features.companion {

public class CompanionController {

    public function AddCompanion(data:Object):void {
        var companionPanel:CompanionPanel = new CompanionPanel();
        companionPanel.name = data.Name;
        companionPanel.strName.text = data.Name;
        companionPanel.strLevel.text = "Lv. " + data.Level;
        companionPanel.HP.strIntHP.text = data.intHPMax;
        companionPanel.MP.strIntMP.text = data.intMPMax;
        companionPanel.y = Game.root.ui.mcCompanionFrame.numChildren * (companionPanel.height + 5);
        Game.root.ui.mcCompanionFrame.addChild(companionPanel)
    }

}
}
