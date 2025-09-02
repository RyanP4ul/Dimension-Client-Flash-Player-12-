package game.controller {
import UI.ModalMC;

import flash.display.MovieClip;

public class TradeController {

    private var game:Game = Game.root;

    public var tradeId:String = "-1";
    public var ctrlTrade:MovieClip;
    public var tradeItem1:MovieClip;
    public var tradeItem2:MovieClip;
    public var tradeItem3:MovieClip;

    public var tradeinfo:Object = {
        "itemsA":[],
        "itemsB":[],
        "hasRequested":{}
    };

    public function tradeHasRequested(lists:Array):Boolean
    {
        var str:String;
        for each (str in lists)
        {
            if (!(str in this.tradeinfo.hasRequested))
            {
                return false;
            }
        }
        return true;
    }

    public function addItemsToTradeA(_arg_1:Array):void
    {
        var _local_2:Object;
        var _local_3:Object;
        var _local_4:Boolean;
        _local_4 = true;
        for each (_local_2 in _arg_1)
        {
            _local_4 = true;
            for each (_local_3 in this.tradeinfo.itemsA)
            {
                if (_local_3.ItemID == _local_2.ItemID)
                {
                    trace("Existed");
                    _local_3.iQty = _local_2.iQty;
                    _local_4 = false;
                    break;
                }
            }
            if (_local_4)
            {
                this.tradeinfo.itemsA.push(_local_2);
            }
        }
    }

    public function addItemsToTradeB(_arg_1:Array):void
    {
        var _local_2:Object;
        var _local_3:Object;
        var _local_4:Boolean;
        _local_4 = true;
        for each (_local_2 in _arg_1)
        {
            _local_4 = true;
            for each (_local_3 in this.tradeinfo.itemsB)
            {
                if (_local_3.ItemID == _local_2.ItemID)
                {
                    _local_4 = false;
                    break;
                }
            }
            if (_local_4)
            {
                this.tradeinfo.itemsB.push(_local_2);
            }
        }
    }

    public function replyToTradeInvite(_arg_1:Object):void
    {
        if (_arg_1.accept)
        {
            this.sendTradeInviteAccept();
        }
        else
        {
            this.sendTradeInviteDecline();
        }
    }

    public function sendTradeInviteAccept():void
    {
        game.net.send("ti", ["1"]);
    }

    public function sendTradeInviteDecline():void
    {
        game.net.send("ti", ["0"]);
    }

    public function sendTradeInvite(_arg_1:String):void
    {
        game.net.send("ti", [_arg_1]);
    }

    public function doTradeAccept(o:Object):void
    {
        if (o.accept)
        {
            game.net.send("tia", [o.unm]);
        }
        else
        {
            game.net.send("tid", [o.unm]);
        }
    }

    public function sendTradeFromInvRequest(o:Object) : void
    {
        var _local_2:ModalMC;
        var _local_3:Object;
        if (o.bEquip == 1)
        {
            _local_2 = new ModalMC();
            _local_3 = {};
            _local_3.strBody = "You must unequip the item before offering it!";
            _local_3.params = {};
            _local_3.glow = "red,medium";
            _local_3.btns = "mono";
            game.ui.ModalStack.addChild(_local_2);
            _local_2.init(_local_3);
        }
        else
        {
            game.net.send("tradeFromInv", [o.ItemID, o.CharItemID, o.TradeID, o.Quantity]);
        }
    }

    public function sendTradeToInvRequest(_arg_1:Object) : void
    {
        game.net.send("tradeToInv", [_arg_1.ItemID, _arg_1.CharItemID, _arg_1.TradeID]);
    }

    public function sendTradeSwapInvRequest(_arg_1:Object, _arg_2:Object) : void
    {
        var _local_3:ModalMC;
        var _local_4:Object;
        if (_arg_2.bEquip == 1)
        {
            _local_3 = new ModalMC();
            _local_4 = {};
            _local_4.strBody = "You must unequip the item before offering it!";
            _local_4.params = {};
            _local_4.glow = "red,medium";
            _local_4.btns = "mono";
            game.ui.ModalStack.addChild(_local_3);
            _local_3.init(_local_4);
        }
        else
        {
            game.net.send("tradeSwapInv", [_arg_2.ItemID, _arg_2.CharItemID, _arg_1.ItemID, _arg_1.CharItemID, _arg_1.TradeID]);
        }
    }

    public function sendLoadOfferRequest(_arg_1:Array=null):void
    {
        var _local_2:String;
        if (_arg_1[0] == "*")
        {
            _arg_1 = ["All"];
        }
        for each (_local_2 in _arg_1)
        {
            tradeinfo.hasRequested[_local_2] = true;
        }
        game.net.send("loadOffer", _arg_1);
    }

}
}
