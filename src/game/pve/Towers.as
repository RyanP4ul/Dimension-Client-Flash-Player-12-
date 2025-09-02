package game.pve {
import flash.display.MovieClip;
import flash.events.MouseEvent;
import flash.filters.ColorMatrixFilter;
import flash.filters.GlowFilter;
import flash.text.TextField;

import game.quest.TestLoader;

public class Towers extends MovieClip {

    private var game:Game = Game.root;

    public var listsMask:MovieClip;
    public var floorMask:MovieClip;
    public var arrowLeft:MovieClip;
    public var arrowRight:MovieClip;
    public var backToLists:MovieClip;
    public var listTowers:MovieClip;
    public var listFloors:MovieClip;
    public var scr:MovieClip;

    public var tTower:TextField;
    public var tEnv:TextField;
    public var tDesc:TextField;
    public var tTotalFloor:TextField;

    public var scrLoader:TestLoader;

    private var _data:Array = [
        {
            "id": 1,
            "title": "Verdant Spire",
            "environment": "Jungle, overgrowth",
            "description": "An overgrown tower reclaimed by primal nature. Vines twist through ancient ruins as the flora fights back against all who enter.",
            "floors": [
                {
                    id: 1,
                    floor: "Floor 1"
                },
                {
                    id: 2,
                    floor: "Floor 2"
                },
                {
                    id: 3,
                    floor: "Floor 3"
                },
                {
                    id: 4,
                    floor: "Floor 4"
                },
                {
                    id: 5,
                    floor: "Floor 5"
                },
                {
                    id: 6,
                    floor: "Floor 6"
                },
                {
                    id: 7,
                    floor: "Floor 7"
                },
                {
                    id: 8,
                    floor: "Floor 8"
                },
                {
                    id: 9,
                    floor: "Floor 9"
                },
                {
                    id: 10,
                    floor: "Floor 10"
                }
            ]
        },
        {
            "id": 2,
            "title": "Ignis Crucible",
            "environment": "Volcano, molten rivers",
            "enemies": ["Lava Wyrms", "Ember Shades", "Flame Golems"]
        },
        {
            "id": 3,
            "title": "Glacien Reach",
            "environment": "Frozen caverns, icy cliffs",
            "enemies": ["Frost Wolves", "Ice Wisps", "Snowbound Knights"]
        },
        {
            "id": 4,
            "title": "Zephyr Vault",
            "environment": "Floating islands, storm clouds",
            "enemies": ["Harpies", "Wind Djinn", "Sky Serpents"]
        },
        {
            "id": 5,
            "title": "Abyssal Spire",
            "environment": "Caverns, shadows, ruins",
            "enemies": ["Shades", "Soul Leeches", "Cursebound Armor"]
        },
        {
            "id": 6,
            "title": "Gravestone Crag",
            "environment": "Rocky cliffs, seismic ruins",
            "enemies": ["Stone Beetles", "Titan Kin", "Living Statues"]
        },
        {
            "id": 7,
            "title": "Aetherion Pinnacle",
            "environment": "Astral realm, magic circuits",
            "enemies": ["Spellwraiths", "Mana Wisps", "Arcane Sentinels"]
        },
        {
            "id": 8,
            "title": "Lumen Nexus",
            "environment": "Crystals, glowing halls",
            "enemies": ["Light Sentinels", "Radiant Golems", "Divine Shades"]
        },
        {
            "id": 9,
            "title": "Chrono Arx",
            "environment": "Shifting halls, time echoes",
            "enemies": ["Hourglass Knights", "Echo Revenants"]
        },
        {
            "id": 10,
            "title": "Umbracrest",
            "environment": "Warped mirrors, trick floors",
            "enemies": ["Doppelgangers", "Trick Spirits", "Puzzle Fiends"]
        }
    ];

    private var _charData:Object = {
        towers: {
            "1": [1,2],
            "2": [1,2,3,4,5]
        }
    };

    private var items:Array = [];
    private var isDragging:Boolean = false;
    private var dragStartX:Number;
    private var containerStartX:Number;
    private var currentIndex:int = 0;

    public function Towers() {
        addFrameScript(0, frameLists, 1, frameFloor);
    }

    private function frameLists():void {
        arrowLeft.buttonMode = arrowRight.buttonMode = true;
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
        items = [];

        for each (var o:Object in _data) {
            var item:TowerListItem = new TowerListItem();
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
        }

        highlightItem(currentIndex);
    }

    private function initListFloors() : void {
        game.onRemoveChildren(listFloors);

        var data:Object = _data[currentIndex];

        if (data == null) return;

        tEnv.text = data.environment;
        tDesc.text = data.description;
        tTower.text = data.title;

        for each (var o:Object in data.floors)
        {
            var item:FloorListItem = new FloorListItem();
            item.tName.text = String(o.floor);

            if (isFloorLocked(data.id, o.id))
            {
                item.tStatus.text = "Locked";
                item.lock.visible = true;
                item.ready.visible = false;
                item.tName.textColor = 0x666666;
            }
            else
            {
                item.tStatus.text = "Ready";
                item.lock.visible = false;
                item.ready.visible = true;
                item.tName.textColor = 0xFFFFFF;
            }

            item.check.visible = false;

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
