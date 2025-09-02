package game.builder {

import flash.display.MovieClip;
import flash.display.Shape;
import flash.events.MouseEvent;
import flash.events.KeyboardEvent;
import flash.geom.Point;
import flash.text.TextFieldAutoSize;

public class MapBuilder extends MovieClip {

    private var game:Game = Game.root;
    public var menu:MapBuilderMenu;

    public function toggle():void {
        if (!game.world.isTimeline) {
            game.Modal("Map Timeline is disabled!", null, {}, "red,medium", "mono");
            return;
        }

        visible = !visible;

        for (var i:int = 0; i < game.world.map.numChildren; i++) {
            var child:MovieClip = game.world.map.getChildAt(i) as MovieClip;
            var handler:MovieClip;

//            trace("TOGGLE => " + child.name);

            if (child != null && child is BuilderObjectDraggable) {

                if (child.typ == "Arrow") {
                    handler = child.getChildByName("handler") as MovieClip;
                    if (handler != null) {
                        handler.visible = visible;
                        child.mouseChildren = visible;
                        child.mouseEnabled = visible;
                    }
                } else if (child.typ == "Mining") {
//                    trace("MINING => " + child.name);
                    handler = child.getChildByName("handler") as MovieClip;
                    if (handler != null) {
                        handler.visible = visible;
                        child.getChildByName("form").visible = false;
                        child.bLock = !visible;
                    }
                } else {
                    child.visible = visible;
                }
            }
        }
    }

    public function initEvents(data:Array):void {
        for (var i:int = 0; i < data.length; i++) createElement(data[i]);
    }

    public function createElement(data:Object, isNew:Boolean = true):void {
        try {
            if (isNew && data.x == 0 && data.y == 0)
            {
                var location:Point = game.world.myAvatar.pMC.location;
                data.x = location.x;
                data.y = location.y;
            }

            var element:MovieClip = createBaseElement(data.type, data);

            if (game.world.myAvatar.isStaff()) {
                element.data = data;
                addHandler(element, data);
                addForm(element, data);
                ApplyLock(element);

                if (data.type == "Arrow") {
                    element.getChildByName("handler").visible = false;
                    element.getChildByName("form").visible = false;
                    element.mouseChildren = false;
                    element.mouseEnabled = false;
                }
                else if (data.type == "Mining")
                {
                    element.getChildByName("handler").visible = false;
                    element.getChildByName("form").visible = false;
                    element.bLock = true;
                }
            }

//            trace("CREATE ELEMENT => " + element.name);

            game.world.map.addChild(element);
        } catch (e:Error) {
            trace("Error creating this data: " + JSON.stringify(data));
            game.world.game.chatF.pushMsg("warning", "Error creating [" + data.type + "] element!", "SERVER", "", 0);
        }
    }

    private function createBaseElement(typ:String, data:Object):MovieClip {
        var elementClass:Class = getElementClass(typ);
        var element:MovieClip = new elementClass();

        element.name = typ + "-" + generateUniqueId();
        element.typ = typ;
        element.bShow = data.bShow !== undefined ? Boolean(data.bShow) : true;
        element.bLock = data.bLock !== undefined ? Boolean(data.bLock) : false;
        element.x = data.x !== undefined ? Number(data.x) : 0;
        element.y = data.y !== undefined ? Number(data.y) : 0;
        element.shadow.width = data.width !== undefined ? Number(data.width) : Number(element.shadow.width);
        element.shadow.height = data.height !== undefined ? Number(data.height) : Number(element.shadow.height);
        element.shadow.rotation = data.rotation !== undefined ? Number(data.rotation) : Number(element.shadow.rotation);

        if (data.bPush) game.world.arrEvent.push(element);
        if (data.bSolid) game.world.arrSolid.push(element);

        switch (typ) {
            case "Navigator":
                element.strNewMap = data.strNewMap || "None";
                element.strSpawnCell = data.strSpawnCell || "Enter";
                element.strSpawnPad = data.strSpawnPad || "Spawn";
                break;
            case "Navigation":
                element.tCell = data.strCell || "Enter";
                element.tPad = data.strPad || "Spawn";
                break;
            case "Tooltip":
                element.strMessage = data.strMessage || "";
                break;
            case "Monster":
                element.MonMapID = data.monMapID || 1;
                break;
            case "Pad":
                element.strPad = data.strPad || "Enter";
                element.name = element.strPad;
                break;
            case "Aggro":
            case "Passive Aggro":
                element.strMonsters = data.strMonsters ? String(data.strMonsters).split(',') : [];
                break;
            case "Npc":
                element.NpcMapID = data.npcMapID || "1";
                break;
            case "Trap":
                element.iDamage = data.iDamage || 0;
                element.strStrl = data.strStrl || "";
                element.strSound = data.strSound || "Hit1";
                break;
            case "Arrow":
                element.shadow.gotoAndStop(int(data.style));
                if (data.flip == "Vertical") element.shadow.scaleX *= -1;
                if (data.flip == "Horizontal") element.shadow.scaleY *= -1;
                break;
            case "Mining":
                element.strLinkage = data.hasOwnProperty("strLinkage") ? data.strLinkage : data.strLinkage = "";

                try {
                    if (game.world.loaderD.hasDefinition(element.strLinkage))
                    {
                        var assetClass:Class = game.world.getClass(element.strLinkage);
                        element.addChild(new (assetClass));
                    }
                } catch (e:Error) {
                }
                break;
            case "AttackIndicator":
                AttackIndicator(int(data.width), int(data.height),  data.color, 0.4, data.shape, element);
                break;
        }

        return element;
    }

    public function AttackIndicator(w:int = 100, h:int = 100, color:uint = 0xFF0000, alpha:Number = 0.4, shapeType:String = "circle", element:MovieClip = null) {
        var shape:Shape = new Shape();
        shape.graphics.beginFill(color, alpha);

        if (shapeType == "circle") {
            var radius:Number = Math.min(w, h) / 2;
            shape.graphics.drawCircle(0, 0, radius);
        } else if (shapeType == "ellipse") {
            shape.graphics.drawEllipse(-w / 2, -h / 2, w, h);
        } else {
            // default to rectangle
            shape.graphics.drawRect(-w / 2, -h / 2, w, h);
        }

        shape.graphics.endFill();
        element.addChild(shape);
    }

    private function getElementClass(typ:String):Class {
        var classMap:Object = {
            "Navigator": MapNavigator,
            "Navigation": MapNavigation,
            "Tooltip": MapToolTip,
            "Monster": MapMonster,
            "Pad": MapPad,
            "Unwalkable": MapUnwalkable,
            "Aggro": MapAggro,
            "Passive Aggro": MapPassiveAgro,
            "Npc": MapNpc,
            "Trap": MapTrap,
            "Arrow": MapArrow,
            "Mining": MapMining,
            "AttackIndicator": MapZone
        };

        if (classMap[typ]) return classMap[typ];
        throw new Error("Unknown type: " + typ);
    }

    private function addHandler(element:MovieClip, data:Object):void {
        var handler:BuilderHandler = new BuilderHandler();
        handler.tType.text = data.type;
        handler.btnExtend.addEventListener(MouseEvent.CLICK, onClick);
        handler.btnDuplicate.addEventListener(MouseEvent.CLICK, onClick);
        handler.btnLock.addEventListener(MouseEvent.CLICK, onClick);
        handler.btnRemove.addEventListener(MouseEvent.CLICK, onClick);
        handler.name = "handler";
        handler.x = 0;
        handler.y = -23;

        handler.btnExtend.a1.visible = data.bShow;
        handler.btnExtend.a2.visible = !data.bShow;

        element.addChild(handler);
    }

    private function addForm(element:MovieClip, data:Object):void {
        var form:MovieClip = new MovieClip();
        form.name = "form";
        form.x = element.shadow.width + 5;
        form.visible = data.bShow;

        addInputs(form, data.type, data);
        element.addChild(form);
    }

    private function addInputs(form:MovieClip, typ:String, data:Object):void {
        var inputs:Array = getInputFields(typ, data);
        for (var i:int = 0; i < inputs.length; i++) {
            try
            {
                var input:BuilderInput = createInput(inputs[i], i * 25);
                form.addChild(input);
            }
            catch(_:Error)
            {
                game.chatF.pushMsg("warning", "Error creating [" + typ + "] .", "SERVER", "", 0);
                break;
            }
        }
    }

    private function getInputFields(typ:String, data:Object):Array {
        var inputFields:Object = {
            "Navigator": [
                { label: "New Map", value: data.strNewMap, restriction: false },
                { label: "Spawn Cell", value: data.strSpawnCell, restriction: false },
                { label: "Spawn Pad", value: data.strSpawnPad, restriction: false },
                { label: "Width", value: data.width, restriction: true },
                { label: "Height", value: data.height, restriction: true },
                { label: "Pos X", value: data.x, restriction: true },
                { label: "Pos Y", value: data.y, restriction: true }
            ],
            "Navigation": [
                { label: "Cell", value: data.strCell, restriction: false },
                { label: "Pad", value: data.strPad, restriction: false },
                { label: "Width", value: data.width, restriction: true },
                { label: "Height", value: data.height, restriction: true },
                { label: "Pos X", value: data.x, restriction: true },
                { label: "Pos Y", value: data.y, restriction: true }
            ],
            "Tooltip": [
                { label: "Message", value: data.strMessage, restriction: false },
                { label: "Width", value: data.width, restriction: true },
                { label: "Height", value: data.height, restriction: true },
                { label: "Pos X", value: data.x, restriction: true },
                { label: "Pos Y", value: data.y, restriction: true }
            ],
            "Monster": [
                { label: "MonMapID", value: data.monMapID, restriction: false },
                { label: "Pos X", value: data.x, restriction: true },
                { label: "Pos Y", value: data.y, restriction: true }
            ],
            "Pad": [
                { label: "Pad", value: data.strPad, restriction: false },
                { label: "Pos X", value: data.x, restriction: true },
                { label: "Pos Y", value: data.y, restriction: true }
            ],
            "Unwalkable": [
                { label: "Rotation", value: data.rotation, restriction: true },
                { label: "Width", value: data.width, restriction: true },
                { label: "Height", value: data.height, restriction: true },
                { label: "Pos X", value: data.x, restriction: true },
                { label: "Pos Y", value: data.y, restriction: true }
            ],
            "Aggro": [
                { label: "Monsters", value: data.strMonsters, restriction: false },
                { label: "Width", value: data.width, restriction: true },
                { label: "Height", value: data.height, restriction: true },
                { label: "Pos X", value: data.x, restriction: true },
                { label: "Pos Y", value: data.y, restriction: true }
            ],
            "Passive Aggro": [
                { label: "Monsters", value: data.strMonsters, restriction: false },
                { label: "Pos X", value: data.x, restriction: true },
                { label: "Pos Y", value: data.y, restriction: true }
            ],
            "Npc": [
                { label: "NpcMapID", value: data.npcMapID, restriction: false },
                { label: "Pos X", value: data.x, restriction: true },
                { label: "Pos Y", value: data.y, restriction: true }
            ],
            "Trap": [
                { label: "Damage", value: data.iDamage, restriction: true },
                { label: "Strl", value: data.strStrl, restriction: false },
                { label: "Sound", value: data.strSound, restriction: false },
                { label: "Width", value: data.width, restriction: true },
                { label: "Height", value: data.height, restriction: true },
                { label: "Pos X", value: data.x, restriction: true },
                { label: "Pos Y", value: data.y, restriction: true }
            ],
            "Arrow": [
                { label: "Style", value: data.style, restriction: false, select: true },
                { label: "Flip", value: data.flip, restriction: false, select: true },
                { label: "Pos X", value: data.x, restriction: true },
                { label: "Pos Y", value: data.y, restriction: true }
            ],
            "Mining": [
                { label: "MiningID", value: data.miningId, restriction: true },
                { label: "Linkage", value: data.strLinkage, restriction: false },
                { label: "Text", value: data.text, restriction: false },
                { label: "Message", value: data.message, restriction: false },
                { label: "Pos X", value: data.x, restriction: true },
                { label: "Pos Y", value: data.y, restriction: true }
            ],
            "AttackIndicator": [
                { label: "Shape", value: data.shape, restriction: false },
                { label: "Color", value: data.color, restriction: false },
                { label: "Width", value: data.width, restriction: true },
                { label: "Height", value: data.height, restriction: true },
                { label: "Pos X", value: data.x, restriction: true },
                { label: "Pos Y", value: data.y, restriction: true }
            ]
        };

        return inputFields[typ] || [];
    }

    private function createInput(config:Object, yPosition:int):BuilderInput {
        var input:BuilderInput = new BuilderInput();

        if (config.restriction) input.tInput.restrict = "0-9";

        if (config.select) {
            input.tInput.mouseEnabled = false;
            input.tInput.autoSize = TextFieldAutoSize.CENTER;
            input.btnLeft.visible = true;
            input.btnRight.visible = true;

            if (config.label == "Style") {
                input.tInput.text = config.value || "1";
                input.btnLeft.addEventListener(MouseEvent.CLICK, onStyleClick, false, 0, true);
                input.btnRight.addEventListener(MouseEvent.CLICK, onStyleClick, false, 0, true);
            } else if (config.label == "Flip") {
                input.tInput.text = config.value || "Vertical";
                input.btnLeft.addEventListener(MouseEvent.CLICK, onFlipClick, false, 0, true);
                input.btnRight.addEventListener(MouseEvent.CLICK, onFlipClick, false, 0, true);
            }
        } else {
            input.tInput.text = config.value || "";
            input.addEventListener(KeyboardEvent.KEY_UP, onKeyboardChange);
        }

        input.tLabel.text = config.label || "None";
        input.y = yPosition;
        input.name = "input-" + String(config.label).toLowerCase().replace(" ", "-");
        return input;
    }

    private function generateUniqueId():Number {
        return Math.floor(Math.random() * 9999999) + 1;
    }

    public function ApplyLock(target:MovieClip):void {
        var handler:BuilderHandler = target.getChildByName("handler") as BuilderHandler;
        if (handler == null) return;

        var form:MovieClip = target.getChildByName("form") as MovieClip;
        if (form == null) return;

        var bLock:Boolean = Boolean(target.bLock);
        var bShow:Boolean = Boolean(target.bShow);

        form.visible = !bLock && bShow;

        handler.tType.visible = !bLock;
        handler.btnExtend.visible = !bLock;
        handler.btnDuplicate.visible = !bLock;
        handler.btnLock.visible = true;
        handler.btnRemove.visible = !bLock;
        handler.btnLock.x = bLock ? 0 : 44.6;
    }

    private function onStyleClick(event:MouseEvent):void {
        var target:MovieClip = event.currentTarget.parent as MovieClip;
        game.mixer.playSound("Click");

        var style:int = int(target.tInput.text);

        switch (event.currentTarget.name) {
            case "btnLeft":
                if (style > 1) {
                    style--;
                    target.tInput.text = style;
                    MovieClip(target.parent.parent).shadow.gotoAndStop(style);
                }
                break;
            case "btnRight":
                if (style < 3) {
                    style++;
                    target.tInput.text = style;
                    MovieClip(target.parent.parent).shadow.gotoAndStop(style);
                }
                break;
        }
    }

    private function onFlipClick(event:MouseEvent):void {
        var target:MovieClip = event.currentTarget.parent as MovieClip;
        game.mixer.playSound("Click");

        switch (event.currentTarget.name) {
            case "btnLeft":
                if (target.tInput.text != "Vertical") {
                    target.tInput.text = "Vertical";
                    MovieClip(target.parent.parent).shadow.scaleX *= -1;
                }
                break;
            case "btnRight":
                if (target.tInput.text != "Horizontal") {
                    target.tInput.text = "Horizontal";
                    MovieClip(target.parent.parent).shadow.scaleY *= -1;
                }
                break;
        }
    }

    private function onClick(event:MouseEvent):void {
        var target:MovieClip = event.currentTarget.parent.parent;
        game.mixer.playSound("Click");

        switch (event.currentTarget.name) {
            case "btnExtend":
                var form:MovieClip = target.getChildByName("form") as MovieClip;
                if (form != null) {
                    form.visible = !form.visible;
                    event.currentTarget.a1.visible = form.visible;
                    event.currentTarget.a2.visible = !form.visible;
                    target.bShow = form.visible;
                }
                break;
            case "btnDuplicate":
                createElement(target.data);
                game.world.game.chatF.pushMsg("server", "Element '" + target.data.type + "' has been duplicated successfully!.", "SERVER", "", 0);
                break;
            case "btnLock":
                target.bLock = !Boolean(target.bLock);
                ApplyLock(target);
                break;
            case "btnRemove":
                game.Modal("Are you sure you want to remove this map element?", function (o:Object):void {
                    if (o.accept) game.world.map.removeChild(target);
                }, {}, "white,medium");
                break;
        }
    }

    private function onKeyboardChange(event:KeyboardEvent):void {
        var input:BuilderInput = event.currentTarget as BuilderInput;
        var form:MovieClip = input.parent as MovieClip;
        var element:MovieClip = form.parent as MovieClip;

        if (input == null || form == null || element == null) return;

        switch (input.name) {
            case "input-sound":
                element.strSound = input.tInput.text;
                break;
            case "input-strl":
                element.strStrl = input.tInput.text;
                break;
            case "input-message":
                element.strMessage = input.tInput.text;
                break;
            case "input-monmapid":
                element.MonMapID = int(input.tInput.text);
                break;
            case "input-cell":
                element.tCell = input.tInput.text;
                break;
            case "input-pad":
                element.tPad = input.tInput.text;
                element.name = input.tInput.text;
                break;
            case "input-pos-x":
                element.x = Number(input.tInput.text);
                break;
            case "input-pos-y":
                element.y = Number(input.tInput.text);
                break;
            case "input-monsters":
                element.strMonsters = input.tInput.text.length > 0 ? input.tInput.text.split(',') : [];
                break;
            case "input-rotation":
                element.shadow.rotation = Number(input.tInput.text);
                break;
            case "input-width":
                var newWidth:int = Number(input.tInput.text);
//                if (newWidth > ConfigurationData.CLIENT_WIDTH) {
//                    game.Modal("You have reached the maximum width of " + ConfigurationData.CLIENT_WIDTH + ".", null, {}, "red,medium", "mono");
//                    input.tInput.text = element.shadow.width;
//                    return;
//                }
                element.shadow.width = newWidth;
                form.x = element.shadow.width + 5;
                break;
            case "input-height":
                var newHeight:int = Number(input.tInput.text);
//                if (newHeight > ConfigurationData.CLIENT_HEIGHT) {
//                    game.Modal("You have reached the maximum height of " + ConfigurationData.CLIENT_HEIGHT + ".", null, {}, "red,medium", "mono");
//                    input.tInput.text = element.shadow.height;
//                    return;
//                }
                element.shadow.height = newHeight;
                break;
        }
    }
}
}