package UI.LPF.Layout {

import UI.LPF.Panel.LPFPanelListShopInvA;
import UI.LPF.Panel.LPFPanelListShopInvB;
import UI.LPF.Panel.LPFPanelPreview;

import flash.display.MovieClip;
import flash.events.Event;

import game.controller.OutfitController;

public class LPFLayoutOutfit extends LPFLayout  {

    public var iSel:Object;
    public var itemsInv:Array;
    public var multiPanel:MovieClip;
    public var splitPanel:MovieClip;
    public var previewPanel:MovieClip;
    public var game:Game = Game.root;

    public function LPFLayoutOutfit() {
        x = 0;
        y = 0;
        panels = [];
        fData = {};
    }

    override public function fOpen(o:Object) : void {
        var sName:String = "Inventory";

        fData = o.fData;
        sMode = o.sMode;

        if ("itemsInv" in fData) itemsInv = fData.itemsInv;
        if ("sName" in fData) sName = fData.sName;

        x = o.r.x;
        y = o.r.y;
        w = o.r.w;
        h = o.r.w;
        tempFill();

        var frame:Object = {};
        frame.panel = new LPFPanelListShopInvB();
        frame.fData = { "items": itemsInv, "sName": "Outfit Inventory" };
        frame.r = { "x":322, "y":3, "w":316, "h":495 };
        frame.closeType = "hide";
        frame.hideDir = "right";
        frame.hidePad = 3;
        frame.isOpen = false;

        splitPanel = addPanel(frame);
        splitPanel.visible = false;
        splitPanel.fHide();

        frame = {};
        frame.panel = new LPFPanelPreview();
        frame.fData = { sName : "Preview" };
        frame.r = {
            "x":322,
            "y":28,
            "w":316,
            "h":470
        };
        frame.closeType = "hide";
        frame.xBuffer = 3;
        frame.showDragonLeft = true;
        frame.isOpen = false;
        previewPanel = addPanel(frame);
        previewPanel.visible = false;
        previewPanel.addEventListener(Event.ENTER_FRAME, previewPanelEF, false, 0, true);

        frame = {};
        frame.panel = new LPFPanelListShopInvA();
        frame.fData = {
            "items" : itemsInv,
            "itemsInv" : itemsInv,
            "objData" : fData.objData,
            "sName": sName
        };

        frame.r = {"x":641, "y":3, "w":316, "h":495 };
        frame.closeType = "close";
        frame.showDragonRight = true;
        frame.isOpen = true;
        multiPanel = addPanel(frame);

        game.dropStackBoost();
        updatePreviewButtons();
    }

    override public function fClose() : void {
        var _local_1:MovieClip;
        game.dropStackReset();
        previewPanel.removeEventListener(Event.ENTER_FRAME, previewPanelEF);
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
    }

    override protected function handleUpdate(o:Object) : Object {
        var p:Object;
        var cancelBroadcast:Boolean;
        var iSelPrev:Object = iSel;
        var forceO:Object;
        var forceP:Object;

        previewPanel.bg.tTitle.text = "Preview";

        trace("OUTFIT => HANDLE UPDATE => " + o.eventType);

        if (o.eventType == "listItemASel")
        {
            if (!game.isGreedyModalInStack())
            {
                iSel = null;

                if (previewPanel.bg.bg.filters.length > 0) previewPanel.bg.bg.filters = [];

                iSel = o.fData;

                o.tabStates = getTabStates(o.fData);

                o.fData = {
                    "iSel":iSel,
                    "oSel":o.fData
                };

                splitPanel.fHide();
                previewPanel.fShow();

                if (iSelPrev == iSel) cancelBroadcast = true;
            }
            else
            {
                cancelBroadcast = true;
            }
        }
        if (o.eventType == "refreshItems")
        {
            if (itemsInv.indexOf(iSel) == -1) iSel = null;

            o.fData = {
                "iSel": iSel
            };

            if (("sInstruction" in o))
            {
                if (o.sInstruction == "closeWindows")
                {
                    splitPanel.fHide();
                    previewPanel.fHide();
                }
                if (o.sInstruction == "previewEquipOnly")
                {
                    splitPanel.fHide();
                    if (((!(iSel == null)) && (!(iSel.bEquip == 1))))
                    {
                        forceO = {};
                        forceO.eventType = "previewButton1Update";
                        forceO.fData = {};
                        forceO.fData.sText = "Equip";
                        forceO.sMode = "red";
                        forceO.r = {
                            "x":-1,
                            "y":-40,
                            "w":-1,
                            "h":-1
                        };
                        forceO.buttonNewEventType = "equipItem";
                        forceP = {};
                        forceP.eventType = "previewButton2Update";
                        forceP.fData = {};
                        forceP.fData.sText = "";
                        forceP.sMode = "grey";
                        forceP.r = {
                            "x":173,
                            "y":-40,
                            "w":-1,
                            "h":-1
                        };
                    }
                    else
                    {
                        previewPanel.fHide();
                    }
                }
            }
            if (iSel == null)
            {
                splitPanel.fHide();
                previewPanel.fHide();
            }
        }
        if (o.eventType == "unequipOutfit" || o.eventType == "equipOutfit")
        {
            if (!game.isGreedyModalInStack())
            {
                if (iSel != null)
                {
                    if (OutfitController.toggleEquipOutfitItem(iSel) && o.eventType == "equipOutfit")
                    {
                        splitPanel.fHide();
                        previewPanel.fHide();
                    }
                }
            }
            else
            {
                cancelBroadcast = true;
            }
        }

        iSelPrev = null;

        updatePreviewButtons();

        return !cancelBroadcast ? o : null;
    }

    private function updatePreviewButtons(_arg_1:Object=null, _arg_2:Object=null):void
    {
        var _local_3:Object = {};
        var _local_4:Object = {};
        if (((!(_arg_1 == null)) && (!(_arg_2 == null))))
        {
            _local_3 = _arg_1;
            _local_4 = _arg_2;
        }
        else
        {
            _local_3.eventType = "previewButton1Update";
            _local_3.fData = {};
            _local_3.fData.sText = "";
            _local_3.sMode = "grey";
            _local_3.r = {
                "x":46,
                "y":-40,
                "w":-1,
                "h":-1
            };
            _local_3.buttonNewEventType = "";
            _local_4.eventType = "previewButton2Update";
            _local_4.fData = {};
            _local_4.fData.sText = "";
            _local_4.sMode = "grey";
            _local_4.r = {
                "x":173,
                "y":-40,
                "w":-1,
                "h":-1
            };
            _local_4.buttonNewEventType = "";
            if (sMode == "outfit")
            {
                _local_3.fData.sText = "";
                _local_3.buttonNewEventType = "";
                _local_4.fData.sText = "";
                _local_4.buttonNewEventType = "";

                if (iSel != null)
                {
                    if (iSel.bEquip == 1)
                    {
                        _local_4.fData.sText = "Unequip!";
                        _local_4.sMode = "red";
                        _local_4.buttonNewEventType = "unequipOutfit";
                    }
                    else
                    {
                        _local_4.fData.sText = "Equip!";
                        _local_4.sMode = "red";
                        _local_4.buttonNewEventType = "equipOutfit";
                    }
                }
            }
        }
        notifyByEventType(_local_3);
        notifyByEventType(_local_4);
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

    private function previewPanelEF(_arg_1:Event):void
    {
        var prevPanelX:Number = previewPanel.x;
        var buffer:Number = ((splitPanel.x - previewPanel.w) - previewPanel.xBuffer);
        var total:Number = (buffer - prevPanelX);
        if (total > 20 || splitPanel.visible)
        {
            previewPanel.x = ((splitPanel.x - previewPanel.w) - previewPanel.xBuffer);
        }
    }

}
}
