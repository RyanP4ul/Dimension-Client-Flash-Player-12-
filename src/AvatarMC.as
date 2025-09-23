// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//AvatarMC

package {

import flash.display.MovieClip;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.geom.ColorTransform;
import flash.events.MouseEvent;
import flash.events.Event;
import flash.display.DisplayObject;
import flash.events.IOErrorEvent;
import flash.system.ApplicationDomain;
import flash.display.Graphics;
import fl.motion.Color;
import game.config.ConfigurationData;

public class AvatarMC extends MovieClip {

    private var game:Game = Game.root;
    private const MAX_RATIO:Number = 4.6566128752458E-10;
    public var hpBar:MovieClip;
    public var mcChar:MovieClip;
    public var pname:MovieClip;
    public var ignore:MovieClip;
    public var shadow:MovieClip;
    public var collider:MovieClip;
    public var currentCollision:MovieClip;
    public var Sounds:MovieClip;
    public var fx:MovieClip;
    public var proxy:MovieClip;
    public var bubble:MovieClip;
    private var xDep:*;
    private var yDep:*;
    private var xTar:*;
    private var yTar:Number;
    private var nDuration:*;
    private var nXStep:*;
    private var nYStep:*;
    private var walkSpeed:Number;
    private var op:Point;
    private var tp:Point;
    private var walkTS:Number;
    private var walkD:Number;
    private var headPoint:Point;
    private var cbx:*;
    private var cby:Number;
    private var bLoadingHelm:Boolean = false;
    public var pAV:Avatar;
    public var spellDur:int = 0;
    public var bBackHair:Boolean = false;
    public var isLoaded:Boolean = false;
    public var isNpc:Boolean = false;
    public var STAGE:MovieClip;
    public var world:World;
    public var px:*;
    public var py:*;
    public var tx:*;
    public var ty:Number;
    public var kv:Killvis = null;
    public var strGender:String;
    public var previousframe:int = -1;
    public var hitboxR:Rectangle;
    private var randNum:Number;
    private var weaponLoad:Boolean = true;
    private var armorLoad:Boolean = true;
    private var classLoad:Boolean = true;
    private var helmLoad:Boolean = true;
    private var hairLoad:Boolean = true;
    private var capeLoad:Boolean = true;
    private var testMC:*;
    private var topIndex:int = 0;
    public var isRasterized:Boolean;
    public var lastFlickerTime:int = 0;

    private var objLinks:Object = {};
    private var heavyAssets:Array = [];
    private var totalTransform:Object = {
        "alphaMultiplier": 1,
        "alphaOffset": 0,
        "redMultiplier": 1,
        "redOffset": 0,
        "greenMultiplier": 1,
        "greenOffset": 0,
        "blueMultiplier": 1,
        "blueOffset": 0
    };
    private var clampedTransform:ColorTransform = new ColorTransform();
    private var animQueue:Array = [];
    public var spFX:Object = {};
    public var defaultCT:ColorTransform = MovieClip(this).transform.colorTransform;
    public var CT3:ColorTransform = new ColorTransform(1, 1, 1, 1, 0xFF, 0xFF, 0xFF, 0);
    public var CT2:ColorTransform = new ColorTransform(1, 1, 1, 1, 127, 127, 127, 0);
    public var CT1:ColorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0);
    private const NEGA_MAX_RATIO:Number = -(MAX_RATIO);
    private var r:int = (Math.random() * int.MAX_VALUE);
    private var animEvents:Object = {};
    private var mcOrder:Object = {};
    public var ox:int;
    public var oy:int;

    private var _lastFrameTime:int = 0;
    private var _frameTimeThreshold:int = 200; // Minimum ms between frames for performance
    private var _collisionCheckIndex:int = 0; // For staggered collision checks
    private var _eventCheckIndex:int = 0; // For staggered event checks
    private var _spFXQueue:Array = [];

    public function AvatarMC():void {
        addFrameScript(0, frame1, 4, frame5, 7, frame8, 9, frame10, 11, frame12, 12, frame13, 13, frame14, 17, frame18, 19, frame20, 22, frame23);
        Sounds.visible = false;
        ignore.visible = false;
		collider.visible = false;
        collider.mouseEnabled = false;

        try {
            var assetClass:Class = (game.params.domain.avatar.getDefinition("mcSkel")) as Class;
            mcChar = MovieClip(addChildAt(new (assetClass)(), 1));
        } catch (e:Error) {
        }

        mcChar.addEventListener(MouseEvent.CLICK, onClickHandler);
        mcChar.buttonMode = true;
        mcChar.pvpFlag.mouseEnabled = false;
        mcChar.pvpFlag.mouseChildren = false;
        pname.mouseChildren = false;
        pname.buttonMode = false;
        pname.ti_ox = pname.ti.x;
        pname.ti_oy = pname.ti.y;
        pname.tg_ox = pname.tg.x;
        pname.tg_oy = pname.tg.y;
        mcChar.mouseChildren = true;
        bubble.mouseEnabled = (bubble.mouseChildren = false);
        shadow.mouseEnabled = (shadow.mouseChildren = false);
        shadow.cacheAsBitmap = true;
        this.addEventListener(Event.ENTER_FRAME, checkQueue, false, 0, true);
        bubble.visible = false;
        bubble.t = "";
        pname.ti.text = "";
        headPoint = new Point(0, (this.mcChar.head.y - (1.4 * this.mcChar.head.height)));
        hideOptionalParts();
    }

    public function get location():Point {
        return new Point(x, y);
    }

    public function fClose():void {
        if (pAV != null) {
            pAV.unloadPet();

            if (pAV == world.myAvatar) {
                world.setTarget(null);
            } else {
                pAV.target = null;
            }

            pAV.pMC = null;
            pAV = null;
        }
        recursiveStop(this);
        world = MovieClip(stage.getChildAt(0)).world;
        mcChar.removeEventListener(MouseEvent.CLICK, onClickHandler);
        pname.removeEventListener(MouseEvent.CLICK, onClickHandler);
        this.removeEventListener(Event.ENTER_FRAME, onEnterFrameWalk);
        this.removeEventListener(Event.ENTER_FRAME, checkQueue);
        if (world.CHARS.contains(this)) {
            world.CHARS.removeChild(this);
        }
        if (world.TRASH.contains(this)) {
            world.TRASH.removeChild(this);
        }
        try {
            if (getChildByName("HealIconMC") != null) {
                MovieClip(getChildByName("HealIconMC")).fClose();
            }
        } catch (e:Error) {
        }
        while (fx.numChildren > 0) {
            fx.removeChildAt(0);
        }
    }

    override public function gotoAndPlay(_arg_1:Object, _arg_2:String = null):void {
        handleAnimEvent(String(_arg_1));
        super.gotoAndPlay(_arg_1);
    }

    public function disablePNameMouse():void {
        mouseEnabled = false;
        pname.mouseEnabled = false;
        pname.mouseChildren = false;
        pname.removeEventListener(MouseEvent.CLICK, onClickHandler);
    }

    public function hasLabel(str:String):Boolean {
        var labels:Array = mcChar.currentLabels;
        var i:int = 0;

        while (i < labels.length) {
            if (labels[i].name == str) {
                return true;
            }
            i++;
        }

        return false;
    }

    private function recursiveStop(_arg_1:MovieClip):void {
        var _local_3:DisplayObject;
        var _local_2:int;
        while (_local_2 < _arg_1.numChildren) {
            _local_3 = _arg_1.getChildAt(_local_2);
            if ((_local_3 is MovieClip)) {
                MovieClip(_local_3).stop();
                recursiveStop(MovieClip(_local_3));
            }
            _local_2++;
        }
    }

    public function showHPBar():void {
        this.hpBar.y = (this.pname.y - 3);
        this.hpBar.visible = true;
        updateHPBar();
    }

    public function hideHPBar():void {
        this.hpBar.visible = false;
    }

    public function updateHPBar():void {
        var _local_3:Object;
        var _local_1:MovieClip = (this.hpBar.g as MovieClip);
        var _local_2:MovieClip = (this.hpBar.r as MovieClip);
        if (this.hpBar.visible) {
            _local_3 = this.pAV.dataLeaf;
            if (((!(_local_3 == null)) && (!(_local_3.intHP == null)))) {
                _local_1.visible = true;
                _local_1.width = Math.round(((_local_3.intHP / _local_3.intHPMax) * _local_2.width));
                if (_local_3.intHP < 1) {
                    _local_1.visible = false;
                }
            }
        }
    }

    public function updateName():void {
        if (pAV.pnm == null) return;

        var uoLeaf:Object = world.uoTree[pAV.pnm];
        if (uoLeaf == null) uoLeaf = world.uoTree[pAV.pnm.toLowerCase()];

        try {
            pname.ti.text = String(uoLeaf != null && uoLeaf.afk ? ("<AFK> " + pAV.objData.strUsername) : pAV.objData.strUsername).toUpperCase();

            if (pAV.objData.guild != null)
            {
                pname.ti.y = pname.ti_oy;
                pname.tg.y = pname.tg_oy;
                pname.tg.text = ("< " + String(pAV.objData.guild.Name).toUpperCase() + " >");
                pname.tg.textColor = pAV.objData.guild.Color;
            }
            else
            {
                pname.ti.y = pname.tg.y;
            }

        } catch (e:Error) {
        }
    }

    private function hideOptionalParts():void {
        var _local_1:* = ["cape", "backhair", "robe", "backrobe", "pvpFlag"];
        var _local_2:* = ["weapon", "weaponOff", "weaponFist", "weaponFistOff", "shield"];
        var _local_3:* = "";
        for (_local_3 in _local_1) {
            if (typeof (mcChar[_local_1[_local_3]]) != undefined) {
                mcChar[_local_1[_local_3]].visible = false;
            }
        }
        for (_local_3 in _local_2) {
            if (typeof (mcChar[_local_2[_local_3]]) != undefined) {
                mcChar[_local_2[_local_3]].visible = false;
            }
        }
    }

    private function onClickHandler(event:MouseEvent):void {
        world = MovieClip(stage.getChildAt(0)).world;
        var avt:Avatar = event.currentTarget.parent.pAV;

//        if (avt.pMC.isNpc) {
//            return;
//        }

        if (event.shiftKey) {
            world.onWalkClick();
        } else {
            if (!event.ctrlKey) {
                if (((((!(avt == world.myAvatar)) && (world.bPvP)) && (!(avt.dataLeaf.pvpTeam == world.myAvatar.dataLeaf.pvpTeam))) && (avt == world.myAvatar.target))) {
                    world.approachTarget();
                } else {
                    if (avt != world.myAvatar.target) {
                        world.setTarget(avt);
                    }
                }
            }
        }
    }

    public function loadClass(sFile:String, sLink:String):void {
        if (pAV.objData.eqp.co == null) {
            classLoad = false;

            if (ConfigurationData.Debug)
            {
                trace("** PMC loadClass >");
            }

            if (world.playerDomains.hasOwnProperty(sLink))
            {
                onLoadClassComplete(null);
            }
            else
            {
                world.queueLoad({
                    "strFile": world.game.getFilePath("classes/" + strGender + "/" + sFile),
                    "callBackA": world.game.onLoadToBytes(onLoadClassComplete, world.mapPlayerAssetClass(sLink)),
                    "callBackB": ioErrorHandler,
                    "avt": pAV,
                    "sES": "ar"
                });
            }
        }
    }

    public function onLoadClassComplete(_arg_1:Event):void {
        if (ConfigurationData.Debug)
        {
            trace(("** PMC onLoadClassComplete >" + pAV.objData.eqp.ar.sLink));
        }

        classLoad = true;
        if (((pAV.isMyAvatar) && (pAV.FirstLoad))) {
            pAV.updateLoaded();
            if (pAV.LoadCount <= 0) {
                pAV.firstDone();
                world.game.chatF.pushMsg("server", "Character load complete.", "SERVER", "", 0);
            }
        }

        if (pAV.objData.eqp.co == null) {
            loadArmorPieces(pAV.objData.eqp.ar.sLink);
        }
    }

    public function loadArmor(sFile:String, sLink:String):void
    {
        if (ConfigurationData.Debug)
        {
            trace("** PMC loadArmor >");
        }

        objLinks.co = sLink;
        armorLoad = false;

        if (world.playerDomains.hasOwnProperty(sLink))
        {
            onLoadArmorComplete(null);
        }
        else
        {
            world.queueLoad({
                "strFile": world.game.getFilePath("classes/" + strGender + "/" + sFile),
                "callBackA":world.game.onLoadToBytes(onLoadArmorComplete, world.mapPlayerAssetClass(sLink)),
                "callBackB":ioErrorHandler,
                "avt":pAV,
                "sES":"ar"
            });
        }
    }

    public function onLoadArmorComplete(event:Event):void {
        if (ConfigurationData.Debug)
        {
            trace(("** PMC onLoadArmorComplete >" + objLinks.co));
        }

        armorLoad = true;
        if (((pAV.isMyAvatar) && (pAV.FirstLoad))) {
            pAV.updateLoaded();
            if (pAV.LoadCount <= 0) {
                pAV.firstDone();
                world.game.chatF.pushMsg("server", "Character load complete.", "SERVER", "", 0);
            }
        }
        loadArmorPieces(objLinks.co);
        if (this.name.indexOf("previewMCB") > -1) {
            MovieClip(parent.parent).repositionPreview(MovieClip(mcChar));
        }
    }

    public function ioErrorHandler(_arg_1:IOErrorEvent):void {
        if (ConfigurationData.Debug)
        {
            trace(("ioErrorHandler: " + _arg_1));
        }
    }

    public function loadArmorPieces(strSkinLinkage:String):void {
        var AssetClass:Class;
        var child:DisplayObject;
        var drk:Color;

        if (ConfigurationData.Debug)
        {
            trace(">>>>>>>>>>>> loadArmorPieces");
        }

        try {
            AssetClass = (world.getClass(((strSkinLinkage + strGender) + "Head")) as Class);
            child = mcChar.head.getChildByName("face");
            if (child != null) {
                mcChar.head.removeChild(child);
            }
            testMC = mcChar.head.addChildAt(new (AssetClass)(), 0);
            testMC.name = "face";
        } catch (err:Error) {
            AssetClass = (world.getClass(("mcHead" + strGender)) as Class);
            child = mcChar.head.getChildByName("face");
            if (child != null) {
                mcChar.head.removeChild(child);
            }
            testMC = mcChar.head.addChildAt(new (AssetClass)(), 0);
            testMC.name = "face";
        }

        if (!isNpc)
        {
            if (pAV == world.myAvatar) {
                world.game.showPortrait(pAV);
            } else {
                if (pAV == world.myAvatar.target) {
                    world.game.showPortraitTarget(pAV);
                }
            }
        }
        try {
            AssetClass = (world.getClass(((strSkinLinkage + strGender) + "Chest")) as Class);
            mcChar.chest.removeChildAt(0);
            mcChar.chest.addChild(new (AssetClass)());
        } catch (e:Error) {
        }
        try {
            AssetClass = (world.getClass(((strSkinLinkage + strGender) + "Hip")) as Class);
            mcChar.hip.removeChildAt(0);
            mcChar.hip.addChild(new (AssetClass)());
        } catch (e:Error) {
        }
        try {
            AssetClass = (world.getClass(((strSkinLinkage + strGender) + "FootIdle")) as Class);
            mcChar.idlefoot.removeChildAt(0);
            mcChar.idlefoot.addChild(new (AssetClass)());
        } catch (e:Error) {
        }
        try {
            AssetClass = (world.getClass(((strSkinLinkage + strGender) + "Foot")) as Class);
            mcChar.frontfoot.removeChildAt(0);
            mcChar.frontfoot.addChild(new (AssetClass)());
            mcChar.frontfoot.visible = false;
            mcChar.backfoot.removeChildAt(0);
            mcChar.backfoot.addChild(new (AssetClass)());
        } catch (e:Error) {
        }
        try {
            AssetClass = (world.getClass(((strSkinLinkage + strGender) + "Shoulder")) as Class);
            mcChar.frontshoulder.removeChildAt(0);
            mcChar.frontshoulder.addChild(new (AssetClass)());
            mcChar.backshoulder.removeChildAt(0);
            mcChar.backshoulder.addChild(new (AssetClass)());
        } catch (e:Error) {
        }
        try {
            AssetClass = (world.getClass(((strSkinLinkage + strGender) + "Hand")) as Class);
            mcChar.fronthand.removeChildAt(0);
            mcChar.fronthand.addChildAt(new (AssetClass)(), 0);
            mcChar.backhand.removeChildAt(0);
            mcChar.backhand.addChildAt(new (AssetClass)(), 0);
            drk = new Color();
            drk.brightness = -1;
            mcChar.backhand.getChildAt(0).transform.colorTransform = drk;
        } catch (e:Error) {
        }
        try {
            AssetClass = (world.getClass(((strSkinLinkage + strGender) + "Thigh")) as Class);
            mcChar.frontthigh.removeChildAt(0);
            mcChar.frontthigh.addChild(new (AssetClass)());
            mcChar.backthigh.removeChildAt(0);
            mcChar.backthigh.addChild(new (AssetClass)());
        } catch (e:Error) {
        }
        try {
            AssetClass = (world.getClass(((strSkinLinkage + strGender) + "Shin")) as Class);
            mcChar.frontshin.removeChildAt(0);
            mcChar.frontshin.addChild(new (AssetClass)());
            mcChar.backshin.removeChildAt(0);
            mcChar.backshin.addChild(new (AssetClass)());
        } catch (e:Error) {
        }
        AssetClass = (world.getClass(((strSkinLinkage + strGender) + "Robe")) as Class);
        if (AssetClass != null) {
            mcChar.robe.removeChildAt(0);
            mcChar.robe.addChild(new (AssetClass)());
            mcChar.robe.visible = true;
        } else {
            mcChar.robe.visible = false;
        }
        AssetClass = (world.getClass(((strSkinLinkage + strGender) + "RobeBack")) as Class);
        if (AssetClass != null) {
            mcChar.backrobe.removeChildAt(0);
            mcChar.backrobe.addChild(new (AssetClass)());
            mcChar.backrobe.visible = true;
        } else {
            mcChar.backrobe.visible = false;
        }

        if (game.preference.data.bDisItemAnim)
        {
            if ((!pAV.isMyAvatar && game.preference.data.bKeepArmorAnimOnly) || !game.preference.data.bKeepArmorAnimOnly)
            {
                KeepAnimation(pAV, "co");
            }
        }

        gotoAndPlay("in1");
        isLoaded = true;
        handleAfterAvatarLoad();
    }

    public function handleAfterAvatarLoad():void
    {
        if (game.preference.data.bCachePlayers && !isRasterized)
        {
            if (!pAV.isMyAvatar)
            {
                mcChar.gotoAndStop("Idle");
                game.rasterize(mcChar);
                isRasterized = true;
            }
        }

        if (game.preference.data.bHideNames)
        {
            hideNameSetup();
        }

        if (((game.preference.data.bHidePlayers) && (!(pAV.isMyAvatar))))
        {
            mcChar.visible = false;
            pname.visible = game.preference.data.bShowNames;
            shadow.visible = game.preference.data.bShowShadows;
        }
    }

    public function hideNameSetup():void
    {
        if (game.preference.data.bHideSelfName)
        {
            if (pAV.isMyAvatar)
            {
                pname.visible = false;
            }
            else
            {
                hideNameCleanup();
            }
            return;
        }

        pname.ti.visible = game.preference.data.bHideGuild;
        pname.tg.visible = false;
        if (!mcChar.hasEventListener(MouseEvent.ROLL_OVER))
        {
            mcChar.addEventListener(MouseEvent.ROLL_OVER, onNameHover, false, 0, true);
            mcChar.addEventListener(MouseEvent.ROLL_OUT, onNameOut, false, 0, true);
        }
    }

    public function hideNameCleanup():void
    {
        if (mcChar.hasEventListener(MouseEvent.ROLL_OVER))
        {
            mcChar.removeEventListener(MouseEvent.ROLL_OVER, onNameHover);
            mcChar.removeEventListener(MouseEvent.ROLL_OUT, onNameOut);
        }
        pname.visible = true;
        pname.ti.visible = true;
        pname.tg.visible = pname.tg.text;
    }

    public function onNameHover(_arg_1:MouseEvent):void
    {
        if (game.preference.data.bHideGuild)
        {
            pname.tg.visible = true;
        }
        else
        {
            pname.ti.visible = true;
            pname.tg.visible = true;
        }
    }

    public function onNameOut(_arg_1:MouseEvent):void
    {
        if (game.preference.data.bHideGuild)
        {
            pname.tg.visible = false;
        }
        else
        {
            pname.ti.visible = false;
            pname.tg.visible = false;
        }
    }

    public function loadArmorPiecesFromDomain(strSkinLinkage:String, pLoaderD:ApplicationDomain):void {
        var AssetClass:Class;
        var child:DisplayObject;

        if (ConfigurationData.Debug)
        {
            trace((">>>>>>>>>>>> loadArmorPiecesFromDomain > " + strSkinLinkage));
        }

        try {
            AssetClass = (pLoaderD.getDefinition(((strSkinLinkage + strGender) + "Head")) as Class);
            child = mcChar.head.getChildByName("face");
            if (child != null) {
                mcChar.head.removeChild(child);
            }
            testMC = mcChar.head.addChildAt(new (AssetClass)(), 0);
            testMC.cacheAsBitmap = true;
            testMC.name = "face";
        } catch (err:Error) {
            AssetClass = (pLoaderD.getDefinition(("mcHead" + strGender)) as Class);
            child = mcChar.head.getChildByName("face");
            if (child != null) {
                mcChar.head.removeChild(child);
            }
            testMC = mcChar.head.addChildAt(new (AssetClass)(), 0);
            testMC.cacheAsBitmap = true;
            testMC.name = "face";
        }
        AssetClass = (pLoaderD.getDefinition(((strSkinLinkage + strGender) + "Chest")) as Class);
        mcChar.chest.removeChildAt(0);
        mcChar.chest.addChild(new (AssetClass)());
        AssetClass = (pLoaderD.getDefinition(((strSkinLinkage + strGender) + "Hip")) as Class);
        mcChar.hip.removeChildAt(0);
        mcChar.hip.addChild(new (AssetClass)());
        mcChar.hip.cacheAsBitmap = true;
        AssetClass = (pLoaderD.getDefinition(((strSkinLinkage + strGender) + "FootIdle")) as Class);
        mcChar.idlefoot.removeChildAt(0);
        mcChar.idlefoot.addChild(new (AssetClass)());
        mcChar.idlefoot.cacheAsBitmap = true;
        AssetClass = (pLoaderD.getDefinition(((strSkinLinkage + strGender) + "Foot")) as Class);
        mcChar.frontfoot.removeChildAt(0);
        mcChar.frontfoot.addChild(new (AssetClass)());
        mcChar.frontfoot.cacheAsBitmap = true;
        mcChar.frontfoot.visible = false;
        mcChar.backfoot.removeChildAt(0);
        mcChar.backfoot.addChild(new (AssetClass)());
        mcChar.backfoot.cacheAsBitmap = true;
        AssetClass = (pLoaderD.getDefinition(((strSkinLinkage + strGender) + "Shoulder")) as Class);
        mcChar.frontshoulder.removeChildAt(0);
        mcChar.frontshoulder.addChild(new (AssetClass)());
        mcChar.frontshoulder.cacheAsBitmap = true;
        mcChar.backshoulder.removeChildAt(0);
        mcChar.backshoulder.addChild(new (AssetClass)());
        mcChar.backshoulder.cacheAsBitmap = true;
        AssetClass = (pLoaderD.getDefinition(((strSkinLinkage + strGender) + "Hand")) as Class);
        mcChar.fronthand.removeChildAt(0);
        mcChar.fronthand.addChildAt(new (AssetClass)(), 0);
        mcChar.fronthand.cacheAsBitmap = true;
        mcChar.backhand.removeChildAt(0);
        mcChar.backhand.addChildAt(new (AssetClass)(), 0);
        mcChar.backhand.cacheAsBitmap = true;
        var drk:Color = new Color();
        drk.brightness = -1;
        mcChar.backhand.getChildAt(0).transform.colorTransform = drk;
        AssetClass = (pLoaderD.getDefinition(((strSkinLinkage + strGender) + "Thigh")) as Class);
        mcChar.frontthigh.removeChildAt(0);
        mcChar.frontthigh.addChild(new (AssetClass)());
        mcChar.frontthigh.cacheAsBitmap = true;
        mcChar.backthigh.removeChildAt(0);
        mcChar.backthigh.addChild(new (AssetClass)());
        mcChar.backthigh.cacheAsBitmap = true;
        AssetClass = (pLoaderD.getDefinition(((strSkinLinkage + strGender) + "Shin")) as Class);
        mcChar.frontshin.removeChildAt(0);
        mcChar.frontshin.addChild(new (AssetClass)());
        mcChar.frontshin.cacheAsBitmap = true;
        mcChar.backshin.removeChildAt(0);
        mcChar.backshin.addChild(new (AssetClass)());
        mcChar.backshin.cacheAsBitmap = true;
        try {
            AssetClass = (pLoaderD.getDefinition(((strSkinLinkage + strGender) + "Robe")) as Class);
            if (AssetClass != null) {
                mcChar.robe.removeChildAt(0);
                mcChar.robe.addChild(new (AssetClass)());
                mcChar.robe.cacheAsBitmap = true;
                mcChar.robe.visible = true;
            } else {
                mcChar.robe.visible = false;
            }
        } catch (e:Error) {
            mcChar.robe.visible = false;
        }
        try {
            AssetClass = (pLoaderD.getDefinition(((strSkinLinkage + strGender) + "RobeBack")) as Class);
            if (AssetClass != null) {
                mcChar.backrobe.removeChildAt(0);
                mcChar.backrobe.addChild(new (AssetClass)());
                mcChar.backrobe.cacheAsBitmap = true;
                mcChar.backrobe.visible = true;
            } else {
                mcChar.backrobe.visible = false;
            }
        } catch (e:Error) {
            mcChar.backrobe.visible = false;
        }
        gotoAndPlay("in1");
        isLoaded = true;
    }

    public function loadHair():void {
        var fileName:String = pAV.objData.strHairFilename;

        // (game != null && (game.preference.data.bDisLoadChar || !pAV.canLoadSelf))
        if (fileName == null || fileName == "" || fileName == "none") {
            mcChar.head.hair.visible = false;
            return;
        }

        hairLoad = false;

        if (world.playerDomains.hasOwnProperty(fileName))
        {
            onHairLoadComplete(null);
        }
        else
        {
            world.queueLoad({
                "strFile": world.game.getFilePath(fileName),
                "callBackA": world.game.onLoadToBytes(onHairLoadComplete, world.mapPlayerAssetClass(fileName)),
                "avt": pAV,
                "sES": "hair"
            });
        }
    }

    public function onHairLoadComplete(event:Event):void {
        var AssetClass:Class;

        if (ConfigurationData.Debug)
        {
            trace("onHairLoadComplete >");
        }

        hairLoad = true;
        if (((pAV.isMyAvatar) && (pAV.FirstLoad))) {
            pAV.updateLoaded();
            if (pAV.LoadCount <= 0) {
                pAV.firstDone();
                world.game.chatF.pushMsg("server", "Character load complete.", "SERVER", "", 0);
            }
        }
        try {
            AssetClass = (world.getClass(((pAV.objData.strHairName + pAV.objData.strGender) + "Hair")) as Class);
            if (AssetClass != null) {
                if (mcChar.head.hair.numChildren > 0) {
                    mcChar.head.hair.removeChildAt(0);
                }
                mcChar.head.hair.addChild(new (AssetClass)());
                mcChar.head.hair.visible = true;
            } else {
                mcChar.head.hair.visible = false;
            }
            AssetClass = (world.getClass(((pAV.objData.strHairName + pAV.objData.strGender) + "HairBack")) as Class);
            if (AssetClass != null) {
                if (mcChar.backhair.numChildren > 0) {
                    mcChar.backhair.removeChildAt(0);
                }
                mcChar.backhair.addChild(new (AssetClass)());
                mcChar.backhair.visible = true;
                bBackHair = true;
            } else {
                mcChar.backhair.visible = false;
                bBackHair = false;
            }
            if ((((pAV.isMyAvatar) && (!(MovieClip(parent.parent.parent).ui.mcPortrait.visible))) && (!(bLoadingHelm)))) {
                world.game.showPortrait(pAV);
            }
            if ((("he" in pAV.objData.eqp) && (!(pAV.objData.eqp.he == null)))) {
                mcChar.head.hair.visible = !pAV.dataLeaf.showHelm;
            }
        } catch (e:Error) {
        }
    }

    public function loadWeapon(sFile:String, sLink:String):void {
        weaponLoad = false;

        if (world.playerDomains.hasOwnProperty(sLink))
        {
            weaponLoad = true;
            onLoadWeaponComplete(null);
        }
        else
        {
            world.queueLoad({
                "strFile":world.game.getFilePath(sFile),
                "callBackA": world.game.onLoadToBytes(onLoadWeaponComplete, world.mapPlayerAssetClass(sLink)), // "callBackA": world.game.onLoadToBytes(onLoadWeaponComplete, world.loaderC),
                "avt": pAV,
                "sES": "weapon"
            });
        }
    }

    public function onLoadWeaponComplete(e:Event):void {
        var AssetClass:Class;

        if (ConfigurationData.Debug) trace("onLoadWeaponComplete >");

        weaponLoad = true;

        if (pAV.isMyAvatar && pAV.FirstLoad) {
            pAV.updateLoaded();
            if (pAV.LoadCount <= 0) {
                pAV.firstDone();
                world.game.chatF.pushMsg("server", "Character load complete.", "SERVER", "", 0);
            }
        }

        if (mcChar.weaponFist.numChildren > 0) mcChar.weaponFist.removeChildAt(0);
        if (mcChar.weaponFistOff.numChildren > 0) mcChar.weaponFistOff.removeChildAt(0);
        if (mcChar.weapon.numChildren > 0) mcChar.weapon.removeChildAt(0);
        if (mcChar.fronthand.numChildren > 1) mcChar.fronthand.removeChildAt(1);
        if (mcChar.backhand.numChildren > 1) mcChar.backhand.removeChildAt(1);

        var wItem:Object = pAV.getItemByEquipSlot("Weapon");

        try {
            AssetClass = (world.getClass(pAV.objData.eqp.Weapon.sLink) as Class);

            if (wItem.sType == "Gauntlet")
            {
                mcChar.fronthand.addChildAt(new (AssetClass)(), 1);
                mcChar.fronthand.getChildAt(1).scaleX = 0.8;
                mcChar.fronthand.getChildAt(1).scaleY = 0.8;
                mcChar.fronthand.getChildAt(1).scaleX = (mcChar.fronthand.getChildAt(1).scaleX * -1);
                mcChar.backhand.addChildAt(new (AssetClass)(), 1);
                mcChar.backhand.getChildAt(1).scaleX = 0.8;
                mcChar.backhand.getChildAt(1).scaleY = 0.8;
                mcChar.backhand.getChildAt(1).scaleX = (mcChar.backhand.getChildAt(1).scaleX * -1);
                mcChar.weapon.mcWeapon = new MovieClip();
            }
            else
            {
                if (wItem.sType != "Gauntlet")
                {
                    mcChar.weapon.mcWeapon = new (AssetClass)();
                    mcChar.weapon.addChild(mcChar.weapon.mcWeapon);
                }
            }

            trace("onLoadWeaponComplete > 1");
        } catch (err:Error) {
            if (e != null)
            {
                mcChar.weapon.mcWeapon = MovieClip(e.target.content);
                mcChar.weapon.addChild(mcChar.weapon.mcWeapon);
            }

            trace("onLoadWeaponComplete > 2");
        }

        mcChar.weapon.visible = false;
        mcChar.weaponOff.visible = false;
        mcChar.weaponFist.visible = false;
        mcChar.weaponFistOff.visible = false;

        if (wItem.sType != "Gauntlet") mcChar.weapon.visible = true;



        if (wItem != null && wItem.sType != null) {
            if (wItem.sType == "Dagger") {
                loadWeaponOff(pAV.objData.eqp.Weapon.sFile, pAV.objData.eqp.Weapon.sLink);
            }
        }

        if (game.preference.data.bDisItemAnim)
        {
            if ((!pAV.isMyAvatar && game.preference.data.bKeepWeaponAnimOnly) || !game.preference.data.bKeepWeaponAnimOnly)
            {
                KeepAnimation(pAV, "Weapon");
            }
        }
    }

    public function loadWeaponOff(_arg_1:*, _arg_2:*):void {
        weaponLoad = false;
        world.queueLoad({
            "strFile": world.game.getFilePath(_arg_1),
            "callBackA": world.game.onLoadToBytes(onLoadWeaponOffComplete, world.loaderC),
            "avt": pAV,
            "sES": "weapon"
        });
    }

    public function onLoadWeaponOffComplete(e:Event):void {
        var AssetClass:Class;

        if (ConfigurationData.Debug)
        {
            trace("onLoadWeaponOffComplete >");
        }

        weaponLoad = true;
        if (((pAV.isMyAvatar) && (pAV.FirstLoad))) {
            pAV.updateLoaded();
            if (pAV.LoadCount <= 0) {
                pAV.firstDone();
                world.game.chatF.pushMsg("server", "Character load complete.", "SERVER", "", 0);
            }
        }
        mcChar.weaponOff.removeChildAt(0);
        try {
            AssetClass = (world.getClass(pAV.objData.eqp.Weapon.sLink) as Class);
            mcChar.weaponOff.addChild(new (AssetClass)());
        } catch (err:Error) {
            mcChar.weaponOff.addChild(e.target.content);
        }
        mcChar.weaponOff.visible = true;
    }

    public function loadCape(_arg_1:*, _arg_2:*):void {
        capeLoad = false;
        world.queueLoad({
            "strFile": world.game.getFilePath(_arg_1),
            "callBackA": world.game.onLoadToBytes(onLoadCapeComplete, world.loaderC),
            "avt": pAV,
            "sES": "cape"
        });
    }

    public function onLoadCapeComplete(_arg_1:Event):void {
        var _local_2:Class;
        capeLoad = true;
        if (((pAV.isMyAvatar) && (pAV.FirstLoad))) {
            pAV.updateLoaded();
            if (pAV.LoadCount <= 0) {
                pAV.firstDone();
                world.game.chatF.pushMsg("server", "Character load complete.", "SERVER", "", 0);
            }
        }
        try {
            _local_2 = (world.getClass(pAV.objData.eqp.ba.sLink) as Class);
            mcChar.cape.removeChildAt(0);
            mcChar.cape.cape = new (_local_2)();
            mcChar.cape.addChild(mcChar.cape.cape);
            setCloakVisibility(pAV.dataLeaf.showCloak);
        } catch (e) {
        }

        if (game.preference.data.bDisItemAnim)
        {
            if ((!pAV.isMyAvatar && game.preference.data.bKeepCapeAnimOnly) || !game.preference.data.bKeepCapeAnimOnly)
            {
                KeepAnimation(pAV, "ba");
            }
        }
    }

    public function loadHelm(_arg_1:*, _arg_2:*):void {
        if (ConfigurationData.Debug)
        {
            trace("pMC.loadHelm >");
        }

        helmLoad = false;
        world.queueLoad({
            "strFile": world.game.getFilePath(_arg_1),
            "callBackA": world.game.onLoadToBytes(onLoadHelmComplete, world.loaderC),
            "avt": pAV,
            "sES": "helm"
        });
        bLoadingHelm = true;
    }

    public function onLoadHelmComplete(_arg_1:Event):void {
        if (ConfigurationData.Debug)
        {
            trace("pMC.onLoadHelmComplete >");
        }

        helmLoad = true;
        if (((pAV.isMyAvatar) && (pAV.FirstLoad))) {
            pAV.updateLoaded();
            if (pAV.LoadCount <= 0) {
                pAV.firstDone();
                world.game.chatF.pushMsg("server", "Character load complete.", "SERVER", "", 0);
            }
        }
        var _local_2:Class = (world.getClass(pAV.objData.eqp.he.sLink) as Class);
        var _local_3:Class = (world.getClass((pAV.objData.eqp.he.sLink + "_backhair")) as Class);
        if (_local_2 != null) {
            if (mcChar.head.helm.numChildren > 0) {
                mcChar.head.helm.removeChildAt(0);
            }
            mcChar.head.helm.visible = pAV.dataLeaf.showHelm;
            mcChar.head.hair.visible = (!(mcChar.head.helm.visible));
            if (_local_3 != null) {
                if (pAV.dataLeaf.showHelm) {
                    if (mcChar.backhair.numChildren > 0) {
                        mcChar.backhair.removeChildAt(0);
                    }
                    mcChar.backhair.visible = true;
                    mcChar.backhair.addChild(new (_local_3)());
                }
            } else {
                mcChar.backhair.visible = ((mcChar.head.hair.visible) && (bBackHair));
            }
            mcChar.head.helm.addChild(new (_local_2)());

            if (currentLabel == "Game")
            {
                if (pAV == world.myAvatar) {
                    world.game.showPortrait(pAV);
                }
                if (pAV == world.myAvatar.target) {
                    world.game.showPortraitTarget(pAV);
                }
            }
        }

        bLoadingHelm = false;

        if (game.preference.data.bDisItemAnim)
        {
            if ((!pAV.isMyAvatar && game.preference.data.bKeepHelmAnimOnly) || !game.preference.data.bKeepHelmAnimOnly)
            {
                KeepAnimation(pAV, "he");
            }
        }
    }

    public function setHelmVisibility(_arg_1:Boolean):void {
        if (ConfigurationData.Debug)
        {
            trace(("setHelmVisibility > " + _arg_1));
        }

        if (((!(pAV.objData.eqp.he == null)) && (!(pAV.objData.eqp.he.sLink == null)))) {
            if (_arg_1) {
                mcChar.head.helm.visible = true;
                mcChar.head.hair.visible = false;
                mcChar.backhair.visible = false;
            } else {
                mcChar.head.helm.visible = false;
                mcChar.head.hair.visible = true;
                mcChar.backhair.visible = bBackHair;
            }
            if (pAV == world.myAvatar) {
                world.game.showPortrait(pAV);
            }
            if (pAV == world.myAvatar.target) {
                world.game.showPortraitTarget(pAV);
            }
        }
    }

    public function setCloakVisibility(_arg_1:Boolean):void {
        if (ConfigurationData.Debug)
        {
            trace(("setCloakVisibility > " + _arg_1));
        }

        if (((!(pAV.objData.eqp.ba == null)) && (!(pAV.objData.eqp.ba.sLink == null)))) {
            if (pAV.isMyAvatar) {
                mcChar.cape.visible = _arg_1;
            } else {
                mcChar.cape.visible = ((_arg_1) && (!(world.hideAllCapes)));
            }
        }
    }

    public function setColor(_arg_1:MovieClip, _arg_2:String, _arg_3:String, _arg_4:String):void {
        var _local_5:Number = Number(pAV.objData[("intColor" + _arg_3)]);
        _arg_1.isColored = true;
        _arg_1.intColor = _local_5;
        _arg_1.strLocation = _arg_3;
        _arg_1.strShade = _arg_4;
        changeColor(_arg_1, _local_5, _arg_4);
    }

    public function changeColor(_arg_1:MovieClip, _arg_2:Number, _arg_3:String, _arg_4:String = ""):void {
        var _local_5:ColorTransform = new ColorTransform();
        if (_arg_4 == "") {
            _local_5.color = _arg_2;
        }
        switch (_arg_3.toUpperCase()) {
            case "LIGHT":
                _local_5.redOffset = (_local_5.redOffset + 100);
                _local_5.greenOffset = (_local_5.greenOffset + 100);
                _local_5.blueOffset = (_local_5.blueOffset + 100);
                break;
            case "DARK":
                _local_5.redOffset = (_local_5.redOffset - 25);
                _local_5.greenOffset = (_local_5.greenOffset - 50);
                _local_5.blueOffset = (_local_5.blueOffset - 50);
                break;
            case "DARKER":
                _local_5.redOffset = (_local_5.redOffset - 125);
                _local_5.greenOffset = (_local_5.greenOffset - 125);
                _local_5.blueOffset = (_local_5.blueOffset - 125);
                break;
        }
        if (_arg_4 == "-") {
            _local_5.redOffset = (_local_5.redOffset * -1);
            _local_5.greenOffset = (_local_5.greenOffset * -1);
            _local_5.blueOffset = (_local_5.blueOffset * -1);
        }
        if (((_arg_4 == "") || (!(_arg_1.transform.colorTransform.redOffset == _local_5.redOffset)))) {
            _arg_1.transform.colorTransform = _local_5;
        }
    }

    public function modulateColor(_arg_1:ColorTransform, _arg_2:String):void {
        var _local_3:MovieClip = (this.stage.getChildAt(0) as MovieClip);
        if (_arg_2 == "+") {
            totalTransform.alphaMultiplier = (totalTransform.alphaMultiplier + _arg_1.alphaMultiplier);
            totalTransform.alphaOffset = (totalTransform.alphaOffset + _arg_1.alphaOffset);
            totalTransform.redMultiplier = (totalTransform.redMultiplier + _arg_1.redMultiplier);
            totalTransform.redOffset = (totalTransform.redOffset + _arg_1.redOffset);
            totalTransform.greenMultiplier = (totalTransform.greenMultiplier + _arg_1.greenMultiplier);
            totalTransform.greenOffset = (totalTransform.greenOffset + _arg_1.greenOffset);
            totalTransform.blueMultiplier = (totalTransform.blueMultiplier + _arg_1.blueMultiplier);
            totalTransform.blueOffset = (totalTransform.blueOffset + _arg_1.blueOffset);
        } else {
            if (_arg_2 == "-") {
                totalTransform.alphaMultiplier = (totalTransform.alphaMultiplier - _arg_1.alphaMultiplier);
                totalTransform.alphaOffset = (totalTransform.alphaOffset - _arg_1.alphaOffset);
                totalTransform.redMultiplier = (totalTransform.redMultiplier - _arg_1.redMultiplier);
                totalTransform.redOffset = (totalTransform.redOffset - _arg_1.redOffset);
                totalTransform.greenMultiplier = (totalTransform.greenMultiplier - _arg_1.greenMultiplier);
                totalTransform.greenOffset = (totalTransform.greenOffset - _arg_1.greenOffset);
                totalTransform.blueMultiplier = (totalTransform.blueMultiplier - _arg_1.blueMultiplier);
                totalTransform.blueOffset = (totalTransform.blueOffset - _arg_1.blueOffset);
            }
        }
        clampedTransform.alphaMultiplier = _local_3.clamp(totalTransform.alphaMultiplier, -1, 1);
        clampedTransform.alphaOffset = _local_3.clamp(totalTransform.alphaOffset, -255, 0xFF);
        clampedTransform.redMultiplier = _local_3.clamp(totalTransform.redMultiplier, -1, 1);
        clampedTransform.redOffset = _local_3.clamp(totalTransform.redOffset, -255, 0xFF);
        clampedTransform.greenMultiplier = _local_3.clamp(totalTransform.greenMultiplier, -1, 1);
        clampedTransform.greenOffset = _local_3.clamp(totalTransform.greenOffset, -255, 0xFF);
        clampedTransform.blueMultiplier = _local_3.clamp(totalTransform.blueMultiplier, -1, 1);
        clampedTransform.blueOffset = _local_3.clamp(totalTransform.blueOffset, -255, 0xFF);
        this.transform.colorTransform = clampedTransform;
    }

    public function updateColor(data:Object = null):void {
        var objData:Object = pAV.objData;

        if (data != null) {
            objData = data;
        }

        scanColor(this, objData);
    }

    public function scanColor(mc:MovieClip, cData:*):void
    {
        var child:DisplayObject;
        if (("isColored" in mc))
        {
            changeColor(mc, Number(cData[("intColor" + mc.strLocation)]), mc.strShade);
        }
        var i:int = 0;
        while (i < mc.numChildren)
        {
            child = mc.getChildAt(i);
            if ((child is MovieClip))
            {
                scanColor(MovieClip(child), cData);
            }
            i++;
        }
    }

    public function queueAnim(s:String):void {
        var petSplit:Array;
        var p:String;
        var pItem:Object;
        var wItem:Object;
        var sType:* = undefined;
        var world:MovieClip = (MovieClip(stage.getChildAt(0)).world as MovieClip);
        var l:String;

        if ((((this.pAV.isMyAvatar && pAV.npcType != "p") && (game.preference.data.bDisSelfMAnim)) && (!(s == "Walk"))))
        {
            return;
        }
        if ((((!(this.pAV.isMyAvatar && pAV.npcType != "p")) && (!(world.showAnimations))) && (!(s == "Walk"))))
        {
            return;
        }

        if (s.indexOf("Pet") > -1) {
            pItem = pAV.getItemByEquipSlot("pe");
            if (s.indexOf(":") > -1) {
                petSplit = s.split(":");
                s = petSplit[0];
                try {
                    if (pItem != null) {
                        if (petSplit[1] == "PetAttack") {
                            p = ["Attack1", "Attack2"][Math.round((Math.random() * 1))];
                            if (pAV.petMC.mcChar.currentLabel == "Idle") {
                                pAV.petMC.mcChar.gotoAndPlay(p);
                            }
                        } else {
                            p = petSplit[1].slice(3);
                            if (pAV.petMC.mcChar.currentLabel == "Idle") {
                                pAV.petMC.mcChar.gotoAndPlay(p);
                            }
                        }
                    }
                } catch (e) {
                }
            } else {
                if (pItem != null) {
                    try {
                        p = ["Attack1", "Attack2"][Math.round((Math.random() * 1))];
                        if (pAV.petMC.mcChar.currentLabel == "Idle") {
                            pAV.petMC.mcChar.gotoAndPlay(p);
                        }
                        return;
                    } catch (e) {
                        s = ["Attack1", "Attack2"][Math.round((Math.random() * 1))];
                    }
                } else {
                    s = ((s.indexOf("1") > -1) ? "Attack1" : "Attack2");
                }
            }
        }

        if (((s == "Attack1") || (s == "Attack2"))) {
            wItem = pAV.getItemByEquipSlot("Weapon");
            if (((!(wItem == null)) && (!(wItem.sType == null)))) {
                sType = wItem.sType;

//                trace("queueAnim > " + s + " TYPE > " + sType);
//                trace(JSON.stringify(wItem));

                switch (sType) {
                    case "Unarmed":
                        s = ["UnarmedAttack1", "UnarmedAttack2", "KickAttack", "FlipAttack"][Math.round((Math.random() * 3))];
                        break;
                    case "Polearm":
                        s = ["PolearmAttack1", "PolearmAttack2"][Math.round((Math.random() * 1))];
                        break;
                    case "Dagger":
                        s = ["DuelWield/DaggerAttack1", "DuelWield/DaggerAttack2"][Math.round((Math.random() * 1))];
                        break;
                    case "Bow":
                        s = "RangedAttack3";
                        break;
                    case "Whip":
                        s = "WhipAttack";
                        break;
                    case "HandGun":
                        s = ["GunAttack", "GunAttack2"][Math.round((Math.random() * 1))];
                        break;
                    case "Rifle":
                        s = "RifleAttack2";
                        break;
                    case "Gauntlet":
                        s = ["UnarmedAttack1", "UnarmedAttack2", "FistweaponAttack1", "FistweaponAttack2"][Math.round((Math.random() * 3))];
                        break;
                }
            }
        }

        if (((hasLabel(s)) && (pAV.dataLeaf.intState > 0))) {
            pAV.handleItemAnimation();
            world = (MovieClip(stage.getChildAt(0)).world as MovieClip);
            l = mcChar.currentLabel;
            if (((world.combatAnims.indexOf(s) > -1) && (world.combatAnims.indexOf(l) > -1))) {
                animQueue.push(s);
            } else {
                mcChar.gotoAndPlay(s);
                if (mcChar.weapon.mcWeapon && s.indexOf("Attack") >= 0 && mcChar.weapon.mcWeapon.bAttack) {
                    mcChar.weapon.mcWeapon.gotoAndPlay("Attack");
                }
            }
        }
    }

    private function checkQueue(_arg_1:Event):Boolean {
	    try
		{
		    var _local_2:MovieClip;
            var _local_3:String;
            var _local_4:int;
            var _local_5:*;
            if (animQueue.length > 0) {
                _local_2 = (MovieClip(stage.getChildAt(0)).world as MovieClip);
                _local_3 = mcChar.currentLabel;
                _local_4 = mcChar.emoteLoopFrame();
                if (((_local_2.combatAnims.indexOf(_local_3) > -1) && (mcChar.currentFrame > (_local_4 + 4)))) {
                    _local_5 = animQueue[0];
                    mcChar.gotoAndPlay(_local_5);
                    if (((_local_5.indexOf("Attack") >= 0) && mcChar.weapon.mcWeapon.bAttack)) {
                        mcChar.weapon.mcWeapon.gotoAndPlay("Attack");
                    }
                    animQueue.shift();
                    return true;
                }
            }
		}
		catch(e:Error)
		{
		    if (hasEventListener(Event.ENTER_FRAME))
			{
			    removeEventListener(Event.ENTER_FRAME, checkQueue);
			}
		}

        return false;
    }

    public function clearQueue():void {
        animQueue = [];
    }

    private function linearTween(_arg_1:*, _arg_2:*, _arg_3:*, _arg_4:*):Number {
        return (((_arg_3 * _arg_1) / _arg_4) + _arg_2);
    }

    public function walkTo(toX:int, toY:int, walkSpeed:int):void {
        var dist:Number;
        var dx:Number;
        var isOK:Boolean = true;
        try {
            STAGE = MovieClip(parent.parent);
        } catch (e:Error) {
            isOK = false;
        }
        if (isOK) {
            if (pAV.petMC != null && pAV.petMC.mcChar != null) {
                pAV.petMC.walkTo((toX - 20), (toY + 5), (walkSpeed - 3));
            }
            op = new Point(this.x, this.y);
            tp = new Point(toX, toY);
            this.walkSpeed = walkSpeed;
            dist = Point.distance(op, tp);
            walkTS = new Date().getTime();
            walkD = Math.round((1000 * (dist / (walkSpeed * 22))));
            if (walkD > 0) {
                dx = (op.x - tp.x);
                if (dx < 0) {
                    this.turn("right");
                } else {
                    this.turn("left");
                }
                if (!this.mcChar.onMove) {
                    this.mcChar.onMove = true;
                    if (this.mcChar.currentLabel != "Walk") {
                        this.mcChar.gotoAndPlay("Walk");
                    }
                }
                this.removeEventListener(Event.ENTER_FRAME, onEnterFrameWalk);
                this.addEventListener(Event.ENTER_FRAME, onEnterFrameWalk);
            }
        }
    }

    private function onEnterFrameWalk(_arg_1:Event):void
        {
            var prevX:Number;
            var prevY:Number;
            var currentTime:Number = new Date().getTime();

            if (currentTime - _lastFrameTime < _frameTimeThreshold) return;

            var elapsed:Number = ((currentTime - walkTS) / walkD);
            if (elapsed > 1) elapsed = 1;

            if (Point.distance(op, tp) <= 0.5 || !this.mcChar.onMove)
            {
                this.stopWalking();
                return;
            }

            if (checkCollisions(prevX, prevY))
            {
                this.x = prevX;
                this.y = prevY;
                this.stopWalking();
                return;
            }

            prevX = this.x;
            prevY = this.y;

            this.x = op.x + (tp.x - op.x) * elapsed;
            this.y = op.y + (tp.y - op.y) * elapsed;

            if (Math.round(prevX) == Math.round(this.x) && Math.round(prevY) == Math.round(this.y) && currentTime > (walkTS + 50))
            {
                this.stopWalking();
                return;
            }

            if (this.pAV.isMyAvatar)
            {
                Game.root.world.mapScrollCheck();
                checkPadLabels();
                checkEventsStaggered();
            }
        }

    private function checkCollisions(prevX:Number, prevY:Number):Boolean
    {
        var hasCollision:Boolean = false;
        var solidLength:int = STAGE.arrSolid.length;

        // Only check a subset of collisions each frame
        var checkCount:int = Math.min(5, solidLength); // Check up to 5 solids per frame
        var startIndex:int = _collisionCheckIndex;

        for (var i:int = 0; i < checkCount; i++)
        {
            var index:int = (startIndex + i) % solidLength;

            if (this.shadow.hitTestObject(STAGE.arrSolid[index].shadow))
            {
                // Try Y axis first
                this.y = prevY;
                var collisionY:Boolean = false;

                for (var j:int = 0; j < checkCount; j++)
                {
                    var jIndex:int = (startIndex + j) % solidLength;
                    if (this.shadow.hitTestObject(STAGE.arrSolid[jIndex].shadow))
                    {
                        collisionY = true;
                        break;
                    }
                }

                if (collisionY)
                {
                    // Try X axis
                    this.x = prevX;

                    for (var k:int = 0; k < checkCount; k++)
                    {
                        var kIndex:int = (startIndex + k) % solidLength;
                        if (this.shadow.hitTestObject(STAGE.arrSolid[kIndex].shadow))
                        {
                            hasCollision = true;
                            break;
                        }
                    }
                }

                if (hasCollision) break;
            }
        }

        _collisionCheckIndex = (_collisionCheckIndex + checkCount) % solidLength;

        return hasCollision;
    }

    private function checkEventsStaggered():void
    {
        var eventLength:int = STAGE.arrEvent.length;
        if (eventLength == 0) return;

        // Check 3 events per frame (adjust as needed)
        var checkCount:int = Math.min(3, eventLength);
        var startIndex:int = _eventCheckIndex;

        for (var i:int = 0; i < checkCount; i++)
        {
            var index:int = (startIndex + i) % eventLength;
            var eventObj:* = STAGE.arrEvent[index];
            var isInside:Boolean = false;

            if (world.bPvP)
            {
                var point:Point = this.shadow.localToGlobal(new Point(0, 0));
                var bounds:Rectangle = eventObj.shadow.getBounds(stage);
                isInside = bounds.containsPoint(point);
            }
            else
            {
                isInside = this.shadow.hitTestObject(eventObj.shadow);
            }

            if (isInside)
            {
                if (!eventObj._entered && MovieClip(eventObj).isEvent)
                {
                    eventObj._entered = true;
                    if (this == MovieClip(parent.parent).myAvatar.pMC)
                    {
                        eventObj.dispatchEvent(new Event("enter"));
                    }
                }
            }
            else if (eventObj._entered)
            {
                if (MovieClip(eventObj).isEvent && this == MovieClip(parent.parent).myAvatar.pMC)
                {
                    eventObj.dispatchEvent(new Event("leave"));
                }
                eventObj._entered = false;
            }
        }

        // Update index for next frame
        _eventCheckIndex = (_eventCheckIndex + checkCount) % eventLength;
    }

    public function simulateTo(_arg_1:int, _arg_2:int, _arg_3:int):Point {
        STAGE = MovieClip(parent.parent);
        this.xDep = this.x;
        this.yDep = this.y;
        this.xTar = _arg_1;
        this.yTar = _arg_2;
        this.walkSpeed = _arg_3;
        this.nDuration = Math.round((Math.sqrt((Math.pow((this.xTar - this.x), 2) + Math.pow((this.yTar - this.y), 2))) / _arg_3));
        var _local_4:* = new Point();
        if (this.nDuration) {
            this.nXStep = 0;
            this.nYStep = 0;
            if (!this.mcChar.onMove) {
                this.mcChar.onMove = true;
            }
            _local_4 = simulateWalkLoop();
        } else {
            _local_4 = null;
        }
        this.x = this.xDep;
        this.y = this.yDep;
        this.mcChar.onMove = false;
        return (_local_4);
    }

    private function simulateWalkLoop():Point {
        var _local_1:*;
        var _local_2:*;
        var _local_3:Boolean;
        var _local_4:*;
        var _local_5:*;
        var _local_6:*;
        var _local_7:*;
        while ((((this.nXStep <= this.nDuration) || (this.nYStep <= this.nDuration)) && (this.mcChar.onMove))) {
            _local_1 = this.x;
            _local_2 = this.y;
            this.x = linearTween(this.nXStep, this.xDep, (this.xTar - this.xDep), this.nDuration);
            this.y = linearTween(this.nYStep, this.yDep, (this.yTar - this.yDep), this.nDuration);
            _local_3 = false;
            _local_4 = 0;
            while (_local_4 < STAGE.arrSolid.length) {
                if (this.shadow.hitTestObject(STAGE.arrSolid[_local_4].shadow)) {
                    _local_3 = true;
                    _local_4 = STAGE.arrSolid.length;
                }
                _local_4++;
            }
            if (_local_3) {
                _local_5 = this.y;
                this.y = _local_2;
                _local_3 = false;
                _local_6 = 0;
                while (_local_6 < STAGE.arrSolid.length) {
                    if (this.shadow.hitTestObject(STAGE.arrSolid[_local_6].shadow)) {
                        this.y = _local_5;
                        _local_3 = true;
                        break;
                    }
                    _local_6++;
                }
                if (_local_3) {
                    this.x = _local_1;
                    _local_3 = false;
                    _local_7 = 0;
                    while (_local_7 < STAGE.arrSolid.length) {
                        if (this.shadow.hitTestObject(STAGE.arrSolid[_local_7].shadow)) {
                            _local_3 = true;
                            break;
                        }
                        _local_7++;
                    }
                    if (_local_3) {
                        this.x = _local_1;
                        this.y = _local_2;
                        this.mcChar.onMove = false;
                        this.nDuration = -1;
                        return (new Point(this.x, this.y));
                    }
                    if (this.nYStep <= this.nDuration) {
                        this.nYStep++;
                    }
                } else {
                    if (this.nXStep <= this.nDuration) {
                        this.nXStep++;
                    }
                }
            } else {
                if (this.nXStep <= this.nDuration) {
                    this.nXStep++;
                }
                if (this.nYStep <= this.nDuration) {
                    this.nYStep++;
                }
            }
            if ((((Math.round(_local_1) == Math.round(this.x)) && (Math.round(_local_2) == Math.round(this.y))) && ((this.nXStep > 1) || (this.nYStep > 1)))) {
                this.mcChar.onMove = false;
                this.nDuration = -1;
                return (new Point(this.x, this.y));
            }
        }
        this.mcChar.onMove = false;
        this.nDuration = -1;
        return (new Point(this.x, this.y));
    }

    public function stopWalking():void {
        try
        {
            world = MovieClip(stage.getChildAt(0)).world;
            if (this.mcChar.onMove) {
                this.removeEventListener(Event.ENTER_FRAME, onEnterFrameWalk);
                if (((this.pAV.isMyAvatar) && (MovieClip(parent.parent).actionReady))) {
                    world.testAction(world.getAutoAttack());
                }
            }
            this.mcChar.onMove = false;
            if (this.walkSpeed > 23) {
                this.mcChar.gotoAndPlay("Fight");
            } else {
                this.mcChar.gotoAndPlay("Idle");
            }
        }
        catch (e:Error)
        {
            removeEventListener(Event.ENTER_FRAME, onEnterFrameWalk);
        }
    }

    public function checkPadLabels():* {
        var _local_4:*;
        var _local_5:*;
        var _local_1:* = MovieClip(stage.getChildAt(0));
        var _local_2:* = _local_1.ui;
        var _local_3:int;
        while (_local_3 < _local_2.mcPadNames.numChildren) {
            _local_4 = MovieClip(_local_2.mcPadNames.getChildAt(_local_3));
            _local_5 = new Point(4, 8);
            _local_5 = _local_4.cnt.localToGlobal(_local_5);
            if (_local_1.distanceO(this, _local_5) < 200) {
                if (!_local_4.isOn) {
                    _local_4.isOn = true;
                    _local_4.gotoAndPlay("in");
                }
            } else {
                if (_local_4.isOn) {
                    _local_4.isOn = false;
                    _local_4.gotoAndPlay("out");
                }
            }
            _local_3++;
        }
    }

    public function turn(_arg_1:String):void {
        if ((((_arg_1 == "right") && (this.mcChar.scaleX < 0)) || ((_arg_1 == "left") && (this.mcChar.scaleX > 0)))) {
            this.mcChar.scaleX = (this.mcChar.scaleX * -1);
        }
    }

    public function scale(_arg_1:Number):void {
        if ((this.mcChar.scaleX >= 0)) {
            this.mcChar.scaleX = _arg_1;
        } else {
            this.mcChar.scaleX = -(_arg_1);
        }
        this.mcChar.scaleY = _arg_1;
        this.shadow.scaleX = (this.shadow.scaleY = _arg_1);
        var _local_2:Point = this.mcChar.localToGlobal(headPoint);
        _local_2 = this.globalToLocal(_local_2);
        this.pname.y = int(_local_2.y - 6);
        this.bubble.y = int((this.pname.y - this.bubble.height));
        this.ignore.y = int(((this.pname.y - this.ignore.height) - 2));
        drawHitBox();
    }

    public function endAction():void {
        var _local_2:Number;
        var _local_3:String;
        var _local_4:Object;
        var _local_5:*;
        var _local_1:* = null;
        if (this.pAV.target != null) {
            _local_1 = this.pAV.target.pMC.mcChar;
        }
        if (!checkQueue(null)) {
            if (this.mcChar.onMove) {
                this.mcChar.gotoAndPlay("Walk");
                _local_2 = (this.x - this.xTar);
                if ((_local_2 < 0)) {
                    this.turn("right");
                } else {
                    this.turn("left");
                }
            } else {
                if (((_local_1 == null) || ((!(_local_1 == null)) && ((((_local_1.currentLabel == "Die") || (_local_1.currentLabel == "Feign")) || (_local_1.currentLabel == "Dead")) || ((this.pAV.target.npcType == "player") && ((!("pvpTeam" in this.pAV.dataLeaf)) || (this.pAV.dataLeaf.pvpTeam == this.pAV.target.dataLeaf.pvpTeam))))))) {
                    if (this.mcChar.currentLabel != "Jump") {
                        this.mcChar.gotoAndPlay("Idle");
                    }
                    if (_local_1 != null) {
                        if (this.pAV.target.dataLeaf.intState == 0) {
                            if (this.pAV == world.myAvatar) {
                                world.setTarget(null);
                            }
                        }
                    }
                } else {
                    _local_3 = "Fight";
                    _local_4 = pAV.getItemByEquipSlot("Weapon");
                    if (((!(_local_4 == null)) && (!(_local_4.sType == null)))) {
                        _local_5 = _local_4.sType;
                        if (_local_4.ItemID == 156) {
                            _local_5 = "Unarmed";
                        }
                        switch (_local_5) {
                            case "Unarmed":
                                _local_3 = "UnarmedFight";
                                break;
                            case "Polearm":
                                _local_3 = "PolearmFight";
                                break;
                            case "Dagger":
                                _local_3 = "DuelWield/DaggerFight";
                                break;
                        }
                    }
                    this.mcChar.gotoAndPlay(_local_3);
                }
            }
        }
    }

    private function drawHitBox():void {
        mcChar.hitbox.graphics.clear();
        var _local_1:int = -30;
        var _local_2:int = 60;
        var _local_3:int = mcChar.head.y;
        var _local_4:int = (-(_local_3) * 0.8);
        hitboxR = new Rectangle(_local_1, _local_3, _local_2, _local_4);
        var _local_5:Graphics = mcChar.hitbox.graphics;
        _local_5.lineStyle(0, 0xFFFFFF, 0);
        _local_5.beginFill(0xAA00FF, 0);
        _local_5.moveTo(_local_1, _local_3);
        _local_5.lineTo((_local_1 + _local_2), _local_3);
        _local_5.lineTo((_local_1 + _local_2), (_local_3 + _local_4));
        _local_5.lineTo(_local_1, (_local_3 + _local_4));
        _local_5.lineTo(_local_1, _local_3);
        _local_5.endFill();
    }

    public function showHealIcon():void {
        if (game.preference.data.bDisHealBubble) return;

        var _local_1:HealIconMC;
        if (!getChildByName("HealIconMC")) {
            _local_1 = new HealIconMC(pAV, world);
            _local_1.name = "HealIconMC";
            addChild(_local_1);
        }
    }

    private function randomNumber(_arg_1:Number, _arg_2:Number):Number {
        randNum = (_arg_1 + (((_arg_2 + 1) - _arg_1) * XORandom()));
        return ((randNum < _arg_2) ? randNum : _arg_2);
    }

    private function XORandom():Number {
        r = (r ^ (r << 21));
        r = (r ^ (r >>> 35));
        r = (r ^ (r << 4));
        if (r > 0) {
            return (r * MAX_RATIO);
        }
        return (r * NEGA_MAX_RATIO);
    }

    public function iaF(_arg_1:Object):void {
        var _local_2:MovieClip;
        _local_2 = (mcChar.head.getChildAt(0) as MovieClip);
        if (_local_2 != null) {
            try {
                _local_2.iaF(_arg_1);
            } catch (e) {
            }
        }
        _local_2 = (mcChar.chest.getChildAt(0) as MovieClip);
        if (_local_2 != null) {
            try {
                _local_2.iaF(_arg_1);
            } catch (e) {
            }
        }
        _local_2 = (mcChar.hip.getChildAt(0) as MovieClip);
        if (_local_2 != null) {
            try {
                _local_2.iaF(_arg_1);
            } catch (e) {
            }
        }
        _local_2 = (mcChar.idlefoot.getChildAt(0) as MovieClip);
        if (_local_2 != null) {
            try {
                _local_2.iaF(_arg_1);
            } catch (e) {
            }
        }
        _local_2 = (mcChar.frontfoot.getChildAt(0) as MovieClip);
        if (_local_2 != null) {
            try {
                _local_2.iaF(_arg_1);
            } catch (e) {
            }
        }
        _local_2 = (mcChar.backfoot.getChildAt(0) as MovieClip);
        if (_local_2 != null) {
            try {
                _local_2.iaF(_arg_1);
            } catch (e) {
            }
        }
        _local_2 = (mcChar.frontshoulder.getChildAt(0) as MovieClip);
        if (_local_2 != null) {
            try {
                _local_2.iaF(_arg_1);
            } catch (e) {
            }
        }
        _local_2 = (mcChar.backshoulder.getChildAt(0) as MovieClip);
        if (_local_2 != null) {
            try {
                _local_2.iaF(_arg_1);
            } catch (e) {
            }
        }
        _local_2 = (mcChar.fronthand.getChildAt(0) as MovieClip);
        if (_local_2 != null) {
            try {
                _local_2.iaF(_arg_1);
            } catch (e) {
            }
        }
        _local_2 = (mcChar.backhand.getChildAt(0) as MovieClip);
        if (_local_2 != null) {
            try {
                _local_2.iaF(_arg_1);
            } catch (e) {
            }
        }
        _local_2 = (mcChar.frontthigh.getChildAt(0) as MovieClip);
        if (_local_2 != null) {
            try {
                _local_2.iaF(_arg_1);
            } catch (e) {
            }
        }
        _local_2 = (mcChar.backthigh.getChildAt(0) as MovieClip);
        if (_local_2 != null) {
            try {
                _local_2.iaF(_arg_1);
            } catch (e) {
            }
        }
        _local_2 = (mcChar.frontshin.getChildAt(0) as MovieClip);
        if (_local_2 != null) {
            try {
                _local_2.iaF(_arg_1);
            } catch (e) {
            }
        }
        _local_2 = (mcChar.backshin.getChildAt(0) as MovieClip);
        if (_local_2 != null) {
            try {
                _local_2.iaF(_arg_1);
            } catch (e) {
            }
        }
        _local_2 = (mcChar.robe.getChildAt(0) as MovieClip);
        if (_local_2 != null) {
            try {
                _local_2.iaF(_arg_1);
            } catch (e) {
            }
        }
        _local_2 = (mcChar.backrobe.getChildAt(0) as MovieClip);
        if (_local_2 != null) {
            try {
                _local_2.iaF(_arg_1);
            } catch (e) {
            }
        }
    }

    public function clearSpFXQueue():void
    {
        _spFXQueue = [];
    }

    public function canCastSpFX():void
    {
        if (_spFXQueue.length < 1)
        {
            return;
        }
        world.castSpellFX(this.pAV, nextSpFX, null, 0);
    }

    public function get nextSpFX():Object
    {
        return (_spFXQueue.shift());
    }

    public function queueSpFX(_arg_1:Object):void
    {
        if (spFX.strl != "")
        {
            _spFXQueue.push(_arg_1);
        }
        else
        {
            spFX = _arg_1;
        }
    }

    public function playSound():void {
    }

    public function addAnimationListener(_arg_1:String, _arg_2:Function):void {
        if (animEvents[_arg_1] == null) {
            animEvents[_arg_1] = [];
        }
        if (!hasAnimationListener(_arg_1, _arg_2)) {
            animEvents[_arg_1].push(_arg_2);
        }
    }

    public function removeAnimationListener(_arg_1:String, _arg_2:Function):void {
        if (animEvents[_arg_1] == null) {
            return;
        }
        var _local_3:uint;
        while (_local_3 < animEvents[_arg_1].length) {
            if (animEvents[_arg_1][_local_3] == _arg_2) {
                animEvents[_arg_1].splice(_local_3, 1);
                return;
            }
            _local_3++;
        }
    }

    public function hasAnimationListener(_arg_1:String, _arg_2:Function):Boolean {
        if (animEvents[_arg_1] == null) {
            return false;
        }
        var _local_3:uint;
        while (_local_3 < animEvents[_arg_1].length) {
            if (animEvents[_arg_1][_local_3] == _arg_2) {
                return true;
            }
            _local_3++;
        }
        return false;
    }

    private function handleAnimEvent(_arg_1:String):void {
        var _local_2:Function;
        if (animEvents[_arg_1] == null) {
            return;
        }
        var _local_3:uint;
        while (_local_3 < animEvents[_arg_1].length) {
            _local_2 = animEvents[_arg_1][_local_3];
            (_local_2());
            _local_3++;
        }
    }
	
	public function playerCollisionCheck(targets:Array) : void {
	    for each (var target:MovieClip in targets)
		{
		    if (target == null 
			    || currentCollision != null 
			    || !collider.hitTestObject(target)
			) continue;

			currentCollision = target;

            Game.root.net.send("collision", ["true", currentCollision.name]);
		}
		
		if (currentCollision != null && !collider.hitTestObject(currentCollision))
		{
            Game.root.net.send("collision", ["false", currentCollision.name]);
			currentCollision = null;
		}
	}

    public function KeepAnimation(avt:Avatar, eqp:String) : void {
        switch (eqp) {
            case "Weapon":
                game.movieClipStartOrStopAll(avt.pMC.mcChar.weapon, game.preference.data.bDisItemAnim && game.preference.data.bKeepWeaponAnimOnly);
                break;
            case "he":
                game.movieClipStartOrStopAll(avt.pMC.mcChar.head.helm, game.preference.data.bDisItemAnim && game.preference.data.bKeepHelmAnimOnly);
                game.movieClipStartOrStopAll(avt.pMC.mcChar.head.hair, game.preference.data.bDisItemAnim && game.preference.data.bKeepHelmAnimOnly);
                if (avt.pMC.mcChar.backhair.visible) game.movieClipStartOrStopAll(avt.pMC.mcChar.backhair, game.preference.data.bDisItemAnim && game.preference.data.bKeepHelmAnimOnly);
                break;
            case "ba":
                game.movieClipStartOrStopAll(avt.pMC.mcChar.cape, game.preference.data.bDisItemAnim && game.preference.data.bKeepCapeAnimOnly);
                break;
            case "ar":
            case "co":
                game.movieClipStartOrStopAll(avt.pMC.mcChar.chest, game.preference.data.bDisItemAnim && game.preference.data.bKeepArmorAnimOnly);
                game.movieClipStartOrStopAll(avt.pMC.mcChar.hip, game.preference.data.bDisItemAnim && game.preference.data.bKeepArmorAnimOnly);
                game.movieClipStartOrStopAll(avt.pMC.mcChar.idlefoot, game.preference.data.bDisItemAnim && game.preference.data.bKeepArmorAnimOnly);
                game.movieClipStartOrStopAll(avt.pMC.mcChar.frontfoot, game.preference.data.bDisItemAnim && game.preference.data.bKeepArmorAnimOnly);
                game.movieClipStartOrStopAll(avt.pMC.mcChar.backfoot, game.preference.data.bDisItemAnim && game.preference.data.bKeepArmorAnimOnly);
                game.movieClipStartOrStopAll(avt.pMC.mcChar.frontshoulder, game.preference.data.bDisItemAnim && game.preference.data.bKeepArmorAnimOnly);
                game.movieClipStartOrStopAll(avt.pMC.mcChar.backshoulder, game.preference.data.bDisItemAnim && game.preference.data.bKeepArmorAnimOnly);
                game.movieClipStartOrStopAll(avt.pMC.mcChar.fronthand, game.preference.data.bDisItemAnim && game.preference.data.bKeepArmorAnimOnly);
                game.movieClipStartOrStopAll(avt.pMC.mcChar.backhand, game.preference.data.bDisItemAnim && game.preference.data.bKeepArmorAnimOnly);
                game.movieClipStartOrStopAll(avt.pMC.mcChar.frontthigh, game.preference.data.bDisItemAnim && game.preference.data.bKeepArmorAnimOnly);
                game.movieClipStartOrStopAll(avt.pMC.mcChar.backthigh, game.preference.data.bDisItemAnim && game.preference.data.bKeepArmorAnimOnly);
                game.movieClipStartOrStopAll(avt.pMC.mcChar.frontshin, game.preference.data.bDisItemAnim && game.preference.data.bKeepArmorAnimOnly);
                game.movieClipStartOrStopAll(avt.pMC.mcChar.backshin, game.preference.data.bDisItemAnim && game.preference.data.bKeepArmorAnimOnly);

                if (avt.pMC.mcChar.robe.visible) game.movieClipStartOrStopAll(avt.pMC.mcChar.robe, game.preference.data.bDisItemAnim && game.preference.data.bKeepArmorAnimOnly);
                if (avt.pMC.mcChar.backrobe.visible) game.movieClipStartOrStopAll(avt.pMC.mcChar.backrobe, game.preference.data.bDisItemAnim && game.preference.data.bKeepArmorAnimOnly);
                break;
        }
    }

    public function get AnimEvent():Object {
        return (animEvents);
    }

    public function artLoaded():Boolean {
        return ((((((weaponLoad) && (capeLoad)) && (helmLoad)) && (armorLoad)) && (classLoad)) && (hairLoad));
    }

    internal function frame1():* {
        mcChar.transform.colorTransform = CT1;
        mcChar.alpha = 0;
        stop();
    }

    internal function frame5():* {
        mcChar.transform.colorTransform = CT1;
        mcChar.alpha = 0;
    }

    internal function frame8():* {
        stop();
    }

    internal function frame10():* {
        mcChar.alpha = 0;
    }

    internal function frame12():* {
        mcChar.transform.colorTransform = CT3;
    }

    internal function frame13():* {
        mcChar.transform.colorTransform = CT2;
    }

    internal function frame14():* {
        mcChar.transform.colorTransform = CT1;
    }

    internal function frame18():* {
        stop();
    }

    internal function frame20():* {
        mcChar.transform.colorTransform = CT1;
    }

    internal function frame23():* {
        stop();
    }


}
}//package 

