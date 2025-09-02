package game.builder {

import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.MouseEvent;
import flash.text.TextField;

import game.quest.TestLoader;

public class MapBuilderMenu extends BuilderObjectDraggable {

    private var areaObjects:Array = ["Navigator", "Navigation", "Tooltip", "Monster", "Pad", "Unwalkable", "Aggro", "Passive Aggro", "Npc", "Trap", "Arrow", "Collision", "Mining", "AttackIndicator"];
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

        for (var i:int = 0; i < areaObjects.length; i++)
        {
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

    private function onMouseOver(event:MouseEvent) : void {
        var item:MapBuilderListItem = event.currentTarget as MapBuilderListItem;
        item.tName.textColor = 0xFFFFFF;
    }
    private function onMouseOut(event:MouseEvent) : void {
        var item:MapBuilderListItem = event.currentTarget as MapBuilderListItem;
        item.tName.textColor = 0x999999;
    }

    private function clearBuilderChild() : void
    {
        var i:int = 0;

        while (i < game.world.map.numChildren)
        {
            var child:MovieClip = game.world.map.getChildAt(i) as MovieClip;

            if (child != null && child is BuilderObjectDraggable)
            {
                game.world.map.removeChild(child);
                i--;
            }

            i++;
        }
    }

    private function confirmationSaveFrame(o:Object) : void
    {
        if (o.accept)
        {
            var timeline:Array = [];

            for (var i:int = 0; i < game.world.map.numChildren; i++)
            {
                var child:MovieClip = game.world.map.getChildAt(i) as MovieClip;

                if (child == null) continue;

                var form:MovieClip = child.getChildByName("form") as MovieClip;

                if (form == null) continue;

                var handler:BuilderHandler = child.getChildByName("handler") as BuilderHandler;

                if (handler == null) continue;

                var bShow:Boolean = form.visible;
                var bLock:Boolean = Boolean(child.bLock);

                if (child is MapNavigator)
                {
                    var inputNavNewMap:BuilderInput = form.getChildByName("input-new-map") as BuilderInput;
                    var inputNavSpawnCell:BuilderInput = form.getChildByName("input-spawn-cell") as BuilderInput;
                    var inputNavSpawnPad:BuilderInput = form.getChildByName("input-spawn-pad") as BuilderInput;

                    if (inputNavNewMap == null || inputNavSpawnCell == null || inputNavSpawnPad == null)
                    {
                        game.Modal("Map Navigator Error!", null, {}, "red,medium", "mono");
                        return;
                    }

                    timeline.push(child.data = {
                        type: "Navigator",
                        bLock: bLock,
                        bShow: bShow,
                        strNewMap: inputNavNewMap.tInput.text,
                        strSpawnCell: inputNavSpawnCell.tInput.text,
                        strSpawnPad: inputNavSpawnPad.tInput.text,
                        width: Number(child.shadow.width),
                        height: Number(child.shadow.height),
                        x: Number(child.x),
                        y: Number(child.y)
                    });
                }
                else if (child is MapNavigation)
                {
                    var inputNavigationCell:BuilderInput = form.getChildByName("input-cell") as BuilderInput;
                    var inputNavigationPad:BuilderInput = form.getChildByName("input-pad") as BuilderInput;

                    if (inputNavigationCell == null || inputNavigationPad == null)
                    {
                        game.Modal("Map Navigation Error!", null, {}, "red,medium", "mono");
                        return;
                    }

                    timeline.push(child.data = {
                        type: "Navigation",
                        bLock: bLock,
                        bShow: bShow,
                        strCell: inputNavigationCell.tInput.text,
                        strPad: inputNavigationPad.tInput.text,
                        width: Number(child.shadow.width),
                        height: Number(child.shadow.height),
                        x: Number(child.x),
                        y: Number(child.y)
                    });
                }
                else if (child is MapToolTip)
                {
                    var inputTooltipMessage:BuilderInput = form.getChildByName("input-message") as BuilderInput;

                    if (inputTooltipMessage == null)
                    {
                        game.Modal("Map Tooltip Error!", null, {}, "red,medium", "mono");
                        return;
                    }

                    timeline.push(child.data = {
                        type: "Tooltip",
                        bLock: bLock,
                        bShow: bShow,
                        strMessage: inputTooltipMessage.tInput.text,
                        width: Number(child.shadow.width),
                        height: Number(child.shadow.height),
                        x: Number(child.x),
                        y: Number(child.y)
                    });
                }
                else if (child is MapMonster)
                {
                    var inputMonsterID:BuilderInput = form.getChildByName("input-monmapid") as BuilderInput;

                    if (inputMonsterID == null)
                    {
                        game.Modal("Map Monster Error!", null, {}, "red,medium", "mono");
                        return;
                    }

                    timeline.push(child.data = {
                        type: "Monster",
                        bLock: bLock,
                        bShow: bShow,
                        monMapID: int(inputMonsterID.tInput.text),
                        x: Number(child.x),
                        y: Number(child.y)
                    });
                }
                else if (child is MapPad)
                {
                    var inputPad:BuilderInput = form.getChildByName("input-pad") as BuilderInput;

                    if (inputPad == null)
                    {
                        game.Modal("Map Pad Error!", null, {}, "red,medium", "mono");
                        return;
                    }

                    timeline.push(child.data = {
                        type: "Pad",
                        bLock: bLock,
                        bShow: bShow,
                        strPad: inputPad.tInput.text,
                        x: Number(child.x),
                        y: Number(child.y)
                    });
                }
                else if (child is MapUnwalkable)
                {
                    timeline.push(child.data = {
                        type: "Unwalkable",
                        bLock: bLock,
                        bShow: bShow,
                        rotation: Number(child.shadow.rotation),
                        width: Number(child.shadow.width),
                        height: Number(child.shadow.height),
                        x: Number(child.x),
                        y: Number(child.y)
                    });
                }
                else if (child is MapAggro)
                {
                    var inputAMons:BuilderInput = form.getChildByName("input-monsters") as BuilderInput;

                    timeline.push(child.data = {
                        type: "Aggro",
                        bLock: bLock,
                        bShow: bShow,
                        strMonsters: inputAMons.tInput.text,
                        width: Number(child.shadow.width),
                        height: Number(child.shadow.height),
                        x: Number(child.x),
                        y: Number(child.y)
                    });
                }
                else if (child is MapPassiveAgro)
                {
                    var inputPMon:BuilderInput = form.getChildByName("input-monsters") as BuilderInput;

                    timeline.push(child.data = {
                        type: "Passive Aggro",
                        bLock: bLock,
                        bShow: bShow,
                        strMonsters: inputPMon.tInput.text,
                        x: Number(child.x),
                        y: Number(child.y)
                    });
                }
                else if (child is MapNpc)
                {
                    var inputNpcMapID:BuilderInput = form.getChildByName("input-npcmapid") as BuilderInput;

                    timeline.push(child.data = {
                        type: "Npc",
                        bLock: bLock,
                        bShow: bShow,
                        npcMapID: inputNpcMapID.tInput.text,
                        x: Number(child.x),
                        y: Number(child.y)
                    });
                }
                else if (child is MapTrap)
                {
                    var inputTrap:BuilderInput = form.getChildByName("input-damage") as BuilderInput;
                    var inputSource:BuilderInput = form.getChildByName("input-source") as BuilderInput;
                    var inputStrl:BuilderInput = form.getChildByName("input-strl") as BuilderInput;
                    var inputSound:BuilderInput = form.getChildByName("input-sound") as BuilderInput;

                    timeline.push(child.data = {
                        type: "Trap",
                        bLock: bLock,
                        bShow: bShow,
                        iDamage: Number(inputTrap.tInput.text),
                        strStrl: inputStrl.tInput.text,
                        strSound: inputSound.tInput.text,
                        width: Number(child.shadow.width),
                        height: Number(child.shadow.height),
                        x: Number(child.x),
                        y: Number(child.y)
                    });
                }
                else if (child is MapArrow)
                {
                    var inputStyle:BuilderInput = form.getChildByName("input-style") as BuilderInput;
                    var inputFlip:BuilderInput = form.getChildByName("input-flip") as BuilderInput;

                    timeline.push({
                        type: "Arrow",
                        bLock: bLock,
                        bShow: bShow,
                        select: int(child.select),
                        style: int(inputStyle.tInput.text),
                        flip: inputFlip.tInput.text,
                        x: Number(child.x),
                        y: Number(child.y)
                    });
                }
                else if (child is MapMining)
                {
                    var inputMiningId:BuilderInput = form.getChildByName("input-miningid") as BuilderInput;
                    var inputLinkage:BuilderInput = form.getChildByName("input-linkage") as BuilderInput;
                    var inputText:BuilderInput = form.getChildByName("input-text") as BuilderInput;
                    var inputMessage:BuilderInput = form.getChildByName("input-message") as BuilderInput;

                    timeline.push({
                        type: "Mining",
                        bLock: bLock,
                        bShow: bShow,
                        miningId: int(inputMiningId.tInput.text),
                        strLinkage: inputLinkage.tInput.text,
                        text: inputText.tInput.text,
                        message: inputMessage.tInput.text,
                        x: Number(child.x),
                        y: Number(child.y)
                    })
                }
            }

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

            if (mode == "normal")
            {
                game.world.myAvatar.showMC();
            }
            else
            {
                game.world.myAvatar.hideMC();
            }

            if (game.world.timeline == null && game.world.map.numChildren > 0) game.world.timeline = [];

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

    private function confirmationUndo(o:Object) : void
    {
        if (o.accept)
        {
            clearBuilderChild();

            if (game.world.timeline != null)
            {
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

    private function confirmationClearFrame(o:Object) : void
    {
        if (o.accept)
        {
            clearBuilderChild();
            game.world.timeline[game.world.strFrame] = [];
            game.world.game.chatF.pushMsg("server", "The map frame has been cleared.", "SERVER", "", 0);
        }
    }

    private function toggleProps() : void {
        isPropsEnabled = !isPropsEnabled;

        for (var i:int = 0; i < game.world.CHARS.numChildren; i++)
        {
            var child:MovieClip = game.world.CHARS.getChildAt(i) as MovieClip;

            if (child == null || !(child is MovieClip) || !child.hasOwnProperty("isProp")) continue;

            child.visible = isPropsEnabled;
        }

        tProps.text = isPropsEnabled ? "Hide Props" : "Show Props";
    }

    private function toggleMonsters() : void {
        isMonsEnabled = !isMonsEnabled;

        for (var i:int = 0; i < game.world.CHARS.numChildren; i++)
        {
            var child:DisplayObject = game.world.CHARS.getChildAt(i);

            if (child == null || !(child is MonsterMC)) continue;

            child.visible = isMonsEnabled;
        }

        tMons.text = isMonsEnabled ? "Hide Mons" : "Show Mons";
    }

    private function onClick(event:MouseEvent) : void
    {
        switch (event.currentTarget.name)
        {
            case "Navigator":
                game.mapBuilder.createElement({ type: "Navigator", bLock: false, bShow: true, strNewMap: "Newbie", strSpawnCell: "Enter", strSpawnPad: "Spawn", width: 20, height: 20, x: 0, y: 0, bPush: true });
                break;
            case "Navigation":
                game.mapBuilder.createElement({ type: "Navigation", bLock: false, bShow: true, strCell: "Enter", strPad: "Spawn", width: 20, height: 20, x: 0, y: 0, bPush: true });
                break;
            case "Tooltip":
                game.mapBuilder.createElement({ type: "Tooltip", bLock: false, bShow: true, strMessage: "Suck me later!", width: 20, height: 20, x: 0, y: 0 });
                break;
            case "Monster":
                game.mapBuilder.createElement({ type: "Monster", bLock: false, bShow: true, monMapID: 1, x: 0, y: 0 });
                break;
            case "Pad":
                game.mapBuilder.createElement({ type: "Pad", bLock: false, bShow: true, strPad: "Spawn", x: 0, y: 0 });
                break;
            case "Unwalkable":
                game.mapBuilder.createElement({ type: "Unwalkable", bLock: false, bShow: true, rotation: 0, width: 20, height: 20, x: 0, y: 0, bSolid: true });
                break;
            case "Aggro":
                game.mapBuilder.createElement({ type: "Aggro", bLock: false, bShow: true, strMonsters: "1", width: 20, height: 20, x: 0, y: 0, bPush: true });
                break;
            case "Passive Aggro":
                game.mapBuilder.createElement({ type: "Passive Aggro", bLock: false, bShow: true, strMonsters: "1", x: 0, y: 0, bPush: true });
                break;
            case "Npc":
                game.mapBuilder.createElement({ type: "Npc", bLock: false, bShow: true, npcMapID: "1", x: 0, y: 0 });
                break;
            case "Trap":
                game.mapBuilder.createElement({ type: "Trap", bLock: false, bShow: true, iDamage: 1000, strStrl: "sp_es4", strSound: "Hit1", width: 20, height: 20, x: 0, y: 0, bPush: true });
                break;
            case "Arrow":
                game.mapBuilder.createElement({ type: "Arrow", bLock: false, bShow: true, select: 1, style: 1, flip: "Vertical", rotation: 0, x: 0, y: 0 });
                break;
            case "Mining":
                game.mapBuilder.createElement({ type: "Mining", bLock: false, bShow: true, miningId: 1, strLinkage: "Iron", text: "Mining", message: "Success!", x: 0, y: 0 });
                break;
            case "AttackIndicator":
                game.mapBuilder.createElement({ type: "AttackIndicator", bLock: false, bShow: true, shape: "circle", color: "0xFF0000", width: 5, height: 5, x: 0, y: 0 });
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
