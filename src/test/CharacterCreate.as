package test {

import UI.Chat;
import UI.ToolTipMC;

import assets.ib2;

import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.ColorTransform;
import flash.geom.Transform;
import flash.net.URLRequestMethod;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;
import flash.text.TextField;
import flash.utils.getDefinitionByName;

import abstracts.AbstractLoader;

import org.sepy.ColorPicker.ColorPicker2;

import test_characters.Carousel;

public class CharacterCreate extends AbstractLoader {

    private const game:Game = Game.root;
    public var toolTipMC:ToolTipMC;
    private const chat:Chat = new Chat(game);
    private var _skills:MovieClip = new MovieClip();
    public var strCharName:TextField;
    public var txtHairName:TextField;
    public var txtClassName:TextField;
    public var txtCat:TextField;

    public var avatars:Array = [];
    private var pAV:Avatar;

    public var btnBack:SimpleButton;
    public var btnCreate:SimpleButton;
    public var btnLeftHair:SimpleButton;
    public var btnRightHair:SimpleButton;
    public var btnLeftCharacter:SimpleButton;
    public var btnRightCharacter:SimpleButton;
    public var btnLeftClassCharacter:SimpleButton;
    public var btnRightClassCharacter:SimpleButton;

    public var cpHair:ColorPicker2;
    public var cpSkin:ColorPicker2;
    public var cpEye:ColorPicker2;

    public var hairs:Object;

    public var selected:int = 0;
    public var selectedHair:int = 0;
    public var listCount:int = 0;
    public var loadedCount:int = 0;

    public var mcGender:GenderMC = new GenderMC();
    public var carousel:Carousel;

    public var applicationDomain:ApplicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
    public var context:LoaderContext = new LoaderContext(false, applicationDomain);

    private var defaultCT:ColorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0);
    private var characterCT:ColorTransform = new ColorTransform(1, 1, 1, 1, 25, 25, 25, 0);

    public const testData:Array = [
        {
            "id": 2,
            "strUsername": "",
            "strGender": "M",
            "sClassName": "Warrior",
            "strHairName": "MQElegant",
            "strHairFilename": "hairs/M/MQElegant.swf",
            "intColorSkin": 15388042,
            "intColorHair": 6180663,
            "intColorBase": 0,
            "intColorEye": 91294,
            "intColorTrim": 0,
            "intColorAccessory": 0,
            "eqp": {
                "Weapon": {
					"ItemID": 1,
                    "sFile": "items/swords/sword01.swf",
                    "sType": "Weapon",
                    "sLink": "sword01"
                },
                "ar": {
					"ItemID": 2,
                    "sFile": "NewWarriorB2.swf",
                    "sLink": "NewWarriorB2"
                }
            }
        },
        {
            "id": 3,
            "strUsername": "",
            "strGender": "M",
            "sClassName": "Mage",
            "strHairName": "MQElegant",
            "strHairFilename": "hairs/M/MQElegant.swf",
            "intColorSkin": 15388042,
            "intColorHair": 6180663,
            "intColorBase": 0,
            "intColorEye": 91294,
            "intColorTrim": 0,
            "intColorAccessory": 0,
            "eqp": {
                "Weapon": {
					"ItemID": 7,
                    "sFile": "items/staves/staff01.swf",
                    "sType": "Weapon",
                    "sLink": ""
                },
                "ar": {
					"ItemID": 3,
                    "sFile": "BaseMageRedesign3R2.swf",
                    "sLink": "BaseMageRedesign3"
                }
            }
        },
        {
            "id": 4,
            "strUsername": "",
            "strGender": "M",
            "sClassName": "Rogue",
            "strHairName": "MQElegant",
            "strHairFilename": "hairs/M/MQElegant.swf",
            "intColorSkin": 15388042,
            "intColorHair": 6180663,
            "intColorBase": 0,
            "intColorEye": 91294,
            "intColorTrim": 0,
            "intColorAccessory": 0,
            "eqp": {
                "Weapon": {
                    "ItemID": 8,
                    "sFile": "items/daggers/dagger01.swf",
                    "sType": "Weapon",
                    "sLink": ""
                },
                "ar": {
					"ItemID": 4,
                    "sFile": "BaseRogue2xx.swf",
                    "sLink": "Rogue2"
                }
            }
        },
        {
            "id": 5,
            "strUsername": "",
            "strGender": "M",
            "sClassName": "Healer",
            "strHairName": "MQElegant",
            "strHairFilename": "hairs/M/MQElegant.swf",
            "intColorSkin": 15388042,
            "intColorHair": 6180663,
            "intColorBase": 0,
            "intColorEye": 91294,
            "intColorTrim": 0,
            "intColorAccessory": 0,
            "eqp": {
                "Weapon": {
					"ItemID": 7,
                    "sFile": "items/staves/staff01.swf",
                    "sType": "Weapon",
                    "sLink": ""
                },
                "ar": {
					"ItemID": 5,
                    "sFile": "NewHealerR2.swf",
                    "sLink": "NewHealerB2"
                }
            }
        }
    ];

    public var skills:Object = {};
    public var characters:Array = [];

    private var _currentSelected:CharacterHairItem;
    private var _previousSelected:CharacterHairItem;

    public function CharacterCreate() {
        characters = game.copyObj(testData);

        context.checkPolicyFile = false;
        context.allowCodeImport = true;

        _skills.x = 160.4;
        _skills.y = 610;
        addChild(_skills);

        mcGender.x = 560;
        mcGender.y = 310.55;
        mcGender.gotoAndStop("Male");
        addChildAt(mcGender, 3);

        strCharName.text = "";
        txtHairName.mouseEnabled = false;

        cpHair.allowUserColor = true;
        cpHair.selectedColor = 0;
        cpHair.columns = 21;
        cpHair.direction = "DL";
        cpHair.useAdvancedColorSelector = true;
        cpHair.useNoColorSelector = false;

        cpSkin.allowUserColor = true;
        cpSkin.selectedColor = 0;
        cpSkin.columns = 21;
        cpSkin.direction = "DL";
        cpSkin.useAdvancedColorSelector = true;
        cpSkin.useNoColorSelector = false;

        cpEye.allowUserColor = true;
        cpEye.selectedColor = 0;
        cpEye.columns = 21;
        cpEye.direction = "DL";
        cpEye.useAdvancedColorSelector = true;
        cpEye.useNoColorSelector = false;

        initCharacters();
        initSkills();
        initEvent();
        initCustomize();
        fetchHairs();
        initAnnouncements();
    }

    private function initEvent():void {
        btnCreate.addEventListener(MouseEvent.CLICK, onClick);
        btnBack.addEventListener(MouseEvent.CLICK, onClick);
        btnLeftHair.addEventListener(MouseEvent.CLICK, onClick);
        btnRightHair.addEventListener(MouseEvent.CLICK, onClick);
        btnLeftCharacter.addEventListener(MouseEvent.CLICK, onClick);
        btnRightCharacter.addEventListener(MouseEvent.CLICK, onClick);
        btnLeftClassCharacter.addEventListener(MouseEvent.CLICK, onClick);
        btnRightClassCharacter.addEventListener(MouseEvent.CLICK, onClick);
        mcGender.btnMale.addEventListener(MouseEvent.CLICK, onClick);
        mcGender.btnFemale.addEventListener(MouseEvent.CLICK, onClick);

        lists.addEventListener(MouseEvent.MOUSE_WHEEL, onScroll, false, 0, true);
        bg.addEventListener(MouseEvent.MOUSE_WHEEL, onScroll, false, 0, true);

        strCharName.restrict = "A-Za-z0-9 _";
    }

    private function initCharacters() : void
    {
        removeAllCharacters();

        avatars = [
            characters[selected],
            characters[(selected + 1) % characters.length],
            characters[(selected - 1 + characters.length) % characters.length]
        ]

        for each (var obj:Object in avatars) {
            if (obj == null) continue;
            setAvatar(obj);
        }

        strCharName.text = "";
        strCharName.removeEventListener(KeyboardEvent.KEY_UP, onChangeName);
        strCharName.addEventListener(KeyboardEvent.KEY_UP, onChangeName);

        var targetGender:String = (characters[selected].strGender == "M") ? "Male" : "Female";
        if (mcGender.currentLabel != targetGender) mcGender.gotoAndPlay("go" + targetGender);

        pAV = getAvatarMCByClassName(characters[selected].sClassName).world.myAvatar;
        txtClassName.text = characters[selected].sClassName;

        initActSkill();
    }

    private function initCustomize():void {
        cpHair.removeEventListener("CHANGE", onColorSelect);
        cpHair.removeEventListener("ROLL_OVER", onItemRollOver);
        cpHair.removeEventListener("ROLL_OUT", onItemRollOut);

        cpHair.addEventListener("CHANGE", onColorSelect, false, 0, true);
        cpHair.addEventListener("ROLL_OVER", onItemRollOver, false, 0, true);
        cpHair.addEventListener("ROLL_OUT", onItemRollOut, false, 0, true);
        cpHair.selectedColor = pAV != null ? pAV.objData.intColorHair : 0;

        cpSkin.removeEventListener("CHANGE", onColorSelect);
        cpSkin.removeEventListener("ROLL_OVER", onItemRollOver);
        cpSkin.removeEventListener("ROLL_OUT", onItemRollOut);

        cpSkin.addEventListener("CHANGE", onColorSelect, false, 0, true);
        cpSkin.addEventListener("ROLL_OVER", onItemRollOver, false, 0, true);
        cpSkin.addEventListener("ROLL_OUT", onItemRollOut, false, 0, true);
        cpSkin.selectedColor = pAV != null ? pAV.objData.intColorSkin : 0;

        cpEye.removeEventListener("CHANGE", onColorSelect);
        cpEye.removeEventListener("ROLL_OVER", onItemRollOver);
        cpEye.removeEventListener("ROLL_OUT", onItemRollOut);

        cpEye.addEventListener("CHANGE", onColorSelect, false, 0, true);
        cpEye.addEventListener("ROLL_OVER", onItemRollOver, false, 0, true);
        cpEye.addEventListener("ROLL_OUT", onItemRollOut, false, 0, true);
        cpEye.selectedColor = pAV != null ? pAV.objData.intColorEye : 0;
    }

    public function setAvatar(obj:Object):void {
        var world:World = new World(game);
        var _pAV:Avatar = new Avatar(game);

        _pAV.objData = obj;
        world.myAvatar = _pAV;
        world.myAvatar.target = null;

        var avatarCache:String = obj.strUsername + "-" + obj.strGender + "-" + obj.id;
        var avatar:AvatarMC = avatarCache in game.cache.create ? game.cache.create[avatarCache] as AvatarMC : world.loadAvatar(world, _pAV, true);

        avatar.name = "avt-" + avatars.indexOf(obj);
        avatar.scale(avatars.indexOf(obj) == 0 ? 2.6 : 1.8);
        avatar.x = avatars.indexOf(obj) == 0 ? 450 : (avatars.indexOf(obj) == 1) ? 650 : 250;
        avatar.y = avatars.indexOf(obj) == 0 ? 520 : 470;

        avatar.transform.colorTransform = avatars.indexOf(obj) != 0 ? characterCT : defaultCT;
        avatar.loadHair();

        if (!(obj.strUsername in game.cache.create)) game.cache.create[obj.strUsername + "-" + obj.strGender + "-" + obj.id] = avatar;

        if (avatars.indexOf(obj) == 0 && avatar.isLoaded) {
            var randomAnimation:Array = ['Cheer', 'Backflip', 'Wave', 'Unsheath'];
            avatar.mcChar.gotoAndPlay(randomAnimation[Math.floor(Math.random() * randomAnimation.length)]);
        }

        addChildAt(avatar, 0);
    }

    public function getAvatarMCByClassName(className:String) : AvatarMC
    {
        for (var i:int = 0; i < numChildren; i++)
        {
            var child:DisplayObject = getChildAt(i);

            if (child is AvatarMC)
            {
                var avt:AvatarMC = child as AvatarMC;

                if (avt.pAV.objData.sClassName == className)
                {
                    return avt;
                }
            }
        }

        return null;
    }

    private function onChangeName(event:Event):void {
        characters[selected].strUsername = strCharName.text;
        pAV.pMC.pname.ti.text = strCharName.text;
    }

    private function fetchHairs():void {
        game.requestAPI(URLRequestMethod.GET, "game/character/hairs", null, onComplete, null);
    }

    private function initAnnouncements() : void
    {
        carousel = new Carousel();
        carousel.x = 945;
        carousel.y = 514;
        addChild(carousel);
    }

    private function onComplete(event:Event):void {
        var response:Object = JSON.parse(event.target.data);

        listCount = pAV.objData.strGender == "M" ? response.hairs.M.length : response.hairs.F.length;
        hairs = pAV.objData.strGender == "M" ? response.hairs.M : response.hairs.F;

        for each (var hair:Object in hairs) {
            game.onLoadMaster(onLoadHairComplete, context, hair.File, null, null, true);
        }
    }

    private function onLoadHairComplete(event:Event):void {
        loadedCount++;

        if (listCount == loadedCount) {
            initHairs();
        }
    }

    private function initHairs():void {
        game.onRemoveChildren(lists);

        resetScroll();

        for (var i:int = 0; i < listCount; i++) {
            var hairCache:String = hairs[i].Name + "-" + pAV.objData.strGender;
            var head:CharacterHairItem = hairCache in game.cache.hairs ? game.cache.hairs[hairCache] : new CharacterHairItem();

            head.x = i % 4 * (50 + 7);
            head.y = Math.floor(i / 4) * (40 + 7);
            head.name = "hair-" + i;
            head.buttonMode = true;
            head.addEventListener(MouseEvent.CLICK, onHairClick);

            if (!(hairCache in game.cache.hairs)) {
                setHair(head, hairs[i].Name);
                game.cache.hairs[hairCache] = head;
            }

            lists.addChild(head);
        }

        positionHighlighter();
        initScroll();
    }

    public function setHair(mc:CharacterHairItem, hairName:String):void {
        var AssetClass:Class;
        var child:DisplayObject;
        var bBackHair:Boolean = false;

        try {
            AssetClass = getDefinitionByName("mcHead" + pAV.objData.strGender) as Class;
            child = mc.mcH.head.getChildByName("face");
            if (child != null) {
                mc.mcH.head.removeChild(child);
            }
            mc.mcH.head.addChildAt(new AssetClass(), 0).name = "face";
        } catch (err:Error) {
        }


        AssetClass = applicationDomain.getDefinition(hairName + pAV.objData.strGender + "Hair") as Class;
        while (mc.mcH.head.hair.numChildren > 0) {
            mc.mcH.head.hair.removeChildAt(0);
        }
        try {
            mc.mcH.head.hair.addChild(new AssetClass());
        } catch (e:Error) {
        }
        mc.mcH.head.hair.visible = true;

        try {
            AssetClass = applicationDomain.getDefinition(hairName + pAV.objData.strGender + "HairBack") as Class;
            while (mc.mcH.backhair.numChildren > 0) {
                mc.mcH.backhair.removeChildAt(0);
            }
            mc.mcH.backhair.addChild(new AssetClass());
            mc.mcH.backhair.visible = true;
            bBackHair = true;
        } catch (err:Error) {
            mc.mcH.backhair.visible = false;
        }

        mc.mcH.backhair.visible = mc.mcH.head.hair.visible && bBackHair;
    }

    private function initSkills() : void
    {
        game.requestAPI(URLRequestMethod.POST, "game/character/skills", {
            itemId: "2,3,4,5"
        }, onSkillComplete, null, false);
    }

    private function onSkillComplete(event:Event) : void
    {
        skills = JSON.parse(event.target.data);
        toolTipMC = new ToolTipMC();
        addChild(toolTipMC);
        initActSkill();
    }

    private function initActSkill() : void
    {
        try
        {
            game.onRemoveChildren(_skills);

            txtCat.text = game.statsController.getCatDefinition(skills[characters[selected].id].cat);
            
            for each(var skill:Object in skills[characters[selected].id].skills)
            {
                skill.sArg1 = "";
                skill.sArg2 = "";

                var icon:ib2 = new ib2();
                icon.tQty.visible = false;
                icon.icon2 = null;
                icon.actObj = skill;
                icon.isCC = true;

                game.updateIcons([icon], skill.icon.split(','), null, true);
                icon.addEventListener(MouseEvent.MOUSE_OVER, actIconOver, false, 0, true);
                icon.addEventListener(MouseEvent.MOUSE_OUT, actIconOut, false, 0, true);
                icon.mouseChildren = false;

                icon.width = 53;
                icon.height = 49;
                icon.x = 55 * _skills.numChildren;

                _skills.addChild(icon);
            }
        }
        catch (e:Error)
        {

        }
    }

    public function positionHighlighter():void {
        var childTarget:DisplayObject = lists.getChildByName("hair-" + selectedHair);
        var child:CharacterHairItem = childTarget as CharacterHairItem;

        if (_previousSelected != null) _previousSelected.highlighter.visible = false;

        _currentSelected = child;
        _currentSelected.highlighter.visible = true;
        _previousSelected = _currentSelected;

        txtHairName.text = hairs[selectedHair].Name;
    }

    private function onColorSelect(event:Event):void {
        switch (event.target.name) {
            case "cpSkin":
                pAV.objData.intColorSkin = event.target.selectedColor;
                break;
            case "cpEye":
                pAV.objData.intColorEye = event.target.selectedColor;
                break;
            case "cpHair":
                pAV.objData.intColorHair = event.target.selectedColor;
                break;
        }

        pAV.pMC.updateColor();
    }

    private function onItemRollOver(event:Event):void {
        var data:Object = {
            intColorSkin: pAV.objData.intColorSkin,
            intColorHair: pAV.objData.intColorHair,
            intColorEye: pAV.objData.intColorEye,
            intColorBase: pAV.objData.intColorBase,
            intColorTrim: pAV.objData.intColorTrim,
            intColorAccessory: pAV.objData.intColorAccessory
        };

        switch (event.target.name) {
            case "cpSkin":
                data.intColorSkin = event.target.selectedColor;
                break;
            case "cpEye":
                data.intColorEye = event.target.selectedColor;
                break;
            case "cpHair":
                data.intColorHair = event.target.selectedColor;
                break;
        }

        pAV.pMC.updateColor(data);
    }

    public function onItemRollOut(event:Event):void {
        pAV.pMC.updateColor();
    }

    private function reset():void {
        selectedHair = 0;
        loadedCount = 0;
        fetchHairs();
        initCustomize();
        positionHighlighter();
    }

    private function onHairClick(event:MouseEvent):void {
        var id:int = parseInt(event.currentTarget.name.slice(5));
        updateHair(id);
    }

    private function resetAvatar(hairName:String, fileHair:String, color:Boolean = false): void {
        var cloneAvatar:AvatarMC = getAvatarMCByClassName(characters[selected].sClassName);

        if (cloneAvatar.mcChar.head.hair.numChildren > 0) {
            cloneAvatar.mcChar.head.hair.removeChildAt(0);
        }

        if (cloneAvatar.mcChar.backhair.numChildren > 0) {
            cloneAvatar.mcChar.backhair.removeChildAt(0);
        }

        if (color) {
            cpHair.selectedColor = 6180663;
            cpSkin.selectedColor = 15388042;
            cpEye.selectedColor = 91294;

            cloneAvatar.pAV.objData.intColorSkin = 15388042;
            cloneAvatar.pAV.objData.intColorHair = 6180663;
            cloneAvatar.pAV.objData.intColorBase = 0;
            cloneAvatar.pAV.objData.intColorEye = 91294;
            cloneAvatar.pAV.objData.intColorTrim = 0;
            cloneAvatar.pAV.objData.intColorAccessory = 0;

            cloneAvatar.updateColor();
        }

        cloneAvatar.pAV.objData.strGender = characters[selected].strGender;
        cloneAvatar.pAV.objData.strHairName = hairName != null ? hairName : characters[selected].strHairName;
        cloneAvatar.pAV.objData.strHairFilename = fileHair != null ? fileHair : characters[selected].strHairFilename;
        cloneAvatar.loadHair();

        initCharacters();
    }

    private function removeAllCharacters():void {
        for (var numChild:int = numChildren - 1; numChild >= 0; numChild--) {

            var child:DisplayObject = getChildAt(numChild);

            if (child is AvatarMC)
            {
                if (child.name.indexOf('-') != -1) {
                    var avt:AvatarMC = child as AvatarMC;
                    avt.pAV.objData.strUsername = "";
                    avt.pname.ti.text = "";
                    removeChildAt(numChild);
                }
            }
        }
    }

    private function updateHair(newHairIndex:int):void {
        if (newHairIndex >= 0 && newHairIndex < listCount) {
            selectedHair = newHairIndex;

            characters[selected].strHairName = hairs[selectedHair].Name;
            characters[selected].strHairFilename = hairs[selectedHair].File;

            resetAvatar(hairs[selectedHair].Name, hairs[selectedHair].File);

            pAV.pMC.loadHair();

            positionHighlighter();
        }
    }

    private function updateGender(newGender:String, hairName:String, hairFile:String):void {
        if (pAV.objData.strGender == newGender) {
            mcGender.gotoAndPlay(newGender == "F" ? "goMale" : "goFemale");

            characters[selected].strGender = newGender == "F" ? "M" : "F";
            characters[selected].strHairName = hairName;
            characters[selected].strHairFilename = hairFile;

            reset();
            resetAvatar(hairName, hairFile, true);
        }
    }

    private function getSelectedItemId(): Array {
        var items:Array = [];

		for each(var equipment:Object in characters[selected].eqp) {
			if (!equipment.ItemID) continue;
			items.push(equipment.ItemID);
		}

/*
        for (var data:String in characters) {
            if (characters[data].id == selected) continue;

            for each(var equipment:Object in characters[data].eqp) {
				if (!equipment.ItemID) continue;
                items.push(equipment.ItemID);
            }
        }*/
		
        return items;
    }

    private function onCreateComplete(event:Event): void {
        var response:Object = JSON.parse(event.currentTarget.data);

        if (response.bSuccess == 0) {
            if (response.sMsg is String)
            {
                chat.popBubble("", response.sMsg, AvatarMC(pAV.pMC));
            }
            else
            {
                var errMsg:String = "";

                for (var str:String in response.sMsg) errMsg += response.sMsg[str][0] + "\n";

                chat.popBubble("", errMsg, AvatarMC(pAV.pMC));
            }
        } else {
            if (game.preference.data.strUsername && game.preference.data.strPassword) {
                game.login(game.preference.data.strUsername, game.preference.data.strPassword);
            } else {
                game.mcLogin.gotoAndStop("Login");
            }
        }
    }

    private function onClick(event:MouseEvent):void {
        switch (event.currentTarget.name) {
            case "btnBack":
                if (game.characters.length > 0) {
                    characters = testData;
                    reset();
                    resetAvatar(characters[selected].strHairName, characters[selected].strHairFilename, true);
                    game.mcLogin.gotoAndStop("Characters");
                } else {
                    game.mcLogin.gotoAndStop("Init");
                }
                break;
            case "btnMale":
                updateGender("F", "MQElegant", "hairs/M/MQElegant.swf");
                break;
            case "btnFemale":
                updateGender("M", "Pig1Bangs1", "hairs/F/Pig1Bangs1.swf");
                break;
            case "btnLeftHair":
                updateHair(selectedHair - 1);
                break;
            case "btnRightHair":
                updateHair(selectedHair + 1);
                break;
            case "btnLeftClassCharacter":
            case "btnLeftCharacter":
                selected = (selected + characters.length - 1) % characters.length;
                initCharacters();
                reset();
                break;
            case "btnRightClassCharacter":
            case "btnRightCharacter":
                selected = (selected + 1) % characters.length;
                initCharacters();
                reset();
                break;
            case "btnCreate":
                if (strCharName.text.length < 5) {
                    chat.popBubble("", "Name needs to be longer.", AvatarMC(pAV.pMC));
                } else {
                    game.requestAPI(URLRequestMethod.POST, "game/character/create", {
                        userId: game.getLogin().userId,
                        name: Game.trim(strCharName.text),
                        gender: pAV.objData.strGender,
                        hairId: hairs[selectedHair].id,
                        items: String(getSelectedItemId()),
                        color: JSON.stringify({
                            skin: pAV.objData.intColorSkin,
                            hair: pAV.objData.intColorHair,
                            eye: pAV.objData.intColorEye,
                            base: pAV.objData.intColorBase,
                            trim: pAV.objData.intColorTrim,
                            accessory: pAV.objData.intColorAccessory
                        })
                    }, onCreateComplete, null, false);
                }
                break;
        }
    }

    public function actIconOver(event:MouseEvent) : void {
        game.actIconTT(MovieClip(event.currentTarget), toolTipMC)
//        toolTipMC.openWith({"str": "test!", "lowerleft": true })
    }

    public function actIconOut(_arg_1:MouseEvent) : void {
        toolTipMC.close();
    }

}

}
