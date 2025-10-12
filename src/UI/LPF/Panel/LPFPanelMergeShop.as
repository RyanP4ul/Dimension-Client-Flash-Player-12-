package UI.LPF.Panel
{
import UI.LPF.Frame.LPFFrameBackdrop;
import UI.LPF.Frame.LPFFrameCostDisplay;
import UI.LPF.Frame.LPFFrameEnhText;
import UI.LPF.Frame.LPFFrameGenericButton;
import UI.LPF.Frame.LPFFrameGoldDisplay;
import UI.LPF.Frame.LPFFrameItemPreview;
import UI.LPF.Frame.LPFFrameListViewTabbed;
import UI.LPF.Frame.LPFFrameQtySelector;
import UI.LPF.Frame.LPFFrameSimpleList;
import UI.LPF.Frame.LPFFrameSimpleText;
import UI.LPF.Frame.LPFFrameSlotDisplay;
import UI.LPF.Frame.LPFFrameTestSort;

import flash.geom.Point;
    import flash.display.MovieClip;
    import flash.events.MouseEvent;

    public class LPFPanelMergeShop extends LPFPanel
    {

        public function LPFPanelMergeShop():void
        {
            x = 0;
            y = 0;
            frames = [];
            fData = {};
        }

        override public function fOpen(_arg_1:Object):void
        {
            var _local_2:Object;
            var _local_6:int;
            fData = _arg_1.fData;
            drawBG(LPFPanelBg2);
            bg.tPane1.text = "Preview";
            bg.tPane2.text = "Cost";
            bg.tPane3.text = "Item List";
            _local_2 = _arg_1.r;
            x = _local_2.x;
            if (_local_2.y > -1)
            {
                y = _local_2.y;
            }
            else
            {
                _local_6 = fParent.numChildren;
                if (_local_6 > 1)
                {
                    y = ((fParent.getChildAt((_local_6 - 2)).y + fParent.getChildAt((_local_6 - 2)).height) + 10);
                }
                else
                {
                    y = 10;
                };
            };
            var _local_3:Point = new Point(0, 0);
            _local_3 = bg.localToGlobal(_local_3);
            bg.y = (bg.y - int((_local_2.y - _local_3.y)));
            w = _local_2.w;
            h = _local_2.h;
            xo = x;
            yo = y;
            if (("closeType" in _arg_1))
            {
                closeType = _arg_1.closeType;
            };
            if (("hideDir" in _arg_1))
            {
                hideDir = _arg_1.hideDir;
            };
            if (("hidePad" in _arg_1))
            {
                hidePad = _arg_1.hidePad;
            };
            if (("xBuffer" in _arg_1))
            {
                xBuffer = _arg_1.xBuffer;
            };
            if (("isOpen" in _arg_1))
            {
                isOpen = _arg_1.isOpen;
            };
            var _local_4:Object = {};
//            _local_4 = {};
//            _local_4.frame = new LPFFrameBackdrop();
//            _local_4.fData = null;
//            _local_4.r = {
//                "x":15,
//                "y":36,
//                "w":290,
//                "h":204
//            };
//            addFrame(_local_4);
//            _local_4 = {};
//            _local_4.frame = new LPFFrameBackdrop();
//            _local_4.fData = null;
//            _local_4.r = {
//                "x":15,
//                "y":244,
//                "w":290,
//                "h":121
//            };
//            addFrame(_local_4);
            _local_4 = {};
            _local_4.frame = new LPFFrameItemPreview();
            _local_4.fData = null;
            _local_4.r = {
                "x":19,
                "y":40,
                "w":284,
                "h":-1
            };
            _local_4.eventTypes = ["listItemASel"];
            addFrame(_local_4);
            _local_4 = {};
            _local_4.frame = new LPFFrameEnhText();
            _local_4.fData = null;
            _local_4.r = {
                "x":19,
                "y":245,
                "w":284,
                "h":-1
            };
            _local_4.eventTypes = ["listItemASel"];
            addFrame(_local_4);
            _local_4 = {};
            _local_4.frame = new LPFFrameBackdrop();
            _local_4.fData = null;
            _local_4.r = {
                "x":655, //(14 + 581),
                "y":94,
                "w":268,
                "h":307
            };
            addFrame(_local_4);
            _local_4 = {};
            _local_4.frame = new LPFFrameGoldDisplay();
            _local_4.fData = fData.objData;
            _local_4.r = {
                "x":720,
                "y":-15,
                "w":-1,
                "h":24
            };
            _local_4.eventTypes = ["refreshCurrency"];
            addFrame(_local_4);
            _local_4 = {};
            _local_4.frame = new LPFFrameSlotDisplay();
            _local_4.fData = fData.objData;
            _local_4.fData.list = fData.itemsInv;
            _local_4.r = {
                "x":720, //(32 + 581),
                "y":415,
                "w":-1,
                "h":24
            };
            _local_4.eventTypes = ["refreshItems", "refreshSlots"];
            addFrame(_local_4);
            _local_4 = {};
            _local_4.frame = new LPFFrameGenericButton();
            _local_4.fData = {"sText":"Add Space"};
            _local_4.sMode = "slot";
            _local_4.r = {
                "x":835,//(185 + 581),
                "y":415,
                "w":-1,
                "h":-1
            };
            _local_4.buttonNewEventType = ["buyBagSlots"];
            addFrame(_local_4);
            _local_4 = {};
            _local_4.frame = new LPFFrameListViewTabbed();
            _local_4.fData = {"list":fData.items};
            _local_4.r = {
                "x":655, //601,
                "y":70,
                "w":265,
                "h":290
            };
            _local_4.tabStates = MovieClip(fParent).getTabStates();
            _local_4.sortOrder = ["Note", "Resource", "Item", "Potion", "Quest Item", "ServerUse", "Enhancement", "Sword", "Axe", "Dagger", "Gun", "Bow", "Mace", "Polearm", "Staff", "Wand", "Class", "Armor", "Helm", "Cape", "Ring", "Amulet", "Belt", "Pet", "BattlePet", "House", "Wall Item", "Floor Item"];
            _local_4.filterMap = {
                "Weapon":["Sword", "Axe", "Dagger", "Gun", "Bow", "Mace", "Polearm", "Staff", "Wand"],
                "ar":["Class", "Armor"],
                "he":["Helm"],
                "ba":["Cape"],
                "pe":["Pet", "BattlePet"],
                "am":["Amulet", "Necklace"],
                "it":["Note", "Resource", "Item", "Potion", "Quest Item", "ServerUse", "House", "Wall Item", "Floor Item"],
                "enh":["Enhancement"]
            };
            _local_4.sName = "itemListA";
            _local_4.itemEventType = "listItemASel";
            _local_4.eventTypes = ["refreshInv", "refreshOption"]; // , "refreshTestShop"
            addFrame(_local_4);
            _local_4 = {};
            _local_4.frame = new LPFFrameSimpleText();
            _local_4.fData = {"msg":"<p align='center'>Select an item from the list. Below are the required parts to buy the desired item.</p>"};
            _local_4.r = {
                "x":385,
                "y":71,
                "w":200,
                "h":-1
            };
            addFrame(_local_4);
            _local_4 = {};
            _local_4.frame = new LPFFrameSimpleList();
            _local_4.fData = {"msg":"<p align='center'>*Items must be in your backpack to appear.</p>"};
            _local_4.r = {
                "x":370,
                "y":140,
                "w":240,
                "h":-1
            };
            _local_4.eventTypes = ["refreshItems", "listItemASel", "updateQtyValue"];
            addFrame(_local_4);
            _local_4 = {};
            _local_4.frame = new LPFFrameCostDisplay();
            _local_4.fData = null;
            _local_4.r = {
                "x":430,
                "y":320,
                "w":-1,
                "h":-1
            };
            _local_4.eventTypes = ["listItemASel", "updateQtyValue"];
            addFrame(_local_4);
            _local_4 = {};
            _local_4.frame = new LPFFrameGenericButton();
            _local_4.fData = null;
            _local_4.r = {
                "x":440,
                "y":-1,
                "w":250,
                "h":-1
            };
            _local_4.eventTypes = ["previewButton1Update"];
            addFrame(_local_4);

            _local_4 = {};
            _local_4.frame = new LPFFrameQtySelector();
            _local_4.fData = null;
            _local_4.r = {
                "x":425,
                "y":330,
                "w":-1,
                "h":-1
            };
            _local_4.eventTypes = ["listItemASel"];
            addFrame(_local_4);

            _local_4 = {};
            _local_4.frame = new LPFFrameTestSort();
            _local_4.fData = {
                items: [
                    { name: "Default" },
                    { name: "Rarity" },
                    { name: "Level" },
                    { name: "Name" }
                ]
            };

            _local_4.r = {
                "x":877,
                "y":43,
                "w":-1,
                "h":-1
            };
            addFrame(_local_4);

            bg.btnClose.addEventListener(MouseEvent.CLICK, onCloseClick, false, 0, true);
            if (!(("showDragonLeft" in _arg_1) && (_arg_1.showDragonLeft == true)))
            {
                bg.dragonLeft.visible = false;
            };
            if (!(("showDragonRight" in _arg_1) && (_arg_1.showDragonRight == true)))
            {
                bg.dragonRight.visible = false;
            };
        }


    }
}//package

