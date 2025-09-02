// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//LPFLayoutInvShopEnh

package UI.LPF.Layout
{
import UI.LPF.Panel.LPFPanelListShopInvA;
import UI.LPF.Panel.LPFPanelListShopInvB;
import UI.LPF.Panel.LPFPanelPreview;
import UI.ModalMC;

import flash.display.MovieClip;
import flash.events.Event;
import flash.filters.GlowFilter;
import flash.text.*;

public class LPFLayoutInvShopEnh extends LPFLayout
{

    private var aSel:String = "";
    private var bSel:String = "";
    public var iQty:int = 1;
    public var iRty:int = 1;
    public var iSel:Object;
    public var eSel:Object;
    public var shopinfo:Object;
    public var itemsInv:Array;
    public var itemsShop:Array;
    public var multiPanel:MovieClip;
    public var splitPanel:MovieClip;
    public var previewPanel:MovieClip;
    public var previewPanelB:MovieClip;
    public var game:Game;

    public function LPFLayoutInvShopEnh():void
    {
        x = 0;
        y = 0;
        panels = [];
        fData = {};
    }

    override public function fOpen(_arg_1:Object):void
    {
        var _local_2:Object;
        var _local_4:Object;
        var _local_5:MovieClip;
        game = Game.root;
        fData = _arg_1.fData;
        sMode = _arg_1.sMode;
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
        _local_2 = _arg_1.r;
        var _local_3:* = "";
        x = _local_2.x;
        y = _local_2.y;
        w = _local_2.w;
        h = _local_2.h;
        tempFill();
        _local_4 = {};
        _local_4.panel = new LPFPanelListShopInvB();
        _local_3 = "Inventory";
        _local_4.fData = {
            "items":itemsInv,
            "sName":_local_3
        };
        _local_4.r = {
            "x":322,
            "y":3,
            "w":316,
            "h":650
        };
        _local_4.closeType = "hide";
        _local_4.hideDir = "right";
        _local_4.hidePad = 3;
        _local_4.isOpen = false;
        splitPanel = addPanel(_local_4);
        splitPanel.visible = false;
        splitPanel.fHide();

        _local_4 = {};
        _local_4.panel = new LPFPanelPreview();
        _local_3 = "Equipped";
        _local_4.fData = {"sName":_local_3};
        _local_4.r = {
            "x":3,
            "y":28,
            "w":316,
            "h":470
        };
        _local_4.closeType = "hide";
        _local_4.xBuffer = 3;
        _local_4.showDragonLeft = true;
        _local_4.isEquip = true;
        _local_4.isOpen = false;
        previewPanelB = addPanel(_local_4);
        previewPanelB.visible = false;

        _local_4 = {};
        _local_4.panel = new LPFPanelPreview();
        _local_3 = "Preview";
        _local_4.fData = { sName:_local_3 };
        _local_4.r = {
            "x":322,
            "y":28,
            "w":316,
            "h":470
        };
        _local_4.closeType = "hide";
        _local_4.xBuffer = 3;
        _local_4.isOpen = false;
        previewPanel = addPanel(_local_4);
        previewPanel.visible = false;
        previewPanel.addEventListener(Event.ENTER_FRAME, previewPanelEF, false, 0, true);
		
        _local_4 = {};
        _local_4.panel = new LPFPanelListShopInvA();
        _local_3 = ((sMode.toLowerCase().indexOf("shop") > -1) ? game.world.shopinfo.sName : "Inventory");
        _local_4.fData = {
            "items":((itemsShop != null) ? itemsShop : itemsInv),
            "itemsInv":itemsInv,
            "objData":fData.objData,
            "sName":_local_3
        };

        if (shopinfo != null)
        {
            _local_4.fData.shopinfo = shopinfo;
        }

        _local_4.r = {
            "x":641,
            "y":3,
            "w":316,
            "h":650
        };
        _local_4.closeType = "close";
        _local_4.showDragonRight = true;
        _local_4.isOpen = true;
        multiPanel = addPanel(_local_4);
        updatePreviewButtons();
        game.dropStackBoost();
    }

    override public function fClose():void
    {
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

    override protected function handleUpdate(o:Object):Object
    {
        var p:Object;
        var newList:Array;
        var sellSel:Object;
        var modal:ModalMC;
        var modalO:Object;
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
                previewPanelB.fHide();
            }
        }
        if (o.eventType == "listSocketItem")
        {
            if (!game.isGreedyModalInStack())
            {
                trace("LIST SUCKIT ITEM :>");
            }
            else
            {
                cancelBroadcast = true;
            }
        }
        if (o.eventType == "listItemASel")
        {
            if (!game.isGreedyModalInStack())
            {
                iQty = 1;
                eSel = null;
                iSel = null;
                aSel = o.fData.sType.toLowerCase();
                bSel = "";

                if (previewPanel.bg.bg.filters.length > 0) previewPanel.bg.bg.filters = [];
                if (previewPanelB.bg.bg.filters.length > 0) previewPanelB.bg.bg.filters = [];

                if (aSel == "enhancement")
                {
                    eSel = o.fData;
                }
                else
                {
                    iSel = o.fData;
                }
                if (o.fData.sType.toLowerCase() == "enhancement")
                {
                    o.tabStates = getTabStates(o.fData);
                }
                else
                {
                    o.tabStates = getTabStates({"sES":"enh"});
                }

                if (iSel != null)
                {
                    if (["Weapon", "he", "co", "ba", "ar", "pe"].indexOf(iSel.sES) > -1)
                    {
                        if (game.world.myAvatar.getItemByEquipSlot(iSel.sES) != null)
                        {
                            previewPanelB.fShow();
                        }
                        else
                        {
                            previewPanelB.fHide();
                        }
                    }
                    else
                    {
                        previewPanelB.fHide();
                    }
                }

                o.fData = {
                    "iSel":iSel,
                    "eSel":eSel,
                    "oSel":o.fData
                };

                splitPanel.fHide();
                previewPanel.fShow();
                if (((iSelPrev == iSel) && (eSelPrev == eSel)))
                {
                    cancelBroadcast = true;
                }
                if (((!(iSel == null)) && (eSel == null)))
                {
                    splitPanel.bg.tTitle.text = "Select Enhancement to Apply";
                }
                if (((iSel == null) && (!(eSel == null))))
                {
                    splitPanel.bg.tTitle.text = "Select Item to Enhance";
                }
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

                if (o.fData.sType.toLowerCase() == "enhancement")
                {
                    p.fData = {
                        "iSel":null,
                        "eSel":p.fData
                    };
                }
                else
                {
                    p.fData = {
                        "iSel":p.fData,
                        "eSel":null
                    };
                }
                if (bSel == "enhancement")
                {
                    eSel = null;
                }
                else
                {
                    if (bSel != "")
                    {
                        iSel = null;
                    }
                }
                bSel = o.fData.sType.toLowerCase();
                if (bSel == "enhancement")
                {
                    eSel = o.fData;
                }
                else
                {
                    iSel = o.fData;
                }
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
                    previewPanelB.fHide();
                }
                if (o.sInstruction == "previewEquipOnly")
                {
                    splitPanel.fHide();
                    if (iSel != null && iSel.bEquip == 0)
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
                        previewPanelB.fHide();
                    }
                }
            }
            if (((iSel == null) && (eSel == null)))
            {
                splitPanel.fHide();
                previewPanel.fHide();
                previewPanelB.fHide();
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
        if (((o.eventType == "equipItem") || (o.eventType == "unequipItem")))
        {
            if (!game.isGreedyModalInStack())
            {
                if (iSel != null)
                {
                    if (((game.toggleItemEquip(iSel)) && (o.eventType == "equipItem")))
                    {
                        splitPanel.fHide();
                        previewPanel.fHide();
                        previewPanelB.fHide();
                    }
                }
            }
            else
            {
                cancelBroadcast = true;
            }
        }
        if (o.eventType == "enhanceItem")
        {
            if (!game.isGreedyModalInStack())
            {
                if (((!(iSel == null)) && (!(eSel == null))))
                {
                    game.tryEnhance(iSel, eSel, (sMode == "shopBuy"));
                }
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
                game.Modal(
                        iQty > 1 ? ("Are you sure you want to buy " + String(iQty) + "x '" + itemObj.sName + "'?") : ("Are you sure you want to buy '" + itemObj.sName + "'?"),
                        game.world.sendBuyItemRequestWithQuantity, {
                            iSel: itemObj,
                            iQty: iQty
                        }, "white,medium"
                );
            }
        }
        if (o.eventType == "useItem")
        {
            if (iSel != null)
            {
                game.world.tryUseItem(iSel);
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
            if (sellSel.bEquip == 1)
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
                        modal = new ModalMC();
                        modalO = {};
                        modalO.strBody = iQty > 1 ? ("Are you sure want to sell " + String(iQty) + "x '" + sellSel.sName + "'?" ) : "Are you sure you want to sell '" + sellSel.sName + "'?";
                        modalO.params = {
                            iSel:sellSel,
                            iQty: iQty
                        };
                        modalO.callback = game.world.sendSellItemRequestWithQuantity;
                        modalO.glow = "white,medium";
                        modalO.greedy = true;
                        game.ui.ModalStack.addChild(modal);
                        modal.init(modalO);
                    }
                }
            }
        }
        if (o.eventType == "buySlots")
        {
            cancelBroadcast = true;
            game.toggleBuySlots();
            fClose();
        }
        if (o.eventType == "toggleHouseInventory")
        {
            if (!game.world.uiLock)
            {
                game.ui.mcPopup.fOpen("HouseInventory");
            }
        }
//        if (o.eventType == "toggleTemporaryInventory")
//        {
//            if (!game.world.uiLock)
//            {
//                game.ui.mcPopup.fOpen("TemporaryInventory");
//            }
//        }
        if (o.eventType == "helpAC")
        {
            cancelBroadcast = true;
            game.world.loadMovieFront("interface/goldAC4.swf", "Inline Asset");
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

    private function updatePreviewButtons(_arg_1:Object=null, _arg_2:Object=null):void
    {
        trace("UPDATE PREVIEW BUTTON");

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
            if (sMode == "inventory")
            {
                if (((iSel == null) && (eSel == null)))
                {
                    _local_3.fData.sText = "";
                    _local_3.buttonNewEventType = "";
                    _local_4.fData.sText = "";
                    _local_4.buttonNewEventType = "";
                }
                else
                {
                    if (((!(iSel == null)) && (!(eSel == null))))
                    {
                        _local_3.fData.sText = "Enhance!";
                        _local_3.buttonNewEventType = "enhanceItem";
                        _local_3.sMode = "red";
                        if (iSel.bEquip == 1)
                        {
                            _local_4.fData.sText = "Unequip";
                            _local_4.buttonNewEventType = "unequipItem";
                        }
                        else
                        {
                            _local_4.fData.sText = "Equip";
                            _local_4.buttonNewEventType = "equipItem";
                            if (_local_3.sMode != "red")
                            {
                                _local_4.sMode = "red";
                            }
                        }
                    }
                    else
                    {
                        if (eSel != null)
                        {
                            _local_3.fData.sText = "";
                            _local_3.buttonNewEventType = "";
                            _local_4.fData.sText = "Apply Now";
                            _local_4.buttonNewEventType = "showItemListB";
                            _local_4.sMode = "red";
                        }
                        else
                        {
                            if (iSel != null)
                            {
                                if (["Weapon", "he", "ar", "ba"].indexOf(iSel.sES) > -1)
                                {
                                    _local_3.fData.sText = "Enhance!";
                                    _local_3.buttonNewEventType = "showItemListB";
                                    if (!("EnhLvl" in iSel))
                                    {
                                        _local_3.sMode = "red";
                                    }
                                    else
                                    {
                                        _local_4.sMode = "red";
                                    }
                                    if (iSel.bEquip == 1)
                                    {
                                        _local_4.fData.sText = "Unequip";
                                        _local_4.buttonNewEventType = "unequipItem";
                                    }
                                    else
                                    {
                                        _local_4.fData.sText = "Equip";
                                        _local_4.buttonNewEventType = "equipItem";
                                    }
                                }
                                else
                                {
                                    trace(((("iSel.sType: " + iSel.sType) + " iSel.sLink: ") + iSel.sLink));
                                    if (((((iSel.sType.toLowerCase() == "pet") || ((((iSel.sType.toLowerCase() == "item") && (!(String(iSel.sLink).toLowerCase() == ""))) && (!(String(iSel.sLink).toLowerCase() == " "))) && (!(String(iSel.sLink).toLowerCase() == "none")))) || (iSel.sES == "co")) || (iSel.sES == "am")))
                                    {
                                        _local_4.sMode = "red";
                                        if (iSel.bEquip == 1)
                                        {
                                            _local_4.fData.sText = "Unequip";
                                            _local_4.buttonNewEventType = "unequipItem";
                                        }
                                        else
                                        {
                                            _local_4.fData.sText = "Equip";
                                            _local_4.buttonNewEventType = "equipItem";
                                        }
                                    }
                                    if (((iSel.sType.toLowerCase() == "serveruse") || (iSel.sType.toLowerCase() == "clientuse")))
                                    {
                                        _local_4.sMode = "red";
                                        _local_4.fData.sText = "Use";
                                        _local_4.buttonNewEventType = "useItem";
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if (sMode == "shopBuy")
            {
                if (((iSel == null) && (eSel == null)))
                {
                    _local_3.fData.sText = "";
                    _local_3.buttonNewEventType = "";
                    _local_4.fData.sText = "";
                    _local_4.buttonNewEventType = "";
                }
                else
                {
                    if (((!(iSel == null)) && (!(eSel == null))))
                    {
                        _local_3.fData.sText = "";
                        _local_3.buttonNewEventType = "";
                        _local_4.fData.sText = "Enhance!";
                        _local_4.buttonNewEventType = "enhanceItem";
                        _local_4.sMode = "red";
                    }
                    else
                    {
                        if (eSel != null)
                        {
                            _local_3.fData.sText = "Buy and Hold";
                            _local_3.buttonNewEventType = "buyItem";
                            _local_4.fData.sText = "Apply Now";
                            _local_4.buttonNewEventType = "showItemListBNoBtns";
                            _local_4.sMode = "red";
                        }
                        else
                        {
                            if (iSel != null)
                            {
                                if (((("bLimited" in shopinfo) && (shopinfo.bLimited)) && (iSel.iQtyRemain <= 0)))
                                {
                                    _local_3.fData.sText = "";
                                    _local_3.buttonNewEventType = "";
                                    _local_4.fData.sText = "Sold Out!";
                                    _local_4.buttonNewEventType = "none";
                                    _local_4.sMode = "grey";
                                }
                                else
                                {
                                    _local_3.fData.sText = "";
                                    _local_3.buttonNewEventType = "";
                                    _local_4.fData.sText = "Buy";
                                    _local_4.buttonNewEventType = "buyItem";
                                    _local_4.sMode = "red";
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
                    _local_3.fData.sText = "";
                    _local_3.buttonNewEventType = "";
                    _local_4.fData.sText = "";
                    _local_4.buttonNewEventType = "";
                }
                else
                {
                    _local_3.fData.sText = "";
                    _local_3.buttonNewEventType = "";
                    _local_4.fData.sText = "Sell";
                    _local_4.buttonNewEventType = "sellItem";
                    _local_4.sMode = "red";
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
        }];

        if (itemsShop == null)
        {
            _local_2.push({
                "sTag":"Show only potions & elixirs",
                "icon":"ich1",
                "state":-1,
                "filter":"pots",
                "mc":{}
            });
        }
        else
        {
            _local_2.push({
                "sTag":"Show only house items",
                "icon":"ihhouse",
                "state":-1,
                "filter":"houseitems",
                "mc":{}
            });
        };

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
        var _local_2:Number = previewPanel.x;
        var _local_3:Number = ((splitPanel.x - previewPanel.w) - previewPanel.xBuffer);
        var _local_4:Number = (_local_3 - _local_2);
        if (((_local_4 > 20) || (splitPanel.visible)))
        {
            previewPanel.x = ((splitPanel.x - previewPanel.w) - previewPanel.xBuffer);
            previewPanelB.x = ((previewPanel.x - previewPanelB.w) - previewPanel.xBuffer);
        }
    }


}
}//package 

