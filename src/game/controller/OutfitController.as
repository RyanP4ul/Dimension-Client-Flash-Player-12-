package game.controller {
import flash.display.MovieClip;

public class OutfitController {

    private static var game:Game = Game.root;
    private static var _data:Array = [];
    private static var _equipments:Array = [];

    public static var id:int = -1;
    public static var isNew:Boolean = false;

    public static function get Data() : Array {
        if (_data.length < 1 && !isNew) return _data;

        _data = [];

        trace("NEW DATA => :>");

        var itemIds:Array = [];
        var item:Object = {};

        for each (item in game.world.myAvatar.objData.outfits[id].eqp) {
            trace("ID => " + item.ItemID + ", NAME => " + item.sName);
            itemIds.push(item.ItemID);
        }

        for (var i:int = 0; i < game.world.myAvatar.items.length; i++) {
            item = game.world.myAvatar.items[i];

            if (["Weapon", "ar", "co", "he", "ba", "pe", "am"].indexOf(item.sES) == -1 || item.EnhID < 1) continue;

            _data[item.ItemID] = game.copyObj(item); // PREVENT THE CHANGES IN INVENTORY

            if (itemIds.indexOf(item.ItemID) != - 1)
            {
                _data[item.ItemID].bEquip = 1;
                _equipments[item.sES] = item.ItemID;
            }
            else
            {
                _data[item.ItemID].bEquip = 0;
            }
        }

        return _data;
    }

    public static function toggleEquipOutfitItem(o:Object):Boolean {
        var isValid:Boolean = false;

        if (game.world.getUoLeafById(game.world.myAvatar.uid).intState != 1) {
            game.MsgBox.notify("Action cannot be performed during combat!");
        } else {
            if (game.world.bPvP) {
                game.MsgBox.notify("Items may not be equipped or unequipped during a PvP match!");
            } else {
                if (o.bEquip == 1) {
                    if (o.sES == "Weapon" || o.sES == "ar") {
                        game.MsgBox.notify("Selected Item cannot be unequipped!");
                    } else {
                        isValid = SendUnEquipOutfit(o);
                    }
                } else {
                    if (o.bUpg == 1 && !game.world.myAvatar.isUpgraded()) {
                        game.showUpgradeWindow();
                    } else {
                        if (int(o.EnhLvl) > int(game.world.myAvatar.objData.intLevel)) {
                            game.MsgBox.notify("Level requirement not met!");
                        } else {
                            if (!(o.sType.toLowerCase() == "item") && ((!(o.sES == "co")) && (!(o.sES == "pe")) && !(o.sES == "am") && !(o.EnhID > 0))) {
                                game.MsgBox.notify("Selected item requires enhancement!");
                            } else {
                                isValid = SendEquipOutfit(o);
                            }
                        }
                    }
                }
            }
        }

        if (isValid)
        {
            if (game.world.myAvatar.isMyAvatar) {
                if (MovieClip(game.ui.mcPopup.getChildByName("mcOutfitInventory")) != null) {
                    MovieClip(game.ui.mcPopup.getChildByName("mcOutfitInventory")).update({"eventType": "refreshItems"});
                }
            }
        }

        return isValid;
    }

    private static function SendEquipOutfit(o:Object):Boolean {
        var isValid:Boolean = true;

        game.world.afkPostpone();

        if (o != null && o.bEquip != 1) {
            if (game.world.coolDown("equipItem")) {
                var item:Object = _equipments[o.sES];

                if (item != null)
                {
                    _data[_equipments[o.sES]].bEquip = 0;
                    o.bEquip = 0;
                    game.world.myAvatar.objData.outfits[id].eqp[o.sES].bEquip = 0;
                }

                _data[o.ItemID].bEquip = 1;
                _equipments[o.sES] = o.ItemID;
                o.bEquip = 1;
                game.world.myAvatar.objData.outfits[id].eqp[o.sES].bEquip = 1;
            }
        } else {
            isValid = false;
            trace("EQUIP OUTFIT => 3");
        }

        return isValid;
    }

    private static function SendUnEquipOutfit(o:Object):Boolean {
        var isValid:Boolean = true;

        if (o != null && o.bEquip == 1) {
            if (game.world.coolDown("unequipItem")) {
                for (var i:int = 0; i < _data.length; i++) {
                    var item:Object = _data[i];

                    if (item == null || item.ItemID != o.ItemID || o.bEquip == 0) continue;

                    o.bEquip = 0;
                    _data[item.ItemID].bEquip = 0;
                    break;
                }
            }
        } else {
            isValid = false;
        }

        return isValid;
    }

}
}
