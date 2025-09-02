package test {

import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.GlowFilter;
import flash.geom.Rectangle;

public class DropMenu extends MovieClip {

    public var game:Game;

    public var tTitle:MovieClip;
    public var preview:MovieClip;
    public var hit:MovieClip;
    public var iListA:MovieClip;
    public var iListB:MovieClip;
    public var fxmask:MovieClip;
    public var bg:MovieClip;
    public var scrTgt:MovieClip;

    public var btnClose:SimpleButton;
    public var mcUpgrade:MovieClip;
    public var mcCoin:MovieClip;

    public var invTree:Object;
    public var fData:Object = null;
    public var itemCount:Object;

    internal var item_load:Object;

    internal var mDown:Boolean = false;

    internal var hRun:int = 0;
    internal var dRun:int = 0;
    internal var mbY:int = 0;
    internal var mhY:int = 0;
    internal var mbD:int = 0;
    internal var ox:int = 0;
    internal var oy:int = 0;
    internal var mox:int = 0;
    internal var moy:int = 0;

    public function DropMenu(game:Game):void {
        this.game = game;

        game.ui.dropStack.visible = false;

        var mc:MovieClip;

        mc = (this as MovieClip);
        mc.tTitle.mouseEnabled = false;
        mc.preview.tPreview.mouseEnabled = false;
        mc.hit.alpha = 0;
        mc.hit.buttonMode = true;
        mc.visible = false;

        itemCount = {};
        invTree = {};
    }

    public function onShow():void {
        var mc:MovieClip = (this as MovieClip);
        if (mc.visible) {
            this.fClose();
        } else {
            this.fOpen();
        }
    }

    public function fClose():void {
        var mc:MovieClip = MovieClip(this);
        mc.btnClose.removeEventListener(MouseEvent.CLICK, btnCloseClick);
        mc.bg.removeEventListener(MouseEvent.MOUSE_DOWN, onMenuBGClick);
        mc.bg.removeEventListener(Event.ENTER_FRAME, onMenuBGEnterFrame);
        mc.hit.removeEventListener(MouseEvent.MOUSE_DOWN, onMenuBGClick);
        mc.hit.removeEventListener(Event.ENTER_FRAME, onMenuBGEnterFrame);
        mc.btnClose.removeEventListener(MouseEvent.CLICK, btnCloseClick);
        mc.preview.bTry.removeEventListener(MouseEvent.CLICK, onItemTryClick);
        mc.preview.bAdd.removeEventListener(MouseEvent.CLICK, onItemAddClick);
        mc.preview.bDel.removeEventListener(MouseEvent.CLICK, onItemDelClick);
    }

    public function fOpen():void {
        var mc:MovieClip = (this as MovieClip);
        mc.preview.bAdd.buttonMode = true;
        mc.preview.bDel.buttonMode = true;
        mc.preview.bTry.buttonMode = true;
        mc.preview.t2.mouseEnabled = false;
        mc.btnClose.addEventListener(MouseEvent.CLICK, btnCloseClick, false, 0, true);
        mc.bg.addEventListener(MouseEvent.MOUSE_DOWN, onMenuBGClick, false, 0, true);
        mc.bg.addEventListener(Event.ENTER_FRAME, onMenuBGEnterFrame, false, 0, true);
        mc.hit.addEventListener(MouseEvent.MOUSE_DOWN, onMenuBGClick, false, 0, true);
        mc.hit.addEventListener(Event.ENTER_FRAME, onMenuBGEnterFrame, false, 0, true);
        mc.preview.bTry.addEventListener(MouseEvent.CLICK, onItemTryClick, false, 0, true);
        mc.preview.bAdd.addEventListener(MouseEvent.CLICK, onItemAddClick, false, 0, true);
        mc.preview.bDel.addEventListener(MouseEvent.CLICK, onItemDelClick, false, 0, true);
        showMenu();
    }

    public function showMenu():void {
        var mc:MovieClip = MovieClip(this);
        this.buildMenu();
        mc.visible = true;
    }

    public function buildMenu():void {
        var o:Object;
        var s:String;
        var a:Array;
        var ok:Boolean;
        var list:Array;
        var j:int;
        o = {};
        s = "";
        a = [];
        ok = true;

        for each(var item:Object in invTree) {
            ok = true;
            s = item.sType;
            if (!(s in o)) {
                o[s] = [];
            }
            a = o[s];
            j = 0;
            while (j < a.length) {
                if (a[j].ItemID == item.ItemID) {
                    ok = false;
                }
                j++;
            }
            if (ok) {
                a.push(item);
            }
        }

        for (s in o) {
            o[s].sortOn("sName");
        }
        fData = o;
        list = [];
        for (s in o) {
            list.push(s);
        }
        list.sort(game.arraySort);

        buildItemList(list, "A", this);
    }

    public function buildItemList(list:Array, typ:String, par:MovieClip):void
    {
        var i:int;
        var mc:MovieClip;
        var lmc:MovieClip;
        var item:MovieClip;
        var itemC:Class;
        var w:int;
        var scr:MovieClip;
        var bMask:MovieClip;
        var display:MovieClip;
        i = 0;
        mc = (this as MovieClip);
        w = 90;
        mc.preview.cnt.visible = false;
        mc.mcCoin.visible = false;
        mc.mcUpgrade.visible = false;
        mc.preview.t2.visible = false;
        mc.preview.bTry.visible = false;
        mc.preview.bAdd.visible = false;
        mc.preview.bDel.visible = false;
        mc.preview.tPreview.visible = false;
        if (typ == "A")
        {
            mc.iListB.visible = false;
            lmc = mc.iListA;
            this.destroyIList(lmc);
            lmc.par = par;
            i = 0;
            while (i < list.length)
            {
                itemC = (lmc.iList.iproto.constructor as Class);
                item = lmc.iList.addChild(new (itemC)());
                item.ti.autoSize = "left";
                item.ti.text = String(list[i]);
                if (item.ti.textWidth > w)
                {
                    w = int(item.ti.textWidth);
                }
                item.hit.alpha = 0;
                item.typ = typ;
                item.val = list[i];
                item.iSel = false;
                item.addEventListener(MouseEvent.CLICK, this.onMenuItemClick, false, 0, true);
                item.addEventListener(MouseEvent.MOUSE_OVER, this.onMenuItemMouseOver, false, 0, true);
                item.y = (lmc.iList.iproto.y + (i * 16));
                item.bg.visible = false;
                item.buttonMode = true;
                i++;
            }
            lmc.iList.iproto.visible = false;
            lmc.iList.y = ((lmc.imask.height / 2) - (lmc.iList.height / 2));
        }
        else
        {
            if (typ == "B")
            {
                mc.iListB.visible = true;
                lmc = mc.iListB;
                this.destroyIList(lmc);
                lmc.par = par;
                i = 0;
                while (i < list.length)
                {
                    itemC = (lmc.iList.iproto.constructor as Class);
                    item = lmc.iList.addChild(new (itemC)());
                    item.ti.autoSize = "left";
                    if (list[i].bUpg == 1)
                    {
                        if (list[i].iStk > 1)
                        {
                            item.ti.htmlText = (((("<font color='#FCC749'>" + String(list[i].sName)) + " x") + String(this.itemCount[list[i].ItemID])) + "</font>");
                        }
                        else
                        {
                            item.ti.htmlText = (("<font color='#FCC749'>" + String(list[i].sName)) + "</font>");
                        }
                    }
                    else
                    {
                        if (list[i].iStk > 1)
                        {
                            item.ti.text = ((String(list[i].sName) + " x") + String(this.itemCount[list[i].ItemID]));
                        }
                        else
                        {
                            item.ti.text = String(list[i].sName);
                        }
                    }
                    if (item.ti.textWidth > w)
                    {
                        w = int(item.ti.textWidth);
                    }
                    item.hit.alpha = 0;
                    item.typ = typ;
                    item.val = list[i];
                    item.iSel = false;
                    item.addEventListener(MouseEvent.CLICK, this.onMenuItemClick, false, 0, true);
                    item.addEventListener(MouseEvent.MOUSE_OVER, this.onMenuItemMouseOver, false, 0, true);
                    item.y = (lmc.iList.iproto.y + (i * 16));
                    item.bg.visible = (item.val.bEquip == 1);
                    item.buttonMode = true;
                    i++;
                }
                lmc.iList.iproto.visible = false;
                lmc.x = ((lmc.par.x + lmc.par.width) + 1);
                lmc.iList.y = ((lmc.imask.height / 2) - (lmc.iList.height / 2));
            }
        }
        w = (w + 7);
        i = 1;
        while (i < lmc.iList.numChildren)
        {
            item = (lmc.iList.getChildAt(i) as MovieClip);
            item.bg.width = w;
            item.hit.width = w;
            i++;
        }
        scr = lmc.scr;
        bMask = lmc.imask;
        display = lmc.iList;
        scr.h.y = 0;
        scr.visible = false;
        scr.hit.alpha = 0;
        scr.mDown = false;
        if (display.height > scr.b.height)
        {
            scr.h.height = int(((scr.b.height / display.height) * scr.b.height));
            this.hRun = (scr.b.height - scr.h.height);
            this.dRun = ((display.height - scr.b.height) + 10);
            display.oy = (display.y = bMask.y);
            scr.visible = true;
            scr.hit.addEventListener(MouseEvent.MOUSE_DOWN, this.scrDown, false, 0, true);
            scr.h.addEventListener(Event.ENTER_FRAME, this.hEF, false, 0, true);
            display.addEventListener(Event.ENTER_FRAME, this.dEF, false, 0, true);
        }
        else
        {
            scr.hit.removeEventListener(MouseEvent.MOUSE_DOWN, this.scrDown);
            scr.h.removeEventListener(Event.ENTER_FRAME, this.hEF);
            display.removeEventListener(Event.ENTER_FRAME, this.dEF);
        }
        lmc.imask.width = (w - 1);
        lmc.divider.x = w;
        lmc.scr.x = w;
        if (lmc.scr.visible)
        {
            lmc.w = (w + lmc.scr.width);
        }
        else
        {
            lmc.w = (w + 1);
        }

        this.resizeMe();
    }

    public function onMenuItemClick(e:MouseEvent):void {
        var imc:MovieClip;
        var cmc:MovieClip;
        var parMC:MovieClip;
        var item:Object;
        var i:int;

        imc = (e.currentTarget as MovieClip);
        parMC = (imc.parent as MovieClip);
        i = 0;
        if (imc.typ == "A") {
            i = 0;
            while (i < parMC.numChildren) {
                MovieClip(parMC.getChildAt(i)).bg.visible = false;
                i++;
            }
            imc.bg.visible = true;
            this.buildItemList(this.fData[imc.val], "B", MovieClip(imc.parent));
        }
        if (imc.typ == "B") {
            i = 1;
            while (i < parMC.numChildren) {
                cmc = (parMC.getChildAt(i) as MovieClip);
                cmc.iSel = false;
                i++;
            }
            imc.iSel = true;
            this.refreshIListB();
            item = imc.val;
            this.item_load = imc.val;
            switch (item.sType.toLowerCase()) {
                case "armor":
                case "class":
                    onLoadArmorComplete(item.sFile, item.sLink);
                    break;
                case "quest item":
                case "enhancement":
                case "necklace":
                case "amulet":
                case "item":
                case "serveruse":
                    this.loadItem();
                    break;
                default:
                    if (item.sFile.indexOf(".swf") >= 0) {
                        game.onLoadMaster(onComplete, game.world.loaderC, item.sFile, null, null);
                    } else {
                        loadItem();
                    }
            }
        }
    }

    public function onMenuItemMouseOver(e:MouseEvent):void {
        var mc:MovieClip = MovieClip(e.currentTarget);
        var item:MovieClip;
        var i:int = 1;
        while (i < mc.parent.numChildren) {
            item = MovieClip(mc.parent.getChildAt(i));
            if (item.bg.alpha < 0.4) {
                item.bg.visible = false;
            }
            i++;
        }
        if (!mc.bg.visible) {
            mc.bg.visible = true;
            mc.bg.alpha = 0.33;
        }
    }

    public function onLoadArmorComplete(sFile:*, sLink:*):void {
        var mc:MovieClip = (preview.cnt as MovieClip);
        var obj:Object = this.item_load;

        if (mc.numChildren > 0) {
            mc.removeChildAt(0);
        }

        var pMC:AvatarMC = AvatarMC(mc.addChild(new AvatarMC()));
        pMC.visible = false;
        pMC.width = 243;
        pMC.height = 215.55;
        pMC.x = 10;
        pMC.y = 80;
        pMC.strGender = game.world.myAvatar.objData.strGender;
        pMC.pAV = game.world.myAvatar;
        pMC.world = game.world;
        pMC.hideHPBar();
        pMC.loadArmorPiecesFromDomain(sLink, game.world.loaderD);
        preview.item = obj;

        addGlow(pMC.mcChar);

        switch (obj.sES) {
            case "Weapon":
            case "he":
            case "ba":
            case "pe":
            case "ar":
            case "co":
                if (obj.bUpg == 1) {
                    if (game.world.myAvatar.isUpgraded()) {
                        preview.bTry.visible = true;
                    }
                } else {
                    preview.bTry.visible = true;
                }
                break;
        }

        preview.bAdd.visible = true;
        preview.bDel.visible = true;
        preview.tPreview.visible = true;
        preview.t2.visible = false;
        preview.cnt.visible = true;
        preview.cnt.alpha = 1;
        mcCoin.visible = obj.bCoins;
        mcUpgrade.visible = obj.bUpg;

        pMC.visible = true;
        resizeMe();
        repositionPreview(pMC, true);
    }

    public function loadItem():void {
        var mc:MovieClip = (preview.cnt as MovieClip);
        var item:*;
        var itemClip:MovieClip;
        var obj:Object = this.item_load;

        if (mc.numChildren > 0) {
            mc.removeChildAt(0);
        }

        itemClip = new (game.world.getClass("iibag") as Class)();
        itemClip.scaleX = (itemClip.scaleY = 1);
        itemClip.y = (itemClip.y - 35);
        item = (mc.addChild(itemClip) as MovieClip);
        this.addGlow(itemClip);
        item.ItemID = obj.ItemID;
        preview.item = obj;
        switch (obj.sES) {
            case "Weapon":
            case "he":
            case "ba":
            case "pe":
            case "ar":
            case "co":
                if (obj.bUpg == 1) {
                    if (game.world.myAvatar.isUpgraded()) {
                        preview.bTry.visible = true;
                    }
                } else {
                    preview.bTry.visible = true;
                }
                break;
        }
        preview.bAdd.visible = true;
        preview.bDel.visible = true;
        preview.tPreview.visible = true;
        preview.t2.visible = false;
        preview.cnt.visible = true;
        preview.cnt.alpha = 1;
        mcCoin.visible = obj.bCoins;
        mcUpgrade.visible = obj.bUpg;
        this.resizeMe();
        this.repositionPreview(itemClip);
    }

    public function onComplete(e:Event):void {
        var itemC:Class;
        var mc:MovieClip = (MovieClip(this).preview.cnt as MovieClip);
        var item:* = undefined;
        var itemClip:MovieClip;
        var obj:* = this.item_load;
        var s:String = obj.sLink;

        if (mc.numChildren > 0) {
            mc.removeChildAt(0);
        }

        try {
            itemC = game.world.getClass(s);
            itemClip = new (itemC)();
        } catch (err:Error) {
            trace(" Weapon added to display list manually");
            itemClip = MovieClip(e.target.content);
        }

        switch (obj.sType.toLowerCase()) {
            case "helm":
                itemClip.scaleX = (itemClip.scaleY = 0.8);
                break;
            case "pet":
                itemClip.scaleX = (itemClip.scaleY = 2);
                break;
            default:
                itemClip.scaleX = (itemClip.scaleY = 0.3);
        }
        item = (mc.addChild(itemClip) as MovieClip);
        this.addGlow(itemClip);
        item.ItemID = obj.ItemID;
        preview.item = obj;
        switch (obj.sES) {
            case "Weapon":
            case "he":
            case "ba":
            case "pe":
            case "ar":
            case "co":
                if (obj.bUpg == 1) {
                    if (game.world.myAvatar.isUpgraded()) {
                        preview.bTry.visible = true;
                    }
                } else {
                    preview.bTry.visible = true;
                }
                break;
        }

        preview.bAdd.visible = true;
        preview.bDel.visible = true;
        preview.tPreview.visible = true;
        preview.t2.visible = false;
        preview.cnt.visible = true;
        preview.cnt.alpha = 1;
        this.resizeMe();
        this.repositionPreview(itemClip);
    }

    public function onItemTryClick(e:MouseEvent):void {
        var item:Object;
        var sES:String;
        item = MovieClip(e.currentTarget.parent).item;
        switch (item.sES) {
            case "Weapon":
            case "he":
            case "ba":
            case "pe":
            case "ar":
            case "co":
                sES = item.sES;
                if (sES == "ar") {
                    sES = "co";
                }
                if (sES == "pe") {
                    if (game.world.myAvatar.objData.eqp["pe"]) {
                        game.world.myAvatar.unloadPet();
                    }
                }
                if (!game.world.myAvatar.objData.eqp[sES]) {
                    game.world.myAvatar.objData.eqp[sES] = {};
                    game.world.myAvatar.objData.eqp[sES].wasCreated = true;
                }
                if (!game.world.myAvatar.objData.eqp[sES].isPreview) {
                    game.world.myAvatar.objData.eqp[sES].isPreview = true;
                    if (("sType" in item)) {
                        game.world.myAvatar.objData.eqp[sES].oldType = game.world.myAvatar.objData.eqp[sES].sType;
                        game.world.myAvatar.objData.eqp[sES].sType = item.sType;
                    }
                    game.world.myAvatar.objData.eqp[sES].oldFile = game.world.myAvatar.objData.eqp[sES].sFile;
                    game.world.myAvatar.objData.eqp[sES].oldLink = game.world.myAvatar.objData.eqp[sES].sLink;
                    game.world.myAvatar.objData.eqp[sES].sFile = ((item.sFile == "undefined") ? "" : item.sFile);
                    game.world.myAvatar.objData.eqp[sES].sLink = item.sLink;
                } else {
                    if (("sType" in item)) {
                        game.world.myAvatar.objData.eqp[sES].sType = item.sType;
                    }
                    game.world.myAvatar.objData.eqp[sES].sFile = ((item.sFile == "undefined") ? "" : item.sFile);
                    game.world.myAvatar.objData.eqp[sES].sLink = item.sLink;
                }
                game.world.myAvatar.loadMovieAtES(sES, item.sFile, item.sLink);
                break;
        }
    }

    public function onItemAddClick(e:MouseEvent):void {
        var item:Object;
        var modal:*;
        var modalO:*;
        var nutext:String;

        item = MovieClip(e.currentTarget.parent).item;

        var i:int = 0;
        while (i < game.ui.dropStack.numChildren) {
            if (!game.ui.dropStack.getChildAt(i)) {

            } else {
                if (item.iStk == 1) {
                    if (((game.ui.dropStack.getChildAt(i).cnt) && (game.ui.dropStack.getChildAt(i).cnt.strName))) {
                        if (game.ui.dropStack.getChildAt(i).cnt.strName.text == item.sName) {
                            game.ui.dropStack.getChildAt(i).cnt.ybtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                            break;
                        }
                    }
                } else {
                    nutext = game.ui.dropStack.getChildAt(i).cnt.strName.text;
                    nutext = nutext.substring(0, nutext.lastIndexOf(" x"));
                    if (nutext == item.sName) {
                        game.ui.dropStack.getChildAt(i).cnt.ybtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                        break;
                    }
                }
            }
            i++;
        }

        game.ui.focus = null;
    }

    public function onItemDelClick(e:MouseEvent):void {
        var item:Object;
        var i:int;
        var nutext:String;

        item = MovieClip(e.currentTarget.parent).item;

        for each (var data:Object in invTree) {
            if (invTree[data.ItemID].ItemID == item.ItemID) {
                delete itemCount[item.ItemID];
                delete invTree[data.ItemID];
            }
        }

        i = 0;
        while (i < game.ui.dropStack.numChildren) {
            if (game.ui.dropStack.getChildAt(i)) {
                if (item.iStk == 1) {
                    if (((game.ui.dropStack.getChildAt(i).cnt) && (game.ui.dropStack.getChildAt(i).cnt.strName))) {
                        if (game.ui.dropStack.getChildAt(i).cnt.strName.text == item.sName) {
                            game.ui.dropStack.getChildAt(i).cnt.nbtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                        }
                    }
                } else {
                    nutext = game.ui.dropStack.getChildAt(i).cnt.strName.text;
                    nutext = nutext.substring(0, nutext.lastIndexOf(" x"));
                    if (nutext == item.sName) {
                        game.ui.dropStack.getChildAt(i).cnt.nbtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                    }
                }
            }
            i++;
        }

        fOpen();
        game.ui.focus = null;
    }

    public function resizeMe():* {
        var mc:MovieClip;
        var minWidth:*;
        mc = MovieClip(this);
        if (mc.iListA.visible) {
            mc.bg.width = ((mc.iListA.x + mc.iListA.w) + 5);
        }
        if (mc.iListB.visible) {
            mc.iListB.x = ((mc.iListA.x + mc.iListA.w) + 1);
            mc.bg.width = (mc.bg.width + (mc.iListB.w + 1));
            mc.iListA.divider.visible = (!(mc.iListA.scr.visible));
        } else {
            mc.iListA.divider.visible = false;
        }
        if (((mc.preview.t2.visible) || (mc.preview.cnt.visible))) {
            mc.preview.x = ((mc.iListB.x + mc.iListB.w) + 4);
            mc.bg.width = (mc.bg.width + (mc.preview.width + 4));
            mc.iListB.divider.visible = (!(mc.iListB.scr.visible));
        } else {
            mc.iListB.divider.visible = false;
        }
        minWidth = ((((mc.tTitle.x + this.tTitle.width) + 4) + mc.btnClose.width) + 4);
        if (mc.bg.width < minWidth) {
            mc.bg.width = minWidth;
        }
        mc.btnClose.x = (mc.bg.width - 19);
        mc.mcUpgrade.x = (mc.bg.width - 40);
        mc.mcCoin.x = (mc.bg.width - 40);
        mc.fxmask.width = mc.bg.width;
        if (mc.x < 0) {
            mc.x = 0;
        }
        if ((mc.x + mc.bg.width) > 960) {
            mc.x = (960 - mc.bg.width);
        }
        if (mc.y < 0) {
            mc.y = 0;
        }
        if ((mc.y + mc.bg.height) > 550) {
            mc.y = (550 - mc.bg.height);
        }
    }

    public function repositionPreview(mc:MovieClip, armor:Boolean = false):void {
        var r:Rectangle = mc.getBounds(this);
        if (r.height > (armor ? 290 : 113)) {
            mc.scaleX = (mc.scaleX * (armor ? 290 : 113 / r.height));
            mc.scaleY = (mc.scaleY * (armor ? 290 : 113 / r.height));
        }
        mc.x = (preview.x - int(((mc.getBounds(this).x + (mc.getBounds(this).width / 2)) - (130 / 2))));
        mc.y = int((preview.y - mc.getBounds(this).y));
    }

    private function refreshIListB():void {
        var mc:MovieClip = MovieClip(this).iListB.iList;
        var i:int;
        var imc:MovieClip;
        i = 1;
        while (i < mc.numChildren) {
            imc = (mc.getChildAt(i) as MovieClip);
            if (imc.val != null) {
                imc.bg.visible = false;
                if (imc.iSel) {
                    imc.bg.visible = true;
                    imc.bg.alpha = 0.5;
                }
                if (int(imc.val.bEquip) == 1) {
                    imc.bg.visible = true;
                    imc.bg.alpha = 1;
                }
            }
            i++;
        }
    }

    private function destroyIList(lmc:MovieClip):void {
        var child:MovieClip;
        while (lmc.iList.numChildren > 1) {
            child = lmc.iList.getChildAt(1);
            child.removeEventListener(MouseEvent.CLICK, this.onMenuItemClick);
            child.removeEventListener(MouseEvent.MOUSE_OVER, this.onMenuItemMouseOver);
            delete child.val;
            lmc.iList.removeChildAt(1);
        }
        lmc.scr.hit.removeEventListener(MouseEvent.MOUSE_DOWN, this.scrDown);
        lmc.scr.h.removeEventListener(Event.ENTER_FRAME, this.hEF);
        lmc.iList.removeEventListener(Event.ENTER_FRAME, this.dEF);
    }

    public function btnCloseClick(e:MouseEvent = null):void {
        game.mixer.playSound("Click");
        hideEditMenu();
    }

    public function hideEditMenu():void {
        visible = false;
    }

    public function showEditMenu():void {
        visible = true;
    }

    public function onMenuBGClick(e:MouseEvent):void {
        mDown = true;
        ox = x;
        oy = y;
        mox = stage.mouseX;
        moy = stage.mouseY;
        stage.addEventListener(MouseEvent.MOUSE_UP, onMenuBGRelease, false, 0, true);
    }

    public function onMenuBGRelease(e:MouseEvent):void {
        mDown = false;
        stage.removeEventListener(MouseEvent.MOUSE_UP, this.onMenuBGRelease);
    }

    public function onMenuBGEnterFrame(e:Event):* {
        var mc:MovieClip = (e.currentTarget.parent as MovieClip);
        if (mc.visible) {
            if (mc.mDown) {
                mc.x = (mc.ox + (stage.mouseX - mc.mox));
                mc.y = (mc.oy + (stage.mouseY - mc.moy));
                if (mc.x < 0) {
                    mc.x = 0;
                }
                if ((mc.x + mc.bg.width) > 960) {
                    mc.x = (960 - mc.bg.width);
                }
                if (mc.y < 0) {
                    mc.y = 0;
                }
                if ((mc.y + mc.bg.height) > 550) {
                    mc.y = (550 - mc.bg.height);
                }
            }
        }
    }

    public function dEF(e:Event):* {
        var scr:*;
        var display:*;
        var hP:*;
        var tY:*;
        scr = MovieClip(e.currentTarget.parent).scr;
        display = MovieClip(e.currentTarget);
        hP = (-(scr.h.y) / this.hRun);
        tY = (int((hP * this.dRun)) + display.oy);
        if (Math.abs((tY - display.y)) > 0.2) {
            display.y = (display.y + ((tY - display.y) / 4));
        } else {
            display.y = tY;
        }
    }

    public function hEF(e:Event):* {
        var scr:*;
        if (MovieClip(e.currentTarget.parent).mDown) {
            scr = MovieClip(e.currentTarget.parent);
            this.mbD = (int(mouseY) - this.mbY);
            scr.h.y = (this.mhY + this.mbD);
            if ((scr.h.y + scr.h.height) > scr.b.height) {
                scr.h.y = int((scr.b.height - scr.h.height));
            }
            if (scr.h.y < 0) {
                scr.h.y = 0;
            }
        }
    }

    public function scrDown(e:MouseEvent):* {
        this.mbY = int(mouseY);
        this.mhY = int(MovieClip(e.currentTarget.parent).h.y);
        this.scrTgt = MovieClip(e.currentTarget.parent);
        this.scrTgt.mDown = true;
        stage.addEventListener(MouseEvent.MOUSE_UP, this.scrUp, false, 0, true);
    }

    public function scrUp(e:MouseEvent):* {
        this.scrTgt.mDown = false;
        stage.removeEventListener(MouseEvent.MOUSE_UP, this.scrUp);
    }

    private function addGlow(mc:MovieClip):void {
        var mcFilter:*;
        mcFilter = new GlowFilter(0xFFFFFF, 1, 8, 8, 2, 1, false, false);
        mc.filters = [mcFilter];
    }

}
}
