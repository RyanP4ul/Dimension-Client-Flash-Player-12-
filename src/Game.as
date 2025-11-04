package {

import Game_fla.game_1_cnt_6;

import UI.Chat;
import UI.ModalMC;
import UI.uProto;

import com.adobe.images.PNGEncoder;

import features.FloatingDisplayHandler;
import features.companion.CompanionController;

import fl.motion.Color;

import flash.display.*;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.IOErrorEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.ProgressEvent;
import flash.events.TimerEvent;
import flash.filters.*;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.media.*;
import flash.net.*;
import flash.system.*;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.ui.*;
import flash.utils.*;

import game.Examine;
import game.aura.PlayerAura;
import game.aura.TargetAura;
import game.builder.MapBuilder;
import game.character.BattleAnalyzer;
import game.character.Boosts;
import game.character.Stats;
import game.config.ConfigurationData;
import game.controller.StatController;
import game.pve.FloorReward;

import network.Cache;
import network.Network;
import network.data.User;

public class Game extends MovieClip {

    public static var root:Game;

    public static var serverBaseURL:String = "http://localhost:3000/";

    public static var bPTR:Boolean = false;
    public static var loginInfo:Object = {};
    public static var objLogin:Object;
    private static var _characters:Array;
    public static var mcUpgradeWindow:MovieClip;
    public static var mcACWindow:MovieClip;

    public var preference:SharedObject;

    public var backgroundMusic:Sound;
    public var musicChannel:SoundChannel;
    public var musicTransform:SoundTransform;

    public var MsgBox:MovieClip;
    public var mcAccount:MovieClip;
    public var mcExtSWF:MovieClip;
    public var ui:MovieClip;
    public var mcLogin:game_1_cnt_6;
    public var world:World = null;
    public var bagSpace:String = "interface/bagspace_20201023.swf";
    private var swfObj:String = "AQWGame";
    public var mcO:MovieClip;
    public var elmType:String;
    public var handleSessionEvent:Function;
    public var chatF:Chat;
    public var objServerInfo:Object;
    public var sfcSocial:Boolean = true;
    public var ldrMC:LoaderMC;
    public var mcConnDetail:ConnDetailMC;
    public var querystring:Object = {};
    public var ts_login_server:Number;
    public var ts_login_client:Number;
    public var aaaloop:int = 0;
    public var totalPingTime:Number = 0;
    public var pingCount:int = 0;
    public var arrRanks:Array = [0];
    public var iRankMax:int = 10;
    public var arrHP:Array = [];
    private var aswc:Apop;

    private var travelMapData:Object;
    private var WorldMapData:worldMap;
    public var apopTree:Object = {};
    public var curID:String;
    private var conn:*;
    public var confirmTime:int = 0;
    public var quests:Boolean = false;
    public var firstJoin:Boolean = true;
    private var fbc:MovieClip;
    public var mcGameMenu:MovieClip;
    public var firstMenu:Boolean = true;
    public var sBG:String = "generic2.swf";
    public var TempLoginName:* = "";
    public var TempLoginPass:* = "";

    public var failedServers:* = {};
    private var rn:RandomNumber = new RandomNumber();
    public const EMAIL_REGEX:RegExp = /^[A-Z0-9._%+-]+@(?:[A-Z0-9-]+\.)+[A-Z]{2,4}$/i;
    public var mixer:SoundFX = new SoundFX();
    public var params:Object = {};
    public var uoPref:Object = {};
    public var loginLoader:URLLoader = new URLLoader();
    public var loaderDomain = null;

    public var isNewClass:Boolean = false;
    public var isNotUnlocked:Boolean = false;

    public var net:Network;
    public var cache:Cache;

    public var statsController:StatController;

    public var targetAura:TargetAura;
    public var playerAura:PlayerAura;
    public var boosts:Boosts;

    public var baseClassStats:Object;
    public var statsNewClass:Boolean = false;
    public var mcStatsPanel:MovieClip;

    public var bAnalyzer:BattleAnalyzer;
    public var mcExamine:Examine;

    public var mapBuilder:MapBuilder;
    public var floorReward:FloorReward;

    public var floatingDisplay:FloatingDisplayHandler;
    public var companionController:CompanionController;

    {
        MovieClip.prototype.removeAllChildren = function ():void
        {
            var _local_1:* = (this.numChildren - 1);
            while (_local_1 >= 0)
            {
                this.removeChildAt(_local_1);
                _local_1--;
            }
        };
    }

    public function Game() {
        net = new Network(this);
        ldrMC = new LoaderMC(MovieClip(this));
        cache = new Cache();
        statsController = new StatController(this);
        floatingDisplay = new FloatingDisplayHandler();
        companionController = new CompanionController();

        _characters = [];

        addFrameScript(0, frame1, 11, frame12, 12, frame13, 22, frame23, 31, frame32);

//        if (params.DeviceType == "Windows") Security.allowDomain("*");

        this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

        preference = SharedObject.getLocal("aqw_pref", "/");

        inituoPref();
        initKeybindPref();
        initCachePref();

        if (preference.data.bSoundOn != null && !preference.data.bSoundOn) mixer.bSoundOn = false;
        if (!mixer.bSoundOn) SoundMixer.soundTransform = new SoundTransform(0);

        uoPref.bSoundOn = mixer.bSoundOn;

        if (preference.data.quality == null) preference.data.quality = "AUTO";

        initArrRep();

        chatF = new Chat(this);

        addChildAt(new Sprite(), 0);
    }

    public function setBackgroundMusic(music:Sound, sc:SoundChannel) : void {
        backgroundMusic = music;
        musicChannel = sc;
        playBackgroundMusic();
    }

    private function playBackgroundMusic():void {
        if (musicChannel)
        {
            var transform:SoundTransform = musicChannel.soundTransform;
            transform.volume = 30 /100;
            musicChannel.soundTransform = transform;
        }
    }

    public static function trim(p_string:String):String {
        return p_string != null ? p_string.replace(/^\s+|\s+$/g, "") : null;
    }

    public static function XMLtoObject(_arg_1:XML):* {
        var _local_3:*;
        var _local_4:*;
        var _local_5:*;
        var _local_2:* = {};
        for (_local_3 in _arg_1.attributes()) {
            _local_2[String(_arg_1.attributes()[_local_3].name())] = String(_arg_1.attributes()[_local_3]);
        }
        for (_local_4 in _arg_1.children()) {
            _local_5 = _arg_1.children()[_local_4].name();
            if (_local_2[_local_5] == undefined) {
                _local_2[_local_5] = [];
            }
            _local_2[_local_5].push(XMLtoObject(_arg_1.children()[_local_4]));
        }
        return (_local_2);
    }

    public static function convertXMLtoObject(_arg_1:XML):* {
        var _local_3:*;
        var _local_4:*;
        var _local_5:XML;
        var _local_6:*;
        var _local_2:* = {};
        for (_local_3 in _arg_1.attributes()) {
            _local_2[String(_arg_1.attributes()[_local_3].name())] = String(_arg_1.attributes()[_local_3]);
        }
        for (_local_4 in _arg_1.children()) {
            _local_5 = _arg_1.children()[_local_4];
            if (_local_5.nodeKind() == "text") {
                if (_local_5 == parseFloat(_local_5).toString()) {
                    return (parseFloat(_local_5));
                }
                return (_local_5);
            }
            if (_local_5.nodeKind() == "element") {
                _local_6 = _arg_1.children()[_local_4].name();
                if (_local_2[_local_6] == null) {
                    _local_2[_local_6] = convertXMLtoObject(_arg_1.children()[_local_4]);
                } else {
                    if (!(_local_2[_local_6] is Array)) {
                        _local_2[_local_6] = [_local_2[_local_6]];
                    }
                    _local_2[_local_6].push(convertXMLtoObject(_arg_1.children()[_local_4]));
                }
            }
        }
        return (_local_2);
    }

    private static function makeGrayscale(_arg_1:DisplayObject, _arg_2:int = 0, _arg_3:Number = 0.33):void {
        var _local_6:Color;
        if (_arg_1 == null) {
            return;
        }
        var _local_4:Array = [_arg_3, _arg_3, _arg_3, 0, 0, _arg_3, _arg_3, _arg_3, 0, 0, _arg_3, _arg_3, _arg_3, 0, 0, _arg_3, _arg_3, _arg_3, 1, 0];
        var _local_5:ColorMatrixFilter = new ColorMatrixFilter(_local_4);
        _arg_1.filters = [_local_5];
        if (_arg_2 != 0) {
            _local_6 = new Color();
            _local_6.brightness = -(_arg_2 / 100);
            _arg_1.transform.colorTransform = _local_6;
        }
    }

    public function onRemoveChildren(target:MovieClip) : void {
        var i:int = target.numChildren - 1;
        while (i >= 0) {
            target.removeChildAt(i);
            i--;
        }
    }

    public function onRemoveChildrens(target:Array) : void {
        for (var i : int = 0; i < target.length; i++)
        {
            var targetMC : MovieClip = target[i] as MovieClip;
            onRemoveChildren(targetMC);
        }
    }

    public function requestAPI(requestMethod:String, api:String, parameters:Object, completeCallback:Function, ioCallback:Function, headers:Boolean = false):void
    {
        var parameter:*;
        var loader:URLLoader = new URLLoader();

        if (completeCallback != null) loader.addEventListener(Event.COMPLETE, completeCallback, false, 0, true);
        if (ioCallback != null) loader.addEventListener(IOErrorEvent.IO_ERROR, ioCallback, false, 0, true);

        var variables:URLVariables = new URLVariables();

        if (parameters != null)
        {
            for (parameter in parameters)
            {
                variables[parameter] = ((parameter == "layout") ? JSON.stringify(parameters[parameter]) : parameters[parameter]);
            }
        }

        var request:URLRequest = new URLRequest(serverBaseURL + "api/" + api);

        if (headers) request.requestHeaders = [new URLRequestHeader("ccid", world.myAvatar.objData.CharID), new URLRequestHeader("token", loginInfo.strToken)];
        if (parameters != null) request.data = variables;

        request.method = requestMethod;
        loader.load(request);
    }

    public function onLoadMaster(
            onComplete:Function,
            context:LoaderContext,
            file:String,
            onProgress:Function = null,
            onError:Function = null,
            gameFile:Boolean = true,
            isLoader:Boolean = false
    ):void {
        if (file == null) return;

        var request:URLRequest = new URLRequest(gameFile ? getFilePath(file) : serverBaseURL + file);
        var urlLoader:URLLoader = new URLLoader();
        urlLoader.dataFormat = URLLoaderDataFormat.BINARY;

        var completeHandler:Function = (context != null && onComplete != null)
                ? onLoadToBytes(onComplete, context, isLoader)
                : onComplete;

        if (completeHandler != null)
            urlLoader.addEventListener(Event.COMPLETE, completeHandler);

        if (onProgress != null)
            urlLoader.addEventListener(ProgressEvent.PROGRESS, onProgress);

        if (onError != null)
            urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);

        urlLoader.load(request);
    }

    public function onLoadToBytes(callback:Function, context:LoaderContext, isLoader:Boolean = false):Function {
        return function (e:Event):void {
            var data:ByteArray = URLLoader(e.target).data as ByteArray;
            var loader:Loader = new Loader();

            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, isLoader ? function(e:Event):void {
                callback(loader);
            } : callback);

            loader.loadBytes(data, context);
        };
    }

    public function monsterTreeWrite(MonMapID:int, monLeafO:Object, targets:* = null):void {
        var nam:String;
        var val:*;
        var Mon:Avatar;
        var s:String;
        var ri:int;
        var tx:*;
        var ty:*;
        var prop:* = "";
        var updated:Object = {};
        var monLeaf:Object = world.monTree[MonMapID];
        if (monLeaf != null) {
            for (s in monLeafO) {
                nam = s;
                val = monLeafO[s];
                updated[nam] = val;
                if (nam.toLowerCase().indexOf("int") > -1) {
                    val = int(val);
                }
                if (nam == "react") {
                    val = val.split(",");
                    ri = 0;
                    while (ri < val.length) {
                        val[ri] = int(val[ri]);
                        ri++;
                    }
                }
                monLeaf[nam] = val;
            }
            prop = "";
            for (prop in updated) {
                nam = prop;
                val = updated[prop];
                if (nam.toLowerCase().indexOf("evt:") < 0) {
                    Mon = world.getMonster(MonMapID);
                    if (Mon != null) {
                        if (nam.toLowerCase().indexOf("hp") > -1) {
                            if (((!(Mon == null)) && (!(Mon.objData == null)))) {
                                val = int(val);
                                Mon.objData[prop] = val;
                                if (world.myAvatar.target == Mon) {
                                    world.updatePortrait(Mon);
                                }
                                if (((!(world.objLock == null)) && ((nam == "intHP") && (val <= 0)))) {
                                    world.intKillCount++;
                                    world.updatePadNames();
                                }
                                if (((!(Mon.objData == null)) && ("boolean"))) {
                                    if (Mon.objData.strFrame == world.strFrame) {
                                        if (val <= 0) {
                                            try {
                                                if (bAnalyzer && targets || updated["targets"].length > 0)
                                                {
                                                    if (bAnalyzer.isRunning)
                                                    {
                                                        for each (var t:String in targets ? targets : updated["targets"])
                                                        {
                                                            if (world.myAvatar.objData.strUsername.toLowerCase() == t)
                                                            {
                                                                bAnalyzer.addKill();
                                                            }
                                                        }
                                                    }
                                                }
                                            } catch (e:Error) {
                                            }

                                            Mon.pMC.stopWalking();
                                            world.removeAuraFX(Mon.pMC, "all");
                                            Mon.pMC.die();
                                            monLeaf.auras = [];
                                            monLeaf.targets = {};
                                            Mon.target = null;
                                            if (("eventTrigger" in MovieClip(world.map))) {
                                                world.map.eventTrigger({
                                                    "type": "monDeath",
                                                    "args": MonMapID,
                                                    "targets": monLeafO.targets
                                                });
                                            }
                                            if (world.myAvatar.dataLeaf.targets[Mon.objData.MonMapID] != null) {
                                                delete world.myAvatar.dataLeaf.targets[Mon.objData.MonMapID];
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if (nam.toLowerCase().indexOf("state") > -1) {
                            if (((!(Mon == null)) && (!(Mon.objData == null)))) {
                                val = int(val);
                                Mon.objData[prop] = val;
                                if (val != 2) {
                                    Mon.dataLeaf.auras = [];
                                }
                                if (((!(Mon.objData.strFrame == null)) && (Mon.objData.strFrame == world.strFrame))) {
                                    if ((((val == 1) && (!(Mon.pMC == null))) && ((!(Mon.pMC.x == Mon.pMC.ox)) || (!(Mon.pMC.y == Mon.pMC.oy))))) {
                                        Mon.pMC.walkTo(Mon.pMC.ox, Mon.pMC.oy, world.WALKSPEED);
                                    }
                                }
                                if (val != 2) {
                                    monLeaf.targets = {};
                                }
                            }
                        }
                        if (nam.toLowerCase().indexOf("dx") > -1) {
                            val = int(val);
                            if ((((!(Mon.objData == null)) && (!(Mon.objData.strFrame == null))) && (Mon.objData.strFrame == world.strFrame))) {
                                tx = int(world.monTree[MonMapID].dx);
                                ty = int(world.monTree[MonMapID].dy);
                                Mon.pMC.walkTo(tx, ty, world.WALKSPEED);
                            }
                        }
                    }
                }
            }
        }
    }

    public function userTreeWrite(username:String, uoLeafO:Object):void {
        var user:User;
        var _local_4:String;
        var name:String;
        var val:*;
        var _local_7:Avatar;
        var _local_8:Avatar;
        var _local_9:Avatar;
        var avt:Avatar;
        var pMC:MovieClip;
        var s:String;
        var intState0:int;
        var i:int;
        var prop:String = "";
        var updated:Object = {};
        var uoLeafSet:Object = {};
        var uoLeaf:Object = world.uoTree[username.toLowerCase()];
        avt = world.getAvatarByUserName(username);
        for (s in uoLeafO) {
            name = s;
            val = uoLeafO[s];
            if ((((((name.toLowerCase().indexOf("int") > -1) || (name.toLowerCase() == "tx")) || (name.toLowerCase() == "ty")) || (name.toLowerCase() == "sp")) || (name.toLowerCase() == "pvpTeam"))) {
                val = int(val);
            }
            if ((((((((((sfcSocial) && (!(uoLeaf == null))) && (!(world.myAvatar.dataLeaf == null))) && (name.toLowerCase() == "inthp")) && (!(username.toLowerCase() == net.myUserName))) && (uoLeaf.strFrame == world.myAvatar.dataLeaf.strFrame)) && ((!(world.bPvP)) || (uoLeaf.pvpTeam == world.myAvatar.dataLeaf.pvpTeam))) && (val > 0)) && (!(world.getFirstHeal() == null)))) {
                if (((val <= uoLeaf.intHP) && (((uoLeaf.intHP - val) >= (uoLeaf.intHPMax * 0.15)) || (val <= (uoLeaf.intHPMax * 0.5))))) {
                    try {
                        avt.pMC.showHealIcon();
                    } catch (e:Error) {
                    }
                }
                if (val > Math.round((uoLeaf.intHPMax * 0.5))) {
                    try {
                        if (avt.pMC.getChildByName("HealIconMC") != null) {
                            MovieClip(avt.pMC.getChildByName("HealIconMC")).fClose();
                        }
                    } catch (e:Error) {
                    }
                }
            }
            if (name.toLowerCase() == "afk") {
                val = (val == "true");
            }
            updated[name] = val;
            uoLeafSet[name] = val;
        }
        intState0 = -1;
        if (world.uoTree[username.toLowerCase()] != null) {
            intState0 = world.uoTree[username.toLowerCase()].intState;
        }
        world.uoTreeLeafSet(username, uoLeafSet);
        uoLeaf = world.uoTree[username.toLowerCase()];
        if (world.isPartyMember(username)) {
            world.updatePartyFrame({"unm": uoLeaf.strUsername});
        }
        prop = "";
        for (prop in updated) {
            val = updated[prop];
            if (prop.toLowerCase() == "strframe") {
                world.manageAreaUser(username, "+");
                if (updated[prop] != world.strFrame) {
                    user = net.room.getUser(username);
                    if (user == null)
                        continue;
                    pMC = world.getMCByUserID(user.getId());
                    if (((!(pMC == null)) && (!(pMC.stage == null)))) {
                        pMC.pAV.hideMC();
                        if (pMC.pAV == world.myAvatar.target) {
                            world.setTarget(null);
                        }
                    }

                } else {
                    if (updated.sp != null) {
                        user = net.room.getUser(username);
                        if (user == null) continue;
                        pMC = world.getMCByUserID(user.getId());
                        if (pMC != null) {
                            pMC.walkTo(updated.tx, updated.ty, world.WALKSPEED);
                        }
                    } else {
                        world.objectByID(uoLeaf.entID);
                    }
                }
            }
            if (prop.toLowerCase() == "sp") {
                if (updated.strFrame == world.strFrame) {
                }
            }
            if (avt != null) {
                if (((prop.toLowerCase().indexOf("inthp") > -1) || (prop.toLowerCase().indexOf("intmp") > -1))) {
                    val = int(val);
                    if (avt.objData != null) {
                        avt.objData[prop] = val;
                    }
                    if (((avt.isMyAvatar) || (world.myAvatar.target == avt))) {
                        world.updatePortrait(avt);
                    }
                    if (avt.isMyAvatar) {
                        world.updateActBar();
                    }
                    if (((!(avt.pMC == null)) && (world.showHPBar))) {
                        avt.pMC.updateHPBar();
                    }
                }
                if (prop.toLowerCase().indexOf("intlevel") > -1) {
                    val = int(val);
                    if (avt.objData != null) {
                        avt.objData[prop] = val;
                        if (((!(avt.isMyAvatar)) && (world.myAvatar.target == avt))) {
                            showPortraitBox(avt, ui.mcPortraitTarget);
                        }
                    }
                }
                if (prop.toLowerCase().indexOf("intstate") > -1) {
                    val = int(val);
                    if (((!(avt.objData == null)) && (world.uoTree[username.toLowerCase()].strFrame == world.strFrame))) {
                        if (((val == 1) && (intState0 == 0))) {
                            avt.pMC.gotoAndStop("Idle");
                            avt.pMC.scale(world.SCALE);
                        }
                    }
                    if (avt.objData != null) {
                        avt.objData[prop] = val;
                    }
                    if ((((val == 0) && (world.uoTree[username.toLowerCase()].strFrame == world.strFrame)) && (!(avt.pMC == null)))) {
                        avt.pMC.stopWalking();
                        avt.pMC.mcChar.gotoAndPlay("Feign");
                        world.removeAuraFX(avt.pMC, "all");
                        if (avt.pMC.getChildByName("HealIconMC") != null) {
                            MovieClip(avt.pMC.getChildByName("HealIconMC")).fClose();
                        }
                        if (avt.isMyAvatar) {
                            world.cancelAutoAttack();
                            world.actionReady = false;
                            world.bitWalk = false;
                            world.map.transform.colorTransform = world.deathCT;
                            world.CHARS.transform.colorTransform = world.deathCT;
                            avt.pMC.transform.colorTransform = world.defaultCT;
                            world.showResCounter();
                        }
                    }
                    if (val != 2) {
                        uoLeaf.targets = {};
                    }
                }
                if (prop.toLowerCase().indexOf("afk") > -1) {
                    if (avt.pMC != null) {
                        avt.pMC.updateName();
                    }
                }
                if (prop == "showCloak") {
                    if (avt.pMC != null) {
                        avt.pMC.setCloakVisibility(val);
                    }
                }
                if (prop == "showHelm") {
                    if (avt.pMC != null) {
                        avt.pMC.setHelmVisibility(val);
                    }
                }
                if (prop.toLowerCase().indexOf("cast") > -1) {
                    if (avt.pMC != null) {
                        if (val.t > -1) {
                            avt.pMC.stopWalking();
                            avt.pMC.queueAnim("Use");
                        } else {
                            avt.pMC.endAction();
                            if (avt == world.myAvatar) {
                                ui.mcCastBar.fClose();
                            }
                        }
                    }
                }
            }
        }
    }

    public function userPetTreeWrite(username:String, uoLeafO:Object):void {
        trace("userPetTreeWrite");

        var name:String;
        var val:*;
        var avt:Avatar;
        var s:String;
        var prop:String = "";
        var updated:Object = {};

        avt = world.getAvatarByUserName(username);

        for (s in uoLeafO) {
            name = s;
            val = uoLeafO[s];
            if ((((((name.toLowerCase().indexOf("int") > -1) || (name.toLowerCase() == "tx")) || (name.toLowerCase() == "ty")) || (name.toLowerCase() == "sp")) || (name.toLowerCase() == "pvpTeam"))) {
                val = int(val);
            }
            updated[name] = val;
        }

        prop = "";

        trace("userPetTreeWrite > DATA > " + JSON.stringify(uoLeafO));

//        for (prop in updated) {
//            val = updated[prop];
//            if (avt != null && avt.petMC != null) {
//                if (prop.toLowerCase().indexOf("inthp") > -1 || prop.toLowerCase().indexOf("intmp") > -1 || prop.toLowerCase().indexOf("intsp") > -1) {
//                    val = int(val);
//                    if (avt.petMC.objData.data != null) {
//                        avt.petMC.objData.data[prop] = val;
//                    }
//
//                    if (val <= 0 && avt.petMC != null)
//                    {
//                        avt.petMC.stopWalking();
//                    }
//
//                    if (((avt.isMyAvatar) || (world.myAvatar.target == avt))) {
////                        world.updatePetPortrait(avt);
//                    }
//                }
//            }
//        }
    }

    public function npcTreeWrite(NpcMapID:int, npcLeafO:Object, targets:* = null):void
    {
        var nam:String;
        var val:*;
        var Npc:Avatar;
        var s:String;
        var prop:* = "";
        var updated:Object = {};
        var npcLeaf:Object = world.npcTree[String(NpcMapID)];

        if (npcLeaf == null)
        {
            return;
        }

        for (s in npcLeafO) {
            nam = s;
            val = npcLeafO[s];
            updated[nam] = val;
            if (nam.toLowerCase().indexOf("int") > -1) {
                val = int(val);
            }
            npcLeaf[nam] = val;
        }

        prop = "";
        for (prop in updated) {
            nam = prop;
            val = updated[prop];

            Npc = world.getNpc(NpcMapID);

            if (Npc != null)
            {

                if (nam.toLowerCase().indexOf("hp") > -1) {
                    if (Npc != null && Npc.objData != null) {
                        val = int(val);
                        Npc.objData[prop] = val;
                        if (world.myAvatar.target == Npc) {
                            world.updatePortrait(Npc);
                        }

                        if (Npc.pMC != null && world.showHPBar) {
                            Npc.pMC.updateHPBar();
                        }

                        if (((!(Npc.objData == null)) && ("boolean"))) {
                            if (Npc.objData.strFrame == world.strFrame) {
                                if (val <= 0) {
                                    try {
                                        if (bAnalyzer && targets || updated["targets"].length > 0)
                                        {
                                            if (bAnalyzer.isRunning)
                                            {
                                                for each (var t:String in targets ? targets : updated["targets"])
                                                {
                                                    if (world.myAvatar.objData.strUsername.toLowerCase() == t)
                                                    {
                                                        bAnalyzer.addKill();
                                                    }
                                                }
                                            }
                                        }
                                    } catch (e:Error) {
                                    }

                                    Npc.pMC.stopWalking();
                                    world.removeAuraFX(Npc.pMC, "all");
                                    Npc.pMC.mcChar.gotoAndPlay("Feign");

                                    npcLeaf.auras = [];
                                    npcLeaf.targets = {};
                                    Npc.target = null

                                    if (world.myAvatar.dataLeaf.targets[Npc.objData.NpcMapID] != null) {
                                        delete world.myAvatar.dataLeaf.targets[Npc.objData.NpcMapID];
                                    }
                                }
                            }
                        }
                    }
                }

                if (nam.toLowerCase().indexOf("state") > -1) {
                    if (Npc != null && Npc.objData != null) {
                        val = int(val);
                        Npc.objData[prop] = val;

                        var interact:MovieClip = Npc.pMC.getChildByName("npc-interact") as MovieClip;

                        if (interact != null)
                        {
                            interact.visible = val != 2;
                        }

                        if (((!(Npc.objData.strFrame == null)) && (Npc.objData.strFrame == world.strFrame))) {
                            if ((((val == 1) && (!(Npc.pMC == null))) && ((!(Npc.pMC.x == Npc.pMC.ox)) || (!(Npc.pMC.y == Npc.pMC.oy))))) {
                                Npc.pMC.walkTo(Npc.pMC.ox, Npc.pMC.oy, world.WALKSPEED);
                            }
                        }
                        if (val != 2) {
                            npcLeaf.targets = {};
                            Npc.dataLeaf.auras = [];
                        }
                    }
                }

                if (nam.toLowerCase().indexOf("dx") > -1) {
                    val = int(val);
                    if ((((!(Npc.objData == null)) && (!(Npc.objData.strFrame == null))) && (Npc.objData.strFrame == world.strFrame))) {
                        var tx:int = int(world.npcTree[NpcMapID].dx);
                        var ty:int = int(world.npcTree[NpcMapID].dy);
                        Npc.pMC.walkTo(tx, ty, world.WALKSPEED);
                    }
                }
            }
        }
    }

    public function doAnim(anim:Object, isProc:Boolean = false, dur:* = null):void {
        if (!anim || !anim.cInf || !anim.tInf) return;

        var anims:Array;
        var animIndex:uint;
        var animStr:String = anim.animStr;
        var pMC:MovieClip;
        var cLeaf:Object;
        var tLeaf:Object;
        var tAvt:Avatar;
        var cAvt:Avatar = null;
        var aura:Object = null;
        var buffer:* = undefined;
        var xBuffer:* = undefined;
        var yBuffer:* = undefined;
        var animString:String;
        var i:int;

        var cTyp:String = "";
        var cID:int = -1;
        var cPid: int = -1;

        var tTyp:String = "";
        var tID:int = -1;
        var tPid: int = -1;

        var tAvts:Array = [];
        var tInfA:Array = [];
        var strF:String = "";
        var cReg:Point = new Point(0, 0);
        var tReg:Point = new Point(0, 0);

        var splitAnimCurrentInf:Array = anim.cInf.split(":");
        cTyp = String(splitAnimCurrentInf[0]);
        cID = int(splitAnimCurrentInf[1]);
        cPid = splitAnimCurrentInf.length == 3 ? splitAnimCurrentInf[2] : -1;

        switch (cTyp) {
            case "t":
            case "p":
                cAvt = world.getAvatarByUserID(cID);
                cLeaf = world.getUoLeafById(cID);
                break;
            case "m":
                cAvt = world.getMonster(cID);
                cLeaf = world.monTree[cID];
                if (anim.msg != null) {
                    if (anim.msg.indexOf("<mon>") > -1) {
                        anim.msg = anim.msg.split("<mon>").join(cAvt.objData.strMonName);
                    }
                    addUpdate(anim.msg);
                }
                break;
            case "n":
                cAvt = world.getNpc(cID);
                cLeaf = world.npcTree[cID];
                if (anim.msg != null) {
                    if (anim.msg.indexOf("<npc>") > -1) {
                        anim.msg = anim.msg.split("<npc>").join(cAvt.objData.strNpcName);
                    }
                    addUpdate(anim.msg);
                }
                break;
        }

        tInfA = anim.tInf.split(",");
        i = 0;
        while (i < tInfA.length) {
            var splitAnimTgtInf:Array = tInfA[i].split(":");
            tTyp = String(splitAnimTgtInf[0]);
            tID = int(splitAnimTgtInf[1]);
            tPid = splitAnimTgtInf.length == 3 ? splitAnimCurrentInf[2] : -1;
            switch (tTyp) {
                case "t":
                case "p":
                    tAvt = world.getAvatarByUserID(tID);
                    tLeaf = world.getUoLeafById(tID);
                    break;
                case "m":
                    tAvt = world.getMonster(tID);
                    tLeaf = world.monTree[tID];
                    break;
                case "n":
                    tAvt = world.getNpc(tID);
                    tLeaf = world.npcTree[tID];
                    break;
            }
            tAvts.push(tAvt);
            i = (i + 1);
        }

        if (tAvts[0] != null) tAvt = tAvts[0];
        if (tAvt != null) tLeaf = tAvt.dataLeaf;

        if (!cAvt || !cAvt.pMC || !tAvt || !tAvt.pMC || !cLeaf || !tLeaf) return;

        var distX:Number = Math.abs(cAvt.pMC.x - world.myAvatar.pMC.x);
        var distY:Number = Math.abs(cAvt.pMC.y - world.myAvatar.pMC.y);
        if (distX > ConfigurationData.CLIENT_WIDTH || distY > ConfigurationData.CLIENT_HEIGHT) return;

        if (!cAvt.hasOwnProperty("lastAnimTime")) cAvt.lastAnimTime = 0;

        if (getTimer() - cAvt.lastAnimTime < 300) return;

        cAvt.lastAnimTime = getTimer();

        aura = {};
        for each (aura in cLeaf.auras) {
            try {
                if (aura.cat != null && (aura.cat == "stun" || aura.cat == "stone" || aura.cat == "disabled")) return;
            } catch (e:Error) {
                trace(("doAnim > " + e));
            }
        }

        if (animStr && animStr.indexOf(",") > -1) {
            var animOptions:Array = animStr.split(",");
            animStr = animOptions[Math.floor(Math.random() * animOptions.length)];
        }

        strF = String(cLeaf.strFrame);

        if (strF != null && strF == world.strFrame && cLeaf.intState > 0) {
            switch (cTyp) {
                case "p":
                    if (cAvt != world.myAvatar) cAvt.target = tAvt;
                    if (cAvt != tAvt) cAvt.pMC.turn((tAvt.pMC.x - cAvt.pMC.x) >= 0 ? "right" : "left");

                    cAvt.pMC.spFX.strl = "";

                    cAvt.pMC.queueSpFX({
                        "strl":anim.strl,
                        "fx":anim.fx,
                        "avts":tAvts
                    });

                    if (!isNaN(dur)) cAvt.pMC.spellDur = dur;
                    if (cAvt.pMC.mcChar.currentLabel != animStr) cAvt.pMC.queueAnim(animStr);
                    if (isProc && cAvt.pMC.mcChar.weapon.mcWeapon.isProc) cAvt.pMC.mcChar.weapon.mcWeapon.gotoAndPlay("Proc");
                    return;
                case "m":
                    if (preference.data.bDisMonAnim || preference.data.bDisLoadMon) return;

                    if (cAvt != world.myAvatar) cAvt.target = tAvt;

                    cReg = cAvt.pMC.mcChar.localToGlobal(new Point(0, 0));
                    tReg = tTyp == "t" ? tAvt.companions[tPid].localToGlobal(new Point(0, 0)) : tAvt.pMC.mcChar.localToGlobal(new Point(0, 0)); // isT ? tAvt.petMC.localToGlobal(new Point(0, 0)) : tAvt.pMC.mcChar.localToGlobal(new Point(0, 0));
                    cReg = world.CHARS.globalToLocal(cReg);
                    tReg = world.CHARS.globalToLocal(tReg);

                    if (cAvt != tAvt) cAvt.pMC.turn((tReg.x - cReg.x) >= 0 ? "right" : "left");

                    if ((Math.abs((cReg.x - tReg.x)) * world.SCALE > 160) || (Math.abs((cReg.y - tReg.y)) * world.SCALE > 15)) {
                        buffer = int((110 + (Math.random() * 50)));
                        xBuffer = (((tReg.x - cReg.x) >= 0) ? -(buffer) : buffer) * world.SCALE;
                        if ((tReg.x + xBuffer < 0) || (tReg.x + xBuffer > ConfigurationData.CLIENT_WIDTH)) xBuffer *= -1;
                        buffer = int(((Math.random() * 30) - 15));
                        yBuffer = (((tReg.y - cReg.y) >= 0) ? -(buffer) : buffer) * world.SCALE;
                        cAvt.pMC.walkTo(tReg.x + xBuffer, tReg.y + yBuffer, 32);
                    }

                    if (cAvt.pMC.spFX) cAvt.pMC.spFX.avt = cAvt.target;

                    if (cAvt.pMC.mcChar.currentLabel != animStr)
                        MovieClip(cAvt.pMC.getChildAt(1)).gotoAndPlay(animStr);
                    return;
                case "t":
                    if (cAvt != world.myAvatar) cAvt.target = tAvt;
                    cReg = cAvt.companions[cPid].localToGlobal(new Point(0, 0));
                    tReg = tAvt.pMC.mcChar.localToGlobal(new Point(0, 0));
                    cReg = world.CHARS.globalToLocal(cReg);
                    tReg = world.CHARS.globalToLocal(tReg);

                    if (Math.abs(cReg.x - tReg.x) * world.SCALE > 160 || Math.abs(cReg.y - tReg.y) * world.SCALE > 15) {
                        buffer = int((110 + (Math.random() * 50)));
                        xBuffer = (((tReg.x - cReg.x) >= 0) ? -(buffer) : buffer) * world.SCALE;
                        if ((tReg.x + xBuffer < 0) || (tReg.x + xBuffer > ConfigurationData.CLIENT_WIDTH)) xBuffer *= -1;
                        buffer = int(((Math.random() * 30) - 15));
                        yBuffer = (((tReg.y - cReg.y) >= 0) ? -(buffer) : buffer) * world.SCALE;
                        cAvt.companions[cPid].walkTo(tReg.x + xBuffer, tReg.y + yBuffer, 32);
                    }

                    if (cAvt != tAvt) cAvt.companions[cPid].turn((tAvt.pMC.x - cAvt.companions[cPid].x) >= 0 ? "right" : "left");
                    if (anim.strl) cAvt.companions[cPid].spFX.strl = anim.strl;
                    if (anim.fx) cAvt.companions[cPid].spFX.fx = anim.fx;
                    if (tAvts) cAvt.companions[cPid].spFX.avts = tAvts;
                    if (cAvt.companions[cPid].mcChar.currentLabel != animStr) cAvt.companions[cPid].mcChar.gotoAndPlay(animStr);
                    return;
                case "n":
                    if (cAvt != world.myAvatar) cAvt.target = tAvt;
                    cReg = cAvt.pMC.mcChar.localToGlobal(new Point(0, 0));
                    tReg = (tTyp == "t") ? tAvt.companions[tPid].localToGlobal(new Point(0, 0)) : tAvt.pMC.mcChar.localToGlobal(new Point(0, 0));
                    cReg = world.CHARS.globalToLocal(cReg);
                    tReg = world.CHARS.globalToLocal(tReg);

                    if (cAvt != tAvt) cAvt.pMC.turn((tAvt.pMC.x - cAvt.pMC.x) >= 0 ? "right" : "left");

                    if (((Math.abs(cReg.x - tReg.x) * world.SCALE > 160) || (Math.abs(cReg.y - tReg.y) * world.SCALE > 15))) {
                        buffer = int((110 + (Math.random() * 50)));
                        xBuffer = (((tReg.x - cReg.x) >= 0) ? -(buffer) : buffer) * world.SCALE;
                        if ((tReg.x + xBuffer < 0) || (tReg.x + xBuffer > ConfigurationData.CLIENT_WIDTH)) xBuffer *= -1;
                        buffer = int(((Math.random() * 30) - 15));
                        yBuffer = (((tReg.y - cReg.y) >= 0) ? -(buffer) : buffer) * world.SCALE;
                        cAvt.pMC.walkTo(tReg.x + xBuffer, tReg.y + yBuffer, 32);
                    }

                    cAvt.pMC.queueSpFX({ "strl": anim.strl, "fx": anim.fx, "avts": tAvts });
                    if (!isNaN(dur)) cAvt.pMC.spellDur = dur;
                    if (cAvt.pMC.mcChar.currentLabel != animStr) cAvt.pMC.queueAnim(animStr);
                    if (isProc && cAvt.pMC.mcChar.weapon.mcWeapon.isProc) {
                        cAvt.pMC.mcChar.weapon.mcWeapon.gotoAndPlay("Proc");
                    }
                    return;
            }
        }
    }

    public function key_StageLogin(_arg_1:KeyboardEvent):* {
        if (_arg_1.target == stage) {
            if ((_arg_1.charCode == Keyboard.ENTER)) {
                stage.focus = mcLogin.ni;
            }
        }
    }

    public function key_StageGame(event:KeyboardEvent):* {
        if (!("text" in event.target)) {
            if (((event.charCode == Keyboard.ENTER) || (String.fromCharCode(event.charCode) == "/"))) {
                chatF.openMsgEntry();
            }
            if (String.fromCharCode(event.charCode) == "t") {
                if (((stage.focus == null) || ((!(stage.focus == null)) && (!("text" in stage.focus))))) {
                    if ((((!(world.myAvatar.target == null)) && (!(world.myAvatar.target.target == null))) && (!(world.myAvatar.target == world.myAvatar.target.target)))) {
                        world.setTarget(world.myAvatar.target.target);
                    }
                }
            }
            if ((String.fromCharCode(event.charCode) == ">")) {
                if (((stage.focus == null) || ((!(stage.focus == null)) && (!("text" in stage.focus))))) {
                    if (((!(chatF.pmSourceA[0] == null)) && (chatF.pmSourceA[0].length >= 1))) {
                        chatF.openPMsg(chatF.pmSourceA[0]);
                        ui.mcInterface.te.text = "> ";
                    }
                }
            }
            if (event.keyCode == preference.data.keys["Inventory"]) {
                if (((stage.focus == null) || ((!(stage.focus == null)) && (!("text" in stage.focus))))) {
                    ui.mcInterface.mcMenu.toggleInventory();
                }
            }
            if (event.keyCode == preference.data.keys["Bank"] && world.myAvatar.isStaff()) {
                if (((stage.focus == null) || ((!(stage.focus == null)) && (!("text" in stage.focus))))) {
                    world.toggleBank();
                }
            }
            if (event.keyCode == preference.data.keys["Quest Log"]) {
                if (stage.focus != ui.mcInterface.te) {
                    world.showQuestTrackerList();
                }
            }
            if (event.keyCode == preference.data.keys["Friends List"]) {
                if (((stage.focus == null) || ((!(stage.focus == null)) && (!("text" in stage.focus))))) {
                    if (ui.mcPopup.currentLabel == "Panel")
                    {
                        ui.mcPopup.onClose();
                    }
                    else
                    {
                        togglePanel("friends");
                    }
                }
            }
            if (event.keyCode == preference.data.keys["Character Panel"]) {
                if (((stage.focus == null) || ((!(stage.focus == null)) && (!("text" in stage.focus))))) {
                    toggleCharStatspanel();
                }
            }
            if (event.keyCode == preference.data.keys["Player HP Bar"]) {
                if (((stage.focus == null) || ((!(stage.focus == null)) && (!("text" in stage.focus))))) {
                    world.toggleHPBar();
                }
            }
            if (event.keyCode == preference.data.keys["Options"]) {
                if (((stage.focus == null) || ((!(stage.focus == null)) && (!("text" in stage.focus))))) {
                    if (ui.mcPopup.currentLabel == "Option") {
                        ui.mcPopup.onClose();
                    } else {
                        ui.mcPopup.fOpen("Option");
                    }
                }
            }
            if (event.keyCode == preference.data.keys["Area List"]) {
                if (((stage.focus == null) || ((!(stage.focus == null)) && (!("text" in stage.focus))))) {
                    if (ui.mcPopup.currentLabel == "Panel")
                    {
                        ui.mcPopup.onClose();
                    }
                    else
                    {
                        togglePanel("charArea");
                    }
                }
            }
            if (event.keyCode == preference.data.keys["Jump"]) {
                if (stage.focus != ui.mcInterface.te) {
                    world.myAvatar.pMC.mcChar.gotoAndPlay("Jump");
                }
            }
            if (event.charCode == Keyboard.ESCAPE) {
                if (event.target != ui.mcInterface.te) {
                }
            }
        }
    }

    public function key_TextLogin(_arg_1:KeyboardEvent):* {
        if (_arg_1.target != stage) {
            if ((_arg_1.charCode == Keyboard.ENTER)) {
                onLoginClick(null);
            }
        }
    }

    public function key_ChatEntry(_arg_1:KeyboardEvent):* {
        if (_arg_1.charCode == Keyboard.ENTER) {
            chatF.submitMsg(ui.mcInterface.te.text, chatF.chn.cur.typ, chatF.pmNm);
        }
        if (_arg_1.charCode == Keyboard.ESCAPE) {
            chatF.closeMsgEntry();
        }
    }

    public function talk(_arg_1:*):* {
        if (_arg_1.accept) {
            chatF.submitMsg(_arg_1.emote1, "emote", net.myUserName);
        } else {
            chatF.submitMsg(_arg_1.emote2, "emote", net.myUserName);
        }
    }

    public function isNumpadKey(_arg_1:uint):Boolean
    {
        return ((_arg_1 >= 96) && (_arg_1 <= 105));
    }

    public function key_actBar(event:KeyboardEvent) : void {
        var i:int;
        var actionRef:*;
        if (stage.focus == null || stage.focus != null && (!("text" in stage.focus))) {
            if (isNumpadKey(event.keyCode))
            {
                event.keyCode = (event.keyCode - 48);
            }

            switch (event.keyCode) {
                case preference.data.keys["Auto Attack"]:
                    i = 0;
                    world.approachTarget();
                    break;
                case preference.data.keys["Skill 1"]:
                    i = 1;
                    if (world.actionMap[i] != null)
                    {
                        actionRef = world.getActionByRef(world.actionMap[i]);
                        if (actionRef.isOK)
                        {
                            world.testAction(actionRef);
                        }
                    }
                    break;
                case preference.data.keys["Skill 2"]:
                    i = 2;
                    if (world.actionMap[i] != null)
                    {
                        actionRef = world.getActionByRef(world.actionMap[i]);
                        if (actionRef.isOK)
                        {
                            world.testAction(actionRef);
                        }
                    }
                    break;
                case preference.data.keys["Skill 3"]:
                    i = 3;
                    if (world.actionMap[i] != null)
                    {
                        actionRef = world.getActionByRef(world.actionMap[i]);
                        if (actionRef.isOK)
                        {
                            world.testAction(actionRef);
                        }
                    }
                    break;
                case preference.data.keys["Skill 4"]:
                    i = 4;
                    if (world.actionMap[i] != null)
                    {
                        actionRef = world.getActionByRef(world.actionMap[i]);
                        if (actionRef.isOK)
                        {
                            world.testAction(actionRef);
                        }
                    }
                    break;
                case preference.data.keys["Skill 5"]:
                    i = 5;
                    if (world.actionMap[i] != null)
                    {
                        actionRef = world.getActionByRef(world.actionMap[i]);
                        if (actionRef.isOK)
                        {
                            world.testAction(actionRef);
                        }
                    }
                    break;
                case preference.data.keys["Skill 6"]:
                    i = 6;
                    if (world.actionMap[i] != null)
                    {
                        actionRef = world.getActionByRef(world.actionMap[i]);
                        if (actionRef.isOK)
                        {
                            world.testAction(actionRef);
                        }
                    }
                    break;
                case preference.data.keys["Skill 7"]:
                    i = 7;
                    if (world.actionMap[i] != null)
                    {
                        actionRef = world.getActionByRef(world.actionMap[i]);
                        if (actionRef.isOK)
                        {
                            world.testAction(actionRef);
                        }
                    }
                    break;
            }
        }
    }

    public function decHex(_arg_1:*):* {
        return (_arg_1.toString(16));
    }

    public function hexDec(_arg_1:*):* {
        return (parseInt(_arg_1, 16));
    }

    public function modColor(_arg_1:*, _arg_2:*, _arg_3:*):* {
        var _local_5:*;
        var _local_6:*;
        var _local_7:*;
        var _local_4:* = "";
        var _local_8:* = 0;
        while (_local_8 < 3) {
            _local_5 = hexDec(_arg_1.substr((_local_8 * 2), 2));
            _local_6 = hexDec(_arg_2.substr((_local_8 * 2), 2));
            switch (_arg_3) {
                case "-":
                default:
                    _local_7 = (_local_5 - _local_6);
                    if (_local_7 < 0) {
                        _local_7 = 0;
                    }
                    _local_7 = decHex(_local_7);
                    break;
                case "+":
                    _local_7 = (_local_5 + _local_6);
                    if (_local_7 > 0xFF) {
                        _local_7 = 0xFF;
                    }
                    _local_7 = decHex(_local_7);
            }
            _local_4 = (_local_4 + String(((_local_7.length < 2) ? ("0" + _local_7) : _local_7)));
            _local_8++;
        }
        return (_local_4);
    }

    internal function replaceString(_arg_1:String, _arg_2:String, _arg_3:String):String {
        var _local_4:Number = 0;
        var _local_5:Number = 0;
        var _local_6:* = "";
        while ((_local_4 = _arg_1.indexOf(_arg_2, _local_4)) != -1) {
            _local_6 = (_local_6 + (_arg_1.substring(_local_5, _local_4) + _arg_3));
            _local_5 = (_local_4 = (_local_4 + _arg_2.length));
        }
        return ((_local_6 == "") ? _arg_1 : _local_6);
    }

    public function stripWhite(_arg_1:String):String {
        _arg_1 = _arg_1.split("\r").join("");
        _arg_1 = _arg_1.split("\t").join("");
        return (_arg_1.split(" ").join(""));
    }

    public function stripWhiteStrict(_arg_1:String):String {
        _arg_1 = stripWhite(_arg_1);
        var _local_2:int;
        while (_local_2 < chatF.strictComparisonChars.length) {
            _arg_1 = _arg_1.split(chatF.strictComparisonChars.substr(_local_2, 1)).join("");
            _local_2++;
        }
        return (_arg_1);
    }

    public function stripWhiteStrictB(_arg_1:String):String {
        _arg_1 = stripWhite(_arg_1);
        var _local_2:int;
        while (_local_2 < chatF.strictComparisonCharsB.length) {
            _arg_1 = _arg_1.split(chatF.strictComparisonCharsB.substr(_local_2, 1)).join("");
            _local_2++;
        }
        return (_arg_1);
    }

    public function stripMarks(_arg_1:String):String {
        var _local_2:int;
        while (_local_2 < chatF.markChars.length) {
            _arg_1 = _arg_1.split(chatF.markChars.substr(_local_2, 1)).join("");
            _local_2++;
        }
        return (_arg_1);
    }

    public function stripDuplicateVowels(_arg_1:String):String {
        _arg_1 = _arg_1.replace(chatF.regExpA, "a");
        _arg_1 = _arg_1.replace(chatF.regExpE, "e");
        _arg_1 = _arg_1.replace(chatF.regExpI, "i");
        _arg_1 = _arg_1.replace(chatF.regExpO, "o");
        _arg_1 = _arg_1.replace(chatF.regExpU, "u");
        return (_arg_1.replace(chatF.regExpSPACE, " "));
    }

    public function maskStringBetween(_arg_1:String, _arg_2:Array):String {
        var _local_4:int;
        var _local_5:int;
        var _local_3:* = "";
        if (((_arg_2.length > 0) && ((_arg_2.length % 2) == 0))) {
            _local_4 = 0;
            _local_5 = 0;
            while (_local_5 < _arg_1.length) {
                if (((_local_5 >= _arg_2[_local_4]) && (_local_5 <= _arg_2[(_local_4 + 1)]))) {
                    if (_arg_1.charAt(_local_5) == " ") {
                        _local_3 = (_local_3 + " ");
                    } else {
                        _local_3 = (_local_3 + "*");
                    }
                    if (_local_5 == _arg_2[(_local_4 + 1)]) {
                        _local_4 = (_local_4 + 2);
                    }
                } else {
                    _local_3 = (_local_3 + _arg_1.charAt(_local_5));
                }
                _local_5++;
            }
        } else {
            trace("");
            trace("Utility.maskStringBetween() > Malformed indeces array.  Must be in format [start,end, start,end, etc]");
            trace("");
        }
        return (_local_3);
    }

    public function arraySort(_arg_1:String, _arg_2:String):int {
        if (_arg_1 > _arg_2) {
            return (1);
        }
        if (_arg_1 < _arg_2) {
            return (-1);
        }
        return (0);
    }

    public function convertBubbleText(_arg_1:String):String {
        var _local_2:String;
        _local_2 = world.myAvatar.objData.strUsername;
        if (_arg_1.indexOf("@name")) {
            _arg_1 = _arg_1.split("@name").join(_local_2);
        }
        _local_2 = String(world.myAvatar.objData.intLevel);
        if (_arg_1.indexOf("@level")) {
            _arg_1 = _arg_1.split("@level").join(_local_2);
        }
        _local_2 = world.myAvatar.objData.strClassName;
        if (_arg_1.indexOf("@class")) {
            _arg_1 = _arg_1.split("@class").join(_local_2);
        }
        _local_2 = ((world.myAvatar.objData.strGender.toLowerCase() == "m") ? "Mr." : "Mrs.");
        if (_arg_1.indexOf("@prefix")) {
            _arg_1 = _arg_1.split("@prefix").join(_local_2);
        }
        _local_2 = ((world.myAvatar.objData.strGender.toLowerCase() == "m") ? "He" : "She");
        if (_arg_1.indexOf("@He")) {
            _arg_1 = _arg_1.split("@prefix").join(_local_2);
        }
        _local_2 = ((world.myAvatar.objData.strGender.toLowerCase() == "m") ? "Him" : "Her");
        if (_arg_1.indexOf("@Him")) {
            _arg_1 = _arg_1.split("@prefix").join(_local_2);
        }
        _local_2 = ((world.myAvatar.objData.strGender.toLowerCase() == "m") ? "His" : "Her");
        if (_arg_1.indexOf("@His")) {
            _arg_1 = _arg_1.split("@prefix").join(_local_2);
        }
        _local_2 = ((world.myAvatar.objData.strGender.toLowerCase() == "m") ? "he" : "she");
        if (_arg_1.indexOf("@he")) {
            _arg_1 = _arg_1.split("@prefix").join(_local_2);
        }
        _local_2 = ((world.myAvatar.objData.strGender.toLowerCase() == "m") ? "him" : "her");
        if (_arg_1.indexOf("@him")) {
            _arg_1 = _arg_1.split("@prefix").join(_local_2);
        }
        _local_2 = ((world.myAvatar.objData.strGender.toLowerCase() == "m") ? "his" : "her");
        if (_arg_1.indexOf("@his")) {
            _arg_1 = _arg_1.split("@prefix").join(_local_2);
        }
        return (_arg_1);
    }

    public function strToProperCase(_arg_1:String):String {
        return (_arg_1.slice(0, 1).toUpperCase() + _arg_1.slice(1, _arg_1.length).toLowerCase());
    }

    public function strSetCharAt(_arg_1:String, _arg_2:int, _arg_3:String):String {
        return ((_arg_1.substring(0, _arg_2) + _arg_3) + _arg_1.substring((_arg_2 + 1), _arg_1.length));
    }

    public function strNumWithCommas(_arg_1:Number):String {
        var _local_2:* = "";
        var _local_3:String = _arg_1.toString();
        var _local_4:int;
        var _local_5:int;
        _local_4 = (_local_3.length - 1);
        while (_local_4 > -1) {
            if (_local_5 == 3) {
                _local_5 = 0;
                _local_2 = ((_local_3.charAt(_local_4) + ",") + _local_2);
            } else {
                _local_2 = (_local_3.charAt(_local_4) + _local_2);
            }
            _local_5++;
            _local_4--;
        }
        return (_local_2);
    }

    public function numToStr(_arg_1:Number, _arg_2:int = 2):String {
        var _local_3:String = _arg_1.toString();
        if (_local_3.indexOf(".") == -1) {
            _local_3 = (_local_3 + ".");
        }
        var _local_4:Array = _local_3.split(".");
        while (_local_4[1].length < _arg_2) {
            _local_4[1] = (_local_4[1] + "0");
        }
        if (_local_4[1].length > _arg_2) {
            _local_4[1] = _local_4[1].substr(0, _arg_2);
        }
        if (_arg_2 > 0) {
            _local_3 = ((_local_4[0] + ".") + _local_4[1]);
        } else {
            _local_3 = _local_4[0];
        }
        return (_local_3);
    }

    public function deepCopy(_arg_1:*, _arg_2:*):void {
        var _local_3:*;
        for (_local_3 in _arg_2) {
            if (typeof ((_arg_2 as Object)[_local_3]) == "object") {
                (_arg_1 as Object)[_local_3] = {};
                deepCopy((_arg_1 as Object)[_local_3], (_arg_2 as Object)[_local_3]);
            } else {
                if ((_arg_2 as Object)[_local_3]) {
                    (_arg_1 as Object)[_local_3] = (_arg_2 as Object)[_local_3];
                }
            }
        }
    }

    public function copyObj(source:Object):* {
        var myBA:ByteArray = new ByteArray();
        myBA.writeObject(source);
        myBA.position = 0;
        return (myBA.readObject());
    }

    public function copyConstructor(_arg_1:*):* {
        var _local_2:ByteArray = new ByteArray();
        _local_2.writeObject(_arg_1);
        _local_2.position = 0;
        return (_local_2.readObject() as Class);
    }

    public function distanceO(_arg_1:*, _arg_2:*):Number {
        return (Math.sqrt((Math.pow(int((_arg_2.x - _arg_1.x)), 2) + Math.pow(int((_arg_2.y - _arg_1.y)), 2))));
    }

    public function distanceP(_arg_1:*, _arg_2:*, _arg_3:*, _arg_4:*):Number {
        return (Math.sqrt((Math.pow((_arg_3 - _arg_1), 2) + Math.pow((_arg_4 - _arg_2), 2))));
    }

    public function distanceXY(_arg_1:*, _arg_2:*, _arg_3:*, _arg_4:*):Object {
        return ({
            "dx": (_arg_3 - _arg_1),
            "dy": (_arg_4 - _arg_2)
        });
    }

    public function isHouseItem(_arg_1:Object):Boolean {
        return (((_arg_1.sType == "House") || (_arg_1.sType == "Floor Item")) || (_arg_1.sType == "Wall Item"));
    }

    public function validateArmor(_arg_1:*):* {
        var _local_10:uint;
        var _local_11:uint;
        var _local_2:Array = [];
        var _local_3:Object = {};
        var _local_4:int;
        var _local_5:int = 10;
        var _local_6:Boolean = true;
        var _local_7:Boolean;
        var _local_8:Boolean;
        var _local_9:int = _arg_1.ItemID;
        switch (_local_9) {
            default:
                break;
            case 319:
            case 2083:
                _local_7 = true;
                _local_2 = [16, 15654, 407, 20, 15651, 409];
                break;
            case 409:
                _local_8 = true;
                _local_2 = [20, 15651];
                break;
            case 408:
                _local_8 = true;
                _local_2 = [17, 15653];
                break;
            case 410:
                _local_8 = true;
                _local_2 = [18, 15652];
                break;
            case 407:
                _local_8 = true;
                _local_2 = [16, 15654];
        }
        if (_local_7) {
            _local_10 = 0;
            while (_local_10 < _local_2.length) {
                if (world.myAvatar.getCPByID(_local_2[_local_10]) < 302500) {
                    _local_6 = false;
                } else {
                    _local_6 = true;
                    if (_local_10 < 2) {
                        _local_10 = 2;
                    }
                    if (((_local_10 < 5) && (_local_10 > 2))) break;
                }
                _local_10++;
            }
            return (_local_6);
        }
        if (_local_8) {
            _local_11 = 0;
            while (_local_11 < _local_2.length) {
                if (world.myAvatar.getCPByID(_local_2[_local_11]) >= _arg_1.iReqCP) {
                    return (true);
                }
                _local_11++;
            }
            return (false);
        }
        return (!((Number(_arg_1.iClass) > 0) && (world.myAvatar.getCPByID(_arg_1.iClass) < _arg_1.iReqCP)));
    }

    public function getItemInfoStringB(obj:Object):String {
        var iRank:int;
        var iSpillCP:int;
        var iRankRep:int;
        var iSpillRep:int;
        var strItemInfo:String = (("<font size='12'><b>" + obj.sName) + "</b></font><br>");

        if (!validateArmor(obj) && obj.iClass > 0) {
            strItemInfo = (strItemInfo + "<font size='10' color='#CC0000'>");
            iRank = getRankFromPoints(obj.iReqCP);
            iSpillCP = (obj.iReqCP - arrRanks[(iRank - 1)]);

            strItemInfo = (iSpillCP > 0 ? (strItemInfo + ("Requires " + iSpillCP + " Class Points on " + obj.sClass + ", Rank " + iRank + ".")) : (strItemInfo + ("Requires " + obj.sClass + ", Rank " + iRank + "."))) + "</font><br>";
        }

        if (obj.FactionID > 1 && world.myAvatar.getRep(obj.FactionID) < obj.iReqRep) {
            strItemInfo = (strItemInfo + "<font size='10' color='#CC0000'>");
            iRankRep = getRankFromPoints(obj.iReqRep);
            iSpillRep = (obj.iReqRep - arrRanks[(iRank - 1)]);

            strItemInfo = (iSpillRep > 0 ? (strItemInfo + "Requires " + iSpillRep + " Reputation on " + obj.sFaction + ", Rank " + iRankRep + ".") : (strItemInfo + "Requires " + obj.sFaction + ", Rank " + iRankRep + ".")) + "</font><br>";
        }

        if ("irq" in obj)
        {
            for each (var item:Object in obj.irq)
            {
                if (world.myAvatar.objData.quests.hasOwnProperty(item.ChainID))
                {
                    var prerequisite:Number = Number(world.myAvatar.objData.quests[item.ChainID]);

                    if (prerequisite < item.Prerequisite) strItemInfo += "<font size='11' color='#CC0000'>Requires completion of quest \"" + item.Name + '".</font><br>';
                }
            }
        }

        if ("reqStats" in obj)
        {
            var sta:Object = world.uoTree[net.myUserName.toLowerCase()];

            function getStatValue(stat:String):int
            {
                return (sta.tempSta.hasOwnProperty("ba") ? sta.tempSta.ba[stat] : 0) +
                        (sta.tempSta.hasOwnProperty("ar") ? sta.tempSta.ar[stat] : 0) +
                        (sta.tempSta.hasOwnProperty("Weapon") ? sta.tempSta.Weapon[stat] : 0) +
                        (sta.tempSta.hasOwnProperty("he") ? sta.tempSta.he[stat] : 0) +
                        sta.tempSta.innate[stat] + sta.sta["$" + stat];
            }

            if (obj.reqStats.Strength > 0) {
                var totalStr: int = getStatValue("STR");
                if (totalStr < obj.reqStats.Strength) strItemInfo += "<font size='11' color='#CC0000'>Requires Strength \"" + obj.reqStats.Strength + "\".</font><br>";
            }

            if (obj.reqStats.Intellect > 0) {
                var totalInt: int = getStatValue("INT");
                if (totalInt < obj.reqStats.Intellect) strItemInfo += "<font size='11' color='#CC0000'>Requires Intellect \"" + obj.reqStats.Intellect + "\".</font><br>";
            }

            if (obj.reqStats.Dexterity > 0) {
                var totalDex: int = getStatValue("DEX");
                if (totalDex < obj.reqStats.Dexterity) strItemInfo += "<font size='11' color='#CC0000'>Requires Dexterity \"" + obj.reqStats.Dexterity + "\".</font><br>";
            }

            if (obj.reqStats.Endurance > 0) {
                var totalEnd: int = getStatValue("END");
                if (totalEnd < obj.reqStats.Endurance) strItemInfo += "<font size='11' color='#CC0000'>Requires Endurance \"" + obj.reqStats.Dexterity + "\".</font><br>";
            }

            if (obj.reqStats.Wisdom > 0) {
                var totalWis: int =  getStatValue("WIS");
                if (totalWis < obj.reqStats.Endurance) strItemInfo += "<font size='11' color='#CC0000'>Requires Wisdom \"" + obj.reqStats.Dexterity + "\".</font><br>";
            }

            if (obj.reqStats.Luck > 0) {
                var totalLck: int = getStatValue("LCK");
                if (totalLck < obj.reqStats.Luck) strItemInfo += "<font size='11' color='#CC0000'>Requires Luck \"" + obj.reqStats.Dexterity + "\".</font><br>";
            }

        }

//        var meta:String = String(obj.sMeta).toLowerCase();
//
//        if (meta.length > 0)
//        {
//            var sta:Object = world.uoTree[net.myUserName.toLowerCase()];
//
//            function getStatValue(stat:String):int
//            {
//                return (sta.tempSta.hasOwnProperty("ba") ? sta.tempSta.ba[stat] : 0) +
//                        (sta.tempSta.hasOwnProperty("ar") ? sta.tempSta.ar[stat] : 0) +
//                        (sta.tempSta.hasOwnProperty("Weapon") ? sta.tempSta.Weapon[stat] : 0) +
//                        (sta.tempSta.hasOwnProperty("he") ? sta.tempSta.he[stat] : 0) +
//                        sta.tempSta.innate[stat] + sta.sta["$" + stat];
//            }
//
//            for each (var stats:String in meta.split(','))
//            {
//                var parts:Array = stats.split(':');
//                var stat:String = parts[0];
//                var value:int = int(parts[1]);
//
//                if (statsController.statMap.hasOwnProperty(stat))
//                {
//                    var totalStat:int = getStatValue(statsController.statMap[stat]);
//                    if (totalStat < value)
//                    {
//                        strItemInfo += "<font size='11' color='#CC0000'>Requires " + stat.charAt(0).toUpperCase() + stat.slice(1) + " \"" + value + "\".</font><br>";
//                    }
//                }
//            }
//        }

        if (((obj.iQSindex >= 0) && (world.getQuestValue(obj.iQSindex) < int(obj.iQSvalue)))) {
            strItemInfo = (strItemInfo + (("<font size='11' color='#CC0000'>Requires completion of quest \"" + obj.sQuest) + '".</font><br>'));
        }

        if (world.myAvatar.isStaff()) strItemInfo += "ID <font color='#00CCFF'>" + obj.ItemID + "</font><br>";

        if ((((!(obj.sMeta == null)) && (getDisplaysType(obj) == "Pet")) && (obj.sMeta.indexOf("Necromancer") > -1))) {
            strItemInfo = (strItemInfo + ("<font color='#00CCFF'><b>Battle " + getDisplaysType(obj)));
        } else {
            strItemInfo = (strItemInfo + ("<font color='#00CCFF'><b>" + getDisplaysType(obj)));
        }

        if (obj.sType.toLowerCase() == "enhancement") {
            strItemInfo = (strItemInfo + (", Level " + obj.iLvl));
        }
        if ((((!(obj.sES == "None")) && (!(obj.sES == "co"))) && (!(obj.sES == "pe")))) {
            if (obj.EnhID > 0) {
                strItemInfo = (strItemInfo + (", Level " + obj.EnhLvl));
                if (obj.sES == "ar") {
                    strItemInfo = (strItemInfo + ("<br>Rank " + getRankFromPoints(obj.iQty)));
                }
            } else {
                if (obj.sType.toLowerCase() != "enhancement") {
                    strItemInfo = (strItemInfo + " Design");
                }
            }
        }

        if (obj.iStk > 1) strItemInfo = strItemInfo + " - " + (obj.hasOwnProperty("iQty") ? obj.iQty : 0) + "/" + obj.iStk;

        if (obj.sES == "Weapon" || obj.sES == "co" || obj.sES == "he" || obj.sES == "ba" || obj.sES == "pe" || obj.sES == "am") {
            if (obj.sType.toLowerCase() != "enhancement") {
                var rarity:Object = world.rarity[obj.iRty];

                strItemInfo += rarity != null ? "<br><font color='" + String(rarity.Color).replace("0x", "#") + "'>" + rarity.Name + " Rarity" : "<br><font color='#FFFFFF'> Rarity";
            }
        }
        if (obj.sType.toLowerCase() != "enhancement") {
            strItemInfo = (strItemInfo + (("</b></font><br><font size='10' color='#FFFFFF'>" + trim(obj.sDesc)) + "<br></font>"));
        } else {
            strItemInfo = (strItemInfo + "</b></font><br><font size='10' color='#FFFFFF'>");
            strItemInfo = (strItemInfo + "Enhancements are special items which can apply stats to your weapons and armor. Select a weapon or armor item from the list on the right, and click the <font color='#00CCFF'>\"Enhancements\"</font> button that appears below its preview.");
        }

        return (strItemInfo);
    }

    public function getIconByType(_arg_1:String):String {
        var _local_2:* = "";
        switch (_arg_1.toLowerCase()) {
            case "axe":
            case "bow":
            case "dagger":
            case "gun":
            case "mace":
            case "polearm":
            case "staff":
            case "sword":
            case "wand":
            case "armor":
                _local_2 = ("iw" + _arg_1.toLowerCase());
                break;
            case "cape":
            case "helm":
            case "pet":
            case "class":
                _local_2 = ("ii" + _arg_1.toLowerCase());
                break;
            default:
                _local_2 = "iibag";
        }
        return (_local_2);
    }

    public function getIconBySlot(_arg_1:String):String {
        var _local_2:* = "";
        switch (_arg_1.toLowerCase()) {
            case "weapon":
                _local_2 = "iwsword";
                break;
            case "back":
            case "ba":
                _local_2 = "iicape";
                break;
            case "head":
            case "he":
                _local_2 = "iihelm";
                break;
            case "armor":
            case "ar":
                _local_2 = "iiclass";
                break;
            case "class":
                _local_2 = "iiclass";
                break;
            case "pet":
            case "pe":
                _local_2 = "iipet";
                break;
            default:
                _local_2 = "iibag";
        }
        return (_local_2);
    }

    public function getDisplaysType(_arg_1:Object):* {
        var _local_2:String = ((_arg_1.sType != null) ? _arg_1.sType : "Unknown");
        var _local_3:String = _local_2.toLowerCase();
        if (((_local_3 == "clientuse") || (_local_3 == "serveruse"))) {
            _local_2 = "Item";
        }
        return (_local_2);
    }

    public function stringToDate(_arg_1:String):Date {
        var _local_2:* = Number(_arg_1.substr(0, 4));
        var _local_3:* = (Number(_arg_1.substr(5, 2)) - 1);
        var _local_4:* = Number(_arg_1.substr(8, 2));
        var _local_5:* = Number(_arg_1.substr(11, 2));
        var _local_6:* = Number(_arg_1.substr(14, 2));
        var _local_7:* = Number(_arg_1.substr(17));
        return (new Date(_local_2, _local_3, _local_4, _local_5, _local_6, _local_7));
    }

    public function dateTimeStringToDate(dateString:String):Date {
        var parts:Array = dateString.split("T");
        var dateParts:Array = parts[0].split("-");
        var timeParts:Array = parts[1].split(":");

        var year:int = int(dateParts[0]);
        var month:int = int(dateParts[1]) - 1;
        var day:int = int(dateParts[2]);
        var hour:int = int(timeParts[0]);
        var minute:int = int(timeParts[1]);
        var second:int = int(timeParts[2]);

        return new Date(year, month, day, hour, minute, second);
    }

    internal function traceObject(_arg_1:*, _arg_2:* = 1):* {
        var _local_4:*;
        var _local_5:*;
        var _local_3:* = "";
        while (_local_3.length < _arg_2) {
            _local_3 = (_local_3 + " ");
        }
        _arg_2++;
        if (((typeof (_arg_1) == "object") && (!(_arg_1.length == null)))) {
            _local_4 = 0;
            while (_local_4 < _arg_1.length) {
                trace(_local_3 + _local_4 + ": " + _arg_1[_local_4]);
                _local_4++;
            }
        } else {
            for (_local_5 in _arg_1) {
                trace(_local_3 + _local_5 + ": " + _arg_1[_local_5]);
                if (typeof _arg_1[_local_5] == "object") {
                    traceObject(_arg_1[_local_5], _arg_2);
                }
            }
        }
    }

    public function max(_arg_1:int, _arg_2:int):int {
        if (_arg_1 > _arg_2) {
            return _arg_1;
        }
        return _arg_2;
    }

    public function clamp(_arg_1:Number, _arg_2:Number, _arg_3:Number):Number {
        if (_arg_1 < _arg_2) {
            return _arg_2;
        }
        if (_arg_1 > _arg_3) {
            return _arg_3;
        }
        return _arg_1;
    }

    public function isValidEmail(_arg_1:String):Boolean {
        return Boolean(_arg_1.match(EMAIL_REGEX));
    }

    public function closeToolTip():void {
        var _local_1:*;
        try {
            _local_1 = MovieClip(stage.getChildAt(0)).ui.ToolTip;
            _local_1.close();
        } catch (e:Error) {
        }
    }

    public function updateIcons(actIcons:Array, iconArray:Array, item:Object = null, isCharCreate:Boolean = false):* {
        var actIconMC:MovieClip;
        var iconShapeClass:Class;
        var iconShape:*;
        var iconShapeMC:*;
        var aw:*;
        var ah:*;
        var bw:*;
        var bh:*;
        var i:int;
        var j:int;
        i = 0;
        while (i < actIcons.length) {
            actIconMC = actIcons[i];
            actIconMC.cnt.removeChildAt(0);
            actIconMC.item = item;
            if (actIconMC.item == null) {
                actIconMC.tQty.visible = false;
            }
            while (j < iconArray.length) {
                iconShapeClass = isCharCreate ? params.domain.assetsDomain.getDefinition(iconArray[j]) as Class : (world.getClass(iconArray[j]) as Class);
                iconShape = new iconShapeClass();
                iconShapeMC = actIconMC.cnt.addChild(iconShape);
                aw = int((42 - 8) + 4 * j);
                ah = int((39 - 8) + 4 * j);
                bw = iconShapeMC.width;
                bh = iconShapeMC.height;
                if (bw > bh) {
                    iconShapeMC.scaleX = (iconShapeMC.scaleY = aw / bw);
                } else {
                    iconShapeMC.scaleX = (iconShapeMC.scaleY = ah / bh);
                }
                iconShapeMC.x = actIconMC.bg.width / 2 - iconShapeMC.width / 2;
                iconShapeMC.y = actIconMC.bg.height / 2 - iconShapeMC.height / 2;
                j++;
            }
            i++;
        }
    }

    public function updateActionObjIcon(actionObj:Object):void {
        var icon1:MovieClip;
        var item:Object;
        var iQty:int;
        var i:int;
        var actIcons:Array = world.getActIcons(actionObj);
        var j:* = 0;
        while (j < actIcons.length) {
            icon1 = actIcons[j];
            item = icon1.item;
            if (item != null) {
                iQty = 0;
                while (i < world.myAvatar.items.length) {
                    if (world.myAvatar.items[i].ItemID == item.ItemID) {
                        iQty = int(world.myAvatar.items[i].iQty);
                    }
                    i++;
                }
                if (iQty > 0) {
                    icon1.tQty.visible = true;
                    icon1.tQty.text = iQty;
                } else {
                    world.unequipUseableItem(item);
                }
            }
            j++;
        }
    }

    public function drawChainsSmooth(_arg_1:Array, _arg_2:int, _arg_3:MovieClip):void {
        var _local_4:Point;
        var _local_5:Point;
        var _local_6:int;
        var _local_7:Array;
        var _local_8:int;
        var _local_9:int;
        var _local_10:int;
        var _local_11:Point;
        var _local_12:Array;
        var _local_13:MovieClip;
        var _local_14:int;
        var _local_15:int;
        _local_6 = 1;
        while (_local_6 < _arg_1.length) {
            _local_4 = new Point(0, 0);
            _local_5 = new Point(0, 0);
            _local_4 = _arg_1[(_local_6 - 1)].localToGlobal(_local_4);
            _local_5 = _arg_1[_local_6].localToGlobal(_local_5);
            _local_7 = [];
            _local_8 = 0;
            _local_9 = 0;
            _local_10 = int(Math.ceil(Point.distance(_local_4, _local_5) / _arg_2));
            if (_local_10 % 2 == 1) {
                _local_10 = _local_10 + 1;
            }
            _local_11 = new Point();
            _local_12 = [_arg_3.fx0, _arg_3.fx1, _arg_3.fx2];
            _local_14 = -1;
            _local_8 = 0;
            while (_local_8 < _local_12.length) {
                _local_7 = [];
                _local_14 = int(Math.random() > 0.5 ? 1 : -1);
                _local_15 = 0;
                _local_9 = 1;
                while (_local_9 < _local_10) {
                    _local_11 = Point.interpolate(_local_4, _local_5, 1 - _local_9 / _local_10);
                    if (++_local_15 % 2 == 1) {
                        _local_11.x = _local_11.x + _local_14 * Math.round(Math.random() * 30);
                        _local_11.y = _local_11.y + _local_14 * Math.round(Math.random() * 30);
                        _local_14 = -_local_14;
                    }
                    _local_7.push(_local_11);
                    _local_9++;
                }
                _local_7.push(_local_5);
                _local_13 = _local_12[_local_8];
                _local_13.graphics.lineStyle(2, 0xFFFFFF, 1);
                _local_13.graphics.moveTo(_local_4.x, _local_4.y);
                _local_9 = 0;
                while (_local_9 < _local_7.length) {
                    _local_13.graphics.curveTo(_local_7[_local_9].x, _local_7[_local_9].y, _local_7[(_local_9 + 1)].x, _local_7[(_local_9 + 1)].y);
                    _local_9 = _local_9 + 2;
                }
                _local_8++;
            }
            _local_6++;
        }
    }

    public function drawChainsLinear(_arg_1:Array, _arg_2:int, _arg_3:MovieClip):void {
        var _local_4:Point;
        var _local_5:Point;
        var _local_6:MovieClip;
        var _local_7:MovieClip;
        var _local_8:int;
        var _local_9:Array;
        var _local_10:int;
        var _local_11:int;
        var _local_12:int;
        var _local_13:Point;
        var _local_14:Array;
        var _local_15:MovieClip;
        _local_8 = 1;
        while (_local_8 < _arg_1.length) {
            _local_6 = _arg_1[(_local_8 - 1)];
            _local_7 = _arg_1[_local_8];
            _local_4 = new Point(0, -_local_6.height * 0.5);
            _local_5 = new Point(0, -_local_7.height * 0.5);
            _local_4 = _local_6.localToGlobal(_local_4);
            _local_5 = _local_7.localToGlobal(_local_5);
            _local_9 = [];
            _local_10 = 0;
            _local_11 = 0;
            _local_12 = int(Math.ceil(Point.distance(_local_4, _local_5) / _arg_2));
            _local_13 = new Point();
            _local_14 = [_arg_3.fx0, _arg_3.fx1, _arg_3.fx2];
            _local_10 = 0;
            while (_local_10 < _local_14.length) {
                _local_9 = [];
                _local_11 = 1;
                while (_local_11 < _local_12) {
                    _local_13 = Point.interpolate(_local_4, _local_5, 1 - _local_11 / (_local_12 + 1));
                    _local_13.x = _local_13.x + Math.round(Math.random() * 25 - 13);
                    _local_13.y = _local_13.y + Math.round(Math.random() * 25 - 13);
                    _local_9.push(_local_13);
                    _local_11++;
                }
                _local_15 = _local_14[_local_10];
                _local_15.graphics.lineStyle(5, 0xFFFFFF, 1);
                _local_15.graphics.moveTo(_local_4.x, _local_4.y);
                _local_11 = 0;
                while (_local_11 < _local_9.length) {
                    _local_15.graphics.lineTo(_local_9[_local_11].x, _local_9[_local_11].y);
                    _local_11++;
                }
                _local_15.graphics.lineTo(_local_5.x, _local_5.y);
                _local_10++;
            }
            _local_8++;
        }
    }

    public function drawFunnel(_arg_1:Array, _arg_2:MovieClip):void {
        var _local_3:MovieClip;
        _arg_2.numLines = 3;
        _arg_2.lineThickness = 3;
        _arg_2.lineColors = [0x9900AA, 0, 0x220066];
        _arg_2.glowColors = [0];
        _arg_2.glowStrength = 4;
        _arg_2.glowSize = 4;
        _arg_2.dur = 500;
        _arg_2.del = 100;
        _arg_2.p1StartingValue = 0.12;
        _arg_2.p2StartingValue = 0.24;
        _arg_2.p3StartingValue = 0.36;
        _arg_2.p1EndingValue = 0.66;
        _arg_2.p2EndingValue = 0.825;
        _arg_2.p3EndingValue = 0.99;
        _arg_2.p1ScaleFactor = 0.5;
        _arg_2.p3ScaleFactor = 0.5;
        _arg_2.easingExponent = 1.5;
        _arg_2.targetMCs = _arg_1;
        _arg_2.filterArr = [];
        _arg_2.fxArr = [];
        _arg_2.ts = new Date().getTime();
        var _local_4:int;
        var _local_5:int;
        _local_4 = 0;
        while (_local_4 < _arg_2.glowColors.length) {
            _arg_2.filterArr.push([new GlowFilter(_arg_2.glowColors[_local_4], 1, _arg_2.glowSize, _arg_2.glowSize, _arg_2.glowStrength, 1, false, false)]);
            _local_4++;
        }
        _local_4 = 0;
        _local_5 = 0;
        var _local_6:int;
        while (_local_6 < _arg_2.numLines) {
            _local_3 = (_arg_2.addChild(new MovieClip()) as MovieClip);
            _local_3.filters = _arg_2.filterArr[_local_4];
            if (++_local_4 >= _arg_2.glowColors.length) {
                _local_4 = 0;
            }
            _local_3.lineColor = _arg_2.lineColors[_local_5];
            if (++_local_5 >= _arg_2.lineColors.length) {
                _local_5 = 0;
            }
            _arg_2.fxArr.push(_local_3);
            _local_6++;
        }
        _arg_2.addEventListener(Event.ENTER_FRAME, funnelEF, false, 0, true);
    }

    internal function funnelEF(_arg_1:Event):void {
        var _local_3:MovieClip;
        var _local_8:Number;
        var _local_9:Number;
        var _local_17:Point;
        var _local_18:Point;
        var _local_19:Point;
        var _local_20:Point;
        var _local_21:Point;
        var _local_22:Point;
        var _local_26:Number;
        var _local_29:Number;
        var _local_30:Number;
        var _local_2:MovieClip = MovieClip(_arg_1.currentTarget);
        var _local_4:Number = new Date().getTime();
        var _local_5:Point = new Point();
        var _local_6:Point = new Point();
        var _local_7:Point = new Point();
        var _local_10:int = 1;
        var _local_11:MovieClip = _local_2.targetMCs[0];
        var _local_12:MovieClip = _local_2.targetMCs[1];
        var _local_13:Point = _local_11.localToGlobal(new Point(0, -_local_11.height / 2));
        var _local_14:Point = _local_12.localToGlobal(new Point(0, -_local_12.height / 2));
        var _local_15:* = _local_12.width;
        var _local_16:* = _local_12.height;
        var _local_23:int = -1;
        var _local_24:int;
        var _local_25:int;
        var _local_27:Number = Math.atan2(_local_13.y - _local_14.y, _local_13.x - _local_14.x);
        _local_27 = _local_27 - Math.PI / 2;
        var _local_28:int;
        while (_local_28 < _local_2.fxArr.length) {
            _local_3 = _local_2.fxArr[_local_28];
            _local_9 = _local_2.ts;
            _local_8 = _local_4 - _local_28 * _local_2.del;
            if (_local_8 > _local_9 + _local_2.dur) {
                if (_local_3.visible) {
                    _local_3.visible = false;
                    _local_3.graphics.clear();
                }
                if (_local_28 == _local_2.fxArr.length - 1) {
                    _local_2.removeEventListener(Event.ENTER_FRAME, funnelEF);
                    if (_local_2.parent != null) {
                        _local_2.parent.removeChild(_local_2);
                    }
                }
            } else {
                if (_local_8 >= _local_2.ts) {
                    _local_29 = (_local_8 - _local_9) / _local_2.dur;
                    _local_29 = Math.pow(1 - _local_29, _local_2.easingExponent);
                    _local_10 = (_local_28 % 2) == 0 ? 1 : -1;
                    _local_17 = new Point(Point.interpolate(_local_13, _local_14, _local_2.p1StartingValue).x + Point.polar(_local_10 * (_local_12.height / _local_2.p1ScaleFactor), _local_27).x, Point.interpolate(_local_13, _local_14, _local_2.p1StartingValue).y + Point.polar(_local_10 * (_local_12.height / _local_2.p1ScaleFactor), _local_27).y);
                    _local_18 = new Point(Point.interpolate(_local_13, _local_14, _local_2.p1EndingValue).x, Point.interpolate(_local_13, _local_14, _local_2.p1EndingValue).y);
                    _local_19 = new Point(Point.interpolate(_local_13, _local_14, _local_2.p2StartingValue).x, _local_14.y);
                    _local_20 = new Point(Point.interpolate(_local_13, _local_14, _local_2.p2EndingValue).x, Point.interpolate(_local_13, _local_14, _local_2.p2EndingValue).y);
                    _local_21 = new Point(Point.interpolate(_local_13, _local_14, _local_2.p3StartingValue).x + Point.polar(-_local_10 * (_local_12.height / _local_2.p3ScaleFactor), _local_27).x, Point.interpolate(_local_13, _local_14, _local_2.p3StartingValue).y + Point.polar(-_local_10 * (_local_12.height / _local_2.p3ScaleFactor), _local_27).y);
                    _local_22 = new Point(Point.interpolate(_local_13, _local_14, _local_2.p3EndingValue).x, Point.interpolate(_local_13, _local_14, _local_2.p3EndingValue).y);
                    _local_5 = Point.interpolate(_local_17, _local_18, _local_29);
                    _local_6 = Point.interpolate(_local_19, _local_20, _local_29);
                    _local_7 = Point.interpolate(_local_21, _local_22, _local_29);
                    _local_26 = _local_3.lineColor;
                    _local_3.graphics.clear();
                    _local_3.graphics.lineStyle(_local_2.lineThickness, _local_26, 1);
                    _local_3.graphics.moveTo(_local_14.x, _local_14.y);
                    _local_3.graphics.curveTo(_local_5.x, _local_5.y, _local_6.x, _local_6.y);
                    _local_3.graphics.curveTo(_local_7.x, _local_7.y, _local_13.x, _local_13.y);
                    _local_30 = Math.cos(((_local_8 - _local_9) / _local_2.dur) * Math.PI * 2);
                    _local_30 = _local_30 / 2 + 0.5;
                    _local_30 = 1 - _local_30;
                    _local_3.alpha = _local_30;
                }
            }
            _local_28++;
        }
    }

    public function spaceBy(_arg_1:int, _arg_2:int):String {
        var _local_3:String = String(_arg_1);
        while (_local_3.length < _arg_2) {
            _local_3 = _local_3 + " ";
        }
        return _local_3;
    }

    public function spaceNumBy(_arg_1:Number, _arg_2:int):String {
        var _local_3:String = _arg_1.toString();
        _local_3 = _local_3.substr(0, _arg_2);
        while (_local_3.length < _arg_2) {
            _local_3 = _local_3 + " ";
        }
        return _local_3;
    }

    public function coeffToPct(_arg_1:Number):String {
        return Number(_arg_1 * 100).toFixed(2);
    }

    public function catCodeToName(_arg_1:String):String {
        switch (_arg_1) {
            case "M1":
                return "Fighter";
            case "M2":
                return "Thief";
            case "M3":
                return "Hybrid";
            case "M4":
                return "Armsman";
            case "C1":
                return "Wizard";
            case "C2":
                return "Healer";
            case "C3":
                return "spellbreaker";
            case "S1":
                return "Lucky";
            default:
                return null;
        }
    }

    public function applyAuraEffect(_arg_1:*, _arg_2:*):* {
        switch (_arg_1.typ) {
            case "+":
                _arg_2[("$" + _arg_1.sta)] = _arg_2[("$" + _arg_1.sta)] + Number(_arg_1.val);
                return;
            case "-":
                _arg_2[("$" + _arg_1.sta)] = _arg_2[("$" + _arg_1.sta)] - Number(_arg_1.val);
                return;
            case "*":
                _arg_2[("$" + _arg_1.sta)] = Math.round(_arg_2[("$" + _arg_1.sta)] * Number(_arg_1.val));
                return;
        }
    }

    public function removeAuraEffect(_arg_1:*, _arg_2:*):* {
        switch (_arg_1.typ) {
            case "+":
                _arg_2[("$" + _arg_1.sta)] = _arg_2[("$" + _arg_1.sta)] - Number(_arg_1.val);
                return;
            case "-":
                _arg_2[("$" + _arg_1.sta)] = _arg_2[("$" + _arg_1.sta)] + Number(_arg_1.val);
                return;
            case "*":
                _arg_2[("$" + _arg_1.sta)] = Math.round(_arg_2[("$" + _arg_1.sta)] / Number(_arg_1.val));
        }
    }

    public function toggleItemEquip(o:Object):Boolean {
        var isValid:Boolean = false;
        var sType:String = o.sType.toLowerCase();
        var sES:String = o.sES;

        if (world.getUoLeafById(world.myAvatar.uid).intState != 1) {
            MsgBox.notify("Action cannot be performed during combat!");
            return false;
        }

        if (world.bPvP) {
            MsgBox.notify("Items may not be equipped or unequipped during a PvP match!");
            return false;
        }

        if (o.bEquip == 1) {
            if (sES == "Weapon" || sES == "ar") {
                MsgBox.notify("Selected Item cannot be unequipped!");
                return false;
            }

            isValid = true;

            if (sType == "item" || sType == "potion") world.unequipUseableItem(o);
            else world.sendUnequipItemRequest(o);

            return isValid;
        }

        if (o.bUpg == 1 && !world.myAvatar.isUpgraded()) {
            showUpgradeWindow();
            return false;
        }

        if (int(o.EnhLvl) > int(world.myAvatar.objData.intLevel)) {
            MsgBox.notify("Level requirement not met!");
            return false;
        }

        var needsEnh:Boolean = (sType != "item" && sES != "co" && sES != "pe" && sES != "am" && !(o.EnhID > 0));
        if (needsEnh) {
            MsgBox.notify("Selected item requires enhancement!");
            return false;
        }

        if (sType == "item" || sType == "potion")
        {
            isValid = true;
            world.equipUseableItem(o);
        }
        else
            isValid = world.sendEquipItemRequest(o);

        return isValid;
    }


    public function tryEnhance(_arg_1:Object, _arg_2:Object, _arg_3:Boolean = false):void {
        if (!(_arg_1 == null) && !(_arg_2 == null)) {
            if (_arg_2.iLvl > world.myAvatar.objData.intLevel) {
                MsgBox.notify("Level requirement not met!");
            } else {
                if (_arg_1.EnhID == _arg_2.ItemID) {
                    MsgBox.notify("Selected Enhancement already applied to item!");
                } else {
                    if (_arg_3) {
                        world.sendEnhItemRequestShop(_arg_1, _arg_2);
                    } else {
                        world.sendEnhItemRequestLocal(_arg_1, _arg_2);
                    }
                }
            }
        }
    }

    public function doIHaveEnhancements():Boolean {
        var _local_1:Object;
        for each (_local_1 in world.myAvatar.items) {
            if (_local_1.sType.toLowerCase() == "enhancement") {
                return true;
            }
        }
        return false;
    }

    public function isItemEnhanceable(_arg_1:Object):Boolean {
        return ["Weapon", "he", "ba", "pe", "ar"].indexOf(_arg_1.sES) >= 0;
    }

    public function resetInvTreeByItemID(ItemID:int):* {
        var item:Object;
        try {
            item = world.invTree[ItemID];
            if ("EnhID" in item) {
                item.EnhID = -1;
            }
            if ("EnhRty" in item) {
                item.EnhRty = -1;
            }
            if ("EnhDPS" in item) {
                item.EnhDPS = -1;
            }
            if ("EnhRng" in item) {
                item.EnhRng = -1;
            }
            if ("EnhLvl" in item) {
                item.EnhLvl = -1;
            }
            if ("EnhPatternID" in item) {
                item.EnhPatternID = -1;
            }
        } catch (e:Error) {
            trace(e);
        }
    }

    public function isMergeShop(_arg_1:Object):Boolean {
        var _local_2:Object;
        for each (_local_2 in _arg_1.items) {
            if ("turnin" in _local_2) {
                return true;
            }
        }
        return false;
    }

    public function recursiveStop(_arg_1:MovieClip):void {
        var _local_2:DisplayObject;
        var _local_3:int;
        while (_local_3 < _arg_1.numChildren) {
            _local_2 = _arg_1.getChildAt(_local_3);
            if (_local_2 is MovieClip) {
                _arg_1 = MovieClip(_local_2);
                if (_arg_1.totalFrames > 1) {
                    _arg_1.gotoAndStop(_arg_1.totalFrames);
                } else {
                    _arg_1.stop();
                }
                recursiveStop(MovieClip(_local_2));
            }
            _local_3++;
        }
    }

    private function onTravelMapComplete(_arg_1:Event):void {
        var _local_2:String = String(_arg_1.target.data);
        var _local_3:Object = JSON.parse(_local_2);
        travelMapData = _local_3;
        WorldMapData = new worldMap(travelMapData);
    }

    private function onTravelError(_arg_1:IOErrorEvent):void {
        trace("travel map load failed: " + _arg_1);
    }

    private function isAlphaChar(_arg_1:String):Boolean {
        var _local_2:uint = _arg_1.charCodeAt(0);
        return _local_2 >= 65 && _local_2 < 123 || _local_2 >= 48 && _local_2 < 58 ? true : false;
    }

    private function isRepeat(_arg_1:Array, _arg_2:String):Boolean {
        var _local_3:uint;
        while (_local_3 < _arg_1.length) {
            if (_arg_1[_local_3] == _arg_2) {
                return true;
            }
            _local_3++;
        }
        return false;
    }

    public function loadGameMenu():void {
        try {
            ui.removeChild(mcGameMenu);
        } catch (e:Error) {
        }

        mcGameMenu = null;

        var menuClass:Class = params.domain.menuDomain.getDefinition("GameMenu") as Class;

        mcGameMenu = MovieClip(new menuClass());
        mcGameMenu.name = "gameMenu";
        mcGameMenu.visible = true;
        mcGameMenu.x = 1050;
		mcGameMenu.y = 20;

        ui.addChild(mcGameMenu);
    }

    public function MenuShow():void {
        try {
            if (mcGameMenu.currentLabel == "Open") {
                mcGameMenu.gotoAndPlay("Close");
            } else {
                mcGameMenu.gotoAndStop("Open");
            }
        } catch (e) {
        }
    }

    public function menuClose():void {
        try {
            if (firstMenu) {
                firstMenu = false;
            } else {
                if (mcGameMenu.currentLabel != "Close") {
                    mcGameMenu.gotoAndPlay("Close");
                }
            }
        } catch (e:Error) {
        }
    }

    public function openMenu():void {
        try {
            if (mcGameMenu.currentLabel != "Open") {
                mcGameMenu.gotoAndStop("Open");
            }
        } catch (e) {
        }
    }

    public function getFilePath(file:String):String {
//        return serverBaseURL + "game/read/swf?path=gamefiles/" + file + "&deviceType= " + params.DeviceType;
//        return serverBaseURL + "game/swf?path=" + file + "&deviceType=" + params.DeviceType;
		return serverBaseURL + "gamefiles/" + file;
    }

    public function initWorld():void {
        if (world != null) {
            world.killTimers();
            world.killListeners();
            this.removeChild(world);
            world = null;
        }

        world = new World(this);

        RefreshLootCount();

        this.addChildAt(world, getChildIndex(ui));

        addChild(floatingDisplay);
    }

    public function grayAll(_arg_1:DisplayObjectContainer):void {
        var _local_2:DisplayObjectContainer;
        var _local_3:int;
        var _local_4:int;
        if (_arg_1 == null) {
            return;
        }
        if ((_arg_1 is MovieClip) && !(_arg_1 == this)) {
            (_arg_1 as MovieClip).stop();
        }
        if (_arg_1.numChildren) {
            _local_4 = _arg_1.numChildren;
            while (_local_3 < _local_4) {
                if (_arg_1.getChildAt(_local_3) is DisplayObjectContainer) {
                    _local_2 = (_arg_1.getChildAt(_local_3) as DisplayObjectContainer);
                    if (_local_2.numChildren) {
                        makeGrayscale(_local_2);
                    } else {
                        if (_local_2 is MovieClip) {
                            makeGrayscale(_local_2 as MovieClip);
                        }
                    }
                }
                _local_3++;
            }
        }
    }

    public function onAddedToStage(_arg_1:Event):void {
        Game.root = this;
        stage.showDefaultContextMenu = false;
        stage.stageFocusRect = false;

        mcConnDetail = new ConnDetailMC();

        gotoAndPlay("Login");

        if (preference.data.quality != "AUTO") {
            stage.quality = preference.data.quality;
        }
    }

    public function init():void {
        MsgBox.visible = false;
        readQueryString();
    }

    private function readQueryString():* {
        var _local_1:*;
        var _local_2:*;
        var _local_3:Array;
        var _local_4:*;
        var _local_5:*;
        var _local_6:String;
        var _local_7:String;
        var _local_8:String;
        try {
            _local_1 = "";
            if (_local_1) {
                _local_3 = _local_1.split("&");
                _local_4 = 0;
                _local_5 = -1;
                while (_local_4 < _local_3.length) {
                    _local_6 = _local_3[_local_4];
                    if ((_local_5 = _local_6.indexOf("=")) > 0) {
                        _local_7 = _local_6.substring(0, _local_5);
                        _local_8 = _local_6.substring(_local_5 + 1);
                        querystring[_local_7] = _local_8;
                    }
                    _local_4++;
                }
            }
            for (var _local_11:* in querystring) {
                _local_2 = _local_11;
                _local_11;
                trace(_local_2 + ": " + querystring[_local_2]);
            }
        } catch (e:Error) {
        }
    }

    public function initLogin():void {
        var curTS:Number;
        var iDiff:Number;
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, key_StageLogin);
        mcLogin.ni.tabIndex = 1;
        mcLogin.pi.tabIndex = 2;
        mcLogin.ni.removeEventListener(FocusEvent.FOCUS_IN, onUserFocus);
        mcLogin.ni.removeEventListener(KeyboardEvent.KEY_DOWN, key_TextLogin);
        mcLogin.pi.removeEventListener(KeyboardEvent.KEY_DOWN, key_TextLogin);
        mcLogin.btnLogin.removeEventListener(MouseEvent.CLICK, onLoginClick);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, key_StageLogin);
        mcLogin.ni.addEventListener(FocusEvent.FOCUS_IN, onUserFocus);
        mcLogin.ni.addEventListener(KeyboardEvent.KEY_DOWN, key_TextLogin);
        mcLogin.pi.addEventListener(KeyboardEvent.KEY_DOWN, key_TextLogin);
        mcLogin.btnLogin.addEventListener(MouseEvent.CLICK, onLoginClick);
        loadCharacterPreference();
        mcLogin.warning.s = String("Sorry! You have been disconnected. \n You will be able to login after $s seconds.");
        mcLogin.warning.visible = false;
        mcLogin.warning.alpha = 0;

        if (params.sURL != null) {
            mcLogin.mcLogo.txtTitle.htmlText = '<font color="#FFB231">New Release:</font> ' + params.sTitle;
        }

        if ("logoutWarningTS" in preference.data) {
            curTS = new Date().getTime();
            iDiff = (preference.data.logoutWarningTS + preference.data.logoutWarningDur * 1000) - curTS;
            if (iDiff > 60000) {
                preference.data.logoutWarningDur = 60;
                preference.data.logoutWarningTS = curTS;
                try {
                    preference.flush();
                } catch (e:Error) {
                    trace(e.message);
                }
            }
            if (iDiff > 1000) {
                initLoginWarning();
            }

            firstJoin = false;
        }

        if (preference.data.bitCheckAutoLogin && preference.data.strUsername != null && preference.data.strPassword != null && firstJoin) {
            firstJoin = false;
            login(preference.data.strUsername.toLowerCase(), preference.data.strPassword);
        }
    }

    public function loadTitle():void {
        try {
            var titleClass:Class = params.domain.titleDomain.getDefinition("TitleScreen") as Class;
            mcLogin.mcTitle.removeChildAt(0);
            mcLogin.mcTitle.addChild(new titleClass);
            mcConnDetail.mcTitle.removeChildAt(0);
            mcConnDetail.mcTitle.addChild(new titleClass);
        } catch (e:Error) {
            trace("Error Load Title!");
        }
    }

    private function initLoginWarning():void {
        var _local_1:MovieClip;
        var _local_2:Number;
        var _local_3:Number;
        var _local_4:Number;
        _local_1 = (mcLogin.warning as MovieClip);
        _local_1.visible = true;
        _local_1.alpha = 100;
        mcLogin.btnLogin.visible = false;
        mcLogin.mcOr.visible = false;
        mcLogin.mcForgotPassword.visible = false;
        mcLogin.mcPassword.visible = false;
        _local_2 = new Date().getTime();
        _local_3 = preference.data.logoutWarningTS;
        _local_4 = preference.data.logoutWarningDur;
        _local_1.n = Math.round(((_local_3 + _local_4 * 1000) - _local_2) / 1000);
        _local_1.ti.text = _local_1.s.split("$s")[0] + _local_1.n + _local_1.s.split("$s")[1];
        _local_1.timer = new Timer(1000);
        _local_1.timer.addEventListener(TimerEvent.TIMER, loginWarningTimer, false, 0, true);
        _local_1.timer.start();
    }

    private function loginWarningTimer(_arg_1:TimerEvent):void {
        var _local_2:MovieClip;
        _local_2 = (mcLogin.warning as MovieClip);
        if (_local_2.n-- < 1) {
            _local_2.visible = false;
            _local_2.alpha = 0;
            mcLogin.mcPassword.visible = true;
            mcLogin.btnLogin.visible = true;
            mcLogin.mcOr.visible = true;
            mcLogin.mcForgotPassword.visible = true;
            _local_2.timer.removeEventListener(TimerEvent.TIMER, loginWarningTimer);
        } else {
            _local_2.ti.text = _local_2.s.split("$s")[0] + _local_2.n + _local_2.s.split("$s")[1];
            _local_2.timer.reset();
            _local_2.timer.start();
        }
    }

    private function initInterface():void {
        ui.mcInterface.cacheAsBitmap = true;
        ui.dropStack.cacheAsBitmap = true;

        ui.mcFPS.visible = preference.data.bFps;
        ui.mcFPS.mouseEnabled = false;
        ui.mcFPS.mouseChildren = false;
        ui.mcPopup.visible = false;
        ui.mcPortrait.visible = false;
        ui.mcPopup.visible = false;
        hidePortraitTarget();
        ui.visible = false;
        ui.mcInterface.mcXPBar.mcXP.scaleX = 0;
        ui.mcUpdates.uproto.visible = false;
        ui.mcUpdates.uproto.y = -400;
        hideMCPVPQueue();
        stage.removeEventListener(KeyboardEvent.KEY_UP, key_actBar);
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, key_StageGame);
        ui.mcInterface.mcXPBar.removeEventListener(MouseEvent.MOUSE_OVER, xpBarMouseOver);
        ui.mcInterface.mcXPBar.removeEventListener(MouseEvent.MOUSE_OUT, xpBarMouseOut);
        ui.mcPortraitTarget.removeEventListener(MouseEvent.CLICK, portraitClick);
        ui.mcPortrait.removeEventListener(MouseEvent.CLICK, portraitClick);
        ui.btnTargetPortraitClose.removeEventListener(MouseEvent.CLICK, onTargetPortraitCloseClick);
        ui.mcPVPQueue.removeEventListener(MouseEvent.CLICK, onMCPVPQueueClick);
        chatF.init();
        stage.addEventListener(KeyboardEvent.KEY_UP, key_actBar);
        ui.mcInterface.mcXPBar.strXP.visible = false;
        ui.mcInterface.mcXPBar.addEventListener(MouseEvent.MOUSE_OVER, xpBarMouseOver);
        ui.mcInterface.mcXPBar.addEventListener(MouseEvent.MOUSE_OUT, xpBarMouseOut);
        ui.mcPortraitTarget.addEventListener(MouseEvent.CLICK, portraitClick);
        ui.mcPortrait.addEventListener(MouseEvent.CLICK, portraitClick);
        ui.btnTargetPortraitClose.addEventListener(MouseEvent.CLICK, onTargetPortraitCloseClick);
        ui.mcPVPQueue.addEventListener(MouseEvent.CLICK, onMCPVPQueueClick);
        ui.iconQuest.visible = false;
        ui.iconQuest.buttonMode = true;
        ui.iconQuest.addEventListener(MouseEvent.CLICK, oniconQuestClick);

        ui.iconDeveloper.visible = true;
        ui.iconDeveloper.buttonMode = true;
        ui.iconDeveloper.addEventListener(MouseEvent.CLICK, oniconDeveloperClick);

        ui.mcInterface.areaList.mouseEnabled = false;
        ui.mcInterface.areaList.title.mouseEnabled = false;
        ui.mcInterface.areaList.title.bMinMax.addEventListener(MouseEvent.CLICK, areaListClick);

        ui.mcInterface.tClientVersion.text = "Version " + ConfigurationData.VERSION;

        ui.mcPvEDuration.visible = false;
        ui.dropStack.visible = false;

        boosts = new Boosts();
        ui.addChild(boosts);

        if (preference.data.bAuras && !ui.mcInterface.getChildByName("playerAuras"))
        {
            playerAura = new PlayerAura(this);
            ui.addChild(playerAura);
            targetAura = new TargetAura(this);
            ui.addChild(targetAura);
        }

        mapBuilder.visible = false;

//        if (preference.data.bAuras)
//        {
//            if (!ui.getChildByName("playerAuras"))
//            {
//                targetAura = new TargetAura(this);
//                ui.addChild(targetAura);
//            }
//
//            if (!ui.getChildByName("targetAuras"))
//            {
//                playerAura = new PlayerAura(this);
//                ui.addChild(playerAura);
//            }
//        }
    }

    private function onUserFocus(_arg_1:FocusEvent):* {
        if (mcLogin.ni.text == "click here") {
            mcLogin.ni.text = "";
        }
    }

    private function loadCharacterPreference():void {
        if (preference.data.bitCheckedUsername) {
            mcLogin.ni.text = TempLoginName != "" ? TempLoginName : preference.data.strUsername;
            mcLogin.chkUserName.bitChecked = true;
        }

        if (preference.data.bitCheckedPassword) {
            mcLogin.pi.text = TempLoginPass != "" ? TempLoginPass : preference.data.strPassword;
            mcLogin.chkPassword.bitChecked = true;
        }

        if (preference.data.bitCheckAutoLogin) {
            mcLogin.chkAutoLogin.bitChecked = true;
        }

        mcLogin.chkUserName.checkmark.visible = mcLogin.chkUserName.bitChecked;
        mcLogin.chkPassword.checkmark.visible = mcLogin.chkPassword.bitChecked;
        mcLogin.chkAutoLogin.checkmark.visible = mcLogin.chkAutoLogin.bitChecked;
        preference.data.bSoundOn = preference.data.bSoundOn == null ? true : Boolean(preference.data.bSoundOn);
    }

    private function saveCharacterPreference():void {
        preference.data.bitCheckedUsername = mcLogin.chkUserName.bitChecked;
        preference.data.bitCheckedPassword = mcLogin.chkPassword.bitChecked;
        preference.data.bitCheckAutoLogin = mcLogin.chkAutoLogin.bitChecked;

        preference.data.strUsername = mcLogin.chkUserName.bitChecked ? preference.data.strUsername = mcLogin.ni.text : "";
        preference.data.strPassword = mcLogin.chkPassword.bitChecked ? mcLogin.pi.text : "";

        try {
            preference.flush();
        } catch (e:Error) {
            trace(e.message);
        }
    }


    private function onLoginClick(_arg_1:MouseEvent):void {
        if ("btnLogin" in mcLogin && mcLogin.btnLogin.visible) {
            if (mcLogin.ni.text != "" && mcLogin.pi.text != "") {
                try {
                    saveCharacterPreference();
                } catch (e:Error) {
                }
                login(mcLogin.ni.text.toLowerCase(), mcLogin.pi.text);
            }
        }
    }

    public function login(strUsername:String, strPassword:String):void {
        mcConnDetail.showConn("Authenticating Account Info...", true);

        loginInfo.strUsername = strUsername;
        loginInfo.strToken = strPassword;

        requestAPI(URLRequestMethod.POST,"game/login", {
            "user":strUsername,
            "pass":strPassword
        }, onLoginComplete, onLoginError, false);
    }

    public function onLoginError(event:IOErrorEvent):void {
        trace("Login Failed!" + event);
        mcConnDetail.showConn("Error login!", true);
    }

    public function onLoginComplete(event:Event):void {
        var response:Object;

		trace("onLoginComplete");

        try {
            response = JSON.parse(event.target.data);

            objLogin = response.login;
            _characters = [];

            for each (var character:Object in response.characters) {
                _characters.push(character);
            }

            if (response.bSuccess == 1) {
                mcConnDetail.hideConn();

                loginInfo.userId = objLogin.userId;
                loginInfo.strToken = objLogin.sToken;

//                mcLogin.gotoAndStop("Test");
                mcLogin.gotoAndStop(_characters.length > 0 ? "Characters" : "Create");
            } else {
                mcConnDetail.showError(response.sMsg);
            }

        } catch (e:Error) {
            mcConnDetail.showConn("Error login!", true);
            trace("caught LoginComplete error => " + e.message);
        }
    }

    public function loadChatChannels() : void {
        mcConnDetail.showConn("Loading chat channels...");
        requestAPI(URLRequestMethod.GET,"game/chat/channels", {}, onChatChannelsComplete, onChatChannelsError, false);
    }

    public function onChatChannelsComplete(event:Event):void {
        try {
            var response:Object = JSON.parse(event.target.data);

            for each (var o:Object in response.channels) {
                chatF.chn[o.Name] = {
                    col: o.Color,
                    str: o.Name,
                    typ: o.Type,
                    tag: o.Tag,
                    rid: o.Rid,
                    act: o.Act
                };
            }

            chatF.chn.cur = chatF.chn.zone;
            chatF.chn.lastPublic = chatF.chn.cur;

            resumeOnLoginResponse();
        } catch (e:Error) {
            mcConnDetail.showConn("Error login!", true);
            trace("caught ChatChannelsComplete error => " + e.message);
        }
    }

    public function onChatChannelsError(event:IOErrorEvent):void {
        trace("Chat Channels Failed!" + event);
        mcConnDetail.showConn("Error Chat Channels!", true);
    }

    public function resumeOnLoginResponse():void {
        mcConnDetail.showConn("Joining Lobby..");

        net.send("firstJoin", []);

//        if (chatF.ignoreList.data.users.length > 0) {
//            net.send("cmd", ["ignoreList", chatF.ignoreList.data.users]);
//        } else {
//            net.send("cmd", ["ignoreList", "$clearAll"]);
//        }
    }

    public function connectTo(ip:String, port:int = 5588):void {
        mixer.playSound("ClickBig");
        mcConnDetail.showConn("Connecting to game server...", true);
        net.connect(ip, port);
        gotoAndPlay("Game");
    }

    public function readIA1Preferences():void {
        uoPref.bCloak = world.getAchievement("ia1", 0) == 0;
        uoPref.bHelm = world.getAchievement("ia1", 1) == 0;
        uoPref.bPet = world.getAchievement("ia1", 2) == 0;
        uoPref.bWAnim = world.getAchievement("ia1", 3) == 0;
        uoPref.bGoto = world.getAchievement("ia1", 4) == 0;
        uoPref.bSoundOn = world.getAchievement("ia1", 5) == 0;
        uoPref.bMusicOn = world.getAchievement("ia1", 6) == 0;
        uoPref.bFriend = world.getAchievement("ia1", 7) == 0;
        uoPref.bParty = world.getAchievement("ia1", 8) == 0;
        uoPref.bGuild = world.getAchievement("ia1", 9) == 0;
        uoPref.bWhisper = world.getAchievement("ia1", 10) == 0;
        uoPref.bTT = world.getAchievement("ia1", 11) == 0;
        uoPref.bFBShare = world.getAchievement("ia1", 12) == 1;
        uoPref.bDuel = world.getAchievement("ia1", 13) == 0;
        world.hideAllCapes = world.getAchievement("ia1", 14) == 1;
        world.hideOtherPets = world.getAchievement("ia1", 15) == 1;
        world.showAnimations = world.getAchievement("ia1", 17) == 0;

        uoPref.bFBShard = false;

        if (uoPref.bSoundOn && preference.data.iSoundStrength != null) {
            SoundMixer.soundTransform = new SoundTransform(preference.data.iSoundStrength / 100);
        } else {
            SoundMixer.soundTransform = new SoundTransform(0);
        }
    }

    public function inituoPref():void {
        uoPref.bCloak = true;
        uoPref.bHelm = true;
        uoPref.bPet = true;
        uoPref.bWAnim = true;
        uoPref.bGoto = true;
        uoPref.bSoundOn = true;
        uoPref.bMusicOn = true;
        uoPref.bFriend = true;
        uoPref.bParty = true;
        uoPref.bGuild = true;
        uoPref.bWhisper = true;
        uoPref.bTT = true;
        uoPref.bFBShare = false;
        uoPref.bDuel = true;
    }

    public function initKeybindPref():void
    {
        if (preference.data.hasOwnProperty("keys")) return;

        preference.data.keys = {};
        preference.data.keys["Auto Attack"] = 49;
        preference.data.keys["Skill 1"] = 50;
        preference.data.keys["Skill 2"] = 51;
        preference.data.keys["Skill 3"] = 52;
        preference.data.keys["Skill 4"] = 53;
        preference.data.keys["Skill 5"] = 54;
        preference.data.keys["Skill 6"] = 55;
        preference.data.keys["Skill 7"] = 56;
        preference.data.keys["Inventory"] = 73;
        preference.data.keys["Bank"] = 66;
        preference.data.keys["Quest Log"] = 76;
        preference.data.keys["Friends List"] = 70;
        preference.data.keys["Character Panel"] = 67;
        preference.data.keys["Player HP Bar"] = 86;
        preference.data.keys["Options"] = 79;
        preference.data.keys["Area List"] = 85;
        preference.data.keys["Jump"] = 32;
        preference.data.keys["Rest"] = 88;
        preference.data.keys["Hide UI"] = null;

        try {
            preference.flush();
        } catch (e:Error) {
            trace(e.message);
        }
    }

    public function initCachePref() : void {
        if (preference.data.hasOwnProperty("cache")) return;

        preference.data.cache = {};
        preference.data.cache.map = { enabled: false, val: 5, min: 1, max : 15 };
//        preference.data.cache.monster = { enabled: false, val: 10, min: 1, max : 30 };

        try {
            preference.flush();
        } catch (e:Error) {
            trace(e.message);
        }
    }

    public function movieClipStartOrStopAll(target:MovieClip, isPlay:Boolean = false):void
    {
        for (var i:uint = 0; i < target.numChildren; i++)
        {
            if ((target.getChildAt(i) is MovieClip))
            {
                try
                {
                    var child:MovieClip = target.getChildAt(i) as MovieClip;

                    if (isPlay)
                    {
                        child.gotoAndPlay(0);
                    }
                    else
                    {
                        child.gotoAndStop(0);
                    }

                    movieClipStartOrStopAll(child, isPlay);
                }
                catch(e:Error)
                {
                }
            }
        }
    }

    public function rasterizePart(_arg_1:DisplayObject):Bitmap
    {
        var _local_2:Matrix;
        var _local_3:Rectangle;
        var _local_4:Point;
        var _local_5:BitmapData;
        var _local_6:Bitmap;
        _local_2 = _arg_1.transform.matrix;
        _local_3 = _arg_1.getBounds(_arg_1.parent);
        _local_4 = new Point((_arg_1.x - _local_3.left), (_arg_1.y - _local_3.top));
        _local_2.tx = _local_4.x;
        _local_2.ty = _local_4.y;
        _local_5 = new BitmapData(_local_3.width, _local_3.height, true, 0);
        _local_5.draw(_arg_1, _local_2, _arg_1.transform.colorTransform, null, null, true);
        _local_6 = new Bitmap(_local_5);
        _local_6.smoothing = true;
        _local_6.x = (_local_6.x - _local_4.x);
        _local_6.y = (_local_6.y - _local_4.y);
        return (_local_6);
    }

    public function rasterize(_arg_1:MovieClip):void
    {
        movieClipRasterizeInner(_arg_1);
    }

    public function movieClipRasterizeInner(_arg_1:MovieClip):void
    {
        var _local_2:uint;
        var _local_3:MovieClip;
        var _local_4:Sprite;
        var _local_5:*;
        _local_2 = 0;
        for (;_local_2 < _arg_1.numChildren;_local_2++)
        {
            if ((_arg_1.getChildAt(_local_2) is MovieClip))
            {
                try
                {
                    _local_3 = (_arg_1.getChildAt(_local_2) as MovieClip);
                    if (_local_3.visible == false) continue;
                    _local_3.getChildAt(0).visible = false;
                    _local_4 = new Sprite();
                    _local_4.addChild(rasterizePart(_local_3.getChildAt(0)));
                    _local_5 = _local_3.addChildAt(_local_4, 0);
                    movieClipRasterizeInner((_arg_1.getChildAt(_local_2) as MovieClip));
                }
                catch(exception)
                {
                }
            }
        }
    }

    public function showPortrait(avt:Avatar):void {
        showPortraitBox(avt, ui.mcPortrait);
        world.updatePortrait(avt);
        ui.iconQuest.visible = true;
    }

    public function hidePortrait():void {
        ui.mcPortrait.visible = false;
        ui.iconQuest.visible = false;
    }

    public function showPortraitTarget(_arg_1:Avatar):* {
        showPortraitBox(Number(world.objExtra["bChar"]) == 1 ? world.myAvatar : _arg_1, ui.mcPortraitTarget);
        ui.mcPortraitTarget.pvpIcon.visible = world.bPvP;
        world.updatePortrait(_arg_1);
        ui.btnTargetPortraitClose.visible = true;
    }

    public function handleBranches(branches:Array, tree:Object, treeSetFunction:Function):void {
        for each (var branchA:Object in branches) {
            var unm:String = branchA.uoName;
            var uoLeaf:Object = {};

            for (var s:String in branchA) {
                var nam:String = s;
                var val:* = branchA[s];

                if (["int", "tx", "ty", "sp", "pvpTeam"].indexOf(nam.toLowerCase()) > -1) {
                    val = int(val);
                }

                uoLeaf[nam] = val;
            }

            if (unm != net.myUserName) {
                uoLeaf.auras = [];
            }

            uoLeaf.targets = {};
            treeSetFunction.call(world, unm, uoLeaf);
            world.manageAreaUser(unm, "+");
        }
    }

    public function hidePortraitTarget():void {
        ui.mcPortraitTarget.visible = false;
        ui.btnTargetPortraitClose.visible = false;
    }

    public function showPortraitBox(avt:Avatar, mcPortraitBox:MovieClip):void {
        mcPortraitBox.pAV = avt;
        mcPortraitBox.visible = true;
    }

    public function oniconQuestClick(event:MouseEvent):void {
        ui.mcQuestTracker.toggle();
    }

    public function oniconDeveloperClick(event:MouseEvent):void {
        mapBuilder.toggle();
    }

    public function updateXPBar():void {
        var _local_1:*;
        var _local_2:*;
        var _local_3:*;
        var _local_4:*;
        ui.mcInterface.mcXPBar.mcXP.scaleX = world.myAvatar.objData.intExp / world.myAvatar.objData.intExpToLevel;
        _local_1 = world.myAvatar.objData;
        _local_2 = _local_1.intExp;
        _local_3 = _local_1.intExpToLevel;
        _local_4 = int((_local_2 / _local_3) * 100);
        if (_local_4 >= 100) {
            _local_4 = 100;
        }
        ui.mcInterface.mcXPBar.strXP.text = (((((("Level " + world.myAvatar.objData.intLevel) + " : ") + _local_2) + " / ") + _local_3) + " (") + _local_4 + ")%";
    }

    public function xpBarMouseOver(_arg_1:MouseEvent):* {
        MovieClip(_arg_1.currentTarget).strXP.visible = true;
    }

    public function xpBarMouseOut(_arg_1:MouseEvent):* {
        MovieClip(_arg_1.currentTarget).strXP.visible = false;
    }

    public function actIconClick(_arg_1:MouseEvent):* {
        var _local_2:*;
        _local_2 = MovieClip(_arg_1.currentTarget).actObj;
        if (!(_local_2.auto == null) && _local_2.auto == true) {
            world.approachTarget();
        } else {
            world.testAction(_local_2);
        }
    }

    public function actIconTT(target:MovieClip, tooltip:MovieClip) : void
    {
        var _local_3:*;
        var _local_4:String;

        if (target.item == null) {
            _local_3 = target.actObj;
            if (_local_3 != null) {
                _local_4 = "<b>" + _local_3.nam + "</b>\n";
                if (!_local_3.isOK) {
                    _local_4 = _local_4 + ("<font color='#FF0000'>Unlocks at Rank " + ((target.actionIndex < 4) ? target.actionIndex : 5) + "!</font>\n");
                }
                if (_local_3.typ != "passive") {
                    if (_local_3.mp > 0) {
                        _local_4 = _local_4 + ("<font color='#0033AA'>" + _local_3.mp + "</font> mana, ");
                    }
                    _local_4 = _local_4 + (("<font color='#AA3300'>" + (_local_3.cd / 1000)) + "</font> sec cooldown" + "\n");
                }
                switch (_local_3.typ) {
                    case "p":
                    case "ph":
                    case "aa":
                        _local_4 = _local_4 + "Physical";
                        break;
                    case "m":
                        _local_4 = _local_4 + "Magical";
                        break;
                    case "ma":
                        _local_4 = _local_4 + "True Damage";
                        break;
                    case "mp":
                    case "pm":
                        _local_4 = _local_4 + " Hybried";
                        break;
                    case "passive":
                        _local_4 = _local_4 + "<font color='#0033AA'>Passive Ability</font>";
                        break;
                }
                _local_4 = _local_4 + "\n";
                if (_local_3.typ != "passive")
                {
                    if (_local_3.range <= 301)
                    {
                        _local_4 = (_local_4 + "A <font color='#AA3300'>short range</font> ");
                    }
                    else
                    {
                        if (_local_3.range >= 3000)
                        {
                            _local_4 = (_local_4 + "An <font color='#0033AA'>infinite range</font> ");
                        }
                        else
                        {
                            if (_local_3.range >= 808)
                            {
                                _local_4 = (_local_4 + "A <font color='#0033AA'>long range</font> ");
                            }
                            else
                            {
                                _local_4 = (_local_4 + "A <font color='#AA3300'>medium range</font> ");
                            }
                        }
                    }
                    if (!_local_3.damage)
                    {
                        _local_4 = (_local_4 + "status skill that applies to ");
                    }
                    else
                    {
                        _local_4 = (_local_4 + ((((_local_3.damage < 0) ? "skill" : "attack") + " that ") + ((_local_3.damage < 0) ? "heals " : "deals damage to ")));
                    }
                    if (_local_3.tgt == "f")
                    {
                        _local_4 = (_local_4 + ("<font color='#0033AA'>" + ((_local_3.tgtMax) || (1))));
                        _local_4 = (_local_4 + ((_local_3.tgtMax > 1) ? " friendly targets.</font>" : " target.</font>"));
                    }
                    else
                    {
                        if (_local_3.tgt == "s")
                        {
                            _local_4 = (_local_4 + "<font color='#0033AA'>yourself.</font>");
                        }
                        else
                        {
                            _local_4 = (_local_4 + ("<font color='#AA3300'>" + ((_local_3.tgtMax) || (1))));
                            _local_4 = (_local_4 + ((_local_3.tgtMax > 1) ? " hostile targets.</font>" : " target.</font>"));
                        }
                    }
                    _local_4 = (_local_4 + "\n\n");
                }
                if (_local_3.sArg2 != "") {
                    _local_4 = _local_4 + _local_3.sArg2;
                } else {
                    _local_4 = _local_4 + _local_3.desc;
                }

                tooltip.openWith(target.hasOwnProperty("isItemSkill") ? {"str": _local_4 } : {"str": _local_4, (target.hasOwnProperty("isCC") ? "lowerleft" : "lowerright"): true })
            }
        } else {
            tooltip.openWith(target.hasOwnProperty("isItemSkill") ? { "str": target.item.sName + "\n" + target.item.sDesc } : {"str": target.item.sName + "\n" + target.item.sDesc, (target.hasOwnProperty("isCC") ? "lowerleft" : "lowerright"): true });
        }
    }

    public function actIconOver(event:MouseEvent) : void {
        if (uoPref.bTT || !(world.myAvatar.dataLeaf.intState == 2)) {
            actIconTT(MovieClip(event.currentTarget), ui.ToolTip)
        }
    }

    public function actIconOut(_arg_1:MouseEvent) : void {
        ui.ToolTip.close();
    }

    public function portraitClick(event:MouseEvent):* {
        var o:Object = {};
        var target:MovieClip = MovieClip(event.currentTarget);

        if (target.pAV.npcType == "player") {
            o = {};
            o.ID = target.pAV.objData.CharID;
            o.strUsername = target.pAV.objData.strUsername;
            if (target.pAV != world.myAvatar) {
                ui.cMenu.fOpenWith("user", o);
            } else {
                ui.cMenu.fOpenWith("self", o);
            }
        }
        else if (target.pAV.npcType == "monster") {
            o = {};
            o.ID = target.pAV.objData.MonMapID;
            o.strUsername = target.pAV.objData.strMonName;
            o.target = world.getMonster(o.ID).pMC;
            ui.cMenu.fOpenWith("mons", o);
        }
//        else if (target.pAV.npcType == "npc")
//        {
//            o = {};
//            o.ID = target.pAV.objData.NpcMapID;
//            o.strUsername = target.pAV.objData.strMonName;
//            o.target = world.getNpc(o.ID).pMC;
//            ui.cMenu.fOpenWith("npcs", o);
//        }
    }

    private function onTargetPortraitCloseClick(_arg_1:MouseEvent):void {
        world.cancelTarget();
    }

    public function showMap():void {
        ui.mcInterface.mcMenu.mcMenuButtons.visible = true;
        ui.mcPopup.fOpen("Map");
    }

    public function logout():void {
        if (world != null) {
            world.exitCombat();
            world.setTarget(null);
            world.killTimers();
            world.killListeners();
            world.clearLoaders(true);

            try {
                world.removeChild(world.map);
            } catch(e:Error) {

            }

            removeChild(world);
            world = null;
        }

        SoundMixer.stopAll();
        firstMenu = true;

        if (net.isConnected) {
            net.close();
        }

        if (currentLabel != "Login") {
            musicChannel = backgroundMusic.play(0, int.MAX_VALUE);
//            mcLogin.gotoAndStop("Characters");
            gotoAndPlay("Login");
        }
    }

    public function showServerList():void {
        if (net.isConnected) {
            net.close()
        }

        login(loginInfo.strUsername, loginInfo.strPassword);
    }

    public function showUpgradeWindow(_arg_1:Object = null):void {
        var _local_2:MovieClip;
        if (mcUpgradeWindow == null) {
            mcUpgradeWindow = new MCUpgradeWindow();
        }
        _local_2 = (mcUpgradeWindow as MovieClip);
        var _local_3:* = _arg_1 != null ? _arg_1 : world.myAvatar.objData;
        _local_2.btnClose.addEventListener(MouseEvent.CLICK, hideUpgradeWindow, false, 0, true);
        _local_2.btnClose2.addEventListener(MouseEvent.CLICK, hideUpgradeWindow, false, 0, true);
        _local_2.btnBuy.addEventListener(MouseEvent.CLICK, onUpgradeClick, false, 0, true);
        addChild(mcUpgradeWindow);
        try {
            ui.mouseChildren = false;
            world.mouseChildren = false;
        } catch (e:Error) {
        }
        try {
            mcLogin.sl.mouseChildren = false;
        } catch (e:Error) {
        }
    }

    public function hideUpgradeWindow(_arg_1:MouseEvent):void {
        removeChild(mcUpgradeWindow);
        try {
            ui.mouseChildren = true;
            world.mouseChildren = true;
        } catch (e:Error) {
        }
        try {
            mcLogin.sl.mouseChildren = true;
        } catch (e:Error) {
        }
    }

    public function onUpgradeClick(_arg_1:Event):void {
        var _local_2:String;
        mixer.playSound("Click");
        _local_2 = ("https://www.aq.com/order-now/direct/default.asp?cid=" + world.myAvatar.objData.CharID) + "&token=" + loginInfo.strToken;
        navigateToURL(new URLRequest(_local_2), "_blank");
    }

    public function showACWindow():void {
        var _local_1:MovieClip;
        if (mcACWindow == null) {
            mcACWindow = new MCACWindow();
        }
        _local_1 = (mcACWindow as MovieClip);
        _local_1.btnClose.addEventListener(MouseEvent.CLICK, hideACWindow, false, 0, true);
        _local_1.btnClose2.addEventListener(MouseEvent.CLICK, hideACWindow, false, 0, true);
        _local_1.btnBuy.addEventListener(MouseEvent.CLICK, onUpgradeClick, false, 0, true);
        _local_1.btnUpgrade.addEventListener(MouseEvent.CLICK, onUpgradeClick, false, 0, true);
        addChild(mcACWindow);
        try {
            ui.mouseChildren = false;
            world.mouseChildren = false;
        } catch (e:Error) {
        }
        try {
            mcLogin.sl.mouseChildren = false;
        } catch (e:Error) {
        }
    }

    public function hideACWindow(_arg_1:MouseEvent):void {
        removeChild(mcACWindow);
        try {
            ui.mouseChildren = true;
            world.mouseChildren = true;
        } catch (e:Error) {
        }
        try {
            mcLogin.sl.mouseChildren = true;
        } catch (e:Error) {
        }
    }

    public function initArrHP():void {
        var _local_1:int;
        var _local_2:int;
        var _local_3:int;
        var _local_4:Number;
        var _local_5:int;
        var _local_6:int;
        var _local_7:Number;
        var _local_8:int;
        var _local_9:int;
        var _local_10:Number;
        var _local_11:*;
        _local_1 = 100;
        _local_2 = 550;
        _local_3 = 275;
        _local_4 = 0.8;
        _local_5 = 720;
        _local_6 = 200;
        _local_7 = 0.92;
        _local_8 = 350;
        _local_9 = 3650;
        _local_10 = 1.1;
        _local_11 = 0;
        while (_local_11 < _local_1) {
            if (_local_11 > 19) {
                arrHP.push(Math.round(_local_8 + Math.pow(_local_11 / _local_1, _local_10) * _local_9));
            } else {
                if (_local_11 > 7) {
                    arrHP.push(Math.round(_local_5 + Math.pow(_local_11 / 20, _local_7) * _local_6));
                } else {
                    arrHP.push(Math.round(_local_2 + Math.pow(_local_11 / 8, _local_4) * _local_3));
                }
            }
            _local_11++;
        }
    }

    public function initArrRep():void {
        var _local_1:int;
        var _local_2:*;
        _local_1 = 0;
        _local_2 = 1;
        while (_local_2 < statsController.intMaxReputationRank) {
            _local_1 = Math.pow(_local_2 + 1, 3) * 100;
            if (_local_2 > 1) {
                arrRanks.push(_local_1 + arrRanks[(_local_2 - 1)]);
            } else {
                arrRanks.push(_local_1 + 100);
            }
            _local_2++;
        }
    }

    public function getRankFromPoints(_arg_1:int):int {
        var _local_2:int;
        var _local_3:*;
        _local_2 = 1;
        if (_arg_1 < 0) {
            _arg_1 = 0;
        }
        _local_3 = 1;
        while (_local_3 < arrRanks.length) {
            if (_arg_1 < arrRanks[_local_3]) {
                return _local_2;
            }
            _local_2++;
            _local_3++;
        }
        return _local_2;
    }

    public function attachOnModalStack(linkage:String):MovieClip {
        var mc:MovieClip;
        var AssetClass:Class = (world.getClass(linkage) as Class);
        var isValid:Boolean = true;

        if (ui.ModalStack.numChildren) {
            mc = MovieClip(ui.ModalStack.getChildAt(0));
            if ((mc.constructor as Class) == AssetClass) {
                isValid = false;
            }
        }

        if (isValid) {
            clearModalStack();
            mc = MovieClip(ui.ModalStack.addChild(new AssetClass()));
            ui.ModalStack.mouseChildren = true;
        }

        return mc;
    }

    public function getInstanceFromModalStack(_arg_1:String):MovieClip {
        var _local_2:int;
        _local_2 = 0;
        while (_local_2 < ui.ModalStack.numChildren) {
            if (getQualifiedClassName(ui.ModalStack.getChildAt(_local_2) == _arg_1)) {
                return ui.ModalStack.getChildAt(_local_2);
            }
            _local_2++;
        }
        return null;
    }

    public function isDialoqueUp():Boolean {
        var _local_1:int;
        var _local_2:*;
        var _local_3:*;
        _local_1 = 0;
        while (_local_1 < world.FG.numChildren) {
            _local_2 = world.FG.getChildAt(_local_1);
            _local_3 = String(_local_2 as MovieClip);
            if (_local_3.indexOf("dlg_") > -1) {
                return true;
            }
            _local_1++;
        }
        return false;
    }

    public function clearModalStack():Boolean {
        var _local_1:int;
        if (isGreedyModalInStack()) {
            return false;
        }
        _local_1 = 0;
        while (ui.ModalStack.numChildren > 0 && _local_1 < 100) {
            _local_1++;
            ui.ModalStack.removeChildAt(0);
        }
        stage.focus = null;
        return true;
    }

    public function closeModalByStrBody(_arg_1:String):void {
        var _local_2:int;
        var _local_3:MovieClip;
        _local_2 = 0;
        _local_2 = 0;
        while (_local_2 < ui.ModalStack.numChildren) {
            _local_3 = (ui.ModalStack.getChildAt(_local_2) as MovieClip);
            if (_local_3.cnt.strBody.htmlText.indexOf(_arg_1) > -1 && !(_local_3.currentLabel == "out")) {
                _local_3.fClose();
            }
            _local_2++;
        }
    }

    public function isGreedyModalInStack():Boolean {
        var i:int = 0;
        var mc:MovieClip;

        while (i < ui.ModalStack.numChildren) {
            mc = (ui.ModalStack.getChildAt(i) as MovieClip);
            if ("greedy" in mc && !(mc.greedy == null) && mc.greedy) {
                return true;
            }
            i++;
        }

        return false;
    }

    public function hexToColorTransform(hex:uint):ColorTransform {
        var red:uint = (hex >> 16) & 0xFF;
        var green:uint = (hex >> 8) & 0xFF;
        var blue:uint = hex & 0xFF;

        var colorTransform:ColorTransform = new ColorTransform();
        colorTransform.redMultiplier = red / 255;
        colorTransform.greenMultiplier = green / 255;
        colorTransform.blueMultiplier = blue / 255;

        return colorTransform;
    }

    public function clearPopups(_arg_1:Array = null):void {
        if (ui.mcPopup.currentLabel == "House") {
            ui.mcPopup.mcHouseMenu.hideItemHandle();
        }
        if (_arg_1 == null || _arg_1.indexOf(ui.mcPopup.currentLabel) < 0) {
            ui.mcPopup.onClose();
        }
        world.removeMovieFront();
        clearModalStack();
    }

    public function clearPopupsQ():void {
        if (!(ui.mcPopup.currentLabel == "House") && !(ui.mcPopup.currentLabel == "HouseShop")) {
            ui.mcPopup.onClose();
        }
    }

    public function addUpdate(_arg_1:String, _arg_2:Boolean = false):void {
        var _local_3:MovieClip;
        var _local_4:MovieClip;
        var _local_5:int;
        _local_3 = ui.mcUpdates;
        _local_4 = (_local_3.addChildAt(new uProto(), 1) as MovieClip);
        _local_4.y = 0;
        _local_4.x = _local_3.uproto.x;
        _local_4.t1.ti.htmlText = _arg_1;
        if (_arg_2) {
            _local_4.t1.ti.textColor = 0xFF0000;
        }
        _local_4.gotoAndPlay("in");
        _local_5 = 2;
        if (_local_3.numChildren > 2) {
            _local_5 = 2;
            while (_local_5 < _local_3.numChildren) {
                if (_local_5 < 4) {
                    _local_3.getChildAt(_local_5).y = _local_3.getChildAt(_local_5).y - 18;
                } else {
                    MovieClip(_local_3.getChildAt(_local_5)).stop();
                    _local_3.removeChildAt(_local_5);
                    _local_5--;
                }
                _local_5++;
            }
        }
    }

    public function clearUpdates():void {
        var _local_1:MovieClip;
        _local_1 = ui.mcUpdates;
        while (_local_1.numChildren > 1) {
            _local_1.removeChildAt(1);
        }
    }

    public function showItemDrop(fData:Object, _arg_2:Boolean):void {
        var drop:Object = world.getDropItem(fData.ItemID);
        var name:String = fData.sName;
        var mc:MovieClip = getDropStack(name);

        if (drop != null && mc != null && fData.iStk > 1)
        {
            mc.cnt.strName.text = drop.sName + " x" + drop.iQty;
        }
        else
        {
            mc = fData.bTemp != 0 || !_arg_2 ? new DFrameMC(fData) : new DFrame2MC(fData);
            mc.name = name;
            ui.dropStack.addChild(mc);
            mc.init();
            mc.fY = (mc.y = -(mc.fHeight + 8));
            mc.fX = (mc.x = -(mc.fWidth / 2));
            cleanDropStack();
        }
    }

    public function getDropStack(name:String) : DFrame2MC
    {
        for (var i:int = 0; i < ui.dropStack.numChildren; i++)
        {
            var target:DisplayObject = ui.dropStack.getChildAt(i);

            if (target is DFrame2MC && target.name == name)
            {
                return target as DFrame2MC;
            }
        }

        return null;
    }

    public function cleanDropStack():void {
        var _local_1:MovieClip;
        var _local_2:MovieClip;
        var _local_3:*;
        _local_1 = null;
        _local_2 = null;
        _local_3 = ui.dropStack.numChildren - 2;
        while (_local_3 > -1) {
            _local_1 = (ui.dropStack.getChildAt(_local_3) as MovieClip);
            _local_2 = (ui.dropStack.getChildAt(_local_3 + 1) as MovieClip);
            _local_1.fY = (_local_1.y = _local_2.fY - (_local_2.fHeight + 8));
            _local_3--;
        }
    }

    public function dropStackBoost():void {
        ui.dropStack.y = 438;
    }

    public function dropStackReset():void {
        ui.dropStack.y = 493;
    }

    public function showAchievement(title:String, points:int):void {
        var achievement:mcAchievement;
        var mc:MovieClip;
        achievement = new mcAchievement();
        mc = (ui.dropStack.addChild(achievement) as MovieClip);
        mc.cnt.tBody.text = title;
        mc.cnt.tPts.text = points < 0 ? points : "";
        mc.fWidth = 348;
        mc.fHeight = 90;
        mc.fX = (mc.x = -(mc.fWidth / 2));
        mc.fY = (mc.y = -(mc.fHeight + 8));
        cleanDropStack();
    }

    public function showQuestpopup(o:Object):void {
        var strText:String = "";
        var questPopup:MovieClip = ui.dropStack.addChild(new mcQuestpopup()) as MovieClip;
        questPopup.cnt.mcAC.visible = false;
        questPopup.cnt.tName.text = o.Name;
        questPopup.cnt.rewards.tRewards.htmlText = "";

        if (o.hasOwnProperty("Copper") && o.Gold > 0) strText += "<font color='#FFFFFF'>" + o.Copper + "</font><font color='#FFCC00'>copper</font>";
        if (o.hasOwnProperty("Silver") && o.Silver > 0) strText += (strText.length > 0 ? "<font color='#FFFFFF'>, </font>" : "") + "<font color='#FFFFFF'>" + o.Silver + "</font><font color='#FF00FF'>silver</font>";
        if (o.hasOwnProperty("Gold") && o.Gold > 0) strText += (strText.length > 0 ? "<font color='#FFFFFF'>, </font>" : "") + "<font color='#FFFFFF'>" + o.Gold + "</font><font color='#FF00FF'>gold</font>";
        if (o.hasOwnProperty("Exp") && o.Exp > 0) strText += (strText.length > 0 ? "<font color='#FFFFFF'>, </font>" : "") + "<font color='#FFFFFF'>" + o.Exp + "</font><font color='#FF00FF'>xp</font>";
        if (o.hasOwnProperty("Rep") && o.Rep > 0) strText += (strText.length > 0 ? "<font color='#FFFFFF'>, </font>" : "") + "<font color='#FFFFFF'>" + o.Rep + "</font><font color='#00CCFF'>rep</font>";

        questPopup.cnt.rewards.tRewards.htmlText = strText;
        questPopup.fWidth = 240;
        questPopup.fHeight = 70;
        questPopup.cnt.rewards.x = Math.round(questPopup.fWidth / 2 - (questPopup.cnt.rewards.tRewards.x + questPopup.cnt.rewards.tRewards.textWidth) / 2);
        questPopup.fX = (questPopup.x = -(questPopup.fWidth / 2));
        questPopup.fY = (questPopup.y = -(questPopup.fHeight + 8));

        mixer.playSound("Good");
        cleanDropStack();
    }

    public function togglePopup(label:String = "") : void {
        var popup:MovieClip = ui.mcPopup;

        if (!isGreedyModalInStack())
        {
            if (popup.currentLabel != label)
            {
                clearPopups();
                clearPopupsQ();
                popup.fData = {"typ": label};
                popup.visible = true;
                popup.gotoAndPlay(label);
            }
            else
            {
                popup.onClose();
            }
        }
    }

    public function toggleOutfit(_arg_1:String = ""):void {
        var _local_2:MovieClip;
        _local_2 = ui.mcPopup;
        if (!isGreedyModalInStack()) {
            if (_local_2.currentLabel != "Outfit") {
                clearPopups();
                clearPopupsQ();
                _local_2.fData = {"typ": _arg_1};
                _local_2.visible = true;
                _local_2.gotoAndPlay("Outfit");
            } else {
                _local_2.fClose();
            }
        }
    }

    public function toggleStatsPanel(_arg_1:String = ""):void {
        var _local_2:MovieClip;
        _local_2 = ui.mcPopup;
        if (!isGreedyModalInStack()) {
            if (_local_2.currentLabel != "Stats") {
                clearPopups();
                clearPopupsQ();
                _local_2.fData = {"typ": _arg_1};
                _local_2.visible = true;
                _local_2.gotoAndPlay("Stats");
            } else {
                _local_2.fClose();
            }
        }
    }

    public function toggleCharStatspanel():void
    {
        if (ui.getChildByName("mcStatsPanel"))
        {
            mcStatsPanel.cleanup();
            mcStatsPanel = null;
            return;
        }

        mcStatsPanel = new Stats();
        ui.addChild(mcStatsPanel);
        mcStatsPanel.name = "mcStatsPanel";
        mcStatsPanel.x = 63.15;
        mcStatsPanel.y = 21.9;
    }

    public function toggleOption(_arg_1:String = ""):void {
        var _local_2:MovieClip;
        _local_2 = ui.mcPopup;
        if (!isGreedyModalInStack()) {
            if (_local_2.currentLabel != "Option") {
                clearPopups();
                clearPopupsQ();
                _local_2.fData = {"typ": _arg_1};
                _local_2.visible = true;
                _local_2.gotoAndPlay("Option");
            } else {
                _local_2.mcCharpanel.fClose();
            }
        }
    }

    public function toggleTrade(tradeId:String = "-1"):void
    {
        var popup:MovieClip = ui.mcPopup;

        if (!isGreedyModalInStack())
        {
            if (popup.currentLabel != "Trade")
            {
                clearPopups();
                clearPopupsQ();
                world.tradeController.tradeId = tradeId;
                popup.visible = true;
                popup.gotoAndPlay("Trade");
            }
            else
            {
                popup.onClose();
            }
        }
    }

    public function toggleBuySlots(_arg_1:String = ""):void {
        var _local_2:MovieClip;
        _local_2 = ui.mcPopup;
        if (!isGreedyModalInStack()) {
            if (_local_2.currentLabel != "BuySlots") {
                clearPopups();
                clearPopupsQ();
                _local_2.fData = {"typ": _arg_1};
                _local_2.visible = true;
                _local_2.gotoAndPlay("BuySlots");
            } else {
                _local_2.mcBuySlots.fClose();
            }
        }
    }

    public function togglePVPPanel(_arg_1:String = ""):void {
        var _local_2:MovieClip;
        _local_2 = ui.mcPopup;
        if (!isGreedyModalInStack()) {
            if (_local_2.currentLabel != "PVPPanel") {
                clearPopups();
                clearPopupsQ();
                _local_2.fData = {"typ": _arg_1};
                _local_2.visible = true;
                _local_2.gotoAndPlay("PVPPanel");
            } else {
                _local_2.onClose();
            }
        }
    }

    public function togglePanel(tab:String = "friends"):void {
        var _local_2:MovieClip;
        _local_2 = ui.mcPopup;
        if (!isGreedyModalInStack()) {
            if (_local_2.currentLabel != "Panel") {
                clearPopups();
                clearPopupsQ();
                _local_2.fData = {
                    "tab": tab
                };
                _local_2.visible = true;
                _local_2.gotoAndPlay("Panel");
            } else {
                _local_2.mcCharpanel.fClose();
            }
        }
    }

    public function toggleWheel(_arg_1:String = ""):void {
        var _local_2:MovieClip;
        _local_2 = ui.mcPopup;
        if (!isGreedyModalInStack()) {
            if (_local_2.currentLabel != "Wheel") {
                clearPopups();
                clearPopupsQ();
                _local_2.fData = {"typ": _arg_1};
                _local_2.visible = true;
                _local_2.gotoAndPlay("Wheel");
            } else {
                _local_2.onClose();
            }
        }
    }

    public function togglePetPanel():void {
        if (!world.uiLock) {
            if (ui.mcPopup.currentLabel == "PetPanel") {
                MovieClip(ui.mcPopup.getChildByName("mcPetPanel")).fClose();
            } else {
                ui.mcPopup.fOpen("PetPanel");
            }

        }

    }

    public function toggleInventoryOutfitPanel():void {
        if (!world.uiLock) {
            if (ui.mcPopup.currentLabel == "OutfitInventory") {
                MovieClip(ui.mcPopup.getChildByName("mcOutfitInventory")).fClose();
            } else {
                ui.mcPopup.fOpen("OutfitInventory");
            }
        }
    }

    public function showPVPScore():void {
        var bar:MovieClip;
        var i:int;
        var o:Object;
        var a:Array;
        var bx:int;
        ui.mcPVPScore.visible = true;
        ui.mcPVPScore.y = 2;
        i = 0;
        a = [{"sName": "Team A"}, {"sName": "Team B"}];
        bx = 200;
        if (world.PVPFactions.length > 0) {
            a = world.PVPFactions;
        }
        i = 0;
        while (i < a.length) {
            o = a[i];
            try {
                bar = ui.mcPVPScore.getChildByName("bar" + i);
                bar.tTeam.text = o.sName;
                if ((bar.tTeam.x + bar.tTeam.width) - bar.tTeam.textWidth - 6 < bx) {
                    bx = Math.round((bar.tTeam.x + bar.tTeam.width) - bar.tTeam.textWidth - 6);
                }
            } catch (e:Error) {
                trace("*** >");
                trace("*** > PvP Faction data could not be found or set.");
                trace("*** >");
            }
            i = i + 1;
        }
        i = 0;
        while (i < a.length) {
            o = a[i];
            try {
                bar = ui.mcPVPScore.getChildByName("bar" + i);
                bar.cap.x = bx;
            } catch (e:Error) {
            }
            i = i + 1;
        }
    }

    public function hidePVPScore():void {
        ui.mcPVPScore.visible = false;
        ui.mcPVPScore.y = -300;
    }

    public function showMCPVPQueue():void {
        var _local_1:Object;
        _local_1 = world.getWarzoneByWarzoneName(world.PVPQueue.warzone);
        ui.mcPVPQueue.t1.text = _local_1.nam;
        ui.mcPVPQueue.removeEventListener(Event.ENTER_FRAME, MCPVPQueueEF);
        ui.mcPVPQueue.t2label.visible = false;
        ui.mcPVPQueue.t2.visible = false;
        if (world.PVPQueue.avgWait > -1) {
            ui.mcPVPQueue.t2label.visible = true;
            ui.mcPVPQueue.t2.visible = true;
            ui.mcPVPQueue.addEventListener(Event.ENTER_FRAME, MCPVPQueueEF, false, 0, true);
        }
        ui.mcPVPQueue.visible = true;
        ui.mcPVPQueue.y = 84;
    }

    public function hideMCPVPQueue():void {
        ui.mcPVPQueue.removeEventListener(Event.ENTER_FRAME, MCPVPQueueEF);
        ui.mcPVPQueue.visible = false;
        ui.mcPVPQueue.y = -300;
    }

    public function onMCPVPQueueClick(_arg_1:MouseEvent):void {
        var _local_2:*;
        _local_2 = {};
        try {
            _local_2.strUsername = world.myAvatar.objData.strUsername;
            ui.cMenu.fOpenWith("pvpqueue", _local_2);
        } catch (e:Error) {
        }
    }

    public function MCPVPQueueEF(_arg_1:Event):void {
        var _local_2:Number;
        var _local_3:*;
        _local_2 = new Date().getTime();
        _local_3 = Math.ceil((world.PVPQueue.avgWait * 1000 - (_local_2 - world.PVPQueue.ts)) / 1000 / 60);
        ui.mcPVPQueue.t2.htmlText = '<font color="#FFFFFF"' + _local_3 + '</font><font color="#999999"m</font>';
        if (_local_3 <= 1) {
            ui.mcPVPQueue.t2.htmlText = "<" + ui.mcPVPQueue.t2.htmlText;
        }
    }

    public function updatePVPScore(_arg_1:Array):void {
        var _local_2:Object;
        var _local_3:MovieClip;
        var _local_4:int;
        var _local_5:int;
        _local_2 = {};
        _local_4 = 0;
        while (_local_4 < _arg_1.length) {
            _local_2 = _arg_1[_local_4];
            _local_3 = (ui.mcPVPScore.getChildByName("bar" + _local_4) as MovieClip);
            if (_local_3 != null) {
                _local_3.ti.text = _local_2.v + "/1000";
                _local_5 = int(int((_local_2.v / 1000) * _local_3.bar.width));
                _local_5 = Math.max(Math.min(_local_5, _local_3.bar.width), 0);
                _local_3.bar.x = -_local_3.bar.width + _local_5;
            }
            _local_4++;
        }
    }

    public function relayPVPEvent(_arg_1:Object):void {
        if (_arg_1.typ == "kill") {
            if (_arg_1.team == world.myAvatar.dataLeaf.pvpTeam) {
                if (_arg_1.val == "Restorer") {
                    addUpdate(getPVPMessage(_arg_1.val, true));
                }
                if (_arg_1.val == "Brawler") {
                    addUpdate(getPVPMessage(_arg_1.val, true));
                }
                if (_arg_1.val == "Captain") {
                    addUpdate(getPVPMessage(_arg_1.val, true));
                }
                if (_arg_1.val == "General") {
                    addUpdate("Victory! The enemy general has been defeated!");
                }
                if (_arg_1.val == "Knight") {
                    addUpdate("A knight of the enemy has fallen! Victory draws closer!");
                }
            } else {
                if (_arg_1.val == "Restorer") {
                    addUpdate(getPVPMessage(_arg_1.val, false), true);
                }
                if (_arg_1.val == "Brawler") {
                    addUpdate(getPVPMessage(_arg_1.val, false), true);
                }
                if (_arg_1.val == "Captain") {
                    addUpdate(getPVPMessage(_arg_1.val, false), true);
                }
                if (_arg_1.val == "General") {
                    addUpdate("Oh no!  Our general has been defeated!", true);
                }
                if (_arg_1.val == "Knight") {
                    addUpdate("A knight has fallen to the enemy!");
                }
            }
        }
    }

    private function getPVPMessage(_arg_1:String, _arg_2:Boolean):String {
        switch (_arg_1) {
            case "Restorer":
                if (_arg_2) {
                    return world.strMapName == "dagepvp" ? "An enemy Blade Master has been defeated! Dage's healing powers are waning!" : "An enemy Restorer has been defeated! The Captain's healing powers are waning!";
                } else {
                    return world.strMapName == "dagepvp" ? "A Blade Master has been defeated!\t Dage's healing powers are waning!" : "A Restorer has been defeated!\t Our Captain's healing powers are waning!";
                }
            case "Brawler":
                if (_arg_2) {
                    return world.strMapName == "dagepvp" ? "An enemy Legion Guard has been defeated!  Dage's attacks grow weaker!" : "An enemy Brawler has been defeated!  The Captain's attacks grow weaker!";
                } else {
                    return world.strMapName == "dagepvp" ? "A Legion Guard has been defeated!\tRally to Dage's defense!" : "A Brawler has been defeated!\tRally to the Captain's defense!";
                }
            case "Captain":
                if (_arg_2) {
                    return world.strMapName == "dagepvp" ? "Dage has been defeated!" : "The enemy captain has been defeated!";
                } else {
                    return world.strMapName == "dagepvp" ? "Dage has been fallen to the enemy!" : "Our Captain has been fallen to the enemy!";
                }
        }
        return "";
    }

    public function mcSetColor(_arg_1:MovieClip, _arg_2:String, _arg_3:String):* {
        var _local_4:MovieClip;
        var _local_6:String;
        _local_4 = _arg_1;
        var _local_5:Boolean;
        _local_6 = "none";
        while (!(_local_4 == null) && !(_local_4.parent == null) && !(_local_4.parent == _local_4.stage)) {
            if ("pAV" in _local_4) {
                if (_local_4.name.indexOf("previewMC") > -1) {
                    _local_6 = "e";
                } else {
                    if (_local_4.name.indexOf("Dummy") > -1) {
                        _local_6 = "d";
                    } else {
                        if (_local_4.name.indexOf("mcPortraitTarget") > -1) {
                            _local_6 = "c";
                        } else {
                            if (_local_4.name.indexOf("mcPortrait") > -1) {
                                _local_6 = "b";
                            } else {
                                _local_6 = "a";
                            }
                        }
                    }
                }
                break;
            }
            _local_4 = MovieClip(_local_4.parent);
        }
        if (_local_6 != "none") {
            _local_4.pAV.pMC.setColor(_arg_1, _local_6, _arg_2, _arg_3);
        }
    }

    public function areaListClick(_arg_1:MouseEvent):void {
        var _local_2:*;
        _local_2 = MovieClip(_arg_1.currentTarget.parent.parent);
        switch (_local_2.currentLabel) {
            case "init":
                _local_2.gotoAndPlay("in");
                return;
            case "hold":
                _local_2.gotoAndPlay("out");
                return;
        }
    }

    public function updateAreaName():void {
        var _local_1:String;
        _local_1 = String(world.areaUsers.length) + " player";
        if (world.areaUsers.length > 1) {
            _local_1 = _local_1 + "(s)";
        }

        _local_1 = _local_1 + " in <font color ='#FFFF00'>";
        if (world.strAreaName.indexOf(":") > -1) {
            _local_1 = _local_1 + (world.strAreaName.split(":")[0] + " (party)");
        } else {
            _local_1 = _local_1 + world.strAreaName;
        }

        _local_1 = _local_1 + "</font>";
        ui.mcInterface.areaList.title.t1.htmlText = _local_1;
    }

    public function areaListGet():void {
        var _local_1:Object = {};
        var _local_2:Array = net.room.getUserList();
        var _local_3:String;
        var _local_4:*;
        for (var _local_7:* in _local_2) {
            _local_3 = _local_7;
            _local_4 = world.uoTree[_local_2[_local_3].getName()];
            if (_local_4 != null) {
                _local_1[_local_3] = {
                    "strUsername": _local_4.strUsername,
                    "intLevel": _local_4.intLevel
                };
            }
        }
        areaListShow(_local_1);
    }

    public function areaListNameClick(_arg_1:MouseEvent):void {
        var _local_2:*;
        var _local_3:*;
        _local_2 = MovieClip(_arg_1.currentTarget);
        _local_3 = {};
        _local_3.ID = _local_2.objData.ID;
        _local_3.strUsername = _local_2.objData.strUsername;
        if (_local_2.objData.strUsername == world.myAvatar.objData.strUsername) {
            ui.cMenu.fOpenWith("self", _local_3);
        } else {
            ui.cMenu.fOpenWith("user", _local_3);
        }
    }

    public function areaListShow(_arg_1:Object):void {
        var _local_2:MovieClip;
        var _local_3:int;
        var _local_4:String;
        var _local_5:*;
        _local_2 = ui.mcInterface.areaList;
        _local_3 = 0;
        for (var _local_8:* in _arg_1) {
            _local_4 = _local_8;
            _local_8;
            _local_5 = _local_2.cnt.addChild(new aProto());
            _local_5.objData = _arg_1[_local_4];
            _local_5.txtName.text = _arg_1[_local_4].strUsername;
            _local_5.txtLevel.text = _arg_1[_local_4].intLevel;
            _local_5.addEventListener(MouseEvent.CLICK, areaListNameClick, false, 0, true);
            _local_5.buttonMode = true;
            _local_5.y = -int(_local_3 * 14);
            _local_3++;
        }
        _local_2.cnt.iproto.visible = false;
        _local_2.visible = true;
    }

    public function closeFBC():void {
        trace("closeFBC()");
        if (fbc != null) {
            fbc.fClose();
        }
    }

    public function getUserName():String {
        if ((!(world == null)) && (!(world.myAvatar == null)) && !(world.myAvatar.objData == null) && "strUserName" in world.myAvatar.objData) {
            return world.myAvatar.objData.strUserName;
        }
        return "";
    }

    public function hideInterface():void {
        ui.visible = false;
    }

    public function showInterface():void {
        ui.visible = true;
    }

    public function loadExternalSWF(_arg_1:String):void {
        ldrMC.loadFile(mcExtSWF, _arg_1, "Game Files");
        hideInterface();
        world.visible = false;
    }

    public function clearExternamSWF():void {
        while (mcExtSWF.numChildren > 0) {
            mcExtSWF.removeChildAt(0);
        }
        world.visible = true;
        showInterface();
    }

    public function openCharacterCustomize():void {
        ui.mcPopup.fOpen("Customize");
    }

    public function openArmorCustomize():void {
        ui.mcPopup.fOpen("ArmorColor");
    }

    public function showConfirmtaionBox(sMsg:String, fHandler:Function):void {
        var modal:* = undefined;
        var modalO:* = undefined;
        modal = new ModalMC();
        modalO = {};
        modalO.strBody = sMsg;
        modalO.btns = "dual";
        modalO.params = {};
        modalO.callback = function (_arg_1:Object):* {
            fHandler(_arg_1.accept);
        };
        ui.ModalStack.addChild(modal);
        modal.init(modalO);
    }

    public function showMessageBox(sMsg:String, fHandler:Function = null):void {
        var modal:* = undefined;
        var modalO:* = undefined;
        modal = new ModalMC();
        modalO = {};
        modalO.strBody = sMsg;
        modalO.btns = "mono";
        modalO.params = {};
        modalO.callback = function (_arg_1:Object):* {
            if (fHandler != null) {
                fHandler();
            }
        };
        ui.ModalStack.addChild(modal);
        modal.init(modalO);
    }

    public function getServerTime():Date {
        var _local_1:Date;
        var _local_2:*;
        _local_1 = new Date();
        _local_2 = ts_login_server + (_local_1.getTime() - ts_login_client);
        return new Date(_local_2);
    }

    public function get date_server():Date {
        return getServerTime();
    }

    public function isObjectEmpty(obj:Object):Boolean {
        var typeInfo:XML = describeType(obj);
        return typeInfo.children().length() == 0;
    }

    public function rand(_arg_1:Number = 0, _arg_2:Number = 1):Number {
        return rn.rand(_arg_1, _arg_2);
    }

    public function get TravelMap():Object {
        return travelMapData;
    }

    public function get objWorldMap():* {
        return WorldMapData;
    }

    public function getLogin():Object {
        return objLogin;
    }

    public function get characters():Array {
        return _characters;
    }

    public function set characters(newChars:Array):void {
        _characters = newChars;
    }

    public function removeChildrenByName(container:DisplayObjectContainer, name:String):void {
        var numChildrens:int = container.numChildren;
        for (var i:int = numChildren - 1; i >= 0; i--) {
            var child:DisplayObject = container.getChildAt(i);
            if (child.name == name) {
                container.removeChild(child);
            }
        }
    }

    public function removeChildrenByNames(parent:DisplayObjectContainer, childNames:Array):void {
        var numChildren:int = parent.numChildren;
        var childrenToRemove:Array = [];

        for (var i:int = 0; i < numChildren; i++) {
            var child:DisplayObject = parent.getChildAt(i);

            if (childNames.indexOf(child.name) !== -1) {
                childrenToRemove.push(child);
            }
        }

        for each (var childToRemove:DisplayObject in childrenToRemove) {
            parent.removeChild(childToRemove);
        }
    }

    public function objectToArray(obj:Object):Array {
        var array:Array = [];

        for each (var value:* in obj) {
            array.push(value);
        }

        return array;
    }

    public function statFixValues(typ:String, val:Number):Array
    {
        var template:Array = [((((typ == "$chi") || (typ == "$cmc")) || (typ == "$tha")) ? coeffToPct(val) : coeffToPct((val - 1)))];
        switch (typ)
        {
            case "$cai":
                template[0] = (template[0] * -1);
                return ((val <= 0.2) ? [coeffToPct((1 - 0.2)), "*"] : template);
            case "$cao":
                return ((val <= 0.1) ? [coeffToPct((0.1 - 1)), "*"] : template);
            case "$tha":
                return ((val >= 0.5) ? [coeffToPct((1 - 0.5)), "*"] : template);
            case "$cpi":
                template[0] = (template[0] * -1);
                return ((val <= 0.2) ? [coeffToPct((1 - 0.2)), "*"] : template);
            case "$cmi":
                template[0] = (template[0] * -1);
                return ((val <= 0.2) ? [coeffToPct((1 - 0.2)), "*"] : template);
            case "$cmo":
                return ((val <= 0.2) ? [coeffToPct((1 - 0.1)), "*"] : template);
            case "$cdi":
                template[0] = (template[0] * -1);
                return (template);
        }
        return (template);
    }

    public function Modal(strBody:String, callback:Function, params:Object, glow:String = null, btns:String = "dual", greedy:Boolean = false, qtySel:Object = null) : void
    {
        var modal:ModalMC = new ModalMC();
        var modalO:Object = {};
        modalO.strBody = strBody;
        modalO.callback = callback;
        modalO.params = params;
        if (glow != null) modalO.glow = glow;
        modalO.btns = btns;
        modalO.greedy = greedy;
        if (qtySel != null) modalO.qtySel = qtySel;
        ui.ModalStack.addChild(modal);
        modal.init(modalO);
    }

    public function DictRemoveFirst(dict:Dictionary) : void {
        for (var s:String in dict)
        {
            delete dict[s];
            break;
        }
    }

    public function RefreshLootCount() : void {
        if (world.dropMenu == null || world.dropMenu.length < 1)
        {
            ui.mcInterface.mcMenu.tLootCount.visible = false;
			ui.mcInterface.mcMenu.mcLootContainer.visible = false;
        }
        else
        {
            ui.mcInterface.mcMenu.tLootCount.visible = true;
			ui.mcInterface.mcMenu.mcLootContainer.visible = true;
            ui.mcInterface.mcMenu.tLootCount.text = world.dropMenu.length;
        }
    }

    public function btnFloorReward(event:MouseEvent) : void
    {
        if (floorReward != null)
        {
            floorReward.visible = !floorReward.visible;

            var btnFloorReward:mcButton = ui.getChildByName("btnFloorReward") as mcButton;
            if (btnFloorReward != null) btnFloorReward.visible = !floorReward.visible;
        }
    }

    public function destroyFloorReward() : void {
        var btnFloorReward:mcButton = ui.getChildByName("btnFloorReward") as mcButton;

        ui.removeChild(btnFloorReward);
        ui.removeChild(floorReward);
        ui.mcPvEDuration.close();
    }

    public function generateUniqueID():String {
        var timestamp:String = new Date().time.toString();
        var randomPart:String = Math.floor(Math.random() * 100000000).toString();
        return timestamp + "%" + randomPart;
    }

    public function cloneAsBitmap(target:DisplayObject):Bitmap {
        var bounds:Rectangle = target.getBounds(target);
        if (bounds.width <= 0 || bounds.height <= 0) {
            trace("[cloneAsBitmap] Target has no visible size:", target);
            return null;
        }

        var bmd:BitmapData = new BitmapData(bounds.width, bounds.height, true, 0x00000000);

        var m:Matrix = new Matrix();
        m.translate(-bounds.x, -bounds.y);
        bmd.draw(target, m, target.transform.colorTransform, null, null, true);

        var clone:Bitmap = new Bitmap(bmd);
        clone.smoothing = true;
        return clone;
    }

    public function createTextField(
            text:String,
            size:int = 14,
            color:uint = 0xFFFFFF,
            bold:Boolean = false,
            autoSize:String = TextFieldAutoSize.LEFT
    ):TextField {
        var tf:TextField = new TextField();
        var format:TextFormat = new TextFormat("Space Mono", size, color, bold);

        tf.defaultTextFormat = format;
        tf.autoSize = autoSize;
        tf.text = text;
        tf.selectable = false;
        tf.mouseEnabled = false;

        return tf;
    }


    private function frame1():void {
        stop();
    }

    private function frame12():void {
        init();
    }

    private function frame13():void {
        loadTitle();
        stop();
    }

    private function frame23():void {
        trace("at game");
        initInterface();
        initWorld();
        stop();
    }

    private function frame32():void {
        stop();
    }

}
}//package