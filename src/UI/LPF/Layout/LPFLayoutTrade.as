package UI.LPF.Layout {
import UI.LPF.Panel.LPFPanelTradePanel;

import flash.display.MovieClip;

public class LPFLayoutTrade extends LPFLayout  {

    public var iSel:Object;
    public var bSel:Object;
    public var cSel:Object;
    public var itemsInv:Array;
    public var splitPanel:MovieClip;
    public var game:Game = Game.root;
    public var notify:Boolean;

    public function LPFLayoutTrade() {
        x = 0;
        y = 0;
        panels = [];
        fData = {};
    }

    override public function fOpen(_arg_1:Object):void
    {
        var _local_2:Object;
        var _local_3:Object;
        var _local_4:MovieClip;
        notify = true;
        fData = _arg_1.fData;
        sMode = _arg_1.sMode;

        if (("itemsInv" in fData))
        {
            itemsInv = fData.itemsInv;
        }

        _local_2 = _arg_1.r;

        x = _local_2.x;
        y = _local_2.y;
        w = _local_2.w;
        h = _local_2.h;
        _local_3 = {};
        _local_3.panel = new LPFPanelTradePanel();
        _local_3.fData = {
            "itemsInv": itemsInv,
            "itemsB": fData.itemsB,
            "itemsC": fData.itemsC,
            "objData": fData.objData
        };
        _local_3.r = {
            "x":-10,
            "y":60,
            "w":900,
            "h":400
        };
        _local_3.isOpen = true;
        splitPanel = addPanel(_local_3);

        game.dropStackBoost();
    }

    override public function fClose():void
    {
        var _local_1:MovieClip;
        game.dropStackReset();
        while (panels.length > 0)
        {
            panels[0].mc.fClose();
            panels.shift();
        }
        if (parent != null)
        {
            _local_1 = MovieClip(parent);
            _local_1.removeChild(this);
            _local_1.onClose();
        }

        if (notify)
        {
            game.net.send("tradeCancel", [fData.tradeId]);
        }
    }

    override protected function handleUpdate(o:Object):Object
    {
        var _local_2:Object;
        var cancelBroadcast:Boolean;
        var _local_6:Object;
        trace(("LayoutTrade.handleUpdate > " + o.eventType));
        var iSelPrev:Object = iSel;
        var _local_5:Object = bSel;

        if (o.eventType == "listItemASel")
        {
            iSel = o.fData;

            if (iSelPrev == iSel) iSel = null;

            o.fData = {"iSel":iSel};
        }
        if (o.eventType == "offerSel")
        {
            bSel = o.fData;
            if (_local_5 == bSel) bSel = null;
            o.fData = {"bSel":bSel};
        }
        if (o.eventType == "otherSel")
        {
            cSel = o.fData;
            if (_local_5 == cSel) cSel = null;
            o.fData = {"cSel":cSel};
        }
        if (o.eventType == "categorySelMyOffer")
        {
            bSel = null;
            if (game.world.tradeController.tradeHasRequested(o.fData.types))
            {
                trace("  Drawing Trade locally");
                o.eventType = "refreshBank";
            }
            else
            {
                o.fData.loadPending = true;
                o.fData.msg = "Loading...";
                trace("  Sending Trade request");
                game.world.tradeController.sendLoadOfferRequest(o.fData.types);
            }
        }
        if (o.eventType == "refreshBank") {}
        if (o.eventType == "refreshInventory") {}
        if (o.eventType == "refreshItems") {}
        if (o.eventType == "lockOffer")
        {
            trace("LOCK OFFER > " + JSON.stringify(fData));
            trace("TRADE CONTROLLER > " + JSON.stringify(fData));
            game.net.send("tradeLock", [fData.tradeId, game.world.tradeController.ctrlTrade.txtMyCopper.text, game.world.tradeController.ctrlTrade.txtMySilver.text, game.world.tradeController.ctrlTrade.txtMyGold.text]);
        }
        if (o.eventType == "unlockOffer")
        {
            game.net.send("tradeUnlock", [fData.tradeId]);
        }
        if (o.eventType == "completeTrade")
        {
            game.net.send("tradeDeal", [fData.tradeId]);
        }
        if (o.eventType == "sendTradeFromInvRequest")
        {
            trace("  Sending Inv->Trade request");
            trace(("  Quantity: " + iSel.iQty));
            var qty:int = ((iSel.iQty != null) ? iSel.iQty : 1);
            if (qty > 1)
            {
                game.Modal("Please specify item quantity you want to trade.", function (o:Object):void
                {
                    if (o.accept)
                    {
                        trace(("iqty: " + o.iQty));
                        iSel.TradeID = fData.tradeId;
                        iSel.Quantity = 1;
                        if (o.iQty != null) iSel.Quantity = o.iQty;
                        game.world.tradeController.sendTradeFromInvRequest(iSel);
                        iSel = null;
                    }
                }, {}, "white,medium", null, true, {min: 1, max: qty})
            }
            else
            {
                iSel.TradeID = fData.tradeId;
                iSel.Quantity = qty;
                game.world.tradeController.sendTradeFromInvRequest(iSel);
                iSel = null;
            }
        }
        if (o.eventType == "sendTradeToInvRequest")
        {
            trace("  Sending Trade->Inv request");
            bSel.TradeID = fData.tradeId;
            game.world.tradeController.sendTradeToInvRequest(bSel);
            bSel = null;
        }
        if (o.eventType == "sendTradeSwapInvRequest")
        {
            trace("  Sending Inv<->Trade request");
            bSel.TradeID = fData.tradeId;
            game.world.tradeController.sendTradeSwapInvRequest(bSel, iSel);
            iSel = null;
            bSel = null;
        }

        updatePreviewButtons();

        iSelPrev = null;

        if (!cancelBroadcast) return (o);

        return null;
    }

    private function updatePreviewButtons(_arg_1:Object=null, _arg_2:Object=null):void
    {
        var _local_3:Object = {};
        if (((!(_arg_1 == null)) && (!(_arg_2 == null))))
        {
            _local_3 = _arg_2;
        }
        else
        {
            _local_3.eventType = "previewButton1Update";
            _local_3.fData = {};
            _local_3.fData.sText = "";
            _local_3.sMode = "grey";
            _local_3.buttonNewEventType = "";
            if (((!(iSel == null)) && (bSel == null)))
            {
                _local_3.fData.sText = "Add to Offer >";
                _local_3.buttonNewEventType = "sendTradeFromInvRequest";
                _local_3.sMode = "red";
            }
            else
            {
                if (((iSel == null) && (!(bSel == null))))
                {
                    _local_3.fData.sText = "< To Inventory";
                    _local_3.buttonNewEventType = "sendTradeToInvRequest";
                    _local_3.sMode = "red";
                }
                else
                {
                    _local_3.fData.sText = "";
                    _local_3.buttonNewEventType = "";
                }
            }
        }
        notifyByEventType(_local_3);
    }

    public function getTabStates(_arg_1:Object=null):Array
    {
        var _local_3:Object;
        var _local_2:Array = [{
            "sTag":"Show All",
            "icon":"iipack",
            "state":-1,
            "filter":"*",
            "mc":{}
        }, {
            "sTag":"Show only weapons",
            "icon":"iwsword",
            "state":-1,
            "filter":"Weapon",
            "mc":{}
        }, {
            "sTag":"Show only armor",
            "icon":"iiclass",
            "state":-1,
            "filter":"ar",
            "mc":{}
        }, {
            "sTag":"Show only helms",
            "icon":"iihelm",
            "state":-1,
            "filter":"he",
            "mc":{}
        }, {
            "sTag":"Show only capes",
            "icon":"iicape",
            "state":-1,
            "filter":"ba",
            "mc":{}
        }, {
            "sTag":"Show only pets",
            "icon":"iipet",
            "state":-1,
            "filter":"pe",
            "mc":{}
        }, {
            "sTag":"Show only amulets",
            "icon":"iin1",
            "state":-1,
            "filter":"am",
            "mc":{}
        }, {
            "sTag":"Show only items",
            "icon":"iibag",
            "state":-1,
            "filter":"it",
            "mc":{}
        }, {
            "sTag":"Show only enhancements",
            "icon":"iidesign",
            "state":-1,
            "filter":"enh",
            "mc":{}
        }];
        if (_arg_1 != null)
        {
            for each (_local_3 in _local_2)
            {
                if (_local_3.filter == _arg_1.sES)
                {
                    return ([_local_3]);
                }
            }
            return ([_local_2[0]]);
        }
        return (_local_2);
    }

}
}
