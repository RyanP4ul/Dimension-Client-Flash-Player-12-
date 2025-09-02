// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//World

package {

import Game_fla.ui_243;

import UI.Display.auraDisplay;

import UI.ModalMC;

import com.greensock.TweenLite;
import com.greensock.easing.Quad;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Loader;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.events.MouseEvent;
import flash.events.ProgressEvent;
import flash.events.TimerEvent;
import flash.filters.GlowFilter;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.media.Sound;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;
import flash.text.TextFormat;
import flash.utils.Timer;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;
import flash.utils.getTimer;

import game.builder.BuilderObjectDraggable;

import game.builder.MapWalkable;

import game.config.ConfigurationData;
import game.controller.QuestController;
import game.controller.TradeController;
import game.utils.Queue;
import game.npc.NpcButton;
import game.quest.Quests;

import types.DomainInfo;

public class World extends MovieClip {

    public static var currentInstance:World;

    private const TICK_MAX:int = 40;

    public var textDisplay:Array = [];
    public var dropMenu:Array = [];
    public var filtered_list:Array = [];
    public var uiLock:Boolean = false;
    public var objInfo:Object = {};
    public var objSession:Object = {};
    public var objResponse:Object = {};
    public var objQuestString:*;
    internal var FEATURE_COLLISION:Boolean = true;
    internal var CELL_MODE:String = "normal";
    public var SCALE:Number = 1;
    public var WALKSPEED:Number = 8;
    public var SCROLL:Boolean = false;
    internal var bitWalk:Boolean = false;
    internal var lastWalk:Date = new Date();
    public var strAreaName:String = "";
    public var strMapName:String;
    public var strMapFileName:String;
    public var isFloor:Boolean = false;
    public var isDungeon:Boolean = false;
    public var isTimeline:Boolean = false;
    public var floorDuration:int = 30;
    public var strMonName:String;
    public var intType:int;
    public var intKillCount:int;
    public var objLock:*;
    public var objExtra:*;
    public var objHouseData:*;
    public var objGuildData:*;
    public var returnInfo:Object;
    public var intNpc:int = 0;
    public var strFrame:String = "";
    public var strPad:String = "";
    public var spawnPoint:Object = {};
    public var FG:MovieClip;
    public var CHARS:MovieClip;
    public var TRASH:MovieClip;
    public var map:MovieClip;
    public var mapBoundsMC:MovieClip = null;
    public var zSortArr:Array = [];
    public var ldr_map:URLLoader = new URLLoader();
    internal var preLMC:*;
    internal var zManager:MovieClip;
    public var selectPreview:Object;
    public var arrEvent:Array;
    public var arrEventR:Array;
    public var arrSolid:Array;
    public var arrSolidR:Array;
    public var avatars:Object = {};
    public var myAvatar:Avatar;
    public var timeline:Object = null;
    public var mondef:Object;
    public var monmap:Array = [];
    public var monswf:Array;
    public var monsters:Array = [];
    public var npcdef:Array;
    public var npcmap:Array;
    public var npcs:Array = [];
    public var combatAnims:Array = ["Attack1", "Attack2", "Attack3", "Attack4", "Hit", "Knockout", "Getup", "Stab", "Thrash", "Castgood", "Cast1", "Cast2", "Cast3", "Sword/ShieldFight", "Sword/ShieldAttack1", "Sword/ShieldAttack2", "ShieldBlock", "DuelWield/DaggerFight", "DuelWield/DaggerAttack1", "DuelWield/DaggerAttack2", "FistweaponFight", "FistweaponAttack1", "FistweaponAttack2", "PolearmFight", "PolearmAttack1", "PolearmAttack2", "RangedFight", "RangedAttack1", "UnarmedFight", "UnarmedAttack1", "UnarmedAttack2", "KickAttack", "FlipAttack", "Dodge"];
    public var staticAnims:Array = ["Fall", "Knockout", "Die"];
    public var bankController:BankController;
    public var tradeController:TradeController;
    public var shopinfo:Object;
    public var shopBuyItem:Object;
    public var enhShopID:int = -1;
    public var enhShopItems:Array;
    public var enhItem:Object;
    public var hairshopinfo:Object;
    public var mapEvents:Object;
    public var adData:Object;
    public var cellMap:Object;
    private var tbmd:BitmapData;
    public var scrollData:Object;
    public var loaderD:ApplicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
    public var loaderC:LoaderContext = new LoaderContext(false, loaderD);
    public var loaderContents:* = [];
    public var loaderContentsFileNames:* = [];
    public var loaderQueue:Array = [];
    public var playerDomains:Object = {};
    public var loaderManager:Object = {
        "i0": {
            "n": "i0",
            "loaderData": null,
            "timer": new Timer(5000, 1),
            "ldr": new URLLoader(),
            "free": true,
            "url": ""
        },
        "i1": {
            "n": "i1",
            "loaderData": null,
            "timer": new Timer(5000, 1),
            "ldr": new URLLoader(),
            "free": true,
            "url": ""
        },
        "i2": {
            "n": "i2",
            "loaderData": null,
            "timer": new Timer(5000, 1),
            "ldr": new URLLoader(),
            "free": true,
            "url": ""
        },
        "i3": {
            "n": "i3",
            "loaderData": null,
            "timer": new Timer(5000, 1),
            "ldr": new URLLoader(),
            "free": true,
            "url": ""
        },
        "i4": {
            "n": "i4",
            "loaderData": null,
            "timer": new Timer(5000, 1),
            "ldr": new URLLoader(),
            "free": true,
            "url": ""
        },
        "i5": {
            "n": "i5",
            "loaderData": null,
            "timer": new Timer(5000, 1),
            "ldr": new URLLoader(),
            "free": true,
            "url": ""
        }
    };
    public var mapLoadInProgress:Boolean = false;
    private var mapW:int = ConfigurationData.CLIENT_WIDTH;
    private var mapH:int = ConfigurationData.CLIENT_HEIGHT;
    private var mapNW:int = mapW;
    private var mapNH:int = mapH;
    private var mapBmps:Array = [];
    private var mapTimer:Timer = new Timer(2000);
    public var actions:Object = {};
    internal var restTimer:Timer = new Timer(2000, 1);
    public var autoActionTimer:Timer = new Timer(2000, 1);
    internal var mvTimer:Timer = new Timer(500, 1);
    internal var mvTimerObj:Object;
    internal var actionTimer:Timer;
    public var actionMap:Array = [];
    internal var autoAction:Object;
    internal var actionReady:Boolean = false;
    public var actionResults:Object = {};
    public var actionResultsMon:Object = {};
    internal var actionID:Number = 0;
    internal var actionIDLimit:Number = 30;
    internal var actionIDMon:Number = 0;
    internal var actionIDLimitMon:Number = 30;
    internal var actionDamage:*;
    internal var actionRangeSpamTS:Number = 0;
    internal var actionResultID:Number = 0;
    internal var actionResultIDLimit:Number = 30;
    internal var minLatencyOneWay:* = 20;
    internal var TcpAckDel:* = 170;
    internal var connMsgOut:* = false;
    public var mapWidth:int;
    public var mapHeight:int;
    public var mData:mapData;
    public var cHandle:cutsceneHandler;
    public var sController:soundController;
    public var chaosNames:Array = [];
    public var linkPreview:MovieClip;
    public var hideAllCapes:Boolean = false;
    public var hideOtherPets:Boolean = false;
    public var showAnimations:Boolean = true;
    public var showMonsters:Boolean = true;
    public var lock:Object = {
        "loadShop": {"cd": 3000, "ts": 0},
        "loadEnhShop": {"cd": 3000, "ts": 0},
        "loadHairShop": {"cd": 3000, "ts": 0},
        "equipItem": {"cd": 2000, "ts": 0},
        "unequipItem": {"cd": 2000, "ts": 0},
        "buyItem": {"cd": 2500, "ts": 0},
        "sellItem": {"cd": 2500, "ts": 0},
        "getDrop": {"cd": 2500, "ts": 0},
        "getMapItem": {"cd": 1000, "ts": 0},
        "questComplete": {"cd": 4000, "ts": 0},
        "acceptQuest": {"cd": 1000, "ts": 0},
        "unacceptQuest": {"cd": 1000, "ts": 0},
        "doIA": {"cd": 1000, "ts": 0},
        "rest": {"cd": 1900, "ts": 0},
        "who": {"cd": 3000, "ts": 0},
        "tfer": {"cd": 3000, "ts": 0},
        "mining": {"cd": 1500, "ts": 0}
    };
    public var invTree:Object = {};
    public var linkTree:Object = {};
    public var uoTree:Object = {};
    public var monTree:Object = {};
    public var npcTree:Object = {};
    public var waveTree:Object = {};
    public var enhPatternTree:Object = {};
    public var defaultCT:ColorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0);
    public var whiteCT:ColorTransform = new ColorTransform(1, 1, 1, 1, 0xFF, 0xFF, 0xFF, 0);
    public var iconCT:ColorTransform = new ColorTransform(0.5, 0.5, 0.5, 1, -50, -50, -50, 0);
    public var rarityCA:Array = [0x666666, 0xFFFFFF, 0x66FF00, 2663679, 0xFF00FF, 0xFFCC00, 0xFF0000];
    public var rarity:Object = {};
    public var deathCT:ColorTransform = new ColorTransform(0.7, 0.7, 1, 1, -20, -20, 20, 0);
    public var monCT:ColorTransform = new ColorTransform(1, 1, 1, 1, 30, 0, 0, 0);
    public var avtCT:ColorTransform = new ColorTransform(1, 1, 1, 1, 40, 40, 70, 0);
    public var avtWCT:ColorTransform = new ColorTransform(0, 0, 0, 0, 0xFF, 0xFF, 0xFF, 0);
    public var avtMCT:ColorTransform = new ColorTransform(0, 0, 0, 0, 30, 0, 0, 0);
    public var avtPCT:ColorTransform = new ColorTransform(0, 0, 0, 0, 40, 40, 70, 0);
    public var statusPoisonCT:ColorTransform = new ColorTransform(-0.3, -0.3, -0.3, 0, 0, 20, 0, 0);
    public var statusStoneCT:ColorTransform = new ColorTransform(-1.3, -1.3, -1.3, 0, 100, 100, 100, 0);
    public var GCD:int = 1500;
    public var GCDO:int = 1500;
    public var GCDTS:Number = 0;
    public var curRoom:int = 1;
    public var modID:int = -1;
    public var partyID:int = -1;
    public var guildID:int = -1;
    public var bPvP:Boolean = false;
    public var partyMembers:Array = [];
    public var partyOwner:String = "";
    public var areaUsers:Array = [];
    public var showHPBar:Boolean = false;
    public var game:Game;
    public var enhp:Array = [{
        "ID":1,
        "sName":"Adventurer",
        "sDesc":"none",
        "iSTR":16,
        "iDEX":16,
        "iEND":18,
        "iINT":16,
        "iWIS":16,
        "iLCK":0
    }, {
        "ID":2,
        "sName":"Fighter",
        "sDesc":"M1",
        "iSTR":44,
        "iDEX":13,
        "iEND":43,
        "iINT":0,
        "iWIS":0,
        "iLCK":0
    }, {
        "ID":3,
        "sName":"Thief",
        "sDesc":"M2",
        "iSTR":30,
        "iDEX":45,
        "iEND":25,
        "iINT":0,
        "iWIS":0,
        "iLCK":0
    }, {
        "ID":4,
        "sName":"Armsman",
        "sDesc":"M4",
        "iSTR":38,
        "iDEX":36,
        "iEND":26,
        "iINT":0,
        "iWIS":0,
        "iLCK":0
    }, {
        "ID":5,
        "sName":"Hybrid",
        "sDesc":"M3",
        "iSTR":28,
        "iDEX":20,
        "iEND":25,
        "iINT":27,
        "iWIS":0,
        "iLCK":0
    }, {
        "ID":6,
        "sName":"Wizard",
        "sDesc":"C1",
        "iSTR":0,
        "iDEX":0,
        "iEND":10,
        "iINT":50,
        "iWIS":20,
        "iLCK":20
    }, {
        "ID":7,
        "sName":"Healer",
        "sDesc":"C2",
        "iSTR":0,
        "iDEX":0,
        "iEND":40,
        "iINT":45,
        "iWIS":15,
        "iLCK":0
    }, {
        "ID":8,
        "sName":"Spellbreaker",
        "sDesc":"C3",
        "iSTR":0,
        "iDEX":0,
        "iEND":20,
        "iINT":40,
        "iWIS":30,
        "iLCK":10
    }, {
        "ID":9,
        "sName":"Lucky",
        "sDesc":"S1",
        "iSTR":10,
        "iDEX":10,
        "iEND":10,
        "iINT":10,
        "iWIS":10,
        "iLCK":50
    }, {
        "ID":23,
        "sName":"Depths",
        "sDesc":"S1",
        "iSTR":0,
        "iDEX":0,
        "iEND":0,
        "iINT":50,
        "iWIS":0,
        "iLCK":50
    }];

    public var PVPMaps:Array = [{
        "nam": "It's Us Or Them",
        "desc": "This cozy PvP map is ideal for players new to PvP in AQW.",
        "warzone": "usorthem",
        "label": "usorthem",
        "icon": "tower",
        "hidden": true
    }, {
        "nam": "Bludrut Brawl!",
        "desc": "A larger map requiring communication, coordination, and a whole lot of DPS.",
        "warzone": "bludrutbrawl",
        "label": "bludrutbrawl",
        "icon": "swords",
        "hidden": false
    }, {
        "nam": "Chaos Brawl!",
        "desc": "A larger map requiring communication, coordination, and a whole lot of DPS.",
        "warzone": "chaosbrawl",
        "label": "chaosbrawl",
        "icon": "swords",
        "hidden": false
    }, {
        "nam": "Frost Brawl!",
        "desc": "A larger map requiring communication, coordination, and a whole lot of DPS.",
        "warzone": "frostbrawl",
        "label": "frostbrawl",
        "icon": "swords",
        "hidden": false
    }, {
        "nam": "Darkovia Brawl!",
        "desc": "Join in the ancient war between werewolves and vampires!",
        "warzone": "darkoviapvp",
        "label": "darkoviapvp",
        "icon": "swords",
        "hidden": true
    }, {
        "nam": "Dage PVP!",
        "desc": "Needs Description!",
        "warzone": "dagepvp",
        "label": "dagepvp",
        "icon": "swords",
        "hidden": true
    }, {
        "nam": "Dage 1V1!",
        "desc": "Needs Description!",
        "warzone": "dage1v1",
        "label": "dage1v1",
        "icon": "swords",
        "hidden": true
    }, {
        "nam": "Doomwood Arena",
        "desc": "This arena is for one on one duels.",
        "warzone": "doomarena",
        "label": "doomarena",
        "icon": "swords",
        "hidden": true
    }];

    public var PVPQueue:Object = { "warzone": "",  "ts": -1,  "avgWait": -1 };
    public var PVPResults:Object = { "pvpScore": [], "team": 0 };
    public var PVPFactions:Array = [];
    public var bookData:Object;

    public var arrHouseItemQueue:* = [];
    public var ldr_House:URLLoader = new URLLoader();
    private var ticksum:Number = 0;
    private var ticklist:* = [];
    private var bfps:Boolean = false;
    private var fpsTS:Number = 0;
    private var fpsQualityCounter:int = 0;
    private var fpsArrayQuality:Array = [];
    internal var arrQuality:Array = ["LOW", "MEDIUM", "HIGH"];
    private var queue:Queue = new Queue();
    public var hasModified:Boolean = false;
    public var frameCopy:Array;
    private var houseFrame:String = "";
    private var imbalancedHouseCells:Array = [];
    private var houseJson:Object;
    private var finishedCells:Array;
    private var convertTimer:Timer;
    private var activeCell:String;

    private var needsZSort:Boolean = false;
    private var auraFXPool:Object = {};
    private var cooldownTargets:Array = [];
    private var frameHandlerActive:Boolean = false;

    public function World(game:Game) {
        this.game = game;
        currentInstance = this;

        SCROLL = false;
        bankController = new BankController();
        tradeController = new TradeController();
        map = new MovieClip();
        map.cacheAsBitmap = true;
        this.addChild(map);
        CHARS = new MovieClip();
        var _local_2:DisplayObject = this.addChild(CHARS);
        CHARS.mouseEnabled = false;
        _local_2.x = 0;
        _local_2.y = 0;
        TRASH = new MovieClip();
        this.addChild(TRASH);
        TRASH.mouseEnabled = false;
        TRASH.visible = false;
        TRASH.y = -1000;
        zManager = new MovieClip();
        this.addChild(zManager);
        FG = new MovieClip();
        this.addChild(FG);

        zManager.removeEventListener(Event.ENTER_FRAME, onZmanagerEnterFrame);
        autoActionTimer.removeEventListener(TimerEvent.TIMER, autoActionHandler);
        restTimer.removeEventListener(TimerEvent.TIMER, restRequest);
        mvTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, mvTimerHandler);
        mapTimer.removeEventListener(TimerEvent.TIMER, mapResizeCheck);

        zManager.addEventListener(Event.ENTER_FRAME, onZmanagerEnterFrame, false, 0, true);
        autoActionTimer.addEventListener(TimerEvent.TIMER_COMPLETE, autoActionHandler);
        restTimer.addEventListener(TimerEvent.TIMER, restRequest);
        mvTimer.addEventListener(TimerEvent.TIMER_COMPLETE, mvTimerHandler);
        mapTimer.addEventListener(TimerEvent.TIMER, mapResizeCheck, false, 0, true);
        mapTimer.start();

        initLoaders();
        initCutscenes();
    }

    public static function get GameRoot():MovieClip {
        return (currentInstance.game);
    }

    public static function get Bank():BankController {
        return (currentInstance.bankController);
    }

    public function initPatternTree():void
    {
        var o:*;
        for each (o in enhp)
        {
            enhPatternTree[o.ID] = o;
        }
    }

    public function initGuildhallData(_arg_1:Array):void {
        var _local_3:*;
        trace(("gd: " + _arg_1));
        var _local_2:uint;
        while (_local_2 < _arg_1.length) {
            trace(("i: " + _local_2));
            for (_local_3 in _arg_1[_local_2]) {
                trace(((((("gd[" + _local_2) + "].[") + _local_3) + "]: ") + _arg_1[_local_2][_local_3]));
            }
            _local_2++;
        }
    }

    public function killTimers():void {
        autoActionTimer.reset();
        restTimer.reset();
        game.chatF.mute.timer.reset();
        autoActionTimer.removeEventListener("timer", autoActionHandler);
        restTimer.removeEventListener("timer", restRequest);
        mvTimer.removeEventListener("timer", mvTimerHandler);
        game.chatF.mute.timer.removeEventListener("timer", game.chatF.unmuteMe);
    }

    public function killListeners():void {
        zManager.removeEventListener(Event.ENTER_FRAME, onZmanagerEnterFrame);
        removeChild(zManager);
    }

    public function queueLoad(_arg_1:*):* {
        _arg_1.retries = 1;
        loaderQueue.push(_arg_1);
        var _local_2:* = getFreeLoader();
        if (_local_2 != null) {
            loadNext(_local_2);
        }
    }

    public function loaderCallback(e:Event):* {
        var ldr:* = e.target;
        var l:* = getLoaderHost(ldr);
        if (l != null) {
            if (l.callBackA != null) {
                l.callBackA(e);
            }
        }
        closeLoader(l, true);
    }

    public function loaderHTTP(e:HTTPStatusEvent):void {
        var l:*;
        var str:String;
        if (e.status != 200) {
            l = getLoaderHostByLoaderInfo(e.currentTarget);
            trace(((("Loader queue http request: " + l.url) + ";") + e.status));
            str = ((("Queue: " + l.url) + ";") + e.status);
            trace(str);
            closeLoader(l, false, false);
        }
    }

    public function loaderErrorHandler(e:IOErrorEvent):* {
        var s:String = e.toString();
        var u:String = s.substr((s.indexOf("URL: ") + 5));
        u = u.substr(0, (u.length - 1));
        var l:* = getLoaderHostByURL(u);
        if (l != null) {
            if (l.callBackB != null) {
                l.callBackB(e);
            }
        }
        closeLoader(l, false, false);
    }

    private function loaderProgressHandler(e:Event):* {
        var loaderInfo:* = e.currentTarget;
        var l:* = getLoaderHostByLoaderInfo(loaderInfo);
        if (l != null) {
            l.isOpen = true;
        }
    }

    private function loaderTimerComplete(e:TimerEvent):void {
        var l:* = getLoaderHostByTimer(Timer(e.currentTarget));
        if (l != null) {
            l.timer.reset();
            if (!l.isOpen) {
                if (l.loaderData.retries-- > 0) {
                    loaderQueue.push(l.loaderData);
                }
                closeLoader(l, false, true);
            }
        }
    }

    public function getLoaderHost(ldr:*):* {
        var i:*;
        for (i in loaderManager) {
            if (loaderManager[i].ldr == ldr) {
                return (loaderManager[i]);
            }
        }
        return null;
    }

    public function getLoaderHostByLoaderInfo(_loaderInfo:*):Object {
        var i:*;
        for (i in loaderManager) {
            if (loaderManager[i].ldr == _loaderInfo) {
                return (loaderManager[i]);
            }
        }
        return null;
    }

    public function getLoaderHostByTimer(t:Timer):Object {
        var i:*;
        for (i in loaderManager) {
            if (loaderManager[i].timer == t) {
                return (loaderManager[i]);
            }
        }
        return null;
    }

    public function getLoaderHostByURL(u:String):Object {
        var i:*;
        for (i in loaderManager) {
            if (u.indexOf(loaderManager[i].url) > -1) {
                return (loaderManager[i]);
            }
        }
        return null;
    }

    public function getFreeLoader():Object {
        var i:*;
        if (loaderQueue.length > 0) {
            for (i in loaderManager) {
                if (loaderManager[i].free) {
                    loaderManager[i].free = false;
                    return (loaderManager[i]);
                }
            }
            return null;
        }
        return null;
    }

    public function closeLoader(ldrObj:Object, isOK:Boolean = true, isLoaded:Boolean = true, doNext:Boolean = true):void {
        if (isLoaded) {
            try {
                ldrObj.ldr.unload();
            } catch (e:Error) {
            }
        }
        ldrObj.free = true;
        ldrObj.isOpen = false;
        ldrObj.loaderData = null;
        ldrObj.timer.reset();
        var l:* = getFreeLoader();
        if (((!(l == null)) && (doNext))) {
            loadNext(l);
        }
    }

    public function initLoaders():void {
        var lmi:Object;
        var i:*;
        for (i in loaderManager) {
            lmi = loaderManager[i];
            lmi.timer.addEventListener(TimerEvent.TIMER_COMPLETE, loaderTimerComplete, false, 0, true);
            lmi.ldr.addEventListener(Event.COMPLETE, loaderCallback, false, 0, true);
            lmi.ldr.addEventListener(IOErrorEvent.IO_ERROR, loaderErrorHandler, false, 0, true);
            lmi.ldr.addEventListener(HTTPStatusEvent.HTTP_STATUS, loaderHTTP, false, 0, true);
            lmi.ldr.addEventListener(ProgressEvent.PROGRESS, loaderProgressHandler, false, 0, true);
        }
    }

    public function clearLoaders(clearPlayerDomains:Boolean = false):* {
        var lmi:Object;
        var i:* = undefined;
        for (i in loaderManager) {
            lmi = loaderManager[i];
            try {
                lmi.ldr.close();
            } catch (e:Error) {
            }
            try {
                lmi.ldr.unload();
            } catch (e:Error) {
            }
            lmi.free = true;
            lmi.isOpen = false;
            lmi.loaderData = null;
            lmi.timer.reset();
            lmi.callBackA = null;
            lmi.callBackB = null;
        }
        if (clearPlayerDomains) {
            playerDomains = {};
        }
        loaderD = new ApplicationDomain(ApplicationDomain.currentDomain);
        loaderC = new LoaderContext(false, loaderD);
        loaderC.checkPolicyFile = false;
        loaderC.allowCodeImport = true;
        loaderQueue = [];
    }

    public function killLoaders():void {
        var lmi:Object;
        var i:*;
        for (i in loaderManager) {
            lmi = loaderManager[i];
            lmi.free = true;
            lmi.isOpen = false;
            lmi.loaderData = null;
            lmi.timer.reset();
            lmi.callBackA = null;
            lmi.callBackB = null;
        }
        loaderQueue = [];
    }

    public function loadNext(_arg_1:Object):* {
        if (loaderQueue.length > 0) {
            loadNextWith(_arg_1, loaderQueue.shift());
        }
    }

    private function loadNextWith(l:Object, loaderData:Object):void {
        var u:URLRequest;
        var c:LoaderContext = loaderC;
        c.checkPolicyFile = false;
        c.allowCodeImport = true;
        if (l != null) {
            l.free = false;
            l.callBackA = loaderData.callBackA != null ? loaderData.callBackA : null;
            l.callBackB = loaderData.callBackB != null ? loaderData.callBackB : null;

//            if (loaderData.avt != null && loaderData.avt == myAvatar && loaderData.sES != null)
//            {
//                if (loaderData.sES == "weapon")
//                {
//                    mapPlayerAssetClass(loaderData.sLink);
//                }
//                else
//                {
//                    mapPlayerAssetClass(loaderData.sES);
//                }
//            }

            u = new URLRequest(loaderData.strFile);
            l.ldr.dataFormat = URLLoaderDataFormat.BINARY;
            l.ldr
            l.ldr.load(u);
            l.url = u.url;
            l.isOpen = false;
            l.loaderData = loaderData;
            l.timer.reset();
            l.timer.start();
        }
    }

    public function mapPlayerAssetClass(sES:String):LoaderContext {
        if (!playerDomains[sES]) {
            var domainInfo:DomainInfo = new DomainInfo();
            domainInfo.loaderD = new ApplicationDomain(ApplicationDomain.currentDomain);
            domainInfo.loaderC = new LoaderContext(false, domainInfo.loaderD);
            domainInfo.loaderC.checkPolicyFile = false;
            domainInfo.loaderC.allowCodeImport = true;

            playerDomains[sES] = domainInfo;
        }

        return playerDomains[sES].loaderC;
    }

    public function getClass(assetLinkageID:String):Class {
        var c:Class;
        var sES:String;
        var o:Object = {};
        try {
            c = (getDefinitionByName(assetLinkageID) as Class);
            if (c != null) {
                return (c);
            }
        } catch (e:Error) {
        }
        try {
            c = (game.params.domain.assetsDomain.getDefinition(assetLinkageID) as Class);
            if (c != null) {
                return (c);
            }
        } catch (e:Error) {
        }
        try {
            c = (game.params.domain.soundEffectsDomain.getDefinition(assetLinkageID) as Class);
            if (c != null) {
                return (c);
            }
        } catch (e:Error) {
        }
        try {
            c = (loaderD.getDefinition(assetLinkageID) as Class);
            if (c != null) {
                return (c);
            }
        } catch (e:Error) {
        }
        trace();
        for (sES in playerDomains) {
            // trace("sES > " + sES);
            if (playerDomains[sES].loaderD.hasDefinition(assetLinkageID)) {
                return (playerDomains[sES].loaderD.getDefinition(assetLinkageID) as Class);
            }
        }
        trace();

        if (ConfigurationData.Debug)
        {
            trace((("getClass() could not find " + assetLinkageID) + "!"));
        }

        return null;
    }

    public function loadMap(strFilename:String):void {
        game.mcConnDetail.showConn("Loading Map Files...");

        if (map != null) {
            this.removeChild(map);
            map = null;
        }

        if (game.preference.data.cache.map.enabled && strFilename in game.cache.maps)
        {
            mapComplete(strFilename, MovieClip(game.cache.maps[strFilename]));
        }
        else
        {
            game.onLoadMaster(function (event:Event) : void {
                mapComplete(strFilename, MovieClip(Loader(event.target.loader).content));
            }, loaderC, ("maps/" + strFilename), onMapLoadProgress, onMapLoadError);
        }

        game.clearPopups();
    }

    private function mapComplete(strFilename:String, content:MovieClip) : void {
        game.ui.visible = true;
        mapLoadInProgress = false;
        map = content;
        map.cacheAsBitmap = true;
        addChildAt(map, 0).x = 0;
        CHARS.x = 0;

        if (game.preference.data.cache.map.enabled && !(strFilename in game.cache.maps))
        {
            if (game.cache.maps.length > game.preference.data.cache.map.max)
            {
                game.DictRemoveFirst(game.cache.maps);
            }

            game.cache.maps[strFilename] = content;
        }

        resetSpawnPoint();

        if (mondef != null && monmap.length > 0) {
            initMonsters(mondef, monmap);
        } else if (npcmap != null && npcmap.length > 0) {
            initNpcs(npcdef, npcmap);
        } else {
            enterMap();
        }

        if (isMyHouse()) game.ui.mcPopup.fOpen("House");
    }

    private function onMapLoadProgress(event:ProgressEvent):void {
        var percent:int = int(Math.floor(((event.bytesLoaded / event.bytesTotal) * 100)));
        game.mcConnDetail.showConn((("Loading Map... " + percent) + "%"));
    }

    private function onMapLoadError(_arg_1:IOErrorEvent):* {
        mapLoadInProgress = false;
        game.mcConnDetail.showError("Loading Map Files... Failed!");
    }

    public function reloadCurrentMap():void {
        clearMonstersAndProps();
        loadMap(((strMapFileName + "?") + Math.random()));
    }

    public function enterMap():void {
        var uotf:Object = uoTreeLeaf(game.net.myUserName);

        if (intType == 0 || returnInfo == null) {
            moveToCell(uotf.strFrame, uotf.strPad);
        } else {
            moveToCell(returnInfo.strCell, returnInfo.strPad);
            returnInfo = null;
        }

        if (isFloor)
        {
            game.ui.mcPvEDuration.start(floorDuration);
        }
        else
        {
            game.ui.mcPvEDuration.close();
        }

        initMapEvents();

        game.mcConnDetail.hideConn();
        game.ui.mcInterface.areaList.visible = true;

        if (myAvatar != null) game.showPortrait(myAvatar);
        if (isMyHouse()) initMassConvert();
    }

    public function initTimeline(strFrame:String) : void
    {
        if (!isTimeline) return;

        var scale:Number = 0.8;
        var speed:int = 11;
        var mode:String = "normal";
        var scroll:Boolean = false;

        var walkable:MapWalkable = new MapWalkable();
        walkable.width = mapWidth;
        walkable.height = mapHeight;
        walkable.x = walkable.y = 0;
        walkable.name = "walk";
        map.walk = map.addChild(walkable);

        for (var i:int = 0; i < map.numChildren; i++)
        {
            var child:DisplayObject = map.getChildAt(i);

            if (child is MovieClip && child.name.indexOf("__props__") == 0)
            {
                MovieClip(child).isProp = true;
                MovieClip(child).mouseEnabled = false;
                MovieClip(child).mouseChildren = false;
            }
        }

        if (timeline != null && timeline.hasOwnProperty(strFrame))
        {
            var o:Object = timeline[strFrame];

            mapWidth = timeline[strFrame].Width;
            mapHeight = timeline[strFrame].Height;

            game.mapBuilder.menu.tScale.text = timeline[strFrame].Scale;
            game.mapBuilder.menu.tMode.text = timeline[strFrame].Mode;
            game.mapBuilder.menu.tSpeed.text = timeline[strFrame].Speed;
            game.mapBuilder.menu.tWidth.text = String(mapWidth);
            game.mapBuilder.menu.tHeight.text = String(mapHeight);
            game.mapBuilder.menu.chkScroll.bitChecked = Boolean(timeline[strFrame].Scroll);
            game.mapBuilder.menu.chkScroll.checkmark.visible = game.mapBuilder.menu.chkScroll.bitChecked;

            scale = timeline[strFrame].Scale;
            mode = timeline[strFrame].Mode;
            speed = timeline[strFrame].Speed;
            scroll = timeline[strFrame].Scroll;

            map.walk.width = mapWidth;
            map.walk.height = mapHeight;

            game.mapBuilder.initEvents(o.Events);
        }
        else
        {
            if (timeline == null) timeline = [];
            game.chatF.pushMsg("server", "The map is being rebuilt please wait.", "SERVER", "", 0);
            game.net.send("mapRebuilt", []);
        }

        cellSetup(scale, speed, mode, scroll);
    }

    public function setReturnInfo(_arg_1:String, _arg_2:String, _arg_3:String):void {
        returnInfo = {};
        returnInfo.strMap = _arg_1;
        returnInfo.strCell = _arg_2;
        returnInfo.strPad = _arg_3;
    }

    public function exitCell():void {
        mvTimerKill();
        exitCombat();

        game.clearPopups(["House"]);

        if (myAvatar != null) {
            myAvatar.targets = {}

            if (myAvatar.pMC != null) myAvatar.pMC.stopWalking();
            if (myAvatar.petMC != null) myAvatar.petMC.stopWalking();
            if (myAvatar.target != null) setTarget(null);
        }

        if (strFrame != "Wait") {
            clearMonstersAndProps();
            hideAllAvatars();
        }

        game.sfcSocial = false;
        game.ui.mcInterface.areaList.gotoAndStop("init");
    }

    public function moveToCell(frame:String, pad:String, _arg_3:Boolean = false):void {
        afkPostpone();

        if (myAvatar != null && myAvatar.pMC != null) myAvatar.pMC.currentCollision = null;

        if ((((objLock == null) || (objLock[frame] == null)) || (objLock[frame] <= intKillCount))) {
            if (uoTree[game.net.myUserName].freeze == null) {
                actionReady = false;
                bitWalk = false;
                var o:Object = {};
                o.strFrame = frame;
                o.strPad = pad;

                if (pad.toLowerCase() != "none") {
                    o.tx = 0;
                    o.ty = 0;
                }

                uoTreeLeafSet(game.net.myUserName, o);
                strFrame = frame;
                strPad = pad;

                if (((strAreaName.indexOf("battleon") < 0) || (strAreaName.indexOf("battleontown") > -1))) {
                    game.menuClose();
                }

                if (!_arg_3) {
                    game.net.send("moveToCell", [frame, pad]);
                }

                exitCell();

                if (isFloor)
                {
                    map.gotoAndStop(frame);
                    initTimeline(frame);
                }
                else
                {
                    map.gotoAndPlay("Blank");
                }
            }
        }
    }

    public function moveToCellByIDa(_arg_1:int):void {
        game.net.send("mtcid", [_arg_1]);
    }

    public function moveToCellByIDb(_arg_1:int):void {
        var _local_2:MovieClip;
        var _local_3:int;
        while (_local_3 < arrEvent.length) {
            _local_2 = (arrEvent[_local_3] as MovieClip);
            if (((("tID" in _local_2) && (_local_2.tID == _arg_1)) || ((_local_2.name.indexOf("ia") == 0) && (int(_local_2.name.substr(2)) == _arg_1)))) {
                moveToCell(_local_2.tCell, _local_2.tPad, true);
            }
            _local_3++;
        }
    }

    public function hideAllAvatars():void {
        var _local_1:*;
        for (_local_1 in avatars) {
            if (((!(avatars[_local_1] == null)) && (!(avatars[_local_1].pMC == null)))) {
                avatars[_local_1].hideMC();
            }
        }
    }

    public function clearAllAvatars():void {
        var _local_1:String;
        for (_local_1 in avatars) {
            destroyAvatar(Number(_local_1));
        }
        avatars = {};
    }

    public function clearMonstersAndProps():void {
        var _local_2:DisplayObject;
        var _local_3:*;
        var _local_1:int;
        _local_1 = 0;
        while (_local_1 < CHARS.numChildren) {
            _local_2 = CHARS.getChildAt(_local_1);
            if (_local_2.hasOwnProperty("isProp") && MovieClip(_local_2).isProp || _local_2.hasOwnProperty("isNpc") && MovieClip(_local_2).isNpc) {
                CHARS.removeChild(_local_2);
                _local_1--;
            } else if (_local_2.hasOwnProperty("isHouseItem") && MovieClip(_local_2).isHouseItem) {
                _local_2.removeEventListener(MouseEvent.MOUSE_DOWN, onHouseItemClick);
                CHARS.removeChild(_local_2);
                _local_1--;
            } else if (_local_2.hasOwnProperty("isMonster") && MovieClip(_local_2).isMonster) {
                MovieClip(_local_2).fClose();
                _local_1--;
            }

            _local_1++;
        }

        _local_1 = 0;
        while (_local_1 < TRASH.numChildren) {
            _local_2 = TRASH.getChildAt(_local_1);
            if (_local_2.hasOwnProperty("isMonster") && MovieClip(_local_2).isMonster) {
                MovieClip(_local_2).fClose();
                _local_1--;
            } else if (_local_2.hasOwnProperty("isNpc") && MovieClip(_local_2).isNpc) {
                CHARS.removeChild(_local_2);
                _local_1--;
            }
            _local_1++;
        }

        _local_1 = 0;
        while (_local_1 < monsters.length) {
            monsters[_local_1].pMC = null;
            _local_1++;
        }

        _local_1 = 0;
        while (_local_1 < npcs.length) {
            npcs[_local_1].pMC = null;
            _local_1++;
        }

        _local_1 = 0;
        while (_local_1 < map.numChildren) {
            _local_2 = map.getChildAt(_local_1);
            if (_local_2 is BuilderObjectDraggable || _local_2 is MapWalkable)
            {
                map.removeChild(_local_2);
                _local_1--;
            }

            _local_1++;
        }

        while (game.ui.mcPadNames.numChildren) {
            _local_3 = game.ui.mcPadNames.getChildAt(0);
            MovieClip(_local_3).stop();
            game.ui.mcPadNames.removeChild(_local_3);
        }
    }

    public function setMapEvents(_arg_1:Object):void {
        mapEvents = _arg_1;
    }

    public function initMapEvents():void {
        if ((("eventUpdate" in map) && (!(mapEvents == null)))) {
            map.eventUpdate({
                "cmd": "event",
                "args": mapEvents
            });
        }
        mapEvents = null;
    }

    public function setCellMap(_arg_1:Object):void {
        cellMap = _arg_1;
    }

    public function updateCellMap(_arg_1:Object):void {
        var _local_3:String;
        var _local_4:MovieClip;
        var _local_5:String;
        var _local_2:Object = {};
        for (_local_3 in cellMap) {
            _local_2 = cellMap[_local_3];
            if (((!(_local_2.ias == null)) && (!(_local_2.ias[_arg_1.ID] == null)))) {
                for (_local_5 in _arg_1) {
                    _local_2.ias[_arg_1.ID][_local_5] = _arg_1[_local_5];
                }
            }
        }
        try {
            _local_4 = MovieClip(CHARS.getChildByName(("ia" + _arg_1.ID)));
            _local_4.update();
            return;
        } catch (e:Error) {
        }
        try {
            _local_4 = MovieClip(map.getChildByName(("ia" + _arg_1.ID)));
            _local_4.update();
        } catch (e:Error) {
        }
    }

    public function onWalkClick(e:Event=null):void
    {
        var cLeaf:Object;
        var aura:Object;
        var p:Point;
        var mvPT:* = undefined;
        cLeaf = myAvatar.dataLeaf;
        for each (aura in cLeaf.auras) {
            try {
                if (aura.cat != null){
                    if (aura.cat == "stun"){
                        return;
                    }
                    if (aura.cat == "stone"){
                        return;
                    }
                    if (aura.cat == "freeze"){
                        return;
                    }
                    if (aura.cat == "disabled"){
                        return;
                    }
                }
            } catch(e:Error) {
            }
        }
        p = new Point(mouseX, mouseY);
        if (bitWalk){
            afkPostpone();
            if ((((((((mouseX >= 0)) && ((mouseX <= ConfigurationData.CLIENT_WIDTH)))) && ((mouseY >= 0)))) && ((mouseY <= ConfigurationData.CLIENT_HEIGHT)))){
                p = CHARS.globalToLocal(p);
                p.x = Math.round(p.x);
                p.y = Math.round(p.y);
                mvPT = myAvatar.pMC.simulateTo(p.x, p.y, WALKSPEED);
                if (((!((mvPT == null))) && ((Point.distance(mvPT, myAvatar.pMC.location) > 5)))){
                    myAvatar.pMC.walkTo(mvPT.x, mvPT.y, WALKSPEED);
                    if (bPvP){
                        pushMove(myAvatar.pMC, mvPT.x, mvPT.y, WALKSPEED);
                    } else {
                        if (clickOnEventTest(mvPT.x, mvPT.y)){
                            pushMove(myAvatar.pMC, mvPT.x, mvPT.y, WALKSPEED);
                        } else {
                            moveRequest({
                                mc:myAvatar.pMC,
                                tx:mvPT.x,
                                ty:mvPT.y,
                                sp:WALKSPEED
                            });
                        }
                    }
                }
            }
        }
    }

    public function clickOnEventTest(_arg_1:int, _arg_2:int):Boolean {
        var avatarRect:Rectangle = myAvatar.pMC.shadow.getBounds(this);
        avatarRect.x = _arg_1 - (avatarRect.width / 2);
        avatarRect.y = _arg_2 - (avatarRect.height / 2);

        for each (var eventMC:MovieClip in arrEvent) {
            var eventRect:Rectangle = eventMC.shadow.getBounds(this);
            if (avatarRect.intersects(eventRect)) {
                return true;
            }
        }

        return false;
    }

    public function moveRequest(_arg_1:Object):void
        {
            if (!mvTimer.running)
            {
                trace("moveRequest > moveRequest");

                pushMove(_arg_1.mc, _arg_1.tx, _arg_1.ty, _arg_1.sp);
                mvTimer.reset();
                mvTimer.start();
            }
            else
            {
                mvTimerObj = _arg_1;
            }
        }

        public function mvTimerHandler(_arg_1:TimerEvent):void
        {
            if (mvTimerObj != null)
            {
				trace("mvTimerHandler > moveRequest");
                pushMove(mvTimerObj.mc, mvTimerObj.tx, mvTimerObj.ty, mvTimerObj.sp);
                mvTimerObj = null;
				mvTimer.reset();
                mvTimer.start();
            }
        }

        public function mvTimerKill():void
        {
            mvTimer.reset();
            mvTimerObj = null;
        }

    public function pushMove(_arg_1:MovieClip, _arg_2:int, _arg_3:int, _arg_4:int):* {
        var o:Object = uoTree[game.net.myUserName];

		if (!bitWalk || o.tx == _arg_2 && o.ty == _arg_3) return;

        needsZSort = true;

        uoTreeLeafSet(game.net.myUserName, {
            tx: int(_arg_2),
            ty: int(_arg_3),
            sp: int(_arg_4)
        });

        game.net.send("mv", [_arg_2, _arg_3, _arg_4]);
    }

    public function monstersToPads():* {
        var _local_1:*;
        var _local_2:*;
        for (_local_1 in monsters) {
            _local_2 = monsters[_local_1];
            if (((!(_local_2.objData == null)) && (_local_2.objData.strFrame == strFrame))) {
                _local_2.pMC.walkTo(_local_2.pMC.ox, _local_2.pMC.oy, (WALKSPEED * 1.4));
            }
        }
    }

    public function updatePadNames():* {
        var _local_2:*;
        var _local_1:int;
        while (_local_1 < game.ui.mcPadNames.numChildren) {
            _local_2 = MovieClip(game.ui.mcPadNames.getChildAt(_local_1));
            if ((((objLock == null) || (objLock[_local_2.tCell] == null)) || (objLock[_local_2.tCell] <= intKillCount))) {
                _local_2.cnt.lock.visible = false;
            } else {
                _local_2.cnt.lock.visible = true;
            }
            _local_1++;
        }
    }

//    public function cellSetup(scale:Number, speed:Number, cellMode:String, scroll:Boolean = false):void {
//        CHARS.x = CHARS.y = 0;
//        map.x = map.y = 0;
//        CELL_MODE = cellMode;
//        SCALE = scale;
//        WALKSPEED = speed;
//        SCROLL = scroll;
//        arrSolid.length = 0;
//        arrEvent.length = 0;
//
//        var monName:Boolean = (Number(objExtra["bMonName"]) == 1);
//        var child:DisplayObject;
//        var i:int = map.numChildren;
//
//        // Add walk event listener once
//        if (map.walk != null && !map.walk.hasEventListener(MouseEvent.CLICK)) {
//            map.walk.addEventListener(MouseEvent.CLICK, onWalkClick, false, 0, true);
//        }
//
//        // Process map children
//        while (i--) {
//            child = map.getChildAt(i);
//            if (!(child is MovieClip)) continue;
//
//            var mc:MovieClip = MovieClip(child);
//
//            // Handle pads
//            if (mc.hasPads) {
//                var j:int = mc.numChildren;
//                while (j--) {
//                    var c:DisplayObject = mc.getChildAt(j);
//                    if (c is MovieClip) {
//                        if (MovieClip(c).isEvent && !MovieClip(c).isProp) {
//                            arrEvent.push(c);
//                        }
//                        if (MovieClip(c).isSolid) {
//                            arrSolid.push(mc);
//                        }
//                    }
//                }
//            }
//
//            // Handle solids, events, and walk areas
//            if (mc.isSolid) {
//                arrSolid.push(mc);
//            } else if (mc.isEvent && !mc.isProp) {
//                arrEvent.push(mc);
//            } else if ("walk" in mc) {
//                mc.btnWalkingArea.useHandCursor = false;
//                if (!mc.btnWalkingArea.hasEventListener(MouseEvent.CLICK)) {
//                    mc.btnWalkingArea.addEventListener(MouseEvent.CLICK, onWalkClick, false, 0, true);
//                }
//            }
//
//            // Handle monsters
//            if (mc.isMonster) {
//                var mons:Array = getMonsters(mc.MonMapID);
//                for each (var mon:Avatar in mons) {
//                    if (mon == null) continue;
//                    var monMC:MovieClip = createMonsterMC(mc, mon.objData.MonID, monName);
//                    monMC.scaleX = monMC.scaleY = SCALE;
//                    monMC.pAV = mon;
//                    monMC.setData();
//                    if (mon.dataLeaf == null) {
//                        TRASH.addChild(monMC);
//                    } else {
//                        CHARS.addChild(monMC);
//                    }
//                }
//            }
//
//            // Handle NPCs
//            if (mc.isNpc) {
//                var npcs:Array = getNpcs(mc.NpcMapID);
//                for each (var npc:Avatar in npcs) {
//                    if (npc == null) continue;
//                    var npcMC:AvatarMC;
//                    if (npc.objData.NpcID in game.cache.npcs) {
//                        npcMC = game.cache.npcs[npc.objData.NpcID] as AvatarMC;
//                    } else {
//                        npcMC = loadAvatar(this, npc, true, npc.objData.Scale);
//                        npcMC.name = npc.objData.strUsername + "_NpcApop_" + npc.objData.NpcID;
//                        npcMC.pname.ti.text = npc.objData.strUsername;
//                        npcMC.pname.ti.textColor = npc.objData.NpcNameColor;
//                        npcMC.x = mc.x;
//                        npcMC.y = mc.y;
//                        var npcApop:MovieClip = new NpcButton(getNpc(npc.objData.NpcMapID)) as MovieClip;
//                        npcApop.x -= 7;
//                        npcApop.y = -150;
//                        npcMC.addChild(npcApop);
//                        game.cache.npcs[npc.objData.NpcID] = npcMC;
//                    }
//                    CHARS.addChild(npcMC);
//                }
//            }
//
//            // Handle props
//            if (mc.isProp) {
//                var oref:MovieClip = MovieClip(CHARS.addChild(mc));
//                if (oref.isEvent) {
//                    arrEvent.push(oref);
//                    oref.isEvent = false;
//                }
//                map.removeChildAt(i); // Remove from map to prevent reprocessing
//            }
//
//            // Optimize large backgrounds
//            if (mc.width > 700 && !("isSolid" in mc) && !("walk" in mc) && !("btnSkip" in mc)) {
//                mc.mouseEnabled = false;
//                mc.mouseChildren = false;
//            }
//        }
//
//        buildBoundingRects();
//        if (map.bounds != null) {
//            mapBoundsMC = (map.getChildByName("bounds") as MovieClip);
//        }
//        if (game.preference.data.bSmoothBG)
//        {
//            rebuildMapBMP(map);
//        }
//        updateNpcs();
//        updateMonsters();
//        updatePadNames();
//        mapScrollCheck();
//        if (objHouseData != null) {
//            updateHouseItems();
//        }
//        playerInit();
//
////        buildBoundingRects();
////        if (map.bounds != null) {
////            mapBoundsMC = map.getChildByName("bounds") as MovieClip;
////        }
////        if (game.preference.data.bSmoothBG) {
////            rebuildMapBMP(map);
////        }
////        updateNpcs();
////        updateMonsters();
////        updatePadNames();
////        mapScrollCheck();
//    }

    public function getTimePeriodDay():String
    {
        var date:Date = new Date();
        var hour:int = date.hours;

        if (hour >= 5 && hour < 12)
        {
            return "Morning";
        }
        else if (hour >= 12 && hour < 17)
        {
            return "Afternoon";
        }
        else if (hour >= 17 && hour < 21)
        {
            return "Evening";
        }
        else
        {
            return "Midnight";
        }
    }

    public function cellSetup(scale:Number, speed:Number, cellMode:String, scroll:Boolean = false):void {
        var child:DisplayObject;
        var j:uint;
        var c:DisplayObject;
        var monArr:*;
        var Mons:Array;
        var Mon:Avatar;
        var oref:*;
        var _local_17:Array;

        CHARS.x = (CHARS.y = 0);
        map.x = (map.y = 0);
        CELL_MODE = cellMode;
        SCALE = scale;
        WALKSPEED = speed;
        SCROLL = scroll;
        arrSolid = [];
        arrEvent = [];

        var monName:* = (Number(objExtra["bMonName"]) == 1);
        var i:int = 0;

        if (map.walk != null){
            map.walk.addEventListener(MouseEvent.CLICK, onWalkClick, false, 0, true);
        }

        while (i < map.numChildren) {
            child = map.getChildAt(i);
            if (child is MovieClip) {
                if (MovieClip(child).hasPads) {
                    j = 0;
                    while (j < MovieClip(child).numChildren) {
                        c = MovieClip(child).getChildAt(j);
                        if ((((c is MovieClip) && (MovieClip(c).isEvent)) && (!(MovieClip(c).isProp)))) {
                            arrEvent.push(MovieClip(c));
                        }
                        if (((c is MovieClip) && (MovieClip(c).isSolid))) {
                            arrSolid.push(MovieClip(child));
                        }
                        j++;
                    }
                }
            }
            if (((child is MovieClip) && (MovieClip(child).isSolid))) {
                arrSolid.push(MovieClip(child));
            }
            if (((child is MovieClip) && ("walk" in child))) {
                MovieClip(child).btnWalkingArea.useHandCursor = false;
                MovieClip(child).btnWalkingArea.addEventListener(MouseEvent.CLICK, onWalkClick, false, 0, true);
            }
            if ((((child is MovieClip) && (MovieClip(child).isEvent)) && (!(MovieClip(child).isProp)))) {
                arrEvent.push(MovieClip(child));
            }

            if (child is MovieClip && MovieClip(child).isMonster) {
                monArr = [];
                Mons = getMonsters(MovieClip(child).MonMapID);
                for each (Mon in Mons) {
                    if (Mon == null) {
                        if (ConfigurationData.Debug)
                        {
                            trace("No Monster Definition found for Pad!");
                        }
                    } else {
                        if (!Mon.objData.hasOwnProperty("strSpawnTimePeriod") ||  Mon.objData.strSpawnTimePeriod == "Always" || (Mon.objData.strSpawnTimePeriod != "Always" && Mon.objData.strSpawnTimePeriod == getTimePeriodDay()))
                        {
                            Mon.pMC = createMonsterMC(MovieClip(child), Mon.objData.MonID, monName);
                            Mon.pMC.scale(SCALE);
                            Mon.pMC.pAV = Mon;
                            Mon.pMC.setData();

                            if (Mon.dataLeaf == null) {
                                TRASH.addChild(Mon.pMC);
                            }
                        }
                    }
                }
            }

            if (child is MovieClip && MovieClip(child).isNpc) {
                monArr = [];
                _local_17 = getNpcs(MovieClip(child).NpcMapID);

                for each (var pAV:Avatar in _local_17) {
                    if (pAV == null) {
                        if (ConfigurationData.Debug)
                        {
                            trace("No Npc Definition found for Pad!");
                        }
                    } else {
//                        if (((!pAV.objData.hasOwnProperty("strSpawnTimePeriod") &&  pAV.objData.strSpawnTimePeriod == "Always") || (pAV.objData.strSpawnTimePeriod != "Always") && pAV.objData.strSpawnTimePeriod == getTimePeriodDay()))
                        if (!pAV.objData.hasOwnProperty("ReqQuestID") || (pAV.objData.hasOwnProperty("ReqQuestID") && QuestController.isQuestComplete(pAV.objData.ReqQuestID)))
                        {
                            var avatar:AvatarMC = loadAvatar(this, pAV, true, pAV.objData.Scale);
                            avatar.name = pAV.objData.strUsername + "_Npc_" + pAV.objData.NpcID;
                            avatar.pname.ti.text = pAV.objData.strUsername;
                            avatar.pname.ti.textColor = pAV.objData.NpcNameColor;

                            avatar.x = child.x;
                            avatar.y = child.y;
                            avatar.ox = avatar.x;
                            avatar.oy = avatar.y;

                            var npcApop:MovieClip = (new NpcButton(getNpc(pAV.objData.NpcMapID))) as MovieClip;
                            npcApop.x = npcApop.x - 7;
                            npcApop.y = -150;
                            npcApop.name = "npc-interact";
                            avatar.addChild(npcApop);

                            CHARS.addChild(avatar);
                        }
                    }
                }
            }
            if (((child is MovieClip) && (MovieClip(child).isProp))) {
                oref = CHARS.addChild(child);
                if (MovieClip(oref).isEvent) {
                    arrEvent.push(MovieClip(oref));
                    MovieClip(oref).isEvent = false;
                }
                i--;
            }
            if ((((((child is MovieClip) && (child.width > 700)) && (!("isSolid" in child))) && (!("walk" in child))) && (!("btnSkip" in child)))) {
                MovieClip(child).mouseEnabled = false;
                MovieClip(child).mouseChildren = false;
            }
            i++;
        }
        buildBoundingRects();
        if (map.bounds != null) {
            mapBoundsMC = (map.getChildByName("bounds") as MovieClip);
        }
        if (game.preference.data.bSmoothBG)
        {
            rebuildMapBMP(map);
        }
        updateNpcs();
        updateMonsters();
        updatePadNames();
        mapScrollCheck();
        if (objHouseData != null) {
            updateHouseItems();
        }
        playerInit();
    }

    public function loadAvatar(world:World, pAV:Avatar, isNpc:Boolean = false, scale:Number = 0.8): AvatarMC
    {
        var avatar:AvatarMC = new AvatarMC();
        pAV.dataLeaf.showCloak = true;
        pAV.dataLeaf.showHelm = true;
        pAV.dataLeaf.showCloak = true;
        pAV.pnm = pAV.objData.strUsername;

        if (avatar.isLoaded)
        {
            avatar.gotoAndPlay("in2");
            return avatar;
        }

        avatar.gotoAndPlay("hold")
        pAV.isMyAvatar = false;
        avatar.pAV = pAV;
        avatar.pAV.pMC = avatar;
        avatar.pAV.npcType = "npc";
        avatar.isNpc = isNpc;
        avatar.world = world != null ? world : new World(game);
        avatar.strGender = avatar.strGender != null ? avatar.strGender : pAV.objData.strGender;
        avatar.hideHPBar();
        avatar.shadow.visible = true;
        avatar.scale(scale);
        pAV.initAvatar({ data:pAV.objData });

        return avatar;
    }

    private function buildBoundingRects():void {
        var _local_2:Rectangle;
        var _local_3:MovieClip;
        var _local_1:int;
        arrEventR = [];
        arrSolidR = [];
        _local_1 = 0;
        while (_local_1 < arrEvent.length) {
            _local_3 = arrEvent[_local_1];
            _local_2 = _local_3.getBounds(game.stage);
            arrEventR.push(_local_2);
            _local_1++;
        }
        _local_1 = 0;
        while (_local_1 < arrSolid.length) {
            _local_3 = arrSolid[_local_1];
            _local_2 = _local_3.getBounds(game.stage);
            arrSolidR.push(_local_2);
            _local_1++;
        }
    }

    public function killWalkObjects():void {
        var _local_2:DisplayObject;
        var _local_1:int;
        while (_local_1 < map.numChildren) {
            _local_2 = map.getChildAt(_local_1);
            if (((_local_2 is MovieClip) && (MovieClip(_local_2).isEvent))) {
                removeEventListener("enter", MovieClip(_local_2).onEnter);
            }
            _local_1++;
        }
    }

    public function exitQuest():void {
        if (returnInfo != null) {
            game.net.send("cmd", ["tfer", game.net.myUserName, returnInfo.strMap, returnInfo.strCell, returnInfo.strPad]);
        }
    }

    public function gotoTown(_arg_1:String, _arg_2:String, _arg_3:String):void {
        var _local_4:* = uoTree[game.net.myUserName];
        if (_local_4.intState == 0) {
            game.chatF.pushMsg("warning", "You are dead!", "SERVER", "", 0);
        } else {
            if (((!(game.world.myAvatar.invLoaded)) || (!(game.world.myAvatar.pMC.artLoaded())))) {
                game.MsgBox.notify("Character still being loaded.");
            } else {
                if (coolDown("tfer")) {
                    game.MsgBox.notify(("Joining " + _arg_1));
                    setReturnInfo(_arg_1, _arg_2, _arg_3);
                    game.net.send("cmd", ["tfer", game.net.myUserName, _arg_1, _arg_2, _arg_3]);
                    if (((strAreaName.indexOf("battleon") < 0) || (strAreaName.indexOf("battleontown") > -1))) {
                        game.menuClose();
                    }
                } else {
                    game.MsgBox.notify("You must wait 5 seconds before joining another map.");
                }
            }
        }
    }

    public function gotoQuest(_arg_1:String, _arg_2:String, _arg_3:String):void {
        gotoTown(_arg_1, _arg_2, _arg_3);
    }

    public function openApop(apopObj:Object, custom:Boolean = false):void {
        var attach:MovieClip;
        if (((isMovieFront("Apop")) || ((!("frame" in apopObj)) || (("frame" in apopObj) && ("cnt" in apopObj))))) {
            game.menuClose();
            attach = attachMovieFront("Apop");
            attach.update(apopObj, custom);
        }
    }

    public function setSpawnPoint(_arg_1:*, _arg_2:*):void {
        spawnPoint.strFrame = _arg_1;
        spawnPoint.strPad = _arg_2;
    }

    public function resetSpawnPoint():void {
        spawnPoint.strFrame = "Enter";
        spawnPoint.strPad = "Spawn";
    }

    public function initObjExtra(_arg_1:String):void {
        var _local_2:Array;
        var _local_3:int;
        var _local_4:Array;
        objExtra = {};
        if (((!(_arg_1 == null)) && (!(_arg_1 == "")))) {
            _local_2 = _arg_1.split(",");
            _local_3 = 0;
            while (_local_3 < _local_2.length) {
                _local_4 = _local_2[_local_3].split("=");
                objExtra[_local_4[0]] = _local_4[1];
                _local_3++;
            }
        }
    }

    public function initObjInfo(_arg_1:String):void {
        var _local_2:Array;
        var _local_3:int;
        var _local_4:Array;
        objInfo = {};
        if (((!(_arg_1 == null)) && (!(_arg_1 == "")))) {
            _local_2 = _arg_1.split(",");
            _local_3 = 0;
            while (_local_3 < _local_2.length) {
                _local_4 = _local_2[_local_3].split("=");
                objInfo[_local_4[0]] = _local_4[1];
                _local_3++;
            }
        }
    }

    private function rasterize(_arg_1:Array, _arg_2:Boolean = false):void {
        var _local_5:Object;
        var _local_6:Point;
        var _local_7:Matrix;
        var _local_8:String;
        var _local_9:DisplayObject;
        mapNW = game.stage.stageWidth;
        var _local_3:Number = (mapNW / mapW);
        var _local_4:int = 0;
        mapNH = Math.round((mapH * _local_3));
        for each (_local_5 in _arg_1) {
            _local_5.child.x = _local_5.x;
            if (_local_5.bmd != null) {
                _local_5.bmd.dispose();
            }
            _local_5.bmd = new BitmapData(mapNW, mapNH, true, 0x999999);
            _local_6 = new Point(0, 0);
            _local_6 = _local_5.child.globalToLocal(_local_6);
            _local_7 = new Matrix((_local_3 * _local_5.child.transform.matrix.a), 0, 0, (_local_3 * _local_5.child.transform.matrix.d), -((_local_6.x * _local_3) * _local_5.child.transform.matrix.a), -((_local_6.y * _local_3) * _local_5.child.transform.matrix.d));
            _local_5.bmd.draw(_local_5.child, _local_7, _local_5.child.transform.colorTransform, null, new Rectangle(0, 0, mapNW, mapNH), false);
            _local_5.bm = new Bitmap(_local_5.bmd);
            _local_8 = String(("bmp" + _local_4));
            _local_9 = _local_5.child.parent.getChildByName(_local_8);
            if (_local_9 != null) {
                _local_5.child.parent.removeChild(_local_9);
            }
            _local_5.bmDO = _local_5.child.parent.addChildAt(_local_5.bm, (_local_5.child.parent.getChildIndex(_local_5.child) + 1));
            _local_5.bmDO.name = _local_8;
            _local_5.bmDO.width = mapW;
            _local_5.bmDO.height = mapH;
            _local_5.child.visible = false;
            if (_arg_2) {
                _local_5.child.x = (_local_5.child.x + 1200);
            }
            _local_4++;
        }
    }

    private function rebuildMapBMP(_arg_1:MovieClip):void {

        var _local_2:MovieClip;
        var _local_3:int;
        clearMapBmps();
        _local_3 = 0;
        while (_local_3 < _arg_1.numChildren) {
            _local_2 = (_arg_1.getChildAt(_local_3) as MovieClip);
            if (((((((((((((_local_2 is MovieClip) && (_local_2.width >= ConfigurationData.CLIENT_WIDTH)) && (_local_2.name.toLowerCase().indexOf("bmp") == -1)) && (_local_2.name.toLowerCase().indexOf("cs") == -1)) && (_local_2.name.toLowerCase().indexOf("bounds") == -1)) && (((_local_2 as MovieClip) == null) || (MovieClip(_local_2).totalFrames < 15))) && (!("isSolid" in _local_2))) && (!("isFloor" in _local_2))) && (!("isWall" in _local_2))) && (!("walk" in _local_2))) && (!("btnSkip" in _local_2))) && (!("noBmp" in _local_2)))) {
                mapBmps.push({
                    "child": _local_2,
                    "x": _local_2.x,
                    "bmDO": null
                });
            }
            _local_3++;
        }
        rasterize(mapBmps);
    }

    private function mapResizeCheck(_arg_1:TimerEvent):void {
        if (((!(map == null)) && (mapBmps.length > 0))) {
            if (mapNW != game.stage.stageWidth) {
                rasterize(mapBmps);
            }
        }
    }

    private function clearMapBmps():void {
        var _local_1:Object;
        if (mapBmps.length > 0) {
            for each (_local_1 in mapBmps) {
                _local_1.bmDO.parent.removeChild(_local_1.bmDO);
                if (_local_1.bmd != null) {
                    _local_1.bmd.dispose();
                }
                _local_1.child = null;
                _local_1.bmd = null;
                _local_1.bm = null;
            }
        }
        mapBmps = [];
    }

    public function initMap():mapData {
        mData = new mapData(game);
        return (mData);
    }

    public function initCutscenes():cutsceneHandler {
        cHandle = new cutsceneHandler(game);
        return (cHandle);
    }

    public function initSound(_arg_1:Sound):soundController {
        sController = new soundController(_arg_1, game);
        return (sController);
    }

    public function gotoHouse(_arg_1:String):void {
        _arg_1 = _arg_1.toLowerCase();
        if (((!(objHouseData == null)) && (objHouseData.unm == _arg_1))) {
            return;
        }
        game.net.send("house", [_arg_1]);
    }

    public function isHouseEquipped():Boolean {
        var _local_1:int = 0;
        while (_local_1 < myAvatar.houseitems.length) {
            if (myAvatar.houseitems[_local_1].bEquip == 1) {
                return true;
            }
            _local_1++;
        }
        return false;
    }

    public function isMyHouse():* {
        return ((!(objHouseData == null)) && (objHouseData.unm == myAvatar.objData.strUsername.toLowerCase()));
    }

    public function showHouseOptions(_arg_1:String):void {
        var _local_2:MovieClip = game.ui.mcPopup.mcHouseOptions;
        switch (_arg_1) {
            case "default":
            case "save":
            default:
                _local_2.visible = true;
                _local_2.bg.x = 0;
                _local_2.cnt.x = 0;
                _local_2.tTitle.x = 5;
                _local_2.bExpand.x = 190;
                _local_2.bg.visible = true;
                _local_2.cnt.visible = true;
                _local_2.tTitle.visible = true;
                _local_2.bExpand.visible = false;
                return;
            case "hide":
                _local_2.visible = true;
                _local_2.bg.x = 181;
                _local_2.cnt.x = 181;
                _local_2.tTitle.x = 186;
                _local_2.bExpand.x = 120;
                _local_2.bg.visible = false;
                _local_2.cnt.visible = false;
                _local_2.tTitle.visible = false;
                _local_2.bExpand.visible = true;
        }
    }

    public function hideHouseOptions():void {
        var _local_2:int;
        var _local_1:MovieClip = game.ui.mcPopup.mcHouseOptions;
        if (_local_1.visible) {
            _local_2 = 0;
            while (_local_2 < _local_1.numChildren) {
                _local_1.getChildAt(_local_2).x = 190;
                _local_2++;
            }
        }
        _local_1.visible = false;
    }

    public function onHouseOptionsDesignClick(_arg_1:MouseEvent):void {
        game.mixer.playSound("Click");
        toggleHouseEdit();
    }

    public function onHouseOptionsSaveClick(_arg_1:MouseEvent):void {
        if (hasModified) {
            game.mixer.playSound("Click");
            saveHouseSetup();
        }
    }

    public function onHouseOptionsHideClick(_arg_1:MouseEvent):void {
        game.mixer.playSound("Click");
        showHouseOptions("hide");
    }

    public function onHouseOptionsExpandClick(_arg_1:MouseEvent):void {
        game.mixer.playSound("Click");
        showHouseOptions("default");
    }

    public function onHouseOptionsFloorClick(_arg_1:MouseEvent):void {
        game.mixer.playSound("Click");
        showHouseInventory(70);
    }

    public function onHouseOptionsWallClick(_arg_1:MouseEvent):void {
        game.mixer.playSound("Click");
        showHouseInventory(72);
    }

    public function onHouseOptionsMiscClick(_arg_1:MouseEvent):void {
        game.mixer.playSound("Click");
        showHouseInventory(73);
    }

    public function onHouseOptionsHouseReset(_arg_1:MouseEvent):void
    {
        game.mixer.playSound("Click");
        var modal:ModalMC = new ModalMC();
        var modalO:Object = {};
        modalO.params = {};
        modalO.strBody = "Are you sure you want to reset the entire house?";
        modalO.callback = confirmClear;
        modalO.btns = "dual";
        game.ui.ModalStack.addChild(modal);
        modal.init(modalO);
    }

    public function confirmClear(_arg_1:Object):void
    {
        var _local_2:int;
        var _local_3:DisplayObject;
        if (_arg_1.accept)
        {
            _local_2 = 0;
            while (_local_2 < CHARS.numChildren)
            {
                _local_3 = CHARS.getChildAt(_local_2);
                if (((_local_3.hasOwnProperty("isHouseItem")) && (MovieClip(_local_3).isHouseItem)))
                {
                    CHARS.removeChild(_local_3);
                    _local_2--;
                }
                _local_2++;
            }
            objHouseData.sHouseInfo = "";
            objHouseData.arrPlacement = [];
            initEquippedItems(objHouseData.arrPlacement);
            sendSaveHouseSetup(objHouseData.sHouseInfo);
            game.requestAPI(URLRequestMethod.POST, "character/HouseSaveRoom", {"frame":"*"}, callbackC, callbackB, true);
        }
    }

    public function callbackC(event:Event):void
    {
        if (event.target.data == "cleared")
        {
            game.addUpdate("House cleared successfully.");
            game.chatF.pushMsg("server", "House cleared successfully.", "SERVER", "", 0);
            cleanEverything();
        }
        else
        {
            game.chatF.pushMsg("warning", (("Error clearing your house. (CODE: " + event.target.data) + ")"), "SERVER", "", 0);
        }
    }

    public function cleanEverything():void
    {
        var disObj:DisplayObject;
        var i:int = 0;
        while (i < CHARS.numChildren)
        {
            disObj = CHARS.getChildAt(i);
            if (((disObj.hasOwnProperty("isHouseItem")) && (MovieClip(disObj).isHouseItem)))
            {
                CHARS.removeChild(disObj);
                i--;
            }
            i++;
        }
        objHouseData.sHouseInfo = "";
        objHouseData.sData = {};
        objHouseData.arrPlacement = [];
        initEquippedItems(objHouseData.arrPlacement);
    }

    public function onHouseOptionsHouseClick(_arg_1:MouseEvent):void {
        game.mixer.playSound("Click");
        gotoTown("buyhouse", "Enter", "Spawn");
    }

    public function showHouseInventory(_arg_1:int):* {
        if (myAvatar.houseitems != null) {
            sendLoadShopRequest(_arg_1);
        }
    }

    public function discardHouseChanges(_arg_1:Object):*
    {
        var _local_2:DisplayObject;
        var _local_3:int;
        var _local_4:*;
        var _local_5:int;
        if (_arg_1.accept)
        {
            saveHouseSetup();
        }
        else
        {
            hasModified = false;
            if (game.ui.mcPopup.mcHouseItemHandle.visible)
            {
                game.ui.mcPopup.mcHouseItemHandle.tgt = null;
                game.ui.mcPopup.mcHouseItemHandle.x = 1000;
                game.ui.mcPopup.mcHouseItemHandle.visible = false;
            }
            _local_3 = 0;
            while (_local_3 < CHARS.numChildren)
            {
                _local_2 = CHARS.getChildAt(_local_3);
                if (((_local_2.hasOwnProperty("isHouseItem")) && (MovieClip(_local_2).isHouseItem)))
                {
                    CHARS.removeChild(_local_2);
                    _local_3--;
                }
                _local_3++;
            }
            if (isLegacy())
            {
                _local_3 = 0;
                while (_local_3 < objHouseData.arrPlacement.length)
                {
                    if (strFrame == objHouseData.arrPlacement[_local_3].c)
                    {
                        objHouseData.arrPlacement.splice(_local_3, 1);
                        _local_3--;
                    }
                    _local_3++;
                }
                for each (_local_4 in frameCopy)
                {
                    objHouseData.arrPlacement.push(_local_4);
                }
            }
            else
            {
                objHouseData.arrPlacement[strFrame] = {};
                objHouseData.arrPlacement[strFrame]["xi"] = [];
                _local_5 = 0;
                for each (_local_4 in frameCopy)
                {
                    objHouseData.arrPlacement[strFrame]["xi"].push(_local_4);
                    _local_5++;
                }
                if (_local_5 == 0)
                {
                    objHouseData.arrPlacement[strFrame] = null;
                }
            }
            updateHouseItems();
        }
        if (((!(hasModified)) && (game.ui.mcPopup.mcHouseMenu.visible)))
        {
            toggleHouseEdit();
        }
    }

    public function toggleHouseEdit():void
    {
        var modal:ModalMC;
        var modalO:Object;
        var _local_3:int;
        var _local_4:DisplayObject;
        var _local_5:*;

        if (((isMyHouse()) && (!(myAvatar.houseitems == null))))
        {
            if (game.ui.mcPopup.mcHouseMenu.visible)
            {
                if (hasModified)
                {
                    modal = new ModalMC();
                    modalO = {};
                    modalO.params = {};
                    modalO.strBody = "Do you want to Save (Yes) or Undo (No) the room?";
                    modalO.callback = discardHouseChanges;
                    modalO.btns = "dual";
                    game.ui.ModalStack.addChild(modal);
                    modal.init(modalO);
                    return;
                }
                game.ui.mcPopup.mcHouseMenu.hideEditMenu();
                setEditMode(false);
            }
            else
            {
                if (arrHouseItemQueue.length > 0)
                {
                    game.showMessageBox("Please wait for your house items to finish loading on your screen before being able to edit them.");
                    return;
                }
                if (isLegacy())
                {
                    frameCopy = [];
                    _local_3 = 0;
                    while (_local_3 < CHARS.numChildren)
                    {
                        _local_4 = CHARS.getChildAt(_local_3);
                        if (((_local_4.hasOwnProperty("isHouseItem")) && (MovieClip(_local_4).isHouseItem)))
                        {
                            if (MovieClip(_local_4).isStable)
                            {
                                frameCopy.push({
                                    "c":strFrame,
                                    "ID":MovieClip(_local_4).ItemID,
                                    "x":_local_4.x,
                                    "y":_local_4.y
                                });
                            }
                        }
                        _local_3++;
                    }
                }
                else
                {
                    frameCopy = [];

                    if (objHouseData.arrPlacement[strFrame])
                    {
                        for each (_local_5 in objHouseData.arrPlacement[strFrame]["xi"])
                        {
                            frameCopy.push(_local_5);
                        }
                    }
                }
                game.ui.mcPopup.mcHouseMenu.showEditMenu();
                setEditMode(true);
            }
        }
        else
        {
            if (strMapName == "buyhouse")
            {
                if (!game.ui.mcPopup.mcHouseMenu.visible)
                {
                    game.ui.mcPopup.mcHouseMenu.showEditMenu();
                }
                else
                {
                    game.ui.mcPopup.mcHouseMenu.hideEditMenu();
                }
            }
        }
    }


    private function houseBounds(_arg_1:Event):void
    {
        if (((((!(isMyHouse())) || (!(strFrame == houseFrame))) || (bitWalk)) || (!(strMapName == "house"))))
        {
            houseFrame = "";
            this.removeEventListener(Event.ENTER_FRAME, houseBounds);
            toggleHouseEdit();
            setEditMode(false);
        }
    }

    public function setEditMode(_arg_1:Boolean):*
    {
        var _local_2:*;
        if (_arg_1)
        {
            houseFrame = strFrame;
            for each (_local_2 in avatars)
            {
                if (_local_2.pMC)
                {
                    _local_2.pMC.visible = false;
                    _local_2.unloadPet();
                }
            }
            bitWalk = false;
            this.addEventListener(Event.ENTER_FRAME, houseBounds, false, 0, true);
        }
        else
        {
            for each (_local_2 in avatars)
            {
                if (_local_2.pMC)
                {
                    _local_2.pMC.visible = true;
                    _local_2.loadPet();
                }
            }
            bitWalk = true;
        }
    }

    public function loadHouseInventory():* {
        game.net.send("loadHouseInventory", []);
    }

    public function updateHouseItems():void
    {
        var _local_1:int;
        var _local_2:Object;
        var _local_3:*;
        if (objHouseData != null)
        {
            if (isMyHouse())
            {
                initEquippedItems(objHouseData.arrPlacement);
            }
            arrHouseItemQueue = [];
            if (isLegacy())
            {
                _local_1 = 0;
                while (_local_1 < objHouseData.arrPlacement.length)
                {
                    if (strFrame == objHouseData.arrPlacement[_local_1].c)
                    {
                        _local_2 = getHouseItem(objHouseData.arrPlacement[_local_1].ID);
                        if (_local_2 != null)
                        {
                            loadHouseItem(_local_2, objHouseData.arrPlacement[_local_1].x, objHouseData.arrPlacement[_local_1].y);
                        }
                    }
                    _local_1++;
                }
            }
            else
            {
                for (_local_3 in objHouseData.arrPlacement)
                {
                    if (strFrame == _local_3)
                    {
                        if (objHouseData.arrPlacement[_local_3])
                        {
                            _local_1 = 0;
                            while (_local_1 < objHouseData.arrPlacement[_local_3]["xi"].length)
                            {
                                _local_2 = getHouseItem(objHouseData.arrPlacement[_local_3]["xi"][_local_1]["ID"]);
                                if (_local_2 != null)
                                {
                                    loadHouseItem(_local_2, objHouseData.arrPlacement[_local_3]["xi"][_local_1]["x"], objHouseData.arrPlacement[_local_3]["xi"][_local_1]["y"], objHouseData.arrPlacement[_local_3]["xi"][_local_1]["f"]);
                                }
                                _local_1++;
                            }
                        }
                    }
                }
            }
        }
    }

    public function attachHouseItem(_arg_1:Object):void
    {
        var _local_2:Class = (loaderD.getDefinition(_arg_1.item.sLink) as Class);
        var _local_3:* = new (_local_2)();
        _local_3.f = _arg_1.f;
        _local_3.x = _arg_1.x;
        _local_3.y = _arg_1.y;
        _local_3.ItemID = _arg_1.item.ItemID;
        _local_3.item = _arg_1.item;
        _local_3.isHouseItem = true;
        _local_3.isStable = false;
        _local_3.addEventListener(MouseEvent.MOUSE_DOWN, onHouseItemClick, false, 0, true);
        if (_local_3.f)
        {
            _local_3.scaleX = (_local_3.scaleX * -1);
        }
        var _local_4:MovieClip = (CHARS.addChild(_local_3) as MovieClip);
        _local_4.name = ("mc" + getQualifiedClassName(_local_4));
        houseItemValidate(_local_3);
    }

    public function onHouseItemClick(_arg_1:Event):void {
        var _local_2:MovieClip = (_arg_1.currentTarget as MovieClip);
        if (((isMyHouse()) && (game.ui.mcPopup.mcHouseMenu.visible))) {
            game.ui.mcPopup.mcHouseMenu.drawItemHandle(MovieClip(_arg_1.currentTarget));
            game.ui.mcPopup.mcHouseMenu.onHandleMoveClick(_arg_1.clone());
        } else {
            if (((_local_2.btnButton == null) || (!(_local_2.btnButton.hasEventListener(MouseEvent.CLICK))))) {
                onWalkClick();
            }
        }
    }

    public function houseItemValidate(_arg_1:MovieClip):void {
        var _local_3:int;
        var _local_4:DisplayObject;
        var _local_2:* = getHouseItem(_arg_1.ItemID);
        if (_local_2.sType == "Floor Item") {
            _arg_1.isStable = false;
            _arg_1.addEventListener(Event.ENTER_FRAME, onHouseItemEnterFrame);
        } else {
            if (_local_2.sType == "Wall Item") {
                _arg_1.isStable = true;
                _local_3 = 0;
                while (_local_3 < map.numChildren) {
                    _local_4 = map.getChildAt(_local_3);
                    if ((((_local_4 is MovieClip) && (MovieClip(_local_4).isFloor)) && (MovieClip(_local_4).hitTestObject(_arg_1)))) {
                        _arg_1.isStable = false;
                        break;
                    }
                    _local_3++;
                }
                if (!_arg_1.isStable) {
                    _arg_1.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 100, 0, 0, 0);
                } else {
                    _arg_1.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0);
                }
            }
        }
    }

    public function onHouseItemEnterFrame(_arg_1:Event):void {
        var _local_4:DisplayObject;
        var _local_5:Rectangle;
        var _local_2:MovieClip = (_arg_1.currentTarget as MovieClip);
        var _local_3:int;
        while (_local_3 < map.numChildren) {
            _local_4 = map.getChildAt(_local_3);
            if ((((_local_4 is MovieClip) && (MovieClip(_local_4).isFloor)) && (MovieClip(_local_4).hitTestPoint(_local_2.x, _local_2.y)))) {
                _local_2.removeEventListener(Event.ENTER_FRAME, onHouseItemEnterFrame);
                _local_2.isStable = true;
                break;
            }
            _local_3++;
        }
        if (!_local_2.isStable) {
            _local_5 = _local_2.getBounds(game.stage);
            if ((_local_5.y + (_local_5.height / 2)) > 495) {
                _local_2.isStable = true;
                _local_2.y = Math.ceil((_local_5.y - (_local_5.y - _local_2.y)));
                _local_2.removeEventListener(Event.ENTER_FRAME, onHouseItemEnterFrame);
            } else {
                _local_2.y = (_local_2.y + 10);
            }
            if (game.ui.mcPopup.mcHouseMenu.visible) {
                game.ui.mcPopup.mcHouseMenu.drawItemHandle(_local_2);
            }
        }
    }

    public function isLegacy():Boolean
    {
        if (((!(objHouseData == null)) && ((objHouseData.sData == "") && (objHouseData.sHouseInfo == ""))))
        {
            return false;
        }
        return (!((!(objHouseData == null)) && (!(objHouseData.sData == ""))));
    }

    public function initHouseData(_arg_1:Object):void
    {
        objHouseData = _arg_1;

        if (objHouseData != null)
        {
            if (!isLegacy())
            {
                if (isMyHouse())
                {
                    searchForInequalities();
                }

                objHouseData.arrPlacement = objHouseData.sData;
                if (!objHouseData.hasOwnProperty("sData") || objHouseData.sData == "")
                {
                    objHouseData.arrPlacement = {};
                }

                if (isMyHouse())
                {
                    game.chatF.pushMsg("server", "Your house data has been upgraded.", "SERVER", "", 0);
                }
            }
            else
            {
                objHouseData.arrPlacement = createItemPlacementArray(objHouseData.sHouseInfo);
                if (isMyHouse())
                {
                    game.chatF.pushMsg("server", "Your house data needs to be upgraded. Upgrading will start shortly.", "SERVER", "", 0);
                }
            }
            verifyItemQty();
        }
        if (((isMyHouse()) && (imbalancedHouseCells.length > 0)))
        {
            massAutoSave();
        }
    }

    public function massAutoSave():void
    {
        convertTimer = new Timer(500, 1);
        convertTimer.addEventListener(TimerEvent.TIMER, onAutoSave, false, 0, true);
        convertTimer.start();
    }

    public function onAutoSave(_arg_1:TimerEvent):void
    {
        var _local_2:String = imbalancedHouseCells.shift();
        game.mcConnDetail.showConn((("Upgrading room " + _local_2) + "..."), false, true);
        game.chatF.pushMsg("server", (("Saving room " + _local_2) + "..."), "SERVER", "", 0);
        game.requestAPI(URLRequestMethod.POST, "character/HouseSaveRoom", {
            "frame":_local_2,
            "layout":objHouseData.sData[_local_2]
        }, callbackA, callbackB, true);
        if (imbalancedHouseCells.length < 1)
        {
            game.mcConnDetail.hideConn();
            convertTimer.removeEventListener(TimerEvent.TIMER, onSendConvert);
            convertTimer.reset();
            convertTimer = null;
        }
    }

    public function searchForInequalities():void
    {
        var _local_2:*;
        var _local_3:Array;
        var _local_4:int;
        var _local_6:*;
        var _local_7:*;
        var _local_8:*;
        var _local_9:int;
        var _local_1:* = {};
        for (_local_2 in objHouseData.sData)
        {
            if (objHouseData.sData[_local_2])
            {
                _local_4 = 0;
                while (_local_4 < objHouseData.sData[_local_2]["xi"].length)
                {
                    _local_7 = objHouseData.sData[_local_2]["xi"][_local_4]["ID"];
                    if (_local_1[_local_7] == null)
                    {
                        _local_1[_local_7] = 1;
                    }
                    else
                    {
                        _local_1[_local_7]++;
                    }
                    _local_4++;
                }
            }
        }
        _local_3 = [];
        _local_4 = 0;
        while (_local_4 < myAvatar.houseitems.length)
        {
            _local_8 = myAvatar.houseitems[_local_4];
            if (Number(_local_1[_local_8.ItemID]) > Number(_local_8.iQty))
            {
                _local_3.push(_local_8.ItemID);
            }
            _local_4++;
        }
        if (_local_3.length == 0)
        {
            return;
        }
        imbalancedHouseCells = [];
        var _local_5:Boolean;
        for (_local_6 in objHouseData.sData)
        {
            _local_5 = false;
            _local_9 = 0;
            while (_local_9 < objHouseData.sData[_local_6]["xi"].length)
            {
                if (_local_3.indexOf(objHouseData.sData[_local_6]["xi"][_local_9]["ID"]) > -1)
                {
                    objHouseData.sData[_local_6]["xi"].splice(_local_9, 1);
                    _local_9--;
                    _local_5 = true;
                }
                _local_9++;
            }
            if (_local_5)
            {
                imbalancedHouseCells.push(_local_6);
            }
        }
    }

    public function initMassConvert():void
    {
        if (objHouseData != null)
        {
            if (objHouseData.sHouseInfo != "")
            {
                if (isLegacy())
                {
                    massConvert();
                }
            }
        }
    }

    public function verifyItemQty():void {
        var _local_3:*;
        var _local_4:*;
        var _local_1:* = {};
        var _local_2:int;
        while (_local_2 < objHouseData.arrPlacement.length) {
            _local_3 = objHouseData.arrPlacement[_local_2].ID;
            if (_local_1[_local_3] == null) {
                _local_1[_local_3] = 1;
            } else {
                _local_1[_local_3]++;
            }
            _local_4 = getHouseItem(_local_3);
            if (((_local_4 == null) || (_local_4.iQty < _local_1[_local_3]))) {
                objHouseData.sHouseInfo = "";
                objHouseData.arrPlacement = [];
            }
            _local_2++;
        }
    }

    public function getHouseItem(_arg_1:int):Object {
        var _local_2:int;
        var _local_3:int;
        if (isMyHouse()) {
            _local_2 = 0;
            while (_local_2 < myAvatar.houseitems.length) {
                if (myAvatar.houseitems[_local_2].ItemID == _arg_1) {
                    return (myAvatar.houseitems[_local_2]);
                }
                _local_2++;
            }
        } else {
            _local_3 = 0;
            while (_local_3 < objHouseData.items.length) {
                if (objHouseData.items[_local_3].ItemID == _arg_1) {
                    return (objHouseData.items[_local_3]);
                }
                _local_3++;
            }
        }
        return null;
    }

    public function removeSelectedItem():void {
        var _local_1:MovieClip;
        if (objHouseData.selectedMC == null) {
            game.MsgBox.notify("Please selected an item to be removed.");
        } else {
            _local_1 = objHouseData.selectedMC;
            _local_1.removeEventListener(MouseEvent.MOUSE_DOWN, onHouseItemClick);
            unequipHouseItem(_local_1.ItemID);
            CHARS.removeChild(_local_1);
            delete objHouseData.selectedMC;
        }
    }

    public function equipHouse(_arg_1:Object):void {
        var _local_2:* = new ModalMC();
        var _local_3:* = {};
        _local_3.strBody = (("Are you sure you want to equip '" + _arg_1.sName) + "'? It will reset your house items?");
        _local_3.params = {"item": _arg_1};
        _local_3.callback = equipHouseRequest;
        game.ui.ModalStack.addChild(_local_2);
        _local_2.init(_local_3);
    }

    public function equipHouseRequest(_arg_1:*):void {
        if (_arg_1.accept) {
            game.world.sendEquipItemRequest(_arg_1.item);
            game.world.equipHouseByID(_arg_1.item.ItemID);
        }
    }

    public function equipHouseByID(_arg_1:int):void {
        var _local_2:int;
        while (_local_2 < myAvatar.houseitems.length) {
            myAvatar.houseitems[_local_2].bEquip = ((myAvatar.houseitems[_local_2].ItemID == _arg_1) ? 1 : 0);
            _local_2++;
        }
    }

    public function massConvert():void
    {
        var _local_1:*;
        houseJson = {};
        for each (_local_1 in createItemPlacementArray(objHouseData.sHouseInfo))
        {
            if (_local_1.c)
            {
                if (frameExists(_local_1.c))
                {
                    if (!houseJson.hasOwnProperty(_local_1.c))
                    {
                        houseJson[_local_1.c] = {};
                        houseJson[_local_1.c]["xi"] = [];
                    }
                    houseJson[_local_1.c]["xi"].push({
                        "ID":parseInt(_local_1.ID),
                        "x":parseInt(_local_1.x),
                        "y":parseInt(_local_1.y)
                    });
                }
            }
        }
        finishedCells = [];
        retrieveUnsentCell();
        convertTimer = new Timer(500, 1);
        convertTimer.addEventListener(TimerEvent.TIMER, onSendConvert, false, 0, true);
        convertTimer.start();
    }

    public function retrieveUnsentCell():void
    {
        var _local_1:*;
        for (_local_1 in houseJson)
        {
            if (finishedCells.indexOf(_local_1) == -1)
            {
                activeCell = _local_1;
                finishedCells.push(_local_1);
                return;
            }
        }
        game.mcConnDetail.hideConn();
        if (convertTimer)
        {
            convertTimer.removeEventListener(TimerEvent.TIMER, onSendConvert);
            convertTimer.reset();
            convertTimer = null;
        }
    }

    public function onSendConvert(_arg_1:TimerEvent):void
    {
        var _local_2:*;
        game.mcConnDetail.showConn((("Converting frame " + activeCell) + " from legacy house data..."), false, true);
        game.chatF.pushMsg("server", (("Saving room " + activeCell) + "..."), "SERVER", "", 0);
        game.requestAPI(URLRequestMethod.POST, "character/HouseSaveRoom", {
            "frame":activeCell,
            "layout":houseJson[activeCell]
        }, callbackA, callbackB, true);
        for each (_local_2 in houseJson[activeCell]["xi"])
        {
        }
        retrieveUnsentCell();
    }

    public function saveHouseSetup():void
    {
        var _local_1:int;
        var _local_3:DisplayObject;
        var _local_4:*;
        _local_1 = 0;
        while (_local_1 < CHARS.numChildren)
        {
            _local_3 = CHARS.getChildAt(_local_1);
            if (((_local_3.hasOwnProperty("isHouseItem")) && (MovieClip(_local_3).isHouseItem)))
            {
                if (!MovieClip(_local_3).isStable)
                {
                    game.showMessageBox((MovieClip(_local_3).item.sName + " is not properly placed!"));
                    return;
                }
            }
            _local_1++;
        }
        var _local_2:Object = {};
        _local_2["xi"] = [];
        _local_1 = 0;
        while (_local_1 < CHARS.numChildren)
        {
            _local_3 = CHARS.getChildAt(_local_1);
            if (((_local_3.hasOwnProperty("isHouseItem")) && (MovieClip(_local_3).isHouseItem)))
            {
                if (MovieClip(_local_3).isStable)
                {
                    _local_4 = {
                        "ID":int(MovieClip(_local_3).ItemID),
                        "x":int(_local_3.x),
                        "y":int(_local_3.y)
                    };
                    if (MovieClip(_local_3).scaleX < 0)
                    {
                        _local_4["f"] = 1;
                    }
                    _local_2["xi"].push(_local_4);
                }
                else
                {
                    game.chatF.pushMsg("warning", (MovieClip(_local_3).item.sName + " was removed for being in an invalid position."), "SERVER", "", 0);
                    unequipHouseItem(MovieClip(_local_3).ItemID);
                    _local_3.removeEventListener(MouseEvent.MOUSE_DOWN, onHouseItemClick);
                    CHARS.removeChild(_local_3);
                }
            }
            _local_1++;
        }
        objHouseData.arrPlacement[strFrame] = _local_2;

        game.requestAPI(URLRequestMethod.POST, "character/HouseSaveRoom", {
            "frame":strFrame,
            "layout":_local_2
        }, callbackA, callbackB, true);
        hasModified = false;
    }

    public function callbackA(_arg_1:Event):void
    {
        if (_arg_1.target.data == "success")
        {
            game.addUpdate("House saved successfully.");
            game.chatF.pushMsg("server", "House saved successfully.", "SERVER", "", 0);
            if (convertTimer)
            {
                convertTimer.start();
            }
        }
        else
        {
            game.chatF.pushMsg("warning", (("Error saving your house. (CODE: " + _arg_1.target.data) + ")"), "SERVER", "", 0);
            convertTimer.removeEventListener(TimerEvent.TIMER, onSendConvert);
            convertTimer.reset();
            convertTimer = null;
            game.mcConnDetail.hideConn();
        }
    }

    public function callbackB(_arg_1:IOErrorEvent):void
    {
        game.chatF.pushMsg("warning", "IOError occurred.", "SERVER", "", 0);
    }

    public function createItemPlacementString(_arg_1:Array):String {
        var _local_3:int;
        var _local_4:*;
        var _local_2:* = "";
        if (_arg_1.length > 0) {
            _local_3 = 0;
            while (_local_3 < _arg_1.length) {
                for (_local_4 in _arg_1[_local_3]) {
                    _local_2 = ((((_local_2 + _local_4) + ":") + _arg_1[_local_3][_local_4]) + ",");
                }
                _local_2 = _local_2.substring(0, (_local_2.length - 1));
                _local_2 = (_local_2 + "|");
                _local_3++;
            }
            _local_2 = _local_2.substring(0, (_local_2.length - 1));
        }
        return (_local_2);
    }

    public function createItemPlacementArray(_arg_1:String):Array {
        var _local_3:*;
        var _local_4:int;
        var _local_5:*;
        var _local_6:*;
        var _local_7:int;
        var _local_2:Array = [];
        if (_arg_1.length > 0) {
            _local_3 = _arg_1.split("|");
            _local_4 = 0;
            while (_local_4 < _local_3.length) {
                _local_5 = {};
                _local_6 = _local_3[_local_4].split(",");
                _local_7 = 0;
                while (_local_7 < _local_6.length) {
                    _local_5[_local_6[_local_7].split(":")[0]] = _local_6[_local_7].split(":")[1];
                    _local_7++;
                }
                _local_2.push(_local_5);
                _local_4++;
            }
        }
        return (_local_2);
    }

    public function sendSaveHouseSetup(_arg_1:*):void {
        game.net.send("housesave", [_arg_1]);
    }

    public function frameExists(_arg_1:String):Boolean
    {
        var _local_2:*;
        if (!_arg_1)
        {
            return false;
        }
        for each (_local_2 in game.world.map.currentScene.labels)
        {
            if (_local_2.name == _arg_1)
            {
                return true;
            }
        }
        return false;
    }

    public function initEquippedItems(_arg_1:*):void {
        var _local_3:int;
        var _local_2:int;
        while (_local_2 < myAvatar.houseitems.length) {
            if (myAvatar.houseitems[_local_2].sType != "House") {
                myAvatar.houseitems[_local_2].bEquip = 0;
                _local_3 = 0;
                while (_local_3 < _arg_1.length) {
                    if (myAvatar.houseitems[_local_2].ItemID == _arg_1[_local_3].ID) {
                        myAvatar.houseitems[_local_2].bEquip = 1;
                    }
                    _local_3++;
                }
            }
            _local_2++;
        }
    }

    public function initHouseInventory(_arg_1:*):void {
        myAvatar.houseitems = ((_arg_1.items == null) ? [] : _arg_1.items);
        initEquippedItems(createItemPlacementArray(_arg_1.sHouseInfo));
        var _local_2:Array = myAvatar.houseitems;
        var _local_3:int;
        while (_local_3 < _local_2.length) {
            _local_2[_local_3].iQty = int(_local_2[_local_3].iQty);
            game.world.invTree[_local_2[_local_3].ItemID] = _local_2[_local_3];
            _local_3++;
        }
    }

    public function unequipHouseItem(_arg_1:int):void {
        var _local_2:int;
        while (_local_2 < myAvatar.houseitems.length) {
            if (myAvatar.houseitems[_local_2].ItemID == _arg_1) {
                myAvatar.houseitems[_local_2].bEquip = 0;
            }
            _local_2++;
        }
    }

    public function loadHouseItem(item:Object, x:int, y:int, f:int=0):void
    {
        try
        {
            attachHouseItem({
                "item":item,
                "x":x,
                "y":y,
                "f":f
            });
        }
        catch(err:Error)
        {
            arrHouseItemQueue.push({
                "item":item,
                "typ":"A",
                "x":x,
                "y":y,
                "f":f
            });
            if (arrHouseItemQueue.length > 0)
            {
                loadNextHouseItem();
            }
        }
    }

    public function loadNextHouseItem():void {
        this.game.onLoadMaster(this.onHouseItemComplete, this.loaderC, arrHouseItemQueue[0].item.sFile);
    }

    public function onHouseItemComplete(_arg_1:Event):void {
        var _local_2:* = arrHouseItemQueue[0];
        if (_local_2.typ == "A") {
            attachHouseItem(_local_2);
            arrHouseItemQueue.splice(0, 1);
            if (arrHouseItemQueue.length > 0) {
                loadNextHouseItem();
            }
        } else {
            game.ui.mcPopup.mcHouseMenu.previewHouseItem(_local_2);
            arrHouseItemQueue.splice(0, 1);
            if (arrHouseItemQueue.length > 0) {
                loadNextHouseItemB();
            }
        }
    }

    public function loadHouseItemB(item:Object):void {
        try {
            game.ui.mcPopup.mcHouseMenu.previewHouseItem({"item": item});
        } catch (err:Error) {
            game.ui.mcPopup.mcHouseMenu.preview.t2.visible = true;
            game.ui.mcPopup.mcHouseMenu.preview.cnt.visible = false;
            game.ui.mcPopup.mcHouseMenu.preview.bAdd.visible = false;
            arrHouseItemQueue.push({
                "item": item,
                "typ": "B"
            });
            if (arrHouseItemQueue.length > 0) {
                loadNextHouseItemB();
            }
        }
    }

    public function loadNextHouseItemB():void {
        var _local_1:Object = this.arrHouseItemQueue[0].item;
        var _local_2:String = _local_1.sFile;
        this.ldr_House = new URLLoader();
        this.ldr_House.dataFormat = URLLoaderDataFormat.BINARY;
        var _local_3:String = _local_2;
        if (_local_1.sType == "House") {
            _local_2 = (_local_1.sFile.substr(0, -4) + "_preview.swf");
            _local_3 = ("maps/" + _local_2);
            this.game.onLoadMaster(this.onHouseItemComplete, this.loaderC, _local_3);
        } else {
            this.game.onLoadMaster(this.onHouseItemComplete, this.loaderC, _local_3);
        }
    }

    public function playerInit():void {
        var test:* = null;
        var rooms:Array = game.net.room.getUserList();
        var tempArray:Array = [];

        for (test in rooms) {
            if (rooms.hasOwnProperty(test)) {
                tempArray.push(rooms[test].getId());
            }
        }

        if (tempArray.length > 0) {
            objectByIDArray(tempArray);
        }

        myAvatar = avatars[game.net.myUserId];
        myAvatar.isMyAvatar = true;
        myAvatar.pMC.disablePNameMouse();
        game.sfcSocial = true;
    }

    public function objectByIDArray(_arg_1:Array):* {
        var _local_2:int;
        var _local_3:int;
        var _local_4:*;
        var _local_5:String;
        var _local_6:Object;
        var _local_7:String;
        var _local_8:Array = [];
        _local_2 = 0;
        while (_local_2 < _arg_1.length) {
            _local_3 = _arg_1[_local_2];
            _local_6 = getUoLeafById(_local_3);
            if (_local_6 != null) {
                _local_5 = _local_6.uoName;
                _local_7 = String(_local_6.strFrame);
                if (_local_3 == game.net.myUserId) {
                    _local_7 = strFrame;
                }
                if (avatars[_local_3] == null) {
                    avatars[_local_3] = new Avatar(game);
                    avatars[_local_3].uid = _local_3;
                    avatars[_local_3].pnm = _local_5;
                }
                avatars[_local_3].dataLeaf = _local_6;
                if (((avatars[_local_3].pMC == null) && (_local_7 == strFrame))) {
                    avatars[_local_3].pMC = createAvatarMC(_local_3);
                    _local_8.push(_local_3);
                }
                updateUserDisplay(_local_3);
            } else {
                if (ConfigurationData.Debug)
                {
                    trace(("login failed for uid: " + _local_3));
                }
            }
            _local_2++;
        }
        if (_local_8.length > 0) {
            getUserDataByIds(_local_8);
        }
    }

    public function objectByID(_arg_1:Number):* {
        var _local_3:*;
        var _local_4:*;

        if (ConfigurationData.Debug)
        {
            trace("** WORLD objectByID >");
        }

        var _local_2:* = getUoLeafById(_arg_1);
        if (_local_2 != null) {
            _local_3 = _local_2.uoName;
            _local_4 = String(_local_2.strFrame);
            if (_arg_1 == game.net.myUserId) {
                _local_4 = strFrame;
            }
            if (avatars[_arg_1] == null) {
                avatars[_arg_1] = new Avatar(game);
                avatars[_arg_1].uid = _arg_1;
                avatars[_arg_1].pnm = _local_3;
            }
            avatars[_arg_1].dataLeaf = _local_2;
            if (((avatars[_arg_1].pMC == null) && (_local_4 == strFrame))) {
                avatars[_arg_1].pMC = createAvatarMC(_arg_1);
                getUserDataById(_arg_1);
            }
            updateUserDisplay(_arg_1);
        }
    }

    public function createAvatarMC(_arg_1:Number):AvatarMC {
        if (ConfigurationData.Debug)
        {
            trace("** WORLD createAvatarMC >");
        }

        var _local_2:AvatarMC = new AvatarMC();
        _local_2.name = ("a" + _arg_1);
        _local_2.x = -600;
        _local_2.y = 0;
        _local_2.pAV = avatars[_arg_1];
        _local_2.world = this;
        return (_local_2);
    }

    public function destroyAvatar(_arg_1:Number):* {
        if (avatars[_arg_1] != null) {
            if (avatars[_arg_1].pMC != null) {
                if (!avatars[_arg_1].isMyAvatar) {
                    avatars[_arg_1].pMC.fClose();
                    delete avatars[_arg_1];
                }
            }
        }
    }

    public function updateUserDisplay(_arg_1:Number):* {
        var _local_5:*;
        var _local_6:*;
        var _local_7:*;

        if (ConfigurationData.Debug)
        {
            trace(("** WORLD updateUserDisplay > " + _arg_1));
        }

        var _local_2:* = getMCByUserID(_arg_1);
        var _local_3:* = getUoLeafById(_arg_1);
        var _local_4:* = String(_local_3.strFrame);
        if (_local_4 == strFrame) {
            _local_2.tx = int(_local_3.tx);
            _local_2.ty = int(_local_3.ty);
            _local_5 = int(_local_3.intState);
            _local_6 = null;

            if ("strPad" in _local_3 && _local_3.strPad.toLowerCase() != "none") {
                if (_local_3.strPad in map)
                {
                    _local_6 = map[_local_3.strPad];
                }
                else if (timeline != null && map.getChildByName(_local_3.strPad))
                {
                    _local_6 = map.getChildByName(_local_3.strPad);
                }
            }

            if (_local_2.tx != 0 || _local_2.ty != 0) {
                if (!testTxTy(new Point(_local_2.tx, _local_2.ty), _local_2)) {
                    _local_7 = solveTxTy(new Point(_local_2.tx, _local_2.ty), _local_2);
                    if (_local_7 != null) {
                        _local_2.x = _local_7.x;
                        _local_2.y = _local_7.y;
                    } else {
                        _local_2.x = int((ConfigurationData.CLIENT_WIDTH / 2));
                        _local_2.y = int((ConfigurationData.CLIENT_HEIGHT / 2));
                    }
                } else {
                    _local_2.x = _local_2.tx;
                    _local_2.y = _local_2.ty;
                }
            } else {
                if (_local_6 != null) {
                    _local_2.x = int(((_local_6.x + int((Math.random() * 10))) - 5));
                    _local_2.y = int(((_local_6.y + int((Math.random() * 10))) - 5));
                } else {
                    _local_2.x = int((ConfigurationData.CLIENT_WIDTH / 2));
                    _local_2.y = int((ConfigurationData.CLIENT_HEIGHT / 2));
                }
            }

            _local_2.scale(SCALE);
            if (_local_2.pAV.isMyAvatar)
            {
                mapScrollCheck();
            }
            if (_local_5) {
                _local_2.mcChar.gotoAndStop("Idle");
            } else {
                _local_2.mcChar.gotoAndStop("Dead");
            }
            if (showHPBar) {
                _local_2.showHPBar();
            } else {
                _local_2.hideHPBar();
            }
            if (_arg_1 == game.net.myUserId) {
                bitWalk = true;
            }
            if (((CELL_MODE == "normal") || (_arg_1 == game.net.myUserId))) {
                _local_2.pAV.showMC();
            } else {
                _local_2.pAV.hideMC();
            }
            if ((((bPvP) && (!(_local_3.pvpTeam == null))) && (_local_3.pvpTeam > -1))) {
                _local_2.mcChar.pvpFlag.visible = true;
                _local_2.mcChar.pvpFlag.gotoAndStop(["a", "b", "c"][_local_3.pvpTeam]);
            } else {
                _local_2.mcChar.pvpFlag.visible = false;
            }
            if (_local_2.isLoaded) {
                _local_2.gotoAndPlay("in2");
            } else {
                _local_2.gotoAndPlay("hold");
            }
        }
    }

    public function repairAvatars():void {
        var _local_1:Avatar;
        game.chatF.pushMsg("server", "Attempting to repair incomplete Avatars...", "SERVER", "", 0);
        var _local_2:Boolean;
        for each (_local_1 in avatars) {
            if (!_local_1.pMC.isLoaded) {
                _local_2 = true;
                if (_local_1.objData != null) {
                    game.chatF.pushMsg("server", (" > repairing " + _local_1.objData.strUsername), "SERVER", "", 0);
                    _local_1.initAvatar(_local_1.objData);
                } else {
                    if (_local_1.pnm != null) {
                        game.chatF.pushMsg("warning", ((" *> Data load incomplete for " + _local_1.pnm) + ", repair cannot continue."), "SERVER", "", 0);
                    } else {
                        game.chatF.pushMsg("warning", " *> Avatar instantiated but no data exists at all!", "SERVER", "", 0);
                    }
                }
            }
        }
        if (!_local_2) {
            game.chatF.pushMsg("server", " > No incomplete Avatars found!", "SERVER", "", 0);
        }
    }

    private function solveTxTy(_arg_1:Point, _arg_2:MovieClip):Point {
        var _local_6:Point;
        var _local_7:Point;
        var _local_10:int;
        var _local_3:int = 20;
        var _local_4:int = int((ConfigurationData.CLIENT_WIDTH / _local_3));
        var _local_5:int = int((ConfigurationData.CLIENT_HEIGHT / _local_3));
        var _local_8:Array = [];
        var _local_9:int;
        while (_local_9 <= _local_4) {
            _local_10 = 0;
            while (_local_10 <= _local_5) {
                _local_6 = new Point((_local_9 * _local_3), (_local_10 * _local_3));
                if (testTxTy(_local_6, _arg_2)) {
                    _local_8.push({
                        "x": _local_6.x,
                        "y": _local_6.y,
                        "d": Math.abs(Point.distance(_arg_1, _local_6))
                    });
                }
                _local_10++;
            }
            _local_9++;
        }
        if (_local_8.length) {
            _local_8.sortOn(["d"], [Array.NUMERIC]);
            _local_7 = new Point(((_local_8[0].x + int((Math.random() * 10))) - 5), ((_local_8[0].y + int((Math.random() * 10))) - 5));
            while ((!(testTxTy(_local_7, _arg_2)))) {
                _local_7 = new Point(((_local_8[0].x + int((Math.random() * 10))) - 5), ((_local_8[0].y + int((Math.random() * 10))) - 5));
            }
            return (_local_7);
        }
        return null;
    }

    private function testTxTy(_arg_1:Point, _arg_2:MovieClip):Boolean {
        var _local_3:int = _arg_2.shadow.width;
        var _local_4:int = _arg_2.shadow.height;
        var _local_5:int = int((_arg_1.x - (_local_3 / 2)));
        var _local_6:int = int((_arg_1.y - (_local_4 / 2)));
        var _local_7:Rectangle = new Rectangle(_local_5, _local_6, _local_3, _local_4);
        var _local_8:Rectangle;
        var _local_9:MovieClip;
        var _local_10:Boolean;
        var _local_11:int;
        while (_local_11 < arrSolid.length) {
            _local_9 = MovieClip(arrSolid[_local_11].shadow);
            _local_8 = new Rectangle(_local_9.x, _local_9.y, _local_9.width, _local_9.height);
            _local_10 = (!(_local_8.intersects(_local_7)));
            _local_11++;
        }
        return (_local_10);
    }

    public function updatePortrait(avt:Avatar):void {
        var avtPortraits:Array;
        var avtPortrait:MovieClip;
        var numStars:int;
        var dataLeaf:Object;
        var pVal:*;
        var pMax:*;
        var pBar:*;
        var i:int;
        var j:int;

        avtPortraits = avt != myAvatar
                ? [game.ui.mcPortraitTarget]
                : avt == myAvatar.target
                        ? [game.ui.mcPortraitTarget, game.ui.mcPortrait]
                        : [game.ui.mcPortrait];

        i = 0;
        while (i < avtPortraits.length) {
            dataLeaf = {};

            avtPortrait = avtPortraits[i];
            avtPortrait.strName.mouseEnabled = false;
            avtPortrait.strClass.mouseEnabled = false;
            avtPortrait.strHPBar.mouseEnabled = false;
            avtPortrait.strHPBar.text = "";

            switch (avt.npcType) {
                case "monster":
                    dataLeaf = monTree[avt.objData.MonMapID];
                    avtPortrait.strName.text = avt.objData.strMonName.toUpperCase();
                    avtPortrait.strHPBar.text = dataLeaf.intHPBar <= 1 ? "" : "x" + dataLeaf.intHPBar;
                    avtPortrait.strClass.text = "Monster";
                    if ("stars" in avtPortrait) {
                        numStars = int(Math.round((Math.pow((avt.objData.intLevel * 1.3), 0.5) / 2)));
                        j = 1;
                        while (j < 6) {
                            avtPortrait.stars.getChildByName(("s" + j)).visible = j <= numStars;
                            j++;
                        }
                    }
                    break;
                case "player":
                    dataLeaf = uoTree[avt.pnm];
                    avtPortrait.strName.text = avt.objData.strUsername.toUpperCase();
                    avtPortrait.strClass.text = ((avt.objData.strClassName + ", Rank ") + avt.objData.iRank);

                    if (("stars" in avtPortrait)) {
                        j = 1;
                        while (j < 6) {
                            avtPortrait.stars.getChildByName(("s" + j)).visible = false;
                            j++;
                        }
                    }
                    break;
                case "npc":
                    dataLeaf = npcTree[avt.objData.NpcMapID];
                    avtPortrait.strName.text = avt.objData.strUsername.toUpperCase();
                    avtPortrait.strClass.text = "Npc";

                    if (("stars" in avtPortrait)) {
                        j = 1;
                        while (j < 6) {
                            avtPortrait.stars.getChildByName(("s" + j)).visible = false;
                            j++;
                        }
                    }
                    break;
            }

            if (avt.npcType == "monster" || avt.npcType == "player" || avt.npcType == "npc") {
                avtPortrait.strLevel.htmlText = myAvatar.objData.intLevel < avt.objData.intLevel ? ("<font color='#FF0000'>Lv. " + avt.objData.intLevel + "</font>") : ("Lv. " + avt.objData.intLevel);
                pVal = 0;
                pMax = 0;
                pBar = null;
                pVal = dataLeaf.intHP;
                pMax = dataLeaf.intHPMax;
                pBar = avtPortrait.HP;
				
                if (dataLeaf.intHP >= 0) {
                    pBar.strIntHP.text = String(dataLeaf.intHP);
                } else {
                    pBar.strIntHP.text = "X";
                }

                if (pVal < 0) {
                    pVal = 0;
                }
                if (pVal > pMax) {
                    pVal = pMax;
                }
                pBar.intHPbar.x = Math.min(-(pBar.intHPbar.width * (1 - (pVal / pMax))), 0);
                pVal = dataLeaf.intMP;
                pMax = dataLeaf.intMPMax;
                pBar = avtPortrait.MP;
                if (dataLeaf.intMP >= 0) {
                    pBar.strIntMP.text = String(dataLeaf.intMP);
                } else {
                    pBar.strIntMP.text = "X";
                }
                if (pVal < 0) {
                    pVal = 0;
                }
                if (pVal > pMax) {
                    pVal = pMax;
                }
                pBar.intMPbar.x = Math.min(-(pBar.intMPbar.width * (1 - (pVal / pMax))), 0);
            }

            i++;
        }
    }

    public function updatePetPortrait(avt:Avatar) : void {
        var avtPortrait:ui_243 = game.ui.mcPetPortrait;
        var petData:Object = game.copyObj(avt.petMC.objData.data);
        var pVal:Number = petData.intHP;
        var pMax:Number = petData.intHPMax;
        var pBar:MovieClip = avtPortrait.HP;

        avtPortrait.strName.mouseEnabled = false;
        avtPortrait.strName.text = petData.Name;
        avtPortrait.strLevel.text = "Lv." + petData.Level;

        if (petData.intHP >= 0) {
            pBar.strIntHP.text = String(petData.intHP);
        } else {
            pBar.strIntHP.text = "X";
        }

        if (pVal < 0) {
            pVal = 0;
        }
        if (pVal > pMax) {
            pVal = pMax;
        }

        pBar.intHPbar.x = Math.min(-(pBar.intHPbar.width * (1 - (pVal / pMax))), 0);
        pVal = petData.intMP;
        pMax = petData.intMPMax;
        pBar = avtPortrait.MP;

        if (petData.intMP >= 0) {
            pBar.strIntMP.text = String(petData.intMP);
        } else {
            pBar.strIntMP.text = "X";
        }
        if (pVal < 0) {
            pVal = 0;
        }
        if (pVal > pMax) {
            pVal = pMax;
        }

        pBar.intMPbar.x = Math.min(-(pBar.intMPbar.width * (1 - (pVal / pMax))), 0);

        pVal = petData.intSP;
        pMax = petData.intSPMax;
        pBar = avtPortrait.SP;

        if (petData.intSP >= 0) {
            pBar.strIntSP.text = String(petData.intSP);
        } else {
            pBar.strIntSP.text = "X";
        }
        if (pVal < 0) {
            pVal = 0;
        }
        if (pVal > pMax) {
            pVal = pMax;
        }

        pBar.intSPbar.x = Math.min(-(pBar.intSPbar.width * (1 - (pVal / pMax))), 0);
    }

    public function getAvatarByUserID(_arg_1:int):Avatar {
        var _local_2:String = String(_arg_1);
        if ((_local_2 in avatars)) {
            return (avatars[_local_2]);
        }
        return null;
    }

    public function getAvatarByUserName(_arg_1:String):Avatar {
        var _local_2:String;
        for (_local_2 in avatars) {
            if ((((!(avatars[_local_2] == null)) && (!(avatars[_local_2].pnm == null))) && (avatars[_local_2].pnm.toLowerCase() == _arg_1.toLowerCase()))) {
                return (avatars[_local_2]);
            }
        }
        return null;
    }

    public function getMCByUserName(_arg_1:*):AvatarMC
    {
        var _local_2:String;
        for (_local_2 in avatars)
        {
            if ((((!(avatars[_local_2] == null)) && (!(avatars[_local_2].pnm == null))) && (avatars[_local_2].pnm.toLowerCase() == _arg_1.toLowerCase())))
            {
                if (avatars[_local_2].pMC != null)
                {
                    return (avatars[_local_2].pMC);
                }
            }
        }
        return null;
    }

    public function getMCByUserID(_arg_1:*):AvatarMC {
        if (((!(avatars[_arg_1] == undefined)) && (!(avatars[_arg_1].pMC == null)))) {
            return (avatars[_arg_1].pMC);
        }
        return null;
    }

    public function getUoLeafById(_arg_1:*):Object {
        var _local_2:Object;
        for each (_local_2 in uoTree) {
            if (_local_2.entID == _arg_1) {
                return (_local_2);
            }
        }
        return null;
    }

    public function getUoLeafByName(_arg_1:String):Object {
        var _local_2:Object;
        _arg_1 = _arg_1.toLowerCase();
        for each (_local_2 in uoTree) {
            if (_local_2.uoName == _arg_1) {
                return (_local_2);
            }
        }
        return null;
    }

    public function getUserDataById(_arg_1:*):void {
        if (ConfigurationData.Debug)
        {
            trace("** WORLD getUserDataById >");
        }

        game.net.send("retrieveUserData", [_arg_1]);
    }

    public function getUserDataByIds(_arg_1:Array):void {
        if (ConfigurationData.Debug)
        {
            trace("** WORLD getUserDataByIds >");
        }

        game.net.send("retrieveUserDatas", _arg_1);
    }

    public function getUsersByCell(_arg_1:String):Array {
        var _local_3:String;
        var _local_2:Array = [];
        for (_local_3 in avatars) {
            if (avatars[_local_3].dataLeaf.strFrame == _arg_1) {
                _local_2.push(avatars[_local_3]);
            }
        }

        return (_local_2);
    }

    public function getAllAvatarsInCell():Array {
        return getMonstersByCell(myAvatar.dataLeaf.strFrame)
                .concat(getUsersByCell(myAvatar.dataLeaf.strFrame))
                .concat(getNpcsByCell(myAvatar.dataLeaf.strFrame));
    }

    private function lookAtValue(_arg_1:String, _arg_2:int):Number {
        return (parseInt(_arg_1.charAt(_arg_2), 36));
    }

    private function updateValue(_arg_1:*, _arg_2:int, _arg_3:Number):String {
        var _local_4:String;
        if (((_arg_3 >= 0) && (_arg_3 < 10))) {
            _local_4 = String(_arg_3);
        } else {
            if (((_arg_3 >= 10) && (_arg_3 < 36))) {
                _local_4 = String.fromCharCode((_arg_3 + 55));
            } else {
                _local_4 = "0";
            }
        }
        return (game.strSetCharAt(_arg_1, _arg_2, _local_4));
    }

    public function getQuestValue(_arg_1:Number):Number {
        var _local_2:int;
        var _local_3:String;
        if (((!(myAvatar == null)) && (!(myAvatar.objData == null)))) {
            _local_2 = int((_arg_1 / 100));
            _local_3 = ((_local_2 > 0) ? ("strQuests" + (_local_2 + 1)) : "strQuests");
            if (myAvatar.objData[_local_3] == null) {
                return (-1);
            }
            return (lookAtValue(myAvatar.objData[_local_3], (_arg_1 - (_local_2 * 100))));
        }
        return (-1);
    }

    public function setQuestValue(_arg_1:Number, _arg_2:Number):void {
        var _local_3:int = int((_arg_1 / 100));
        var _local_4:String = ((_local_3 > 0) ? ("strQuests" + (_local_3 + 1)) : "strQuests");
        if ((_local_4 in myAvatar.objData)) {
            myAvatar.objData[_local_4] = updateValue(myAvatar.objData[_local_4], (_arg_1 - (_local_3 * 100)), _arg_2);
        }
    }

    public function sendUpdateQuestRequest(_arg_1:Number, _arg_2:Number):void {
        game.net.send("updateQuest", [_arg_1, _arg_2]);
    }

    public function setHomeTownCurrent():void {
        game.net.send("setHomeTown", []);
        myAvatar.objData.strHomeTown = myAvatar.objData.strMapName;
    }

    public function setHomeTown(_arg_1:String):void {
        game.net.send("setHomeTown", [_arg_1]);
        myAvatar.objData.strHomeTown = _arg_1;
    }

    public function sendBankFromInvRequest(_arg_1:Object):* {
        var _local_2:ModalMC;
        var _local_3:Object;
        if (_arg_1.bEquip == 1) {
            _local_2 = new ModalMC();
            _local_3 = {};
            _local_3.strBody = "You must unequip the item before storing it in the bank!";
            _local_3.params = {};
            _local_3.glow = "red,medium";
            _local_3.btns = "mono";
            game.ui.ModalStack.addChild(_local_2);
            _local_2.init(_local_3);
        } else {
            if (((_arg_1.bGold == 0) && (myAvatar.iBankCount >= myAvatar.objData.iBankSlots))) {
                _local_2 = new ModalMC();
                _local_3 = {};
                _local_3.strBody = "You have exceeded your maximum bank storage for non-AC items!";
                _local_3.params = {};
                _local_3.glow = "red,medium";
                _local_3.btns = "mono";
                game.ui.ModalStack.addChild(_local_2);
                _local_2.init(_local_3);
            } else {
                game.net.send("bankFromInv", [_arg_1.ItemID, _arg_1.CharItemID]);
            }
        }
    }

    public function sendBankToInvRequest(_arg_1:Object):* {
        var _local_2:*;
        var _local_3:*;
        if (myAvatar.items.length >= myAvatar.objData.iBagSlots) {
            _local_2 = new ModalMC();
            _local_3 = {};
            _local_3.strBody = "You have exceeded your maximum inventory storage!";
            _local_3.params = {};
            _local_3.glow = "red,medium";
            _local_3.btns = "mono";
            game.ui.ModalStack.addChild(_local_2);
            _local_2.init(_local_3);
        } else {
            game.net.send("bankToInv", [_arg_1.ItemID, _arg_1.CharItemID]);
        }
    }

    public function feedPet(iSel:Object):* {
        this.game.net.send("petFeed", [iSel.ItemID, iSel.CharItemID]);
    }

    public function sendBankSwapInvRequest(_arg_1:Object, _arg_2:Object):* {
        var _local_3:ModalMC;
        var _local_4:Object;
        if (_arg_2.bEquip == 1) {
            _local_3 = new ModalMC();
            _local_4 = {};
            _local_4.strBody = "You must unequip the item before storing it in the bank!";
            _local_4.params = {};
            _local_4.glow = "red,medium";
            _local_4.btns = "mono";
            game.ui.ModalStack.addChild(_local_3);
            _local_3.init(_local_4);
        } else {
            if ((((_arg_2.bGold == 0) && (_arg_1.bGold == 1)) && (myAvatar.iBankCount >= myAvatar.objData.iBankSlots))) {
                _local_3 = new ModalMC();
                _local_4 = {};
                _local_4.strBody = "You have exceeded your maximum bank storage for non-AC items!";
                _local_4.params = {};
                _local_4.glow = "red,medium";
                _local_4.btns = "mono";
                game.ui.ModalStack.addChild(_local_3);
                _local_3.init(_local_4);
            } else {
                game.net.send("bankSwapInv", [_arg_2.ItemID, _arg_2.CharItemID, _arg_1.ItemID, _arg_1.CharItemID]);
            }
        }
    }

    public function getInventory(_arg_1:*):* {
        game.net.send("retrieveInventory", [_arg_1]);
    }

    public function sendChangeColorRequest(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int):void {
        game.net.send("changeColor", [_arg_1, _arg_2, _arg_3, _arg_4, hairshopinfo.HairShopID]);
    }

    public function sendChangeArmorColorRequest(_arg_1:int, _arg_2:int, _arg_3:int):void {
        game.net.send("changeArmorColor", [_arg_1, _arg_2, _arg_3]);
    }

    public function sendLoadBankRequest(_arg_1:Array = null):void {
        if (_arg_1[0] == "*") {
            _arg_1 = ["All"];
        }
        bankinfo.addRequestedTypes(_arg_1);
        game.net.send("loadBank", _arg_1);
    }

    public function sendReloadShopRequest(_arg_1:int):void {
        if ((((!(shopinfo == null)) && (shopinfo.ShopID == _arg_1)) && (!(shopinfo.bLimited == null)))) {
            game.net.send("reloadShop", [_arg_1]);
        }
    }

    public function sendLoadShopRequest(_arg_1:int):void {
        if (((shopinfo == null) || ((!(shopinfo.ShopID == _arg_1)) || (shopinfo.bLimited)))) {
            if (coolDown("loadShop")) {
                game.menuClose();
                game.net.send("loadShop", [_arg_1]);
            }
        } else {
            game.menuClose();
            if (shopinfo.bHouse == 1) {
                game.ui.mcPopup.fOpen("HouseShop");
            } else {
                if (game.isMergeShop(shopinfo)) {
                    game.ui.mcPopup.fOpen("MergeShop");
                } else {
                    game.ui.mcPopup.fOpen("Shop");
                }
            }
        }
    }

    public function sendLoadHairShopRequest(_arg_1:int):void {
        if (((hairshopinfo == null) || (!(hairshopinfo.HairShopID == _arg_1)))) {
            game.net.send("loadHairShop", [_arg_1]);
        } else {
            game.openCharacterCustomize();
        }
    }

    public function sendLoadEnhShopRequest(_arg_1:int):void {
        var _local_2:ModalMC = new ModalMC();
        var _local_3:Object = {};
        _local_3.strBody = "Old enhancement shops are disabled on the PTR.  Please visit Battleon for the new shops.";
        _local_3.params = {};
        _local_3.btns = "mono";
        game.ui.ModalStack.addChild(_local_2);
        _local_2.init(_local_3);
    }

    public function sendEnhItemRequest(_arg_1:Object):void {
        enhItem = _arg_1;
        game.net.send("enhanceItem", [_arg_1.ItemID, _arg_1.EnhID, enhShopID]);
    }

    public function sendEnhItemRequestShop(_arg_1:Object, _arg_2:Object):void {
        if (coolDown("buyItem")) {
            enhItem = _arg_1;
            game.net.send("enhanceItemShop", [_arg_1.ItemID, _arg_2.ItemID, shopinfo.ShopID]);
        }
    }

    public function sendEnhItemRequestLocal(_arg_1:Object, _arg_2:Object):void {
        if (coolDown("buyItem")) {
            enhItem = _arg_1;
            game.net.send("enhanceItemLocal", [_arg_1.ItemID, _arg_2.ItemID]);
        }
    }

    public function sendBuyItemRequest(o:Object):void {
        if (coolDown("buyItem")) {
            if (((o.bStaff == 1) && (myAvatar.objData.intAccessLevel < 40))) {
                game.MsgBox.notify("Test Item: Cannot be purchased yet!");
            } else {
                if (((!(shopinfo.sField == "")) && (!(getAchievement(shopinfo.sField, shopinfo.iIndex) == 1)))) {
                    game.MsgBox.notify("Item Locked: Special requirement not met.");
                } else {
                    if (((o.bUpg == 1) && (!(myAvatar.isUpgraded())))) {
                        game.showUpgradeWindow();
                    } else {
                        if (((o.FactionID > 1) && (myAvatar.getRep(o.FactionID) < o.iReqRep))) {
                            game.MsgBox.notify("Item Locked: Reputation Requirement not met.");
                        } else {
                            if (!game.validateArmor(o)) {
                                game.MsgBox.notify("Item Locked: Class Requirement not met.");
                            } else {
                                if (((o.iQSindex >= 0) && (getQuestValue(o.iQSindex) < int(o.iQSvalue)))) {
                                    game.MsgBox.notify("Item Locked: Quest Requirement not met.");
                                } else {
                                    if ((((myAvatar.isItemInInventory(o.ItemID)) || (myAvatar.isItemInBank(o.ItemID))) && (myAvatar.isItemStackMaxed(o.ItemID)))) {
                                        game.MsgBox.notify((("You cannot have more than " + o.iStk) + " of that item!"));
                                    } else {
                                        if ((o.bSilver == 0 && o.bGold == 0 && o.iCost > myAvatar.objData.intCopper) || (o.bSilver == 1 && o.iCost > myAvatar.objData.intSilver) || (o.bGold == 1 && o.iCost > myAvatar.objData.intGold)) {
                                            game.MsgBox.notify("Insufficient Funds!");
                                        } else {
                                            if ((((!(game.isHouseItem(o))) && (myAvatar.items.length >= myAvatar.objData.iBagSlots)) || ((game.isHouseItem(o)) && (myAvatar.houseitems.length >= myAvatar.objData.iHouseSlots)))) {
                                                game.MsgBox.notify("Inventory Full!");
                                            } else {
                                                if (((shopBuyItem == null) || (!(shopBuyItem.ShopItemID == o.ShopItemID)))) {
                                                    shopBuyItem = o;
                                                }
                                                game.net.send("buyItem", [shopBuyItem.ItemID, shopinfo.ShopID, shopBuyItem.ShopItemID]);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    public function sendBuyItemRequestWithQuantity(o:Object) : void
    {
        if (o.accept)
        {
            shopBuyItem = o.iSel;
            game.net.send("buyItem", [o.iSel.ItemID, shopinfo.ShopID, o.iSel.ShopItemID, o.iQty]);
        }
    }

    public function maximumShopBuys(_arg_1:Object):int
    {
        var _local_4:*;
        var _local_5:*;
        var _local_6:*;
        var _local_7:*;
        var _local_8:*;
        if (_arg_1 == null)
        {
            return (0);
        }
        var _local_2:* = myAvatar.getItemByID(_arg_1.ItemID);
        if (_arg_1.sES == "ar")
        {
            return (1);
        }
        var _local_3:Number = ((_local_2 != null) ? (_arg_1.iStk - _local_2.iQty) : _arg_1.iStk);
        if (_local_3 < 1)
        {
            return (0);
        }
        if (_arg_1.iCost > 0)
        {
            if (_arg_1.bGold == 1)
            {
                _local_4 = Math.floor(myAvatar.objData.intGold / _arg_1.iCost);
            }
            else if (_arg_1.bSilver == 1)
            {
                _local_4 = Math.floor(myAvatar.objData.intSilver / _arg_1.iCost);
            }
            else
            {
                _local_4 = Math.floor(myAvatar.objData.intGold / _arg_1.iCost);
            }

            _local_3 = Math.min(_local_4, _local_3);
        }
        if (_arg_1.turnin != null)
        {
            _local_5 = 0;
            while (_local_5 < _arg_1.turnin.length)
            {
                _local_6 = _arg_1.turnin[_local_5];
                _local_7 = myAvatar.getItemByID(_local_6.ItemID);
                if (_local_7 == null)
                {
                    return (0);
                }
                _local_8 = Math.floor((_local_7.iQty / _local_6.iQty));
                if (_local_8 == 0)
                {
                    return (0);
                }
                _local_3 = Math.min(_local_3, _local_8);
                _local_5++;
            }
            _local_3 = (_local_3 * _arg_1.iQty);
        }
        _local_3 = Math.min(_local_3, 100000);
        return (Math.min(_local_3, ((_local_2 != null) ? (_arg_1.iStk - _local_2.iQty) : _arg_1.iStk)));
    }

    public function sendSellItemRequest(_arg_1:Object):void {
        if (coolDown("sellItem")) {
            game.net.send("sellItem", [_arg_1.ItemID, _arg_1.iQty, _arg_1.CharItemID]);
        }
    }

    public function sendSellItemRequestWithQuantity(_arg_1:Object):*
    {
        if (_arg_1.accept)
        {
            if (coolDown("sellItem"))
            {
                game.net.send("sellItem", [_arg_1.iSel.ItemID, _arg_1.iQty, _arg_1.iSel.CharItemID]);
            }
        }
    }

    public function maximumShopSells(_arg_1:Object):int
    {
        if (_arg_1.sES == "ar") return 1;
        var _local_2:* = myAvatar.getItemByID(_arg_1.ItemID);
        return ((_local_2 == null) ? 0 : _local_2.iQty);
    }

    public function sendRemoveItemRequest(_arg_1:Object, _arg_2:int = 1):void {
        if (_arg_2 == 1) {
            game.net.send("removeItem", [_arg_1.ItemID, _arg_1.CharItemID]);
        } else {
            game.net.send("removeItem", [_arg_1.ItemID, _arg_1.CharItemID, _arg_2]);
        }
    }

    public function sendRemoveTempItemRequest(_arg_1:int, _arg_2:int):void {
        game.net.send("removeTempItem", [_arg_1, _arg_2]);
        myAvatar.removeTempItem(_arg_1, _arg_2);
    }

    public function sendEquipItemRequest(_arg_1:Object):Boolean {
        var _local_2:Boolean = true;
        if (((!(_arg_1 == null)) && (!(myAvatar.isItemEquipped(_arg_1.ItemID))))) {
            if (coolDown("equipItem")) {
                game.net.send("equipItem", [_arg_1.ItemID]);
            } else {
                _local_2 = false;
            }
        } else {
            _local_2 = false;
        }
        return (_local_2);
    }

    public function sendForceEquipRequest(_arg_1:int):void {
        game.net.send("forceEquipItem", [_arg_1]);
    }

    public function sendUnequipItemRequest(_arg_1:Object):void {
        if (((!(_arg_1 == null)) && (myAvatar.isItemEquipped(_arg_1.ItemID)))) {
            if (coolDown("unequipItem")) {
                game.net.send("unequipItem", [_arg_1.ItemID]);
            }
        }
    }

    public function sendChangeClassRequest(_arg_1:int):void {
        game.net.send("changeClass", [_arg_1]);
    }

    public function selfMute(_arg_1:int = 1):void {
        game.net.send("cmd", ["mute", _arg_1, "minutes", myAvatar.objData.strUsername.toLowerCase()]);
    }

    public function getAvailablePotionSlots() : String
    {
        if (!game.equipPotion1) // && !game.equipPotion2
            return "i1";
        else if (!game.equipPotion2) // && !game.equipPotion1
            return "i2";

        return "none";
    }

    public function equipUseableItem(itemObj:Object):void {
        if (getAvailablePotionSlots() == "none") {
            game.Modal("No available potion slots!", null, {}, "red,medium", "mono");
            return;
        }

        var actObj:Object = null;

        for each (var action:Object in actions.active) {
            if (!action) continue;

            if ((action.ref == "i1" && !game.equipPotion1) || (action.ref == "i2" && !game.equipPotion2)) {
                if (action.ref == "i1") game.equipPotion1 = true;
                else game.equipPotion2 = true;

                actObj = action;
                break;
            }
        }

        if (!actObj) return;

        actObj.sArg1 = String(itemObj.ItemID);
        actObj.sArg2 = String(itemObj.sDesc);

        game.updateIcons(getActIcons(actObj), [itemObj.sFile], itemObj);
        game.updateActionObjIcon(actObj);

        for each (var item:Object in myAvatar.items) {
            if (item.sType.toLowerCase() == "item" && item.sLink.toLowerCase() != "none" && item.ItemID == itemObj.ItemID && (!item.hasOwnProperty("bEquip") || item.bEquip == 0)) {
                item.bEquip = 1;
                item.bRef = actObj.ref;
                game.net.send("geia", [actObj.ref, item.sMeta]);
                break;
            }
        }

        if (myAvatar.isMyAvatar) {
            var inv:MovieClip = MovieClip(game.ui.mcPopup.getChildByName("mcInventory"));
            if (inv) inv.update({ eventType: "refreshItems" });
        }
    }

    public function unequipUseableItem(itemObj:Object):void {
        if (itemObj == null) {
            game.Modal("Unable to unequip!", null, {}, "red,medium", "mono");
            return;
        }

        var actObj:Object = null;

        for each (var action:Object in actions.active) {
            if (!action) continue;

            var ref:String = action.ref;

            if ((ref == "i1" && game.equipPotion1 && itemObj.bRef == "i1") || (ref == "i2" && game.equipPotion2 && itemObj.bRef == "i2")) {

                if (ref == "i1") game.equipPotion1 = false;
                else game.equipPotion2 = false;

                actObj = action;
                break;
            }
        }

        if (!actObj) return;

        var tempItemID:int = actObj.sArg1;

        actObj.sArg1 = "";
        actObj.sArg2 = "";
        game.updateIcons(getActIcons(actObj), ["icu1"], null);

        for each (var item:Object in myAvatar.items) {
            if (item.sType.toLowerCase() == "item" && item.sLink.toLowerCase() != "none" && item.ItemID == tempItemID && item.bEquip == 1) {
                item.bEquip = 0;
                break;
            }
        }

        if (myAvatar.isMyAvatar) {
            var inv:MovieClip = MovieClip(game.ui.mcPopup.getChildByName("mcInventory"));
            if (inv) inv.update({ eventType: "refreshItems" });
        }
    }


    public function tryUseItem(_arg_1:Object):void {
        if (_arg_1.sType.toLowerCase() == "clientuse") {
            switch (_arg_1.sLink) {
            }
        } else {
            if (_arg_1.sType.toLowerCase() == "serveruse") {
                sendUseItemRequest(_arg_1);
            }
        }
    }

    public function sendUseItemRequest(_arg_1:Object):void {
        game.net.send("serverUseItem", ["+", _arg_1.ItemID]);
    }

    public function sendUseItemArrayRequest(_arg_1:Array):void {
        game.net.send("serverUseItem", _arg_1);
    }

    public function bankHasRequested(_arg_1:Array):Boolean {
        return (bankinfo.hasRequested(_arg_1));
    }

    public function addItemsToBank(_arg_1:*):void {
        bankinfo.addItemsToBank(_arg_1);
    }

    public function toggleBank():void {
        if (!uiLock) {
            if (game.ui.mcPopup.currentLabel == "Bank") {
                MovieClip(game.ui.mcPopup.getChildByName("mcBank")).fClose();
            } else {
                game.ui.mcPopup.fOpen("Bank");
            }
        }
    }

    public function sendReport(_arg_1:Array):void {
        game.net.send("cmd", _arg_1);
    }

    public function sendWhoRequest():void {
        if (coolDown("who")) {
            game.net.send("cmd", ["who"]);
        }
    }

    public function sendRewardReferralRequest(_arg_1:*):void {
        game.net.send("rewardReferral", []);
    }

    public function sendGetAdDataRequest():void {
        if (game.world.myAvatar.objData.iDailyAds < game.world.myAvatar.objData.iDailyAdCap) {
            game.net.send("getAdData", []);
        }
    }

    public function sendGetAdRewardRequest():void {
        if (game.world.myAvatar.objData.iDailyAds < game.world.myAvatar.objData.iDailyAdCap) {
            game.net.send("getAdReward", []);
        }
    }

    public function sendWarVarsRequest():void {
        game.net.send("loadWarVars", []);
    }

    public function loadQuestStringData():void {
        game.net.send("loadQuestStringData", []);
    }

    public function buyBagSlots(_arg_1:int):void {
        game.net.send("buyBagSlots", [_arg_1]);
    }

    public function buyBankSlots(_arg_1:int):void {
        game.net.send("buyBankSlots", [_arg_1]);
    }

    public function buyHouseSlots(_arg_1:int):void {
        game.net.send("buyHouseSlots", [_arg_1]);
    }

    public function sendLoadFriendsListRequest():* {
        game.net.send("loadFriendsList", []);
    }

    public function sendLoadFactionRequest():* {
        game.net.send("loadFactions", []);
    }

    public function initAchievements():void {
        var _local_2:* = myAvatar.objData;
        with (_local_2) {
            ip0 = uint(ip0);
            ia0 = uint(ia0);
            ia1 = uint(ia1);
            id0 = uint(id0);
            id1 = uint(id1);
            id2 = uint(id2);
            im0 = uint(im0);
            iq0 = uint(iq0);
        }
    }

    public function getAchievement(_arg_1:String, _arg_2:int):int {
        if (((_arg_2 < 0) || (_arg_2 > 31))) {
            return (-1);
        }
        var _local_3:* = myAvatar.objData[_arg_1];
        if (_local_3 == null) {
            return (-1);
        }
        return (((_local_3 & Math.pow(2, _arg_2)) == 0) ? 0 : 1);
    }

    public function setAchievement(_arg_1:String, _arg_2:int, _arg_3:int = 1):void {
        var _local_4:* = ["ia0", "iq0"];
        if (((((_local_4.indexOf(_arg_1) >= 0) && (_arg_2 >= 0)) && (_arg_2 < 32)) && (!(getAchievement(_arg_1, _arg_2) == _arg_3)))) {
            game.net.send("setAchievement", [_arg_1, _arg_2, _arg_3]);
        }
    }

    public function updateAchievement(_arg_1:String, _arg_2:int, _arg_3:int):void {
        if (_arg_3 == 0) {
            myAvatar.objData[_arg_1] = (myAvatar.objData[_arg_1] & (~(Math.pow(2, _arg_2))));
        } else {
            if (_arg_3 == 1) {
                myAvatar.objData[_arg_1] = (myAvatar.objData[_arg_1] | Math.pow(2, _arg_2));
            }
        }
        game.readIA1Preferences();
    }

    public function showGuildList():void {
        if (myAvatar.objData.guild != null) {
            game.ui.mcPopup.fOpen("GuildPanel");
        } else {
            game.MsgBox.notify("You need to create or join a guild first.");
        }
    }

    public function isModerator(_arg_1:String):void {
        game.net.send("isModerator", [_arg_1]);
    }

    public function toggleName(_arg_1:*, _arg_2:String):* {
        if (_arg_2 == "on") {
            getMCByUserID(_arg_1).pname.visible = true;
        }
        if (_arg_2 == "off") {
            getMCByUserID(_arg_1).pname.visible = false;
        }
    }

    public function toggleHPBar():void {
        var avt:Avatar;
        var umc:MovieClip;

        showHPBar = !showHPBar;

        for (var uid:String in avatars) {
            avt = avatars[uid];
            if (avt.pMC != null) {
                umc = avt.pMC;
                if (showHPBar) {
                    umc.showHPBar();
                } else {
                    umc.hideHPBar();
                }
            }
        }

        for (var i:int = 0; i < npcs.length; i++)
        {
            avt = npcs[i];

            if (avt.pMC != null)
            {
                umc = avt.pMC;
                if (showHPBar) {
                    umc.showHPBar();
                } else {
                    umc.hideHPBar();
                }
            }
        }
    }

    public function resPlayer():* {
        afkPostpone();
        game.net.send("resPlayerTimed", [game.net.myUserId]);
    }

    public function showResCounter():* {
        var _local_1:* = MovieClip(game.ui.mcRes);
        if (_local_1.currentLabel == "in") {
            return;
        }
        _local_1.gotoAndPlay("in");
        _local_1.resC = 10;
        if (_local_1.resTimer == null) {
            _local_1.resTimer = new Timer(1000);
            _local_1.resTimer.addEventListener("timer", resTimer);
        } else {
            _local_1.resTimer.reset();
        }
        _local_1.resTimer.start();
    }

    public function resTimer(_arg_1:TimerEvent):* {
        var _local_2:* = MovieClip(game.ui.mcRes);
        _local_2.resC--;
        if (_local_2.resC > 0) {
            _local_2.mcTomb.ti.text = ("0" + _local_2.resC);
        } else {
            _local_2.mcTomb.ti.text = "00";
            _arg_1.target.reset();
            _local_2.visible = false;
            _local_2.gotoAndStop(1);
            resPlayer();
        }
    }

    public function rest():void {
        if (!restTimer.running) {
            myAvatar.pMC.mcChar.gotoAndPlay("Rest");
            game.net.send("emotea", ["rest"]);
            restStart();
        }
    }

    public function restStart():* {
        afkPostpone();
        restTimer.reset();
        restTimer.start();
    }

    public function restRequest(_arg_1:TimerEvent):* {
        var _local_2:* = getUoLeafById(myAvatar.uid);
        if (((((!(_local_2.intHP == _local_2.intHPMax)) || (!(_local_2.intMP == _local_2.intMPMax))) && (myAvatar.pMC.mcChar.currentLabel == "Rest")) && (_local_2.intState == 1))) {
            if (coolDown("rest")) {
                game.net.send("restRequest", [""]);
                restTimer.reset();
                restTimer.start();
            } else {
                restStart();
            }
        } else {
            restTimer.reset();
        }
    }

    public function afkToggle():void {
        var _local_1:* = uoTree[game.net.myUserName];
        if (_local_1 != null) {
            game.net.send("afk", [(!(_local_1.afk))]);
        }
    }

    public function afkPostpone():void {
        var now:* = new Date().getTime();
        var _local_2:* = uoTree[game.net.myUserName];
        if ((((!(_local_2 == null)) && (_local_2.afk)) && ((_local_2.afkts == null) || (now > (_local_2.afkts + 500))))) {
            game.net.send("afk", [false]);
            _local_2.afkts = now;
        }
    }

    public function hideAllPets(_arg_1:Boolean = true):void {
        var _local_2:*;
        for (_local_2 in avatars) {
            if (!((!(_arg_1)) && (avatars[_local_2] == myAvatar))) {
                if (avatars[_local_2] != null) {
                    avatars[_local_2].unloadPet();
                }
            }
        }
    }

    public function showAllPets(_arg_1:Boolean = true):void {
        var _local_2:*;
        var _local_3:Object;
        var _local_4:*;
        for (_local_2 in avatars) {
            if (!((!(_arg_1)) && (avatars[_local_2] == myAvatar))) {
                _local_3 = getUoLeafById(_local_2);
                _local_4 = String(_local_3.strFrame);
                if (_local_4 == strFrame) {
                    avatars[_local_2].loadPet();
                }
            }
        }
    }

    public function updateMonsters():* {
        var _local_1:int;
        if (monmap != null) {
            _local_1 = 0;
            while (_local_1 < monmap.length) {
                if (monmap[_local_1].strFrame == strFrame) {
                    updateMonster(monmap[_local_1]);
                }
                _local_1++;
            }
        }
    }

    public function updateNpcs():void {
        var i:int = 0;
        for each(var npc:Object in npcmap) {
            trace("updateNpcs > " + JSON.stringify(npc));
            if (npc.strFrame == strFrame) {
//                npc.avatarMC = npc.avatarMC == null ? new AvatarMC() : npc.avatarMC;
//                new ApopNpc(this, npcs[i], npc, i);
                updateNpc(npc);
            }
            i++;
        }
    }

    public function updateMonster(obj:Object):void {
        var mon:Avatar = getMonster(obj.MonMapID);
        if (mon.pMC == null) {
            if (ConfigurationData.Debug)
            {
                trace((">> Monster Pad Missing - MonMapID:" + obj.MonMapID));
            }
            return;
        }

        mon.objData.intMPMax = int(mon.objData.intMPMax);
        mon.objData.intHPMax = int(mon.objData.intMPMax);
        var monObj:Object = monTree[obj.MonMapID];
        if (monObj.MonID != mon.objData.MonID || monObj.intState == 0) {
            mon.pMC.visible = false;
        }
        if ((mon.pMC.x - myAvatar.pMC.x) >= 0) {
            mon.pMC.turn("left");
        }
        mon.pMC.updateNamePlate();
    }

    public function updateNpc(obj:Object):void {
        var pAV:Avatar = getNpc(obj.NpcMapID);
        try {
            if (pAV.pMC == null) {
                if (ConfigurationData.Debug)
                {
                    trace((">> Npc Pad Missing - NpcMapID:" + obj.NpcMapID));
                }
                return;
            }
        } catch (e:Error) {

        }

        pAV.objData.intMPMax = int(pAV.objData.intMPMax);
        pAV.objData.intHPMax = int(pAV.objData.intMPMax);
        var npcObj:Object = npcTree[obj.NpcMapID];
        if (((!(npcObj.NpcID == pAV.objData.NpcID)) || (npcObj.intState == 0))) {
            pAV.pMC.visible = false;
        }
        if ((pAV.pMC.x - myAvatar.pMC.x) >= 0) {
            pAV.pMC.turn("left");
        }
//        pAV.pMC.updateNamePlate();
    }

    public function createMonsterMC(monPad:MovieClip, MonID:int, randomName:Boolean = false):MonsterMC {
        var monMC:MonsterMC;
        var rand:int;
        var AssetClass:Class;
        var monObj:Object = mondef[MonID]; // getMonsterDefinition(MonID);

        if (randomName) {
            rand = int(Math.round((Math.random() * (chaosNames.length - 1))));
            if (chaosNames[rand] != game.world.myAvatar.objData.strUsername) {
                monMC = new MonsterMC(chaosNames[rand]);
            } else {
                rand = ((rand == 0) ? ++rand : --rand);
                monMC = new MonsterMC(chaosNames[rand]);
            }
        } else {
            if (Number((objExtra["bChar"] == 1))) {
                monMC = new MonsterMC(myAvatar.objData.strUsername);
            } else {
                monMC = new MonsterMC(monObj.strMonName);
            }
        }

        monMC.name = monObj.strMonName;
        CHARS.addChild(monMC);
        monMC.x = monPad.x;
        monMC.y = monPad.y;
        monMC.ox = monMC.x;
        monMC.oy = monMC.y;

        if (Number((objExtra["bChar"] == 1))) {
            monMC.removeChildAt(1);
            monMC.addChildAt((new dummyMC() as MovieClip), 1);
            copyAvatarMC((monMC.getChildAt(1) as MovieClip));
        } else if (!game.preference.data.bDisLoadMon && game.cache.monsterContext.applicationDomain.hasDefinition(monObj.strLinkage)) {
            try {
                monMC.removeChildAt(1);
                AssetClass = (game.cache.monsterContext.applicationDomain.getDefinition(monObj.strLinkage) as Class);
                monMC.addChildAt(new (AssetClass)(), 1);
            } catch (e:Error) {
                trace("CREATE MOSNTER MC => " + e.getStackTrace());
            }
        }
        monMC.mouseEnabled = false;
        monMC.bubble.mouseEnabled = (monMC.bubble.mouseChildren = false);
        monMC.init();
        if (("strDir" in monPad)) {
            if (monPad.strDir == "static") {
                monMC.isStatic = true;
            }
        }
        if (("noMove" in monPad)) {
            monMC.noMove = monPad.noMove;
        }
        return (monMC);
    }

    public function getMonDataById():* {
    }

    public function retrieveMonData():* {
        game.net.send("retrieveMonData", []);
    }

    private function getMonID(_arg_1:int):int {
        var _local_2:String;
        var _local_3:*;
        for (_local_2 in monTree) {
            _local_3 = monTree[_local_2];
            if (_local_3.MonMapID == _arg_1) {
                return (_local_3.MonID);
            }
        }
        return (-1);
    }

//    private function getMonsterDefinition(_arg_1:int):Object {
//        var _local_2:int = 0;
//        while (_local_2 < mondef.length) {
//            if (mondef[_local_2].MonID == _arg_1) {
//                return (mondef[_local_2]);
//            }
//            _local_2++;
//        }
//        return (null);
//    }

    private function getNpcDefinition(_arg_1:int):Object {
        var _local_2:int = 0;
        while (_local_2 < npcdef.length) {
            if (npcdef[_local_2].MonID == _arg_1) {
                return (npcdef[_local_2]);
            }
            _local_2++;
        }
        return null;
    }

    public function getMonster(monMapId:int):Avatar {
        for each (var avt:Avatar in monsters) {
            if (avt.objData.MonMapID == monMapId && avt.objData.MonID == monTree[monMapId].MonID) {
                return avt;
            }
        }
        return null;
    }

    public function getNpc(npcMapId:int):Avatar {
        for each (var avt:Avatar in npcs) {
            if (avt.objData.NpcMapID == npcMapId && avt.objData.NpcID == npcTree[npcMapId].NpcID) {
                return avt;
            }
        }
        return null;
    }

    public function getMonsters(_arg_1:int):Array {
        var _local_2:Array = [];
        var _local_3:int = 0;
        while (_local_3 < monsters.length) {
            if (monsters[_local_3].objData.MonMapID == _arg_1) {
                _local_2.push(monsters[_local_3]);
            }
            _local_3++;
        }
        if (_local_2.length > 0) {
            return (_local_2);
        }
        return null;
    }

    public function getNpcs(_arg_1:int):Array {
        var _local_2:Array = [];
        var _local_3:int = 0;
        while (_local_3 < npcs.length) {
            if (npcs[_local_3].objData.NpcMapID == _arg_1) {
                _local_2.push(npcs[_local_3]);
            }
            _local_3++;
        }
        if (_local_2.length > 0) {
            return (_local_2);
        }
        return null;
    }

    public function getMonsterCluster(_arg_1:int):Array {
        var _local_2:* = [];
        var _local_3:int = 0;
        while (_local_3 < monsters.length) {
            if (monsters[_local_3].objData.MonMapID == _arg_1) {
                _local_2.push(monsters[_local_3]);
            }
            _local_3++;
        }
        return (_local_2);
    }

    public function getNpcCluster(_arg_1:int):Array {
        var _local_2:* = [];
        var _local_3:int = 0;
        while (_local_3 < npcs.length) {
            if (npcs[_local_3].objData.NpcMapID == _arg_1) {
                _local_2.push(npcs[_local_3]);
            }
            _local_3++;
        }

        return (_local_2);
    }

    public function getMonstersByCell(_arg_1:String):Array {
        var _local_2:Array = [];
        var _local_3:int;
        while (_local_3 < monsters.length) {
            if (((!(monsters[_local_3].dataLeaf == null)) && (monsters[_local_3].dataLeaf.strFrame == _arg_1))) {
                _local_2.push(monsters[_local_3]);
            }
            _local_3++;
        }

        return (_local_2);
    }

    public function getNpcsByCell(_arg_1:String):Array {
        var _local_2:Array = [];
        var _local_3:int = 0;
        while (_local_3 < npcs.length) {
            if (((!(npcs[_local_3].dataLeaf == null)) && (npcs[_local_3].dataLeaf.strFrame == _arg_1))) {
                _local_2.push(npcs[_local_3]);
            }
            _local_3++;
        }

        return (_local_2);
    }

    public function initMonsters(definition:Object, map:Array) : void {
        if (definition == null || map.length < 1) return;

        game.mcConnDetail.showConn("Loading Monsters...");

        var prop:String;

        queue = new Queue();
        monswf = [];
        monsters = [];

        for each (var mapMonster:Object in map)
        {
            var monObj:Object = definition[mapMonster.MonID];

            if (monObj == null) continue;

            var mon:Avatar = new Avatar(game);
            mon.npcType = "monster";

            if (mon.objData == null) mon.objData = {};

            for (prop in monObj) mon.objData[prop] = monObj[prop];
            for (prop in mapMonster) mon.objData[prop] = mapMonster[prop];

            var monLeaf:Object = monTree[String(mon.objData.MonMapID)];
            monLeaf.strFrame = String(mon.objData.strFrame);
            mon.dataLeaf = monLeaf.MonID == mon.objData.MonID ? monTree[mon.objData.MonMapID] : null;

            monsters.push(mon);
        }

        if (game.preference.data.bDisLoadMon)
        {
            initNpcs(npcdef, npcmap);
        }
        else
        {
            for (prop in definition)
            {
                if (prop == "len") continue;

                var strFile:String = definition[prop].strMonFileName;

                queue.add("mon/" + strFile, String(definition[prop].strLinkage), function (event:Event) : void
                {
                    monswf.push("Leght");

                    if (monswf.length == mondef.len)
                    {
                        initNpcs(npcdef, npcmap);
                    }
                    else
                    {
                        queue.next();
                    }
                }, function (event:ProgressEvent) : void {
                    game.mcConnDetail.showConn("Loading Monster (" + queue.File.replace("mon/", "") + ") " + (int(event.bytesLoaded / event.bytesTotal) * 100) + "%");
                }, game.cache.monsterContext);
            }
        }
    }

    public function initNpcs(md:Array, mp:Array):void {
        var npcObj:Object;
        var j:int;
        var Npc:*;
        var prop:*;
        var npcLeaf:*;
        var i:int;
        if (((!(md == null)) && (!(mp == null))))
        {
            npcs = [];
            npcObj = null;
            i = 0;
            while (i < mp.length)
            {
                j = 0;
                while (j < md.length)
                {
                    if (mp[i].NpcID == md[j].NpcID)
                    {
                        npcObj = md[j];
                    }
                    j++;
                }
                npcs.push(new Avatar(game));
                Npc = npcs[(npcs.length - 1)];
                Npc.npcType = "npc";
                if (Npc.objData == null) Npc.objData = {};

                for (prop in npcObj) Npc.objData[prop] = npcObj[prop];
                for (prop in mp[i]) Npc.objData[prop] = mp[i][prop];

                npcLeaf = npcTree[String(Npc.objData.NpcMapID)];
                npcLeaf.strFrame = String(Npc.objData.strFrame);

                Npc.dataLeaf = npcLeaf.NpcID == Npc.objData.NpcID ? npcTree[Npc.objData.NpcMapID] : null;

                i++;
            }

        }

        enterMap();
    }

//    public function toggleMonsters():* {
//        var _local_1:DisplayObject;
//        game.ui.monsterIcon.redX.visible = showMonsters;
//        showMonsters = (!(showMonsters));
//        var _local_2:int;
//        while (_local_2 < CHARS.numChildren) {
//            _local_1 = CHARS.getChildAt(_local_2);
//            if (((_local_1.hasOwnProperty("isMonster")) && (MovieClip(_local_1).isMonster))) {
//                MovieClip(_local_1).setVisible();
//            }
//            _local_2++;
//        }
//    }

    public function setTarget(_arg_1:*):* {
        if (myAvatar != null && !myAvatar.target != _arg_1) {
            if (myAvatar.target != null) {

                if (myAvatar.target.npcType == "monster") {
                    if ((((bPvP) && (!(myAvatar.target.dataLeaf.react == null))) && (myAvatar.target.dataLeaf.react[myAvatar.dataLeaf.pvpTeam] == 1))) {
                        myAvatar.target.pMC.modulateColor(avtPCT, "-");
                    } else {
                        myAvatar.target.pMC.modulateColor(avtMCT, "-");
                    }
                }
                if (myAvatar.target.npcType == "player") {
                    if (((bPvP) && (!(myAvatar.target.dataLeaf.pvpTeam == myAvatar.dataLeaf.pvpTeam)))) {
                        myAvatar.target.pMC.modulateColor(avtMCT, "-");
                    } else {
                        myAvatar.target.pMC.modulateColor(avtPCT, "-");
                    }
                }
                if (myAvatar.target.npcType == "npc")
                {
                    if (myAvatar.target.objData.strBehave != "Ally")
                    {
                        myAvatar.target.pMC.modulateColor(avtMCT, "-");
                    }
                    else
                    {
                        myAvatar.target.pMC.modulateColor(avtPCT, "-");
                    }
                }
            }
            if (_arg_1 != null) {
                if (((!(bPvP)) && (_arg_1.npcType == "player"))) {
                    if (autoActionTimer != null) {
                        cancelAutoAttack();
                    }
                }
                myAvatar.target = _arg_1;
                if (myAvatar.target.npcType == "monster") {
                    if ((((bPvP) && (!(myAvatar.target.dataLeaf.react == null))) && (myAvatar.target.dataLeaf.react[myAvatar.dataLeaf.pvpTeam] == 1))) {
                        myAvatar.target.pMC.modulateColor(avtPCT, "+");
                    } else {
                        myAvatar.target.pMC.modulateColor(avtMCT, "+");
                    }
                }
                if (myAvatar.target.npcType == "player") {
                    if (((bPvP) && (!(myAvatar.target.dataLeaf.pvpTeam == myAvatar.dataLeaf.pvpTeam)))) {
                        myAvatar.target.pMC.modulateColor(avtMCT, "+");
                    } else {
                        myAvatar.target.pMC.modulateColor(avtPCT, "+");
                    }
                }

                if (myAvatar.target.npcType == "npc")
                {
                    trace("SET TARGET > DEBUG 2 > OBJ DATA > " + myAvatar.target.npcType + " > " + JSON.stringify(myAvatar.target.objData));
                    trace("SET TARGET > DEBUG 2 > DATE LEAF >  " + myAvatar.target.npcType + " > " + JSON.stringify(myAvatar.target.dataLeaf));
                    // THERE'S NO STRBEHAVER IN OBJDATA MAYBE TRY TO DATELEAF

                    if (myAvatar.target.objData.strBehave != "Ally")
                    {
                        myAvatar.target.pMC.modulateColor(avtMCT, "+");
                    }
                    else
                    {
                        myAvatar.target.pMC.modulateColor(avtPCT, "+");
                    }
                }

                game.showPortraitTarget(_arg_1);
            } else {
                game.hidePortraitTarget();
                if (myAvatar.dataLeaf.intState > 0) {
                    exitCombat();
                }
                myAvatar.target = null;
            }
        }
    }

    public function cancelTarget():void {
        if (((!(autoActionTimer == null)) && (autoActionTimer.running))) {
            cancelAutoAttack();
            myAvatar.pMC.mcChar.gotoAndStop("Idle");
            return;
        }
        if (myAvatar.target != null) {
            setTarget(null);

        }
    }

    public function approachTarget():* {
        var _local_3:Object;
        var _local_5:Boolean;
        var _local_6:Point;
        var _local_7:Point;
        var _local_8:Number;
        var _local_9:Number;
        var _local_10:int;
        var _local_11:int;
        var _local_12:int;
        var _local_13:int;
        var _local_14:int;
        var _local_15:int;
        var _local_16:*;
        var _local_17:*;
        var _local_18:*;
        var _local_19:int;
        var _local_20:int;
        var _local_21:Array;
        var _local_22:Array;

        if (ConfigurationData.Debug)
        {
            trace("approach target");
        }

        var _local_1:Boolean = true;
        var _local_2:Object = uoTree[game.net.myUserName];
        var _local_4:Object = getAutoAttack();

        if (myAvatar.target != null) {
            switch (myAvatar.target.npcType)
            {
                case "monster":
                    _local_3 = monTree[myAvatar.target.objData.MonMapID];
                    break;
                case "player":
                    _local_3 = myAvatar.target.dataLeaf;
                    break;
                case "npc":
                    _local_3 = npcTree[myAvatar.target.objData.NpcMapID];
                    break;
                default:
                    if (ConfigurationData.Debug)
                    {
                        trace("target is not null");
                    }
                    break;
            }

            if (_local_3 == null || (_local_2.intState == 0) || _local_3.intState == 0) {
                _local_1 = false;
            }
            if ((((bPvP) && (((!(_local_3.react == null)) && (_local_3.react[_local_2.pvpTeam] == 1)) || (_local_2.pvpTeam == _local_3.pvpTeam))) || ((!(bPvP)) && (myAvatar.target.npcType == "player")))) {
                _local_1 = false;
            }
            if (_local_1) {
                game.mixer.playSound("ClickBig");
                if (_local_4 != null) {
                    if (actionRangeCheck(_local_4)) {
                        testAction(_local_4);
                    } else {
                        actionReady = true;
                        _local_5 = false;
                        _local_6 = myAvatar.pMC.mcChar.localToGlobal(new Point(0, 0));
                        _local_7 = myAvatar.target.pMC.mcChar.localToGlobal(new Point(0, 0));
                        if (_local_4.range > 301) {
                            _local_8 = Point.distance(_local_6, _local_7);
                            _local_9 = (_local_4.range * SCALE);
                            _local_9 = (_local_9 * 0.9);
                            if (_local_9 < _local_8) {
                                _local_7 = Point.interpolate(_local_6, _local_7, (_local_9 / _local_8));
                            }
                            _local_5 = (!(padHit(_local_7.x, _local_7.y, myAvatar.pMC.shadow.getBounds(game.stage))));
                        } else {
                            _local_10 = 0;
                            while (((_local_10 < 100) && (!(_local_5)))) {
                                _local_11 = int(int((50 + (Math.random() * 110))));
                                if (_local_10 > 50) {
                                    _local_11 = (_local_11 * -1);
                                }
                                _local_12 = (((_local_7.x - _local_6.x) >= 0) ? -(_local_11) : _local_11);
                                _local_13 = int(((Math.random() * 40) - 20));
                                _local_12 = Math.ceil((_local_12 * SCALE));
                                _local_13 = Math.floor((_local_13 * SCALE));
                                _local_14 = (_local_7.x + _local_12);
                                _local_15 = (_local_7.y + _local_13);
                                _local_5 = (!(padHit(_local_14, _local_15, myAvatar.pMC.shadow.getBounds(game.stage))));
                                _local_10++;
                            }
                            _local_7.x = (_local_7.x + _local_12);
                            _local_7.y = (_local_7.y + _local_13);
                        }
                        if (_local_5) {
							if (bPvP)
							{
								myAvatar.pMC.walkTo(_local_7.x, _local_7.y, WALKSPEED);
								pushMove(myAvatar.pMC, _local_7.x, _local_7.y, WALKSPEED);
							}
							else
							{
								myAvatar.pMC.walkTo(_local_7.x, _local_7.y, (WALKSPEED * 2));
								pushMove(myAvatar.pMC, _local_7.x, _local_7.y, (WALKSPEED * 2));
							}
                        } else {
                            game.chatF.pushMsg("server", "No path found!", "SERVER", "", 0);
                        }
                    }
                }
            }
        } else {
            if (ConfigurationData.Debug)
            {
                trace("target exists");
            }

            _local_16 = myAvatar;
            _local_17 = null;
            _local_18 = null;
            _local_19 = (("tgtMin" in _local_4) ? _local_4.tgtMin : 1);
            _local_20 = (("tgtMax" in _local_4) ? _local_4.tgtMax : 1);
            _local_21 = [];
            _local_22 = getAllAvatarsInCell();
            for each (_local_17 in _local_22) {
                _local_3 = _local_17.dataLeaf;
                if (
                        _local_3 != null && (!bPvP && _local_17.npcType == "monster"
                        || (!bPvP && _local_17.npcType == "npc")
                        || bPvP && _local_17.npcType == "player" && _local_2.pvpTeam != _local_3.pvpTeam
                        || bPvP && _local_17.npcType == "monster" && _local_3.react != null && _local_3.react[_local_2.pvpTeam] == 0) && actionRangeCheck(_local_4, _local_17))
                {
                    setTarget(_local_17);
                    testAction(_local_4);
                    return;
                }
            }
            game.chatF.pushMsg("warning", "No target selected!", "SERVER", "", 0);
        }
    }

    public function padHit(_arg_1:int, _arg_2:int, _arg_3:Rectangle):Boolean {
        var _local_5:Rectangle;
        var _local_6:MovieClip;
        var _local_4:int;
        if (((((_arg_1 < 0) || (_arg_1 > ConfigurationData.CLIENT_WIDTH)) || (_arg_2 < 10)) || (_arg_2 > ConfigurationData.CLIENT_HEIGHT - 20))) {
            return false;
        }
        _arg_3.x = int((_arg_1 - (_arg_3.width / 2)));
        _arg_3.y = int((_arg_2 - (_arg_3.height / 2)));
        _local_4 = 0;
        while (_local_4 < arrEvent.length) {
            _local_6 = arrEvent[_local_4];
            if ((("strSpawnCell" in _local_6) || ("tCell" in _local_6))) {
                _local_5 = arrEventR[_local_4];
                if (_arg_3.intersects(_local_5)) {
                    return true;
                }
            }
            _local_4++;
        }
        return false;
    }

    public function drawRects(_arg_1:Array):void {
        var _local_5:Rectangle;
        var _local_2:Array = [0xFF0000, 0xFF00, 0xFF];
        var _local_3:Sprite = new Sprite();
        var _local_4:Graphics = _local_3.graphics;
        var _local_6:int;
        _local_6 = 0;
        while (_local_6 < _arg_1.length) {
            _local_5 = _arg_1[_local_6];
            _local_4.moveTo(_local_5.x, _local_5.y);
            _local_4.beginFill(_local_2[_local_6], 0.3);
            _local_4.lineTo((_local_5.x + _local_5.width), _local_5.y);
            _local_4.lineTo((_local_5.x + _local_5.width), (_local_5.y + _local_5.height));
            _local_4.lineTo(_local_5.x, (_local_5.y + _local_5.height));
            _local_4.lineTo(_local_5.x, _local_5.y);
            _local_4.endFill();
            _local_6++;
        }
    }

    public function testAction(actionObj:Object, forceAARangeError:Boolean = false):* {
        var tLeaf:Object;
        var aura:Object;
        var pet:* = undefined;
        var tgtOK:Boolean;
        var sAvt:Avatar;
        var to:Object;
        var now:Number;
        var a:int;
        var b:int;
        var c:int;
        var cLeaf:Object = uoTreeLeaf(game.net.myUserName);
        var cAvt:* = myAvatar;
        var tAvt:* = null;
        var pAvt:* = null;
        var tgtMin:int = (("tgtMin" in actionObj) ? actionObj.tgtMin : 1);
        var tgtMax:int = (("tgtMax" in actionObj) ? actionObj.tgtMax : 1);
        var targets:Array = [];
        var scan:Array = getAllAvatarsInCell();

        a = 0;
        while (a < scan.length) {
            tAvt = scan[a];
            if ((((tAvt.dataLeaf == null) || (tAvt.dataLeaf.intState == 0)) || ((tAvt.pMC == null) || (tAvt.pMC.x == null)))) {
                scan.splice(a, 1);
                a = (a - 1);
                if (tAvt == myAvatar.target) {
                    setTarget(null);
                }
            }
            a = (a + 1);
        }
        a = 0;
        tAvt = null;
        if (((!(myAvatar.target == null)) && (scan.indexOf(myAvatar.target) > -1))) {
            scan.unshift(scan.splice(scan.indexOf(myAvatar.target), 1)[0]);
        }

        afkPostpone();
        var errMsg:String = "none";
        var forceAAloop:Boolean;
        if (!actionTimeCheck(actionObj)) {
            errMsg = (("Ability '" + actionObj.nam) + "' is not ready yet.");
        }
        if ((((errMsg == "none") && (!(actionObj.mp == null))) && (Math.round((actionObj.mp * cLeaf.sta["$cmc"])) > cLeaf.intMP))) {
            errMsg = "Not enough mana!";
        }
        if (((errMsg == "none") && (!(actionObj.sp == null)))) {
            if (!checkSP(actionObj.sp, cLeaf)) {
                errMsg = "Not Enough Spirit Power!";
            }
        }
        if (errMsg == "none" && (actionObj.ref == "i1" || actionObj.ref == "i2") && actionObj.sArg1 == "") {
            errMsg = "No item assigned to that slot!";
        }
        if ((((((errMsg == "none") && (!(myAvatar.target == null))) && ("filter" in actionObj)) && ("sRace" in myAvatar.target.objData)) && (!(myAvatar.target.objData.sRace.toLowerCase() == actionObj.filter.toLowerCase())))) {
            errMsg = (("Target is not a " + actionObj.filter) + "!");
        }
        if (errMsg == "none") {
            for each (aura in cLeaf.auras) {
                try {
                    if (aura.cat != null) {
                        if (aura.cat == "stun") {
                            errMsg = "Cannot act while stunned!";
                        }
                        if (aura.cat == "stone") {
                            errMsg = "Cannot act while petrified!";
                        }
                        if (aura.cat == "disabled") {
                            errMsg = "Cannot act while disabled!";
                        }
                        if (errMsg != "none") {
                            forceAAloop = true;
                        }
                    }
                } catch (e:Error) {
                }
            }
        }
        if (errMsg == "none") {
            if (actionObj.pet != null) {
                pet = cAvt.getItemByEquipSlot("pe");
                if (cAvt.getItemByEquipSlot("pe") == null) {
                    if (cAvt.checkTempItem(actionObj.pet, 1)) {
                        summonPet(actionObj.pet, true);
                    } else {
                        summonPet(actionObj.pet, false);
                    }
                }
            } else {
                if (actionObj.checkPet != null) {
                    if (cAvt.getItemByEquipSlot("pe").sMeta.indexOf(actionObj.checkPet) == -1) {
                        errMsg = "No battle pet equipped.";
                    }
                }
            }
        }

        if (((errMsg == "none") || (forceAAloop))) {
            if (myAvatar.target != null) {
                tAvt = myAvatar.target;

                if (tAvt.npcType == "monster") {
                    tLeaf = monTree[tAvt.objData.MonMapID];
                } else if (tAvt.npcType == "player") {
                    tLeaf = tAvt.dataLeaf;
                } else if (tAvt.npcType == "npc") {
                    tLeaf = npcTree[tAvt.objData.NpcMapID];
                }
            }

            switch (actionObj.tgt) {
                case "h":
                    if (tAvt == null) {
                        if (tgtMin > 0) {
                            for each (tAvt in scan) {
                                tLeaf = tAvt.dataLeaf;
                                if (tLeaf != null && (
                                        !bPvP && tAvt.npcType == "monster"
                                        || bPvP && (tAvt.npcType == "player" && cLeaf.pvpTeam != tLeaf.pvpTeam || bPvP && tAvt.npcType == "monster" && tLeaf.react != null && tLeaf.react[cLeaf.pvpTeam] == 0 || tAvt.npcType == "npc" && tAvt.objData.strBehave != "Ally")
                                ) && actionRangeCheck(actionObj, tAvt)) {
                                    setTarget(tAvt);
                                    testAction(actionObj);
                                    return;
                                }
                            }
                            errMsg = "No target selected!";
                            if (actionObj.typ == "aa") {
                                cancelAutoAttack();
                            }
                        }
                    } else {
                        if (((((!(bPvP)) && (tAvt.npcType == "player")) || (((bPvP) && (tAvt.npcType == "player")) && (cLeaf.pvpTeam == tLeaf.pvpTeam))) || ((((bPvP) && (tAvt.npcType == "monster")) && (!(tLeaf.react == null))) && (tLeaf.react[cLeaf.pvpTeam] == 1)) || (!bPvP && tAvt.npcType == "npc" && tAvt.objData.strBehave == "Ally"))) {
                            errMsg = "Can't attack that target!";
                            if (actionObj.typ == "aa") {
                                cancelAutoAttack();
                            }
                        }
                        if (((tgtMin > 0) && (tAvt.dataLeaf.intState == 0))) {
                            errMsg = "Your target is dead!";
                        }
                    }
                    break;
                case "f":
                    if (tAvt == null) {
                        setTarget(myAvatar);
                        tAvt = myAvatar;
                        tLeaf = tAvt.dataLeaf;
                    }
                    if (((((!(bPvP)) && (tAvt.npcType == "monster")) || (!bPvP && tAvt.npcType == "player") || (!bPvP && tAvt.npcType == "npc" && tAvt.objData.strBehave == "Ally") || ((bPvP) && (!(cLeaf.pvpTeam == tLeaf.pvpTeam)))) || ((((bPvP) && (tAvt.npcType == "monster")) && (!(tLeaf.react == null))) && (tLeaf.react[cLeaf.pvpTeam] == 1)))) {
                        tAvt = myAvatar;
                    }
                    tLeaf = tAvt.dataLeaf;
                    break;
                case "s":
                    if (tAvt == null) {
                        setTarget(myAvatar);
                        tAvt = myAvatar;
                    }
                    if (((!(tAvt == null)) && (!(tAvt == myAvatar)))) {
                        tAvt = myAvatar;
                    }
                    tLeaf = tAvt.dataLeaf;
                    break;
            }
            pAvt = tAvt;
            if ((((errMsg == "none") && (!(actionRangeCheck(actionObj, pAvt)))) || (forceAAloop))) {
                if (!forceAAloop) {
                    errMsg = "You are out of range!  Move closer to your target!";
                }
                if (actionObj.typ == "aa") {
                    autoActionTimer.delay = 500;
                    autoActionTimer.reset();
                    autoActionTimer.start();
                }
            }
            tgtOK = true;
            if (errMsg == "none") {

                while (scan.length > 0) {
                    tAvt = scan[0];
                    tLeaf = tAvt.dataLeaf;
                    tgtOK = true;
                    if (tLeaf.intState == 0) {
                        tgtOK = false;
                    }
                    if ((((!(tAvt == null)) && ("filter" in actionObj)) && ("sRace" in tAvt.objData))) {
                        if (tAvt.objData.sRace.toLowerCase() != actionObj.filter.toLowerCase()) {
                            tgtOK = false;
                        }
                    }
                    switch (actionObj.tgt) {
                        case "h":
                            if (
                                    (!bPvP && tAvt.npcType == "player") ||
                                    (bPvP && tAvt.npcType == "player" && cLeaf.pvpTeam == tLeaf.pvpTeam) ||
                                    (bPvP && tAvt.npcType == "monster" && tLeaf.react != null && tLeaf.react[cLeaf.pvpTeam] == 1) ||
                                    (bPvP && tAvt.npcType == "npc") ||
                                    (!bPvP && tAvt.npcType == "npc" && tAvt.objData.strBehave == "Ally")
                            ) {
                                tgtOK = false;
                            }
                            break;
                        case "f":
                            if (((((!(bPvP)) && (tAvt.npcType == "monster")) || (!bPvP && tAvt.npcType == "npc" && tAvt.objData.strBehave != "Ally") || ((bPvP) && (!(cLeaf.pvpTeam == tLeaf.pvpTeam)))) || ((((bPvP) && (tAvt.npcType == "monster")) && (!(tLeaf.react == null))) && (tLeaf.react[cLeaf.pvpTeam] == 1)))) {
                                trace("tgtOK > " + tAvt.npcType);
								tgtOK = false;
                            }
                            break;
                        case "s":
                            if (((!(tAvt == null)) && (!(tAvt == myAvatar)))) {
                                tgtOK = false;
                            }
                            break;
                    }
                    if (tgtOK) {
                        sAvt = myAvatar;
                        if (((actionObj.fx == "c") && (targets.length > 0))) {
                            sAvt = targets[(targets.length - 1)].avt;
                        }
                        a = Math.abs((tAvt.pMC.x - sAvt.pMC.x));
                        b = Math.abs((tAvt.pMC.y - sAvt.pMC.y));
                        c = Math.pow(((a * a) + (b * b)), 0.5);
                        if (actionRangeCheck(actionObj, tAvt)) {
                            targets.push({
                                "avt": tAvt,
                                "d": c,
                                "hp": tLeaf.intHP
                            });
                        }
                    }
                    scan.shift();
                }
            }
            targets.sortOn("hp", Array.NUMERIC);
            if (pAvt != null) {
                a = 0;
                while (a < targets.length) {

                    to = targets[a];

                    if (to.avt == pAvt) {
                        targets.unshift(targets.splice(a, 1)[0]);
                    }
                    a = (a + 1);
                }
            }
            if (targets.length > tgtMax) {
                targets = targets.splice(0, tgtMax);
            }
            if (targets.length > 0) {
                if (pAvt != null) {
                    if (((!(targets[0].avt == null)) && (!(targets[0].avt.dataLeaf == null)))) {
                        tAvt = targets[0].avt;
                        tLeaf = tAvt.dataLeaf;
                    } else {
                        tAvt = null;
                        tLeaf = null;
                    }
                } else {
                    tAvt = null;
                    tLeaf = null;
                }
            }
        }

        if (errMsg == "none") {
            if (cLeaf.intState != 0) {

                if ((((!(actionObj.lock)) && ((tLeaf == null) || (!(tLeaf.intState == 0)))) && (targets.length >= tgtMin))) {
                    doAction(actionObj, targets);
                }
                if (((myAvatar.target == null) || ((tLeaf == null) || (tLeaf.intState == 0)))) {
                    exitCombat();
                }
            }
        } else {
            now = new Date().getTime();
            if (((errMsg == "You are out of range!  Move closer to your target!") && ((!(actionObj.typ == "aa")) || (forceAARangeError)))) {
                if ((now - actionRangeSpamTS) > 3000) {
                    actionRangeSpamTS = now;
                    game.chatF.pushMsg("warning", errMsg, "SERVER", "", 0);
                }
            } else {
                if (actionObj.typ != "aa") {
                    game.chatF.pushMsg("warning", errMsg, "SERVER", "", 0);
                }
            }
        }
    }

    public function summonPet(_arg_1:int, _arg_2:Boolean):* {
        if (_arg_2) {
            game.net.send("equipItem", [_arg_1]);
        } else {
            game.net.send("summonPet", [_arg_1]);
        }
    }

    public function autoActionHandler(_arg_1:TimerEvent):* {
        if (ConfigurationData.Debug)
        {
            trace("* autoActionHandler >");
        }

        if ((((((!(myAvatar.dataLeaf == null)) && (!(myAvatar.dataLeaf.intState == 0))) && (!(myAvatar.target == null))) && (!(myAvatar.target.dataLeaf == null))) && (!(myAvatar.target.dataLeaf.intState == 0)))) {
            testAction(getAutoAttack(), true);
        } else {
            exitCombat();
        }
    }

    public function getAutoAttack():Object {
        var _local_1:* = 0;
        while (_local_1 < actions.active.length) {
            if ((((!(actions.active[_local_1] == null)) && (!(actions.active[_local_1].auto == null))) && actions.active[_local_1].auto)) {
                return (actions.active[_local_1]);
            }
            _local_1++;
        }
        return null;
    }

    public function exitCombat():* {
        var _local_1:int;
        actionReady = false;
        if (((!(actions == null)) && (!(actions.active == null)))) {
            _local_1 = 0;
            while (_local_1 < actions.active.length) {
                actions.active[_local_1].lock = false;
                _local_1++;
            }
        }
        if (myAvatar != null) {
            if (((((!(myAvatar.pMC == null)) && (!(myAvatar.pMC.mcChar == null))) && (!(myAvatar.pMC.mcChar.onMove))) && (!(myAvatar.pMC.mcChar.currentLabel == "Rest")))) {
                myAvatar.pMC.mcChar.gotoAndStop("Idle");
            }
            if (myAvatar.dataLeaf != null) {
                myAvatar.dataLeaf.targets = {};
            }
            cancelAutoAttack();
        }
    }

    public function cancelAutoAttack():* {
        var icon:MovieClip;
        if (autoActionTimer != null) {
            autoActionTimer.reset();
        }
        var i:* = 0;
        while (i < actionMap.length) {
            try {
                if (actionMap[i] == "aa") {
                    icon = MovieClip(game.ui.mcInterface.actBar.getChildByName(("i" + (i + 1))));
                    icon.bg.gotoAndStop(1);
                }
            } catch (e:Error) {
            }
            i++;
        }
    }

    public function doAction(_arg_1:*, _arg_2:*):* {
        var _local_3:Avatar;

        if (ConfigurationData.Debug)
        {
            trace(("doAction > " + _arg_1.nam));
        }

        afkPostpone();
        if (_arg_2.length > 0) {
            _local_3 = _arg_2[0].avt;
            if (_local_3 != myAvatar) {
                if ((_local_3.pMC.x - myAvatar.pMC.x) >= 0) {
                    myAvatar.pMC.turn("right");
                } else {
                    myAvatar.pMC.turn("left");
                }
            }
        }
        var _local_4:int = 0;
        while (_local_4 < _arg_2.length) {
            _local_3 = _arg_2[_local_4].avt;
            switch (_local_3.npcType) {
                case "monster":
                    if (myAvatar.dataLeaf.targets[_local_3.objData.MonMapID] == null) {
                        myAvatar.dataLeaf.targets[_local_3.objData.MonMapID] = "m";
                    }
                    break;
                case "player":
                    if (myAvatar.dataLeaf.targets[_local_3.objData.uid] == null) {
                        myAvatar.dataLeaf.targets[_local_3.objData.uid] = "p";
                    }
                    break;
                case "npc":
                    if (myAvatar.dataLeaf.targets[_local_3.objData.NpcMapID] == null)
                    {
                        myAvatar.dataLeaf.targets[_local_3.objData.NpcMapID] = "n";
                    }
                    break;
            }
            _local_4++;
        }
        getActionResult(_arg_1, _arg_2);
    }

    public function aggroMap(cInf:String, tInf:String, isHeal:Boolean):void
    {
        var mi:*;
        var testMonLeaf:*;
        var cType:String = cInf.split(":")[0];
        var cID:String = cInf.split(":")[1];
        var tType:String = tInf.split(":")[0];
        var tID:String = tInf.split(":")[1];

        var cLeaf:Object = {}; // cType == "p" || cType == "t" ? getUoLeafById(cID) : monTree[cID];
        var tLeaf:Object = {}; // tType == "p" || tType == "t" ? getUoLeafById(tID) : monTree[tID];

        if (cType == "p" || cType == "t")
            cLeaf = getUoLeafById(cID);
        else if (cType == "m")
            cLeaf = monTree[cID];
        else if (cType == "n")
            cLeaf = npcTree[cID];

        if (tType == "p" || tType == "t")
            tLeaf = getUoLeafById(tID);
        else if (tType == "m")
            tLeaf = monTree[tID];
        else if (tType == "n")
            tLeaf = npcTree[tID];

        if (!("targets" in cLeaf)) cLeaf.targets = {};
        if (!("targets" in tLeaf)) tLeaf.targets = {};

        if (tType == "m" || tType == "n")
        {
            if (!(tID in cLeaf.targets))
            {
                cLeaf.targets[tID] = tType;
            }
            if (!(cID in tLeaf.targets))
            {
                tLeaf.targets[cID] = cType;
            }
        }

        if (cType == "p" && tType == "p" && isHeal)
        {
            for (mi in monTree)
            {
                testMonLeaf = monTree[mi];
                if (((!(testMonLeaf.targets[tID] == null)) && (!(cID in testMonLeaf.targets))))
                {
                    testMonLeaf.targets[cID] = cType;
                }
            }
        }
    }

//    public function aggroMap(_arg_1:String, _arg_2:String, _arg_3:*):void {
//        var _local_12:*;
//        var _local_13:*;
//        var _local_4:String = _arg_1.split(":")[0];
//        var _local_5:String = _arg_1.split(":")[1];
//        var _local_6:String = _arg_2.split(":")[0];
//        var _local_7:String = _arg_2.split(":")[1];
//        var _local_8:* = "";
//        var _local_9:* = "";
//        var _local_10:Object = {};
//        var _local_11:Object = {};
//
//        if (_local_4 == "p") { // SINCE PET IS NOT ALLOWED TO PVP DISABLE THE PET ATTACK
//            _local_10 = getUoLeafById(_local_5);
//        } else {
//            _local_10 = monTree[_local_5];
//        }
//
//        if (_local_6 == "p" || _local_6 == "t") {
//            _local_11 = getUoLeafById(_local_7);
//        } else {
//            _local_11 = monTree[_local_7];
//        }
//
//        if (!("targets" in _local_10)) {
//            _local_10.targets = {};
//        }
//
//        if (!("targets" in _local_11)) {
//            _local_11.targets = {};
//        }
//
//        if (_local_6 == "m") {
//            if (!(_local_7 in _local_10.targets)) {
//                _local_10.targets[_local_7] = _local_6;
//            }
//            if (!(_local_5 in _local_11.targets)) {
//                _local_11.targets[_local_5] = _local_4;
//            }
//        }
//
//        if ((((_local_4 == "p") && (_local_6 == "p")) && (_arg_3))) {
//            for (_local_12 in monTree) {
//                _local_13 = monTree[_local_12];
//                if (((!(_local_13.targets[_local_7] == null)) && (!(_local_5 in _local_13.targets)))) {
//                    _local_13.targets[_local_5] = _local_4;
//                }
//            }
//        }
//    }

    private function actionTimeCheck(_arg_1:*):Boolean {
        var _local_4:int;

        if (ConfigurationData.Debug)
        {
            trace("actionTimeCheck >");
        }

        var _local_2:Number = new Date().getTime();
        var _local_3:Number = (1 - Math.min(Math.max(myAvatar.dataLeaf.sta.$tha, -1), 0.5));
        if (_arg_1.auto) {
            if (autoActionTimer.running) {
                return false;
            }
            return true;
        }
        if ((_local_2 - GCDTS) < GCD) {
            return false;
        }
        if (_arg_1.OldCD != null) {
            _local_4 = Math.round((_arg_1.OldCD * _local_3));
        } else {
            _local_4 = Math.round((_arg_1.cd * _local_3));
        }
        if ((_local_2 - _arg_1.ts) >= _local_4) {
            delete _arg_1.OldCD;
            return true;
        }
        return false;
    }

    private function actionRangeCheck(_arg_1:*, _arg_2:Avatar = null):Boolean {
        var _local_3:Point;
        var _local_4:Point;
        var _local_5:*;
        var _local_6:*;
        var _local_7:*;
        var _local_8:*;

        if (((_arg_2 == null) && (!(myAvatar.target == null)))) {
            _arg_2 = myAvatar.target;
        }
        if (_arg_2 == myAvatar) {
            return true;
        }
        if ((("tgtMin" in _arg_1) && (_arg_1.tgtMin == 0))) {
            return true;
        }
        if (_arg_2 == null) {
            return false;
        }
        _local_3 = myAvatar.pMC.mcChar.localToGlobal(new Point(0, 0));
        _local_4 = _arg_2.pMC.mcChar.localToGlobal(new Point(0, 0));
        _local_5 = Math.abs((_local_4.x - _local_3.x));
        _local_6 = Math.abs((_local_4.y - _local_3.y));
        _local_7 = Math.pow(((_local_5 * _local_5) + (_local_6 * _local_6)), 0.5);
        _local_8 = (_arg_1.range * SCALE);
        if (_arg_1.range <= 301) {
            if (((_local_5 <= _local_8) && (_local_6 <= (30 * SCALE)))) {
                return true;
            }
            return false;
        }
        if (_local_7 <= _local_8) {
            return true;
        }
        return false;
    }

    public function aggroAllMon():* {
        var _local_2:*;
        var _local_1:* = [];
        for (_local_2 in monTree) {
            if (monTree[_local_2].strFrame == strFrame) {
                _local_1.push(_local_2);
            }
        }
        aggroMons(_local_1);
    }

    public function aggroMon(_arg_1:*):* {
        var _local_2:* = [];
        _local_2.push(_arg_1);
        aggroMons(_local_2);
    }

    public function aggroMons(_arg_1:*):* {
        if (_arg_1.length) {
            game.net.send("aggroMon", _arg_1);
        }
    }

    public function castSpellFX(cAvt:*, spFX:*, spell:*, dur:int = 0):* {
        var tAvt:Avatar;
        var AssetClass:Class;
        var spellFX:*;
        var targetMCs:Array;
        var i:int;

        try {
            if (((!(showAnimations)) || (((cAvt) && (!(cAvt.isMyAvatar))) && (!(cAvt.pMC.mcChar.visible)))))
            {
                cAvt.pMC.clearSpFXQueue();
                return;
            }

            if (game.preference.data.bDisSkillAnim)
            {
                if (((!(game.preference.data.bAnimSelf)) || (((game.preference.data.bAnimSelf) && (cAvt)) && (!(cAvt.isMyAvatar)))))
                {
                    cAvt.pMC.clearSpFXQueue();
                    return;
                }
            }

            if ((((!(spFX.strl == null)) && (!(spFX.strl == ""))) && (!(spFX.avts == null))))
            {
                targetMCs = [];
                i = 0;
                if (spFX.fx == "c")
                {
                    if (spFX.strl == "lit1")
                    {
                        targetMCs.push(cAvt.pMC.mcChar);
                        i = 0;
                        while (i < spFX.avts.length)
                        {
                            tAvt = spFX.avts[i];
                            if ((((!(tAvt == null)) && (!(tAvt.pMC == null))) && (!(tAvt.pMC.mcChar == null))))
                            {
                                targetMCs.push(tAvt.pMC.mcChar);
                            }
                            i = (i + 1);
                        }
                        if (targetMCs.length > 1)
                        {
                            AssetClass = (getClass("sp_C1") as Class);
                            if (AssetClass != null)
                            {
                                spellFX = new (AssetClass)();
                                spellFX.mouseEnabled = false;
                                spellFX.mouseChildren = false;
                                spellFX.visible = true;
                                spellFX.world = MovieClip(this);
                                spellFX.strl = spFX.strl;
                                game.drawChainsLinear(targetMCs, 33, MovieClip(CHARS.addChild(spellFX)));
                            }
                        }
                    }
                }
                else
                {
                    if (spFX.fx == "f")
                    {
                        targetMCs.push(cAvt.pMC.mcChar);
                        tAvt = spFX.avts[0];
                        if ((((!(tAvt == null)) && (!(tAvt.pMC == null))) && (!(tAvt.pMC.mcChar == null))))
                        {
                            targetMCs.push(tAvt.pMC.mcChar);
                        }
                        if (targetMCs.length > 1)
                        {
                            spellFX = new MovieClip();
                            spellFX.mouseEnabled = false;
                            spellFX.mouseChildren = false;
                            spellFX.visible = true;
                            spellFX.world = MovieClip(this);
                            spellFX.strl = spFX.strl;
                            game.drawFunnel(targetMCs, MovieClip(CHARS.addChild(spellFX)));
                        }
                    }
                    else
                    {
                        i = 0;
                        while (i < spFX.avts.length)
                        {
                            tAvt = spFX.avts[i];
                            if (tAvt != null)
                            {
                                if (tAvt.pMC != null)
                                {
                                    AssetClass = (getClass(spFX.strl) as Class);
                                    if (AssetClass != null)
                                    {
                                        spellFX = new (AssetClass)();
                                        spellFX.spellDur = dur;
                                        if (spell != null)
                                        {
                                            spellFX.transform = spell.transform;
                                        }
                                        CHARS.addChild(spellFX);
                                        spellFX.mouseEnabled = false;
                                        spellFX.mouseChildren = false;
                                        spellFX.visible = true;
                                        spellFX.world = MovieClip(this);
                                        spellFX.strl = spFX.strl;
                                        spellFX.tMC = tAvt.pMC;
                                        switch (spFX.fx)
                                        {
                                            case "p":
                                                spellFX.x = cAvt.pMC.x;
                                                spellFX.y = (cAvt.pMC.y - (cAvt.pMC.mcChar.height * 0.5));
                                                spellFX.dir = (((tAvt.pMC.x - cAvt.pMC.x) >= 0) ? 1 : -1);
                                                break;
                                            case "w":
                                                spellFX.x = spellFX.tMC.x;
                                                spellFX.y = (spellFX.tMC.y + 3);
                                                if (cAvt != null)
                                                {
                                                    if (spellFX.tMC.x < cAvt.pMC.x)
                                                    {
                                                        spellFX.scaleX = (spellFX.scaleX * -1);
                                                    }
                                                }
                                                break;
                                        }
                                    }
                                }
                            }
                            i = (i + 1);
                        }
                    }
                }
            }
        } catch (e) {
            cAvt.pMC.clearSpFXQueue();
        }
    }

    public function showSpellFXHit(_arg_1:*):* {
        var _local_2:* = {};
        switch (_arg_1.strl) {
            case "sp_ice1":
                _local_2.strl = "sp_ice2";
                break;
            case "sp_el3":
                _local_2.strl = "sp_el2";
                break;
            case "sp_ed3":
                _local_2.strl = "sp_ed1";
                break;
            case "sp_ef1":
            case "sp_ef6":
                _local_2.strl = "sp_ef2";
                break;
        }
        _local_2.fx = "w";
        _local_2.avts = [_arg_1.tMC.pAV];
        castSpellFX(null, _local_2, null);
    }

    public function doCastIA(_arg_1:Object):void {
    }

    public function getActionByActID(_arg_1:int):Object {
        var _local_2:Object;
        var _local_3:int;
        while (_local_3 < actions.active.length) {
            if (actions.active[_local_3].actID == _arg_1) {
                _local_2 = actions.active[_local_3];
            }
            _local_3++;
        }
        return (_local_2);
    }

    public function getActionByRef(_arg_1:String):Object {
        var _local_2:*;
        for each (_local_2 in actions.active) {
            if (_local_2.ref == _arg_1) {
                return (_local_2);
            }
        }
        for each (_local_2 in actions.passive) {
            if (_local_2.ref == _arg_1) {
                return (_local_2);
            }
        }
        return null;
    }

    public function handleSAR(resObj:Object):void {
        var o:Object = {};
        var cTyp:* = "";
        var cID:int = -1;
        var tTyp:* = "";
        var tID:int = -1;
        if (resObj.iRes == 1) {
            if (game.bAnalyzer && game.bAnalyzer.isRunning)
            {
                var cInf:Array = resObj.actionResult.cInf.split(":");
                var tInf:Array = resObj.actionResult.tInf.split(":");

                if (cInf[0] == "p")
                {
                    if (cInf[1] == game.net.myUserId)
                    {
                        if (resObj.actionResult.hp >= 0)
                        {
                            game.bAnalyzer.addDamage(resObj.actionResult.hp);
                        }
                        else
                        {
                            game.bAnalyzer.addHeal((resObj.actionResult.hp * -1));
                        }
                    }
                }
                else if (tInf[0] == "p")
                {
                    if (tInf[1] == game.net.myUserId)
                    {
                        if (resObj.actionResult.hp >= 0)
                        {
                            game.bAnalyzer.addReceived(resObj.actionResult.hp);
                        }
                        else
                        {
                            game.bAnalyzer.addHeal((resObj.actionResult.hp * -1));
                        }
                    }
                }
            }

            if (resObj.actionResult.typ == "d" || resObj.actionResult.typ == "bleed" || resObj.actionResult.typ == "toxic") {
                showAuraImpact(resObj.actionResult);
                o = game.copyObj(resObj.actionResult);
                o.a = [game.copyObj(resObj.actionResult)];
            } else {
                aggroMap(resObj.actionResult.cInf, resObj.actionResult.tInf, (resObj.actionResult.hp >= 0));

				cTyp = resObj.actionResult.cInf.split(":")[0];
                cID = int(resObj.actionResult.cInf.split(":")[1]);
                tTyp = resObj.actionResult.tInf.split(":")[0];
                tID = int(resObj.actionResult.tInf.split(":")[1]);
                o = game.copyObj(resObj.actionResult);
                o.a = [game.copyObj(resObj.actionResult)];

                if (cTyp == "p" && cID == game.net.myUserId || cTyp == "t" || cTyp == "n") {
                    showActionResult(o, o.actID);
                } else {
                    showIncomingAttackResult(o);
                }
            }
        }
        if (resObj.iRes == 0) {
            switch (resObj.actionResult.cInf.split(":")[0]) {
                case "p":
                    showActionResult(null, resObj.actID);
                    break;
                case "t":
                    showActionResult(null, resObj.actID);
                    break;
                case "n":
                    showActionResult(null, resObj.actID);
                    break;
            }
        }
    }

    public function handleSARS(_arg_1:Object):void {
        var _local_3:* = "";
        var _local_4:int = -1;
        var _local_7:String = _arg_1.cInf;
        _local_3 = _local_7.split(":")[0];
        _local_4 = int(_local_7.split(":")[1]);
        var _local_8:Object = {};
        if (_arg_1.iRes == 1) {
            var i:int = 0;
            while (i < _arg_1.a.length) {
                if (game.bAnalyzer && game.bAnalyzer.isRunning)
                {
                    if (_local_3 == "p")
                    {
                        if (_local_4 == game.net.myUserId)
                        {
                            if (_arg_1.a[i].hp >= 0)
                            {
                                game.bAnalyzer.addDamage(_arg_1.a[i].hp);
                            }
                            else
                            {
                                game.bAnalyzer.addHeal((_arg_1.a[i].hp * -1));
                            }
                        }
                    }
                    else
                    {
                        if (_arg_1.a[i].tInf.split(":")[0] == "p")
                        {
                            if (_arg_1.a[i].tInf.split(":")[1] == game.net.myUserId)
                            {
                                if (_arg_1.a[i].hp >= 0)
                                {
                                    game.bAnalyzer.addReceived(_arg_1.a[i].hp);
                                }
                                else
                                {
                                    game.bAnalyzer.addHeal((_arg_1.a[i].hp * -1));
                                }
                            }
                        }
                    }
                }

                _local_8 = _arg_1.a[i];
                aggroMap(_local_7, _local_8.tInf, (_local_8.hp >= 0));
                i++;
            }

            if (_local_3 == "p" && _local_4 == game.net.myUserId || _local_3 == "n") {
                showActionResult(game.copyObj(_arg_1), _arg_1.actID);
            } else {
                showIncomingAttackResult(game.copyObj(_arg_1));
            }
        }
        if (_arg_1.iRes == 0) {
            switch (_local_7.split(":")[0]) {
                case "p":
                    showActionResult(null, _arg_1.actID);
                    return;
                case "t":
                    showActionResult(null, _arg_1.actID);
                    return;
                case "n":
                    showActionResult(null, _arg_1.actID);
                    return;
            }
        }
    }

    public function getActionResult(_arg_1:*, _arg_2:*):* {
        var xtArr:*;
        var cmd:*;
        var tgtStr:String;
        var tAvt:Avatar;
        var i:int;
        var now:Number;
        var icon:*;

        xtArr = [];
        cmd = "gar";
        tgtStr = "";
        i = 0;
        xtArr.push(actionID);
        if (_arg_2.length > 0) {
            i = 0;
            while (i < _arg_2.length) {
                tAvt = _arg_2[i].avt;
                if (i > 0) {
                    tgtStr = (tgtStr + ",");
                }

                tgtStr = (tgtStr + (_arg_1.ref + ">"));

                if (tAvt.npcType == "monster") {
                    tgtStr = (tgtStr + ("m:" + tAvt.objData.MonMapID));
                }
                if (tAvt.npcType == "player") {
                    tgtStr = (tgtStr + ("p:" + tAvt.uid));
                }
                if (tAvt.npcType == "npc") {
                    tgtStr = (tgtStr + ("n:" + tAvt.objData.NpcMapID));
                }
                i++;
            }
        } else {
            tgtStr = (tgtStr + (_arg_1.ref + ">"));
        }
        xtArr.push(tgtStr);
        if (_arg_1.ref == "i1" || _arg_1.ref == "i2") {
            xtArr.push(_arg_1.sArg1);
        }
        xtArr.push("wvz");
        game.net.send(cmd, xtArr);
        if (((!(map.getAction == null)) && map.getAction)) {
            try {
                map.sendAction(_arg_1.ref);
            } catch (e) {
            }
        }
        now = new Date().getTime();
        _arg_1.lock = true;
        _arg_1.actID = actionID;
        actionID++;
        if (actionID > actionIDLimit) {
            actionID = 0;
        }
        _arg_1.lastTS = _arg_1.ts;
        _arg_1.ts = now;
        if (_arg_1.typ != "aa") {
            coolDownAct(_arg_1);
            globalCoolDownExcept(_arg_1);
            if (((!(autoActionTimer.running)) && (_arg_1.tgt == "h"))) {
                testAction(getAutoAttack());
            }
        } else {
            if (game.preference.data.bSkillCD)
            {
                coolDownAct(_arg_1);
            }
            else
            {
                i = 0;
                while (i < actionMap.length) {
                    if (actionMap[i] == _arg_1.ref) {
                        icon = MovieClip(game.ui.mcInterface.actBar.getChildByName(("i" + (i + 1))));
                        if (icon.bg.currentLabel != "pulse") {
                            icon.bg.gotoAndPlay("pulse");
                        }
                    }
                    i++;
                }
            }
            actionReady = false;
        }
        actionResults[actionResultID] = {};
    }

    public function showActionResult(_arg_1:*, _arg_2:*):* {
        var _local_3:*;
        var _local_4:*;
        var _local_5:*;
        var _local_6:*;
        var _local_7:*;
        var _local_8:*;
        var _local_9:*;
        _local_3 = new Date();
        _local_4 = getActionByActID(_arg_2);
        if (_local_4 != null) {
            _local_4.lock = false;
            _local_4.actID = -1;
            _local_5 = _local_4.ts;
            _local_6 = _local_3.getTime();
            _local_7 = int(((_local_6 - _local_5) / 2));
            if (_local_4.typ == "aa") {
                _local_8 = Math.round((_local_4.cd * (1 - Math.min(Math.max(myAvatar.dataLeaf.sta.$tha, -1), 0.5))));
                _local_9 = (_local_8 - int((_local_6 - _local_5)));
                if (_local_9 > _local_8) {
                    _local_9 = _local_8;
                }
                if (_local_9 < (_local_8 - 100)) {
                    _local_9 = (_local_8 - 100);
                }
                autoActionTimer.delay = _local_9;
                autoActionTimer.reset();
                autoActionTimer.start();
            }
            if (_arg_1 == null) {
                _local_4.ts = _local_4.lastTS;
            } else {
                _local_4.ts = Math.max(int((_local_6 - _local_7)), (_local_5 + minLatencyOneWay));
                unlockActionsExcept(_local_4);
                game.updateActionObjIcon(_local_4);
            }
        }
        if (_arg_1 != null) {
            playActionSound(_arg_1);
            if (_arg_1.type != "none") {
                actionResults[actionResultID] = new ActionImpactTimer();
                actionResults[actionResultID].world = MovieClip(this);
                actionResults[actionResultID].actionResult = _arg_1;
                actionResults[actionResultID].showImpact(250);
                if (++actionResultID > actionResultIDLimit) {
                    actionResultID = 0;
                }
            }
        }
    }

    public function showIncomingAttackResult(_arg_1:Object):void {
        playActionSound(_arg_1);
        actionResultsMon[actionIDMon] = new ActionImpactTimer();
        actionResultsMon[actionIDMon].world = MovieClip(this);
        actionResultsMon[actionIDMon].actionResult = _arg_1;
        actionResultsMon[actionIDMon].showImpact(350);
        actionIDMon++;
        if (actionIDMon > actionIDLimitMon) {
            actionIDMon = 0;
        }
    }

    public function playActionSound(_arg_1:Object):void {
        var _local_2:Object;
        if (((_arg_1.a.length > 0) && (!(_arg_1.a[0].type == null)))) {
            _local_2 = _arg_1.a[0];
            switch (_local_2.type) {
                case "hit":
                    if (_local_2.hp >= 0) {
                        if (Math.random() < 0.5) {
                            game.mixer.playSound("Hit1");
                        } else {
                            game.mixer.playSound("Hit2");
                        }
                    } else {
                        game.mixer.playSound("Heal");
                    }
                    return;
                case "crit":
                    if (_local_2.hp >= 0) {
                        game.mixer.playSound("Hit3");
                    } else {
                        game.mixer.playSound("Heal");
                    }
                    return;
                case "miss":
                    game.mixer.playSound("Miss");
                    return;
                case "none":
                    game.mixer.playSound("Good");
                    return;
            }
        }
    }

    public function showActionImpact(resObj:*):* {
        if (game.preference.data.bDisDmgDisplay) return;

        var tMC:MovieClip;
        var actionDamage:MovieClip;
        var tf:TextFormat = new TextFormat();
        var i:int = 0;
        var a:Array = resObj.a;
        var displayType:String = null;
        var displayData:Object = {};

        while (i < a.length) {
            var o:Object = a[i];
            var entType:String = o.tInf.split(":")[0];
            var entID:int = int(o.tInf.split(":")[1]);
            switch (entType) {
                case "p":
                    tMC = avatars[entID].pMC;
                    break;
                case "m":
                    tMC = getMonster(entID).pMC;
                    break;
                case "t":
                    tMC = avatars[entID].petMC;
                    break;
                case "n":
                    tMC = getNpc(entID).pMC;
                    break;
            }

            if (tMC != null && tMC.pAV != null && tMC.pAV.dataLeaf != null) {
                switch (o.type) {
                    case "hit":
                        displayType = "hitDisplay";
                        displayData = int(o.hp) >= 0
                                ? {
                                    text: o.hp,
                                    textColor: 0xFFFFFF
                                }
                                : {
                                    text: "+" + Math.abs(o.hp) + "+",
                                    textColor: 0xA6FF4D
                                };

                        wound(tMC, "damage");
                        break;
                    case "crit":
                        displayType = "critDisplay";

                        displayData = o.hp > 0
                                ? {
                                    text: o.hp,
                                    textColor: 16750916,
                                    filters: [new GlowFilter(0x330000, 1, 2, 2, 5, 1, false, false)]
                                }
                                : {
                                    text: -(o.hp),
                                    textColor: 65450
                                };

                        wound(tMC, "damage");
                        break;
					case "immune":
                        displayType = "avoidDisplay";
                        displayData = { text: "Immune", textColor: 8716287 }
					    break;
                    case "miss":
                        displayType = "avoidDisplay";
                        displayData = { text: "Miss!" }
                        break;
                    case "dodge":
                        displayType = "avoidDisplay";
                        displayData = { text: "Dodge!" }
                        if (isMoveOK(tMC.pAV.dataLeaf) && entType != "t") {
                            tMC.queueAnim("Dodge");
                        }
                        break;
                    case "parry":
                        displayType = "avoidDisplay";
                        displayData = { text: "Parry!" }
                        if (isMoveOK(tMC.pAV.dataLeaf) && entType != "t") {
                            tMC.queueAnim("Dodge");
                        }
                        break;
                    case "block":
                        displayType = "avoidDisplay";
                        displayData = { text: "Block!" }

                        if (isMoveOK(tMC.pAV.dataLeaf) && entType != "t") {
                            tMC.queueAnim("Block");
                        }
                        break;
                    default:
                        trace("Unknown display type");
                        break;
                }

                if (displayType != null)
                {
                    var point:Point = tMC.mcChar.localToGlobal(new Point(0, 0));
                    point = CHARS.globalToLocal(point);
                    game.displayHandler.show(displayType, (point.x - 13) + CHARS.x, (point.y + tMC.pname.y) + CHARS.y, displayData);
                }
            }
            i++;
        }
    }

    public function showAuraImpact(actionResult:Object):void {
        if (game.preference.data.bDisDmgDisplay) return;

        var tAvt:MovieClip;
        var tInf:String = actionResult.tInf.split(":")[0];
        var cId:int = int(actionResult.tInf.split(":")[1]);
        switch (tInf) {
            case "p":
                if ((((!(avatars[cId] == null)) && ("pMC" in avatars[cId])) && (!(avatars[cId].pMC == null)))) {
                    tAvt = avatars[cId].pMC;
                }
                break;
            case "m":
                if ((((!(getMonster(cId) == null)) && ("pMC" in getMonster(cId))) && (!(getMonster(cId).pMC == null)))) {
                    tAvt = getMonster(cId).pMC;
                }
                break;
            case "n":
                if ((((!(getNpc(cId) == null)) && ("pMC" in getNpc(cId))) && (!(getNpc(cId).pMC == null)))) {
                    tAvt = getNpc(cId).pMC;
                }
                break;
        }

        if (tAvt != null) {
            var point:Point = tAvt.mcChar.localToGlobal(new Point(0, 0));
            point = CHARS.globalToLocal(point);

            if (actionResult.typ == "bleed")
            {
                game.displayHandler.show("dotDisplay", (point.x - 13) + CHARS.x, (point.y + tAvt.pname.y) + CHARS.y, {
                    text: actionResult.hp,
                    textColor: 0xFF4C4C
                });
            }
            else if (actionResult.typ == "toxic")
            {
                game.displayHandler.show("dotDisplay", (point.x - 13) + CHARS.x, (point.y + tAvt.pname.y) + CHARS.y, {
                    text: actionResult.hp,
                    textColor: 0x66FF66
                });
            }
            else
            {
				trace("dotDisplay > " + actionResult.hp);
                game.displayHandler.show("dotDisplay", (point.x - 13) + CHARS.x, (point.y + tAvt.pname.y) + CHARS.y, { text: actionResult.hp });
            }
        }
    }

    public function showAuraChange(resObj:Object, tAvt:Avatar, tLeaf:Object):* {
        var tMC:MovieClip;
        var actionDamage:* = undefined;
        var cLeaf:Object;
        var i:int;
        var nc:int;
        var gap:int;
        var child:DisplayObject;
        var cTyp:String;
        var cID:int;
        var tTyp:String;
        var tID:int;
        var aura:Object;
        var existingAura:Object;
        var dateObj:Date;
        var isOK:Boolean;
        var tFilters:Array;
        var tFilter:* = undefined;
        var auras:* = undefined;
        var ai:* = undefined;
        var actObj:* = undefined;
        var icon1:* = undefined;
        var filterIndex:int;

        trace("showAuraChange > ");

        tMC = tAvt.pMC;
        actionDamage = null;
        var cAvt:Avatar;
        cLeaf = null;
        if (tMC != null) {
            i = 0;
            nc = tMC.numChildren;
            gap = 1;
            if (resObj.cInf != null) {
                cTyp = String(resObj.cInf.split(":")[0]);
                cID = int(resObj.cInf.split(":")[1]);
                switch (cTyp) {
                    case "p":
                        cAvt = getAvatarByUserID(cID);
                        cLeaf = getUoLeafById(cID);
                        break;
                    case "m":
                        cAvt = getMonster(cID);
                        cLeaf = monTree[cID];
                        break;
                    case "n":
                        cAvt = getNpc(cID);
                        cLeaf = npcTree[cID];
                        break;
                }
            }
            if (resObj.auras != null) {
                gap = resObj.auras.length;
            }
            i = 0;
            while (i < nc) {
                child = tMC.getChildAt(i);
                if ((((!(child == null)) && (!(child.toString() == null))) && (child.toString().indexOf("auraDisplay") > -1))) {
                    child.y = (child.y - (int((child.height + 3)) * gap));
                }
                i = (i + 1);
            }
            aura = {};
            existingAura = {};
            dateObj = new Date();
            isOK = true;
            if (tLeaf.auras == null) {
                tLeaf.auras = [];
            }
            if (tLeaf.passives == null) {
                tLeaf.passives = [];
            }

            switch (resObj.cmd) {
                case "aura+":
                case "aura++":
                case "aura+p":
                    i = 0;
                    while (i < resObj.auras.length) {
                        aura = resObj.auras[i];
                        aura.cLeaf = cLeaf;
                        if (resObj.cmd == "aura+p") {
                            aura.passive = true;
                        } else {
                            aura.passive = false;
                        }
                        if (!aura.passive) {
                            if (aura.t != null) {
                                aura.ts = dateObj.getTime();
                            }
							trace("AURA => " + JSON.stringify(aura));
                            if (((((tAvt == myAvatar) || (tAvt == myAvatar.target)) || ((!(tLeaf.targets == null)) && (!(tLeaf.targets[game.net.myUserId] == null)))) || (resObj.cmd == "aura++"))) {

                                if (aura.potionType != null) {
                                    if (aura.potionType.toLowerCase() == "tonic") {
                                        tAvt.objData.Tonic = true;
                                    }
                                    if (aura.potionType.toLowerCase() == "elixir") {
                                        tAvt.objData.Elixir = true;
                                    }
                                }
                                if (aura.nam == "Skill Locked") {
                                    ai = 0;
                                    while (ai < actions.active.length) {
                                        actObj = actions.active[ai];
                                        if (actObj.nam == aura.val) {
                                            icon1 = game.ui.mcInterface.actBar.getChildByName(("i" + (ai + 1)));
                                            icon1.actObj.skillLock = true;
                                        }
                                        ai++;
                                    }
                                }

                                if (game.preference.data.bAuras && game.preference.data.bAuraText && aura.nam == "Spirit Power") {
                                    actionDamage = new auraDisplay();
                                    actionDamage.t.ti.text = (aura.nam + "!");
                                    actionDamage.t.ti.text = ((aura.nam + " ") + aura.val);
                                    tMC.addChild(actionDamage);
                                    actionDamage.x = ((tMC.mcChar.scaleX < 0) ? 35 : (-(actionDamage.t.ti.textWidth) - 35));
                                    actionDamage.y = ((tMC.pname.y + 25) + ((actionDamage.height + 3) * i));
                                }

                                if (aura.fx != null) {
                                    addAuraFX(tMC, aura.fx);
                                }
                            }
							
                            if (aura.s != null) {
                                switch (aura.s) {
                                    case "s":
									trace("STUN!");
                                        if (tMC.mcChar.currentLabel != "Fall") {
                                            tMC.clearQueue();
                                            tMC.mcChar.gotoAndPlay("Fall");
                                        }
                                        break;
                                }
                            }
                            if (aura.cat != null) {
                                isOK = true;
                                for each (existingAura in tLeaf.auras) {
                                    try {
                                        if (((!(existingAura.cat == null)) && (existingAura.cat == aura.cat))) {
                                            isOK = false;
                                        }
                                    } catch (e:Error) {
                                        trace(("combat.applyAuras > " + e));
                                    }
                                }
                                if (isOK) {
                                    switch (aura.cat) {
                                        case "paralyze":
                                        case "stone":
                                            tMC.modulateColor(statusStoneCT, "+");
                                            tMC.mcChar.stop();
                                            break;
                                        case "clean":
                                            tFilters = tMC.mcChar.filters;
                                            tFilters.push(new GlowFilter(0xFFFFFF, 1, 30, 30, 2, 2));
                                            tMC.mcChar.filters = tFilters;
                                            break;
                                    }
                                }
                            }
                            if (((!(aura.animOn == null)) && ((cLeaf == null) || (cLeaf.intState == 2)))) {
                                if (aura.animOn.indexOf("fadeFX:") > -1) {
                                    removeAuraFX(tMC, aura.animOn.split(":")[1], "fade");
                                } else {
                                    if (aura.animOn.indexOf("useFX:") > -1) {
                                        removeAuraFX(tMC, aura.animOn.split(":")[1], "use");
                                    } else {
                                        if (aura.animOn.indexOf("removeFX:") > -1) {
                                            removeAuraFX(tMC, aura.animOn.split(":")[1]);
                                        } else {
                                            tMC.mcChar.gotoAndPlay(aura.animOn);
                                        }
                                    }
                                }
                            }

                            if (aura.msgOn != null) {
                                if (aura.msgOn.charAt(0) == "@") {
                                    if (tAvt == myAvatar) {
                                        game.addUpdate(aura.msgOn.substr(1));
                                    }
                                } else {
                                    game.addUpdate(aura.msgOn);
                                }
                            }

                            if (aura.isNew) {
                                tLeaf.auras.push(aura);
                            } else {
                                updateAuraData(cLeaf, aura, tLeaf);
                            }
                        } else {
                            tLeaf.passives.push(aura);
                        }
                        i = (i + 1);
                    }
                    return;
                case "aura-":
                case "aura--":
                    auras = [];
                    if (resObj.auras != null) {
                        auras = resObj.auras;
                    } else {
                        if (resObj.aura != null) {
                            auras = [resObj.aura];
                        }
                    }
                    i = 0;
                    while (i < auras.length) {
                        aura = auras[i];
                        if (removeAura(aura, tLeaf, tMC)) {
                            if (((((tAvt == myAvatar) || (tAvt == myAvatar.target)) || ((!(tLeaf.targets == null)) && (!(tLeaf.targets[game.net.myUserId] == null)))) || (resObj.cmd == "aura--"))) {
                                if (game.preference.data.bAuras && game.preference.data.bAuraText)
                                {
                                    actionDamage = new auraDisplay();
                                    actionDamage.t.ti.text = (("*" + aura.nam) + " fades*");
                                    actionDamage.t.ti.textColor = 0x999999;
                                    tMC.addChild(actionDamage);
                                    actionDamage.x = ((tMC.mcChar.scaleX < 0) ? 35 : (-(actionDamage.t.ti.textWidth) - 35));
                                    actionDamage.y = (tMC.pname.y + 25);
                                }
                            }
                            if (aura.potionType != null) {
                                if (aura.potionType.toLowerCase() == "tonic") {
                                    tAvt.objData.Tonic = false;
                                }
                                if (aura.potionType.toLowerCase() == "elixir") {
                                    tAvt.objData.Elixir = false;
                                }
                            }
                            if (aura.s != null) {
                                switch (aura.s) {
                                    case "s":
                                        if (tMC.mcChar.currentLabel == "Fall") {
                                            if (isStatusGone("s", tLeaf)) {
                                                tMC.mcChar.gotoAndPlay("Getup");
                                            }
                                        }
                                        break;
                                }
                            }
                            if (aura.cat != null) {
                                isOK = true;
                                for each (existingAura in tLeaf.auras) {
                                    try {
                                        if (((!(existingAura.cat == null)) && (existingAura.cat == aura.cat))) {
                                            isOK = false;
                                        }
                                    } catch (e:Error) {
                                        trace(("combat.applyAuras > " + e));
                                    }
                                }
                                if (isOK) {
                                    switch (aura.cat) {
                                        case "stone":
                                            tMC.modulateColor(statusStoneCT, "-");
                                            tMC.mcChar.play();
                                            break;
                                        case "clean":
                                            tFilters = tMC.mcChar.filters;
                                            filterIndex = 0;
                                            while (filterIndex < tFilters.length) {
                                                tFilter = tFilters[filterIndex];
                                                if (((tFilter is GlowFilter) && (GlowFilter(tFilter).color == 0xFFFFFF))) {
                                                    tFilters.splice(filterIndex, 1);
                                                    filterIndex = (filterIndex - 1);
                                                }
                                                filterIndex = (filterIndex + 1);
                                            }
                                            tMC.mcChar.filters = tFilters;
                                            break;
                                    }
                                }
                            }
                            if (aura.nam == "Skill Locked") {
                                ai = 0;
                                while (ai < actions.active.length) {
                                    actObj = actions.active[ai];
                                    if (actObj.nam == aura.val) {
                                        icon1 = game.ui.mcInterface.actBar.getChildByName(("i" + (ai + 1)));
                                        icon1.actObj.skillLock = false;
                                        icon1.cnt.alpha = 1;
                                    }
                                    ai++;
                                }
                            }
                            if (aura.animOff != null) {
                                tMC.mcChar.gotoAndPlay(aura.animOff);
                            }
                            if (aura.msgOff != null) {
                                if (aura.msgOff.charAt(0) == "@") {
                                    if (tAvt == myAvatar) {
                                        game.addUpdate(aura.msgOff.substr(1));
                                    }
                                } else {
                                    game.addUpdate(aura.msgOff);
                                }
                            }
                        }
                        i = (i + 1);
                    }
                    return;
                case "aura*":
                    actionDamage = new auraDisplay();
                    actionDamage.t.ti.text = "* IMMUNE *";
                    tMC.addChild(actionDamage);
                    actionDamage.x = ((tMC.mcChar.scaleX < 0) ? 35 : (-(actionDamage.t.ti.textWidth) - 35));
                    actionDamage.y = ((tMC.pname.y + 25) + ((actionDamage.height + 3) * i));
                    return;
            }
        }
    }

    public function updateAuraData(_arg_1:Object, _arg_2:Object, _arg_3:Object):void {
        var _local_4:Object;
        for each (_local_4 in _arg_3.auras) {
            if (((_local_4.nam == _arg_2.nam) && (_local_4.cLeaf == _arg_1))) {
                _local_4.dur = _arg_2.dur;
                _local_4.val = _arg_2.val;
            }
        }
    }

    public function handleAuraEvent(cmd:String, resObj:Object):void {
        var cLeaf:Object;
        var tLeaf:Object;
        var cAvt:Avatar;
        var tAvt:Avatar;
        var cTyp:String;
        var cID:int;
        var tTyp:String;
        var tID:int;
        var forceAura:Boolean;

        if (game.sfcSocial) {
            forceAura = false;
            if (((cmd.indexOf("++") > -1) || (cmd.indexOf("--") > -1))) {
                forceAura = true;
            }
            cAvt = null;
            tAvt = null;
            if (resObj.cInf != null) {
                cTyp = String(resObj.cInf.split(":")[0]);
                cID = int(resObj.cInf.split(":")[1]);
                switch (cTyp) {
                    case "p":
                        cAvt = getAvatarByUserID(cID);
                        cLeaf = getUoLeafById(cID);
                        break;
                    case "m":
                        cAvt = getMonster(cID);
                        cLeaf = monTree[cID];
                        break;
                    case "n":
                        cAvt = getNpc(cID);
                        cLeaf = npcTree[cID];
                        break;
                }
            }
            if (resObj.tInf != null) {
                tTyp = String(resObj.tInf.split(":")[0]);
                tID = int(resObj.tInf.split(":")[1]);
	
                switch (tTyp) {
                    case "p":
                        try {
                            tAvt = getAvatarByUserID(tID);
                            tLeaf = getUoLeafById(tID);
                            if (((forceAura) || (tLeaf.strFrame == strFrame))) {
                                if (game.sfcSocial) {
                                    showAuraChange(resObj, tAvt, tLeaf);
                                }
                            }
                        } catch (e:Error) {
                        }
                        return;
                    case "m":
                        try {
                            tAvt = getMonster(tID);
                            tLeaf = monTree[tID];
                            if (((forceAura) || ((cLeaf == null) || ((!(cLeaf.targets[tID] == null)) && (tLeaf.strFrame == strFrame))))) {
                                if (game.sfcSocial) {
                                    showAuraChange(resObj, tAvt, tLeaf);
                                }
                            }
                        } catch (e:Error) {
                            trace((" HAE > " + e));
                        }
                        return;
                    case "n":
                        try {
                            tAvt = getNpc(tID);
                            tLeaf = npcTree[tID];
                            if (((forceAura) || ((cLeaf == null) || ((!(cLeaf.targets[tID] == null)) && (tLeaf.strFrame == strFrame))))) {
                                if (game.sfcSocial) {
                                    showAuraChange(resObj, tAvt, tLeaf);
                                }
                            }
                        } catch (e:Error) {

                        }
                        break;
                }
            }
        }
    }

    public function removeAura(_arg_1:Object, _arg_2:Object, _arg_3:MovieClip):Boolean {
        var _local_4:Boolean;
        var _local_5:int;

        if (ConfigurationData.Debug)
        {
            trace(("removeAura > " + _arg_1.nam));
        }

        if (game.sfcSocial) {
            _local_4 = false;
            _local_5 = 0;
            _local_5 = 0;
            while (_local_5 < _arg_2.auras.length) {
                if (_arg_2.auras[_local_5].nam == _arg_1.nam) {
                    if (((!(_arg_3 == null)) && (!(_arg_2.auras[_local_5].fx == null)))) {
                        removeAuraFX(_arg_3, _arg_2.auras[_local_5].fx, "fade");
                    }
                    _arg_2.auras.splice(_local_5, 1);
                    _local_5 = _arg_2.auras.length;
                    _local_4 = true;
                }
                _local_5++;
            }
            _local_5 = 0;
            while (_local_5 < _arg_2.passives.length) {
                if (_arg_2.passives[_local_5].nam == _arg_1.nam) {
                    _arg_2.passives.splice(_local_5, 1);
                    _local_5 = _arg_2.passives.length;
                    _local_4 = false;
                }
                _local_5++;
            }
            return (_local_4);
        }

        return false;
    }

    public function addAuraFX(tMC:MovieClip, fxName:String):void {
        if (ConfigurationData.Debug) trace("addAuraFX > " + fxName);

        var fx:MovieClip = tMC.fx.getChildByName(fxName);
        if (fx == null) {
            // Check pool first
            if (auraFXPool[fxName] && auraFXPool[fxName].length > 0) {
                fx = auraFXPool[fxName].pop();
            } else {
                var c:Class = getClass(fxName);
                if (c) fx = new c() as MovieClip;
            }
            if (fx) {
                fx.name = fxName;
                fx.y = -30;
                tMC.fx.addChild(fx);
            }
        }
    }

    public function removeAuraFX(tMC:MovieClip, fxName:String, fxLabel:String = null):void {
        if (ConfigurationData.Debug) trace("removeAuraFX > " + fxName + (fxLabel ? " " + fxLabel : ""));

        var i:int = tMC.fx.numChildren;
        while (i--) {
            var fx:MovieClip = MovieClip(tMC.fx.getChildAt(i));
            if (fxName == "all" || fx.name == fxName) {
                if (fxLabel) {
                    try {
                        MovieClip(fx.getChildByName("inner")).gotoAndPlay(fxLabel);
                    } catch (fxe:Error) {
                        trace("fx play error > " + fxe);
                    }
                } else {
                    tMC.fx.removeChild(fx);
                    // Return to pool
                    if (!auraFXPool[fxName]) auraFXPool[fxName] = [];
                    auraFXPool[fxName].push(fx);
                    fx.stop();
                }
            }
        }
    }

    public function isStatusGone(_arg_1:String, _arg_2:Object):Boolean {
        var _local_3:int = 0;
        while (_local_3 < _arg_2.auras.length) {
            if (((!(_arg_2.auras[_local_3].s == null)) && (_arg_2.auras[_local_3].s == _arg_1))) {
                return false;
            }
            _local_3++;
        }

        return true;
    }

    public function isMoveOK(tLeaf:Object):Boolean {
        var isOK:Boolean;
        var aura:Object;
        isOK = true;
        aura = {};
        if (tLeaf.auras != null) {
            for each (aura in tLeaf.auras) {
                try {
                    if (aura.cat != null) {
                        if (aura.cat == "stun") {
                            isOK = false;
                        }
                        if (aura.cat == "stone") {
                            isOK = false;
                        }
                        if (aura.cat == "disabled") {
                            isOK = false;
                        }
                    }
                } catch (e:Error) {
                    if (ConfigurationData.Debug)
                    {
                        trace(("doAnim > " + e));
                    }
                }
            }
            return (isOK);
        }

        return false;
    }

//    public function wound(obj:*, typ:String):* {
//        if (game.preference.data.bDisDmgStrobe) return;
//
//        if (typ == "damage") {
//            var flickermc:MovieClip = new MovieClip();
//            flickermc.name = "flickermc";
//            flickermc.maxF = 3;
//            flickermc.curF = 0;
//            flickermc.addEventListener(Event.ENTER_FRAME, flickerFrame);
//            if (obj.contains(flickermc)) {
//                obj.flickermc.removeEventListener(Event.ENTER_FRAME, flickerFrame);
//                obj.removeChild(flickermc);
//            }
//            obj.addChild(flickermc);
//        }
//    }

    public function wound(obj:*, typ:String):* {
        if (game.preference.data.bDisDmgStrobe || typ != "damage" || obj.getChildByName("flickermc") != null || getTimer() - obj.lastFlickerTime < 1500) return;

        var flicker:MovieClip = new MovieClip();
        flicker.name = "flickermc";
        flicker.maxF = 3;
        flicker.curF = 0;
        flicker.addEventListener(Event.ENTER_FRAME, flickerFrame);

        obj.addChild(flicker);
    }

    public function flickerFrame(event:Event):* {
        var mc:*;
        mc = MovieClip(event.currentTarget);

        if (mc.parent == null || mc.parent.stage == null) {
            mc.removeEventListener(Event.ENTER_FRAME, flickerFrame);
            return;
        }

        switch (mc.curF) {
            case 0:
            case 2:
                mc.parent.modulateColor(avtWCT, "+");
                break;
            case 1:
            case 3:
                mc.parent.modulateColor(avtWCT, "-");
                break;
        }

        mc.curF++;
        if (mc.curF > mc.maxF) {
            mc.removeEventListener(Event.ENTER_FRAME, flickerFrame);

            mc.parent.lastFlickerTime = getTimer();

            if (mc.parent.contains(mc))
                mc.parent.removeChild(mc);
        }
    }

    public function unlockActionsExcept(_arg_1:*):* {
        var _local_2:*;
        var _local_3:*;
        var _local_4:*;
        var _local_5:*;
        var _local_6:*;
        var _local_7:*;
        _local_2 = [];
        _local_3 = 0;
        _local_3 = 0;
        while (_local_3 < actions.active.length) {
            _local_5 = actions.active[_local_3];
            if ((((!(_local_5.ref == _arg_1.ref)) && _local_5.lock) && (_local_5.ts < _arg_1.ts))) {
                _local_6 = 0;
                while (_local_6 < actionMap.length) {
                    if (actionMap[_local_6] == _local_5.ref) {
                        _local_2.push(("i" + (_local_6 + 1)));
                    }
                    _local_6++;
                }
            }
            _local_3++;
        }
        _local_4 = 0;
        while (_local_4 < _local_2.length) {
            _local_7 = game.ui.mcInterface.actBar.getChildByName(_local_2[_local_4]);
            if (_local_7.actObj != null) {
                _local_7.actObj.lock = false;
            }
            _local_4++;
        }
    }

    public function unlockActions():* {
        var _local_1:*;
        var _local_2:*;
        _local_1 = 0;
        while (_local_1 < actions.active.length) {
            _local_2 = actions.active[_local_1];
            _local_2.lock = false;
            _local_1++;
        }
    }

    public function updateActBar():void {
        var _local_1:*;
        var _local_2:*;
        var _local_3:*;
        if ((((!(myAvatar == null)) && (!(myAvatar.dataLeaf == null))) && (!(myAvatar.dataLeaf.sta == null)))) {
            _local_1 = 0;
            while (_local_1 < game.ui.mcInterface.actBar.numChildren) {
                _local_2 = game.ui.mcInterface.actBar.getChildAt(_local_1);
                if ((("actObj" in _local_2) && (!(_local_2.actObj == null)))) {
                    _local_3 = _local_2.actObj.skillLock;
                    _local_3 = ((_local_3 == null) ? false : _local_3);
                    if (((myAvatar.dataLeaf.intMP >= Math.round((_local_2.actObj.mp * myAvatar.dataLeaf.sta["$cmc"]))) && (!(_local_3)))) {
                        if (_local_2.cnt.alpha < 1) {
                            _local_2.cnt.alpha = 1;
                        }
                    } else {
                        if (_local_2.cnt.alpha == 1) {
                            _local_2.cnt.alpha = 0.4;
                        }
                    }
                }
                _local_1++;
            }
        }
    }

    public function getActIcons(_arg_1:Object):Array {
        var _local_2:Array;
        var _local_3:MovieClip;
        var _local_4:*;
        _local_2 = [];
        _local_4 = 0;
        while (_local_4 < actionMap.length) {
            if (actionMap[_local_4] == _arg_1.ref) {
                _local_3 = (game.ui.mcInterface.actBar.getChildByName(("i" + (_local_4 + 1))) as MovieClip);
                if (_local_3 != null) {
                    _local_2.push(_local_3);
                }
            }
            _local_4++;
        }
        return (_local_2);
    }

    public function globalCoolDownExcept(skipAction:Object):void {
        var now:Number = getTimer();
        for each (var action:Object in actions.active) {
            if (action.isOK && action !== skipAction && action.ref !== "aa") {
                var icon:MovieClip = getActIcons(action)[0];
                if (icon && (!("icon2" in icon) || icon.icon2 == null || (action.ts + action.cd > now && (action.ts + action.cd - now) < GCD))) {
                    coolDownAct(action, GCD, now);
                }
            }
        }

        GCDTS = now;
    }

    public function checkCooldown(action:Object):void {
        var icons:Array = getActIcons(action);
        for each (var icon:MovieClip in icons) {
            if (icon.icon2 != null) {
                icon.icon2.bitmapData.dispose();
                var bmd:BitmapData = new BitmapData(50, 50, true, 0);
                bmd.draw(icon, null, iconCT);
                var bm:Bitmap = new Bitmap(bmd);
                icon.icon2 = game.ui.mcInterface.actBar.addChild(bm);
            }
        }
    }

    public function coolDownAct(actionObj:Object, cd:int=-1, ts:Number=-1):*
    {
        var actIcons:Array;
        var icon1:MovieClip;
        var j:int;
        var icon2:*;
        var iMask:MovieClip;
        var bmd:*;
        var bm:*;
        var k:int;
        var iconF:DisplayObject;
        actIcons = getActIcons(actionObj);
        j = 0;
        while (j < actIcons.length)
        {
            icon1 = actIcons[j];
            icon2 = null;
            iMask = null;
            if (icon1.icon2 == null)
            {
                bmd = new BitmapData(50, 50, true, 0);
                bmd.draw(icon1, null, iconCT);
                bm = new Bitmap(bmd);
                icon2 = game.ui.mcInterface.actBar.addChild(bm);
                icon1.icon2 = icon2;
                if (cd == -1)
                {
                    iconF = game.ui.mcInterface.actBar.addChild(new iconFlare());
                    icon2.transform = (iconF.transform = icon1.transform);
                    icon1.ts = actionObj.ts;
                    icon1.cd = actionObj.cd;
                }
                else
                {
                    icon2.transform = icon1.transform;
                    icon1.ts = ts;
                    icon1.cd = cd;
                }
                iMask = (game.ui.mcInterface.actBar.addChild(new ActMask()) as MovieClip);
                iMask.scaleX = 0.33;
                iMask.scaleY = 0.33;
                iMask.x = int(((icon2.x + (icon2.width / 2)) - (iMask.width / 2)));
                iMask.y = int(((icon2.y + (icon2.height / 2)) - (iMask.height / 2)));
                k = 0;
                while (k < 4)
                {
                    iMask[(("e" + k) + "oy")] = iMask[("e" + k)].y;
                    k++;
                }
                icon2.mask = iMask;
            }
            else
            {
                icon2 = icon1.icon2;
                iMask = icon2.mask;
                if (cd == -1)
                {
                    icon1.ts = actionObj.ts;
                    icon1.cd = actionObj.cd;
                }
                else
                {
                    icon1.ts = ts;
                    icon1.cd = cd;
                }
            }
            if (((cd == -1) && (game.preference.data.bSkillCD)))
            {
                switch (actionObj.ref)
                {
                    case "aa":
                        icon1.ref = "txtCD0";
                        break;
                    case "i1":
                        icon1.ref = "txtCD5";
                        break;
					case "i2":
                        icon1.ref = "txtCD6";
                        break;
                    default:
                        icon1.ref = ("txtCD" + actionObj.ref.slice(1));
                }

                var actBarCD:ActBarCD = game.ui.mcInterface.actBar.getChildByName(icon1.ref) as ActBarCD;

                if (actBarCD != null)
                {
                    game.ui.mcInterface.actBar.setChildIndex(actBarCD, (game.ui.mcInterface.actBar.numChildren - 1));
                    actBarCD.txtCD.text = String(Number(icon1.cd / 1000).toFixed(1));
                    actBarCD.visible = true;
                }
            }
            iMask.e0.stop();
            iMask.e1.stop();
            iMask.e2.stop();
            iMask.e3.stop();
            icon1.removeEventListener(Event.ENTER_FRAME, countDownAct);
            icon1.addEventListener(Event.ENTER_FRAME, countDownAct, false, 0, true);
            j++;
        }
    }

    public function countDownAct(e:Event):void
    {
        try
        {
            var dat:*;
            var ti:*;
            var ct1:*;
            var ct2:*;
            var cd:*;
            var tp:*;
            var mc:*;
            var fr:*;
            var i:*;
            var iMask:*;
            dat = new Date();
            ti = dat.getTime();
            ct1 = MovieClip(e.target);
            ct2 = ct1.icon2;
            cd = Math.round((ct1.cd * (1 - Math.min(Math.max(myAvatar.dataLeaf.sta.$tha, -1), 0.5))));
            tp = ((ti - ct1.ts) / cd);
            mc = Math.floor((tp * 4));
            fr = (int(((tp * 360) % 90)) + 1);
            if (!ct1.actObj.lock)
            {
                if (tp < 0.99)
                {
                    if (ct1.ref)
                    {
                        game.ui.mcInterface.actBar.getChildByName(ct1.ref).txtCD.text = String(Number((Number((1 - tp)) * (ct1.cd / 1000))).toFixed(1));
                    }
                    i = 0;
                    while (i < 4)
                    {
                        if (i < mc)
                        {
                            ct2.mask[("e" + i)].y = -300;
                        }
                        else
                        {
                            ct2.mask[("e" + i)].y = ct2.mask[(("e" + i) + "oy")];
                            if (i > mc)
                            {
                                ct2.mask[("e" + i)].gotoAndStop(0);
                            }
                        }
                        i++;
                    }
                    MovieClip(ct2.mask[("e" + mc)]).gotoAndStop(fr);
                }
                else
                {
                    if (ct1.ref)
                    {
                        game.ui.mcInterface.actBar.getChildByName(ct1.ref).visible = false;
                    }
                    iMask = ct2.mask;
                    ct2.mask = null;
                    ct2.parent.removeChild(iMask);
                    ct1.removeEventListener(Event.ENTER_FRAME, countDownAct);
                    ct2.parent.removeChild(ct2);
                    ct2.bitmapData.dispose();
                    ct1.icon2 = null;
                }
            }
        }
        catch(error:Error)
        {
            MovieClip(e.target).removeEventListener(Event.ENTER_FRAME, countDownAct);
        }
    }

    public function getMapItem(_arg_1:int):void
    {
        if (coolDown("getMapItem"))
        {
            game.net.send("getMapItem", [_arg_1]);
        }
    }

    public function healByIcon(_arg_1:Avatar):void {
        var _local_2:Object;
        _local_2 = getFirstHeal();
        if (_local_2 != null) {
            setTarget(_arg_1);
            testAction(_local_2);
        }
    }

    public function getFirstHeal():Object {
        var _local_1:*;
        try {
            _local_1 = 0;
            while (_local_1 < actions.active.length) {
                if (((((!(actions.active[_local_1] == null)) && (!(actions.active[_local_1].damage == null))) && (actions.active[_local_1].damage < 0)) && (actions.active[_local_1].isOK))) {
                    return (actions.active[_local_1]);
                }
                _local_1++;
            }
        } catch (e:Error) {
        }
        return null;
    }

    internal function checkSP(_arg_1:int, _arg_2:Object):Boolean {
        var _local_3:*;
        _local_3 = 0;
        while (_local_3 < _arg_2.auras.length) {
            if (_arg_2.auras[_local_3].nam == "Spirit Power") {
                if (_arg_1 <= _arg_2.auras[_local_3].val) {
                    return true;
                }
                return false;
            }
            _local_3++;
        }
        return false;
    }


    public function showTestQuestList(questIds:Array, tracker:Boolean = false) : void
    {
        var quest:Quests = game.attachOnModalStack("game.quest.Quests") as Quests;

        if (quest == null || game.isGreedyModalInStack()) return;

        quest.x = 15;
        quest.y = 65;

        if (tracker)
        {
            quest.open(true);
        }
        else
        {
            game.net.send("loadQuests", questIds);
        }
    }

    public function showQuestTrackerList() : void
    {
        showTestQuestList([], true);
    }

    public function isPartyMember(_arg_1:String):Boolean {
        var _local_2:int;
        _arg_1 = _arg_1.toLowerCase();
        if (_arg_1 != game.net.myUserName) {
            _local_2 = 0;
            while (_local_2 < partyMembers.length) {
                if (partyMembers[_local_2].toLowerCase() == _arg_1) {
                    return true;
                }
                _local_2++;
            }
        }
        return false;
    }

    public function doPartyAccept(_arg_1:Object):void {
        if (_arg_1.accept) {
            game.net.send("gp", ["pa", _arg_1.pid]);
        } else {
            game.net.send("gp", ["pd", _arg_1.pid]);
        }
    }

    public function addPartyMember(_arg_1:String):* {
        partyMembers.push(_arg_1);
        updatePartyFrame();
    }

    public function removePartyMember(_arg_1:String):* {
        var _local_2:*;
        if (_arg_1 != game.net.myUserName) {
            _local_2 = partyMembers.indexOf(_arg_1);
            if (_local_2 > -1) {
                partyMembers.splice(_local_2, 1);
            }
        } else {
            partyID = -1;
            partyOwner = "";
            partyMembers = [];
        }
        updatePartyFrame();
    }

    public function updatePartyFrame(_arg_1:Object = null):* {
        var _local_2:MovieClip;
        var _local_3:int;
        var _local_4:int;
        var _local_5:MovieClip;
        var _local_6:int;
        var _local_7:Object;
        var _local_8:Array;
        var _local_9:Boolean;
        var _local_10:Boolean;
        var _local_11:String;
        var _local_12:*;
        var _local_13:*;
        _local_2 = null;
        _local_3 = 0;
        _local_4 = 0;
        _local_5 = null;
        _local_6 = 0;
        _local_7 = null;
        _local_8 = [];
        _local_9 = true;
        _local_10 = false;
        if ((((!(_arg_1 == null)) && (!(_arg_1.range == null))) && !_arg_1.range)) {
            _local_9 = false;
        }
        if (_arg_1 != null) {
            _local_8 = [_arg_1.unm];
        } else {
            _local_10 = true;
            _local_8 = partyMembers;
        }
        if (_local_8.length > 0) {
            _local_11 = "";
            if (_arg_1 == null) {
                _local_12 = [];
                _local_6 = 0;
                _local_6 = 0;
                while (_local_6 < game.ui.mcPartyFrame.numChildren) {
                    _local_12.push(MovieClip(game.ui.mcPartyFrame.getChildAt(_local_6)));
                    _local_6++;
                }
                _local_6 = 0;
                _local_6 = 0;
                while (_local_6 < _local_12.length) {
                    _local_2 = _local_12[_local_6];
                    _local_13 = _local_2.strName.text;
                    if (partyMembers.indexOf(_local_13) == -1) {
                        _local_2.removeEventListener(MouseEvent.CLICK, onPartyPanelClick);
                        game.ui.mcPartyFrame.removeChild(_local_2);
                    }
                    _local_6++;
                }
            }
            _local_6 = 0;
            while (_local_6 < _local_8.length) {
                _local_11 = _local_8[_local_6];
                _local_2 = getPartyPanelByName(_local_11);
                _local_7 = uoTree[_local_11.toLowerCase()];
                if (_local_7 == null) {
                    _local_2.HP.visible = false;
                    _local_2.MP.visible = false;
                    _local_2.txtRange.visible = true;
                } else {
                    if (_local_9) {
                        _local_3 = _local_7.intHP;
                        _local_4 = _local_7.intHPMax;
                        _local_5 = _local_2.HP;
                        if (_local_3 >= 0) {
                            _local_5.strIntHP.text = (_local_5.strIntHPs.text = String(_local_7.intHP));
                        } else {
                            _local_5.strIntHP.text = (_local_5.strIntHPs.text = "X");
                        }
                        if (_local_3 < 0) {
                            _local_3 = 0;
                        }
                        _local_5.intHPbar.x = -(_local_5.intHPbar.width * (1 - (_local_3 / _local_4)));
                        _local_3 = _local_7.intMP;
                        _local_4 = _local_7.intMPMax;
                        _local_5 = _local_2.MP;
                        if (_local_3 >= 0) {
                            _local_5.strIntMP.text = (_local_5.strIntMPs.text = String(_local_7.intMP));
                        } else {
                            _local_5.strIntMP.text = (_local_5.strIntMPs.text = "X");
                        }
                        if (_local_3 < 0) {
                            _local_3 = 0;
                        }
                        _local_5.intMPbar.x = -(_local_5.intMPbar.width * (1 - (_local_3 / _local_4)));
                        _local_2.HP.visible = true;
                        _local_2.MP.visible = true;
                        _local_2.txtRange.visible = false;
                    } else {
                        _local_2.HP.visible = false;
                        _local_2.MP.visible = false;
                        _local_2.txtRange.visible = true;
                    }
                }
                if (_local_10) {
                    _local_2.y = int(((_local_2.height + 2) * _local_6));
                }
                _local_2.partyLead.visible = (_local_11.toLowerCase() == partyOwner.toLowerCase());
                _local_6++;
            }
        } else {
            _local_6 = 0;
            while (((game.ui.mcPartyFrame.numChildren > 0) && (_local_6 < 10))) {
                _local_2 = MovieClip(game.ui.mcPartyFrame.getChildAt(0));
                _local_2.removeEventListener(MouseEvent.CLICK, onPartyPanelClick);
                game.ui.mcPartyFrame.removeChildAt(0);
                _local_6++;
            }
        }
        game.ui.mcPortrait.partyLead.visible = (partyOwner.toLowerCase() == game.net.myUserName);
    }

    public function createPartyPanel(_arg_1:Object):MovieClip {
        var _local_3:*;
        var _local_2:* = (game.ui.mcPartyFrame.numChildren + 1);
        _local_3 = MovieClip(game.ui.mcPartyFrame.addChild(new PartyPanel()));
        _local_3.strName.text = _arg_1.unm;
        _local_3.HP.visible = false;
        _local_3.MP.visible = false;
        _local_3.txtRange.visible = false;
        _local_3.addEventListener(MouseEvent.CLICK, onPartyPanelClick, false, 0, true);
        _local_3.buttonMode = true;
        return (_local_3);
    }

    public function getPartyPanelByName(_arg_1:String):MovieClip {
        var _local_2:*;
        var _local_3:MovieClip;
        var _local_4:int;
        _local_2 = game.ui.mcPartyFrame.numChildren;
        _local_3 = null;
        _local_4 = 0;
        while (_local_4 < _local_2) {
            _local_3 = MovieClip(game.ui.mcPartyFrame.getChildAt(_local_4));
            if (_local_3.strName.text == _arg_1) {
                return (_local_3);
            }
            _local_4++;
        }
        return (createPartyPanel({"unm": _arg_1}));
    }

    public function onPartyPanelClick(_arg_1:MouseEvent):void {
        var _local_2:*;
        var _local_3:*;
        var _local_4:Avatar;
        _local_2 = MovieClip(_arg_1.currentTarget);
        _local_3 = {};
        _local_3.strUsername = _local_2.strName.text;
        if (_arg_1.shiftKey) {
            _local_4 = getAvatarByUserName(_local_3.strUsername.toLowerCase());
            if (((((!(_local_4 == null)) && (!(_local_4.pMC == null))) && (!(_local_4.dataLeaf == null))) && (_local_4.dataLeaf.strFrame == myAvatar.dataLeaf.strFrame))) {
                setTarget(_local_4);
            }
        } else {
            game.ui.cMenu.fOpenWith("party", _local_3);
        }
    }

    public function partyInvite(_arg_1:String):void {
        game.net.send("gp", ["pi", _arg_1]);
    }

    public function partyKick(_arg_1:String):void {
        game.net.send("gp", ["pk", _arg_1]);
    }

    public function partyLeave():void {
        game.net.send("gp", ["pl"]);
    }

    public function partySummon(_arg_1:String):void {
        game.net.send("gp", ["ps", _arg_1]);
    }

    public function acceptPartySummon(_arg_1:Object):void {
        if (_arg_1.accept) {
            game.net.send("gp", ["psa"]);
            if (_arg_1.strF == null) {
                game.net.send("cmd", ["goto", _arg_1.unm]);
            } else {
                moveToCell(_arg_1.strF, _arg_1.strP);
            }
        } else {
            game.net.send("gp", ["psd", _arg_1.unm]);
        }
    }

    public function partyUpdate(_arg_1:String, _arg_2:String):void {
    }

    public function partyPromote(_arg_1:String):void {
        game.net.send("gp", ["pp", _arg_1]);
    }

    public function _SafeStr_1(_arg_1:*):* {
        var _local_2:*;
        var _local_3:*;
        _arg_1 = _arg_1.toLowerCase();
        _local_2 = uoTree[game.net.myUserName];
        _local_3 = uoTree[String(_arg_1).toLowerCase()];
        if (((_local_2.intState == 1) && ((_local_2.pvpTeam == null) || (_local_2.pvpTeam == -1)))) {
            if (((!(_local_3 == null)) && (!(_local_2.uoName == _local_3.uoName)))) {
                if ((("nogoto" in map) && (map.nogoto))) {
                    game.chatF.pushMsg("warning", "/goto can't target players within this map.", "SERVER", "", 0);
                    return;
                }
                if (_local_2.strFrame != _local_3.strFrame) {
                    moveToCell(_local_3.strFrame, _local_3.strPad);
                }
            } else {
                game.net.send("cmd", ["goto", _arg_1]);
            }
        }
    }

    public function pull(_arg_1:*):* {
        _arg_1 = _arg_1.toLowerCase();
        game.net.send("cmd", ["pull", _arg_1]);
    }

    public function requestFriend(_arg_1:String):void {
        game.net.send("requestFriend", [_arg_1]);
    }

    public function addFriend(_arg_1:Object):void {
        if (_arg_1.accept) {
            game.net.send("addFriend", [_arg_1.unm]);
        } else {
            game.net.send("declineFriend", [_arg_1.unm]);
        }
    }

    public function deleteFriend(_arg_1:int, _arg_2:*):void {
        game.net.send("deleteFriend", [_arg_1, _arg_2]);
    }

    public function guildInvite(_arg_1:String):void {
        game.net.send("guild", ["gi", _arg_1]);
    }

    public function guildRemove(_arg_1:Object):void {
        if (_arg_1.accept) {
            game.net.send("guild", ["gr", _arg_1.userName]);
        }
    }

    public function guildPromote(_arg_1:String):void {
        game.net.send("guild", ["gp", _arg_1]);
    }

    public function guildDemote(_arg_1:String):void {
        game.net.send("guild", ["gd", _arg_1]);
    }

    public function doGuildAccept(_arg_1:Object):void {
        if (_arg_1.accept) {
            game.net.send("guild", ["ga", _arg_1.guildID, _arg_1.owner]);
        } else {
            game.net.send("guild", ["gdi", _arg_1.guildID, _arg_1.owner]);
        }
    }

    public function setGuildMOTD(_arg_1:String):void {
        game.net.send("guild", ["motd", _arg_1]);
    }

    public function createGuild(_arg_1:Object):void {
        if (_arg_1.accept) {
            game.net.send("guild", ["gc", _arg_1.guildName]);
        }
    }

    public function addMemSlots(_arg_1:int):void {
        game.net.send("guild", ["slots", _arg_1]);
    }

    public function renameGuild(_arg_1:Object):void {
        if (_arg_1.accept) {
            game.net.send("guild", ["rename", _arg_1.guildName]);
        }
    }

    public function requestPVPQueue(_arg_1:String, _arg_2:int = -1):void {
        game.net.send("PVPQr", [_arg_1, _arg_2]);
    }

    public function handlePVPQueue(_arg_1:Object):void {
        var _local_2:MovieClip;
        if (_arg_1.bitSuccess == 1) {
            PVPQueue.warzone = _arg_1.warzone;
            PVPQueue.ts = new Date().getTime();
            PVPQueue.avgWait = _arg_1.avgWait;
            game.showMCPVPQueue();
        } else {
            PVPQueue.warzone = "";
            PVPQueue.ts = -1;
            PVPQueue.avgWait = -1;
            game.hideMCPVPQueue();
        }
        _local_2 = game.ui.mcPopup;
        if (((_local_2.currentLabel == "PVPPanel") && (!(_local_2.mcPVPPanel == null)))) {
            _local_2.mcPVPPanel.updateBody();
        }
        game.closeModalByStrBody("A new Warzone battle has started!");
    }

    public function updatePVPAvgWait(_arg_1:int):void {
        PVPQueue.avgWait = _arg_1;
    }

    public function duelExpire():* {
        game.closeModalByStrBody("has challenged you to a duel.");
    }

    public function receivePVPInvite(_arg_1:Object):* {
        var _local_2:*;
        var _local_3:*;
        var _local_4:*;
        _local_2 = new ModalMC();
        _local_3 = {};
        _local_4 = getWarzoneByWarzoneName(_arg_1.warzone);
        _local_3.strBody = (("A new Warzone battle has started!  Will you join " + _local_4.nam) + "?");
        _local_3.greedy = true;
        _local_3.params = {};
        _local_3.callback = replyToPVPInvite;
        game.ui.ModalStack.addChild(_local_2);
        game.ui.mcPopup.onClose();
        game.hideMCPVPQueue();
        _local_2.init(_local_3);
    }

    public function replyToPVPInvite(_arg_1:Object):void {
        if (_arg_1.accept) {
            sendPVPInviteAccept();
        } else {
            sendPVPInviteDecline();
        }
    }

    public function sendPVPInviteAccept():void {
        game.net.send("PVPIr", ["1"]);
    }

    public function sendPVPInviteDecline():void {
        game.net.send("PVPIr", ["0"]);
    }

    public function sendDuelInvite(_arg_1:String):void {
        game.net.send("duel", [_arg_1]);
    }

    public function doDuelAccept(_arg_1:Object):void {
        if (_arg_1.accept) {
            game.net.send("da", [_arg_1.unm]);
        } else {
            game.net.send("dd", [_arg_1.unm]);
        }
    }

    public function getWarzoneByName(_arg_1:String):* {
        var _local_2:int;
        _local_2 = 0;
        while (_local_2 < PVPMaps.length) {
            if (PVPMaps[_local_2].nam == _arg_1) {
                return (PVPMaps[_local_2]);
            }
            _local_2++;
        }
        return null;
    }

    public function getWarzoneByWarzoneName(_arg_1:String):* {
        var _local_2:int;
        _local_2 = 0;
        while (_local_2 < PVPMaps.length) {
            if (PVPMaps[_local_2].warzone == _arg_1) {
                return (PVPMaps[_local_2]);
            }
            _local_2++;
        }
        return null;
    }

    public function setPVPFactionData(_arg_1:Array):void {
        if (_arg_1 != null) {
            PVPFactions = _arg_1;
        } else {
            PVPFactions = [];
        }
    }

    public function attachMovieFront(strLinkage:*):MovieClip {
        var mc:MovieClip;
        var AssetClass:Class;
        var addOK:*;
        var tempClass:*;
        AssetClass = (getClass(strLinkage) as Class);
        addOK = true;
        if (FG.numChildren) {
            mc = MovieClip(FG.getChildAt(0));
            tempClass = (mc.constructor as Class);
            if (tempClass == AssetClass) {
                addOK = false;
            }
        }
        if (addOK) {
            removeMovieFront();
            mc = MovieClip(FG.addChild(new (AssetClass)()));
            FG.mouseChildren = true;
        }
        return (mc);
    }

    public function attachMovieFrontMenu(_arg_1:*):MovieClip {
        var _local_2:MovieClip;
        var _local_3:Class;
        var _local_4:*;
        var _local_5:*;
        _local_3 = (getClass(_arg_1) as Class);
        _local_4 = true;
        if (FG.numChildren) {
            _local_2 = MovieClip(FG.getChildAt(0));
            _local_5 = (_local_2.constructor as Class);
            if (_local_5 == _local_3) {
                _local_4 = false;
            }
        }
        if (_local_4) {
            removeMovieFront();
            _local_2 = MovieClip(FG.addChild(new (_local_3)()));
            FG.mouseChildren = true;
        }
        return (_local_2);
    }

    public function removeMovieFront():* {
        var _local_1:int;
        _local_1 = 0;
        while (((FG.numChildren > 0) && (_local_1 < 100))) {
            _local_1++;
            FG.removeChildAt(0);
        }
        game.ldrMC.closeHistory();
        game.stage.focus = null;
    }

    public function getMovieFront():* {
        if (((FG.numChildren > 0) && (!(FG.getChildAt(0) == null)))) {
            return (FG.getChildAt(0));
        }
        return null;
    }

    public function isMovieFront(strLinkage:String):Boolean {
        var mc:MovieClip;
        var AssetClass:Class;
        var isMF:*;
        var tempClass:*;
        AssetClass = (this.getClass(strLinkage) as Class);
        isMF = false;
        if (FG.numChildren) {
            mc = MovieClip(FG.getChildAt(0));
            tempClass = (mc.constructor as Class);
            if (tempClass == AssetClass) {
                isMF = true;
            }
        }
        return (isMF);
    }

    public function loadMovieFront(_arg_1:String, _arg_2:String = "Game Files"):void {
        removeMovieFront();
        game.ldrMC.loadFile(FG, _arg_1, _arg_2);
    }

    public function showPreL():* {
        if (((preLMC == null) || (!(MovieClip(this).contains(preLMC))))) {
            preLMC = new PreL();
            addChild(preLMC);
            preLMC.x = ((ConfigurationData.CLIENT_WIDTH / 2) - (preLMC.width / 2));
            preLMC.y = ((ConfigurationData.CLIENT_HEIGHT / 2) - (preLMC.height / 2));
        }
    }

//    private function calculateFPS():void {
//        try
//        {
//            var currentTime:Number = new Date().getTime();
//            if (fpsTS != 0) {
//                var delta:Number = currentTime - fpsTS;
//                ticklist.push(delta);
//                if (ticklist.length > TICK_MAX) {
//                    ticksum -= ticklist.shift();
//                }
//                ticksum += delta;
//                var fps:Number = 1000 / (ticksum / ticklist.length);
//                if (game.ui.mcFPS.visible) {
//                    game.ui.mcFPS.txtFPS.text = fps.toFixed(1); // Simplified precision
//                }
//            }
//            fpsTS = currentTime;
//        }
//        catch(e)
//        {
//
//        }
//    }

    private function calculateFPS():void {
        var _local_1:Number;
        var _local_2:int;
        var _local_3:int;
        var _local_4:*;
        var _local_5:Number;
        var _local_6:int;
        var _local_7:Number;
        var _local_8:int;
        try {
            if (fpsTS != 0) {
                _local_1 = new Date().getTime();
                _local_2 = (_local_1 - fpsTS);
                _local_3 = 0;
                if (ticklist.length == TICK_MAX) {
                    _local_3 = ticklist.shift();
                }
                ticklist.push(_local_2);
                ticksum = ((ticksum + _local_2) - _local_3);
                _local_4 = (1000 / (ticksum / ticklist.length));
                if (game.ui.mcFPS.visible) {
                    game.ui.mcFPS.txtFPS.text = _local_4.toPrecision(4);
                }
                if ((((game.preference.data.quality == "AUTO") && (ticklist.length == TICK_MAX)) && ((++fpsQualityCounter % 24) == 0))) {
                    fpsArrayQuality.push(_local_4);
                    if (fpsArrayQuality.length == 5) {
                        _local_5 = 0;
                        _local_6 = 0;
                        while (_local_6 < fpsArrayQuality.length) {
                            _local_5 = (_local_5 + fpsArrayQuality[_local_6]);
                            _local_6++;
                        }
                        _local_7 = (_local_5 / fpsArrayQuality.length);
                        _local_8 = arrQuality.indexOf(game.stage.quality);
                        if (((_local_7 < 12) && (_local_8 > 0))) {
                            game.stage.quality = arrQuality[(_local_8 - 1)];
                        }
                        if (((_local_7 >= 12) && (_local_8 < 2))) {
                            game.stage.quality = arrQuality[(_local_8 + 1)];
                        }
                        fpsArrayQuality = [];
                    }
                }
            }
            fpsTS = new Date().getTime();
        } catch (e) {
        }
    }

    public function onZmanagerEnterFrame(_arg_1:Event):* {
        calculateFPS();

        if (!needsZSort) return;

        var zSortArr:Array = [];

        for (var i:int = 0; i < CHARS.numChildren; i++) {
            var zMC:MovieClip = MovieClip(CHARS.getChildAt(i));
            if (String(zMC.name).indexOf("%") > -1) continue;
            zSortArr.push({ mc: zMC, oy: zMC.y });
        }

        zSortArr.sortOn("oy", Array.NUMERIC);

        for (var j:int = 0; j < zSortArr.length; j++) {
            zMC = zSortArr[j].mc;
            var mcIndex:int = CHARS.getChildIndex(zMC);
            if (mcIndex != j) {
                CHARS.swapChildrenAt(mcIndex, j);
            }
        }

        needsZSort = false;
    }

    public function iaTrigger(_arg_1:MovieClip):* {
        var _local_2:*;
        var _local_3:int;
        if (coolDown("doIA")) {
            _local_2 = [];
            _local_2.push(_arg_1.iaType);
            _local_2.push(_arg_1.name);
            if (("iaPathMC" in _arg_1)) {
                _local_2.push(myAvatar.dataLeaf.strFrame);
            } else {
                _local_2.push(_arg_1.iaFrame);
            }
            if (("iaStr" in _arg_1)) {
                _local_2.push(_arg_1.iaStr);
            }
            if (("iaPathMC" in _arg_1)) {
                _local_2.push(_arg_1.iaPathMC);
            }
            trace(((("xtArr: " + _local_2) + " str: ") + _arg_1.isStr));
            _local_3 = 0;
            while (_local_3 < _local_2.length) {
                trace(((_local_3 + " isNull: ") + (_local_2[_local_3] == null)));
                _local_3++;
            }
            game.net.send("ia", _local_2);
        }
    }

    public function actCastRequest(o:Object):void {
        var xtArr:Array;
        var params:Array;
        var co:Object;
        xtArr = ["castr"];
        params = [];
        switch (o.typ) {
            case "sia":
                if (coolDown("doIA")) {
                    co = {};
                    co.typ = "sia";
                    co.callback = actCastTrigger;
                    co.args = o;
                    co.dur = Number(o.sAccessCD);
                    co.txt = o.sMsg;
                    game.ui.mcCastBar.fOpenWith(co);
                    params.push(1);
                    params.push(o.ID);
                }
                break;
        }
        if (params.length > 0) {
            game.net.send(xtArr.toString(), params);
        }
    }

    public function actCastTrigger(_arg_1:Object):void {
        switch (_arg_1.typ) {
            case "sia":
                siaTrigger(_arg_1);
                return;
        }
    }

    public function siaTrigger(_arg_1:Object):void {
        game.net.send(["castt"].toString(), []);
    }

    public function uoTreeLeaf(_arg_1:*):Object {
        if (uoTree[_arg_1.toLowerCase()] == null) {
            uoTree[_arg_1.toLowerCase()] = {};
        }
        return (uoTree[_arg_1.toLowerCase()]);
    }

    public function myLeaf():Object {
        return (uoTreeLeaf(game.net.myUserName));
    }

    public function uoTreeLeafSet(_arg_1:*, _arg_2:Object):* {
        var _local_3:*;
        var _local_5:*;
        var _local_6:*;
        if (uoTree[_arg_1.toLowerCase()] == null) {
            uoTree[_arg_1.toLowerCase()] = {};
        }
        _local_3 = uoTree[_arg_1.toLowerCase()];
        var _local_4:* = [];
        for (_local_5 in _arg_2) {
            _local_3[_local_5] = _arg_2[_local_5];
            _local_6 = getAvatarByUserName(_arg_1);
            if (((!(_local_6 == null)) && (!(_local_6.objData == null)))) {
                _local_6.objData[_local_5] = _arg_2[_local_5];
            }
        }
    }

    public function manageAreaUser(_arg_1:String, _arg_2:String):void {
        var _local_3:int;
        _arg_1 = _arg_1.toLowerCase();
        if (_arg_2 == "+") {
            if (areaUsers.indexOf(_arg_1) == -1) {
                areaUsers.push(_arg_1);
            }
        } else {
            _local_3 = areaUsers.indexOf(_arg_1);
            if (_local_3 > -1) {
                areaUsers.splice(_local_3, 1);
            }
        }

        game.updateAreaName();
    }

    public function updateAreaUserCount():void {
    }

    public function setAllCloakVisibility():void {
        var _local_1:Array;
        var _local_2:Avatar;
        _local_1 = getUsersByCell(myAvatar.dataLeaf.strFrame);
        for each (_local_2 in _local_1) {
            _local_2.pMC.setCloakVisibility(_local_2.dataLeaf.showCloak);
        }
    }

    public function coolDown(_arg_1:String):Boolean {
        var _local_2:*;
        var _local_3:*;
        var _local_4:*;
        var _local_5:*;
        _local_2 = lock[_arg_1];
        _local_3 = new Date();
        _local_4 = _local_3.getTime();
        _local_5 = (_local_4 - _local_2.ts);
        if (_local_5 < _local_2.cd) {
            game.chatF.pushMsg("warning", "Action taken too quickly, try again in a moment.", "SERVER", "", 0);
            return false;
        }
        _local_2.ts = _local_4;
        return true;
    }

    public function copyAvatarMC(_arg_1:MovieClip):void {
        var _local_2:AvatarMCCopier;
        _local_2 = new AvatarMCCopier(this);
        _local_2.copyTo(_arg_1);
    }

    public function doLoadPet(_arg_1:Avatar):Boolean {
        return !(!game.uoPref.bPet || _arg_1 != myAvatar && hideOtherPets);
    }

    public function get Scale():Number {
        return (SCALE);
    }

    public function get bankinfo():BankController {
        return (bankController);
    }

//    public function mapScrollCheck():void
//    {
//        var scrollTarget:Point = new Point();
//        var scrollEase:Number = 1.5;
//
//        if (SCROLL) {
//			trace("MAP SCROLL CHECK > 1");
//            var p:Point = myAvatar.pMC.location;
//			trace("MAP SCROLL CHECK > 2");
//            var bounds:Rectangle = map.walk.getRect(stage);
//			trace("MAP SCROLL CHECK > 3");
//
//            var cd:int = ConfigurationData.CLIENT_WIDTH / 2;
//            var left:int = 0;
//            var right:int = Math.round(ConfigurationData.CLIENT_WIDTH - bounds.width);
//
//            if (p.x < cd) {
//                scrollTarget.x = left;
//            } else if (p.x > bounds.width - cd) {
//                scrollTarget.x = right;
//            } else {
//                scrollTarget.x = map.x + Math.round(cd - (bounds.x + p.x));
//            }
//
//            var cdy:int = (ConfigurationData.CLIENT_HEIGHT / 2) - 50;
//            var top:int = 0;
//            var bottom:int = Math.floor(ConfigurationData.CLIENT_HEIGHT - bounds.height);
//            if (p.y < cdy) {
//                scrollTarget.y = top;
//            } else if (p.y > bounds.height - (ConfigurationData.CLIENT_HEIGHT - cdy)) {
//                scrollTarget.y = bottom;
//            } else {
//                scrollTarget.y = map.y + Math.round(cdy - (bounds.y + p.y));
//            }
//
//            map.x += (scrollTarget.x - map.x) * scrollEase;
//            CHARS.x += (scrollTarget.x - CHARS.x) * scrollEase;
//            map.y += (scrollTarget.y - map.y) * scrollEase;
//            CHARS.y += (scrollTarget.y - CHARS.y) * scrollEase;
//        }
//    }

    public function getDropItem(itemId:int) : Object
    {
        for (var i:int = 0; i < dropMenu.length; i++)
        {
            var item:Object = dropMenu[i];

            if (item != null && item.ItemID == itemId) return item;
        }

        return null;
    }

    public function removeItemDrop(itemId:int) : void
    {
        for (var i:int = 0; i < dropMenu.length; i++)
        {
            var item:Object = dropMenu[i];

            if (item == null || item.ItemID != itemId) continue;

            dropMenu.splice(i, 1);
        }
    }

    public function keepOrRemoveAllDrop(isKeep:Boolean) : void
    {
        if (dropMenu.length < 1)
        {
            game.Modal("No items to drop. It seems you don't have any items ready to be claimed or dropped.", null, {}, "red,medium", "mono");
            return;
        }

        var drops:Array = [];

        for each (var drop:Object in dropMenu) drops.push(drop.ItemID);

        game.net.send(isKeep ? "getDrop" : "denyDrop", drops);

        dropMenu.splice(0, dropMenu.length);

        var lootTemporary:MovieClip = MovieClip(game.ui.mcPopup.getChildByName("mcLoot"));
        lootTemporary.itemsInv = dropMenu;
        lootTemporary.update({"eventType": "refreshItems"});
        game.RefreshLootCount();
    }

    public function mapScrollCheck():void {
        if (!SCROLL) return;

        var p:Point = myAvatar.pMC.location;
        var bounds:Rectangle = map.walk.getRect(stage);
        var _halfWidth:int = ConfigurationData.CLIENT_WIDTH / 2;
        var _halfHeight:int = ConfigurationData.CLIENT_HEIGHT / 2;
        var _cdy:int = _halfHeight - 50;

        var mapChanged:Boolean = false;

        // Horizontal Scrolling
        var maxRight:int = bounds.width - _halfWidth;
        var minLeft:int = _halfWidth;
        var boundsX:int = bounds.x + p.x;

        if (p.x > minLeft && p.x < maxRight) {
            var xd:int = _halfWidth - boundsX;
            if (xd != 0) {
                map.x += xd;
                CHARS.x += xd;
            }
        } else {
            var targetX:int = 0;
            if (p.x < minLeft) {
                targetX = 0;
            } else if (p.x > maxRight) {
                targetX = ConfigurationData.CLIENT_WIDTH - bounds.width;
            }

            if (map.x != targetX) {
                map.x = targetX;
                CHARS.x = targetX;
                mapChanged = true;
            }
        }

        // Vertical Scrolling
        var maxBottom:int = bounds.height - (ConfigurationData.CLIENT_HEIGHT - _cdy);
        if (p.y > _cdy && p.y < maxBottom) {
            var xdy:int = _cdy - (bounds.y + p.y);
            if (xdy != 0) {
                map.y += xdy;
                CHARS.y += xdy;
                mapChanged = true;
            }
        } else {
            var targetY:int = 0;
            if (p.y < _cdy) {
                targetY = 0;
            } else if (p.y > maxBottom) {
                targetY = ConfigurationData.CLIENT_HEIGHT - bounds.height;
            }

            if (map.y != targetY) {
                map.y = targetY;
                CHARS.y = targetY;
                mapChanged = true;
            }
        }
    }

    public function tryRandomAction() : void
    {
        var i:int = new RandomNumber().rand(0, game.world.actions.active.length - 2); // SINCE THERE'S A TWO POTION AND WE DON'T WANT THAT SHIT TO CAST

        if (actionMap[i] != null)
        {

            var actionRef:Object = getActionByRef(actionMap[i]);

            if (!actionTimeCheck(actionRef))
            {
                tryRandomAction();
                return;
            }

            if (actionRef.isOK)
            {
                testAction(actionRef);
            }

        }
    }

}

}


