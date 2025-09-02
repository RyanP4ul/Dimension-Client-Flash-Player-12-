package UI.LPF.Layout
{

import UI.LPF.Panel.LPFPanelHousePreview;
import UI.LPF.Panel.LPFPanelListShopInvA;
import UI.LPF.Panel.LPFPanelListShopInvB;

import flash.display.MovieClip;
import flash.events.Event;

public class LPFLayoutHouseInvShop extends LPFLayout
{

    private var aSel:String = "";
    private var bSel:String = "";
    public var iQty:int = 1;
    public var iSel:Object;
    public var eSel:Object;
    public var shopinfo:Object;
    public var itemsInv:Array;
    public var itemsShop:Array;
    public var multiPanel:MovieClip;
    public var splitPanel:MovieClip;
    public var previewPanel:MovieClip;
    public var game:Game;

    public function LPFLayoutHouseInvShop():void
    {
        x = 0;
        y = 0;
        panels = [];
        fData = {};
    }

    override public function fOpen(o:Object):void
    {
        var r:Object;
        var panelDef:Object;
        var lastPanel:MovieClip;
        game = Game.root;
        fData = o.fData;
        sMode = o.sMode;
        if (("itemsInv" in fData))
        {
            itemsInv = fData.itemsInv;
        }
        if (("itemsShop" in fData))
        {
            itemsShop = fData.itemsShop;
        }
        if (("shopinfo" in fData))
        {
            shopinfo = fData.shopinfo;
        }
        r = o.r;
        var s:String = "";
        x = r.x;
        y = r.y;
        w = r.w;
        h = r.h;
        tempFill();
        panelDef = {};
        panelDef.panel = new LPFPanelListShopInvB();
        s = "House Inventory";
        panelDef.fData = {
            "items":itemsInv,
            "sName":s
        };
        panelDef.r = {
            "x":322,
            "y":3,
            "w":316,
            "h":650
        };
        panelDef.closeType = "hide";
        panelDef.hideDir = "right";
        panelDef.hidePad = 3;
        panelDef.isOpen = false;
        splitPanel = addPanel(panelDef);
        splitPanel.visible = false;
        splitPanel.fHide();
        panelDef = {};
        panelDef.panel = new LPFPanelHousePreview();
        s = "Preview";
        panelDef.fData = {"sName":s};
        panelDef.r = {
            "x":322,
            "y":78,
            "w":316,
            "h":420
        };
        panelDef.closeType = "hide";
        panelDef.xBuffer = 3;
        panelDef.showDragonLeft = true;
        panelDef.isOpen = false;
        previewPanel = addPanel(panelDef);
        previewPanel.visible = false;
        previewPanel.addEventListener(Event.ENTER_FRAME, previewPanelEF, false, 0, true);
        panelDef = {};
        panelDef.panel = new LPFPanelListShopInvA();
        s = ((sMode.toLowerCase().indexOf("shop") > -1) ? game.world.shopinfo.sName : "House Inventory");
        panelDef.fData = {
            "items":((itemsShop != null) ? itemsShop : itemsInv),
            "itemsInv":itemsInv,
            "objData":fData.objData,
            "sName":s
        };
        if (shopinfo != null)
        {
            panelDef.fData.shopinfo = shopinfo;
        }
        panelDef.r = {
            "x":641,
            "y":3,
            "w":316,
            "h":650
        };
        panelDef.closeType = "close";
        panelDef.showDragonRight = true;
        panelDef.isOpen = true;
        multiPanel = addPanel(panelDef);
        updatePreviewButtons();
        game.dropStackBoost();
    }

    override public function fClose():void
    {
        var parentMC:MovieClip;
        game.dropStackReset();
        previewPanel.removeEventListener(Event.ENTER_FRAME, previewPanelEF);
        while (panels.length > 0)
        {
            panels[0].mc.fClose();
            panels.shift();
        }
        if (parent != null)
        {
            parentMC = MovieClip(parent);
            parentMC.removeChild(this);
            parentMC.onClose();
        }
    }

    override protected function handleUpdate(o:Object):Object
    {
        var p:Object;
        var newList:Array;
        var sellSel:Object;
        var modal:* = undefined;
        var modalO:* = undefined;
        trace(("LayoutINVENH.handleUpdate > " + o.eventType));
        var cancelBroadcast:Boolean;
        var iSelPrev:Object = iSel;
        var eSelPrev:Object = eSel;
        var forceO:Object;
        var forceP:Object;
        if (((!(iSel == null)) && (!(eSel == null))))
        {
            previewPanel.bg.tTitle.text = "Create";
        }
        else
        {
            previewPanel.bg.tTitle.text = "Preview";
        }
        if (o.eventType == "equipHouse")
        {
            if (!game.isGreedyModalInStack())
            {
                if (iSel != null)
                {
                    game.world.equipHouse(iSel);
                    splitPanel.fHide();
                    previewPanel.fHide();
                }
            }
            else
            {
                cancelBroadcast = true;
            }
        }
        if (o.eventType == "sModeSet")
        {
            if (sMode != o.sModeBroadcast)
            {
                sMode = o.sModeBroadcast;
                iSel = null;
                eSel = null;
                o.iSel = iSel;
                newList = itemsInv;
                if (sMode == "shopBuy")
                {
                    newList = itemsShop;
                }
                o.fData = {"list":newList};
                splitPanel.fHide();
                previewPanel.fHide();
            }
        }
        if (o.eventType == "listItemASel")
        {
            if (!game.isGreedyModalInStack())
            {
                iQty = 1;
                eSel = null;
                iSel = o.fData;
                aSel = o.fData.sType.toLowerCase();
                bSel = "";
                o.fData = {
                    "iSel":iSel,
                    "eSel":eSel,
                    "oSel":o.fData
                };
                previewPanel.fShow();
            }
            else
            {
                cancelBroadcast = true;
            }
        }
        if (o.eventType == "listItemBSel")
        {
            if (!game.isGreedyModalInStack())
            {
                p = game.copyObj(o);
                p.eventType = "listItemBSolo";
                p.fData = {
                    "iSel":p.fData,
                    "eSel":null
                };
                iSel = null;
                bSel = o.fData.sType.toLowerCase();
                iSel = o.fData;
                o.fData = {
                    "iSel":iSel,
                    "eSel":eSel
                };
                if (((!(iSelPrev == iSel)) || (!(eSelPrev == eSel))))
                {
                    notifyByEventType(p);
                }
                previewPanel.fShow();
            }
            else
            {
                cancelBroadcast = true;
            }
        }
        if (o.eventType == "refreshItems")
        {
            if (itemsInv.indexOf(iSel) == -1)
            {
                iSel = null;
            }
            if (itemsInv.indexOf(eSel) == -1)
            {
                eSel = null;
            }
            o.fData = {
                "iSel":iSel,
                "eSel":eSel
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
            if (((iSel == null) && (eSel == null)))
            {
                splitPanel.fHide();
                previewPanel.fHide();
            }
        }
        if (o.eventType == "refreshShop")
        {
            game.world.sendReloadShopRequest(shopinfo.ShopID);
            cancelBroadcast = true;
        }
        if (o.eventType == "showItemListB")
        {
            if (!game.isGreedyModalInStack())
            {
                splitPanel.fShow();
            }
            else
            {
                cancelBroadcast = true;
            }
        }
        if (o.eventType == "showItemListBNoBtns")
        {
            if (!game.isGreedyModalInStack())
            {
                forceO = {};
                forceO.eventType = "previewButton1Update";
                forceO.fData = {};
                forceO.fData.sText = "";
                forceP = {};
                o.eventType = "showItemListB";
                splitPanel.fShow();
            }
            else
            {
                cancelBroadcast = true;
            }
        }
        if (o.eventType == "buyItem")
        {
            var itemObj:Object = iSel != null ? iSel : eSel;

            if (itemObj != null)
            {
                if (itemObj.iCost <= 0)
                {
                    game.world.sendBuyItemRequestWithQuantity({
                        accept: true,
                        iSel: itemObj,
                        iQty: iQty
                    });
                }
                else
                {
                    game.Modal(iQty > 1 ? ("Are you sure you want to buy " + String(iQty) + "x '" + itemObj.sName + "'?") : ("Are you sure you want to buy '" + itemObj.sName + "'?"), game.world.sendBuyItemRequestWithQuantity, {iSel: itemObj, iQty: iQty}, "white,medium");
                }
            }
        }
        if (o.eventType == "sellItem")
        {
            if (iSel != null)
            {
                sellSel = iSel;
            }
            else
            {
                if (eSel != null)
                {
                    sellSel = eSel;
                }
            }
            if (sellSel.bEquip)
            {
                game.MsgBox.notify("Item is currently equipped!");
            }
            else
            {
                if (((((sellSel.bGold == 1) && (sellSel.iHrs == null)) && (!(sellSel.ItemID == 8939))) && (!(sellSel.iCost == 0))))
                {
                    trace(((((("bGold: " + sellSel.bGold) + " sellSel.iHrs: ") + sellSel.iHrs) + " ItemID: ") + sellSel.ItemID));
                    game.MsgBox.notify("Cannot be sold, free storage in your bank!");
                }
                else
                {
                    if (sellSel && sellSel.hasOwnProperty("sMeta") && sellSel.sMeta.indexOf("NoSell") > -1)
                    {
                        game.MsgBox.notify("This item cannot be sold!");
                    }
                    else
                    {
                        game.Modal(iQty > 1 ? ("Are you sure want to sell " + String(iQty) + "x '" + sellSel.sName + "'?" ) : "Are you sure you want to sell '" + sellSel.sName + "'?",
                                game.world.sendSellItemRequestWithQuantity, {
                                    iSel:sellSel,
                                    iQty: iQty
                                }, "white,medium", "dual", true);
                    }
                }
            }
        }
        if (o.eventType == "buyBagSlots")
        {
            cancelBroadcast = true;
            game.world.loadMovieFront(game.bagSpace, "Inline Asset");
            fClose();
        }
        if (o.eventType == "toggleHouseInventory")
        {
            if (!game.world.uiLock)
            {
                game.ui.mcPopup.fOpen("HouseInventory");
            }
        }
        if (o.eventType == "toggleTemporaryInventory")
        {
            if (!game.world.uiLock)
            {
                game.ui.mcPopup.fOpen("TemporaryInventory");
            }
        }
        if (o.eventType == "toggleInventory")
        {
            if (!game.world.uiLock)
            {
                game.ui.mcPopup.fOpen("Inventory");
            }
        }
        updatePreviewButtons(forceO, forceP);
        iSelPrev = null;
        eSelPrev = null;
        if (!cancelBroadcast)
        {
            return (o);
        }
        return (null);
    }

    private function updatePreviewButtons(forceO:Object=null, forceP:Object=null):void
    {
        var o:Object = {};
        var p:Object = {};
        if (((!(forceO == null)) && (!(forceP == null))))
        {
            o = forceO;
            p = forceP;
        }
        else
        {
            o.eventType = "previewButton1Update";
            o.fData = {};
            o.fData.sText = "";
            o.sMode = "grey";
            o.r = {
                "x":46,
                "y":-40,
                "w":-1,
                "h":-1
            };
            o.buttonNewEventType = "";
            p.eventType = "previewButton2Update";
            p.fData = {};
            p.fData.sText = "";
            p.sMode = "grey";
            p.r = {
                "x":173,
                "y":-40,
                "w":-1,
                "h":-1
            };
            p.buttonNewEventType = "";
            if (sMode == "inventory")
            {
                if (((iSel == null) && (eSel == null)))
                {
                    o.fData.sText = "";
                    o.buttonNewEventType = "";
                    p.fData.sText = "";
                    p.buttonNewEventType = "";
                }
                else
                {
                    if (iSel != null)
                    {
                        if (iSel.sES == "ho")
                        {
                            if (iSel.bEquip != 1)
                            {
                                p.fData.sText = "Equip";
                                p.buttonNewEventType = "equipHouse";
                            }
                            p.sMode = "red";
                        }
                    }
                }
            }
            if (sMode == "shopBuy")
            {
                if (((iSel == null) && (eSel == null)))
                {
                    o.fData.sText = "";
                    o.buttonNewEventType = "";
                    p.fData.sText = "";
                    p.buttonNewEventType = "";
                }
                else
                {
                    if (((!(iSel == null)) && (!(eSel == null))))
                    {
                        o.fData.sText = "";
                        o.buttonNewEventType = "";
                        p.fData.sText = "Enhance!";
                        p.buttonNewEventType = "enhanceItem";
                        p.sMode = "red";
                    }
                    else
                    {
                        if (eSel != null)
                        {
                            o.fData.sText = "Buy and Hold";
                            o.buttonNewEventType = "buyItem";
                            p.fData.sText = "Apply Now";
                            p.buttonNewEventType = "showItemListBNoBtns";
                            p.sMode = "red";
                        }
                        else
                        {
                            if (iSel != null)
                            {
                                if (((("bLimited" in shopinfo) && (shopinfo.bLimited)) && (iSel.iQtyRemain <= 0)))
                                {
                                    o.fData.sText = "";
                                    o.buttonNewEventType = "";
                                    p.fData.sText = "Sold Out!";
                                    p.buttonNewEventType = "none";
                                    p.sMode = "grey";
                                }
                                else
                                {
                                    o.fData.sText = "";
                                    o.buttonNewEventType = "";
                                    p.fData.sText = "Buy";
                                    p.buttonNewEventType = "buyItem";
                                    p.sMode = "red";
                                }
                            }
                        }
                    }
                }
            }
            if (sMode == "shopSell")
            {
                if (((iSel == null) && (eSel == null)))
                {
                    o.fData.sText = "";
                    o.buttonNewEventType = "";
                    p.fData.sText = "";
                    p.buttonNewEventType = "";
                }
                else
                {
                    o.fData.sText = "";
                    o.buttonNewEventType = "";
                    p.fData.sText = "Sell";
                    p.buttonNewEventType = "sellItem";
                    p.sMode = "red";
                }
            }
        }
        notifyByEventType(o);
        notifyByEventType(p);
    }

    private function onSellRequest(params:Object):void
    {
        if (params.accept)
        {
            game.world.sendSellItemRequest(params.iSel);
        }
    }

    public function getTabStates(item:Object=null):Array
    {
        var o:Object;
        var tabStates:Array = [{
            "sTag":"Show All",
            "icon":"iipack",
            "state":-1,
            "filter":"*",
            "mc":{}
        }, {
            "sTag":"Show only houses",
            "icon":"ihhouse",
            "state":-1,
            "filter":"House",
            "mc":{}
        }, {
            "sTag":"Show only walls",
            "icon":"ihwall",
            "state":-1,
            "filter":"Wall Item",
            "mc":{}
        }, {
            "sTag":"Show only floors",
            "icon":"ihfloor",
            "state":-1,
            "filter":"Floor Item",
            "mc":{}
        }];
        if (item != null)
        {
            for each (o in tabStates)
            {
                if (o.filter == item.sType)
                {
                    return ([o]);
                }
            }
            return ([tabStates[0]]);
        }
        return (tabStates);
    }

    private function previewPanelEF(e:Event):void
    {
        var ox:Number = previewPanel.x;
        var tx:Number = ((splitPanel.x - previewPanel.w) - previewPanel.xBuffer);
        var dx:Number = (tx - ox);
        if (((dx > 20) || (splitPanel.visible)))
        {
            previewPanel.x = ((splitPanel.x - previewPanel.w) - previewPanel.xBuffer);
        }
    }


}
}//package

