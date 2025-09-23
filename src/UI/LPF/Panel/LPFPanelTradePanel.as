package UI.LPF.Panel {
import UI.LPF.Frame.LPFFrameBackdrop;
import UI.LPF.Frame.LPFFrameGenericButton;
import UI.LPF.Frame.LPFFrameGoldDisplay;
import UI.LPF.Frame.LPFFrameItemPreview;
import UI.LPF.Frame.LPFFrameListViewTabbed;

import flash.display.MovieClip;
import flash.events.MouseEvent;

import game.panel.LPFPanelBg5;

public class LPFPanelTradePanel extends LPFPanel  {

    private var game:Game = Game.root;

    public function LPFPanelTradePanel() {
        x = 0;
        y = 0;
        frames = [];
        fData = {};
    }

    override public function fOpen(_arg_1:Object):void
    {
        var _local_2:Object;
        var _local_3:int;
        fData = _arg_1.fData;
        drawBG(LPFPanelBg5);
        bg.tTitle.text = "Trade";
        bg.tPane1.text = "Inventory";
        bg.tPane2.text = "Preview";
        bg.tPane3.text = "Your Offer";
        bg.tPane4.text = "Their Offer";
        _local_2 = _arg_1.r;
        x = _local_2.x;

        if (_local_2.y > -1)
        {
            y = _local_2.y;
        }
        else
        {
            _local_3 = fParent.numChildren;
            if (_local_3 > 1)
            {
                y = ((fParent.getChildAt((_local_3 - 2)).y + fParent.getChildAt((_local_3 - 2)).height) + 10);
            }
            else
            {
                y = 10;
            }
        }

        bg.y = 0;
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
        if (("xBuffer" in _arg_1))
        {
            xBuffer = _arg_1.xBuffer;
        }
        if (("isOpen" in _arg_1))
        {
            isOpen = _arg_1.isOpen;
        }

        // YOUR INVENTORY
        var frame:Object = {};
        frame.frame = new LPFFrameBackdrop();
        frame.fData = null;
        frame.r = {
            "x":42,
            "y":113,
            "w":268,
            "h":350
        };
        addFrame(frame);

        frame = {};
        frame.frame = new LPFFrameListViewTabbed();
        frame.fData = {"list":fData.itemsInv};
        frame.r = {
            "x":44,
            "y":89.05,
            "w":265,
            "h":370
        };
        frame.tabStates = MovieClip(fParent).getTabStates();
        frame.sortOrder = ["Note", "Resource", "Item", "Quest Item", "ServerUse", "Enhancement", "Sword", "Axe", "Dagger", "Gun", "Bow", "Mace", "Polearm", "Staff", "Wand", "Class", "Armor", "Helm", "Cape", "Ring", "Amulet", "Belt", "Pet", "House", "Wall Item", "Floor Item", "BattlePet"];
        frame.filterMap = {
            "Weapon":["Sword", "Axe", "Gauntlet", "Dagger", "HandGun", "Rifle", "Gun", "Whip", "Bow", "Mace", "Polearm", "Staff", "Wand"],
            "ar":["Class", "Armor"],
            "he":["Helm"],
            "ba":["Cape"],
            "pe":["Pet", "BattlePet"],
            "am":["Misc", "Earring", "Amulet", "Necklace", "Belt", "Ring"],
            "it":["Note", "Resource", "Item", "Quest Item", "ServerUse"],
            "enh":["Enhancement"],
            "House":["House"],
            "Wall Item":["Wall Item"],
            "Floor Item":["Floor Item"]
        };
        frame.sTypeSort = "default";
        frame.itemEventType = "listItemASel";
        frame.eventTypes = ["refreshItems", "refreshInv"];
        addFrame(frame);

        frame = {};
        frame.frame = new LPFFrameGenericButton();
        frame.fData = null;
        frame.r = {
            "x":127,
            "y":495,
            "w":100,
            "h":-1
        };
        frame.eventTypes = ["previewButton1Update"];
        addFrame(frame);

        frame = {};
        frame.frame = new LPFFrameGoldDisplay();
        frame.fData = fData.objData;
        frame.r = {
            "x":35,
            "y":465,
            "w":-1,
            "h":24
        };
        frame.eventTypes = ["refreshCurrency"];
        addFrame(frame);

        // ITEM PREVIEW
        frame = {};
        frame.frame = new LPFFrameItemPreview();
        frame.fData = null;
        frame.r = {
            "x":340,
            "y":113,
            "w":284,
            "h":-1
        };
        frame.eventTypes = ["listItemASel"];
        addFrame(frame);

/*
        frame = {};
        frame.frame = new LPFFrameEnhText();
        frame.fData = null;
        frame.r = {
            "x":339,
            "y":314.3,
            "w":-1,
            "h":-1
        };
        frame.eventTypes = ["listItemASel", "refreshItems"];
        addFrame(frame);
*/

        // YOUR OFFER

        frame = {};
        frame.frame = new LPFFrameBackdrop();
        frame.fData = null;
        frame.r = {
            "x":674.5,
            "y":113,
            "w":268,
            "h":263.85
        };
        addFrame(frame);

        frame = {};
        frame.frame = new LPFFrameListViewTabbed();
        frame.fData = {"list": fData.itemsB};
        frame.r = {
            "x":677.45,
            "y":89.05,
            "w":265,
            "h":281.2
        };
        frame.tabStates = MovieClip(fParent).getTabStates();
        frame.sortOrder = ["Note", "Resource", "Item", "Quest Item", "ServerUse", "Enhancement", "Sword", "Axe", "Dagger", "Gun", "Bow", "Mace", "Polearm", "Staff", "Wand", "Class", "Armor", "Helm", "Cape", "Ring", "Amulet", "Belt", "Pet", "BattlePet", "House", "Wall Item", "Floor Item"];
        frame.filterMap = {
            "Weapon":["Sword", "Axe", "Gauntlet", "Dagger", "HandGun", "Rifle", "Gun", "Whip", "Bow", "Mace", "Polearm", "Staff", "Wand"],
            "ar":["Class", "Armor"],
            "he":["Helm"],
            "ba":["Cape"],
            "pe":["Pet", "BattlePet"],
            "am":["Misc", "Earring", "Amulet", "Necklace", "Belt", "Ring"],
            "it":["Note", "Resource", "Item", "Quest Item", "ServerUse"],
            "enh":["Enhancement"],
            "House":["House"],
            "Wall Item":["Wall Item"],
            "Floor Item":["Floor Item"]
        };
        frame.sName = "offer";
        frame.openBlank = false;
        frame.allowDesel = true;
        frame.itemEventType = "offerSel";
        frame.tabEventType = "categorySelMyOffer";
        frame.eventTypes = ["refreshItems", "refreshInv", "categorySelMyOffer"];
        game.world.tradeController.tradeItem1 = frame.frame;
        addFrame(frame);

        // THEIR OFFER
        frame = {};
        frame.frame = new LPFFrameBackdrop();
        frame.fData = null;
        frame.r = {
            "x":978.8,
            "y":113,
            "w":268,
            "h":263.85
        };
        addFrame(frame);

        frame = {};
        frame.frame = new LPFFrameListViewTabbed();
        frame.fData = {
            "list": fData.itemsC
        };
        frame.r = {
            "x":981.8,
            "y":89,
            "w":265,
            "h":281.2
        };
        frame.tabStates = MovieClip(fParent).getTabStates();
        frame.sortOrder = ["Note", "Resource", "Item", "Quest Item", "ServerUse", "Enhancement", "Sword", "Axe", "Dagger", "Gun", "Bow", "Mace", "Polearm", "Staff", "Wand", "Class", "Armor", "Helm", "Cape", "Ring", "Amulet", "Belt", "Pet", "House", "Wall Item", "Floor Item"];
        frame.filterMap = {
            "Weapon":["Sword", "Axe", "Gauntlet", "Dagger", "HandGun", "Rifle", "Gun", "Whip", "Bow", "Mace", "Polearm", "Staff", "Wand"],
            "ar":["Class", "Armor"],
            "he":["Helm"],
            "ba":["Cape"],
            "pe":["Pet"],
            "am":["Misc", "Earring", "Amulet", "Necklace", "Belt", "Ring"],
            "it":["Note", "Resource", "Item", "Quest Item", "ServerUse"],
            "enh":["Enhancement"],
            "House":["House"],
            "Wall Item":["Wall Item"],
            "Floor Item":["Floor Item"]
        };
        frame.sName = "their";
        frame.onDemand = true;
        frame.openBlank = false;
        frame.allowDesel = true;
        frame.itemEventType = "otherSel";
        frame.tabEventType = "refreshItems";
        frame.eventTypes = ["refreshItems", "refreshBank", "refreshInv"];
        game.world.tradeController.tradeItem2 = frame.frame;
        addFrame(frame);

        bg.btnClose.addEventListener(MouseEvent.CLICK, onCloseClick, false, 0, true);
        if (!(("showDragonLeft" in _arg_1) && _arg_1.showDragonLeft))
        {
            bg.dragonLeft.visible = true;
        }
        if (!(("showDragonRight" in _arg_1) && _arg_1.showDragonRight))
        {
            bg.dragonRight.visible = true;
        }
    }

}
}
