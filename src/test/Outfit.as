package test {

import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.Event;
import flash.events.MouseEvent;

public class Outfit extends MovieClip {

    private var game:Game = Game.root;
    public var tl1:MovieClip;
    public var tl2:MovieClip;
    public var tl3:MovieClip;
    public var tr1:MovieClip;
    public var tr2:MovieClip;
    public var tr3:MovieClip;
    public var bl1:MovieClip;
    public var br1:MovieClip;
    public var bg:MovieClip;
    public var btnClose:SimpleButton;
    public var pAV:Avatar;
    public var avatar:AvatarMC;
    public var interfaceOutfitSets:outfitsets;
    public var slots:int = 10;
    public var sets:Array = [];
//    public var sets:Array = [
//        {
//            name: "Test 1",
//            colors: {
//                skin: 15388042,
//                base: 0,
//                accessory: 0,
//                hair: 6180663,
//                eye: 91294,
//                trim: 0
//            },
//            he: 13,
//            ba: null,
//            ar: 3,
//            co: null,
//            Weapon: 1,
//            pe: null,
//            mi: null
//        },
//        {
//            name: "Test 2",
//            colors: {
//                skin: 15388042,
//                base: 0,
//                accessory: 0,
//                hair: 6180663,
//                eye: 91294,
//                trim: 0
//            },
//            he: 13,
//            ba: 14,
//            ar: 3,
//            co: 15,
//            Weapon: 12,
//            pe: 7,
//            mi: null
//        }
//    ];

    public function Outfit() {
        addEventListener(Event.ADDED_TO_STAGE, onStage);
    }

    public function onStage(event:Event):void
    {
        removeEventListener(Event.ADDED_TO_STAGE, this.onStage);
        setAvatar();
        initSets();
        initOutfitInterface();
        btnClose.addEventListener(MouseEvent.CLICK, onClose, false, 0, true);
    }

    public function setAvatar(): void
    {
//        pAV = new Avatar(game);
//        pAV.objData = game.copyObj(game.world.myAvatar.objData);
//        avatar = game.world.loadAvatar(game.world, pAV, true, 3);
//        avatar.name = "outfit";
//
//        if (getChildByName("outfit") > 0)
//        {
//            MovieClip(getChildByName("outfit")).removeChildAt(0);
//        }
//
//        pAV.initAvatar({ data: pAV.objData });
//
//        avatar.x = -200;
//        avatar.y = 330;
//
//        addChild(avatar);

        avatar =  new AvatarMC();
        avatar.world = game.world;
        pAV = new Avatar(game);
        pAV.items = game.copyObj(game.world.myAvatar.items);
        pAV.objData = game.copyObj(game.world.myAvatar.objData);
        pAV.dataLeaf = game.copyObj(game.world.myAvatar.dataLeaf);

        pAV.dataLeaf.showHelm = true;
        pAV.dataLeaf.showCloak = true;
        pAV.isMyAvatar = true;
        avatar.pAV = pAV;
        avatar.pAV.pMC = avatar;
        avatar.strGender = game.world.myAvatar.objData.strGender;

        for (var sES:String in pAV.objData.eqp)
        {
            pAV.loadMovieAtES(sES, pAV.objData.eqp[sES].sFile, pAV.objData.eqp[sES].sLink);
        }

        if (pAV.objData.eqp.he == null)
        {
            avatar.loadHair();
        }

        avatar.hideHPBar();
        avatar.shadow.visible = true;
        avatar.pname.visible = false;
        avatar.scale(3);
        avatar.visible = true;
        avatar.name = "outfit";
        avatar.x = -200;
        avatar.y = 330;

        addChild(avatar);
    }

    public function initSets():void
    {
        for (var name:String in game.world.myAvatar.objData.outfits)
        {
            var cloneOutfit:Object = game.copyObj(game.world.myAvatar.objData.outfits[name]);
            cloneOutfit.name = name;
            sets.push(cloneOutfit);
        }
    }

    public function initOutfitInterface():void
    {
        this.interfaceOutfitSets = new outfitsets(this, game);
        this.addChild(this.interfaceOutfitSets);
        this.interfaceOutfitSets.x = 216.7;
        this.interfaceOutfitSets.y = 171.5;
    }

    private function organizeSets():void
    {
        var t:*;
        var s:Object = {};

        for each (t in this.sets)
        {
            s[t.name] = game.copyObj(t);
            delete s[t.name].name;
        }

        game.world.myAvatar.objData.outfits = s;
    }

    public function onClose(event:MouseEvent):void
    {
        organizeSets();
        fClose();
    }

    public function fClose():void
    {
        MovieClip(parent).onClose();
    }

    public function slowDown():void
    {
        game.MsgBox.notify("Slow down! Last action was too fast.");
    }

}

}
