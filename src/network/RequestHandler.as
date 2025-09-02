package network {

import com.greensock.TweenLite;

import flash.display.Shape;
import UI.Display.goldDisplay;
import UI.Display.xpDisplay;
import UI.Display.xpDisplayBonus;
import assets.ib1;
import assets.ib2;
import fl.motion.Color;
import flash.display.MovieClip;
import flash.events.MouseEvent;
import flash.geom.ColorTransform;
import flash.utils.getTimer;
import game.config.ConfigurationData;
import game.controller.QuestController;
import game.fia.FiaPanel;
import game.pve.FloorReward;
import game.quest.Quests;
import game.wheel.mcWheelOfDoom_27;
import network.data.Room;
import network.data.User;

public class RequestHandler extends Object {

    private var game:Game;

    public function RequestHandler(game:Game) {
        this.game = game;
    }

    public function Protocol(o:Object):void {
        switch (o.cmd) {
            case "internal":
                Internal(o.args);
                break;
            case "loginResponse":
                LoginResponse(o);
                break;
            case "joinRoom":
                JoinRoom(o);
                break;
            case "enterRoom":
                EnterRoom(o);
                break;
            case "userGone":
                UserGone(o);
                break;
            case "moveToArea":
                MoveToArea(o);
                break;
            case "initUserData":
                InitUserData(o);
                break;
            case "initUserDatas":
                InitUserDatas(o);
                break;
            case "changeColor":
                ChangeColor(o);
                break;
            case "changeArmorColor":
                ChangeArmorColor(o);
                break;
            case "addGoldExp":
                AddGoldExp(o);
                break;
            case "levelUp":
                LevelUp(o);
                break;
            case "petLevelUp":
                PetLevelUp(o);
                break;
            case "loadInventoryBig":
                LoadInventoryBig(o);
                break;
            case "friends":
                Friends(o);
                break;
            case "initInventory":
                InitInventory(o);
                break;
            case "loadHouseInventory":
                LoadHouseInventory(o);
                break;
            case "house":
                House(o);
                break;
            case "buyBagSlots":
                BuyBagSlots(o);
                break;
            case "buyBankSlots":
                BuyBankSlots(o);
                break;
            case "buyHouseSlots":
                BuyHouseSlots(o);
                break;
            case "callfct":
                CallFct(o);
                break;
            case "genderSwap":
                GenderSwap(o);
                break;
            case "loadBank":
                LoadBank(o);
                break;
            case "bankFromInv":
                BankFromInv(o);
                break;
            case "bankToInv":
                BankToInv(o);
                break;
            case "bankSwapInv":
                BankSwapInv(o);
                break;
            case "loadShop":
                LoadShop(o);
                break;
            case "loadEnhShop":
                LoadEnhShop(o);
                break;
            case "enhanceItemShop":
                EnhanceItemShop(o);
                break;
            case "enhanceItemLocal":
                EnhanceItemLocal(o);
                break;
            case "loadHairShop":
                LoadHairShop(o);
                break;
            case "buyItem":
                BuyItem(o);
                break;
            case "favItem":
                FavoriteItem(o);
                break;
            case "sellItem":
                SellItem(o);
                break;
            case "removeItem":
                RemoveItem(o);
                break;
            case "updateClass":
                UpdateClass(o);
                break;
            case "equipItem":
                EquipItem(o);
                break;
            case "unequipItem":
                UnEquipItem(o);
                break;
            case "dropItem":
                DropItem(o);
                break;
            case "getDrop":
                GetDrop(o);
                break;
            case "addItems":
                AddItems(o);
                break;
            case "wheel":
                Wheel(o);
                break;
            case "forceAddItem":
                ForceAddItem(o);
                break;
            case "warvalues":
                WarValues(o);
                break;
            case "enhp":
                Enhp(o);
                break;
            case "turnIn":
                TurnIn(o);
                break;
            case "getTestQuests":
                GetTestQuests(o);
                break;
            case "questComplete":
                QuestComplete(o);
                break;
            case "updateQuest":
                UpdateQuest(o);
                break;
            case "initMonData":
                InitMonData(o);
                break;
            case "aura+":
            case "aura*":
            case "aura-":
            case "aura--":
            case "aura++":
            case "aura+p":
                Aura(o.cmd, o);
                break;
            case "clearAuras":
                ClearAuras(o);
                break;
            case "uotls":
                Uotls(o);
                break;
            case "mtls":
                Mtls(o);
                break;
			case "ntls":
                Ntls(o);
                break;
            case "cb":
                Cb(o);
                break;
            case "ct":
                Ct(o);
                break;
            case "sar":
                Sar(o);
                break;
            case "sars":
                Sars(o);
                break;
            case "showAuraResult":
                ShowAuraResult(o);
                break;
            case "anim":
                Anim(o);
                break;
            case "sAct":
                SAct(o);
                break;
            case "seia":
                Seia(o);
                break;
            case "stu":
                Stu(o);
                break;
            case "firstJoin":
                FirstJoin(o);
                break;
            case "event":
                Event(o);
                break;
            case "modinfo":
                ModInfo(o);
                break;
            case "modinc":
                ModInc(o);
                break;
            case "ia":
                Ia(o);
                break;
            case "siau":
                Siau(o);
                break;
            case "umsg":
                Umsg(o);
                break;
            case "gi":
                Gi(o);
                break;
            case "gd":
                Gd(o);
                break;
            case "ga":
                Ga(o);
                break;
            case "gr":
                Gr(o);
                break;
            case "guildDelete":
                GuildDelete(o);
                break;
            case "gMOTD":
                GMotd(o);
                break;
            case "updateGuild":
                UpdateGuild(o);
                break;
            case "gc":
                Gc(o);
                break;
            case "pi":
                Pi(o);
                break;
            case "pa":
                Pa(o);
                break;
            case "pr":
                Pr(o)
                break;
            case "pp":
                Pp(o);
                break;
            case "ps":
                Ps(o);
                break;
            case "pd":
                Pd(o);
                break;
            case "pc":
                Pc(o);
                break;
            case "PVPQ":
                PvpQ(o);
                break;
            case "PVPI":
                PvpI(o);
                break;
            case "PVPE":
                PvpE(o);
                break;
            case "PVPS":
                PvpS(o);
                break;
            case "PVPC":
                PvpC(o);
                break;
            case "di":
                Di(o);
                break;
            case "DuelEX":
                DuelEx(o);
                break;
            case "loadFactions":
                LoadFactions(o);
                break;
            case "addFaction":
                AddFaction(o);
                break;
            case "loadFriendsList":
                LoadFriendsList(o);
                break;
            case "requestFriend":
                RequestFriend(o);
                break;
            case "addFriend":
                AddFriend(o);
                break;
            case "updateFriend":
                UpdateFriend(o);
                break;
            case "deleteFriend":
                DeleteFriend(o);
                break;
            case "isModerator":
                IsModerator(o);
                break;
            case "loadWarVars":
                LoadWarVars(o);
                break;
            case "setAchievement":
                SetAchievement(o);
                break;
            case "showAchievement":
                ShowAchievement(o);
                break;
            case "loadQuestStringData":
                LoadQuestStringData(o);
                break;
            case "gettimes":
                GetTimes(o);
                break;
            case "clockTick":
                ClockTick(o);
                break;
            case "castWait":
                CastWait(o);
                break;
            case "CatchResult":
                CatchResult(o);
                break;
            case "alchOnStart":
                AlchOnStart(o);
                break;
            case "alchComplete":
                AlchComplete(o);
                break;
            case "bookInfo":
                BookInfo(o);
                break;
            case "spellOnStart":
                SpellOnStart(o);
                break;
            case "spellComplete":
                SpellComplete(o);
                break;
            case "spellWaitTimer":
                SpellWaitTimer(o);
                break;
            case "playerDeath":
                PlayerDeath(o);
                break;
            case "getScrolls":
                GetScrolls(o);
                break;
            case "turninscroll":
                TurnInScrolls(o);
                break;
            case "addLoadout":
                AddLoadOut(o);
                break;
            case "removeLoadout":
                RemoveLoadOut(o);
                break;
            case "equipLoadout":
                EquipLoadOut(o);
                break;
            case "petSta":
                PetSta(o);
                break;
			case "retrievePetData":
			    RetrievePetData(o);
			    break;
            case "sendLinkedItems":
                SendLinkedItems(o);
                break;
            case "boosts":
                TestBoosts(o);
                break;
		    case "refreshGoldDisplay":
                RefreshGoldDisplay(o);
                break;
            case "refresh":
                Refresh(o);
                break;
			case "popupmsg":
			    Popupmsg(o);
				break;
			case "buySlots":
			    BuySlots(o);
				break;
            case "loadOffer":
                LoadOffer(o);
                break;
            case "startTrade":
                StartTrade(o);
                break;
            case "tradeCancel":
                TradeCancel(o);
                break;
            case "tradeFromInv":
                TradeFromInventory(o);
                break;
            case "tradeUnlock":
                TradeUnlock(o);
                break;
            case "tradeLock":
                TradeLock(o);
                break;
            case "ti":
                TradeRequest(o);
                break;
            case "tradeSwapInv":
                TradeSwapInventory(o);
                break;
            case "tradeToInv":
                TradeToInventory(o);
                break;
			case "tradeDeal":
		        TradeDeal(o);
		        break;
            case "floorReward":
                FloorRewards(o);
                break;
            case "autoAttack":
                AutoAttack(o);
                break;
			case "attackIndicator":
				AttackIndicator(o);
				break;
        }
    }

    private function Internal(o:Array):void {
        switch (o[0]) {
            case "loginMulti":
                LoginMulti(o);
                break;
            case "notify":
                Notify(o);
                break;
            case "logoutWarning":
                LogoutWarning(o);
                break;
            case "multiLoginWarning":
                MultiLoginWarning();
                break;
            case "serverf":
                ServerF(o);
                break;
            case "wheel":
            case "server":
            case "warning":
            case "moderator":
            case "administrator":
                DefaultMessage(o);
                break;
            case "gsupdate":
                GsUpdate(o);
                break;
            case "respawnMon":
                RespawnMonster(o);
                break;
            case "resTimed":
                ResTimed(o);
                break;
            case "exitArea":
                ExitArea(o);
                break;
            case "uotls":
                UotlsStr(o);
                break;
            case "mtls":
                MtlsStr(o);
                break;
            case "spcs":
                Spcs(o);
                break;
            case "cc":
                Cc(o);
                break;
            case "emotea":
                Emotea(o);
                break;
            case "em":
                Emotea(o);
                break;
            case "chatm":
                Chatm(o);
                break;
            case "whisper":
                Whisper(o);
                break;
            case "mute":
                Mute(o);
                break;
            case "unmute":
                UnMute();
                break;
            case "mvna":
                Mvna(o);
                break;
            case "mvnb":
                Mvnb(o);
                break;
            case "gtc":
                Gtc(o);
                break;
            case "mtcid":
                MtcId(o);
                break;
            case "Dragon Buff":
                DragonBuff();
                break;
            case "trap door":
                TrapDoor(o);
                break;
            case "gMOTD":
                GMotdStr(o);
                break;
            case "buyGSlots":
                BuyGSlots(o);
                break;
            case "gRename":
                GRename(o);
                break;
        }
    }

    private function LoginMulti(o:Array):void {
        if (o[2] != 1 || o[2] != "true") {
            game.mcConnDetail.showError("Login Failed!");
        }
    }

    private function Notify(o:Array):void {
        game.chatF.pushMsg("server", game.chatF.cleanStr(o[2]), "SERVER", "", 0);
        game.MsgBox.notify(game.chatF.cleanStr(o[2]));
    }

    private function LogoutWarning(o:Array):void {
        game.preference.data.logoutWarning = String(o[2]);
        game.preference.data.logoutWarningDur = Number(o[3]);
        game.preference.data.logoutWarningTS = new Date().getTime();

        try {
            game.preference.flush();
        } catch (e:Error) {
            trace(e.message);
        }
    }

    private function MultiLoginWarning():void {
        game.mcConnDetail.showError("Your account has been logged on from another computer. Please log back in to play.")
    }

    private function ServerF(o:Array):void {
        var silentMute:Boolean = false;
        var msg:String = o[2];
        var typ:String = "server";
        var msgT:String = game.stripWhite(msg.toLowerCase());

        if (game.chatF.strContains(msgT, game.chatF.illegalStrings)) {
            silentMute = true;
        }

        msgT = game.stripWhiteStrict(msg.toLowerCase());

        if (game.chatF.strContains(msgT, ["email", "password"])) {
            silentMute = true;
        }

        if (!silentMute) {
            game.chatF.pushMsg("server", msg, "SERVER", "", 0);
        }
    }

    private function DefaultMessage(o:Array):void {
        var msg:String = o[1];
        msg = game.chatF.cleanChars(msg);
        msg = game.chatF.cleanStr(msg);
        game.chatF.pushMsg(o[0], msg, "SERVER", "", 0);
    }

    private function GsUpdate(o:Array):void {
        try {
            game.world.map.killCount(o[2]);
        } catch (e:Error) {
            trace(e.message);
        }
    }

    private function RespawnMonster(o:Array):void {
        if (game.sfcSocial) {
            var monMapId:int = o[1];
            var mon:Avatar = game.world.getMonster(monMapId);
            var monLeaf:Object = game.world.monTree[monMapId];
            var monName:String = "";

            if (monLeaf != null && mon.objData != null && mon.objData.strFrame == game.world.strFrame) {
                monLeaf.targets = {};
                mon.pMC.respawn(monName);
                mon.pMC.x = mon.pMC.ox;
                mon.pMC.y = mon.pMC.oy;

                if (mon.objData.bRed == 1 && game.world.myAvatar.dataLeaf.intState > 0) {
                    game.world.aggroMon(monMapId);
                }
            }
        }
    }

    private function ResTimed(o:Array):void {
        if (o.length > 2 && String(o[0]) != null && String(o[1]) != null) {
            game.world.moveToCell(String(o[1]), String(o[2]));
        } else {
            game.world.moveToCell(game.world.spawnPoint.strFrame, game.world.spawnPoint.strPad);
        }

        game.world.map.transform.colorTransform = game.world.defaultCT;
        game.world.CHARS.transform.colorTransform = game.world.defaultCT;
    }

    private function ExitArea(o:Array):void {
        var uid:int = int(o[1]);
        var unm:String = String(o[2]);

        game.world.manageAreaUser(unm, "-");

        var avt:Object = game.world.avatars[uid];

        if (avt != null) {
            if (avt == game.world.myAvatar.target) {
                game.world.setTarget(null);
            }

            if (((!(avt.objData == null)) && (game.world.isPartyMember(avt.objData.strUsername)))) {
                game.world.updatePartyFrame({
                    "unm": avt.objData.strUsername,
                    "range": false
                });
            }

            game.world.destroyAvatar(uid);
            delete game.world.uoTree[unm];
        }
    }

    private function UotlsStr(o:Array):void {
        var ot:Object = {};
        var a:Array = o[2].split(",");
        var i:int = 0;

        while (i < a.length) {
            ot[a[i].split(":")[0]] = a[i].split(":")[1];
            i++;
        }

        game.userTreeWrite(String(o[1]), ot);
    }

    private function MtlsStr(o:Array):void {
        var ot:Object = {};
        var a:Array = o[3].split(",");
        var i:int = 0;

        while (i < a.length) {
            ot[a[i].split(":")[0]] = a[i].split(":")[1];
            i = (i + 1);
        }

        game.monsterTreeWrite(int(o[2]), ot);
    }

    private function Spcs(o:Array):void {
        var MonMapID:int = int(o[2]);
        var MonID:int = int(o[3]);
        var monLeaf:Object = game.world.monTree[MonMapID];
        var newMon:Object = {};
        var i:int = 0;

        if (game.world.mondef[MonID] != null) newMon = game.world.mondef[MonID];

        monLeaf.intHP = 0;
        monLeaf.intMP = 0;
        monLeaf.intHPMax = newMon.intHPMax;
        monLeaf.intMPMax = newMon.intMPMax;
        monLeaf.intState = 0;
        monLeaf.iLvl = newMon.iLvl;
        monLeaf.MonID = MonID;

        var cluster:Array = game.world.getMonsterCluster(MonMapID);
        i = 0;
        while (i < cluster.length) {
            var clMon:Object = cluster[i];
            if (monLeaf.MonID == clMon.objData.MonID) {
                if (monLeaf.strFrame == game.world.strFrame) {
                    game.world.CHARS.addChild(clMon.pMC);
                }
                clMon.dataLeaf = monLeaf;
            } else {
                if (monLeaf.strFrame == game.world.strFrame) {
                    game.world.TRASH.addChild(clMon.pMC);
                }
                clMon.dataLeaf = null;
            }
            i = (i + 1);
        }
    }

    private function Cc(o:Array):void {
        var strMsg:String = game.chatF.getCCText(o[2]);
        var unm:String = String(o[3]);
        var filter:Boolean = false;

        if (game.chatF.ignoreList.data.users != undefined) {
            if (game.chatF.ignoreList.data.users.indexOf(unm) > -1) {
                filter = true;
            }
        }

        if (!filter) {
            game.chatF.pushMsg("zone", strMsg, unm, "", 0);
        }
    }

    private function Emotea(o:Array):void {
        var unm:String = String(o[2]);
        var msg:String = game.chatF.cleanStr(String(o[3]));
        var silentMute:Boolean = false;

        while (msg.indexOf("  ") > -1) {
            msg = msg.split("  ").join(" ");
        }

        msg = game.chatF.cleanChars(msg);
        var msgT:String = game.stripWhiteStrict(msg.toLowerCase());

        if (game.chatF.strContains(msgT, game.chatF.illegalStrings)) {
            silentMute = true;
        }

        if (!silentMute) {
            game.chatF.pushMsg("event", msg, unm, "", 0);
        }
    }

    private function Chatm(o:Array):void {
        var str:String = game.chatF.cleanStr(String(o[1]), true, false, Boolean(int(o[6])));
        var unm:String = String(o[2]);
        var typ:String = str.substr(0, str.indexOf("~"));
        var msg:String = game.chatF.cleanChars(str.substr((str.indexOf("~") + 1)));
        var filter:Boolean = false;

        if (game.chatF.ignoreList.data.users != undefined) {
            if (game.chatF.ignoreList.data.users.indexOf(unm.toLowerCase()) > -1) {
                filter = true;
            }
        }

        if (!filter) {
            game.chatF.pushMsg(typ, msg, unm, "", 1);
        }
    }

    private function Whisper(o:Array):void {
        var typ:String = "whisper";
        var msg:String = o[2];
        var snd:String = String(o[3]);
        var rcp:String = String(o[4]);
        var org:int = int(o[5]);
        var filter:Boolean = false;

        msg = game.chatF.cleanStr(msg);
        msg = game.chatF.cleanChars(msg);

        if (msg.indexOf(":=sm") > -1) {
            msg = msg.substr(0, msg.indexOf(":=sm"));
        }

        if (game.chatF.ignoreList.data.users != undefined) {
            if (game.chatF.ignoreList.data.users.indexOf(snd.toLowerCase()) > -1) {
                filter = true;
            }
        }

        if (!filter || snd == rcp) {
            if (snd.toLowerCase() != game.net.myUserName.toLowerCase()) {
                game.chatF.pmSourceA = [snd];
                if (game.chatF.pmSourceA.length > 20) {
                    game.chatF.pmSourceA.splice(0, (game.chatF.pmSourceA.length - 20));
                }
            }

            if (org == 1) {
                game.chatF.pushMsg(typ, msg, snd, rcp, 0);
                game.chatF.pushMsg(typ, msg, snd, rcp, 1);
            } else {
                game.chatF.pushMsg(typ, msg, snd, rcp, org, int(o[6]));
            }
        }
    }

    private function Mute(o:Array):void {
        game.chatF.muteMe(int(o[2]));
    }

    private function UnMute():void {
        game.chatF.unmuteMe();
    }

    private function Mvna(o:Array):void {
        if (game.world.uoTree[game.net.myUserName].freeze == null || !game.world.uoTree[game.net.myUserName].freeze) {
            game.world.uoTree[game.net.myUserName].freeze = true;
        }
    }

    private function Mvnb(o:Array):void {
        if (game.world.uoTree[game.net.myUserName].freeze != null) {
            delete game.world.uoTree[game.net.myUserName].freeze;
        }
    }

    private function Gtc(o:Array):void {
        if (String(o[2]) != null && String(o[3]) != null) {
            game.world.moveToCell(String(o[2]), String(o[3]));
        }
    }

    private function MtcId(o:Array):void {
        if (o.length > 2) {
            game.world.moveToCellByIDb(Number(o[2]));
        }
    }

    private function DragonBuff():void {
        game.world.map.doDragonBuff();
    }

    private function TrapDoor(o:Array):void {
        game.world.map.doTrapDoor(o[2]);
    }

    private function GMotdStr(o:Array):void {
        game.world.myAvatar.objData.guild.MOTD = o[2];
    }

    private function BuyGSlots(o:Array):void {
        var slots:int = int(o[2]);

        if (!isNaN(slots)) {
            game.world.myAvatar.objData.intSilver = (game.world.myAvatar.objData.intSilver - (slots * 200));
        }

        if (game.ui.mcPopup.currentLabel == "GuildPanel") {
            game.ui.mcPopup.updateGuildWindow();
        }
    }

    private function GRename(o:Array):void {
        game.world.myAvatar.objData.intSilver = (game.world.myAvatar.objData.intSilver - 1000);
    }

    private function LoginResponse(o:Object):void {
	    trace ("RES => 1");
        if (o.success) {
		    trace ("RES => 2");
            game.mcConnDetail.showConn("Loading Character Data...");
            game.net.myUserId = o.myUserId;
            game.net.myUserName = o.myUserName;
            game.ts_login_client = new Date().getTime();
            game.ts_login_server = game.stringToDate(o.time).getTime();
            game.chatF.pushMsg("moderator", o.messageOfTheDay, "SERVER", "", 0);
            game.confirmTime = getTimer();
            game.resumeOnLoginResponse();
//            _game.retrieveInfo(o.settings.split(","));
        } else {
            game.mcConnDetail.showConn(o.msg);
        }
    }

    private function JoinRoom(o:Object):void {
        game.net.room = new Room();

        for each(var uo:Object in o.users) {
            var user:User = new User(uo.id, uo.name);
            user.setPlayerId(uo.id);
            game.net.room.addUser(user, uo.id);
        }
    }

    private function EnterRoom(o:Object):void {
        var user:User = new User(o.id, o.name);
        user.setPlayerId(o.id);
        game.net.room.addUser(user, o.id);
    }

    private function UserGone(o:Object):void {
        game.net.room.removeUser(o.id);
    }

    private function MoveToArea(o:Object):void {
        if (o.areaName.indexOf("battleon") > -1 && o.areaName.indexOf("battleontown") < 0) {
            game.openMenu();
            game.firstMenu = false;
        } else if (!game.firstMenu) {
            game.menuClose();
        }

        if (game.floorReward != null) game.destroyFloorReward();

        game.world.mapLoadInProgress = true;
        game.world.strAreaName = o.areaName;
        game.world.initObjExtra(o.sExtra);
        game.world.areaUsers = [];
        game.world.modID = -1;
        var myLeaf:Object = game.copyObj(game.world.uoTreeLeaf(game.net.myUserName));

        game.world.uoTree = {};
        if (myLeaf != null) {
            game.world.uoTree[game.net.myUserName] = myLeaf;
        }
        game.world.chaosNames = o.monName != null ? o.monName.split(",") : [];

        if (o.pvpTeam != null) {
            myLeaf.pvpTeam = o.pvpTeam;
            game.world.bPvP = true;
            game.ui.mcPortrait.pvpIcon.visible = true;
            game.ui.mcPortrait.partyLead.y = 18;
            game.world.setPVPFactionData(o.PVPFactions);
            if (!game.world.objExtra.hasOwnProperty("bChaos")) {
                game.updatePVPScore(o.pvpScore);
                game.showPVPScore();
            }
        } else {
            game.ui.mcPortrait.pvpIcon.visible = false;
            game.ui.mcPortrait.partyLead.y = 0;
            delete myLeaf.pvpTeam;
            game.world.bPvP = false;
            game.hidePVPScore();
            game.world.setPVPFactionData(null);
        }

        if (o.pvpScore != null) {
            game.updatePVPScore(o.pvpScore);
        }

        game.world.monTree = {};
        game.world.monsters = [];
        game.world.npcTree = {};
        game.world.npcs = [];

        for (var bi:int = 0; bi < o.uoBranch.length; bi++) {
            var branchA:Object = o.uoBranch[bi];
            var unm:String = branchA.uoName;
            var uoLeaf:Object = {};
            for (var nam:String in branchA) {
                var val:* = branchA[nam];
                if (["int", "tx", "ty", "sp", "pvpTeam"].indexOf(nam.toLowerCase()) > -1) {
                    val = int(val);
                }
                uoLeaf[nam] = val;
            }

            if (unm != game.net.myUserName) {
                uoLeaf.auras = [];
            }

            uoLeaf.targets = {};
            game.world.uoTreeLeafSet(unm, uoLeaf);
            game.world.manageAreaUser(unm, "+");
        }

        for (bi = 0; bi < o.monBranch.length; bi++) {
            branchA = o.monBranch[bi];
            var monLeaf:Object = {};
            var mID:String = "1";
            for (nam in branchA) {
                val = branchA[nam];
                if (nam.toLowerCase().indexOf("monmapid") > -1) {
                    mID = val;
                }
                if (["int", "monid", "monmapid"].indexOf(nam.toLowerCase()) > -1) {
                    val = int(val);
                }
                monLeaf[nam] = val;
            }

            monLeaf.auras = [];
            monLeaf.targets = {};
            monLeaf.strBehave = "walk";
            game.world.monTree[mID] = monLeaf;
        }

        for (bi = 0; bi < o.npcBranch.length; bi++) {
            branchA = o.npcBranch[bi];
            var npcLeaf:Object = {};
            mID = "1";
            for (nam in branchA) {
                val = branchA[nam];
                if (nam.toLowerCase().indexOf("npcmapid") > -1) {
                    mID = val;
                }
                if (["int", "npcid", "npcmapid"].indexOf(nam.toLowerCase()) > -1) {
                    val = int(val);
                }
                npcLeaf[nam] = val;
            }

            npcLeaf.auras = [];
            npcLeaf.targets = {};
            npcLeaf.strBehave = "walk";
            game.world.npcTree[mID] = npcLeaf;
        }

        trace("MoveToArea > " + JSON.stringify(game.world.npcTree));

        game.world.setMapEvents("event" in o ? o.event : null);
        game.world.setCellMap("cellMap" in o ? o.cellMap : null);

        if (game.world.strFrame != "") {
            game.world.exitCell();
        }

        game.world.killLoaders();
        game.world.clearMonstersAndProps();
        game.world.clearAllAvatars();
        game.world.avatars[game.net.myUserId] = game.world.myAvatar;
        game.world.strMapName = o.strMapName;
        game.world.strMapFileName = o.strMapFileName;
        game.world.isTimeline = o.isTimeline;
        game.world.intType = o.intType;
        game.world.intKillCount = o.intKillCount;
        game.world.objLock = o.objLock != null ? o.objLock : null;
        game.world.timeline = o.hasOwnProperty("timeline") ? o.timeline : null;

        if (o.hasOwnProperty("FloorDuration")) game.world.floorDuration = int(o.FloorDuration);

        if (o.hasOwnProperty("monsters"))
        {
            game.world.mondef = o.monsters.definition;
            game.world.monmap = o.monsters.map;
        }
        else
        {
            game.world.mondef = null;
            game.world.monmap = [];
        }

        if (o.hasOwnProperty("npcdef") && o.hasOwnProperty("npcmap"))
        {
            game.world.npcdef = o.npcdef;
            game.world.npcmap = o.npcmap;
        }
        else
        {
            game.world.npcdef = [];
            game.world.npcmap = [];
        }

        game.world.isFloor = Boolean(o.isFloor);
        game.world.isDungeon = Boolean(o.isDungeon);
        game.world.curRoom = Number(o.areaId);
        game.world.actionResultsMon = {};
        game.world.actionResults = {};
        game.world.mapBoundsMC = null;
        game.chatF.chn.zone.rid = game.world.curRoom;
        game.world.initHouseData("houseData" in o ? o.houseData : null);

        game.world.updatePartyFrame();
        game.world.clearLoaders();
        game.world.loadMap(o.strMapFileName.toLowerCase());
        game.elmType = o.elmType;
    }

    private function InitUserData(o:Object):void {
        try {
            var avt:Avatar = game.world.getAvatarByUserID(o.uid);
            var uoLeaf:Object = avt.dataLeaf;
            if (avt != null && uoLeaf != null) {
                avt.initAvatar({"data": o.data});
                if (avt.isMyAvatar) {
                    game.loadGameMenu();
                    avt.objData.strHomeTown = avt.objData.strMapName;
                    if (avt.objData.guild != null) {
                        game.chatF.chn.guild.act = 1;
                        if (String(avt.objData.guild.MOTD) != "undefined") {
                            game.chatF.pushMsg("guild", ("Message of the day: " + String(avt.objData.guild.MOTD)), "SERVER", "", 0);
                        }
                    }
                    if (avt.objData.iUpg > 0) {
                        if (avt.objData.iUpgDays < 0) {
                            game.chatF.pushMsg("moderator", "Your membership has expired. Please visit our website to renew your membership.", "SERVER", "", 0);
                        } else {
                            if (avt.objData.iUpgDays < 7) {
                                game.chatF.pushMsg("moderator", (("Your membership will expire in " + (Number(avt.objData.iUpgDays) + 1)) + " days. Please visit our website to renew your membership."), "SERVER", "", 0);
                            }
                        }
                    }
                    game.updateXPBar();
                    if (game.ui.mcPopup.currentLabel == "Inventory") {
                        MovieClip(game.ui.mcPopup.getChildByName("mcInventory")).update({"eventType": "refreshCurrency"});
                    }
                    trace(("resObj.uid: " + o.uid));
                    game.world.getInventory(o.uid);
                    game.world.initAchievements();
                    game.readIA1Preferences();
                }
            }
        } catch (e:Error) {
            trace("initUserData > ");
            trace(e);
        }
    }

    private function InitUserDatas(o:Object):void {
        var a:Array = o.a;
        var i:int = 0;
        while (i < a.length) {
            var ot:Object = a[i];
            try {
                var avt:Avatar = game.world.getAvatarByUserID(ot.uid);
                var uoLeaf:Object = avt.dataLeaf;
                if (((!(avt == null)) && (!(uoLeaf == null)))) {
                    avt.initAvatar({"data": ot.data});

                    if (((avt.isMyAvatar) && ((avt.items == null) || (avt.items.length < 1)))) {
                        game.loadGameMenu();
                        avt.objData.strHomeTown = avt.objData.strMapName;
                        if (avt.objData.guild != null) {
                            game.chatF.chn.guild.act = 1;
                            if (String(avt.objData.guild.MOTD) != "undefined") {
                                game.chatF.pushMsg("guild", ("Message of the day: " + String(avt.objData.guild.MOTD)), "SERVER", "", 0);
                            }
                        }
                        if (avt.objData.iUpg > 0) {
                            if (avt.objData.iUpgDays < 0) {
                                game.chatF.pushMsg("moderator", "Your membership has expired. Please visit our website to renew your membership.", "SERVER", "", 0);
                            } else {
                                if (avt.objData.iUpgDays < 7) {
                                    game.chatF.pushMsg("moderator", (("Your membership will expire in " + (Number(avt.objData.iUpgDays) + 1)) + " days. Please visit our website to renew your membership."), "SERVER", "", 0);
                                }
                            }
                        }
                        game.updateXPBar();

                        if (game.ui.mcPopup.currentLabel == "Inventory") {
                            MovieClip(game.ui.mcPopup.getChildByName("mcInventory")).update({"eventType": "refreshCurrency"});
                        }

                        game.world.getInventory(ot.uid);
                        game.world.initAchievements();
                        game.readIA1Preferences();
                    }
                }
            } catch (e:Error) {
                trace("initUserDatas > ");
                trace(e);
            }

            i++;
        }
    }

    private function ChangeColor(o:Object):void {
        var avt:Avatar = game.world.getAvatarByUserID(o.uid);
        if (((!(avt == null)) && (avt.bitData))) {
            if (avt.isMyAvatar) {
                game.showPortrait(avt);
            } else {
                if (o.HairID != null) {
                    avt.objData.HairID = o.HairID;
                    avt.objData.strHairName = o.strHairName;
                    avt.objData.strHairFilename = o.strHairFilename;
                    if (((!(avt.pMC == null)) && (!(avt.pMC.stage == null)))) {
                        avt.pMC.loadHair();
                    }
                }
                avt.objData.intColorSkin = o.intColorSkin;
                avt.objData.intColorHair = o.intColorHair;
                avt.objData.intColorEye = o.intColorEye;
                if (((!(avt.pMC == null)) && (!(avt.pMC.stage == null)))) {
                    avt.pMC.updateColor();
                }
            }
        } else {
            trace("can't set data!");
        }
    }

    private function ChangeArmorColor(o:Object):void {
        var avt:Avatar = game.world.getAvatarByUserID(o.uid);
        if (((!(avt == null)) && (avt.bitData))) {
            if (!avt.isMyAvatar) {
                avt.objData.intColorBase = o.intColorBase;
                avt.objData.intColorTrim = o.intColorTrim;
                avt.objData.intColorAccessory = o.intColorAccessory;
                if (((!(avt.pMC == null)) && (!(avt.pMC.stage == null)))) {
                    avt.pMC.updateColor();
                }
            }
        } else {
            trace("can't set data!");
        }
    }

    private function AddGoldExp(o:Object):void {
        if (o.intExp != null && o.intExp > 0) {

            if (game.bAnalyzer && game.bAnalyzer.isRunning) game.bAnalyzer.addExp(o.intExp);

            var mon:Avatar;
            var deltaXP:int = o.intExp;
            game.world.myAvatar.objData.intExp = (game.world.myAvatar.objData.intExp + deltaXP);
            game.updateXPBar();

            if (game.world.myAvatar.petMC.objData != null)
            {
                game.world.myAvatar.petMC.objData.data.XP += deltaXP;

                if (game.ui.mcPopup.currentLabel == "PetPanel") {
                    MovieClip(game.ui.mcPopup.getChildByName("mcPetPanel")).update({"eventType": "updatePetExp"});
                }
            }

            var xp:xpDisplay = new xpDisplay();
            xp.t.ti.text = (deltaXP + " xp");
            var xpB:* = null;
            if (("bonusExp" in o)) {
                xpB = new xpDisplayBonus();
                xpB.t.ti.text = String((("+ " + o.bonusExp) + " xp!"));
                xp.t.ti.text = ((deltaXP - o.bonusExp) + " xp");
            }
            if (o.typ != null && o.typ == "m") {
                mon = game.world.getMonster(o.id);
                xp.x = mon.pMC.mcChar.x;
                xp.y = (mon.pMC.mcChar.y - 40);
                mon.pMC.addChild(xp);
                if (xpB != null) {
                    xpB.x = xp.x;
                    xpB.y = xp.y;
                    mon.pMC.addChild(xpB);
                }
            } else {
                xp.x = game.world.myAvatar.pMC.mcChar.x;
                xp.y = (game.world.myAvatar.pMC.pname.y + 10);
                game.world.myAvatar.pMC.addChild(xp);
                if (xpB != null) {
                    xpB.x = xp.x;
                    xpB.y = xp.y;
                    game.world.myAvatar.pMC.addChild(xpB);
                }
            }
        }
        if (o.intCopper != null && o.intCopper > 0) {
             if (game.bAnalyzer && game.bAnalyzer.isRunning) game.bAnalyzer.addCopper(o.intCopper);

            game.mixer.playSound("Coins");
            var deltaCopper:int = o.intCopper;
            game.world.myAvatar.objData.intCopper = (game.world.myAvatar.objData.intCopper + o.intCopper);
            if (game.ui.mcPopup.currentLabel == "Inventory") {
                MovieClip(game.ui.mcPopup.getChildByName("mcInventory")).update({"eventType": "refreshCurrency"});
            }
            var copper:goldDisplay = new goldDisplay();
            copper.t.ti.htmlText = (deltaCopper + " <font color=\"#B87333\">copper</font>");
            copper.tMask.ti.htmlText = (deltaCopper + " copper");
            if (o.typ != null && o.typ == "m") {
                mon = game.world.getMonster(o.id);
                copper.x = mon.pMC.mcChar.x;
                copper.y = (mon.pMC.mcChar.y - 80);
                mon.pMC.addChild(copper);
            } else {
                copper.x = game.world.myAvatar.pMC.mcChar.x;
                copper.y = (game.world.myAvatar.pMC.pname.y - 90);
                game.world.myAvatar.pMC.addChild(copper);
            }
        }
		if (o.intSilver != null && o.intSilver > 0) {
             if (game.bAnalyzer && game.bAnalyzer.isRunning) game.bAnalyzer.addSilver(o.intSilver);

            var deltaSilver:int = o.intSilver;
            game.world.myAvatar.objData.intSilver = (game.world.myAvatar.objData.intSilver + o.intSilver);
            if (game.ui.mcPopup.currentLabel == "Inventory") {
                MovieClip(game.ui.mcPopup.getChildByName("mcInventory")).update({"eventType": "refreshCurrency"});
            }
            var silver:goldDisplay = new goldDisplay();
            silver.t.ti.htmlText = (deltaSilver + " <font color=\"#C0C0C0\">silver</font>");
            silver.tMask.ti.htmlText = (deltaSilver + " silver");
            if (o.typ != null && o.typ == "m") {
                mon = game.world.getMonster(o.id);
                silver.x = mon.pMC.mcChar.x;
                silver.y = (mon.pMC.mcChar.y - 50);
                mon.pMC.addChild(silver);
            } else {
                silver.x = game.world.myAvatar.pMC.mcChar.x;
                silver.y = (game.world.myAvatar.pMC.pname.y - 60);
                game.world.myAvatar.pMC.addChild(silver);
            }
        }
		if (o.intGold != null && o.intGold > 0) {
            if (game.bAnalyzer && game.bAnalyzer.isRunning) game.bAnalyzer.addGold(o.intGold);

            game.mixer.playSound("Coins");
            var deltaGold:int = o.intGold;
            game.world.myAvatar.objData.intGold = (game.world.myAvatar.objData.intGold + o.intGold);
            if (game.ui.mcPopup.currentLabel == "Inventory") {
                MovieClip(game.ui.mcPopup.getChildByName("mcInventory")).update({"eventType": "refreshCurrency"});
            }
            var gold:goldDisplay = new goldDisplay();
            gold.t.ti.htmlText = (deltaGold + " <font color=\"#FFCC00\">gold</font>");
            gold.tMask.ti.htmlText = (deltaGold + " gold");
            if (o.typ != null && o.typ == "m") {
                mon = game.world.getMonster(o.id);
                gold.x = mon.pMC.mcChar.x;
                gold.y = (mon.pMC.mcChar.y - 20);
                mon.pMC.addChild(gold);
            } else {
                gold.x = game.world.myAvatar.pMC.mcChar.x;
                gold.y = (game.world.myAvatar.pMC.pname.y - 30);
                game.world.myAvatar.pMC.addChild(gold);
            }
        }
        if (o.iCP != null) {
            var deltaCP:int = o.iCP;
            game.world.myAvatar.objData.iCP = (game.world.myAvatar.objData.iCP + deltaCP);
            game.world.myAvatar.updateArmorRep();
            var iRank:int = game.world.myAvatar.objData.iRank;
            game.world.myAvatar.updateRep();
            if (iRank != game.world.myAvatar.objData.iRank) {
                game.world.myAvatar.rankUp(game.world.myAvatar.objData.strClassName, game.world.myAvatar.objData.iRank);
            }
            var txtBonusCP:String = "";
            if (o.bonusCP == null) {
                o.bonusCP = 0;
            } else {
                txtBonusCP = ((" + " + o.bonusCP) + "(Bonus)");
            }
            game.chatF.pushMsg("server", ((((("Class Points for " + game.world.myAvatar.objData.strClassName) + " increased by ") + (deltaCP - o.bonusCP)) + txtBonusCP) + "."), "SERVER", "", 0);
        }
        if (o.FactionID != null) {
            if (o.bonusRep == null) {
                o.bonusRep = 0;
            }
            game.world.myAvatar.addRep(o.FactionID, o.iRep, o.bonusRep);
        }
    }

    private function LevelUp(o:Object):void {
        game.world.myAvatar.objData.intLevel = o.intLevel;
        game.world.myAvatar.objData.intExpToLevel = o.intExpToLevel;
        game.world.myAvatar.objData.intExp = 0;
        game.updateXPBar();
        game.showPortraitBox(game.world.myAvatar, game.ui.mcPortrait);
        game.world.myAvatar.levelUp();
        if (("updatePStats" in game.world.map)) {
            game.world.map.updatePStats();
        }
    }

    private function PetLevelUp(o:Object):void {
        var avt:Avatar = game.world.myAvatar;

        if (avt == null || avt.petMC.objData == null) return;

        game.world.myAvatar.healAnimation(true);
        game.world.myAvatar.objData.petMC.objData.data.Level = o.intLevel;
        game.world.myAvatar.objData.petMC.objData.data.XP = 0;
        game.world.myAvatar.objData.petMC.objData.data.XPToLevel = o.intExpToLevel;
        game.world.updatePetPortrait(avt);

        if (game.ui.mcPopup.currentLabel == "PetPanel") {
            MovieClip(game.ui.mcPopup.getChildByName("mcPetPanel")).update({"eventType": "updatePetExp"});
        }
    }

//    private function RetrievePetData(o:Object) : void {
//        var avt:Avatar = game.world.myAvatar;
//        var str:String;
//
//        if (!("pet" in avt.objData)) avt.objData.pet = {};
//
//        if (avt != null && avt.objData.pet != null && "data" in o) {
//            if (avt.objData.pet.hasOwnProperty("data"))
//            {
//                for (str in o.data) {
//                    if (avt.objData.pet.data.hasOwnProperty(str)) {
//                        avt.objData.pet.data[str] = o.data[str];
//                    }
//                }
//            } else {
//                avt.objData.pet.data = o.data;
//            }
//
//            game.ui.mcPetPortrait.visible = true;
//            game.ui.btnTargetPetPortraitClose.visible = true;
//            game.world.updatePetPortrait(avt);
//        }
//    }

    private function LoadInventoryBig(o:Object):void {
        trace("loadInventoryBig");
        game.world.myAvatar.iBankCount = int(o.bankCount);
        game.world.myAvatar.initInventory(o.items);
        game.world.initHouseInventory({
            "sHouseInfo": game.world.myAvatar.objData.sHouseInfo,
            "items": o.hitems
        });
        game.world.myAvatar.initFactions(o.factions);
        game.world.myAvatar.initGuild(o.guild);
		game.world.myAvatar.pMC.updateName();
        game.world.uiLock = false;
        game.world.myAvatar.invLoaded = true;
        if (("eventTrigger" in MovieClip(game.world.map))) {
            game.world.map.eventTrigger({"cmd": "userLoaded"});
        }
        game.world.myAvatar.checkItemAnimation();
    }

    private function Friends(o:Object):void {
        game.world.myAvatar.initFriendsList(o.friends);

        if (game.ui.mcPopup.currentLabel == "Panel") {
            var panel:FiaPanel = FiaPanel(game.ui.mcPopup.getChildByName("mcPanel"));
            panel.displayLists(game.world.myAvatar.friends);
        }

//        if (o.showList) {
//            var flo:Object = {};
//            flo.typ = "userListFriends";
//            flo.ul = game.world.myAvatar.friends;
//            game.ui.mcOFrame.fOpenWith(flo);
//        }
    }

    private function InitInventory(o:Object):void {
        trace("INIT INVENTORY");
        game.world.myAvatar.initInventory(o.items);
        if (("eventTrigger" in MovieClip(game.world.map))) {
            game.world.map.eventTrigger({"cmd": "userLoaded"});
        }
    }

    private function LoadHouseInventory(o:Object):void {
        game.world.initHouseInventory(o);
    }

    private function House(o:Object):void {
        game.MsgBox.notify(o.msg);
    }

    private function BuyBagSlots(o:Object):void {
        game.mixer.playSound("Heal");
        game.world.myAvatar.objData.iBagSlots = (game.world.myAvatar.objData.iBagSlots + Number(o.iSlots));
        game.world.myAvatar.objData.intSilver = (game.world.myAvatar.objData.intSilver - (Number(o.iSlots) * 200));
        game.MsgBox.notify((("You now have " + game.world.myAvatar.objData.iBagSlots) + " inventory spaces!"));
        if (game.ui.mcPopup.currentLabel == "Inventory") {
            MovieClip(game.ui.mcPopup.getChildByName("mcInventory")).update({"eventType": "refreshSlots"});
        }
        if (game.ui.mcPopup.currentLabel == "Shop") {
            MovieClip(game.ui.mcPopup.getChildByName("mcShop")).update({"eventType": "refreshSlots"});
        }
    }

    private function BuyBankSlots(o:Object):void {
        game.mixer.playSound("Heal");
        game.world.myAvatar.objData.iBankSlots = (game.world.myAvatar.objData.iBankSlots + Number(o.iSlots));
        game.world.myAvatar.objData.intSilver = (game.world.myAvatar.objData.intSilver - (Number(o.iSlots) * 200));
        game.MsgBox.notify((("You now have " + game.world.myAvatar.objData.iBankSlots) + " bank spaces!"));
        if (game.ui.mcPopup.currentLabel == "Inventory") {
            MovieClip(game.ui.mcPopup.getChildByName("mcInventory")).update({"eventType": "refreshSlots"});
        }
        if (game.ui.mcPopup.currentLabel == "Shop") {
            MovieClip(game.ui.mcPopup.getChildByName("mcShop")).update({"eventType": "refreshSlots"});
        }
    }

    private function BuyHouseSlots(o:Object):void {
        game.mixer.playSound("Heal");
        game.world.myAvatar.objData.iHouseSlots = (game.world.myAvatar.objData.iHouseSlots + Number(o.iSlots));
        game.world.myAvatar.objData.intSilver = (game.world.myAvatar.objData.intSilver - (Number(o.iSlots) * 200));
        game.MsgBox.notify((("You now have " + game.world.myAvatar.objData.iHouseSlots) + " house inventory spaces!"));
        if (game.ui.mcPopup.currentLabel == "Inventory") {
            MovieClip(game.ui.mcPopup.getChildByName("mcInventory")).update({"eventType": "refreshSlots"});
        }
        if (game.ui.mcPopup.currentLabel == "Shop") {
            MovieClip(game.ui.mcPopup.getChildByName("mcShop")).update({"eventType": "refreshSlots"});
        }
    }

    private function CallFct(o:Object):void {
        try {
            var fct:* = game.world.map[o.fctNam];
            (fct(o.fctParams));
        } catch (e:Error) {
            trace(e);
        }
    }

    private function GenderSwap(o:Object):void {
        var avt:Avatar = game.world.getAvatarByUserID(o.uid);
        if (((!(avt == null)) && (avt.bitData))) {
            if (o.bitSuccess == 1) {
                if (avt.isMyAvatar) {
                    game.MsgBox.notify("Your gender has been successfully changed.");
                    avt.objData.intGold = (avt.objData.intGold - o.intGold);
                }
                avt.objData.strGender = o.gender;
                avt.objData.HairID = o.HairID;
                avt.objData.strHairName = o.strHairName;
                avt.objData.strHairFilename = o.strHairFilename;
                avt.initAvatar({"data": avt.objData});
            }
        }
    }

    private function LoadBank(o:Object):void {
        if (o.bitSuccess) {
            if (((!(o.items == null)) && (!(o.items == "undefined")))) {
                game.world.addItemsToBank(o.items);
            }
            if (game.ui.mcPopup.currentLabel == "Bank") {
                MovieClip(game.ui.mcPopup.getChildByName("mcBank")).update({"eventType": "refreshBank"});
            } else {
                game.ui.mcPopup.fOpen("Bank");
            }
        } else {
            game.Modal("Error loading bank items!  Try logging out and back in to fix this problem.", null, {}, "red,medium", "mono");
        }
    }

    private function BankFromInv(o:Object):void {
        if ((("bSuccess" in o) && (o.bSuccess == 1))) {
            game.world.myAvatar.bankFromInv(o.ItemID);
            QuestController.refreshTracker();
            if (game.ui.mcPopup.currentLabel == "Bank") {
                MovieClip(game.ui.mcPopup.getChildByName("mcBank")).update({"eventType": "refreshItems"});
            }
        } else {
            game.Modal(o.msg, null, {}, "red,medium", "mono");
        }
    }

    private function BankToInv(o:Object):void {
        game.world.myAvatar.bankToInv(o.ItemID);
        QuestController.refreshTracker();
        if (game.ui.mcPopup.currentLabel == "Bank") {
            MovieClip(game.ui.mcPopup.getChildByName("mcBank")).update({"eventType": "refreshItems"});
        }
    }

    private function BankSwapInv(o:Object):void {
        game.world.myAvatar.bankSwapInv(o.invItemID, o.bankItemID);
        QuestController.refreshTracker();
        if (game.ui.mcPopup.currentLabel == "Bank") {
            MovieClip(game.ui.mcPopup.getChildByName("mcBank")).update({"eventType": "refreshItems"});
        }
    }

    private function LoadShop(o:Object):void {
        if ((((((!(game.world.shopinfo == null)) && ("ShopID" in game.world.shopinfo)) && (game.world.shopinfo.ShopID == o.shopinfo.ShopID)) && ("bLimited" in game.world.shopinfo)) && (game.world.shopinfo.bLimited))) {
            trace(" >>>> Shop reload detected");
            var i:int = 0;
            while (i < o.shopinfo.items.length) {
                game.world.shopinfo.items.push(o.shopinfo.items[i]);
                game.world.shopinfo.items.shift();
                i = (i + 1);
            }
            if (game.ui.mcPopup.currentLabel == "Shop") {
                MovieClip(game.ui.mcPopup.getChildByName("mcShop")).update({"eventType": "refreshItems"});
            } else {
                game.ui.mcPopup.fOpen("Shop");
            }
        } else {
            game.world.shopinfo = o.shopinfo;
            if (o.shopinfo.bHouse == 1) {
                trace("House Shop");
                game.ui.mcPopup.fOpen("HouseShop");
            } else {
                if (game.isMergeShop(o.shopinfo)) {
                    game.ui.mcPopup.fOpen("MergeShop");
                } else {
                    game.ui.mcPopup.fOpen("Shop");
                }
            }
        }
    }

    private function LoadEnhShop(o:Object):void {
        game.world.enhShopID = o.shopinfo.ShopID;
        game.world.enhShopItems = o.shopinfo.items;
        game.ui.mcPopup.fOpen("EnhShop");
    }

    private function EnhanceItemShop(o:Object):void {
        if (o.iCost != null) {
            game.world.myAvatar.objData.intGold = (game.world.myAvatar.objData.intGold - Number(o.iCost));
            if (game.ui.mcPopup.currentLabel == "Inventory") {
                MovieClip(game.ui.mcPopup.getChildByName("mcInventory")).update({"eventType": "refreshCurrency"});
            }
            if (game.ui.mcPopup.currentLabel == "Shop") {
                MovieClip(game.ui.mcPopup.getChildByName("mcShop")).update({"eventType": "refreshCurrency"});
            }
        }

        var iSel:Object = null;
        var eSel:Object = null;

        for each (o in game.world.myAvatar.items) {
            if (o.ItemID == o.ItemID) {
                iSel = o;
            }
        }

        iSel.iEnh = o.EnhID;
        iSel.EnhID = o.EnhID;
        iSel.EnhPatternID = o.EnhPID;
        iSel.EnhLvl = o.EnhLvl;
        iSel.EnhDPS = o.EnhDPS;
        iSel.EnhRng = o.EnhRng;
        iSel.EnhRty = o.EnhRty;
        game.mixer.playSound("Good");

        if (game.ui.mcPopup.currentLabel == "Inventory") {
            MovieClip(game.ui.mcPopup.getChildByName("mcInventory")).update({
                "eventType": "refreshItems",
                "sInstruction": "previewEquipOnly"
            });
        }

        if (game.ui.mcPopup.currentLabel == "Shop") {
            MovieClip(game.ui.mcPopup.getChildByName("mcShop")).update({
                "eventType": "refreshItems",
                "sInstruction": "closeWindows"
            });
        }

        game.Modal("You have upgraded <b>" + iSel.sName + "</b> with <b>" + o.EnhName + "</b>, level <b>" + o.EnhLvl + "</b>!", null, {}, "red,medium", "mono");
    }

    private function EnhanceItemLocal(o:Object):void {
        var iSel:Object = null;
        var eSel:Object = null;
        for each (o in game.world.myAvatar.items) {
            if (o.ItemID == o.ItemID) {
                iSel = o;
            }
        }
        iSel.iEnh = o.EnhID;
        iSel.EnhID = o.EnhID;
        iSel.EnhPatternID = o.EnhPID;
        iSel.EnhLvl = o.EnhLvl;
        iSel.EnhDPS = o.EnhDPS;
        iSel.EnhRng = o.EnhRng;
        iSel.EnhRty = o.EnhRty;
        game.mixer.playSound("Good");

        if (game.ui.mcPopup.currentLabel == "Inventory") {
            MovieClip(game.ui.mcPopup.getChildByName("mcInventory")).update({
                "eventType": "refreshItems",
                "sInstruction": "previewEquipOnly"
            });
        }

        if (game.ui.mcPopup.currentLabel == "Shop") {
            MovieClip(game.ui.mcPopup.getChildByName("mcShop")).update({
                "eventType": "refreshItems",
                "sInstruction": "closeWindows"
            });
        }

        game.Modal("You have upgraded <b>" + iSel.sName + "</b> with <b>" + o.EnhName + "</b>, level <b>" + o.EnhLvl + "</b>!", null, {}, "red,medium", "mono");
    }

    private function LoadHairShop(o:Object):void {
        game.world.hairshopinfo = o;
        game.openCharacterCustomize();
    }

    private function BuyItem(o:Object):void {
        if (o.bitSuccess == 0) {
            if ((("bSoldOut" in o) && (o.bSoldOut))) {
                if (game.world.shopinfo.bLimited) {
                    MovieClip(game.ui.mcPopup.getChildByName("mcShop")).update({
                        "eventType": "refreshShop",
                        "sInstruction": "closeWindows"
                    });
                }

                game.Modal(o.strMessage + " is no longer in stock.", null, {}, "red,medium", "mono");
            } else {
                if (o.strMessage != null) {
                    game.MsgBox.notify(o.strMessage);
                }
            }
        } else {
            if (o.strMessage != null)
            {
                game.MsgBox.notify(o.strMessage);
            }
            var item:Object = game.copyObj(game.world.shopBuyItem);
            item.iQty = o.iQty;
            item.CharItemID = o.CharItemID;
            item.bBank = o.bBank;

            if (item.bGold == 1) {
			    item.iHrs = 0;
                game.world.myAvatar.objData.intGold = (game.world.myAvatar.objData.intGold - Number(item.iCost * item.iQty));
            } else if (item.bSilver == 1) {
                game.world.myAvatar.objData.intSilver = (game.world.myAvatar.objData.intSilver - Number(item.iCost * item.iQty));
            } else {
                game.world.myAvatar.objData.intCopper = (game.world.myAvatar.objData.intCopper - Number(item.iCost * item.iQty));
            }

            if (game.ui.mcPopup.currentLabel == "Inventory") {
                MovieClip(game.ui.mcPopup.getChildByName("mcInventory")).update({"eventType": "refreshCurrency"});
            }

            game.showItemDrop(item, false);
            if (game.world.invTree[item.ItemID] == null) {
                game.world.invTree[item.ItemID] = game.copyObj(o);
                game.world.invTree[item.ItemID].iQty = 0;
            }
            game.world.myAvatar.addItem(item);
            if (item.bHouse == 1) {
                if (((item.sType == "House") && (!(game.world.isHouseEquipped())))) {
                    game.world.sendEquipItemRequest(item);
                    game.world.myAvatar.getItemByID(item.ItemID).bEquip = 1;
                }
                MovieClip(game.ui.mcPopup.getChildByName("mcShop")).update({"eventType":"refreshCurrency"});
                MovieClip(game.ui.mcPopup.getChildByName("mcShop")).update({
                    "eventType":"refreshItems",
                    "sInstruction":"closeWindows"
                });
                if (game.world.shopinfo.bLimited)
                {
                    MovieClip(game.ui.mcPopup.getChildByName("mcShop")).update({"eventType":"refreshShop"});
                }
                if (game.ui.mcPopup.currentLabel == "HouseInventory")
                {
                    MovieClip(game.ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshCurrency"});
                    MovieClip(game.ui.mcPopup.getChildByName("mcInventory")).update({
                        "eventType":"refreshItems",
                        "sInstruction":"closeWindows"
                    });
                }
            } else {
                if (game.ui.mcPopup.currentLabel == "Shop") {
                    MovieClip(game.ui.mcPopup.getChildByName("mcShop")).update({"eventType": "refreshCurrency"});
                    MovieClip(game.ui.mcPopup.getChildByName("mcShop")).update({
                        "eventType": "refreshItems",
                        "sInstruction": "closeWindows"
                    });
                    if (game.world.shopinfo.bLimited) {
                        MovieClip(game.ui.mcPopup.getChildByName("mcShop")).update({"eventType": "refreshShop"});
                    }
                } else {
                    if (game.ui.mcPopup.currentLabel == "MergeShop") {
                        MovieClip(game.ui.mcPopup.getChildByName("mcShop")).update({"eventType": "refreshCurrency"});
                        MovieClip(game.ui.mcPopup.getChildByName("mcShop")).update({"eventType": "refreshItems"});
                    } else {
                        if (game.ui.mcPopup.currentLabel == "Inventory") {
                            MovieClip(game.ui.mcPopup.getChildByName("mcInventory")).update({"eventType": "refreshCurrency"});
                            MovieClip(game.ui.mcPopup.getChildByName("mcInventory")).update({
                                "eventType": "refreshItems",
                                "sInstruction": "closeWindows"
                            });
                        }
                    }
                }
            }

            QuestController.updateQuest(item);
        }
    }

    private function FavoriteItem(o:Object): void {
        if (game.world.myAvatar.items[o.ItemID] != null) {
            game.world.myAvatar.items[o.ItemID].bFav = o.Favorite;
            game.world.invTree[o.ItemID].bFav = o.Favorite;

            if (game.ui.mcPopup.currentLabel == "Inventory") {
                MovieClip(game.ui.mcPopup.getChildByName("mcInventory")).update({
                    "eventType": "refreshItems"
                });
            }
        }
    }

    private function SellItem(o:Object):void {
        game.world.myAvatar.removeItem(o.CharItemID);
        if (o.bGold == 1) {
            game.world.myAvatar.objData.intGold = (game.world.myAvatar.objData.intGold + o.intAmount);
        } else if (o.bSilver == 1) {
            game.world.myAvatar.objData.intSilver = (game.world.myAvatar.objData.intSilver + o.intAmount);
        } else {
            game.world.myAvatar.objData.intCopper = (game.world.myAvatar.objData.intCopper + o.intAmount);
        }

        if (game.ui.mcPopup.currentLabel == "Shop") {
            MovieClip(game.ui.mcPopup.getChildByName("mcShop")).update({"eventType": "refreshCurrency"});
            MovieClip(game.ui.mcPopup.getChildByName("mcShop")).update({
                "eventType": "refreshItems",
                "sInstruction": "closeWindows"
            });
        } else {
            if (game.ui.mcPopup.currentLabel == "Inventory") {
                MovieClip(game.ui.mcPopup.getChildByName("mcInventory")).update({"eventType": "refreshCurrency"});
                MovieClip(game.ui.mcPopup.getChildByName("mcInventory")).update({
                    "eventType": "refreshItems",
                    "sInstruction": "closeWindows"
                });
            } else {
                if (game.ui.mcPopup.currentLabel == "HouseShop") {
                    MovieClip(game.ui.mcPopup.getChildByName("mcHouseShop")).reset();
                }
            }
        }

        QuestController.refreshTracker();
    }

    private function RemoveItem(o:Object):void {
        if (o.iQty != null) {
            game.world.myAvatar.removeItem(o.CharItemID, o.iQty);
        } else {
            game.world.myAvatar.removeItem(o.CharItemID);
        }

        if (game.ui.mcPopup.currentLabel == "Inventory") {
            MovieClip(game.ui.mcPopup.getChildByName("mcInventory")).update({"eventType": "refreshItems"});
        }

        QuestController.refreshTracker();
    }

    private function UpdateClass(o:Object):void {
        game.isNewClass = true;
        game.statsNewClass = true;
        var avt:Avatar = game.world.getAvatarByUserID(o.uid);
        if (((!(avt == null)) && (!(avt.objData == null)))) {
            avt.objData.strClassName = o.sClassName;
            avt.objData.iCP = o.iCP;
            avt.objData.sClassCat = o.sClassCat;
            avt.updateRep();
            if (o.uid == game.net.myUserId) {
                if (("sDesc" in o)) {
                    avt.objData.sClassDesc = o.sDesc;
                }
                if (("sStats" in o)) {
                    avt.objData.sClassStats = o.sStats;
                }
                if (("aMRM" in o)) {
                    avt.objData.aClassMRM = o.aMRM;
                }
            }
        }
    }

    private function EquipItem(o:Object):void {
        var avt:Avatar = game.world.getAvatarByUserID(o.uid);
        if (avt != null) {
            if (((!(avt.pMC == null)) && (!(avt.objData == null)))) {
                avt.objData.eqp[o.strES] = {};
                avt.objData.eqp[o.strES].sFile = ((o.sFile == "undefined") ? "" : o.sFile);
                avt.objData.eqp[o.strES].sLink = o.sLink;
                if (("sType" in o)) {
                    avt.objData.eqp[o.strES].sType = o.sType;
                }
                if (("ItemID" in o)) {
                    avt.objData.eqp[o.strES].ItemID = o.ItemID;
                }
                if (("sMeta" in o)) {
                    avt.objData.eqp[o.strES].sMeta = o.sMeta;
                }
                avt.loadMovieAtES(o.strES, o.sFile, o.sLink);
            }
            if (avt.isMyAvatar) {
                avt.equipItem(o.ItemID);
                if (MovieClip(game.ui.mcPopup.getChildByName("mcInventory")) != null) {
                    MovieClip(game.ui.mcPopup.getChildByName("mcInventory")).update({"eventType": "refreshItems"});
                }
                if (game.ui.mcPopup.mcTempInventory != null) {
                    game.ui.mcPopup.mcTempInventory.mcItemList.refreshList();
                    game.ui.mcPopup.mcTempInventory.refreshDetail();
                }
            }
        }
    }

    private function UnEquipItem(o:Object):void {
        var avt:Avatar = game.world.getAvatarByUserID(o.uid);
        if (avt != null) {
            if (avt.pMC != null) {
                delete avt.objData.eqp[o.strES];
                avt.unloadMovieAtES(o.strES);
            }
            if (avt.isMyAvatar) {
                avt.unequipItem(o.ItemID);
                if (game.ui.mcPopup.currentLabel == "Inventory") {
                    MovieClip(game.ui.mcPopup.getChildByName("mcInventory")).update({"eventType": "refreshItems"});
                }
                if (game.ui.mcPopup.mcTempInventory != null) {
                    game.ui.mcPopup.mcTempInventory.mcItemList.refreshList();
                    game.ui.mcPopup.mcTempInventory.refreshDetail();
                }
            }

            if (o.strES == "pe")
            {
				avt.petMC = null;
                game.ui.mcPetPortrait.visible = false;
                game.ui.btnTargetPetPortraitClose.visible = false;
            }
        }
    }

    private function DropItem(o:Object):void {
		trace("dropItem");
	
        for (var itemId:Object in o.items) {
            var fData:Object = null;

            if (game.world.invTree[itemId] == null) {
                game.world.invTree[itemId] = game.copyObj(o.items[itemId]);
                game.world.invTree[itemId].iQty = 0;
                fData = o.items[itemId];
            } else {
                fData = game.copyObj(game.world.invTree[itemId]);
                fData.iQty = int(o.items[itemId].iQty);

//                for (var invTreeKey:String in game.world.invTree[itemId])
//                {
//                    if (o.items[itemId][invTreeKey] != fData[invTreeKey])
//                    {
//                        fData[invTreeKey] = o.items[itemId][invTreeKey];
//
//                        if (invTreeKey != "iQty")
//                        {
//                            game.world.invTree[itemId][invTreeKey] = o.items[itemId][invTreeKey];
//                        }
//                    }
//                }
            }

            var dropItem:Object = game.world.getDropItem(int(itemId));

            if (dropItem != null)
            {
			    dropItem.iQty = fData.iQty + dropItem.iQty > fData.iStk ? dropItem.iStk : dropItem.iQty + int(o.items[itemId].iQty);
            }
            else
            {
                game.world.dropMenu.push(game.copyObj(o.items[itemId]));
            }

            if (game.ui.mcPopup.currentLabel == "Loot") {
				trace("dropItem > LOOT");
                var lootTemporary:MovieClip = MovieClip(game.ui.mcPopup.getChildByName("mcLoot"));
                lootTemporary.itemsInv = game.world.dropMenu;
                lootTemporary.update({"eventType": "refreshItems"});
            } else {
				trace("dropItem > LOOT SAD > " + game.ui.mcPopup.currentLabel);
			}

            fData.dID = itemId;
            fData.dQty = int(o.items[itemId].iQty);
            game.showItemDrop(fData, true);
			
			game.RefreshLootCount();
        }
    }

    private function GetDrop(o:Object) : void {
        if (!o.hasOwnProperty("drops")) return;

        var drops:Array = o.drops;

        trace("DROPS LENGTH => " + drops.length);

        for (var i:int = 0; i < drops.length; i++) {
            var item:Object = drops[i];

            for (var j:int = 0; j < game.ui.dropStack.numChildren; j++) {
                var mc:MovieClip = game.ui.dropStack.getChildAt(j) as MovieClip;

                if (mc.fData != null && mc.fData.ItemID == item.ItemID && item.bOut) {
                    if (item.bSuccess == 1) {
                        mc.gotoAndPlay("out");
                    } else {
                        game.Modal("Item could not be added to your inventory! Please make sure your inventory is not full or the item is already present in your inventory/bank.", null, {}, "red,medium", "mono");

                        mc.cnt.ybtn.mouseEnabled = true;
                        mc.cnt.ybtn.mouseChildren = true;
                    }
                }
            }

            try {
                if (item.bSuccess == 1) {
                    var dropitem:Object = game.copyObj(game.world.invTree[item.ItemID]);
                    dropitem.CharItemID = item.CharItemID;
                    dropitem.bBank = item.bBank;
                    dropitem.iQty = int(item.iQty);

                    if (item.EnhID != null) {
                        dropitem.EnhID = int(item.EnhID);
                        dropitem.EnhLvl = int(item.EnhLvl);
                        dropitem.EnhPatternID = int(item.EnhPatternID);
                        dropitem.EnhRty = int(item.EnhRty);
                    }

                    game.world.myAvatar.addItem(dropitem);
                    QuestController.updateQuest(dropitem);

                    if (item.showDrop == 1) {
                        game.showItemDrop(dropitem, false);
                    }

                    if (game.ui.mcPopup.currentLabel == "Inventory") {
                        MovieClip(game.ui.mcPopup.getChildByName("mcInventory")).update({"eventType": "refreshItems"});
                    }

                    if (((game.ui.mcPopup.currentLabel == "Shop") || (game.ui.mcPopup.currentLabel == "MergeShop"))) {
                        MovieClip(game.ui.mcPopup.getChildByName("mcShop")).update({"eventType": "refreshItems"});
                    }

                    if (game.ui.mcPopup.currentLabel == "Loot")
                    {
                        var lootTemporary:MovieClip = MovieClip(game.ui.mcPopup.getChildByName("mcLoot"));
                        lootTemporary.itemsInv = game.world.dropMenu;
                        lootTemporary.update({"eventType": "refreshItems"});
                    }

                    if (item.pendingID != null) {
                        game.world.myAvatar.updatePending(int(item.pendingID));
                    }

                    game.RefreshLootCount();
                }
            } catch (e:Error) {
                trace(e.message);
            }
        }
    }

    private function AddItems(o:Object):void {
        for (var ItemID:Object in o.items) {
            var itemObj:Object = null;

            if (game.world.invTree[ItemID] == null) {
                itemObj = game.copyObj(o.items[ItemID]);
            } else {
                itemObj = game.copyObj(game.world.invTree[ItemID]);
                itemObj.iQty = int(o.items[ItemID].iQty);
            }
            game.showItemDrop(itemObj, true);
            game.world.myAvatar.addTempItem(itemObj);

            QuestController.updateQuest(itemObj);

            if (itemObj.sMeta == "doUpdate") {
                try {
                    game.world.map.doUpdate();
                } catch (e:Error) {
                }
            }
        }
    }

    private function Wheel(o:Object):void {
        if (game.ui.mcPopup.currentLabel != "Wheel") return;

        var wheel:mcWheelOfDoom_27 = mcWheelOfDoom_27(game.ui.mcPopup.getChildByName("mcWheel"));

        if (wheel == null) return;

        wheel.update();
        wheel.sFrame = o.type;
        wheel.btnLever.gotoAndPlay("Opening");
        wheel.gotoAndPlay("Spin");

//        var dropItem:Object = game.copyObj(o.dropItems["18927"]);
//        dropItem.CharItemID = o.charItem1;
//        if (game.world.invTree["18927"] == null) {
//            dropItem.bBank = 0;
//        }
//        trace(("dropQty: " + o.dropQty));
//        dropItem.iQty = ((o.dropQty != null) ? Number(o.dropQty) : 1);
//        game.world.myAvatar.addItem(dropItem);
//        dropItem = game.copyObj(o.dropItems["19189"]);
//        dropItem.CharItemID = o.charItem2;
//        if (game.world.invTree["19189"] == null) {
//            dropItem.bBank = 0;
//        }
//        dropItem.iQty = 1;
//        game.world.myAvatar.addItem(dropItem);
//        if (o.Item != null) {
//            dropItem = game.copyObj(o.Item);
//            dropItem.CharItemID = o.CharItemID;
//            dropItem.bBank = 0;
//            dropItem.iQty = 1;
//            game.world.myAvatar.addItem(dropItem);
//        }
//        if (game.ui.mcPopup.currentLabel == "Inventory") {
//            MovieClip(game.ui.mcPopup.getChildByName("mcInventory")).update({"eventType": "refreshItems"});
//        }
//        try {
//            game.world.map.doWheelDrop(o.Item, o.dropQty);
//        } catch (e) {
//            trace(("error in wheel function: " + e));
//        }
    }

    private function ForceAddItem(o:Object):void {
        for (var fi:* in o.items) {
            game.world.myAvatar.addItem(game.copyObj(o.items[fi]));
        }
    }

    private function WarValues(o:Object):void {
        game.world.map.updateWarValues(o.wars);
    }

    private function Enhp(o:Object):void {
        for each (var ot:Object in o.o) {
            game.world.enhPatternTree[ot.ID] = ot;
        }
    }

    private function TurnIn(o:Object):void {
        if (((!(o.sItems == null)) && (o.sItems.length >= 3))) {
            var itemArr:Array = o.sItems.split(",");
            var dropIndex:int = 0;
            while (dropIndex < itemArr.length) {
                var dropID:int = itemArr[dropIndex].split(":")[0];
                var dropQty:int = int(itemArr[dropIndex].split(":")[1]);
                if (game.world.invTree[dropID].bTemp == 0) {
                    game.world.myAvatar.removeItemByID(dropID, dropQty);
                } else {
                    game.world.myAvatar.removeTempItem(dropID, dropQty);
                }
                dropIndex++;
            }
        }
        if (game.ui.mcPopup.currentLabel == "Inventory") {
            MovieClip(game.ui.mcPopup.getChildByName("mcInventory")).update({"eventType": "refreshItems"});
        }
    }

    private function GetTestQuests(o:Object) : void
    {
        QuestController.ClearData();

        for (var key:String in o.quests) QuestController.addQuest(int(key), Object(o.quests[key]));

        if (game.ui.ModalStack.numChildren > 0) MovieClip(game.ui.ModalStack.getChildAt(0)).open();
    }

    private function QuestComplete(o:Object) : void
    {
        if (("eventTrigger" in MovieClip(game.world.map))) {
            game.world.map.eventTrigger({
                "cmd": "questComplete",
                "args": o.questId
            });
        }

        QuestController.Unaccept(o.questId);

		var questObj:Object = game.world.myAvatar.objData.quests;

        if (o.hasOwnProperty("once") && Boolean(o.once) && questObj.indexOf(o.questId) == -1)
        {
            questObj.push(o.questId);
            QuestController.removeQuest(o.questId);
        }

/*
		if (o.hasOwnProperty("next") && QuestController.Data.hasOwnProperty(String(o.next)))
		{
            QuestController.Data[int(o.next)].Locked = null;
		}

*/


		if (o.hasOwnProperty("locked")) QuestController.Data[int(o.questId)].Locked = o.locked;

        var quest:Quests = game.getInstanceFromModalStack("Quests") as Quests;
        if (quest != null) quest.reset();
        if (o.hasOwnProperty("Achievement")) game.showAchievement(o.Achievement.Name, -1);
        game.ui.mcQuestTracker.update();
        game.showQuestpopup(o);
    }

    private function UpdateQuest(o:Object):void {
        game.world.setQuestValue(o.iIndex, o.iValue);
    }

    private function InitMonData(o:Object):void {
        for (var m:Object in o.mon) {
            game.world.updateMonster(o.mon[m]);
        }
    }

    private function Aura(cmd:String, o:Object):void {
        game.world.handleAuraEvent(cmd, o);
    }

    private function ClearAuras(o:Object):void {
        var tAvt:Avatar = game.world.myAvatar;
        var tLeaf:Object = tAvt.dataLeaf;
        game.world.showAuraChange({
            "cmd": "aura-",
            "auras": tLeaf.auras
        }, tAvt, tLeaf);
        tLeaf.auras = [];
    }

    private function Uotls(o:Object):void {
        game.userTreeWrite(o.unm, o.o);
    }

    private function Mtls(o:Object):void {
        game.monsterTreeWrite(o.id, o.o, o.targets);
    }
	
	private function Ntls(o:Object):void {
        game.npcTreeWrite(o.id, o.o, o.targets);
    }

    private function Cb(o:Object):void {
        var updateId:String;

        if (o.m != null) {
            for (updateId in o.m) {
                game.monsterTreeWrite(int(updateId), o.m[updateId]);
            }
        }
        if (o.p != null) {
            for (updateId in o.p) {
                game.userTreeWrite(updateId, o.p[updateId]);
            }
        }
		if (o.t != null) {
            for (updateId in o.t) {
                game.userPetTreeWrite(updateId, o.t[updateId]);
            }
        }
        if (o.n != null) {
            for (updateId in o.n) {
                game.npcTreeWrite(int(updateId), o.n[updateId]);
            }
        }
        if (o.anims != null) {
            if (game.sfcSocial) {
                for each (o in o.anims) {
                    if (o.isProc) {
                        game.doAnim(o, o.isProc);
                    } else {
                        game.doAnim(o);
                    }
                }
            }
        }
        if (o.a != null) {
            var i:int = 0;
            while (i < o.a.length) {
                game.world.handleAuraEvent(o.a[i].cmd, o.a[i]);
                i++;
            }
        }
    }

    private function Ct(o:Object):void {
        var anim:Object = {};
        var updateId:String;

        if (o.m != null) {
            for (updateId in o.m) {
                game.monsterTreeWrite(int(updateId), o.m[updateId]);
            }
        }

        if (o.p != null) {
            for (updateId in o.p) {
                game.userTreeWrite(updateId, o.p[updateId]);
            }
        }
		if (o.t != null) {
            for (updateId in o.t) {
                game.userPetTreeWrite(updateId, o.t[updateId]);
            }
        }
        if (o.n != null) {
            for (updateId in o.n) {
                game.npcTreeWrite(int(updateId), o.n[updateId]);
            }
        }

        if (o.a != null) {
            var j:int = 0;
            while (j < o.a.length) {
                try {
                    var k:int = 0;
                    while (k < o.a[j].auras.length) {
                        if (o.a[j].auras[k].spellOn != null) {
                            anim[o.a[j].auras[k].spellOn] = o.a[j].auras[k].dur;
                        }
                        k++;
                    }
                } catch (e:Error) {
                }
                game.world.handleAuraEvent(o.a[j].cmd, o.a[j]);
                j++;
            }
        }

        if (o.sara != null) {
            for each (var sara:Object in o.sara) {
                game.world.handleSAR(sara);
            }
        }

        if (o.sarsa != null) {
            for each (var sarsa:Object in o.sarsa) {
                game.world.handleSARS(sarsa);
            }
        }

        if (o.anims != null) {
            if (game.sfcSocial) {
                for each (var ot:Object in o.anims) {
                    game.doAnim(ot, ot.isProc ? ot.isProc : false, anim[ot.strl]);
                }
            }
        }

        if (o.sounds != null) {
            var sounds:Array = String(o.sounds).split(",");

            for (var i:int = 0; i < sounds.length; i++)
            {
                game.mixer.playSound(sounds[i]);
            }
        }

        if (o.pvp != null) {
            switch (o.pvp.cmd) {
                case "PVPS":
                    game.updatePVPScore(o.pvp.pvpScore);
                    break;
                case "PVPC":
                    game.world.PVPResults.pvpScore = o.pvp.pvpScore;
                    game.world.PVPResults.team = o.pvp.team;
                    game.updatePVPScore(o.pvp.pvpScore);
                    game.togglePVPPanel("results");
                    break;
            }
        }

        if (game.preference.data.bAuras)
        {
            game.targetAura.handleAura(o);
            game.playerAura.handleAura(o);
        }
    }

    private function Sar(o:Object):void {
        game.world.handleSAR(o);
    }

    private function Sars(o:Object):void {
        game.world.handleSARS(o);
    }

    private function ShowAuraResult(o:Object):void {
        game.world.showAuraImpact(o);
    }

    private function Anim(o:Object):void {
        if (game.sfcSocial) {
            game.doAnim(o);
        }
    }

    private function SAct(o:Object):void {
        if (game.isNewClass)
        {
            game.ui.mcInterface.actBar.visible = false;
            game.onRemoveChildren(game.ui.mcInterface.actBar);

            game.world.actions = {};
            game.world.actions.active = [];
            game.world.actions.passive = [];
            game.world.actionMap = [];

            for (var am:int = 0; am < o.actions.active.length; am++)
            {
                var blank:ib1 = new ib1();
                blank.width = 42;
                blank.height = 39;
                blank.name = "blank" + am;
                blank.x = 45 * am;
                game.ui.mcInterface.actBar.addChild(blank);

                var actCD:ActBarCD = new ActBarCD();
                actCD.name = "txtCD" + am;
                actCD.x = blank.x + (blank.width - actCD.width) / 2;
                actCD.y = blank.y + (blank.height - actCD.height) / 2;
                actCD.y = actCD.y - 7;
                actCD.mouseEnabled = false;
                game.ui.mcInterface.actBar.addChild(actCD);

                var bind:keyBind = new keyBind();
                bind.key.text = String.fromCharCode(am == 0 ? game.preference.data.keys["Auto Attack"] : game.preference.data.keys["Skill " + am]);
                bind.name = "keyA" + am;
                bind.x = actCD.x + 6 + (actCD.width - bind.width) / 2;
                bind.y = blank.height + 4;
                game.ui.mcInterface.actBar.addChild(bind);

                game.world.actionMap.push(null);
            }

            var blanki:int = 0;
            while (blanki < o.actions.active.length)
            {
                game.ui.mcInterface.actBar.getChildByName(("blank" + blanki)).visible = true;
                var actBar:MovieClip = game.ui.mcInterface.actBar;
                var delIcon:MovieClip = actBar.getChildByName("i" + (blanki + 1)) as MovieClip;
                if (delIcon != null)
                {
                    delIcon.removeEventListener(MouseEvent.CLICK, game.actIconClick);
                    delIcon.removeEventListener(MouseEvent.MOUSE_OVER, game.actIconOver);
                    delIcon.removeEventListener(MouseEvent.MOUSE_OUT, game.actIconOut);
                    if (delIcon.icon2 != null)
                    {
                        delIcon.removeEventListener(Event.ENTER_FRAME, game.world.countDownAct);

                        if (delIcon.icon2.mask != null)
                        {
                            actBar.removeChild(delIcon.icon2.mask);
                            delIcon.icon2.mask = null;
                        }
                        actBar.removeChild(delIcon.icon2);
                    }
                    actBar.removeChild(delIcon);
                }
//                game.ui.mcInterface.actBar.getChildByName(("txtCD" + blanki)).visible = false;
//                game.ui.mcInterface.actBar.getChildByName(("txtCD" + blanki)).mouseEnabled = false;
                blanki++;
            }
        }

        var ai:int = 0;
        var slot:int = 0;
        var actObj:Object;
        while (ai < o.actions.active.length)
        {
            if (!game.isNewClass)
            {
                game.isNotUnlocked = (game.ui.mcInterface.actBar.getChildByName(("i" + (ai + 1))).cnt.transform.colorTransform.toString().indexOf("0.09765625") > -1);
                if (((o.actions.active[ai].isOK) && (game.isNotUnlocked)))
                {
                    var existing:MovieClip = game.ui.mcInterface.actBar.getChildByName(("i" + (ai + 1)));
                    existing.addEventListener(MouseEvent.CLICK, game.actIconClick, false, 0, true);
                    existing.buttonMode = true;
                    existing.cnt.transform.colorTransform = new ColorTransform();
                    game.world.getActionByRef(game.world.actionMap[ai]).isOK = true;
                }
            }
            else
            {
                actObj = o.actions.active[ai];
                actObj.sArg1 = "";
                actObj.sArg2 = "";
                game.world.actions.active.push(actObj);
                actObj.ts = 0;
                actObj.actID = -1;
                actObj.lock = false;
                game.world.actionMap[ai] = actObj.ref;
                var actIconMC:MovieClip = game.ui.mcInterface.actBar.addChild(new ib2());
                slot = ((ai < (o.actions.active.length - 1)) ? ai : o.actions.active.length - 1);
                var blankMC:* = game.ui.mcInterface.actBar.getChildByName(("blank" + slot));
                actIconMC.x = blankMC.x;
                actIconMC.width = 42;
                actIconMC.height = 39;
                actIconMC.name = String(("i" + (ai + 1)));
                actIconMC.actionIndex = ai;
                actIconMC.actObj = actObj;
                actIconMC.icon2 = null;
                actIconMC.tQty.visible = false;
                actIconMC.y = (actIconMC.y - 6);
                game.updateIcons([actIconMC], actObj.icon.split(","), null);
                blankMC.visible = false;
                actIconMC.addEventListener(MouseEvent.MOUSE_OVER, game.actIconOver, false, 0, true);
                actIconMC.addEventListener(MouseEvent.MOUSE_OUT, game.actIconOut, false, 0, true);
                actIconMC.mouseChildren = false;

                if (actObj.auto != null && actObj.auto)
                {
                    game.world.actions.auto = game.world.actions.active[ai];
                }
                else
                {
                    game.world.actions.active[ai].auto = false;
                }
                if (actObj.isOK)
                {
                    actIconMC.addEventListener(MouseEvent.CLICK, game.actIconClick, false, 0, true);
                    actIconMC.buttonMode = true;
                }
                else
                {
                    var c:Color = new Color();
                    c.setTint(0x333333, 0.9);
                    actIconMC.cnt.transform.colorTransform = c;
                }
            }
            ai = (ai + 1);
        }

        game.world.myAvatar.dataLeaf.passives = [];
        if (o.actions.passive != null)
        {
            ai = 0;
            while (ai < o.actions.passive.length)
            {
                actObj = game.copyObj(o.actions.passive[ai]);
                actObj.sArg1 = "";
                actObj.sArg2 = "";
                game.world.actions.passive.push(actObj);
                if (actObj.auras != null)
                {
                    var i:int = 0;
                    while (i < actObj.auras.length)
                    {
                        game.world.myAvatar.dataLeaf.passives.push(actObj.auras[i]);
                        i = (i + 1);
                    }
                }
                ai = (ai + 1);
            }
        }

//        if (game.preference.data.bAuras)
//        {
//            game.targetAura.classChanged();
//            game.playerAura.classChanged();
//        }

        game.isNewClass = false;
        game.ui.mcInterface.actBar.visible = true;
        game.ui.mcInterface.actBar.x = ((ConfigurationData.CLIENT_WIDTH - game.ui.mcInterface.actBar.width) / 2);
    }

    private function Seia(o:Object):void {
        if (o.iRes == 1) {
            var ai:int = 0;
            while (ai < game.world.actions.active.length) {
                var ot:Object = game.world.actions.active[ai];
                if (ot.ref == "i1" || ot.ref == "i2") {
                    if (("tgtMax" in ot)) {
                        delete ot.tgtMax;
                    }
                    if (("tgtMin" in ot)) {
                        delete ot.tgtMin;
                    }
                    if (("auras" in ot)) {
                        delete ot.auras;
                    }
                    if (ot.OldCD == null) {
                        ot.OldCD = ot.cd;
                    }
                    for (var s:String in o.o) {
                        if (((((!(s == "nam")) && (!(s == "ref"))) && (!(s == "desc"))) && (!(s == "typ")))) {
                            ot[s] = o.o[s];
                        }
                    }
                }

                ai++;
            }
        }

    }

    private function Stu(o:Object):void {
        var avt:Avatar = game.world.myAvatar;
        var unm:String = game.net.myUserName;
        var uoLeaf:Object = game.world.uoTreeLeaf(unm);
        if (o.wDPS != null) {
            uoLeaf.wDPS = o.wDPS;
        }
        if (o.mDPS != null) {
            uoLeaf.mDPS = o.mDPS;
        }
        if (uoLeaf.sta == null) {
            uoLeaf.sta = {};
        }
        for (var stuS:String in o.sta) {
            uoLeaf.sta[stuS] = o.sta[stuS];
            if (game.statsController.stats.indexOf(stuS.substr(1)) > -1) {
                uoLeaf.sta[stuS] = int(uoLeaf.sta[stuS]);
            } else {
                uoLeaf.sta[stuS] = Number(uoLeaf.sta[stuS]);
            }
            if (stuS.toLowerCase().indexOf("$tha") > -1) {
                var actObj:Object = game.world.getAutoAttack();
                if ((((!(actObj == null)) && (!(uoLeaf == null))) && (!(uoLeaf.sta == null)))) {
                    var cd:Number = Math.round((actObj.cd * (1 - Math.min(Math.max(uoLeaf.sta.$tha, -1), 0.5))));
                    if (game.world.autoActionTimer.running) {
                        game.world.autoActionTimer.delay = (game.world.autoActionTimer.delay - (game.world.autoActionTimer.delay - cd));
                        game.world.autoActionTimer.delay = (game.world.autoActionTimer.delay + 100);
                        game.world.autoActionTimer.reset();
                        game.world.autoActionTimer.start();
                    } else {
                        game.world.autoActionTimer.delay = cd;
                    }
                }
                var hasteCoeff:Number = (1 - Math.min(Math.max(uoLeaf.sta.$tha, -1), 0.5));
                var now:Number = new Date().getTime();
                game.world.GCD = Math.round((hasteCoeff * game.world.GCDO));
                for each (actObj in game.world.actions.active) {
                    if (((((actObj.isOK) && (!(game.world.getActIcons(actObj)[0] == null))) && (game.world.getActIcons(actObj)[0].icon2 == null)) && ((now - actObj.ts) < (actObj.cd * hasteCoeff)))) {
                        game.world.coolDownAct(actObj, ((actObj.cd * hasteCoeff) - (now - actObj.ts)), now);
                    }
                }
            }
            if (stuS.toLowerCase().indexOf("$cmc") > -1) {
                game.world.updateActBar();
            }
        }

        if (o.tempSta != null) {
            uoLeaf.tempSta = o.tempSta;
            if (("updatePStats" in game.world.map)) {
                game.world.map.updatePStats();
            }
        }

        if (avt != null) {
            game.world.updatePortrait(avt);
        }

        if (game.statsNewClass)
        {
            game.baseClassStats = {};
            for (var stu:Object in o.sta)
            {
                game.baseClassStats[stu] = o.sta[stu];
            }
            if (game.mcStatsPanel)
            {
                game.mcStatsPanel.updateBase();
            }
            game.statsNewClass = false;
        }
        if (game.mcStatsPanel)
        {
            game.mcStatsPanel.update();
        }
    }

    private function FirstJoin(o:Object):void {
        if (o.hasOwnProperty("cvu")) game.statsController.updateCoreValues(o.cvu);
        if (o.hasOwnProperty("rarities"))
        {
            for each (var rarity:Object in o.rarities)
            {
                if (game.world.rarity[rarity.id] != null) continue;
                game.world.rarity[rarity.id] = rarity;
            }
        }
    }

    private function Event(o:Object):void {
        game.world.map.eventTrigger(o);
    }

    private function ModInfo(o:Object):void {
        game.world.map.showModInfo(o);
    }

    private function ModInc(o:Object):void {
        if (o.bSuccess) {
            game.world.map.hideLoading();
            game.world.map.show(o.events);
            game.world.modID = int(o.mID);
        } else {
            game.chatF.pushMsg("warning", o.msg, "SERVER", "", 0);
        }
    }

    private function Ia(o:Object):void {
        if (("iaPathMC" in o)) {
            try {
                var mc:* = game.world;
                var mcPath:Array = o.iaPathMC.split(".");
                while (mcPath.length > 0) {
                    var s:String = String(mcPath.shift());
                    if (mc.getChildByName(s) != null) {
                        mc = (mc.getChildByName(s) as MovieClip);
                    } else {
                        mc = mc[s];
                    }
                }
            } catch (e:Error) {
            }
        } else {
            if (o.str != null) {
                var avt:Avatar = game.world.getAvatarByUserID(int(o.str));
                if (avt != null) {
                    mc = avt.pMC;
                }
            } else {
                mc = MovieClip(game.world.CHARS.getChildByName(o.oName));
            }
        }
        if (((!(mc == null)) && (!(mc == game.world)))) {
            try {
                switch (o.typ) {
                    case "rval":
                        mc.userName = o.unm;
                        mc.iaF(o);
                        break;
                    case "str":
                        if (o.str == null) {
                            mc.userName = o.unm;
                        }
                        mc.iaF(o);
                        break;
                    case "flourish":
                        mc.userName = o.unm;
                        mc.gotoAndPlay(o.oFrame);
                        break;
                }
            } catch (e:Error) {
                trace(("error: " + e));
            }
        }
    }

    private function Siau(o:Object):void {
        game.world.updateCellMap(o);
    }

    private function Umsg(o:Object):void {
        game.addUpdate(o.s);
    }

    private function Gi(o:Object):void {
        game.Modal(o.owner + " has invited you to join the guild " + o.gName + ". Do you accept?", game.world.doGuildAccept, {
            "guildID": o.guildID,
            "owner": o.owner
        }, null, "dual");

        game.chatF.pushMsg("server", ((o.owner + " has invited you to join the guild ") + o.gName), "SERVER", "", 0);
    }

    private function Gd(o:Object):void {
        game.chatF.pushMsg("server", (o.unm + " has declined your invitation."), "SERVER", "", 0);
    }

    private function Ga(o:Object):void {
        var avt:Avatar = game.world.getAvatarByUserName(o.unm);
        if (avt != null) {
            avt.updateGuild(o.guild);
            if (avt.isMyAvatar) {
                game.chatF.chn.guild.act = 1;
                game.chatF.pushMsg("server", "You have joined the guild.", "SERVER", "", 0);
            } else {
                if (game.world.myAvatar.objData.guild.Name == avt.objData.guild.Name) {
                    game.chatF.pushMsg("server", (avt.pnm + " has joined the guild."), "SERVER", "", 0);
                    game.world.myAvatar.updateGuild(o.guild);
                }
            }
        } else {
            if (o.guild.Name == game.world.myAvatar.objData.guild.Name) {
                game.chatF.pushMsg("server", (o.unm + " has joined the guild."), "SERVER", "", 0);
                game.world.myAvatar.updateGuild(o.guild);
            }
        }
    }

    private function Gr(o:Object):void {
        var avt:Avatar = game.world.getAvatarByUserName(o.unm);
        if (avt != null) {
            avt.updateGuild(null);
            if (avt.isMyAvatar) {
                game.chatF.chn.guild.act = 0;
                game.chatF.pushMsg("server", "You have been removed from the guild.", "SERVER", "", 0);
            } else {
                if (game.world.myAvatar.objData.guild.Name == avt.objData.guild.Name) {
                    game.chatF.pushMsg("server", (avt.pnm + " has been removed from the guild."), "SERVER", "", 0);
                    game.world.myAvatar.updateGuild(o.guild);
                }
            }
        }
        if (game.world.myAvatar.objData.guild != null) {
            if (game.world.myAvatar.objData.guild.Name == o.guild.Name) {
                game.chatF.pushMsg("server", (o.unm + " has been removed from the guild."), "SERVER", "", 0);
                game.world.myAvatar.updateGuild(o.guild);
            }
        }
    }

    private function GuildDelete(o:Object):void {
        var avt:Avatar = game.world.getAvatarByUserName(o.unm);
        if (avt != null) {
            avt.updateGuild(null);
            if (avt.isMyAvatar) {
                game.chatF.pushMsg("server", o.msg, "SERVER", "", 0);
            }
        }
    }

    private function GMotd(o:Object):void {
        game.world.myAvatar.objData.guild.MOTD = o.MOTD[0];
    }

    private function UpdateGuild(o:Object):void {
        try {
            if (game.world.myAvatar.objData != null) {
                game.world.myAvatar.updateGuild(o.guild);
            }
        } catch (e) {
        }
        if (o.msg != null) {
            game.chatF.pushMsg("server", o.msg, "SERVER", "", 0);
        }
    }

    private function Gc(o:Object):void {
        var avt:Avatar = game.world.getAvatarByUserID(o.uid);
        avt.initGuild(o.guild);
    }

    private function Pi(o:Object):void {
        game.Modal(o.owner + " has invited you to join their group.  Do you accept?", game.world.doPartyAccept, {"pid": o.pid}, null, "dual");
        game.chatF.pushMsg("server", (o.owner + " has invited you to a group."), "SERVER", "", 0);
    }

    private function Pa(o:Object):void {
        var suppressMultiples:Boolean = false;

        if (game.world.partyOwner == "") {
            game.world.partyOwner = o.owner;
        }

        if (game.world.partyID == -1) {
            game.world.partyID = o.pid;
            game.chatF.chn.party.act = 1;
            if (o.owner.toLowerCase() != game.net.myUserName) {
                game.chatF.pushMsg("server", "You have joined the party.", "SERVER", "", 0);
                suppressMultiples = true;
            }
        }

        var i:int = 0;

        while (i < o.ul.length) {
            var unm:String = o.ul[i];
            if (unm.toLowerCase() != game.net.myUserName) {
                game.world.addPartyMember(unm);
                if (!suppressMultiples) {
                    game.chatF.pushMsg("server", (unm + " has joined the party."), "SERVER", "", 0);
                }
            }
            i++;
        }
    }

    private function Pr(o:Object):void {
        var isYou:Boolean = false;
        var nam:String = game.world.partyOwner;

        game.world.partyOwner = o.owner;

        if (nam != game.world.partyOwner) {
            game.chatF.pushMsg("server", (game.world.partyOwner + " is now the party leader."), "SERVER", "", 0);
        }
        if (o.unm.toLowerCase() == game.net.myUserName.toLowerCase()) {
            isYou = true;
            game.chatF.chn.party.act = 0;
        }
        if (o.typ == "k") {
            if (isYou) {
                game.chatF.pushMsg("server", "You have been removed from the party", "SERVER", "", 0);
            } else {
                game.chatF.pushMsg("server", (o.unm + " has been removed from the party"), "SERVER", "", 0);
            }
        } else {
            if (o.typ == "l") {
                if (isYou) {
                    game.chatF.pushMsg("server", "You have left the party", "SERVER", "", 0);
                } else {
                    game.chatF.pushMsg("server", (o.unm + " has left the party"), "SERVER", "", 0);
                }
            }
        }
        game.world.removePartyMember(String(o.unm).toLowerCase());
    }

    private function Pp(o:Object):void {
        var nam:String = game.world.partyOwner;
        game.world.partyOwner = o.owner;

        if (nam != game.world.partyOwner) {
            game.chatF.pushMsg("server", (game.world.partyOwner + " is now the party leader."), "SERVER", "", 0);
        }

        game.world.updatePartyFrame();
    }

    private function Ps(o:Object):void {
        game.Modal(o.unm + " wants to summon you to them.  Do you accept?", game.world.acceptPartySummon, o, null, "dual");
        game.chatF.pushMsg("server", (o.unm + " is trying to summon you to them."), "SERVER", "", 0);
    }

    private function Pd(o:Object):void {
        game.chatF.pushMsg("server", (o.unm + " has declined your invitation."), "SERVER", "", 0);
    }

    private function Pc(o:Object):void {
        if (game.world.partyID > -1) {
            game.chatF.pushMsg("server", "Your party has been disbanded", "SERVER", "", 0);
        }
        game.world.partyID = -1;
        game.world.partyOwner = "";
        game.world.partyMembers = [];
        game.world.updatePartyFrame();
        game.chatF.chn.party.act = 0;
        if (game.chatF.chn.cur == game.chatF.chn.party) {
            game.chatF.chn.cur = game.chatF.chn.zone;
        }
        if (game.chatF.chn.lastPublic == game.chatF.chn.party) {
            game.chatF.chn.lastPublic = game.chatF.chn.zone;
        }
    }

    private function PvpQ(o:Object):void {
        game.world.handlePVPQueue(o);
    }

    private function PvpI(o:Object):void {
        game.world.receivePVPInvite(o);
    }

    private function PvpE(o:Object):void {
        game.relayPVPEvent(o);
    }

    private function PvpS(o:Object):void {
        game.updatePVPScore(o.pvpScore);
    }

    private function PvpC(o:Object):void {
        game.world.PVPResults.pvpScore = o.pvpScore;
        game.world.PVPResults.team = o.team;
        game.updatePVPScore(o.pvpScore);
        game.togglePVPPanel("results");
    }

    private function Di(o:Object):void {
        game.Modal(o.owner + " has challenged you to a duel.  Do you accept?", game.world.doDuelAccept, {"unm": o.owner}, null, "dual");
        game.chatF.pushMsg("server", (o.owner + " has challenged you to a duel."), "SERVER", "", 0);
    }

    private function DuelEx(o:Object):void {
        game.world.duelExpire();
    }

    private function LoadFactions(o:Object):void {
        game.world.myAvatar.initFactions(o.factions);
    }

    private function AddFaction(o:Object):void {
        game.world.myAvatar.addFaction(o.faction);
    }

    private function LoadFriendsList(o:Object):void {
        game.world.myAvatar.initFriendsList(o.friends);
    }

    private function RequestFriend(o:Object):void {
        game.Modal(o.unm + " has invited you to be friends. Do you accept?", game.world.addFriend, {"ID": o.ID, "unm": o.unm}, null, "dual");
        game.chatF.pushMsg("server", (o.unm + " has invited you to be friends."), "SERVER", "", 0);
    }

    private function AddFriend(o:Object):void {
        game.world.myAvatar.addFriend(o.friend);
    }

    private function UpdateFriend(o:Object):void {
        game.world.myAvatar.updateFriend(o.friend);
    }

    private function DeleteFriend(o:Object):void {
        game.world.myAvatar.deleteFriend(o.ID);
    }

    private function IsModerator(o:Object):void {
        game.Modal((o.val ? o.unm + " is staff!" : o.unm + " is NOT staff!"), game.world.addFriend, {}, (o.val ? "gold,medium" : "red,medium"), "mono");
        game.chatF.pushMsg("warning", (o.val ? (o.unm + " is staff!") : (o.unm + " is NOT staff!")), "SERVER", "", 0);
    }

    private function LoadWarVars(o:Object):void {
        game.world.objResponse["loadWarVars"] = o;
//        _game.world.dispatchEvent(new Event("loadWarVars"));
    }

    private function SetAchievement(o:Object):void {
        game.world.updateAchievement(o.field, o.index, o.value);
    }

    private function ShowAchievement(o:Object) : void
    {
        game.showAchievement(o.title, o.points);
    }

    private function LoadQuestStringData(o:Object):void {
        game.world.objQuestString = o.obj;
//        _game.world.dispatchEvent(new Event("QuestStringData_Complete"));
    }

    private function GetTimes(o:Object):void {
        var a:Array = [];
        for (var s:* in o.o) {
            o = o.o[s];
            o.s = s;
            a.push(o);
        }

        a.sortOn("t", (Array.NUMERIC | Array.DESCENDING));
        trace(" ** GETTIMES START **");

        var i:int = 0;
        while (i < a.length) {
            o = a[i];
            trace(((((((((o.s + ",") + o.t) + ",") + o.n) + ",") + game.numToStr((o.t / o.n))) + ",") + Math.round(o.d)));
            i = (i + 1);
        }
        trace(" ** GETTIMES END **");
    }

    private function ClockTick(o:Object):void {
        if (("eventTrigger" in MovieClip(game.world.map))) {
            game.world.map.eventTrigger(o);
        }
    }

    private function CastWait(o:Object):void {
        try {
            game.world.map.fishGame.castingWait(o.wait, o.derp);
        } catch (e:Error) {
        }
    }

    private function CatchResult(o:Object):void {
        game.world.myAvatar.addRep(20, o.catchResult.myRep);
        try {
            game.world.map.fishGame.showCatch(o);
        } catch (e:Error) {
        }
    }

    private function AlchOnStart(o:Object):void {
        game.world.map.alchemyGame.onStart(o);
    }

    private function AlchComplete(o:Object):void {
        game.world.map.alchemyGame.checkComplete(o);
    }

    private function BookInfo(o:Object):void {
        game.world.bookData = o.bookData;
    }

    private function SpellOnStart(o:Object):void {
        game.world.map.mcGame.spellOnStart(o);
    }

    private function SpellComplete(o:Object):void {
        game.world.map.mcGame.spellComplete(o);
    }

    private function SpellWaitTimer(o:Object):void {
        game.world.map.mcGame.spellWaitTimer(o);
    }

    private function PlayerDeath(o:Object):void {
        if (("eventTrigger" in MovieClip(game.world.map))) {
            game.world.map.eventTrigger(o);
        }
    }

    private function GetScrolls(o:Object):void {
        trace("getScrolls recieved");
        try {
            game.world.scrollData = o.scrolls;
            game.world.map.initScrollData();
        } catch (e:Error) {
            trace("error finding function");
        }
    }

    private function TurnInScrolls(o:Object):void {
        if (o.IDs != null) {
            var i:int = 0;
            while (i < o.IDs.length) {
                game.world.myAvatar.updateScrolls(int(o.IDs[i]));
                i = (i + 1);
            }
            var s:* = "";
            i = 0;
            while (i < 500) {
                s = (s + String.fromCharCode(0));
                i = (i + 1);
            }
            game.world.myAvatar.objData.pending = s;
            try {
                game.world.map.displayTurnins(o.IDs);
            } catch (e:Error) {
                trace("error displaying turnins");
            }
        }
    }

    private function AddLoadOut(o:Object):void {
        if (game.ui.mcPopup.currentLabel == "Outfit") {
            game.world.myAvatar.objData.outfits[o.name] = o.outfit;
            game.ui.mcPopup.mcOutfit.interfaceOutfitSets.interfaceOutfitEdit.onServerResponseUpdate();
        }
    }

    private function RemoveLoadOut(o:Object):void {
        if (game.ui.mcPopup.currentLabel == "Outfit") {
            game.ui.mcPopup.mcOutfit.interfaceOutfitSets.onServerResponseRemove(o.name);
            delete game.world.myAvatar.objData.outfits[o.name];
        }
    }

    private function EquipLoadOut(o:Object):void {
        var avt:Avatar = game.world.getAvatarByUserID(o.uid);
        if (avt != null && (!game.preference.data.bDisLoadChar || game.world.myAvatar.pMC.canLoadSelf)) {
            if (avt.pMC != null && avt.objData != null) {
                avt.objData.eqp = {};
                for (var sES:String in o.outfits) {
                    if (o.outfits[sES] != null) {
                        avt.objData.eqp[sES] = {};
                        avt.objData.eqp[sES].sFile = o.outfits[sES].sFile;
                        avt.objData.eqp[sES].sLink = o.outfits[sES].sLink;
                        avt.objData.eqp[sES].sType = o.outfits[sES].sType;
                        avt.objData.eqp[sES].ItemID = o.outfits[sES].ItemID;
                        avt.objData.eqp[sES].sMeta = o.outfits[sES].sMeta;

                        avt.loadMovieAtES(sES, o.outfits[sES].sFile, o.outfits[sES].sLink);

                        if (avt.isMyAvatar) {
                            avt.equipItem(o.outfits[sES].ItemID);
                        }
                    }
                }

                if (avt.isMyAvatar) {
                    if (MovieClip(game.ui.mcPopup.getChildByName("mcInventory")) != null) {
                        MovieClip(game.ui.mcPopup.getChildByName("mcInventory")).update({"eventType": "refreshItems"});
                    }
                }
            }
        }
    }

    private function PetSta(o:Object):void {
        var avt:Avatar = game.world.myAvatar;
        var str:String;

        if (!("pet" in avt.objData)) avt.petMC.objData = {};

        if (avt != null && avt.petMC.objData != null && "sta" in o) {
            avt.petMC.objData.sta = o.sta;
		/*
                if (avt.objData.pet.hasOwnProperty("sta"))
                {
                    for (str in o.data) {
                        if (avt.objData.pet.sta.hasOwnProperty(str)) {
                            avt.objData.pet.sta[str] = o.sta[str];
                        }
                    }
                }
                else
                {
                    avt.objData.pet.sta = o.sta;
                }
		*/
        }
    }
	
	private function RetrievePetData(o:Object) : void {
	    var avt:Avatar = game.world.myAvatar;
        var str:String;
		
		if (!("pet" in avt.objData)) avt.petMC.objData = {};
		
        if (avt != null && avt.petMC != null && "data" in o) {
            if (avt.petMC.objData.hasOwnProperty("data"))
            {
                for (str in o.data) {
                    if (avt.petMC.objData.data.hasOwnProperty(str)) {
                        avt.petMC.objData.data[str] = o.data[str];
                    }
                }
            } else {
                avt.petMC.objData.data = o.data;
            }

            game.ui.mcPetPortrait.visible = true;
            game.ui.btnTargetPetPortraitClose.visible = true;
            game.world.updatePetPortrait(avt);
		}
	}

    private function SendLinkedItems(o:Object) : void {
        if (o.hasOwnProperty("items"))
        {
            var items:Object = o.items;

            for (var key:String in items)
            {
                var copyObj:Object = game.copyObj(items[key]);
                game.world.linkTree[copyObj.CharItemID] = game.copyObj(copyObj);
            }
        }
    }

    private function TestBoosts(o:Object) : void {
        if (!o.hasOwnProperty("option")) return;

		trace("TES BOOSTS DATA > " + JSON.stringify(o));

        if (o.option == "+" && o.hasOwnProperty("xpBoost"))
        {
			trace("xpBoost > ENABLED");
            game.world.myAvatar.objData.iBoostXP = o.xpBoost;
            game.addUpdate("You have activated the Experience Boost!  All Experience rewards are doubled while the effect holds. " + Math.ceil(o.xpBoost / 60) + " minute(s) remaining.");
            game.boosts.createIconMC("XpBoost", "icbxp", Math.ceil(o.xpBoost / 60));
        }
        else if (o.option == "-" && o.hasOwnProperty("xpBoost"))
        {
            delete game.world.myAvatar.objData.iBoostXP;
            game.boosts.removeIcon("XpBoost");
            game.chatF.pushMsg("server", "The Experience Boost has faded! Experience rewards are no longer doubled.", "SERVER", "", 0);
        }

        if (o.option == "+" && o.hasOwnProperty("cpBoost"))
        {
            game.world.myAvatar.objData.iBoostCP = o.cpBoost;
            game.addUpdate("You have activated the ClassPoint Boost!  All ClassPoint rewards are doubled while the effect holds. " + Math.ceil(o.cpBoost / 60) + " minute(s) remaining.");
            game.boosts.createIconMC("CpBoost", "icbcp", Math.ceil(o.cpBoost / 60));
        }
        else if (o.option == "-" && o.hasOwnProperty("cpBoost"))
        {
            delete game.world.myAvatar.objData.iBoostCP;
            game.boosts.removeIcon("CpBoost");
            game.chatF.pushMsg("server", "The Class Points Boost has faded! Class Points rewards are no longer doubled.", "SERVER", "", 0);
        }

        if (o.option == "+" && o.hasOwnProperty("repBoost"))
        {
            game.world.myAvatar.objData.iBoostRep = o.repBoost;
            game.addUpdate("You have activated the Reputation Boost!  All Reputation rewards are doubled while the effect holds. " + Math.ceil(o.repBoost / 60) + " minute(s) remaining.");
            game.boosts.createIconMC("RepBoost", "icbrep", Math.ceil(o.repBoost / 60));
        }
        else if (o.option == "-" && o.hasOwnProperty("repBoost"))
        {
            delete game.world.myAvatar.objData.iBoostRep;
            game.boosts.removeIcon("RepBoost");
            game.chatF.pushMsg("server", "The Reputation Boost has faded! Reputation rewards are no longer doubled.", "SERVER", "", 0);
        }

        if (o.option == "+" && o.hasOwnProperty("copperBoost"))
        {
            game.world.myAvatar.objData.iBoostCopper = o.copperBoost;
            game.addUpdate("You have activated the Copper Boost!  All Copper rewards are doubled while the effect holds. " + Math.ceil(o.copperBoost / 60) + " minute(s) remaining.");
            game.boosts.createIconMC("CopperBoost", "iibag", Math.ceil(o.copperBoost / 60));
        }
        else if (o.option == "-" && o.hasOwnProperty("copperBoost"))
        {
            delete game.world.myAvatar.objData.iBoostCopper;
            game.boosts.removeIcon("CopperBoost");
            game.chatF.pushMsg("server", "The Copper Boost has faded! Copper rewards are no longer doubled.", "SERVER", "", 0);
        }

        if (o.option == "+" && o.hasOwnProperty("silverBoost"))
        {
            game.world.myAvatar.objData.iBoostSilver = o.copperBoost;
            game.addUpdate("You have activated the Silver Boost!  All Silver rewards are doubled while the effect holds. " + Math.ceil(o.silverBoost / 60) + " minute(s) remaining.");
            game.boosts.createIconMC("SilverBoost", "iibag", Math.ceil(o.silverBoost / 60));
        }
        else if (o.option == "-" && o.hasOwnProperty("silverBoost"))
        {
            delete game.world.myAvatar.objData.iBoostSilver;
            game.boosts.removeIcon("SilverBoost");
            game.chatF.pushMsg("server", "The Silver Boost has faded! Silver rewards are no longer doubled.", "SERVER", "", 0);
        }

        if (o.option == "+" && o.hasOwnProperty("goldBoost"))
        {
			trace("goldBoost > ENABLED");
            game.world.myAvatar.objData.iBoostG = o.goldBoost;
            game.addUpdate("You have activated the Gold Boost!  All Gold rewards are doubled while the effect holds. " + Math.ceil(o.goldBoost / 60) + " minute(s) remaining.");
			game.boosts.createIconMC("GoldBoost", "icbgold", Math.ceil(o.goldBoost / 60));
        }
        else if (o.option == "-" && o.hasOwnProperty("goldBoost"))
        {
            delete game.world.myAvatar.objData.iBoostG;
            game.boosts.removeIcon("GoldBoost");
            game.chatF.pushMsg("server", "The Gold Boost has faded! Gold rewards are no longer doubled.", "SERVER", "", 0);
        }

        game.boosts.rearrangeIconMC();
    }
	
	private function RefreshGoldDisplay(o:Object) : void
	{
	    if (o.hasOwnProperty("copper")) game.world.myAvatar.objData.intCopper = o.copper;
	    if (o.hasOwnProperty("silver")) game.world.myAvatar.objData.intSilver = o.silver;
	    if (o.hasOwnProperty("gold")) game.world.myAvatar.objData.intGold = o.gold;

        if (game.ui.mcPopup.currentLabel == "Inventory") MovieClip(game.ui.mcPopup.getChildByName("mcInventory")).update({"eventType": "refreshCurrency"});
        if (game.ui.mcPopup.currentLabel == "Trade") MovieClip(game.ui.mcPopup.getChildByName("mcTrade")).update({"eventType": "refreshCurrency"});
		
	}
	
	private function Refresh(o:Object) : void
	{
	    trace("REFRESH");
		
        var id:int = o.id;

	    switch (o.type)
		{
		    case "items":
                var item:Object = game.world.myAvatar.getItemByID(id);
                var inv:MovieClip = MovieClip(game.ui.mcPopup.getChildByName("mcInventory"));

                if (item == null) return;

                item = o.data;
                game.world.invTree[id] = item;

                for (var i:int = 0; i < inv.itemsInv.length; i++)
                {
                    if (inv.itemsInv[i].ItemID == id)
                    {
                        inv.itemsInv[i] = item;
                    }
                }

                if (game.ui.mcPopup.currentLabel == "Inventory" && inv.previewPanel.visible)
                {
                    MovieClip(game.ui.mcPopup.getChildByName("mcInventory")).update({"eventType": "refreshItems"});
                }
			    break;
		}
	}

	private function Popupmsg(o:Object) : void {
	    game.Modal(o.strMsg, null, {}, o.strGlow, o.hasOwnProperty("btns") ? o.btns : "mono");
	}

    private function BuySlots(o:Object) : void {
        game.world.myAvatar.objData.intCopper = o.copper;

        switch (o.type) {
            case "Bag Slots":
                game.world.myAvatar.objData.iBagSlots += o.slots;
                break;
            case "Bank Slots":
                game.world.myAvatar.objData.iBankSlots += o.slots;
                break;
            case "House Slots":
                game.world.myAvatar.objData.iHouseSlots += o.slots;
                break;
        }

        if (game.ui.mcPopup.currentLabel == "BuySlots")
        {
            MovieClip(game.ui.mcPopup.getChildByName("mcBuySlots")).update();
        }
    }

    private function LoadOffer(o:Object) : void {
        if (o.bitSuccess)
        {
            if (o.hasOwnProperty("itemsA")) game.world.tradeController.addItemsToTradeA(o.itemsA);
            if (o.hasOwnProperty("itemsB")) game.world.tradeController.addItemsToTradeB(o.itemsB);
            if (game.ui.mcPopup.currentLabel == "Trade") MovieClip(game.ui.mcPopup.getChildByName("mcTrade")).update({eventType:"refreshBank"});
        }
        else
        {
            game.Modal("Error loading trade items!  Try logging out and back in to fix this problem.", null, {}, "red,medium", "mono");
        }
    }
    private function StartTrade(o:Object) : void {
        game.world.tradeController.tradeinfo = {
            itemsA: [],
            itemsB: [],
            hasRequested: {}
        }

        game.toggleTrade(o.userId);
    }
    private function TradeCancel(o:Object) : void {
        if (o.bitSuccess)
        {
            game.world.myAvatar.tradeToInvReset();

            if (game.ui.mcPopup.currentLabel == "Trade") {
                MovieClip(game.ui.mcPopup.getChildByName("mcTrade")).notify = false;
                MovieClip(game.ui.mcPopup.getChildByName("mcTrade")).fClose();
            }
        }
    }
    private function TradeFromInventory(o:Object) : void {
        if (o.hasOwnProperty("bSuccess") && o.bSuccess == 1)
        {
            game.world.myAvatar.tradeFromInv(o.ItemID, o.Type, o.Quantity);

            QuestController.refreshTracker();

            if (game.ui.mcPopup.currentLabel == "Trade"){
                MovieClip(game.ui.mcPopup.getChildByName("mcTrade")).update({eventType:"refreshItems"});
            }
        }
        else
        {
            game.Modal(o.msg, null, {}, "red,medium", "mono");
        }
    }
    private function TradeUnlock(o:Object) : void {
        if (o.bitSuccess){
            game.world.tradeController.ctrlTrade.txtLock.text = "Lock";
            game.world.tradeController.ctrlTrade.btnDeal.alpha = 0.5;
            game.world.tradeController.ctrlTrade.btnDeal.mouseEnabled = false;
            game.world.tradeController.ctrlTrade.txtMyCopper.mouseEnabled = true;
            game.world.tradeController.ctrlTrade.txtMySilver.mouseEnabled = true;
            game.world.tradeController.ctrlTrade.txtMyGold.mouseEnabled = true;
            game.world.tradeController.tradeItem1.alpha = 1;
            game.world.tradeController.tradeItem2.alpha = 1;
        }
    }
    private function TradeLock(o:Object) : void {
        if (o.bitSuccess)
        {
            game.world.tradeController.ctrlTrade.txtTargetCopper.text = o.copper;
            game.world.tradeController.ctrlTrade.txtTargetSilver.text = o.silver;
            game.world.tradeController.ctrlTrade.txtTargetGold.text = o.gold;

            if ("Deal" in o && o.Deal == 1) {
                game.world.tradeController.ctrlTrade.btnDeal.alpha = 1;
                game.world.tradeController.ctrlTrade.btnDeal.mouseEnabled = true;
            }

            if ("Self" in o && o.Self == 1) {
                game.world.tradeController.ctrlTrade.txtMyCopper.mouseEnabled = false;
                game.world.tradeController.ctrlTrade.txtMySilver.mouseEnabled = false;
                game.world.tradeController.ctrlTrade.txtMyGold.mouseEnabled = false;
                game.world.tradeController.ctrlTrade.txtLock.text = "Unlock";
                game.world.tradeController.tradeItem1.alpha = 0.5;
            } else  {
                game.world.tradeController.tradeItem2.alpha = 0.5;
            }
        }
        else
        {
            game.Modal(o.msg, null, {}, "red,medium", "mono");
        }
    }
    private function TradeRequest(o:Object) : void {
        game.Modal(o.owner + "has requested you to trade. Do you accept?", game.world.tradeController.doTradeAccept, { unm: o.owner }, "white,medium", "dual");
        game.chatF.pushMsg("server", (o.owner + " has requested you to trade."), "SERVER", "", 0);
    }
    private function TradeSwapInventory(o:Object) : void {
        game.world.myAvatar.tradeSwapInv(o.invItemID, o.tradeItemID);
        QuestController.refreshTracker();
        if (game.ui.mcPopup.currentLabel == "Trade"){
            MovieClip(game.ui.mcPopup.getChildByName("mcTrade")).update({eventType:"refreshItems"});
        }
    }
    private function TradeToInventory(o:Object) : void {
        if (o.Type == 1) {
            game.world.myAvatar.tradeToInvA(o.ItemID);
        } else {
            game.world.myAvatar.tradeToInvB(o.ItemID);
        }

        QuestController.refreshTracker();

        if (game.ui.mcPopup.currentLabel == "Trade"){
            MovieClip(game.ui.mcPopup.getChildByName("mcTrade")).update({eventType:"refreshItems"});
        }
    }
	
	private function TradeDeal(o:Object) : void
	{
        if (o.bitSuccess)
        {
            if ("onHold" in o && o.onHold == 1)
            {
                game.world.tradeController.ctrlTrade.btnDeal.alpha = 0.5;
                game.world.tradeController.ctrlTrade.btnDeal.mouseEnabled = false;
            }
            else
            {
                if (game.ui.mcPopup.currentLabel == "Trade")
                {
                    MovieClip(game.ui.mcPopup.getChildByName("mcTrade")).notify = false;
                    MovieClip(game.ui.mcPopup.getChildByName("mcTrade")).fClose();
                }
            }
        }
        else
        {
            game.Modal(o.msg, null, {}, "red,medium", "mono");
        }
	}

    private function FloorRewards(o:Object) : void
    {
        if (game.getChildByName("FloorReward")) return;

        game.mixer.playSound("FloorVictory");

        var btnFloorReward:mcButton = new mcButton();
        btnFloorReward.name = "btnFloorReward";
        btnFloorReward.tName.text = "Show";
        btnFloorReward.x = 1165;
        btnFloorReward.y = 550;
        btnFloorReward.visible = false;
        btnFloorReward.addEventListener(MouseEvent.CLICK, game.btnFloorReward, false, 0, true);
        game.ui.addChild(btnFloorReward);

        game.floorReward = new FloorReward(o.data);
        game.floorReward.name = "FloorReward";
        game.floorReward.x = 0;
        game.floorReward.y = 0;
        game.ui.addChild(game.floorReward);

        if (game.ui.mcPvEDuration.timer != null)
        {
            game.ui.mcPvEDuration.timer.stop();
            game.floorReward.tCompletionTime.text = "Completion Time: " + game.ui.mcPvEDuration.formatTime();
        }
    }

    private function AutoAttack(o:Object) : void
    {
        game.world.tryRandomAction();
    }

	private function AttackIndicator(o:Object) : void
	{
        var mc:MovieClip = new MovieClip();
        var shape:Shape = new Shape();
        var width:int = int(o.width);
        var height:int = int(o.height);

        shape.graphics.beginFill(0xFF0000, 0.5);

        if (o.shape == "circle")
        {
            var radius:Number = Math.min(width, height) / 2;
            shape.graphics.drawCircle(0, 0, radius);
        }
        else
        {
            shape.graphics.drawRect(-width / 2, -height / 2, width, height);
        }

        shape.graphics.endFill();

        mc.name = game.generateUniqueID();
        mc.x = int(o.x);
        mc.y = int(o.y);

		mc.mouseEnabled = false;
        mc.addChild(shape);
		
		game.world.CHARS.addChild(mc);

        TweenLite.to(mc, int(o.delay), {
            alpha: 0.5,
            repeat: 1,
            yoyo: 1,
            onComplete: function () : void {
                game.world.CHARS.removeChild(mc);
            }
        });
	}

}

}
