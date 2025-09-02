package game.panel {

import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.MouseEvent;
import flash.text.TextField;

public class LPFPanelBg5 extends MovieClip  {

    private var game:Game = Game.root;

    public var tTitle:TextField;
    public var tPane1:TextField;
    public var tPane2:TextField;
    public var tPane3:TextField;
    public var tPane4:TextField;
    public var txtLock:TextField;

    public var txtMyCopper:TextField;
    public var txtMySilver:TextField;
    public var txtMyGold:TextField;
    public var txtTargetCopper:TextField;
    public var txtTargetSilver:TextField;
    public var txtTargetGold:TextField;

    public var bg:MovieClip;
    public var dragonRight:MovieClip;
    public var dragonLeft:MovieClip;

    public var btnClose:SimpleButton;
    public var btnLock:SimpleButton;
    public var btnDeal:SimpleButton;

    public function LPFPanelBg5() {
        tTitle.mouseEnabled = false;
        tPane1.mouseEnabled = false;
        tPane2.mouseEnabled = false;
        tPane3.mouseEnabled = false;
        tPane4.mouseEnabled = false;
        txtLock.mouseEnabled = false;

        txtMyCopper.restrict = "0-9";
        txtMySilver.restrict = "0-9";
        txtMyGold.restrict = "0-9";

        txtTargetCopper.mouseEnabled = false;
        txtTargetSilver.mouseEnabled = false;
        txtTargetGold.mouseEnabled = false;

        btnDeal.alpha = 0.5;
        btnDeal.mouseEnabled = false;

        btnLock.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        btnDeal.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);

        game.world.tradeController.ctrlTrade = this;
    }

    private function onClick(event:MouseEvent) : void
    {
        game.mixer.playSound("Click");

        switch (event.currentTarget.name)
        {
            case "btnLock":
                if (txtLock.text == "Lock")
                {
                    if (txtMyCopper.length == 0) txtMyCopper.text = "0";
                    if (txtMySilver.length == 0) txtMySilver.text = "0";
                    if (txtMyGold.length == 0) txtMyGold.text = "0";

                    MovieClip(game.ui.mcPopup.getChildByName("mcTrade")).update({"eventType":"lockOffer"});
                }
                else
                {
                    MovieClip(game.ui.mcPopup.getChildByName("mcTrade")).update({"eventType":"unlockOffer"});
                }
                break;
            case "btnDeal":
                MovieClip(game.ui.mcPopup.getChildByName("mcTrade")).update({"eventType":"completeTrade"});
                break;
        }
    }

}

}
