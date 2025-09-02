package game.outfit {

import fl.motion.Color;

import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.Shape;
import flash.display.SimpleButton;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;
import flash.text.TextField;
import flash.utils.getDefinitionByName;

import game.character.Boosts;

import game.character.CharSelectListItem;
import game.utils.Queue;
import game.controller.OutfitController;

import org.sepy.ColorPicker.ColorPicker2;

public class Outfits extends MovieClip {

    private var game:Game = Game.root;

    public var bg:MovieClip;

    public var btnAddOrUpdate:SimpleButton;

    public var txtAddOrUpdate:TextField;

    public var cpSkin:MovieClip;
    public var cpBase:MovieClip;
    public var cpAccessory:MovieClip;
    public var cpHair:MovieClip;
    public var cpEye:MovieClip;
    public var cpTrim:MovieClip;

    private var _currentId:int = -1;

    private var _lists:MovieClip = new MovieClip();
    private var _listMask:MovieClip = new MovieClip();

    private var _characters:MovieClip = new MovieClip();

    private var _currentSelected:CharSelectListItem;
    private var _previousSelected:CharSelectListItem;

    public var loaderD:ApplicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
    public var loaderC:LoaderContext = new LoaderContext(false, loaderD);

//    private var _tempData:Object = [
//                {
//                    "Name": "Outfit 1",
//                    "intColorSkin": "15388042",
//                    "intColorHair": "6180663",
//                    "intColorBase": "0",
//                    "intColorEye": "91294",
//                    "intColorTrim": "0",
//                    "intColorAccessory": "0",
//                    "eqp": "Weapon:5,ar:2"
//                },
//                {
//                    "Name": "Outfit 2",
//                    "intColorSkin": "15388042",
//                    "intColorHair": "6180663",
//                    "intColorBase": "0",
//                    "intColorEye": "91294",
//                    "intColorTrim": "0",
//                    "intColorAccessory": "0",
//                    "eqp": "Weapon:1,ar:2"
//                }
//            ]
//    ;

    public function Outfits() {
        _listMask.graphics.beginFill(52479);
        _listMask.graphics.drawRect(0, 0, bg.width, bg.height);
        _listMask.graphics.endFill();
        _listMask.x = bg.x;
        _listMask.y = bg.y;
        _lists.mask = _listMask;
        addChild(_listMask);

        _lists.x = 10;
        _lists.y = 10;
        addChild(_lists);

        _characters.x = 600;
        _characters.y = 300;
        addChild(_characters);

        btnAddOrUpdate.visible = false;
        txtAddOrUpdate.visible = false;

        cpSkin.visible = false;
        cpBase.visible = false;
        cpAccessory.visible = false;
        cpHair.visible = false;
        cpEye.visible = false;
        cpTrim.visible = false;

        txtAddOrUpdate.mouseEnabled = false;

        initLists();
    }

    private function initLists():void {
        game.onRemoveChildren(_lists);

        for (var i:int = 0; i < 6; i++) {
            var item:CharSelectListItem = new CharSelectListItem();
            item.tNewChar.visible = true;
            item.tName.visible = false;
            item.tInfo.visible = false;
            item.buttonMode = true;

            if (game.world.myAvatar.objData.outfits[i] != null) {
                item.tNewChar.text = game.world.myAvatar.objData.outfits[i].Name;
                item.tNewChar.x -= 35;
                item.btnEdit.visible = true;
                item.y = _lists.numChildren * 50;
                item.name = "o-" + _lists.numChildren;

                item.addEventListener(MouseEvent.CLICK, function (event:MouseEvent):void {
                    var currentItem:CharSelectListItem = CharSelectListItem(event.currentTarget);
                    var id:int = parseInt(currentItem.name.slice(2));

                    if (_currentId == id) return;

                    OutfitController.isNew = _currentId != id;
                    OutfitController.id = id;

                    if (!game.world.myAvatar.objData.outfits[id].hasOwnProperty("isClicked"))
                    {
                        var copyObj:Object = game.copyObj(game.world.myAvatar.objData.outfits[id].eqp);

                        game.world.myAvatar.objData.outfits[id].strGender = String(game.world.myAvatar.objData.strGender);
                        game.world.myAvatar.objData.outfits[id].strHairFilename = String(game.world.myAvatar.objData.strHairFilename);
                        game.world.myAvatar.objData.outfits[id].strHairName = String(game.world.myAvatar.objData.strHairName);
                        game.world.myAvatar.objData.outfits[id].isClicked = true;
                        game.world.myAvatar.objData.outfits[id].eqp = {};

                        for each (var key:Object in String(copyObj).split(","))
                        {
                            var parts:Array = String(key).split(":");
                            var equipment:String = parts[0];
                            var itemId:int = parseInt(parts[1]);
                            var item:Object = game.copyObj(game.world.invTree[itemId]);

                            if (item == null) continue;

                            var itemObj:Object = {
                                ItemID: itemId,
                                sFile: String(item.sFile),
                                sLink: String(item.sLink)
                            };

                            if (equipment.toLowerCase() == "weapon") itemObj["sType"] = String(item.sType);

                            game.world.myAvatar.objData.outfits[id].eqp[equipment] = itemObj;
                        }
                    }

                    if (_previousSelected != null) _previousSelected.highlighter.visible = false;

                    _currentId = id;
                    _currentSelected = currentItem;
                    _currentSelected.highlighter.visible = true;
                    _currentSelected.highlighter.alpha = 1;
                    _previousSelected = _currentSelected;

                    initColors();
                    setAvatar(game.world.myAvatar.objData.outfits[id]);
                });

                item.btnEdit.addEventListener(MouseEvent.CLICK, function (event:MouseEvent):void {
                    _currentSelected.tNewChar.mouseEnabled = true;

                    txtAddOrUpdate.text = "Update";
                    btnAddOrUpdate.visible = true;
                    txtAddOrUpdate.visible = true;

                    stage.focus = _currentSelected.tNewChar;

                    game.ui.mcPopup.fOpen("OutfitInventory");
                })

                item.btnDelete.addEventListener(MouseEvent.CLICK, function (event:MouseEvent):void {
                    game.Modal("Are you sure want to delete?", function (o:Object):void {
                        if (o.accept) {
                            game.chatF.pushMsg("event", "DELETE SUCCESSFULLY", "SERVER", "", 0);
//                            var id:int = parseInt(currentItem.name.slice(2));
//                            trace("DELETE OUTFIT => " + id);
//                            delete _tempData[id];
//                            initLists();
                        }
                    }, {}, "white,medium", "dual", false)
                })
            } else {
                item.tNewChar.text = "New Outfit";
                item.slot.visible = true;
                item.btnDelete.visible = false;
                item.y = _lists.numChildren * 50;

                item.addEventListener(MouseEvent.CLICK, function (event:MouseEvent):void {
                    game.Modal("Are you sure you want to save your current equip item?", function (o:Object):void {
                        if (o.accept) {
                            var equipments:String = "";

                            for each (var item:Object in game.world.myAvatar.objData.eqp) equipments += game.world.invTree[item.ItemID].sES + ":" + item.ItemID + ",";

                            equipments = equipments.substring(0, equipments.length - 1);

                            trace(equipments);
                            game.chatF.pushMsg("event", "SUCCESS SAVE OUTFIT", "SERVER", "", 0);
                        }
                    }, {}, "white,medium", "dual")
                })
            }

            item.addEventListener(MouseEvent.MOUSE_OVER, function (event:MouseEvent) : void {
                var currentItem:CharSelectListItem = CharSelectListItem(event.target.parent);
                if (!currentItem.highlighter.visible)
                {
                    currentItem.highlighter.visible = true;
                    currentItem.highlighter.alpha = 0.2;
                }
            })

            item.addEventListener(MouseEvent.MOUSE_OUT, function (event:MouseEvent) : void {
                var currentItem:CharSelectListItem = CharSelectListItem(event.target.parent);
                currentItem.highlighter.visible = false;
                currentItem.highlighter.alpha = 1;
            })

            _lists.addChild(item);
        }
    }

    private function setAvatar(obj:Object):void {
        game.onRemoveChildren(_characters);

        var world:World = new World(game);
        var pAV:Avatar = new Avatar(game);

        pAV.objData = obj;
        world.myAvatar = pAV;
        world.myAvatar.target = null;

        var avatar:AvatarMC = world.loadAvatar(world, pAV, true);
        avatar.pname.visible = false;
        avatar.scale(2.3);

        _characters.addChild(avatar);
    }

    private function initColors() : void {
        var color:Color = new Color();
        color.setTint(game.world.myAvatar.objData.outfits[_currentId].intColorSkin, 1);
        cpSkin.transform.colorTransform = color;
        cpSkin.mouseEnabled = false;
        cpSkin.visible = true;

        color.setTint(game.world.myAvatar.objData.outfits[_currentId].intColorBase, 1);
        cpBase.transform.colorTransform = color;
        cpBase.mouseEnabled = false;
        cpBase.visible = true;

        color.setTint(game.world.myAvatar.objData.outfits[_currentId].intColorAccessory, 1);
        cpAccessory.transform.colorTransform = color;
        cpAccessory.mouseEnabled = false;
        cpAccessory.visible = true;

        color.setTint(game.world.myAvatar.objData.outfits[_currentId].intColorHair, 1);
        cpHair.transform.colorTransform = color;
        cpHair.mouseEnabled = false;
        cpHair.visible = true;

        color.setTint(game.world.myAvatar.objData.outfits[_currentId].intColorEye, 1);
        cpEye.transform.colorTransform = color;
        cpEye.mouseEnabled = false;
        cpEye.visible = true;

        color.setTint(game.world.myAvatar.objData.outfits[_currentId].intColorTrim, 1);
        cpTrim.transform.colorTransform = color;
        cpTrim.mouseEnabled = false;
        cpTrim.visible = true;
    }

}
}
