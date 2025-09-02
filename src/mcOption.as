// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//mcOption

package {

import UI.ToolTipMC;

import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.filters.GlowFilter;
import flash.media.SoundMixer;
import flash.media.SoundTransform;
import flash.text.TextField;
import flash.utils.Timer;
import flash.utils.setTimeout;

import game.aura.PlayerAura;
import game.aura.TargetAura;

import game.character.BattleAnalyzer;

import game.option.OptionListItem;
import game.quest.TestLoader;

public class mcOption extends MovieClip {

    private var game:Game = Game.root;
    private var toolTipMC:ToolTipMC = game.ui.ToolTip;

    public var tTitle:TextField;

    public var btnClose:SimpleButton;
    public var btnLogout:SimpleButton;
    public var btnFriend:SimpleButton;
    public var btnGuild:SimpleButton;
    public var btnIgnore:SimpleButton;
    public var btnCharacter:SimpleButton;
    public var btnBattleAnalyzer:SimpleButton;

    public var btnGeneral:MovieClip;
    public var btnGameplay:MovieClip;
    public var btnSocial:MovieClip;
    public var btnKey:MovieClip;
    public var btnCache:MovieClip;

    public var listScrLoader:TestLoader;
    public var listScr:MovieClip;

    public var label:String;
    private var visualIndex:int = 0;
    private var selectedKey:OptionListItem;

    public var lists:MovieClip;
    public var mcGeneral:MovieClip;

    public var mcSearch:MovieClip;
    public var listMask:MovieClip;

    private var serverTimer:Timer = new Timer(1000);

    private const visuals:Array = ["AUTO", "LOW", "MEDIUM", "HIGH", "BEST"];

    private const settings:Object = {
        gameplay: [
            { "strName": "Tool", "prop": "bTT", "bPref": false },
            { "strName": "Pet", "prop": "bPet", "bPref": false },
            { "strName": "Helm", "prop": "bHelm", "bPref": false },
            { "strName": "Cloak", "prop": "bCloak", "bPref": false },
            { "strName": "Goto", "prop": "bGoto", "bPref": false },
            { "strName": "Animation", "prop": "showAnimations", "bPref": false },
            { "strName": "Hide All Capes", "prop": "hideAllCapes", "bPref": false },
            { "strName": "Hide Other Pets", "prop": "hideOtherPets", "bPref": false },
            { "strName": "Disable Damage Strobe", "prop": "bDisDmgStrobe", "sDesc": "Prevents the white flash/strobe effect whenever a monster or player is damaged!", "bPref": true },
            { "strName": "Disable Damage Number", "prop": "bDisDmgDisplay", "sDesc": "Disables all damage numbers from showing as well as the white flash/strobe effect", "bPref": true },
            { "strName": "Hide Healing Bubbles", "prop": "bDisHealBubble", "sDesc":"Hides the green healing bubbles above players when they're low on health", "bPref": true },
            { "strName": "Visual Skill CoolDown", "prop": "bSkillCD", "sDesc":"Visual skill cooldowns!", "bPref": true },
            { "strName": "Smooth Background", "prop": "bSmoothBG", "sDesc": "Removes map background pixelation\\nYou must reload the map or move to a new area to see changes take affect", "bPref": true },
            { "strName": "Disable Monster Animations", "prop": "bDisMonAnim", "sDesc":"Disables monster animations with the benefit of performance", "bPref": true },
            { "strName": "Disable Self Animations", "prop": "bDisSelfMAnim", "sDesc":"Disables your player's movement animations except for walking for the benefit of performance", "bPref": true },

            {
                "strName": "Load Characters", "prop": "bDisLoadChar", "bPref": true, "sub": [
                    { "strName": "Load Only Your Character", "prop": "bCharSelf", "bPref": true }
                ]
            },

            { "strName": "Disable Load Monsters", "prop": "bDisLoadMon", "bPref": true },
            { "strName": "Static Player Art", "prop": "bCachePlayers", "sDesc": "Reduces the graphics of other players. \\n!WARNING! Having this enabled may or may not show some of the other player's colors. You will not be able to see their equipment changes with this enabled either.\\nYou must change rooms after turning this feature off in order for changes to take effect", "bPref": true },

            {
                "strName": "Hide Players", "prop": "bHidePlayers", "sDesc":"This will hide players on the map\nYou can hide specific players by clicking on their portraits (targetting them)!", "bPref": true, "sub": [
                    { "strName": "Show Name Tags", "prop": "bShowNames", "sDesc":"Only works if \"Hide Players\" is enabled!\nHaving this enabled will allow you to still see name tags of players even though they're hidden.", "bPref": true },
                    { "strName": "Show Shadows", "prop": "bShowShadows", "sDesc":'Only works if "Hide Players" is enabled!\nHaving this enabled will allow you to still see player shadows and clicking on the shadows will target them.', "bPref": true }
                ]
            },

            {
                "strName": "Hide Player Names", "prop": "bHideNames", "sDesc":"Hides player names\nHover over a player to reveal their name & guild", "bPref": true, "sub": [
                    { "strName": "Hide Guild Names Only", "prop": "bHideGuild", "sDesc":"Player names will be visible, and guild names will be hidden", "bPref": true },
                    { "strName": "Hide Your Name Only", "prop": "bHideSelfName", "sDesc":'Only your name will be hidden.\nEnabling this setting will not make "Hide Guild Names Only" work.', "bPref": true }
                ]
            },

            {
                "strName": "Class Actives/Auras UI", "prop": "bAuras", "bPref": true, "sDesc":"Work in Progress. No proper stack limit and icons yet.\nAllows you to view your buffs/auras underneath your player portrait and for your enemies as well!", "sub": [
                    { "strName": "Disable Aura Text", "prop": "bAuraText", "bPref": true }
                ]
            },
            {
                "strName": "Disable Skill Animation", "prop": "bDisSkillAnim", "sDesc":'There are two types of animations: Class Skill Animations & Player Movement Animations\nThis feature disables Class Skill Animations only while the regular "Animations" setting will disable both Class Skill Animations & Player Movement Animations', "bPref": true, "sub": [
                    { "strName": "Show Your Skill Animations Only", "prop": "bAnimSelf", "sDesc":'Only works if "Disable Skill Animations" is enabled!\nAdds an exception to "Disable Skill Animations" to show your skill animations only', "bPref": true }
                ]
            },
            {
                "strName": "Disable Item Animation", "prop": "bDisItemAnim", "bPref": true, "sub": [
                    { "strName": "Keep Weapon Animation Only", "prop": "bKeepWeaponAnimOnly", "bPref": true },
                    { "strName": "Keep Armor Animation Only", "prop": "bKeepArmorAnimOnly", "bPref": true },
                    { "strName": "Keep Cape Animation Only", "prop": "bKeepCapeAnimOnly", "bPref": true },
                    { "strName": "Keep Helm Animation Only", "prop": "bKeepHelmAnimOnly", "bPref": true }
                ]
            },
            {
                "strName": "Drops", "prop": "bDrops", "bPref": true, "sub": [
                    { "strName": "Claim All Drop", "prop": "bDropClaimAll", "bPref": true },
                    { "strName": "Claim Only Existed Item", "prop": "bDropClaimExistedItem", "bPref": true },
                    { "strName": "Claim Requirements Quests", "prop": "bDropReqQuest", "bPref": true }
                ]
            },
//            {
//                "strName": "Auto Deny Drops", "prop": "bDrops", "bPref": true, "sub": [
//                    { "strName": "Claim All Drop", "prop": "bDropClaimAll", "bPref": true },
//                    { "strName": "Claim Only Existed Item", "prop": "bDropClaimExistedItem", "bPref": true },
//                    { "strName": "Claim Requirements Quests", "prop": "bDropReqQuest", "bPref": true }
//                ]
//            }
        ],
        social: [
            { "strName": "Party", "prop": "bParty", "bPref": false },
            { "strName": "Friend", "prop": "bFriend", "bPref": false },
            { "strName": "Duel", "prop": "bDuel", "bPref": false },
            { "strName": "Guild", "prop": "bGuild", "bPref": false },
            { "strName": "Whisper", "prop": "bWhisper", "bPref": false }
        ],
        key: [
            { "strName": "Auto Attack", "bKey": true },
            { "strName": "Skill 1", "bKey": true },
            { "strName": "Skill 2", "bKey": true },
            { "strName": "Skill 3", "bKey": true },
            { "strName": "Skill 4", "bKey": true },
            { "strName": "Skill 5", "bKey": true },
            { "strName": "Skill 6", "bKey": true },
            { "strName": "Skill 7", "bKey": true },
            { "strName": "Inventory", "bKey": true },
            { "strName": "Bank", "access": 40, "bKey": true },
            { "strName": "Quest Log", "bKey": true },
            { "strName": "Friends List", "bKey": true },
            { "strName": "Character Panel", "bKey": true },
            { "strName": "Options", "bKey": true },
            { "strName": "Area List", "bKey": true },
            { "strName": "Jump", "bKey": true },
            { "strName": "Hide UI", "bKey": true }
        ],
        cache: [
            { "strName": "Maps", "prop": "map", "bQty": true, "iMin": 1, "iMax": 15 }
//            { "strName": "Monsters", "prop": "monster", "bQty": true, "iMin": 1, "iMax": 30 }
        ]
    };

    public function mcOption() {
        init();
    }

    public function init(): void {
        label = "General";

        serverTimer.addEventListener(TimerEvent.TIMER, timerHandler, false, 0, true);
        serverTimer.start();

        btnClose.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        btnGeneral.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        btnGameplay.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        btnSocial.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        btnKey.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        btnCache.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        btnLogout.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        mcGeneral.btnLeftVisual.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        mcGeneral.btnRightVisual.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);

        mcGeneral.btnLeftFps.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        mcGeneral.btnRightFps.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);

        mcGeneral.btnLeftSound.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        mcGeneral.btnRightSound.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);

        mcGeneral.btnFriend.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        mcGeneral.btnGuild.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        mcGeneral.btnIgnore.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        mcGeneral.btnCharacter.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        mcGeneral.btnBattleAnalyzer.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);

        mcSearch.txtSearch.text = "Search";
        mcSearch.txtSearch.addEventListener(KeyboardEvent.KEY_DOWN, onSearch, false, 0, true);
        mcSearch.txtSearch.addEventListener(FocusEvent.FOCUS_IN, onSearchFocusIn, false, 0, true);
        mcSearch.txtSearch.addEventListener(FocusEvent.FOCUS_OUT, onSearchFocusOut, false, 0, true);

        btnGeneral.buttonMode = true;
        btnGameplay.buttonMode = true;
        btnSocial.buttonMode = true;
        btnKey.buttonMode = true;
        btnCache.buttonMode = true;

        initGeneral();
        setup(null);
    }

    private function onFilter(data:Object, index:int, arr:Array):Boolean
    {
        return data != null && (data.strName.toLowerCase().indexOf(mcSearch.txtSearch.text.toLowerCase()) > -1);
    }

    private function onSearch(event:KeyboardEvent): void
    {
        if (event.charCode == 13)
        {
            var setting:Array = settings[String(label).toLowerCase()];
            setup(mcSearch.txtSearch.text != "" ? setting.filter(onFilter) : setting);
        }
    }

    private function onSearchFocusIn(event:FocusEvent): void
    {
        if (mcSearch.txtSearch.text == "Search")
        {
            mcSearch.txtSearch.text = "";
        }
    }

    private function onSearchFocusOut(event:FocusEvent): void
    {
        if (mcSearch.txtSearch.text == "")
        {
            mcSearch.txtSearch.text = "Search";
        }
    }

    private function setup(items:Object):void {
        game.onRemoveChildren(lists);

        mcGeneral.visible = items == null;

        trace("SETUP > GAMEPLAY");

        for (var s:String in items) {
            var option:OptionListItem = new OptionListItem();
            option.name = items[s].strName;
            option.tName.text = items[s].strName;

            option.tStatus.visible = false;

            if (items[s].hasOwnProperty("access") && int(items[s]["access"]) > game.world.myAvatar.objData.intAccessLevel) continue;

            if (items[s].hasOwnProperty("bKey"))
            {
                var keyCode:Object = game.preference.data.keys[items[s].strName];
                option.tStatus.text = keyCode != null ? (keyCode == 32 ? "Space" : String.fromCharCode(keyCode)) : "None";
                option.btnKey.addEventListener(MouseEvent.CLICK, onChangeKeyBind, false, 0, true);
                option.btnKey.visible = true;
                option.tStatus.visible = true;
                option.chkActive.visible = false;
            }
            else if (items[s].hasOwnProperty("bQty"))
            {
                var cache:Object = game.preference.data.cache[items[s]["prop"]];
                var qty:QtySelectorMC = new QtySelectorMC(this, game, cache.min, cache.max, {name: items[s]["prop"], val: cache.val});
                qty.x = 140;
                qty.y = 3.25;
                option.addChild(qty);

                option.chkActive.checkmark.visible = game.preference.data.cache[items[s].prop].enabled;
            }
            else
            {
                option.chkActive.checkmark.visible = game.preference.data[items[s].prop];
            }

            option.y = lists.numChildren * 34.5;

            option.chkActive.removeEventListener(MouseEvent.CLICK, onClick);
            option.chkActive.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);

            option.removeEventListener(MouseEvent.MOUSE_OVER, onOver);
            option.removeEventListener(MouseEvent.MOUSE_OUT, onOut);
            option.addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 0, true);
            option.addEventListener(MouseEvent.MOUSE_OUT, onOut, false, 0, true);

            if (items.length >= 8)
            {
                option.bg.width = 295;
                option.chkActive.x = 278;

                if (label != "Key")
                {
                    option.tStatus.x = 178.1;
                }
            }

            lists.addChild(option);

            if (items[s].hasOwnProperty("sub")) initSubOption(items[s].sub);
        }

        if (items == null)
        {
            listScrLoader = null;
            listScr.visible = false;
            mcSearch.visible = false;
        }
        else
        {
            listScrLoader = new TestLoader(listMask, lists, listScr, 175);
            listScrLoader.open();
            listScr.visible = true;
            mcSearch.visible = true;
        }
    }

    private function initSubOption(item:Object) : void {
        for (var u:String in item) {
            var subOption:OptionListItem = new OptionListItem();
            subOption.name = item[u].strName;
            subOption.isSub = true;
            subOption.tName.text = item[u].strName;
            subOption.tStatus.x = 160
            subOption.bg.width = 273.75;
            subOption.chkActive.x = 258;
            subOption.chkActive.checkmark.visible = game.preference.data[item[u].prop];
            subOption.chkActive.visible = true;
            subOption.tStatus.visible = false;
            subOption.btnLeft.visible = false;
            subOption.btnRight.visible = false;

            subOption.chkActive.removeEventListener(MouseEvent.CLICK, onClick);
            subOption.chkActive.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
            subOption.removeEventListener(MouseEvent.MOUSE_OVER, onOver);
            subOption.removeEventListener(MouseEvent.MOUSE_OUT, onOut);
            subOption.addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 0, true);
            subOption.addEventListener(MouseEvent.MOUSE_OUT, onOut, false, 0, true);

            subOption.x = 20;
            subOption.y = lists.numChildren * 34.5;

            lists.addChild(subOption);
        }
    }

    private function timerHandler(_arg_1:TimerEvent):void {
        if (stage == null) {
            serverTimer.stop();
            serverTimer.removeEventListener(TimerEvent.TIMER, timerHandler);
        } else {
            if (mcGeneral != null) {
                mcGeneral.txtTime.text = game.date_server.toLocaleTimeString();
            }
        }
        if (MovieClip(parent) != null) {
            if (MovieClip(parent).currentLabel != "Option") {
                MovieClip(parent).removeChild(this);
                serverTimer.stop();
                serverTimer.removeEventListener(TimerEvent.TIMER, timerHandler);
            }
        }
    }

    private function initGeneral():void {
        for (var i:int = 0; i < visuals.length; i++)
        {
            if (visuals[i] == game.preference.data.quality)
            {
                visualIndex = i;
            }
        }

        initSound();
        mcGeneral.txtQuality.text = visuals[visualIndex];
        mcGeneral.txtFps.text = game.preference.data.bFps ? "On" : "Off";
    }

    private function initSound():void
    {
        if (game.preference.data.bSoundOn) {
            game.mixer.bSoundOn = true;
            SoundMixer.soundTransform = new SoundTransform(game.preference.data.iSoundStrength != null ? (game.preference.data.iSoundStrength / 100) : 1);
            mcGeneral.soundSelector.visible = 1;
        } else {
            game.mixer.bSoundOn = false;
            SoundMixer.stopAll();
            SoundMixer.soundTransform = new SoundTransform(0);
            mcGeneral.soundSelector.visible = 0;
        }

        mcGeneral.txtSounds.text = game.preference.data.bSoundOn ? "On" : "Off";
    }

    private function setPreference(str:String): void {
        switch (str) {
            case "Visuals":
                game.preference.data.quality = visuals[visualIndex];
                mcGeneral.txtQuality.text = visuals[visualIndex];
                stage.quality = visuals[visualIndex] == "AUTO" ? "HIGH" : visuals[visualIndex];
                break;
            case "Sounds":
                game.preference.data.bSoundOn = !game.preference.data.bSoundOn;

                initSound();

                game.uoPref.bSoundOn = game.mixer.bSoundOn;
                game.net.send("cmd", ["uopref", "bSoundOn", String(game.uoPref.bSoundOn)]);
                break
            case "Fps":
                game.preference.data.bFps = !game.preference.data.bFps;
                game.ui.mcFPS.visible = game.preference.data.bFps;
                mcGeneral.txtFps.text = game.preference.data.bFps ? "On" : "Off";
                break;
        }

        game.preference.flush();
    }

    private function onChangeKeyBind(event:MouseEvent): void {
        selectedKey = OptionListItem(event.currentTarget.parent);
        selectedKey.tStatus.text = "...";
        addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
    }

    private function onKeyDown(event:KeyboardEvent): void {
        event.preventDefault();
        event.stopPropagation();

        if (!(event.keyCode >= 32 && event.keyCode <= 126))
        {
            game.Modal("Invalid Key!", null, {}, "red,medium", "mono");
            selectedKey.tStatus.text = String.fromCharCode(game.preference.data.keys[selectedKey.tName.text]);
        }
        else if (isAssigned(event.keyCode))
        {
            game.Modal("Key is already assigned!", null, {}, "red,medium", "mono");
            selectedKey.tStatus.text = String.fromCharCode(game.preference.data.keys[selectedKey.tName.text]);
        }
        else
        {
            try {

                selectedKey.tStatus.text = String.fromCharCode(event.keyCode);
                game.preference.data.keys[selectedKey.tName.text] = event.keyCode;
                game.preference.flush();

                game.Modal("Successfully assigned new key.", null, {}, "green,medium", "mono");
                game.ui.mcInterface.actBar.getChildByName("keyA" + (selectedKey.tName.text == "Auto Attack" ? "0" : parseInt(selectedKey.tName.text.split(" ")[1]))).key.text = String.fromCharCode(event.keyCode);
            } catch (e:Error) {
                trace(e.message);
            }
        }

        removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
    }

    private function isAssigned(target:uint) : Boolean
    {
        for each (var key:Object in game.preference.data.keys)
        {
            if (target == key)
            {
                return true;
            }
        }

        return false;
    }

    private function getDataByName(name:String, isSub:Boolean = false) : Object
    {
        var items:Object = settings[label.toLowerCase()];

        for each (var o:Object in items)
        {
            if (isSub && o.hasOwnProperty("sub"))
            {
                for each (var s:Object in o.sub)
                {
                    if (name == s.strName)
                    {
                        return s;
                    }
                }
            }
            else if (name == o.strName)
            {
                return o;
            }
        }

        return null;
    }

    private function getOptionListByName(name:String) : OptionListItem
    {
        for (var i:int = 0; i < lists.numChildren; i++)
        {
            var child:OptionListItem = OptionListItem(lists.getChildAt(i));

            if (child.name.toLowerCase() == name.toLowerCase())
            {
                return child;
            }
        }

        return null;
    }

    private function onClick(e:MouseEvent): void {
        game.mixer.playSound("Click");

        var option:OptionListItem;
        var setting:Object;
        var propName:String;
        var player:Avatar;

        switch (e.currentTarget.name) {
            case "chkActive":
                option = e.currentTarget.parent as OptionListItem;
                setting = getDataByName(option.tName.text, option.isSub);
                propName = setting.prop;

                if (label == "Cache")
                {

                    game.preference.data.cache[propName].enabled = !game.preference.data.cache[propName].enabled;
                    game.preference.flush();

                    if (game.preference.data.cache[propName].enabled && game.cache.maps.length < 1)
                    {
                        game.cache.maps[game.world.strAreaName] = game.world.map;
                    }

                    option.chkActive.checkmark.visible = game.preference.data.cache[propName].enabled;
                }
                else if (setting.bPref == null || setting.bPref)
                {
                    game.preference.data[propName] = !game.preference.data[propName];
                    game.preference.flush();
                    option.chkActive.checkmark.visible = game.preference.data[propName];

                    switch (setting.strName) {
                        case "Static Player Art":
                            if (game.preference.data.bCachePlayers)
                            {
                                for each (player in game.world.avatars)
                                {
                                    if (player.pMC && !player.isMyAvatar)
                                    {
                                        try
                                        {
                                            game.rasterize(player.pMC.mcChar);
                                        }
                                        catch(e:Error)
                                        {
                                            trace("Static Player Art Error > " + e.message);
                                        }
                                    }
                                }
                            }
                            break;
                        case "Class Actives/Auras UI":
                            if (game.preference.data.bAuras)
                            {
                                game.playerAura = new PlayerAura(game);
                                game.targetAura = new TargetAura(game);
                                game.ui.mcPortrait.addChild(game.playerAura);
                                game.ui.mcPortraitTarget.addChild(game.targetAura);
                            }
                            else if (game.playerAura != null)
                            {
                                if (game.ui.mcPortrait.getChildByName("playerAuras"))
                                {
                                    game.playerAura.cleanup();
                                    game.ui.mcPortrait.removeChild(game.ui.mcPortrait.getChildByName("playerAuras"));
                                }

                                if (game.ui.getChildByName("targetAuras"))
                                {
                                    game.ui.removeChild(game.ui.getChildByName("targetAuras"));
                                    game.targetAura.cleanup();
                                }
                            }
                            break;
                        case "Disable Monster Animations":
                            if (game.preference.data.bDisMonAnim)
                            {
                                for (var mons:String in game.world.monsters)
                                {
                                    if (game.world.monsters[mons].dataLeaf && game.world.monsters[mons].pMC)
                                    {
                                        game.movieClipStartOrStopAll((game.world.monsters[mons].pMC.getChildAt(1) as MovieClip));
                                    }
                                }
                            }
                            break
                        case "Hide Players":
                            for each (player in game.world.avatars)
                            {
                                if (!player.pMC || player.isMyAvatar) continue;

                                player.pMC.mcChar.visible = (!(game.preference.data.bHidePlayers));
                                player.pMC.pname.visible = game.preference.data.bShowNames;
                                player.pMC.shadow.visible = game.preference.data.bShowShadows;

                                if (!game.preference.data.bHidePlayers)
                                {
                                    player.pMC.pname.visible = true;
                                    player.pMC.shadow.visible = true;
                                }
                            }
                            break;
                        case "Hide Player Names":
                            for each (player in game.world.avatars)
                            {
                                if (player.pMC)
                                {
                                    if (!game.preference.data.bHideNames)
                                    {
                                        player.pMC.hideNameCleanup();
                                    }
                                    else
                                    {
                                        player.pMC.hideNameSetup();
                                    }
                                }
                            }
                            break;
                        case "Hide Guild Names Only":
                            if (game.preference.data.bHideNames)
                            {
                                for each (player in game.world.avatars)
                                {
                                    if (player.pMC)
                                    {
                                        player.pMC.hideNameSetup();
                                    }
                                }
                            }
                            break;
                        case "Hide Your Name Only":
                            if (game.preference.data.bHideNames)
                            {
                                for each (player in game.world.avatars)
                                {
                                    if (player.pMC)
                                    {
                                        player.pMC.hideNameSetup();
                                    }
                                }
                            }
                            break;
                        case "Disable Item Animation":
                            for each (player in game.world.avatars) {
                                if (!player.pMC)  continue;

                                for (var equipType:Object in player.objData.eqp)
                                {
                                    player.pMC.KeepAnimation(player, equipType);
                                }
                            }
                            break;
                        case "Keep Weapon Animation Only":
                            for each (player in game.world.avatars) {
                                if (!player.pMC)  continue;
                                player.pMC.KeepAnimation(player, "Weapon");
                            }
                            break;
                        case "Keep Armor Animation Only":
                            for each (player in game.world.avatars) {
                                if (!player.pMC)  continue;
                                player.pMC.KeepAnimation(player, "co");
                            }
                            break;
                        case "Keep Cape Animation Only":
                            for each (player in game.world.avatars) {
                                if (!player.pMC)  continue;
                                player.pMC.KeepAnimation(player, "ba");
                            }
                            break;
                        case "Keep Helm Animation Only":
                            for each (player in game.world.avatars) {
                                if (!player.pMC)  continue;
                                player.pMC.KeepAnimation(player, "he");
                            }
                            break;
                        case "Claim All Drop":
                            if (game.preference.data.bDropClaimAll && (game.preference.data.bDropClaimExistedItem || game.preference.data.bDropClaimExistedItem))
                            {
                                game.Modal("Turning on \"Claim All\" option will automatically turn off Existed Item, Req Quests options.", null, {}, "red,medium", "mono");

                                if (game.preference.data.bDropClaimExistedItem)
                                {
                                    var claimOnlyExistedItem:OptionListItem = getOptionListByName("Claim Only Existed Item");

                                    if (claimOnlyExistedItem != null)
                                    {
                                        claimOnlyExistedItem.chkActive.checkmark.visible = false;
                                        game.preference.data.bDropClaimExistedItem = false;
                                    }
                                }

                                if (game.preference.data.bDropReqQuest)
                                {
                                    var claimReqQuests:OptionListItem = getOptionListByName("Claim Requirements Quests");
                                    if (claimReqQuests != null)
                                    {
                                        claimReqQuests.chkActive.checkmark.visible = false;
                                        game.preference.data.bDropReqQuest = false;
                                    }
                                }

                                game.preference.flush();
                            }
                            break;
                        case "Claim Only Existed Item":
                        case "Claim Requirements Quests":
                            if (game.preference.data.bDropClaimAll && (game.preference.data.bDropClaimExistedItem || game.preference.data.bDropReqQuest))
                            {
                                game.Modal("Turning on \"Existed Item\" or \"Req Quests\" option will automatically turn off Claim All option.", null, {}, "red,medium", "mono");

                                var claimAllDrop:OptionListItem = getOptionListByName("Claim All Drop");
                                if (claimAllDrop != null)
                                {
                                    claimAllDrop.chkActive.checkmark.visible = false;
                                    game.preference.data.bDropClaimAll = false;
                                    game.preference.flush();
                                }
                            }
                            break;
                        case "Load Characters":
                            game.Modal("Please reload the game client to apply the changes.", null, {}, "red,medium", "mono");
                            break;
                    }
                }
                else
                {
                    game.preference.data[propName] = !game.preference.data[propName];
                    game.uoPref[propName] = !game.uoPref[propName];

                    switch (propName) {
                        case "Pet":
                            if (game.uoPref.bPet) {
                                game.world.hideAllPets();
                            } else {
                                game.world.showAllPets();
                                if (game.world.hideOtherPets) {
                                    game.world.hideAllPets(false);
                                }
                            }
                            break;
                        case "Helm":
                            game.world.myAvatar.dataLeaf.showHelm = game.uoPref.bHelm;
                            game.world.myAvatar.pMC.setHelmVisibility(game.uoPref.bHelm);
                            break;
                        case "Cloak":
                            game.world.myAvatar.dataLeaf.showCloak = game.uoPref.bCloak;
                            game.world.myAvatar.pMC.setCloakVisibility(game.uoPref.bCloak);
                            break;
                        case "Hide All Capes":
                            game.world.setAllCloakVisibility();
                            break;
                        case "Hide Other Pets":
                            if (game.world.hideOtherPets) {
                                game.world.showAllPets(false);
                            } else {
                                game.world.hideAllPets(false);
                            }
                            break;
                    }

                    game.preference.flush();
                    game.net.send("cmd", ["uopref", propName, String(game.uoPref[propName])]);
                    option.chkActive.checkmark.visible = game.preference.data[propName];
                }
                break;
//            case "btnLeft":
//            case "btnRight":
//                option = e.currentTarget.parent as OptionListItem;
//                setting = getDataByName(option.tName.text, option.isSub); // settings[label.toLowerCase()][option.y / (option.hasOwnProperty("sub") ? (option.sub.length - 1) * 34.5 : 34.5)];
//                propName = setting.prop;
//                break;
            case "btnLeftVisual":
                visualIndex = --visualIndex < 0 ? visuals.length : visualIndex;
                break;
            case "btnRightVisual":
                visualIndex = ++visualIndex > visuals.length ? 0 : visualIndex;
                setPreference("Visuals");
                break;
            case "btnLeftFps":
            case "btnRightFps":
                setPreference("Fps");
                break;
            case "btnLeftSound":
            case "btnRightSound":
                setPreference("Sounds");
                break;
            case "btnGeneral":
                label = "General";
                tTitle.text = label;
                setup(null);
                break;
            case "btnGameplay":
                label = "Gameplay";
                tTitle.text = label;
                setup(settings.gameplay);
                break;
            case "btnSocial":
                label = "Social";
                tTitle.text = label;
                setup(settings.social);
                break;
            case "btnKey":
                label = "Key";
                tTitle.text = label;
                setup(settings.key);
                break;
            case "btnCache":
                label = "Cache";
                tTitle.text = label;
                setup(settings.cache);
                break;
            case "btnFriend":
                game.togglePanel("friends");
                break;
            case "btnGuild":
                game.world.showGuildList();
                break;
            case "btnIgnore":
                game.togglePanel("ignore");
                break;
            case "btnCharacter":
                break;
            case "btnBattleAnalyzer":
                if (game.ui.getChildByName("battleAnalyzer")) return;
                game.bAnalyzer = new BattleAnalyzer();
                game.bAnalyzer.name = "battleAnalyzer";
                game.bAnalyzer.x = 20;
                game.bAnalyzer.y = 280;
                game.ui.addChild(game.bAnalyzer);
                break;
            case "btnClose":
                MovieClip(parent).onClose();
                break;
            case "btnLogout":
                game.logout();
                break;
        }
    }

    public function onOver(event:MouseEvent):void
    {
        try
        {
            var option:OptionListItem = event.currentTarget as OptionListItem;
            var item:Object = getDataByName(option.tName.text, option.isSub);

            if (!item.hasOwnProperty("sDesc")) return;

            toolTipMC.openWith({ "str" : item.sDesc });
        }
        catch(e:Error)
        {
        }
    }

    public function onOut(event:MouseEvent):*
    {
        try
        {
            toolTipMC.close();
        }
        catch(e:Error)
        {
        }
    }

}
}//package 

