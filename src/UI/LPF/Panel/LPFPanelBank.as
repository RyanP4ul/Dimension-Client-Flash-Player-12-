// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//LPFPanelBank

package UI.LPF.Panel
{
import UI.LPF.Frame.LPFFrameBackdrop;
import UI.LPF.Frame.LPFFrameGenericButton;
import UI.LPF.Frame.LPFFrameGoldDisplay;
import UI.LPF.Frame.LPFFrameListViewTabbed;
import UI.LPF.Frame.LPFFrameSimpleText;
import UI.LPF.Frame.LPFFrameSlotDisplay;

import flash.events.MouseEvent;
    import flash.events.FocusEvent;
    import flash.geom.Point;
    import flash.display.MovieClip;
    import flash.text.*;

    public class LPFPanelBank extends LPFPanel 
    {

        public function LPFPanelBank():void
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
            drawBG(LPFPanelBg3);
            bg.tTitle.text = "Bank";
            bg.tPane1.text = "Bank Items";
            bg.tPane2.text = "";
            bg.tPane3.text = "Inventory Items";
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
            _local_4 = {};
            _local_4.frame = new LPFFrameBackdrop();
            _local_4.fData = null;
            _local_4.r = {
                "x":(14 + 1),
                "y":62,
                "w":268,
                "h":340
            };
            addFrame(_local_4);
            var _local_5:int = 38;
            _local_4 = {};
            _local_4.frame = new LPFFrameListViewTabbed();
            _local_4.fData = {
                "list":fData.itemsB,
                "isBank":true
            };
            _local_4.r = {
                "x":16,
                "y":_local_5,
                "w":265,
                "h":340
            };
            _local_4.tabStates = MovieClip(fParent).getTabStates(null, ["*"]);
            _local_4.sortOrder = ["Note", "Resource", "Item", "Quest Item", "ServerUse", "Enhancement", "Sword", "Axe", "Dagger", "Gun", "Bow", "Mace", "Polearm", "Staff", "Wand", "Class", "Armor", "Helm", "Cape", "Ring", "Amulet", "Belt", "Pet", "House", "Wall Item", "Floor Item"];
            _local_4.filterMap = {
                "Weapon":["Sword", "Axe", "Dagger", "Gun", "Bow", "Mace", "Polearm", "Staff", "Wand"],
                "ar":["Class", "Armor"],
                "he":["Helm"],
                "ba":["Cape"],
                "pe":["Pet"],
                "am":["Amulet", "Necklace"],
                "it":["Note", "Resource", "Item", "Quest Item", "ServerUse", "House", "Wall Item", "Floor Item"],
                "enh":["Enhancement"]
            };
            _local_4.sName = "bank";
            _local_4.itemEventType = "bankSel";
            _local_4.tabEventType = "categorySel";
            _local_4.eventTypes = ["refreshItems", "refreshBank", "categorySel"];
            _local_4.onDemand = true;
            _local_4.openBlank = true;
            _local_4.allowDesel = true;
            addFrame(_local_4);
            _local_4 = {};
            _local_4.frame = new LPFFrameSlotDisplay();
            _local_4.fData = {};
            _local_4.fData.avatar = fData.avatar;
            _local_4.r = {
                "x":110,
                "y":415,
                "w":-1,
                "h":24
            };
            _local_4.eventTypes = ["refreshItems", "refreshBank", "refreshSlots"];
            _local_4.isBank = true;
            addFrame(_local_4);
            _local_4 = {};
            _local_4.frame = new LPFFrameBackdrop();
            _local_4.fData = null;
            _local_4.r = {
                "x":655, //(14 + 581),
                "y":94,
                "w":268,
                "h":290
            };
            addFrame(_local_4);
            _local_4 = {};
            _local_4.frame = new LPFFrameGoldDisplay();
            _local_4.fData = fData.objData;
            _local_4.r = {
                "x":690,
                "y":-15,
                "w":-1,
                "h":24
            };
            _local_4.eventTypes = ["refreshCurrency"];
            addFrame(_local_4);
            _local_4 = {};
            _local_4.frame = new LPFFrameSlotDisplay();
            _local_4.fData = fData.objData;
            _local_4.fData.list = fData.itemsI;
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
            _local_5 = 46;
            _local_4 = {};
            _local_4.frame = new LPFFrameListViewTabbed();
            _local_4.fData = {"list":fData.itemsI};
            _local_4.r = {
                "x":655, //601,
                "y":70,
                "w":265,
                "h":307
            };
            _local_4.tabStates = MovieClip(fParent).getTabStates();
            _local_4.sortOrder = ["Note", "Resource", "Item", "Quest Item", "ServerUse", "Enhancement", "Sword", "Axe", "Dagger", "Gun", "Bow", "Mace", "Polearm", "Staff", "Wand", "Class", "Armor", "Helm", "Cape", "Ring", "Amulet", "Belt", "Pet", "House", "Wall Item", "Floor Item"];
            _local_4.filterMap = {
                "Weapon":["Sword", "Axe", "Dagger", "Gun", "Bow", "Mace", "Polearm", "Staff", "Wand"],
                "ar":["Class", "Armor"],
                "he":["Helm"],
                "ba":["Cape"],
                "pe":["Pet"],
                "am":["Amulet", "Necklace"],
                "it":["Note", "Resource", "Item", "Quest Item", "ServerUse", "House", "Wall Item", "Floor Item"],
                "enh":["Enhancement"]
            };
            _local_4.sName = "inventory";
            _local_4.itemEventType = "inventorySel";
            _local_4.eventTypes = ["refreshInv", "refreshItems", "refreshInventory"];
            _local_4.allowDesel = true;
            _local_4.refreshTabs = true;
            addFrame(_local_4);
            _local_4 = {};
            _local_4.frame = new LPFFrameSimpleText();
            _local_4.fData = {"msg":"<p align='center'>Select an item from your Inventory (right) to move that item to the Bank (left), and vice-versa.<br>Selecting an item from both lists allows you to perform a swap.</p>"};
            _local_4.r = {
                "x":-1,
                "y":10,
                "w":200,
                "h":-1,
                "center":true
            };
            addFrame(_local_4);
            _local_4 = {};
            _local_4.frame = new LPFFrameGenericButton();
            _local_4.fData = null;
            _local_4.r = {
                "x":455,
                "y":363.5,
                "w":-1,
                "h":-1,
                "center":false
            };
            _local_4.eventTypes = ["previewButton1Update"];
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

