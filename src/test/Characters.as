package test {

import UI.Chat;

import test_characters.Carousel;

import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.ProgressEvent;
import flash.events.TimerEvent;
import flash.geom.ColorTransform;
import flash.net.URLRequestMethod;
import flash.text.TextField;
import flash.utils.Timer;

import game.character.CharSelectListItem;
import game.config.ConfigurationData;
import game.select.SelectorOptionItem;

public class Characters extends MovieClip {

    public var game:Game = Game.root;
    public var chat:Chat;

    public var btnBack:SimpleButton;
    public var btnPlay:SimpleButton;
    public var btnLeftCharacter:SimpleButton;
    public var btnRightCharacter:SimpleButton;

    public var settings:CharacterSettings;
    public var askPassword:CharacterAskPassword;

    public var carousel:Carousel;
    public var lists:MovieClip = new MovieClip();
    public var outfitLists:MovieClip = new MovieClip();
    public var btnSettings:MovieClip;

    public var tBtn:TextField;
    public var tCharacters:TextField;

    public var selected:int = 0;
    public var availableSlot:int = 0;

    private var defaultCT:ColorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0);
    private var characterCT:ColorTransform = new ColorTransform(1, 1, 1, 1, 25, 25, 25, 0);

    public var characters:Array;
    public var avatars:Array;

    public var jokeDelay:Number = 1000 * 20;
    public var timer:Timer = new Timer(jokeDelay);
    public var jokes:Array = ["Choosing your hero… or your next respawn victim?", "Remember: fashion > stats. Always.", "Your character misses you. No pressure.", "Did you really grind 6 hours for that hat?", "Ah yes, the hero who saved the world… and still can’t find pants that match.", "You look stronger than yesterday. Must be the lag.", "Warning: this character still owes Gold to the innkeeper."]

    public var world:World;

    private var _currentSelected:CharSelectListItem;
    private var _previousSelected:CharSelectListItem;

    public function Characters() {
        chat = new Chat(game);
        settings.visible = false;
        askPassword.visible = false;

        if (game.mcLogin.mcTitle)
        {
            var title:MovieClip = game.mcLogin.mcTitle.getChildAt(0) as MovieClip;
            title.Screen.Background.Spawn.alpha = 1;
        }

        tBtn.text = "Play";
        tBtn.mouseEnabled = false;

        lists.x = 945;
        lists.y = 100;
        addChildAt(lists, 1);

        outfitLists.x = 50;
        outfitLists.y = 125;
        addChild(outfitLists);

        initInterface();
        initLists();
        initAnnouncements();
    }

    public function initInterface(): void {
        characters = game.characters;
        initCharacters();
        initButton();
    }

    private function initButton():void {
        btnBack.addEventListener(MouseEvent.CLICK, onClick);
        btnPlay.addEventListener(MouseEvent.CLICK, onClick);
        btnSettings.addEventListener(MouseEvent.CLICK, onClick);
        btnLeftCharacter.addEventListener(MouseEvent.CLICK, onClick);
        btnRightCharacter.addEventListener(MouseEvent.CLICK, onClick);
        btnSettings.buttonMode = true;
        timer.addEventListener(TimerEvent.TIMER, onTimer);
    }

    public function initCharacters():void {
		try {
		
		removeAllCharacters();

        if (game.preference.data.bHideOtherCharacter) {
            btnLeftCharacter.visible = false;
            btnRightCharacter.visible = false;
        } else {
            btnLeftCharacter.visible = true;
            btnRightCharacter.visible = true;
        }

        selected = game.preference.data.iSelectedCharacter;

        avatars = [
            characters[selected],
            characters[(selected + 1) % characters.length],
            characters[(selected - 1 + characters.length) % characters.length]
        ];

        if (game.preference.data.bHideOtherCharacter) {
            setAvatar(avatars[selected]);
        } else {
            for each (var obj:Object in avatars) {
                if (obj == null) continue;
                setAvatar(obj);
            }
        }

            timer.start();
        positionHighlighter();
		
		} catch(e:Error) {
		}
    }

    private function setAvatar(obj:Object):void {
        var world:World = new World(game);
        var pAV:Avatar = new Avatar(game);

        pAV.objData = obj;
        world.myAvatar = pAV;
        world.myAvatar.target = null;

        var avatar:AvatarMC = obj.strUsername in game.cache.characters ? game.cache.characters[obj.strUsername] as AvatarMC : world.loadAvatar(world, pAV, true);

        avatar.name = "avt-" + avatars.indexOf(obj);
        avatar.scale(avatars.indexOf(obj) == 0 ? 2.6 : 1.8);
        avatar.x = avatars.indexOf(obj) == 0 ? 450 : (avatars.indexOf(obj) == 1) ? 650 : 250;
        avatar.y = avatars.indexOf(obj) == 0 ? 520 : 470;
        avatar.mcChar.transform.colorTransform = avatars.indexOf(obj) != 0 ? characterCT : defaultCT;

        if (!(obj.strUsername in game.cache.characters)) game.cache.characters[obj.strUsername] = avatar;

        if (avatars.indexOf(obj) == 0) {
            var randomAnimation:Array = ['Cheer', 'Backflip', 'Wave', 'Unsheath'];
            avatar.mcChar.gotoAndPlay(randomAnimation[Math.floor(Math.random() * randomAnimation.length)]);
        }

        addChildAt(avatar, 0);

//        var box:MovieClip = new MovieClip();
//        box.graphics.beginFill(52479);
//        box.graphics.drawRect(0, 0, 50, 20);
//        box.graphics.endFill();
//        box.x = avatars.indexOf(obj) == 0 ? 450 : (avatars.indexOf(obj) == 1) ? 650 : 250;
//        box.y = avatars.indexOf(obj) == 0 ? 400 : 350;
//        addChildAt(box, 0);
    }

    private function initLists():void {
        if (lists.numChildren > 0)
        {
            game.onRemoveChildren(lists);
            availableSlot = 0;
        }

        for (var i:int = 0; i < game.getLogin().intMaxCharSlot; i++) {
            var item:CharSelectListItem = new CharSelectListItem();

            if (i < game.getLogin().intCharSlot) {
                var character:Object = characters[i];

                if (character) {
                    item.tName.text = character.strUsername;
                    item.tInfo.text = "Level " + character.intLevel + ", " + character.strClassName + " Rank " + game.getRankFromPoints(character.intClassRank);
                    item.btnDelete.addEventListener(MouseEvent.CLICK, onClick);
                    item.name = "item-" + i;
                    item.addEventListener(MouseEvent.CLICK, function (event:MouseEvent): void {
                        selected = parseInt(event.currentTarget.name.slice(5));
                        SetSelectedCharacter();
                        updateCharacters();

                        if (_previousSelected != null) _previousSelected.highlighter.visible = false;

                        _currentSelected = CharSelectListItem(event.currentTarget);
                        _currentSelected.highlighter.visible = true;
                        _previousSelected = _currentSelected;
                    });
                    ++availableSlot;
                } else {
                    item.tName.visible = false;
                    item.tInfo.visible = false;
                    item.btnDelete.visible = false;
                    item.tNewChar.visible = true;
                    item.slot.visible = true;
                    item.name = "btnCreate";
                    item.addEventListener(MouseEvent.CLICK, onClick);
                }
            } else {
                item.tNewChar.text = "Locked";
                item.buttonMode = false;

                item.tName.visible = false;
                item.tInfo.visible = false;
                item.btnDelete.visible = false;
                item.tNewChar.visible = true;
                item.slot.visible = false;
                item.lock.visible = true;
            }

            item.buttonMode = true;
            item.y = i * 50;

            lists.addChild(item);
        }

        tCharacters.text = availableSlot + " / " + "6 Characters";
        positionHighlighter();
    }

    private function initAnnouncements() : void
    {
        carousel = new Carousel();
        carousel.x = 945;
        carousel.y = 514;
        addChild(carousel);
    }

    public function initSettings() : void {
        settings.btnCloseSettings.addEventListener(MouseEvent.CLICK, onClick);

        if (game.preference.data.bAskPassword) {
            settings.chkAskPassword.bitChecked = true;
        }

        if (game.preference.data.bHideOtherCharacter) {
            settings.chkHideCharacter.bitChecked = true;
        }

        settings.chkAskPassword.checkmark.visible = settings.chkAskPassword.bitChecked;
        settings.chkHideCharacter.checkmark.visible = settings.chkHideCharacter.bitChecked;
        settings.visible = true;
    }

    public function initAskPassword(sType:String = null):void {
        if (sType == null) return;

        askPassword.sType = sType;
        askPassword.txtPassword.text = "";
        askPassword.btnCloseAskPassword.addEventListener(MouseEvent.CLICK, onClick);
        askPassword.btnConfirm.addEventListener(MouseEvent.CLICK, onClick);
        askPassword.visible = true;
    }

    public function initGame():void {
        Game.loginInfo.strCharName = characters[selected].strUsername;
        game.connectTo(ConfigurationData.SERVER_IP_ADDRESS, ConfigurationData.SERVER_PORT);
        game.chatF.iChat = 2;
    }

    private function onTimer(event:TimerEvent):void {
        try {
            if (currentFrameLabel != "Login") timer.stop();

            var targetChild:DisplayObject = getChildByName("avt-" + (game.preference.data.bHideOtherCharacter || avatars.length <= 1 ? selected : Math.floor(Math.random() * avatars.length)));
            var luckyGuy:AvatarMC = targetChild as AvatarMC;
            var randomJokes:String = jokes[Math.floor(Math.random() * jokes.length)];

            chat.popBubble("", randomJokes, luckyGuy, 7000);
        } catch (e:Error) {
            timer.stop();
        }
    }

    public function updateCharacters():void {
        initCharacters();
        initLists();
    }

    private function positionHighlighter() : void
    {
        for (var i:int = 0; i < lists.numChildren; i++)
        {
            var child:CharSelectListItem = lists.getChildAt(i) as CharSelectListItem;

            if (child.name.indexOf("item-") != -1 && parseInt(child.name.slice(5)) == selected)
            {
                child.highlighter.visible = true;
            }
        }
    }

    private function removeAllCharacters():void {
        if (avatars != null) {
            for (var numChild:int = numChildren - 1; numChild >= 0; numChild--) {
                var childName:String = getChildAt(numChild).name;
                if (childName.indexOf('-') != -1) {
                    removeChildAt(numChild);
                }
            }
        }
    }

    private function SetSelectedCharacter(): void {
        game.preference.data.iSelectedCharacter = selected;
        game.preference.flush();
    }

    private function SetSettings():void {
        var oldHideOtherCharacter:Boolean = game.preference.data.bHideOtherCharacter;

        game.preference.data.bAskPassword = settings.chkAskPassword.checkmark.visible;
        game.preference.data.bHideOtherCharacter = settings.chkHideCharacter.checkmark.visible;

        settings.chkAskPassword.bitChecked = game.preference.data.bAskPassword;
        settings.chkHideCharacter.bitChecked = game.preference.data.bHideOtherCharacter;

        if (oldHideOtherCharacter != game.preference.data.bHideOtherCharacter) {
            initInterface();
        }

        settings.visible = false;
    }

    private function onClick(event:MouseEvent):void {
        game.mixer.playSound("Click");

        switch (event.currentTarget.name) {
            case "btnBack":
                game.mcLogin.gotoAndStop("Init");
                break;
            case "btnCreate":
                game.mcLogin.gotoAndStop("Create");
                break;
            case "btnLeftCharacter":
                selected = (selected + characters.length - 1) % characters.length;
                SetSelectedCharacter();
                updateCharacters();
                break;
            case "btnRightCharacter":
                selected = (selected + 1) % characters.length;
                SetSelectedCharacter();
                updateCharacters();
                break;
            case "btnDelete":
                initAskPassword("Delete");
                break;
            case "btnPlay":
                switch (tBtn.text.toLowerCase()) {
                    case "play":
                        if (game.preference.data.bAskPassword) {
                            initAskPassword("Play");
                        } else {
                            initGame();
                        }
                        break;
                }
                break;
            case "btnSettings":
                initSettings();
                break;
            case "btnCloseSettings":
                if (game.preference.data.bAskPassword && !settings.chkAskPassword.checkmark.visible) // game.preference.data.bAskPassword != settings.chkAskPassword.checkmark.visible
                {
                    initAskPassword("Change");
                    return;
                }

                SetSettings();

                break;
            case "btnCloseAskPassword":
                askPassword.visible = false;
                break;
            case "btnConfirm":
                game.requestAPI(URLRequestMethod.POST ,"game/character/password", {
                    charId: characters[selected].charId,
                    pass: askPassword.txtPassword.text.toString()
                }, onPasswordComplete, null, false);
                break;
        }
    }

    private function onPasswordComplete(event:Event): void {
        var response:Object = JSON.parse(event.target.data);

        if (response.bSuccess == 1) {

            switch (askPassword.sType) {
                case "Play":
                    initGame();
                    break;
                case "Change":
                    SetSettings();
                    break;
                case "Delete":
                    game.requestAPI(URLRequestMethod.POST, "game/character/delete", {
                        charId: characters[selected].charId
                    }, onDeleteComplete, null, false);
                    break;
            }

            askPassword.visible = false;
        } else {
            game.MsgBox.notify(response.sMsg);
        }
    }

    private function onDeleteComplete(event:Event): void {
        var response:Object = JSON.parse(event.target.data);

        if (response.bSuccess == 1) {
            delete game.cache.characters[characters[selected].strUsername];

            characters.splice(selected, 1);
            selected = 0;
            SetSelectedCharacter();
            updateCharacters();

            if (characters.length < 1) game.mcLogin.gotoAndStop("Init");
        } else {
            game.MsgBox.notify(response.sMsg);
        }
    }

}

}
