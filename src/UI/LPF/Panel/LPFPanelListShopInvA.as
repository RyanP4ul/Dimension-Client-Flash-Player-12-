// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//LPFPanelListShopInvA

package UI.LPF.Panel
{
import UI.LPF.Frame.LPFFrameBackdrop;
import UI.LPF.Frame.LPFFrameCheapBuySell;
import UI.LPF.Frame.LPFFrameGenericButton;
import UI.LPF.Frame.LPFFrameGoldDisplay;
import UI.LPF.Frame.LPFFrameListViewTabbed;
import UI.LPF.Frame.LPFFrameSlotDisplay;
import UI.LPF.Frame.LPFFrameTestSort;

import flash.display.MovieClip;
    import flash.events.MouseEvent;
import flash.filters.GlowFilter;
import flash.text.*;

    public class LPFPanelListShopInvA extends LPFPanel
    {

        public function LPFPanelListShopInvA():void
        {
            x = 0;
            y = 0;
            frames = [];
            fData = {};
        }

        override public function fOpen(_arg_1:Object):void
        {
            var _local_7:int;
            fData = _arg_1.fData;
            var _local_2:Object = _arg_1.r;
            x = _local_2.x;
            if (_local_2.y > -1)
            {
                y = _local_2.y;
            }
            else
            {
                _local_7 = fParent.numChildren;
                if (_local_7 > 1)
                {
                    y = ((fParent.getChildAt((_local_7 - 2)).y + fParent.getChildAt((_local_7 - 2)).height) + 10);
                }
                else
                {
                    y = 10;
                }
            }
            w = _local_2.w;
            h = _local_2.h;
            xo = x;
            yo = y;
            if (("closeType" in _arg_1))
            {
                closeType = _arg_1.closeType;
            }
            if (("hideDir" in _arg_1))
            {
                hideDir = _arg_1.hideDir;
            }
            if (("hidePad" in _arg_1))
            {
                hidePad = _arg_1.hidePad;
            }

            var isInv:Boolean = MovieClip(fParent).game.ui.mcPopup.currentLabel == "Inventory";
            var isHouse:Boolean = MovieClip(fParent).game.ui.mcPopup.currentLabel == "HouseInventory";
            var isOutfit:Boolean = MovieClip(fParent).game.ui.mcPopup.currentLabel == "OutfitInventory";
            var isLoot:Boolean = MovieClip(fParent).game.ui.mcPopup.currentLabel == "Loot";
            var isTemp:Boolean = MovieClip(fParent).game.ui.mcPopup.currentLabel == "Temporary";
            var isShop:Boolean = fParent.sMode.indexOf("shop") > -1 && !MovieClip(fParent).game.world.isVendorShop;

            var _local_3:Object = {};

            if (isOutfit || isLoot || isTemp)
            {
                _local_3 = {};
                _local_3.frame = new LPFFrameGenericButton();
                _local_3.sMode = "dark";
                _local_3.isActive = isTemp;
                _local_3.fData = {
                    "sText": "Temporary"
                };
                _local_3.r = {
                    "x":112,
                    "y":40,
                    "w":-1,
                    "h":-1
                };
                _local_3.buttonNewEventType = ["toggleTemporary"];
                addFrame(_local_3);
                _local_3 = {};
                _local_3.frame = new LPFFrameGenericButton();
                _local_3.sMode = "dark";
                _local_3.isActive = isLoot;
                _local_3.fData = {
                    "sText": "Loot",
                    "bSearch": true
                };
                _local_3.r = {
                    "x":21,
                    "y":40,
                    "w":-1,
                    "h":-1
                };
                _local_3.buttonNewEventType = ["toggleLoot"];
                addFrame(_local_3);
            }

            _local_3 = {};
            _local_3.frame = new LPFFrameBackdrop();
            _local_3.fData = null;
            _local_3.r = {
                "x":20,
                "y":124, // 44
                "w":(w - 50),
                "h": isShop ? 310 : (isOutfit || isLoot || isTemp ? 470 : 450) // isOutfit || isLoot ? 371 : 316 // 396
            };
            addFrame(_local_3);

            if (isInv || isHouse || isShop || MovieClip(fParent).game.world.isVendorShop)
            {
                _local_3 = {};
                _local_3.frame = new LPFFrameGoldDisplay();
                _local_3.fData = fData.objData;
                _local_3.r = {
                    "x":-20,
                    "y":-33,
                    "w":-1,
                    "h":24
                };
                _local_3.eventTypes = ["refreshCurrency"];
                addFrame(_local_3);

                _local_3 = {};
                _local_3.frame = new LPFFrameSlotDisplay();
                _local_3.fData = fData.objData;
                _local_3.fData.list = fData.itemsInv;
                _local_3.r = {
                    "x":85,
                    "y":-58,
                    "w":-1,
                    "h":24
                };
                _local_3.eventTypes = ["refreshItems", "refreshSlots"];
                addFrame(_local_3);

                _local_3 = {};
                _local_3.frame = new LPFFrameGenericButton();
                _local_3.fData = {"sText":"Add Space"};
                _local_3.sMode = "slot";
                _local_3.r = {
                    "x":200,
                    "y":-60,
                    "w":10,
                    "h":10
                };
                _local_3.buttonNewEventType = ["buySlots"];
                addFrame(_local_3);

                if (!isShop)
                {
                    _local_3 = {};
                    _local_3.frame = new LPFFrameGenericButton();
                    _local_3.sMode = "dark";
                    _local_3.isActive = isHouse;
                    _local_3.fData = {"sText": "House Inventory"};
                    _local_3.r = {
                        "x":112,
                        "y":40,
                        "w":-1,
                        "h":-1
                    };
                    _local_3.buttonNewEventType = ["toggleHouseInventory"];
                    addFrame(_local_3);
                    _local_3 = {};
                    _local_3.frame = new LPFFrameGenericButton();
                    _local_3.sMode = "dark";
                    _local_3.isActive = isInv;
                    _local_3.fData = {
                        "sText": "Inventory",
                        "bSearch": true
                    };
                    _local_3.r = {
                        "x":21,
                        "y":40,
                        "w":-1,
                        "h":-1
                    };
                    _local_3.buttonNewEventType = ["toggleInventory"];
                    addFrame(_local_3);
                }
            }

            if (isLoot)
            {
                _local_3 = {};
                _local_3.frame = new LPFFrameGenericButton();
                _local_3.sMode = "red";
                _local_3.fData = {
                    "sText": "Keep All"
                };
                _local_3.r = {
                    "x":45,
                    "y":600,
                    "w":145,
                    "h":36.1
                };
                _local_3.buttonNewEventType = ["toggleLootKeepAll"];
                addFrame(_local_3);

                _local_3 = {};
                _local_3.frame = new LPFFrameGenericButton();
                _local_3.sMode = "red";
                _local_3.fData = {
                    "sText": "Remove All"
                };
                _local_3.r = {
                    "x":157.95,
                    "y":600,
                    "w":145,
                    "h":36.1
                };
                _local_3.buttonNewEventType = ["toggleLootRemoveAll"];
                addFrame(_local_3);
            }

            var _local_4:* = 465;
            if (isShop)
            {
                _local_3 = {};
                _local_3.frame = new LPFFrameCheapBuySell();
                _local_3.fData = null;
                _local_3.eventType = "sModeSet";
                _local_3.openOn = "shopBuy";
                _local_3.r = {
                    "x":20,
                    "y": -100, //(_local_5 + _local_4),
                    "w":-1,
                    "h":-1
                };
                addFrame(_local_3);
            }
            _local_3 = {};
            _local_3.frame = new LPFFrameListViewTabbed();
            var _local_6:Object = {
                "list":fData.items,
                "bLimited":false
            };
            if (("shopinfo" in fData))
            {
                if (("bLimited" in fData.shopinfo))
                {
                    _local_6.bLimited = fData.shopinfo.bLimited;
                }
            }
            _local_3.fData = _local_6;
            _local_3.r = {
                "x":20,
                "y":100, // 70 // _local_5
                "w":265,
                "h": isShop ? _local_4 - 30 : (isOutfit || isLoot || isTemp ? _local_4 + 20 : _local_4)
            };
            _local_3.tabStates = MovieClip(fParent).getTabStates();
            _local_3.sortOrder = ["Note", "Resource", "Item", "Quest Item", "ServerUse", "Enhancement", "Rune", "Sword", "Axe", "Gauntlet", "Dagger", "HandGun", "Rifle", "Gun", "Whip", "Bow", "Mace", "Polearm", "Staff", "Wand", "Class", "Armor", "Helm", "Cape", "Misc", "Earring", "Amulet", "Necklace", "Belt", "Ring", "Pet", "BattlePet"];
            _local_3.filterMap = {
                "Weapon":["Sword", "Axe", "Gauntlet", "Dagger", "HandGun", "Rifle", "Gun", "Whip", "Bow", "Mace", "Polearm", "Staff", "Wand", "Rune"],
                "ar":["Class", "Armor"],
                "he":["Helm"],
                "ba":["Cape"],
                "pe":["Pet", "BattlePet"],
                "am":["Misc", "Earring", "Amulet", "Necklace", "Belt", "Ring"],
                "it":["Note", "Resource", "Item", "Quest Item", "ServerUse"],
                "enh":["Enhancement"],
                "houseitems":["House", "Wall Item", "Floor Item"],
                "pots":["Item"]
            };
            _local_3.sName = "itemListA";
            _local_3.sTypeSort = "default";
            _local_3.itemEventType = "listItemASel";
            _local_3.eventTypes = ["refreshItems", "refreshInv", "sModeSet", "refreshOption"];
            addFrame(_local_3);

            _local_3 = {};
            _local_3.frame = new LPFFrameTestSort();
            _local_3.fData = {
                items: [
                    { name: "Default" },
                    { name: "Rarity" },
                    { name: "Level" },
                    { name: "Name" }
                ]
            };

            if (isInv)
            {
                _local_3.fData.items.push({ name: "Recent" });
                _local_3.fData.items.push({ name: "Favorite" });
                _local_3.r = {
                    "x":200,
                    "y":72,
                    "w":-1,
                    "h":-1
                };
            }
            else
            {
                _local_3.r = {
                    "x":230,
                    "y":72,
                    "w":-1,
                    "h":-1
                };
            }

            addFrame(_local_3);

//            _local_3 = {};
//            _local_3.frame = new LPFFrameSorting();
//            _local_3.fData = {
//                items: [
//                    { name: "Default" },
//                    { name: "Rarity" },
//                    { name: "Level" },
//                    { name: "Name" }
//                ]
//            };
//
//            if (isInv) _local_3.fData.items.push({ name: "Favorite" });
//
//            _local_3.r = {
//                "x":33,
//                "y":72,
//                "w":-1,
//                "h":-1
//            };
//            addFrame(_local_3);

            drawBG();

            bg.btnClose.addEventListener(MouseEvent.CLICK, onCloseClick, false, 0, true);
            if (!(("showDragonLeft" in _arg_1) && (_arg_1.showDragonLeft == true)))
            {
                bg.dragonLeft.visible = false;
            }
            if (!(("showDragonRight" in _arg_1) && (_arg_1.showDragonRight == true)))
            {
                bg.dragonRight.visible = false;
            }
        }


    }
}//package 

