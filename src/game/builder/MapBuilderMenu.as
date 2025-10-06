package game.builder {

import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.MouseEvent;
import flash.text.TextField;

import game.quest.TestLoader;

public class MapBuilderMenu extends BuilderObjectDraggable {

    private var areaObjects:Array = ["Navigator", "Navigation", "Tooltip", "Monster", "Pad", "Unwalkable", "Aggro", "Passive Aggro", "Npc", "Trap", "Arrow", "Collision", "Resource", "Prop", "AttackIndicator"];

    public var isPropsEnabled:Boolean = true;
    public var isMonsEnabled:Boolean = true;

    public var listMask:MovieClip;
    public var lists:MovieClip;

    public var listScrLoader:TestLoader;
    public var listScr:MovieClip;

    public var tProps:TextField;
    public var tMons:TextField;
    public var tScale:TextField;
    public var tMode:TextField;
    public var tSpeed:TextField;
    public var tWidth:TextField;
    public var tHeight:TextField;
    public var chkScroll:MovieClip;

    public var btnProps:SimpleButton;
    public var btnMons:SimpleButton;
    public var btnClear:SimpleButton;
    public var btnUndo:SimpleButton;
    public var btnSave:SimpleButton;

    public function MapBuilderMenu() {
        lists.mask = listMask;

        tProps.mouseEnabled = false;
        tMons.mouseEnabled = false;

        for (var i:int = 0; i < areaObjects.length; i++) {
            var item:MapBuilderListItem = new MapBuilderListItem();
            item.tName.text = areaObjects[i];
            item.y = lists.numChildren * 25;
            item.name = areaObjects[i];
            item.buttonMode = true;
            item.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            item.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
            item.removeEventListener(MouseEvent.CLICK, onClick);
            item.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
            item.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
            item.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
            lists.addChild(item);
        }

        listScrLoader = new TestLoader(listMask, lists, listScr, 175);
        listScrLoader.open();

        btnProps.removeEventListener(MouseEvent.CLICK, onClick);
        btnMons.removeEventListener(MouseEvent.CLICK, onClick);
        btnClear.removeEventListener(MouseEvent.CLICK, onClick);
        btnUndo.removeEventListener(MouseEvent.CLICK, onClick);
        btnSave.removeEventListener(MouseEvent.CLICK, onClick);

        btnProps.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        btnMons.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        btnClear.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        btnUndo.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        btnSave.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
    }

    private function onMouseOver(event:MouseEvent):void {
        var item:MapBuilderListItem = event.currentTarget as MapBuilderListItem;
        item.tName.textColor = 0xFFFFFF;
    }

    private function onMouseOut(event:MouseEvent):void {
        var item:MapBuilderListItem = event.currentTarget as MapBuilderListItem;
        item.tName.textColor = 0x999999;
    }

    private function clearBuilderChild():void {
        var i:int = 0;

        while (i < game.world.map.numChildren) {
            var child:MovieClip = game.world.map.getChildAt(i) as MovieClip;

            if (child != null && child is BuilderObjectDraggable) {
                game.world.map.removeChild(child);
                i--;
            }

            i++;
        }
    }

    private function getCommonData(child:MovieClip, bLock:Boolean, bShow:Boolean):Object {
        return {
            bLock: bLock,
            bShow: bShow,
            x: Number(child.x),
            y: Number(child.y)
        };
    }

    private function getShadowData(child:MovieClip):Object {
        return {
            width: Number(child.shadow.width),
            height: Number(child.shadow.height),
            rotation: Number(child.shadow.rotation)
        };
    }

    private function merge(...objs):Object {
        var result:Object = {};
        for each (var o:Object in objs) {
            for (var k:String in o) result[k] = o[k];
        }
        return result;
    }

    private function confirmationSaveFrame(o:Object):void {
        if (o.accept) {
            var timeline:Array = [];
//            var child:MovieClip;
//            var form:MovieClip;
//            var handler:BuilderHandler;
//            var bShow:Boolean = true;
//            var bLock:Boolean = false;

            for (var i:int = 0; i < game.world.map.numChildren; i++) {
                var child:MovieClip = game.world.map.getChildAt(i) as MovieClip;
                if (!child) continue;

                var form:MovieClip = child.getChildByName("form") as MovieClip;
                var handler:BuilderHandler = child.getChildByName("handler") as BuilderHandler;
                if (!form || !handler) continue;

                var bShow:Boolean = form.visible;
                var bLock:Boolean = Boolean(child.bLock);

                if (child is MapNavigator) {
                    var navNew:BuilderInput = form.getChildByName("input-new-map") as BuilderInput;
                    var navCell:BuilderInput = form.getChildByName("input-spawn-cell") as BuilderInput;
                    var navPad:BuilderInput = form.getChildByName("input-spawn-pad") as BuilderInput;
                    if (!navNew || !navCell || !navPad) {
                        game.Modal("Map Navigator Error!", null, {}, "red,medium", "mono");
                        return;
                    }

                    timeline.push(child.data = merge(
                            {
                                type: "Navigator",
                                strNewMap: navNew.tInput.text,
                                strSpawnCell: navCell.tInput.text,
                                strSpawnPad: navPad.tInput.text
                            },
                            getCommonData(child, bLock, bShow),
                            getShadowData(child)
                    ));
                } else if (child is MapNavigation) {
                    var navInCell:BuilderInput = form.getChildByName("input-cell") as BuilderInput;
                    var navInPad:BuilderInput = form.getChildByName("input-pad") as BuilderInput;
                    if (!navInCell || !navInPad) {
                        game.Modal("Map Navigation Error!", null, {}, "red,medium", "mono");
                        return;
                    }

                    timeline.push(child.data = merge(
                            {type: "Navigation", strCell: navInCell.tInput.text, strPad: navInPad.tInput.text},
                            getCommonData(child, bLock, bShow),
                            getShadowData(child)
                    ));
                } else if (child is MapToolTip) {
                    var tipMsg:BuilderInput = form.getChildByName("input-message") as BuilderInput;
                    if (!tipMsg) {
                        game.Modal("Map Tooltip Error!", null, {}, "red,medium", "mono");
                        return;
                    }

                    timeline.push(child.data = merge(
                            {type: "Tooltip", strMessage: tipMsg.tInput.text},
                            getCommonData(child, bLock, bShow),
                            getShadowData(child)
                    ));
                } else if (child is MapMonster) {
                    var monId:BuilderInput = form.getChildByName("input-monmapid") as BuilderInput;
                    if (!monId) {
                        game.Modal("Map Monster Error!", null, {}, "red,medium", "mono");
                        return;
                    }

                    timeline.push(child.data = merge(
                            {type: "Monster", monMapID: int(monId.tInput.text)},
                            getCommonData(child, bLock, bShow)
                    ));
                } else if (child is MapPad) {
                    var pad:BuilderInput = form.getChildByName("input-pad") as BuilderInput;
                    if (!pad) {
                        game.Modal("Map Pad Error!", null, {}, "red,medium", "mono");
                        return;
                    }

                    timeline.push(child.data = merge(
                            {type: "Pad", strPad: pad.tInput.text},
                            getCommonData(child, bLock, bShow)
                    ));
                } else if (child is MapUnwalkable) {
                    timeline.push(child.data = merge(
                            {type: "Unwalkable"},
                            getCommonData(child, bLock, bShow),
                            getShadowData(child)
                    ));
                } else if (child is MapAggro) {
                    var aggro:BuilderInput = form.getChildByName("input-monsters") as BuilderInput;
                    timeline.push(child.data = merge(
                            {type: "Aggro", strMonsters: aggro.tInput.text},
                            getCommonData(child, bLock, bShow),
                            getShadowData(child)
                    ));
                } else if (child is MapPassiveAgro) {
                    var pAggro:BuilderInput = form.getChildByName("input-monsters") as BuilderInput;
                    timeline.push(child.data = merge(
                            {type: "Passive Aggro", strMonsters: pAggro.tInput.text},
                            getCommonData(child, bLock, bShow)
                    ));
                } else if (child is MapNpc) {
                    var npcId:BuilderInput = form.getChildByName("input-npcmapid") as BuilderInput;
                    timeline.push(child.data = merge(
                            {type: "Npc", npcMapID: npcId.tInput.text},
                            getCommonData(child, bLock, bShow)
                    ));
                } else if (child is MapTrap) {
                    var trap:BuilderInput = form.getChildByName("input-damage") as BuilderInput;
                    var strl:BuilderInput = form.getChildByName("input-strl") as BuilderInput;
                    var snd:BuilderInput = form.getChildByName("input-sound") as BuilderInput;

                    timeline.push(child.data = merge(
                            {
                                type: "Trap",
                                iDamage: Number(trap.tInput.text),
                                strStrl: strl.tInput.text,
                                strSound: snd.tInput.text
                            },
                            getCommonData(child, bLock, bShow),
                            getShadowData(child)
                    ));
                } else if (child is MapArrow) {
                    var style:BuilderInput = form.getChildByName("input-style") as BuilderInput;
                    var flip:BuilderInput = form.getChildByName("input-flip") as BuilderInput;
                    timeline.push(merge(
                            {
                                type: "Arrow",
                                select: int(child.select),
                                style: int(style.tInput.text),
                                flip: flip.tInput.text
                            },
                            getCommonData(child, bLock, bShow)
                    ));
                }
            }

            // --- Process CHARS (MapResource + MapProp) ---
            for (var k:int = 0; k < game.world.CHARS.numChildren; k++) {
                child = game.world.CHARS.getChildAt(k) as MovieClip;
                if (!child || !(child is MapResource || child is MapProp)) continue;

                form = child.getChildByName("form") as MovieClip;
                handler = child.getChildByName("handler") as BuilderHandler;
                if (!form || !handler) continue;

                bShow = form.visible;
                bLock = Boolean(child.bLock);

                if (child is MapResource) {
                    var resId:BuilderInput = form.getChildByName("input-resmapid") as BuilderInput;

                    timeline.push(merge(
                            {
                                type: "Resource",
                                resMapId: int(resId.tInput.text)
                            },
                            getCommonData(child, bLock, bShow)
                    ));
                } else if (child is MapProp) {
                    var propId:BuilderInput = form.getChildByName("input-propmapid") as BuilderInput;
                    timeline.push(merge(
                            {type: "Prop", propMapId: int(propId.tInput.text)},
                            getCommonData(child, bLock, bShow)
                    ));
                }
            }

            // --- Save settings ---
            var scale:Number = Number(tScale.text);
            var mode:String = tMode.text;
            var speed:int = int(tSpeed.text);
            var scroll:Boolean = Boolean(chkScroll.bitChecked);
            var width:int = int(tWidth.text);
            var height:int = int(tHeight.text);

            game.world.myAvatar.pMC.scale(scale);
            game.world.WALKSPEED = speed;
            game.world.SCROLL = scroll;
            game.world.mapWidth = width;
            game.world.mapHeight = height;

            if (scroll) {
                game.world.map.walk.width = width;
                game.world.map.walk.height = height;
                game.world.map.walk.x = game.world.map.walk.y = 0;
            }

            (mode == "normal") ? game.world.myAvatar.showMC() : game.world.myAvatar.hideMC();

            if (game.world.timeline == null && game.world.map.numChildren > 0) game.world.timeline = [];

            trace("Saving data: " + JSON.stringify(timeline));

            game.world.timeline[game.world.strFrame] = {
                Scale: scale,
                Mode: mode,
                Speed: speed,
                Scroll: scroll,
                Width: width,
                Height: height,
                Events: timeline
            };

            game.net.send("mapBuilder", [scale, mode, speed, scroll, width, height, JSON.stringify(timeline)]);
        }
    }

    private function confirmationUndo(o:Object):void {
        if (o.accept) {
            clearBuilderChild();

            if (game.world.timeline != null) {
                var data:Object = game.world.timeline[game.world.strFrame];

                tScale.text = data.Scale;
                tMode.text = data.Mode;
                tSpeed.text = data.Speed;
                chkScroll.bitChecked = data.Scroll;
                chkScroll.checkmark.visible = game.mapBuilder.menu.chkScroll.bitChecked;

                game.mapBuilder.initEvents(data.Events);
                game.world.cellSetup(Number(data.Scale), Number(data.Speed), data.Mode);
            }

            game.world.game.chatF.pushMsg("server", "The map frame has been undo.", "SERVER", "", 0);
        }
    }

    private function confirmationClearFrame(o:Object):void {
        if (o.accept) {
            clearBuilderChild();
            game.world.timeline[game.world.strFrame] = [];
            game.world.game.chatF.pushMsg("server", "The map frame has been cleared.", "SERVER", "", 0);
        }
    }

    private function toggleProps():void {
        isPropsEnabled = !isPropsEnabled;

        for (var i:int = 0; i < game.world.CHARS.numChildren; i++) {
            var child:MovieClip = game.world.CHARS.getChildAt(i) as MovieClip;

            if (child == null || !(child is MovieClip) || !child.hasOwnProperty("isProp")) continue;

            child.visible = isPropsEnabled;
        }

        tProps.text = isPropsEnabled ? "Hide Props" : "Show Props";
    }

    private function toggleMonsters():void {
        isMonsEnabled = !isMonsEnabled;

        for (var i:int = 0; i < game.world.CHARS.numChildren; i++) {
            var child:DisplayObject = game.world.CHARS.getChildAt(i);

            if (child == null || !(child is MonsterMC)) continue;

            child.visible = isMonsEnabled;
        }

        tMons.text = isMonsEnabled ? "Hide Mons" : "Show Mons";
    }

    private function onClick(event:MouseEvent):void {
        switch (event.currentTarget.name) {
            case "Navigator":
                game.mapBuilder.createElement({
                    type: "Navigator",
                    bLock: false,
                    bShow: true,
                    strNewMap: "Newbie",
                    strSpawnCell: "Enter",
                    strSpawnPad: "Spawn",
                    width: 20,
                    height: 20,
                    x: 0,
                    y: 0,
                    bPush: true
                });
                break;
            case "Navigation":
                game.mapBuilder.createElement({
                    type: "Navigation",
                    bLock: false,
                    bShow: true,
                    strCell: "Enter",
                    strPad: "Spawn",
                    width: 20,
                    height: 20,
                    x: 0,
                    y: 0,
                    bPush: true
                });
                break;
            case "Tooltip":
                game.mapBuilder.createElement({
                    type: "Tooltip",
                    bLock: false,
                    bShow: true,
                    strMessage: "Suck me later!",
                    width: 20,
                    height: 20,
                    x: 0,
                    y: 0
                });
                break;
            case "Monster":
                game.mapBuilder.createElement({type: "Monster", bLock: false, bShow: true, monMapID: 1, x: 0, y: 0});
                break;
            case "Pad":
                game.mapBuilder.createElement({type: "Pad", bLock: false, bShow: true, strPad: "Spawn", x: 0, y: 0});
                break;
            case "Unwalkable":
                game.mapBuilder.createElement({
                    type: "Unwalkable",
                    bLock: false,
                    bShow: true,
                    rotation: 0,
                    width: 20,
                    height: 20,
                    x: 0,
                    y: 0,
                    bSolid: true
                });
                break;
            case "Aggro":
                game.mapBuilder.createElement({
                    type: "Aggro",
                    bLock: false,
                    bShow: true,
                    strMonsters: "1",
                    width: 20,
                    height: 20,
                    x: 0,
                    y: 0,
                    bPush: true
                });
                break;
            case "Passive Aggro":
                game.mapBuilder.createElement({
                    type: "Passive Aggro",
                    bLock: false,
                    bShow: true,
                    strMonsters: "1",
                    x: 0,
                    y: 0,
                    bPush: true
                });
                break;
            case "Npc":
                game.mapBuilder.createElement({type: "Npc", bLock: false, bShow: true, npcMapID: "1", x: 0, y: 0});
                break;
            case "Trap":
                game.mapBuilder.createElement({
                    type: "Trap",
                    bLock: false,
                    bShow: true,
                    iDamage: 1000,
                    strStrl: "sp_es4",
                    strSound: "Hit1",
                    width: 20,
                    height: 20,
                    x: 0,
                    y: 0,
                    bPush: true
                });
                break;
            case "Arrow":
                game.mapBuilder.createElement({
                    type: "Arrow",
                    bLock: false,
                    bShow: true,
                    select: 1,
                    style: 1,
                    flip: "Vertical",
                    rotation: 0,
                    x: 0,
                    y: 0
                });
                break;
            case "Resource":
                game.mapBuilder.createElement({
                    type: "Resource",
                    bLock: false,
                    bShow: true,
                    resMapId: -1,
                    x: 0,
                    y: 0
                });
                break;
            case "Prop":
                game.mapBuilder.createElement({type: "Prop", bLock: false, bShow: true, propMapId: -1, scale: 0.0, x: 0, y: 0});
                break;
            case "AttackIndicator":
                game.mapBuilder.createElement({
                    type: "AttackIndicator",
                    bLock: false,
                    bShow: true,
                    shape: "circle",
                    color: "0xFF0000",
                    width: 5,
                    height: 5,
                    x: 0,
                    y: 0
                });
                break;
            case "btnProps":
                toggleProps();
                break;
            case "btnMons":
                toggleMonsters();
                break;
            case "btnClear":
                game.Modal("Are you sure you want to clear all map element?", confirmationClearFrame, {}, "white,medium");
                break;
            case "btnUndo":
                game.Modal("Are you sure you want to undo? This will reset the value and position of the map element based on the current data.", confirmationUndo, {}, "white,medium");
                break;
            case "btnSave":
                game.Modal("Are you sure you want to update the map frame?", confirmationSaveFrame, {}, "white,medium");
                break;
        }
    }

}
}
