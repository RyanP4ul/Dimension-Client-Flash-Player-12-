// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//Avatar

package {
import UI.Display.LevelUpDisplay;
import UI.Display.RankUpDisplay;

import flash.display.MovieClip;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.filters.GlowFilter;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;

import test_characters.CustomLoader;

public class Avatar {

    public var game:Game;
    public var uid:int;
    public var pMC:MovieClip;
    public var pnm:String;
    public var objData:Object = null;
    public var dataLeaf:Object = {};
    public var guild:Object = {};
    public var npcType:String = "player";
    public var target:* = null;
    public var targets:Object = {};
    public var isMyAvatar:Boolean = false;
    public var friends:Array = [];
    public var classes:Array;
    public var factions:Array = [];
    public var bank:Array;
    public var items:Array;
    public var houseitems:Array;
    public var tempitems:Array = [];
    public var bitData:Boolean = false;
    public var strFrame:String = "";
//    public var petMC:PetMC;
    public var companions:Object = null;
    public var sLinkPet:String = "";
    public var friendsLoaded:Boolean = false;
    public var strProj:String = "";
    public var invLoaded:Boolean = false;
    public var filtered_list:Array;
    private var loadCount:int = 0;
    private var firstLoad:Boolean = true;
    private var specialAnimation:Object = {};
    public var lastAnimTime:int = 0;

    public function Avatar(game:Game) {
        this.game = game;
    }

    public function initAvatar(o:Object):* {
        objData = o.data;

        if ("intCopper" in objData) objData.intCopper = Number(objData.intCopper);
        if ("intGold" in objData) objData.intGold = Number(objData.intGold);
        if ("dUpgExp" in objData) objData.dUpgExp = game.stringToDate(objData.dUpgExp);
        if ("dMutedTill" in objData) objData.dMutedTill = game.stringToDate(objData.dMutedTill);
        if ("dCreated" in objData) objData.dCreated = game.stringToDate(objData.dCreated);

        pMC.strGender = objData.strGender;

        updateRep();

        pMC.updateName();
        pMC.ignore.visible = o.data.hasOwnProperty("strUsername") ? game.chatF.isIgnored(o.data.strUsername) : false;

        if (objData.eqp != null) {
            for (var eqp:String in objData.eqp) {
                loadCount++;

                loadMovieAtES(eqp, objData.eqp[eqp].sFile, objData.eqp[eqp].sLink);
                updateItemAnimation(objData.eqp[eqp].sMeta);
            }
        }

        pMC.loadHair();

        bitData = true;
    }

    public function get canLoadSelf() : Boolean
    {
        return game.currentLabel == "Game" && game.preference.data.bDisLoadChar && game.preference.data.bCharSelf && objData.strUsername == game.world.myAvatar.objData.strUsername;
    }

    public function loadMovieAtES(eqp:String, _arg_2:*, _arg_3:*):void {
        if (eqp != null) {
            if (!game.preference.data.bDisLoadChar || canLoadSelf)
            {
                switch (eqp) {
                    case "Weapon":
                        pMC.loadWeapon(_arg_2, _arg_3);
                        return;
                    case "he":
                        pMC.loadHelm(_arg_2, _arg_3);
                        return;
                    case "ba":
                        pMC.loadCape(_arg_2, _arg_3);
                        return;
                    case "ar":
                        pMC.loadClass(_arg_2, _arg_3);
                        return;
                    case "co":
                        pMC.loadArmor(_arg_2, _arg_3);
                        return;
                    case "pe":
                        loadPet();
                        return;
                }
            }
            else
            {
                pMC.isLoaded = true;
                pMC.gotoAndStop("in2");
            }
        }
    }

    public function unloadMovieAtES(_arg_1:String):void {
        if (_arg_1 != null) {
            switch (_arg_1) {
                case "he":
                    pMC.mcChar.head.helm.visible = false;
                    pMC.mcChar.head.hair.visible = true;
                    pMC.mcChar.backhair.visible = pMC.bBackHair;
                    if (this == game.world.myAvatar) {
                        game.showPortrait(this);
                    }
                    if (this == game.world.myAvatar.target) {
                        game.showPortraitTarget(this);
                    }
                    return;
                case "ba":
                    pMC.mcChar.cape.visible = false;
                    return;
                case "pe":
                    unloadPet();
                    return;
                case "co":
                    pMC.loadClass(objData.eqp["ar"].sFile, objData.eqp["ar"].sLink);
                    return;
            }
        }
    }

    var context:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);


    public function loadPet():void {
		companions = {};
	
        if (game.world.doLoadPet(this) && objData != null && objData.hasOwnProperty("companions") && game.world.CHARS.contains(pMC))
        {
            for each (var o:Object in objData.companions)
            {
                var pet:PetMC = new PetMC();

                pet.mouseEnabled = (pet.mouseChildren = false);
                pet.WORLD = game.world;
                pet.pAV = this;
                pet.petId = int(o.id);
                companions[o.id] = pet;

//                game.onLoadMaster(onLoadPetComplete, game.world.loaderC, o.sFile, null, onLoadPetError);


                var loader:CustomLoader = new CustomLoader();
                loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadPetComplete);
                loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadPetError);
                loader.customParent = pet;
                loader.load(new URLRequest(game.getFilePath(o.sFile)), context);
            }
        }
    }

    private function onLoadPetError(_arg_1:Event):void {
		trace("onLoadPetError");
        unloadPet();
    }

    public function onLoadPetComplete(e:Event):void {
		trace("onLoadPetComplete");

        var loader:CustomLoader = CustomLoader(e.target.loader);

        var companionObj:Object = objData.companions[loader.customParent.petId];

        if (!companionObj) return;

        trace("onLoadPetComplete > 1");

        try {
            trace("onLoadPetComplete > 2");

            var assetClass:Class = (loader.contentLoaderInfo.applicationDomain.getDefinition(companionObj.sLink) as Class);
            trace("onLoadPetComplete > " + companionObj.sLink);
            loader.customParent.removeChildAt(1);
            trace("onLoadPetComplete > 3");
            loader.customParent.mcChar = MovieClip(loader.customParent.addChildAt(new (assetClass), 1));
            trace("onLoadPetComplete > 4");
            loader.customParent.mcChar.name = "mc";
            trace("onLoadPetComplete > 5");
        } catch (e:Error) {
            trace("Error loading pet asset class: " + e.message);
        }

        if (game.world.uoTree[objData.strUsername.toLowerCase()].strFrame == game.world.strFrame) {
            trace("onLoadPetComplete > 6");
            if (loader.customParent.stage == null && (loader.customParent.getChildByName("defaultmc") == null)) {
                trace("onLoadPetComplete > 6.1");
                MovieClip(game.world.CHARS.addChild(loader.customParent)).name = ("pet_" + loader.customParent.petId);
            }

            trace("onLoadPetComplete > 7");

            loader.customParent.scale(pMC.mcChar.scaleY);
            loader.customParent.x = (pMC.x - 20);
            loader.customParent.y = (pMC.y + 5);
            trace("onLoadPetComplete > 8");
        }

        game.companionController.AddCompanion(companionObj);
		
//		if (objData.eqp["pe"].sType == "BattlePet")
//		{
//			var avt:Avatar = game.world.getAvatarByUserName(objData.strUsername.toLowerCase());
//			if (avt.isMyAvatar) {
//				game.ui.mcPetPortrait.visible = true;
//				game.ui.btnTargetPetPortraitClose.visible = true;
//
//				avt.objData.eqp["pe"].sLink = this.objData.eqp["pe"].sLink;
//
//				// petMC.pAV.npcType = "pet";
//				game.ui.mcPetPortrait.pAV = petMC.pAV;
////				game.world.updatePetPortrait(petMC.pAV);
//			}
//		}
    }

    public function unloadPet():void {
        for each (var petMC:PetMC in companions) {
            if (petMC.stage != null) {
                game.world.CHARS.removeChild(petMC);
            }
        }

//        if (petMC != null) {
//            if (petMC.stage != null) {
//                game.world.CHARS.removeChild(petMC);
//            }
//            petMC = null;
//        }
    }

    public function showMC():void {
        if (pMC != null) {
            if (game.world.TRASH.contains(pMC)) {
                game.world.CHARS.addChild(game.world.TRASH.removeChild(pMC));
            } else {
                game.world.CHARS.addChild(pMC);
            }
            showPetMC();
        }
    }

    public function hideMC():void {
        if (pMC != null) {
            if (game.world.CHARS.contains(pMC)) {
                game.world.TRASH.addChild(game.world.CHARS.removeChild(pMC));
            } else {
                game.world.TRASH.addChild(pMC);
            }
            hidePetMC();
        }
    }

    public function showPetMC():void {
        if (companions == null) {
            loadPet();
        } else {
            for each (var pet:PetMC in companions) {
                if (pet.stage == null && pet.getChildByName("defaultmc") == null) {
                    game.world.CHARS.addChild(pet);
                    pet.scale(pMC.mcChar.scaleY);
                    pet.x = (pMC.x - 20);
                    pet.y = (pMC.y + 5);
                }
            }
        }
    }

    public function hidePetMC():void {
        if (companions != null) {
            for each (var pet:PetMC in companions) {
                if (pet.stage != null) {
                    game.world.CHARS.removeChild(pet);
                }
            }
        }
    }

    public function initFactions(_arg_1:Array):void {
        var _local_2:int;
        if (_arg_1 == null) {
            factions = [];
        } else {
            factions = _arg_1;
            _local_2 = 0;
            while (_local_2 < factions.length) {
                initFaction(factions[_local_2]);
                _local_2++;
            }
        }
    }

    public function addFaction(_arg_1:Object):void {
        if (((!(_arg_1 == null)) && (!(factions == null)))) {
            factions.push(_arg_1);
            initFaction(_arg_1);
        }
    }

    public function addRep(_arg_1:int, _arg_2:int, _arg_3:int = 0):void {
        var _local_5:int;
        var _local_6:String;
        var _local_4:* = getFaction(_arg_1);
        if (_local_4 != null) {
            _local_5 = _local_4.iRank;
            _local_4.iRep = (_local_4.iRep + _arg_2);
            initFaction(_local_4);
            if (_local_4.iRank > _local_5) {
                rankUp(_local_4.sName, _local_4.iRank);
            }
            _local_6 = "";
            if (_arg_3 > 0) {
                _local_6 = ((" + " + _arg_3) + "(Bonus)");
            }
            game.chatF.pushMsg("server", ((((("Reputation for " + _local_4.sName) + " increased by ") + (_arg_2 - _arg_3)) + _local_6) + "."), "SERVER", "", 0);
        }
    }

    public function initFaction(_arg_1:*):void {
        _arg_1.iRep = int(_arg_1.iRep);
        _arg_1.iRank = game.getRankFromPoints(_arg_1.iRep);
        _arg_1.iRepToRank = 0;
        if (_arg_1.iRank < game.iRankMax) {
            _arg_1.iRepToRank = (game.arrRanks[_arg_1.iRank] - game.arrRanks[(_arg_1.iRank - 1)]);
        }
        _arg_1.iSpillRep = (_arg_1.iRep - game.arrRanks[(_arg_1.iRank - 1)]);
    }

    public function getRep(_arg_1:Object):int {
        var _local_2:* = getFaction(_arg_1);
        return ((_local_2 == null) ? 0 : _local_2.iRep);
    }

    public function getFaction(_arg_1:Object):Object {
        return ((isNaN(Number(_arg_1))) ? getFactionByName(String(_arg_1)) : getFactionByID(int(_arg_1)));
    }

    private function getFactionByID(_arg_1:int):Object {
        var _local_2:int;
        while (_local_2 < factions.length) {
            if (factions[_local_2].FactionID == _arg_1) {
                return (factions[_local_2]);
            }
            _local_2++;
        }
        return null;
    }

    private function getFactionByName(name:String):Object {
        var i:int = 0;
        while (i < factions.length) {
            if (factions[i].sName == name) {
                return (factions[i]);
            }
            i++;
        }
        return null;
    }

    public function initFriendsList(_arg_1:Array):void {
        if (_arg_1 != null) {
            trace("FRIENDS LISTS => " + JSON.stringify(_arg_1));
            friends = _arg_1;
        }
    }

    public function addFriend(_arg_1:Object):void {
        if (_arg_1 != null) {
            friends.push(_arg_1);
            if (game.ui.mcOFrame.currentLabel == "Idle") {
                game.ui.mcOFrame.update();
            }
        }
    }

    public function updateFriend(_arg_1:Object):void {
        var _local_2:int;
        if (_arg_1 != null) {
            _local_2 = 0;
            while (_local_2 < friends.length) {
                if (friends[_local_2].ID == _arg_1.ID) {
                    friends[_local_2] = _arg_1;
                    break;
                }
                _local_2++;
            }
            if (game.ui.mcOFrame.currentLabel == "Idle") {
                game.ui.mcOFrame.update();
            }
        }
    }

    public function deleteFriend(_arg_1:int):void {
        var _local_2:int;
        while (_local_2 < friends.length) {
            if (friends[_local_2].ID == _arg_1) {
                friends.splice(_local_2, 1);
                break;
            }
            _local_2++;
        }
        if (game.ui.mcOFrame.currentLabel == "Idle") {
            game.ui.mcOFrame.update();
        }
    }

    public function isFriend(_arg_1:int):Boolean {
        var _local_2:* = 0;
        while (_local_2 < friends.length) {
            if (friends[_local_2].ID == _arg_1) {
                return true;
            }
            _local_2++;
        }
        return false;
    }

    public function isFriendName(_arg_1:String):Boolean {
        var _local_2:* = 0;
        while (_local_2 < friends.length) {
            if (friends[_local_2].sName.toLowerCase() == _arg_1.toLowerCase()) {
                return true;
            }
            _local_2++;
        }
        return false;
    }

    public function initGuild(_arg_1:Object):void {
        guild = _arg_1;
        if (_arg_1 != null) {
            pMC.pname.tg.text = (("< " + String(_arg_1.Name)) + " >");
            game.chatF.chn.guild.act = 1;
            objData.guild = _arg_1;
        }
    }

    public function updateGuild(_arg_1:Object):void {
        objData.guild = _arg_1;
        if (objData.guild != null) {
            pMC.pname.tg.text = (("< " + String(objData.guild.Name)) + " >");
        } else {
            pMC.pname.tg.text = "";
        }
    }

    public function initInventory(_arg_1:Array):void {
        var _local_2:*;
        if (_arg_1 == null) {
            items = [];
        } else {
            items = _arg_1;
            _local_2 = 0;
            while (_local_2 < items.length) {
                items[_local_2].iQty = int(items[_local_2].iQty);
                game.world.invTree[items[_local_2].ItemID] = items[_local_2];
                _local_2++;
            }
        }
    }

    public function cleanInventory():void {
        var _local_2:*;
        var _local_1:* = 0;
        while (_local_1 < items.length) {
            _local_2 = items[_local_1];
            if (_local_2.iQty == null) {
                _local_2.iQty = 1;
            }
            _local_1++;
        }
    }

    public function initBank(_arg_1:Array):void {
        var _local_2:int;
        if (_arg_1 == null) {
            bank = [];
        } else {
            bank = _arg_1;
            _local_2 = 0;
            while (_local_2 < bank.length) {
                if (bank[_local_2].bGold == 0) {
                    iBankCount++;
                }
                bank[_local_2].iQty = int(bank[_local_2].iQty);
                _local_2++;
            }
        }
    }

    public function tradeFromInv(_arg_1:int, _arg_2:int, _arg_3:int):void
    {
        var _local_4:int;
        var _local_5:int;
        var _local_6:Object;
        var _local_7:*;
        var _local_8:int;
        while (_local_4 < items.length)
        {
            if (items[_local_4].ItemID == _arg_1)
            {
                _local_6 = game.copyObj(items[_local_4]);
                _local_7 = game.copyObj(items.splice(_local_4, 1));
                while (_local_8 < _local_7.length)
                {
                    if (_local_7[_local_8].ItemID == _arg_1)
                    {
                        _local_7[_local_8].iQty = _arg_3;
                        trace((" Quantity Set: " + _arg_3));
                    }
                    _local_8++;
                }
                game.world.tradeController.addItemsToTradeA(_local_7);
                _local_6.iQty = (_local_6.iQty - _arg_3);
                if (_local_6.iQty > 0)
                {
                    trace(("Quantity item: " + _local_6.iQty));
                    game.world.invTree[_arg_1].iQty = _local_6.iQty;
                    items.push(game.world.invTree[_arg_1]);
                }
                else
                {
                    game.world.invTree[_arg_1].iQty = 0;
                }
                return;
            }
            _local_4++;
        }
    }

    public function tradeToInvA(_arg_1:int):void
    {
        var _local_2:*;
        var _local_3:int;
        var _local_4:*;
        var _local_5:int;
        while (_local_3 < game.world.tradeController.tradeinfo.itemsA.length)
        {
            if (game.world.tradeController.tradeinfo.itemsA[_local_3].ItemID == _arg_1)
            {
                _local_2 = game.world.tradeController.tradeinfo.itemsA[_local_3];
                _local_4 = game.world.tradeController.tradeinfo.itemsA.splice(_local_3, 1)[0];
                if (isItemInInventory(_arg_1))
                {
                    trace("Found");
                    _local_2.iQty = (_local_2.iQty + game.world.invTree[_arg_1].iQty);
                    while (_local_5 < items.length)
                    {
                        if (items[_local_5].ItemID == _arg_1)
                        {
                            items[_local_5].iQty = _local_2.iQty;
                            trace("Updated existing");
                            break;
                        }
                        _local_5++;
                    }
                }
                else
                {
                    items.push(_local_4);
                }
                game.world.invTree[_arg_1] = _local_2;
                return;
            }
            _local_3++;
        }
    }

    public function tradeToInvB(_arg_1:int):void
    {
        var _local_2:int;
        while (_local_2 < game.world.tradeController.tradeinfo.itemsB.length)
        {
            if (game.world.tradeController.tradeinfo.itemsB[_local_2].ItemID == _arg_1)
            {
                game.world.tradeController.tradeinfo.itemsB.splice(_local_2, 1)[0];
                return;
            }
            _local_2++;
        }
    }

    public function tradeSwapInv(_arg_1:int, _arg_2:int):void
    {
        var _local_3:Object;
        var _local_4:Object;
        var _local_5:int;
        _local_5 = 0;
        while (_local_5 < items.length)
        {
            if (items[_local_5].ItemID == _arg_1)
            {
                _local_4 = items.splice(_local_5, 1)[0];
                break;
            }
            _local_5++;
        }
        _local_5 = 0;
        while (_local_5 < game.world.tradeController.tradeinfo.itemsA.length)
        {
            if (game.world.tradeController.tradeinfo.itemsA[_local_5].ItemID == _arg_2)
            {
                _local_3 = game.world.tradeController.tradeinfo.itemsA.splice(_local_5, 1)[0];
                break;
            }
            _local_5++;
        }
        if (((!(_local_3 == null)) && (!(_local_4 == null))))
        {
            game.world.tradeController.tradeinfo.itemsA.push(game.copyObj(_local_4));
            game.world.invTree[_arg_1].iQty = 0;
            items.push(_local_3);
            game.world.invTree[_arg_2] = _local_3;
        }
    }

    public function tradeToInvReset():void
    {
        var _local_1:*;
        var _local_2:int;
        var _local_3:*;
        var _local_4:int;
        while (_local_2 < game.world.tradeController.tradeinfo.itemsA.length)
        {
            _local_1 = game.world.tradeController.tradeinfo.itemsA[_local_2];
            trace(("Offer Item: " + _local_1.ItemID));
            if (isItemInInventory(_local_1.ItemID))
            {
                trace("Found");
                _local_1.iQty = (_local_1.iQty + game.world.invTree[_local_1.ItemID].iQty);
                while (_local_4 < items.length)
                {
                    if (items[_local_4].ItemID == _local_1.ItemID)
                    {
                        items[_local_4].iQty = _local_1.iQty;
                        trace(("Updated existing: " + _local_1.ItemID));
                        break;
                    }
                    _local_4++;
                }
            }
            else
            {
                trace(("Adding back item: " + _local_1.ItemID));
                items.push(_local_1);
            }
            game.world.invTree[_local_1.ItemID] = _local_1;
            _local_2++;
        }
    }

    public function bankFromInv(ItemID:int):void {
        var i:int;
        i = 0;
        while (i < items.length) {
            if (items[i].ItemID == ItemID) {
                if (items[i].bGold == 0) {
                    iBankCount++;
                }
                game.world.addItemsToBank(game.copyObj(items.splice(i, 1)));
                game.world.invTree[ItemID].iQty = 0;
                removeFromFiltered(ItemID);
                return;
            }
            i++;
        }
        i = 0;
        while (i < houseitems.length) {
            if (houseitems[i].ItemID == ItemID) {
                if (houseitems[i].bGold == 0) {
                    iBankCount++;
                }
                game.world.addItemsToBank(game.copyObj(houseitems.splice(i, 1)));
                game.world.invTree[ItemID].iQty = 0;
                removeFromFiltered(ItemID);
                return;
            }
            i++;
        }
    }

    public function bankToInv(_arg_1:int):void {
        var _local_2:Object = game.world.bankinfo.bankToInv(_arg_1);
        if (_local_2 == null) {
            return;
        }
        items.push(_local_2);
        game.world.invTree[_arg_1] = _local_2;
    }

    public function bankSwapInv(_arg_1:int, _arg_2:int):void {
        var _local_3:Object;
        var _local_4:Object;
        var _local_5:int;
        _local_5 = 0;
        while (_local_5 < items.length) {
            if (items[_local_5].ItemID == _arg_1) {
                _local_4 = items.splice(_local_5, 1)[0];
                break;
            }
            _local_5++;
        }
        _local_3 = game.world.bankinfo.bankToInv(_arg_2);
        if (((!(_local_3 == null)) && (!(_local_4 == null)))) {
            game.world.bankinfo.addItem(game.copyObj(_local_4));
            if (_local_4.bGold == 0) {
                iBankCount++;
            }
            game.world.invTree[_arg_1].iQty = 0;
            items.push(_local_3);
            if (_local_3.bGold == 0) {
                iBankCount--;
            }
            game.world.invTree[_arg_2] = _local_3;
            MovieClip(game.ui.mcPopup.getChildByName("mcBank")).update({"eventType": "refreshBank"});
        }
    }

    public function removeItem(CharItemID:int, iQty:int = 1):void {
        var item:Object = {};
        var i:int = 0;
        while (i < items.length) {
            item = items[i];
            if (item.CharItemID == CharItemID) {
                if (((item.sES == "ar") || ((item.iQty - iQty) < 1))) {
                    item.iQty = 0;
                    game.resetInvTreeByItemID(item.ItemID);
                    removeFromFiltered(item.ItemID);
                    items.splice(i, 1);
                } else {
                    item.iQty = (item.iQty - iQty);
                }
                return;
            }
            i++;
        }

        var j:int = 0;
        while (j < houseitems.length) {
            if (houseitems[j].CharItemID == CharItemID) {
                if (houseitems[j].iQty > 1) {
                    houseitems[j].iQty--;
                } else {
                    houseitems[j].iQty = 0;
                    houseitems.splice(j, 1);
                    removeFromFiltered(item.ItemID);
                }
                return;
            }
            j++;
        }
    }

    public function removeItemByID(ItemID:int, iQty:int = 1):void {
        var i:int = 0;
        while (i < items.length) {
            if (items[i].ItemID == ItemID) {
                if (((items[i].sES == "ar") || (items[i].iQty <= iQty))) {
                    items[i].iQty = 0;
                    items.splice(i, 1);
                } else {
                    items[i].iQty = (items[i].iQty - iQty);
                }
                return;
            }
            i++;
        }

        i = 0;

        while (i < houseitems.length) {
            if (houseitems[i].ItemID == ItemID) {
                if (houseitems[i].iQty <= iQty) {
                    houseitems[i].iQty = 0;
                    houseitems.splice(i, 1);
                } else {
                    houseitems[i].iQty = houseitems[i].iQty - iQty;
                }
                return;
            }
            i++;
        }
    }

    public function removeFromFiltered(ItemID:int):void {
        if (!filtered_list) {
            return;
        }
        if (((filtered_list) && (filtered_list.length < 1))) {
            return;
        }
        var i:int = 0;
        while (i < filtered_list.length) {
            if (filtered_list[i].ItemID == ItemID) {
                filtered_list.splice(i, 1);
                break;
            }
            i++;
        }
    }

    public function get filtered_inventory():Array {
        return filtered_list && filtered_list.length > 0 ? filtered_list : game.ui.mcPopup.currentLabel == "HouseInventory" || game.ui.mcPopup.currentLabel == "HouseBank" ? houseitems : items;
    }

    public function addItem(_arg_1:Object):void {
        var _local_2:Array;
        if (Boolean(_arg_1.bBank)) {
            addToBank(_arg_1);
            return;
        }
        _local_2 = ((_arg_1.bHouse == 1) ? houseitems : items);
        var _local_3:int;
        while (_local_3 < _local_2.length) {
            if (_local_2[_local_3].ItemID == _arg_1.ItemID) {
                _local_2[_local_3].iQty = (_local_2[_local_3].iQty + int(_arg_1.iQty));
                return;
            }
            _local_3++;
        }
        _arg_1.iQty = int(_arg_1.iQty);
        game.world.invTree[_arg_1.ItemID] = _arg_1;
        _local_2.push(_arg_1);
    }

    public function addToBank(_arg_1:*):void {
        if (((bank == null) || (bank.length == 0))) {
            return;
        }
        var _local_2:int;
        while (_local_2 < bank.length) {
            if (bank[_local_2].ItemID == _arg_1.ItemID) {
                bank[_local_2].iQty = (bank[_local_2].iQty + int(_arg_1.iQty));
                return;
            }
            _local_2++;
        }
    }

    public function varVal(_arg_1:String):* {
        var _local_2:* = MovieClip(pMC.mcChar.stage.getChildAt(0));
        var _local_3:* = _local_2.world;
        return (_local_2.sfc.getRoom(_local_3.curRoom).getUser(uid).getVariable(_arg_1));
    }

    public function getItemByID(_arg_1:int):Object {
        var _local_2:int;
        while (_local_2 < items.length) {
            if (items[_local_2].ItemID == _arg_1) {
                return (items[_local_2]);
            }
            _local_2++;
        }
        var _local_3:int;
        while (_local_3 < houseitems.length) {
            if (houseitems[_local_3].ItemID == _arg_1) {
                return (houseitems[_local_3]);
            }
            _local_3++;
        }
        var _local_4:int;
        while (_local_4 < tempitems.length) {
            if (tempitems[_local_4].ItemID == _arg_1) {
                return (tempitems[_local_4]);
            }
            _local_4++;
        }
        return null;
    }

    public function getItemIDByName(_arg_1:String):int {
        var _local_2:int;
        while (_local_2 < items.length) {
            if (items[_local_2].sName == _arg_1) {
                return (items[_local_2].ItemID);
            }
            _local_2++;
        }
        var _local_3:int;
        while (_local_3 < houseitems.length) {
            if (houseitems[_local_3].sName == _arg_1) {
                return (houseitems[_local_3].ItemID);
            }
            _local_3++;
        }
        var _local_4:int;
        while (_local_4 < tempitems.length) {
            if (tempitems[_local_4].sName == _arg_1) {
                return (tempitems[_local_4].ItemID);
            }
            _local_4++;
        }
        return (-1);
    }

    public function isItemInBank(_arg_1:Number):Boolean {
        var _local_2:int;
        if (bank != null) {
            _local_2 = 0;
            while (_local_2 < bank.length) {
                if (bank[_local_2].ItemID == _arg_1) {
                    return true;
                }
                _local_2++;
            }
        }
        return false;
    }

    public function isItemInInventory(_arg_1:Object):Boolean {
        var _local_3:int;
        var _local_4:int;
        var _local_2:int = ((isNaN(Number(_arg_1))) ? getItemIDByName(String(_arg_1)) : int(_arg_1));
        if (_local_2 > 0) {
            _local_3 = 0;
            while (_local_3 < items.length) {
                if (items[_local_3].ItemID == _local_2) {
                    return true;
                }
                _local_3++;
            }
            _local_4 = 0;
            while (_local_4 < houseitems.length) {
                if (houseitems[_local_4].ItemID == _local_2) {
                    return true;
                }
                _local_4++;
            }
        }
        return false;
    }

    public function isItemStackMaxed(_arg_1:Number):Boolean {
        var _local_2:int;
        if (bank != null) {
            _local_2 = 0;
            while (_local_2 < bank.length) {
                if (((bank[_local_2].ItemID == _arg_1) && (bank[_local_2].iQty >= bank[_local_2].iStk))) {
                    return true;
                }
                _local_2++;
            }
        }
        if (items != null) {
            _local_2 = 0;
            while (_local_2 < items.length) {
                if (((items[_local_2].ItemID == _arg_1) && (items[_local_2].iQty >= items[_local_2].iStk))) {
                    return true;
                }
                _local_2++;
            }
        }
        if (houseitems != null) {
            _local_2 = 0;
            while (_local_2 < houseitems.length) {
                if (((houseitems[_local_2].ItemID == _arg_1) && (houseitems[_local_2].iQty >= houseitems[_local_2].iStk))) {
                    return true;
                }
                _local_2++;
            }
        }
        return false;
    }

    public function addTempItem(_arg_1:Object):void {
        var _local_2:int;
        while (_local_2 < tempitems.length) {
            if (tempitems[_local_2].ItemID == _arg_1.ItemID) {
                tempitems[_local_2].iQty = (tempitems[_local_2].iQty + int(_arg_1.iQty));
                return;
            }
            _local_2++;
        }
        tempitems.push(_arg_1);
        game.world.invTree[_arg_1.ItemID] = _arg_1;
    }

    public function removeTempItem(_arg_1:int, _arg_2:int):void {
        var _local_3:int;
        while (_local_3 < tempitems.length) {
            if (tempitems[_local_3].ItemID == _arg_1) {
                if (tempitems[_local_3].iQty > _arg_2) {
                    tempitems[_local_3].iQty = (tempitems[_local_3].iQty - _arg_2);
                } else {
                    tempitems[_local_3].iQty = 0;
                    tempitems.splice(_local_3, 1);
                }
                return;
            }
            _local_3++;
        }
    }

    public function checkTempItem(_arg_1:int, _arg_2:int):Boolean {
        var _local_3:int;
        while (_local_3 < tempitems.length) {
            if (((tempitems[_local_3].ItemID == _arg_1) && (tempitems[_local_3].iQty >= _arg_2))) {
                return true;
            }
            _local_3++;
        }
        return false;
    }

    public function getTempItemQty(_arg_1:int):int {
        var _local_2:int;
        while (_local_2 < tempitems.length) {
            if (tempitems[_local_2].ItemID == _arg_1) {
                return (tempitems[_local_2].iQty);
            }
            _local_2++;
        }
        return (-1);
    }

    public function unequipItemAtES(_arg_1:String):void {
        var _local_2:int;
        _local_2 = 0;
        while (_local_2 < items.length) {
            if (items[_local_2].sES == _arg_1) {
                items[_local_2].bEquip = 0;
                removeItemAnimation(items[_local_2].sMeta);
            }
            _local_2++;
        }
        _local_2 = 0;
        while (_local_2 < tempitems.length) {
            if (tempitems[_local_2].sES == _arg_1) {
                tempitems[_local_2].bEquip = 0;
            }
            _local_2++;
        }
    }

    public function equipItem(_arg_1:int):void {
        var _local_2:int;
        game.world.afkPostpone();
        if (((!(items == null)) && (items.length > 0))) {
            _local_2 = 0;
            while (_local_2 < items.length) {
                if (items[_local_2].ItemID == _arg_1) {
                    unequipItemAtES(items[_local_2].sES);
                    items[_local_2].bEquip = 1;
                    updateItemAnimation(items[_local_2].sMeta);
                    return;
                }
                _local_2++;
            }
        }
        if (((!(tempitems == null)) && (tempitems.length > 0))) {
            _local_2 = 0;
            while (_local_2 < tempitems.length) {
                if (tempitems[_local_2].ItemID == _arg_1) {
                    unequipItemAtES(tempitems[_local_2].sES);
                    tempitems[_local_2].bEquip = 1;
                    return;
                }
                _local_2++;
            }
        }
    }

    public function unequipItem(_arg_1:int):void {
        var _local_2:int;
        if (((!(items == null)) && (items.length > 0))) {
            _local_2 = 0;
            while (_local_2 < items.length) {
                if (items[_local_2].ItemID == _arg_1) {
                    items[_local_2].bEquip = 0;
                    removeItemAnimation(items[_local_2].sMeta);
                    return;
                }
                _local_2++;
            }
        }
        if (((!(tempitems == null)) && (tempitems.length > 0))) {
            _local_2 = 0;
            while (_local_2 < tempitems.length) {
                if (tempitems[_local_2].ItemID == _arg_1) {
                    tempitems[_local_2].bEquip = 0;
                    return;
                }
                _local_2++;
            }
        }
    }

    public function checkItemAnimation():void {
        var _local_1:uint;
        while (_local_1 < items.length) {
            if (items[_local_1].bEquip == 1) {
                updateItemAnimation(items[_local_1].sMeta);
            }
            _local_1++;
        }
    }

    private function updateItemAnimation(_arg_1:String):void {
        var _local_5:Array;
        if (_arg_1 == null) {
            return;
        }
        if (((_arg_1.indexOf("anim") < 0) && (_arg_1.indexOf("proj") < 0))) {
            return;
        }
        var _local_2:* = "";
        var _local_3:Number = -1;
        var _local_4:Array = _arg_1.split(",");
        var _local_6:uint;
        while (_local_6 < _local_4.length) {
            _local_5 = _local_4[_local_6].split(":");
            if (_local_5[0] == "anim") {
                _local_2 = _local_5[1];
            } else {
                if (_local_5[0] == "chance") {
                    _local_3 = Number(_local_5[1]);
                }
                if (_local_5[0] == "proj") {
                    strProj = _local_5[1];
                }
            }
            _local_6++;
        }
        if (((!(_local_2 == "")) && (_local_3 > 0))) {
            specialAnimation[_local_2] = _local_3;
        }
    }

    private function removeItemAnimation(_arg_1:String):* {
        var _local_2:String;
        if (_arg_1 == null) {
            return;
        }
        if (_arg_1.indexOf("proj") > -1) {
            strProj = "";
        }
        for (_local_2 in specialAnimation) {
            if (_arg_1.indexOf(_local_2) > -1) {
                delete specialAnimation[_local_2];
                return;
            }
        }
    }

    public function isItemEquipped(_arg_1:int):Boolean {
        var _local_2:* = getItemByID(_arg_1);
        if ((((_local_2 == null) || (_local_2.bEquip == null)) || (_local_2.bEquip == 0))) {
            return false;
        }
        return true;
    }

    public function getClassArmor(_arg_1:String):Object {
        var _local_2:int;
        while (_local_2 < items.length) {
            if (((items[_local_2].sName == _arg_1) && (items[_local_2].sES == "ar"))) {
                return (items[_local_2]);
            }
            _local_2++;
        }
        return null;
    }

    public function getEquippedItemBySlot(_arg_1:String):Object {
        var _local_2:int;
        while (_local_2 < items.length) {
            if (((items[_local_2].bEquip == 1) && (items[_local_2].sES == _arg_1))) {
                return (items[_local_2]);
            }
            _local_2++;
        }
        return null;
    }

    public function getItemByEquipSlot(_arg_1:String):Object {
        if ((((!(objData == null)) && (!(objData.eqp == null))) && (!(objData.eqp[_arg_1] == null)))) {
            return (objData.eqp[_arg_1]);
        }
        return null;
    }

    public function updateArmorRep():void {
        var _local_1:* = getClassArmor(objData.strClassName);
        _local_1.iQty = Number(objData.iCP);
    }

    public function getArmorRep(_arg_1:String = ""):int {
        if (_arg_1 == "") {
            _arg_1 = objData.strClassName;
        }
        var _local_2:* = getClassArmor(_arg_1);
        if (_local_2 != null) {
            return (_local_2.iQty);
        }
        return (0);
    }

    public function getCPByID(_arg_1:int):int {
        var _local_2:* = getItemByID(_arg_1);
        if (_local_2 != null) {
            return (_local_2.iQty);
        }
        return (-1);
    }

    public function updateRep():void {
        var _local_1:* = objData.iRank;
        var _local_2:* = objData.iCP;
        var _local_3:int = game.getRankFromPoints(_local_2);
        var _local_4:int;
        var _local_5:* = game.world;
        if (_local_3 < game.iRankMax) {
            _local_4 = (game.arrRanks[_local_3] - game.arrRanks[(_local_3 - 1)]);
        }
        objData.iCurCP = (_local_2 - game.arrRanks[(_local_3 - 1)]);
        objData.iRank = _local_3;
        objData.iCPToRank = _local_4;
        if (((isMyAvatar) && (!(_local_1 == _local_3)))) {
            _local_5.updatePortrait(this);
        }
    }

    public function levelUp():void {
        healAnimation();
        var _local_1:* = pMC.addChild(new LevelUpDisplay());
        _local_1.t.ti.text = objData.intLevel;
        _local_1.x = pMC.mcChar.x;
        _local_1.y = (pMC.pname.y + 10);
    }

    public function rankUp(_arg_1:String, _arg_2:int):void {
        healAnimation();
        var _local_3:* = pMC.addChild(new RankUpDisplay());
        _local_3.t.ti.text = ((_arg_1 + ", Rank ") + _arg_2);
        _local_3.x = pMC.mcChar.x;
        _local_3.y = (pMC.pname.y + 10);
    }

    public function healAnimation(isPet:Boolean = false):void {
        game.mixer.playSound("Heal");

        var mc:*;

        if (isPet)
        {
            for each (var petMC:PetMC in companions)
            {
                mc = petMC.parent.addChild(new sp_eh1());
                mc.x = petMC.x;
                mc.y = petMC.y;
            }
        }
        else
        {
            mc = pMC.parent.addChild(new sp_eh1());
            mc.x = pMC.x;
            mc.y = pMC.y;
        }
    }

    public function isUpgraded():Boolean {
        return (int(objData.iUpgDays) >= 0);
    }

    public function hasUpgraded():Boolean {
        return (int(objData.iUpg) > 0);
    }

    public function isVerified():Boolean {
        return (((objData.intAQ > 0) || (objData.intDF > 0)) || (objData.intMQ > 0));
    }

    public function isStaff():Boolean {
        if (objData == null || !objData.hasOwnProperty("intAccessLevel")) return false;
        return (objData.intAccessLevel >= 40);
    }

    public function isEmailVerified():Boolean {
        return (objData.intActivationFlag == 5);
    }

    public function updatePending(_arg_1:int):void {
        var _local_5:String;
        var _local_6:uint;
        if (objData.pending == null) {
            _local_5 = "";
            _local_6 = 0;
            while (_local_6 < 500) {
                _local_5 = (_local_5 + String.fromCharCode(0));
                _local_6++;
            }
            objData.pending = _local_5;
        }
        var _local_2:int = Math.floor((_arg_1 >> 3));
        var _local_3:int = (_arg_1 % 8);
        var _local_4:int = objData.pending.charCodeAt(_local_2);
        _local_4 = (_local_4 | (1 << _local_3));
        objData.pending = ((objData.pending.substr(0, _local_2) + String.fromCharCode(_local_4)) + objData.pending.substr((_local_2 + 1)));
    }

    public function updateScrolls(_arg_1:int):void {
        var _local_5:String;
        var _local_6:uint;
        if (objData.scrolls == null) {
            _local_5 = "";
            _local_6 = 0;
            while (_local_6 < 500) {
                _local_5 = (_local_5 + String.fromCharCode(0));
                _local_6++;
            }
            objData.scrolls = _local_5;
        }
        var _local_2:int = Math.floor((_arg_1 >> 3));
        var _local_3:int = (_arg_1 % 8);
        var _local_4:int = objData.scrolls.charCodeAt(_local_2);
        _local_4 = (_local_4 | (1 << _local_3));
        objData.scrolls = ((objData.scrolls.substr(0, _local_2) + String.fromCharCode(_local_4)) + objData.scrolls.substr((_local_2 + 1)));
    }

    public function handleItemAnimation():void {
        var _local_2:String;
        var _local_3:Class;
        var _local_4:MovieClip;
        var _local_1:Number = (Math.random() * 100);
        for (_local_2 in specialAnimation) {
            if (_local_1 < specialAnimation[_local_2]) {
                _local_3 = (game.world.getClass(_local_2) as Class);
                if (_local_3 != null) {
                    _local_4 = (new (_local_3)() as MovieClip);
                    _local_4.x = pMC.x;
                    _local_4.y = pMC.y;
                    if (pMC.mcChar.scaleX < 0) {
                        _local_4.scaleX = (_local_4.scaleX * -1);
                    }
                    game.world.CHARS.addChild(_local_4);
                }
                return;
            }
        }
    }

    public function IsOwned(isHouse:Boolean, ItemID:int):Boolean
    {
        for each (var item:Object in ((isHouse) ? houseitems : items))
        {
            if (item.ItemID == ItemID)
            {
                return true;
            }
        }

        return game.world.bankinfo.isItemInBank(ItemID);
    }

    public function initCompanions(data:Object) : void {
        objData.companions = data;
        loadPet();
    }

    public function get FirstLoad():Boolean {
        return (firstLoad);
    }

    public function get LoadCount():int {
        return (loadCount);
    }

    public function updateLoaded():void {
        loadCount--;
    }

    public function firstDone():void {
        firstLoad = false;
    }

    public function get iBankCount():int {
        return (game.world.bankinfo.Count);
    }

    public function set iBankCount(_arg_1:int):void {
        game.world.bankinfo.Count = _arg_1;
    }


}
}//package 

