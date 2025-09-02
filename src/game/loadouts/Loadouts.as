package game.loadouts {
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.FocusEvent;
import flash.events.MouseEvent;
import flash.filters.ColorMatrixFilter;
import flash.geom.ColorTransform;
import flash.text.TextField;

public class Loadouts extends MovieClip {

    private const MAX_LOADOUTS:int = 8;
    private var game:Game = Game.root;
    private var _currentSelected:LoadoutListItem = null;

//    private var _tempData:Object = {
//        "1": { "name": "My Default", "equipments": [1, 2] }
//        "1": { "name": "Set #1 [empty]", "equipments": [1, 2] },
//        "2": { "name": "Set #2 [empty]", "equipments": [1, 2] },
//        "3": { "name": "Set #3 [empty]", "equipments": [1, 2] },
//        "4": { "name": "Set #4 [empty]", "equipments": [1, 2] },
//        "5": { "name": "Set #5 [empty]", "equipments": [1, 2] },
//        "6": { "name": "Set #6 [empty]", "equipments": [1, 2] },
//        "7": { "name": "Set #7 [empty]", "equipments": [1, 2] },
//        "8": { "name": "Set #8 [empty]", "equipments": [1, 2] }
//    };

    public var tEditName:TextField;
    public var itemLists:MovieClip;
    public var btnUpdate:SimpleButton;
    public var btnBackToList:SimpleButton;
    public var btnBackToSave:SimpleButton;
    public var btnNewName:SimpleButton;
    public var btnEquip:SimpleButton;
    public var btnSave:SimpleButton;
    public var btnClose:SimpleButton;

    private var grayscaleMatrix:Array = [
        0.3, 0.59, 0.11, 0, 0,
        0.3, 0.59, 0.11, 0, 0,
        0.3, 0.59, 0.11, 0, 0,
        0, 0, 0, 1, 0
    ];

    public function Loadouts() {
        addFrameScript(0, lists, 1, edit, 2, save, 3, newName);
        open();
    }

    private function lists():void {
        btnEquip.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        btnSave.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        btnClose.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        stop();
    }

    private function edit():void {
//        tEditName.text = _currentSelected ? _currentSelected.tName.text : "Equipment Set...";
        tEditName.addEventListener(FocusEvent.FOCUS_IN, onSearchFocusIn, false, 0, true);
        tEditName.addEventListener(FocusEvent.FOCUS_OUT, onSearchFocusOut, false, 0, true);

        btnUpdate.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        btnBackToList.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);

        stop();
    }

    private function save() : void {
        initLoadoutLists();
        btnBackToList.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        stop();
    }

    private function newName() : void {
        btnBackToSave.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        btnNewName.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        stop();
    }

    public function open() : void {
        itemLists = new MovieClip();
        itemLists.x = 10;
        itemLists.y = 60;
        addChild(itemLists);

        initLoadoutLists();
    }

    public function close() : void {
        parent.removeChild(this);
    }

    private function initLoadoutLists():void {
        game.onRemoveChildren(itemLists);

        _currentSelected = null;
        itemLists.visible = true;

        for (var i:int = 1; i <= MAX_LOADOUTS; i++)
        {
            var item:LoadoutListItem = new LoadoutListItem();
            item.name = "item-" + i;

            var o:Object = game.world.myAvatar.objData.loadOuts[i];

            if (o != null)
            {
                item.btnEdit.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
                item.btnDelete.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);

                item.buttonMode = true;
                item.tName.text = o.name;
                item.addEventListener(MouseEvent.CLICK, function (event:MouseEvent) : void {
                    var item:LoadoutListItem = LoadoutListItem(event.currentTarget);

                    if (item == null || _currentSelected == item) return;
                    if (_currentSelected) _currentSelected.highlighter.visible = false;

                    btnEquip.filters = [];
                    item.highlighter.visible = true;
                    _currentSelected = item;

                    trace("LOAD OUT ITEM > " + item.name);
                });
            }
            else
            {
                item.tName.textColor = 0x999999;
                item.tName.text = "Set #" + i + " (empty)";
                item.btnEdit.visible = false;
                item.btnDelete.visible = false;
            }

            item.y = itemLists.numChildren * item.height + 13;

            itemLists.addChild(item);
        }
    }

    private function initSaveLists():void {
        game.onRemoveChildren(itemLists);

        _currentSelected = null;
        itemLists.visible = true;

        for (var i:int = 1; i <= MAX_LOADOUTS; i++)
        {
            var item:LoadoutListItem = new LoadoutListItem();
            item.name = "item-" + i;

            var o:Object = game.world.myAvatar.objData.loadOuts[i];

            if (o != null)
            {
                item.btnEdit.visible = false;
                item.btnDelete.visible = false;
                item.buttonMode = true;
                item.tName.text = o.name;
                item.addEventListener(MouseEvent.CLICK, function (event:MouseEvent) : void {
                    trace("SAVE LISTS OVERWRITE");
                });
            }
            else
            {
                item.tName.textColor = 0xFFFFFF;
                item.buttonMode = true;
                item.addEventListener(MouseEvent.CLICK, function (event:MouseEvent) : void {
                    trace("SET NEW NAME!");

                    var item:LoadoutListItem = LoadoutListItem(event.currentTarget);

                    if (item == null) return;

                    _currentSelected = item;

                    itemLists.visible = false;
                    gotoAndStop("newName");
                });
                item.tName.text = "Set #" + i + " (empty)";
                item.btnEdit.visible = false;
                item.btnDelete.visible = false;
            }

            item.y = itemLists.numChildren * item.height + 13;

            itemLists.addChild(item);
        }
    }

    private function onSearchFocusIn(event:FocusEvent):void {
        if (tEditName.text == "Equipment Set...") {
            tEditName.text = "";
        }
        tEditName.textColor = 0xFFFFFF;
    }

    private function onSearchFocusOut(event:FocusEvent):void {
        if (tEditName.text == "") {
            tEditName.text = "Equipment Set...";
        }
        tEditName.textColor = 0x999999;
    }

    private function onClick(event:MouseEvent) : void {
        var slot:int;
        var name:String;

        switch (event.currentTarget.name)
        {
            case "btnEquip":
				if (_currentSelected == null)
                {
                    game.Modal("Please select first!", null, {}, "red,medium", "mono");
                    return;
                }
				
                slot = parseInt(_currentSelected.name.slice(5));
                name = _currentSelected.tName.text;
                game.net.send("loadOuts", ["equip", slot, name]);
                break;
            case "btnEdit":
                if (_currentSelected == null)
                {
                    game.Modal("Please select first!", null, {}, "red,medium", "mono");
                    return;
                }

                itemLists.visible = false;
                gotoAndStop("edit");
                tEditName.text = _currentSelected.tName.text;
                break;
            case "btnUpdate":
                if (tEditName.text.length < 1)
                {
                    game.Modal("Too Short!", null, {}, "red,medium", "mono");
                    return;
                }

                slot = parseInt(_currentSelected.name.slice(5));
                name = tEditName.text;
                var oldName:String = _currentSelected.tName.text;
                _currentSelected.tName.text = name;
                game.world.myAvatar.objData.loadOuts[slot].name = name;

                game.net.send("loadOuts", ["update", slot, oldName, name]);

                gotoAndStop("lists");
                initLoadoutLists();
                break;
            case "btnDelete":
                if (_currentSelected == null)
                {
                    game.Modal("Please select first!", null, {}, "red,medium", "mono");
                    return;
                }

                game.Modal("Are you sure want to delete?", function (o:Object) : void {
                    if (o.accept)
                    {
                        slot = parseInt(_currentSelected.name.slice(5));

                        game.net.send("loadOuts", ["delete", slot, _currentSelected.tName.text]);

                        delete game.world.myAvatar.objData.loadOuts[slot];

                        initLoadoutLists();
                    }
                }, {}, "white,medium", "dual");
                break;

            case "btnBackToList":
                gotoAndStop("lists");
                initLoadoutLists();
                break;
            case "btnBackToSave":
            case "btnSave":
                gotoAndStop("save");
                initSaveLists();
                break;
            case "btnNewName":
                if (tEditName.text.length < 1)
                {
                    game.Modal("Too Short!", null, {}, "red,medium", "mono");
                    return;
                }

                var itemIDs:Array = [];

                for each(var o:Object in game.world.myAvatar.objData.eqp) itemIDs.push(int(o.ItemID));

                slot = parseInt(_currentSelected.name.slice(5));
                name = tEditName.text;

                _currentSelected.tName.text = name;
                game.world.myAvatar.objData.loadOuts[slot] = {
                    "name": name,
                    "equipments": String(itemIDs)
                };

                game.net.send("loadOuts", ["new", slot, _currentSelected.tName.text, String(itemIDs)]);

                gotoAndStop("save");
                initSaveLists();
                break;
            case "btnClose":
                parent.removeChild(this);
                break;
        }
    }

}
}