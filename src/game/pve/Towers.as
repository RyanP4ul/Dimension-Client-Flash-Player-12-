package game.pve {
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.ColorMatrixFilter;
import flash.filters.GlowFilter;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;
import flash.text.TextField;

import game.quest.TestLoader;

public class Towers extends MovieClip {

    private var game:Game = Game.root;
    private var currentLoaderIndex:int = 0;

    public var loaderD:ApplicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
    public var loaderC:LoaderContext = new LoaderContext(false, loaderD);

    public var listsMask:MovieClip;
    public var floorMask:MovieClip;
    public var arrowLeft:MovieClip;
    public var arrowRight:MovieClip;
    public var backToLists:MovieClip;
    public var listTowers:MovieClip;
    public var listFloors:MovieClip;
    public var scr:MovieClip;

    public var tTower:TextField;
    public var tDesc:TextField;
    public var tTotalFloor:TextField;

    public var scrLoader:TestLoader;

    private var _data:Array = [
        {
            "id": 1,
            "title": "Central Tower",
            "environment": "Jungle, overgrowth",
            "description": "Rising from the heart of the town, the Central Tower is an ancient structure shrouded in mystery. No one knows who built it or why it stands, but its presence has shaped the lives of everyone around it. Each floor within holds trials, treasures, and terrors beyond imagination, drawing adventurers from across the land. To climb the tower is to seek power, glory, or the truth hidden within its heights.",
            "file": "CentralTower/central_tower_r7_preview.swf",
            "linkage": "Main",
            "floors": [
                {
                    id: 1,
                    floor: "Floor 1",
                    icon: "iwsword",
                    objectives: "Kill Boss",
                    duration: "18000" // 5 MINUTES
                },
                {
                    id: 2,
                    floor: "Floor 2",
                    icon: "iwsword"
                },
                {
                    id: 3,
                    floor: "Floor 3",
                    icon: "iwsword"
                },
                {
                    id: 4,
                    floor: "Floor 4",
                    icon: "iwsword"
                },
                {
                    id: 5,
                    floor: "Floor 5",
                    icon: "iwsword"
                },
                {
                    id: 6,
                    floor: "Floor 6",
                    icon: "iwsword"
                },
                {
                    id: 7,
                    floor: "Floor 7",
                    icon: "iwsword"
                },
                {
                    id: 8,
                    floor: "Floor 8",
                    icon: "iwsword"
                },
                {
                    id: 9,
                    floor: "Floor 9",
                    icon: "iwsword"
                },
                {
                    id: 10,
                    floor: "Floor 10",
                    icon: "iwsword"
                }
            ]
        },
        {
            "id": 2,
            "title": "Test 2",
            "environment": "Jungle, overgrowth",
            "description": "Rising from the heart of the town, the Central Tower is an ancient structure shrouded in mystery. No one knows who built it or why it stands, but its presence has shaped the lives of everyone around it. Each floor within holds trials, treasures, and terrors beyond imagination, drawing adventurers from across the land. To climb the tower is to seek power, glory, or the truth hidden within its heights.",
            "file": "CentralTower/central_tower_r7_preview.swf",
            "linkage": "Main",
            "floors": [
                {
                    id: 1,
                    floor: "Floor 1"
                }
            ]
        }
    ];

    private var _charData:Object = {
        towers: {
            "1": [1, 2]
//            "2": [1,2,3,4,5]
        }
    };

    private var items:Array = [];
    private var isDragging:Boolean = false;
    private var dragStartX:Number;
    private var containerStartX:Number;
    private var currentIndex:int = 0;

    public function Towers() {
        loaderC.checkPolicyFile = false;
        loaderC.allowCodeImport = true;
        addFrameScript(0, frameLists, 1, frameFloor);
    }

    private function frameLists():void {

        arrowLeft.buttonMode = arrowRight.buttonMode = true;

        arrowLeft.removeEventListener(MouseEvent.CLICK, scrollLeft);
        arrowRight.removeEventListener(MouseEvent.CLICK, scrollRight);
        listTowers.removeEventListener(MouseEvent.MOUSE_DOWN, startDragging);
        stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragging);

        arrowLeft.addEventListener(MouseEvent.CLICK, scrollLeft);
        arrowRight.addEventListener(MouseEvent.CLICK, scrollRight);

        listTowers.addEventListener(MouseEvent.MOUSE_DOWN, startDragging);
        stage.addEventListener(MouseEvent.MOUSE_UP, stopDragging);

        initListTowers();
        stop();
    }

    private function frameFloor():void {
        backToLists.buttonMode = true;
        backToLists.addEventListener(MouseEvent.CLICK, onBackToLists);

        initListFloors();

        stop();
    }

    private function initListTowers():void {
        game.onRemoveChildren(listTowers);
        currentLoaderIndex = 0;
        items = [];

        for each (var o:Object in _data) {
            var item:TowerListItem = new TowerListItem();
            item.width = 230;
            item.height = 400;
            item.tTitle.text = o.title;
            item.name = "item-" + o.id;
            item.x = items.length * (item.width + 10);
            item.isLocked = !_charData.towers.hasOwnProperty(String(o.id));
            trace(item.name + (item.isLocked ? " is locked" : " is unlocked"));
            item.lock.visible = item.isLocked;

            item.buttonMode = true;
            item.mouseChildren = false;
            item.addEventListener(MouseEvent.CLICK, onItemClick);

            listTowers.addChild(item);
            items.push(item);

            if (!loaderD.hasDefinition(o.linkage))
            {
                game.onLoadMaster(function (event:Event) : void {
                    loadNext();
                }, loaderC, "maps/towers/" + o.file);
            }
            else
            {
                loadNext();
            }
        }

        highlightItem(currentIndex);
    }

    private function loadNext() : void
    {
        if (currentLoaderIndex >= items.length) return;

        var o:Object = _data[currentLoaderIndex];
        var item:TowerListItem = items[currentLoaderIndex];

        if (item == null) return;

        var assetClass:Class = loaderD.getDefinition(o.linkage) as Class;

        if (assetClass != null)
        {
            var mc:MovieClip = new (assetClass);
            item.preview.addChild(mc);
            item.loader.visible = false;
        }

        currentLoaderIndex++;

        loadNext();
    }

    private function initListFloors() : void {
        game.onRemoveChildren(listFloors);

        var data:Object = _data[currentIndex];

        if (data == null) return;
        tTower.text = data.title;
        tDesc.text = data.description;

        for each (var o:Object in data.floors)
        {
            var item:FloorListItem = new FloorListItem();
            item.tName.text = String(o.floor);

            if (listFloors.numChildren != 0 && isFloorLocked(data.id, o.id))
            {
                item.tStatus.text = "Locked";
                item.lock.visible = true;
                item.ready.visible = false;
                item.check.visible = false;
                item.tName.textColor = 0x666666;
            }
            else
            {
                item.tStatus.text = "Ready";
                item.lock.visible = false;
                item.ready.visible = true;
                item.check.visible = true;
                item.tName.textColor = 0xFFFFFF;
            }

            item.y = listFloors.numChildren * (item.height - 3);
            item.buttonMode = true;

            listFloors.addChild(item);
        }

        tTotalFloor.text = "Total Floors: " + listFloors.numChildren;

        scrLoader = new TestLoader(floorMask, listFloors, scr);
        scrLoader.open();

        setChildIndex(scr, numChildren - 1);
    }

    private function isFloorLocked(towerID:int, floorID:int) : Boolean
    {
        var tower:Object = _charData.towers[String(towerID)];

        if (tower == null) return true;

        for each(var o:Object in tower)
            if (int(o) == floorID)
                return false;

        return true;
    }

    private function scrollLeft(e:MouseEvent):void {
        if (currentIndex > 0) {
            highlightItem(--currentIndex);
            alignItemToLeft();
        }
    }

    private function scrollRight(e:MouseEvent):void {
        if (currentIndex < items.length - 1) {
            highlightItem(++currentIndex);
            alignItemToLeft();
        }
    }

    private function onItemClick(e:MouseEvent):void {
        if (Math.abs(mouseX - dragStartX) > 5) return;

        var clickedItem:MovieClip = e.currentTarget as MovieClip;
        var index:int = items.indexOf(clickedItem);

        if (index !== -1) {
            if (clickedItem.isLocked)
            {
                trace("TOWER IS LOCKED!");
                return;
            }

            currentIndex = index;
            highlightItem(currentIndex);
            alignItemToLeft();

            removeListEvents();
            listTowers.visible = false;
            gotoAndStop("Floor");
        }
    }

    private function highlightItem(index:int):void {
        for each (var item:TowerListItem in items) {
            item.filters = item.isLocked ? [new ColorMatrixFilter([
                0.3086, 0.6094, 0.0820, 0, 0,
                0.3086, 0.6094, 0.0820, 0, 0,
                0.3086, 0.6094, 0.0820, 0, 0,
                0,      0,      0,      1, 0
            ])] : [];
        }

        var glow:GlowFilter = new GlowFilter(0xFFD700, 0.2, 5, 5, 1, 2);
        items[index].filters = [glow];
    }

    private function alignItemToLeft():void {
        var targetX:Number = listsMask.x - items[currentIndex].x;
        targetX = clamp(targetX, getMinScrollX(), getMaxScrollX());
        listTowers.x = targetX;
    }

    private function startDragging(e:MouseEvent):void {
        isDragging = true;
        dragStartX = mouseX;
        containerStartX = listTowers.x;
        stage.addEventListener(MouseEvent.MOUSE_MOVE, dragScroll);
    }

    private function dragScroll(e:MouseEvent):void {
        if (isDragging) {
            var newX:Number = containerStartX + (mouseX - dragStartX);
            listTowers.x = clamp(newX, getMinScrollX(), getMaxScrollX());
        }
    }

    private function stopDragging(e:MouseEvent):void {
        isDragging = false;
        stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragScroll);
    }

    private function getMaxScrollX():Number {
        return listsMask.x;
    }

    private function getMinScrollX():Number {
        return listsMask.x - (listTowers.width - listsMask.width);
    }

    private function clamp(value:Number, min:Number, max:Number):Number {
        return Math.max(min, Math.min(max, value));
    }

    private function onBackToLists(e:MouseEvent):void {
        backToLists.visible = false;
        backToLists.removeEventListener(MouseEvent.CLICK, onBackToLists);
        gotoAndStop("Lists");
    }

    private function removeListEvents():void {
        arrowLeft.removeEventListener(MouseEvent.CLICK, scrollLeft);
        arrowRight.removeEventListener(MouseEvent.CLICK, scrollRight);
        listTowers.removeEventListener(MouseEvent.MOUSE_DOWN, startDragging);
        stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragging);
    }
}
}
