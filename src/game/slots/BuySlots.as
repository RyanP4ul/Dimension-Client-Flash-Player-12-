package game.slots {
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;


public class BuySlots extends MovieClip {

    private var game:Game = Game.root;
    private var _qtySelector:QtySelectorMC;
    private var _currentSlot:String = "Bag Slots";
    private var _data:Object = [
        { "title": "Bag Slots", "desc": "Increase your backpack space to carry more weapons armors items and treasure Items in your backpack can be accessed at any time Adding Backpack space will permanently give you more room" },
        { "title": "Bank Slots", "desc": "You can safely store your most precious items in the bank This will give you more room for loot in your backpack while adventurin The bank can be accessed at major towns including Town Adding Bank space will permanently give you more room" },
        { "title": "House Slots", "desc": "Your house inventory is where you can find the furniture and houses you have collectedUse these items to customize your house or castle Click on the house icon or type house to go to your home Increasing your House Slots will permanently add more space" }
    ];

    public var tTitle:TextField;
    public var tDesc:TextField;
    public var tTag:TextField;
    public var tBuy:TextField;
    public var tMaximum:TextField;

    public var select:MovieClip;

    public var btnBagSlot:MovieClip;
    public var btnBankSlot:MovieClip;
    public var btnHouseSlot:MovieClip;

    public var btnBuy:SimpleButton;
    public var btnClose:SimpleButton;

    public function BuySlots() {
        btnBagSlot.buttonMode = true;
        btnBankSlot.buttonMode = true;
        btnHouseSlot.buttonMode = true;

        tBuy.mouseEnabled = false;
        tBuy.mouseWheelEnabled = false;

        tMaximum.visible = false;

        btnBagSlot.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        btnBankSlot.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        btnHouseSlot.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        btnBuy.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        btnClose.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);

        addEventListener(Event.ENTER_FRAME, onEnterFrame);

        update();
    }

    public function update() : void {
        var o:Object = getDataByTitle(_currentSlot);

        tTitle.text = o.title + " - " + getCountSlot();
        tDesc.text = o.desc;

        if (getChildByName("qty")) removeChild(getChildByName("qty"));

        if (isMaximum())
        {
            tMaximum.visible = true;
            tTag.visible = false;
            tBuy.visible = false;
            btnBuy.visible = false;
        }
        else
        {
            tMaximum.visible = false;
            tTag.visible = true;
            tBuy.visible = true;
            btnBuy.visible = true;

            _qtySelector = new QtySelectorMC(this, game, 1, getMaximum());
            _qtySelector.name = "qty";
            _qtySelector.width = 126;
            _qtySelector.height = 57.6;
            _qtySelector.x = 275.05;
            _qtySelector.y = 178.9;

            addChild(_qtySelector);
        }
    }

    private function onEnterFrame(event:Event) : void {
        if (this == null)
        {
            removeEventListener(Event.ENTER_FRAME, onEnterFrame);
        }
        else if (tBuy.visible)
        {
            tBuy.htmlText = _qtySelector.val * 200 + " <font color='#C0C0C0'>silver</font>";
        }
    }

    private function getCountSlot() : String {
        var slot:String = "0 / 0";

        switch (_currentSlot)
        {
            case "Bag Slots":
                slot = game.world.myAvatar.objData.iBagSlots + " / " + game.statsController.intBagSpaceCap;
                break;
            case "Bank Slots":
                slot = game.world.myAvatar.objData.iBankSlots + " / " + game.statsController.intBankSpaceCap;
                break;
            case "House Slots":
                slot = game.world.myAvatar.objData.iHouseSlots + " / " + game.statsController.intHouseSpaceCap;
                break;
        }

        return slot;
    }

    private function isMaximum() : Boolean {
        var slot:Boolean = false;

        switch (_currentSlot)
        {
            case "Bag Slots":
                slot = game.world.myAvatar.objData.iBagSlots >= game.statsController.intBagSpaceCap;
                break;
            case "Bank Slots":
                slot = game.world.myAvatar.objData.iBankSlots >= game.statsController.intBankSpaceCap;
                break;
            case "House Slots":
                slot = game.world.myAvatar.objData.iHouseSlots >= game.statsController.intHouseSpaceCap;
                break;
        }

        return slot;
    }

    private function getMaximum() : int {
        var slot:int = 0;

        switch (_currentSlot) {
            case "Bag Slots":
                slot = game.statsController.intBagSpaceCap - game.world.myAvatar.objData.iBagSlots;
                break;
            case "Bank Slots":
                slot = game.statsController.intBankSpaceCap - game.world.myAvatar.objData.iBankSlots;
                break;
            case "House Slots":
                slot = game.statsController.intHouseSpaceCap - game.world.myAvatar.objData.iHouseSlots;
                break;
        }

        return slot;
    }

    private function getDataByTitle(title:String) : Object {
        for each (var o:Object in _data) {
            if (o.title == title)
            {
                return o;
            }
        }

        return null;
    }

    public function fClose() : void {
        var m:MovieClip = MovieClip(parent);
        m.removeChild(this);
        m.onClose();
    }

    private function onClick(event:MouseEvent) : void {
        switch (event.currentTarget.name)
        {
            case "btnBagSlot":
                _currentSlot = "Bag Slots";
                select.y = btnBagSlot.y;
                update();
                break;
            case "btnBankSlot":
                _currentSlot = "Bank Slots";
                select.y = btnBankSlot.y;
                update();
                break;
            case "btnHouseSlot":
                _currentSlot = "House Slots";
                select.y = btnHouseSlot.y;
                update();
                break;
            case "btnBuy":
                if (game.world.myAvatar.objData.intSilver < _qtySelector.val * 200)
                {
                    game.Modal("You don't have enough Silver to make this purchase.", null, {}, "red,glow", "mono")
                }
                else
                {
                    game.net.send("buySlots", [_currentSlot, _qtySelector.val]);
                }
                break;
            case "btnClose":
                fClose();
                break;
        }
    }

}

}
