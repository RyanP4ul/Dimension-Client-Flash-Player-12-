// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//Game_fla.mcMenu_286

package Game_fla
{
import UI.ToolTipMC;
import UI.interfaceMenu;

import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.events.MouseEvent;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.net.*;
    import flash.media.*;
    import flash.geom.*;
    import flash.system.*;
    import flash.utils.*;
    import flash.filters.*;
    import flash.external.*;
    import flash.ui.*;
    import adobe.utils.*;
    import flash.accessibility.*;
    import flash.errors.*;
    import flash.printing.*;
    import flash.profiler.*;
    import flash.sampler.*;
    import flash.xml.*;

    public dynamic class mcMenu_286 extends MovieClip 
    {

        public var btnQuest:MovieClip;
        public var btnRest:SimpleButton;
        public var btnHouse:SimpleButton;
        public var btnChar:MovieClip;
        public var btnMenu:SimpleButton;
        public var btnBook:SimpleButton;
        public var btnBag:SimpleButton;
        public var btnMap:SimpleButton;
        public var btnOption:SimpleButton;
        public var btnLoot:SimpleButton;
        public var menu:*;
		public var mcLootContainer:MovieClip;

        public function mcMenu_286()
        {
            addFrameScript(0, frame1);
        }

        public function onMouseOver(event:MouseEvent) : void
        {
            var tt:ToolTipMC = Game.root.ui.ToolTip;
            switch (event.currentTarget.name)
            {
                case "btnRest":
                    tt.openWith({"str":"Rest"});
                    return;
                case "btnBag":
                    tt.openWith({"str":"Inventory"});
                    return;
                case "btnTemp":
                    tt.openWith({"str":"Temp Inventory"});
                    return;
                case "btnMenu":
                    tt.openWith({"str":"Game Menu"});
                    return;
                case "btnMap":
                    tt.openWith({"str":"Map"});
                    return;
                case "btnOption":
                    tt.openWith({"str":"Options"});
                    return;
                case "btnQuest":
                    tt.openWith({"str":"Quests"});
                    return;
                case "btnBook":
                    tt.openWith({"str":"Book of Lore"});
                    return;
                case "btnHouse":
                    tt.openWith({"str":"House"});
                    return;
                case "btnLoot":
                    tt.openWith({"str":"Loot & Temporary"});
                    return;
                case "btnChar":
                    if (menu == null)
                    {
                        tt.openWith({"str":"Character"});
                    }
                    return;
            }
        }

        public function onMouseOut(event:MouseEvent) : void
        {
            Game.root.ui.ToolTip.close();
        }

        public function onMouseClick(event:MouseEvent) : void
        {
            var game:Game = Game.root;

            game.mixer.playSound("Click");
            if (event.currentTarget.name != "btnMenu")
            {
                game.menuClose();
            }
            switch (event.currentTarget.name)
            {
                case "btnRest":
                    handleMenu(null);
                    MovieClip(parent.parent.parent).world.rest();
                    return;
                case "btnBag":
                    handleMenu(null);
                    toggleInventory();
                    return;
                case "btnMenu":
                    handleMenu(null);
                    game.MenuShow();
                    return;
                case "btnMap":
                    if (game.ui.mcPopup.currentLabel == "Map")
                    {
                        game.ui.mcPopup.onClose();
                    }
                    else
                    {
                        handleMenu(null);
                        game.ui.mcPopup.fOpen("Map");
                    }
                    return;
                case "btnBook":
                    if (game.ui.mcPopup.currentLabel == "Book")
                    {
                        game.ui.mcPopup.onClose();
                    }
                    else
                    {
                        handleMenu(null);
                        game.ui.mcPopup.fOpen("Book");
                    }
                    return;
                case "btnOption":
                    if (game.ui.mcPopup.currentLabel == "Option")
                    {
                        game.ui.mcPopup.onClose();
                    }
                    else
                    {
                        handleMenu(null);
                        game.toggleOption();
                    }
                    return;
                case "btnQuest":
                    handleMenu(MovieClip(event.currentTarget));
                    return;
                case "btnHouse":
                    trace("btnHouse > 1");
                    if (game.world.isHouseEquipped())
                    {
                        trace("btnHouse > House Equipped");
                        game.world.gotoHouse(game.net.myUserName);
                    }
                    else
                    {
                        trace("btnHouse > No House");
                        game.world.gotoTown("buyhouse", "Enter", "Spawn");
                    }
                    return;
                case "btnLoot":
                    handleMenu(null);
                    toggleLootTemporary();
                    break;
                case "btnChar":
                    handleMenu(MovieClip(event.currentTarget));
                    return;
            }
        }

        public function handleMenu(_arg_1:MovieClip):void
        {
            var _local_2:MovieClip;
            if (_arg_1 == null)
            {
                if (menu == null)
                {
                    return;
                }
                _local_2 = MovieClip(this.getChildByName(menu.btnOpen));
                _local_2.removeChild(menu.mcMenu);
                menu = null;
                return;
            }
            if (menu == null)
            {
                menu = new interfaceMenu(_arg_1.buttons, _arg_1.name);
                _arg_1.addChild(menu.mcMenu);
            }
            else
            {
                if (((_arg_1 == null) || (menu.btnOpen == _arg_1.name)))
                {
                    _arg_1.removeChild(menu.mcMenu);
                    menu = null;
                }
                else
                {
                    _local_2 = MovieClip(this.getChildByName(menu.btnOpen));
                    _local_2.removeChild(menu.mcMenu);
                    menu = null;
                    menu = new interfaceMenu(_arg_1.buttons, _arg_1.name);
                    _arg_1.addChild(menu.mcMenu);
                }
            }
        }

        public function toggleTempInventory():void
        {
            var _local_1:* = MovieClip(stage.getChildAt(0));
            if (!_local_1.world.uiLock)
            {
                if (_local_1.ui.mcPopup.currentLabel == "Temp")
                {
                    _local_1.ui.mcPopup.onClose();
                }
                else
                {
                    _local_1.ui.mcPopup.fOpen("Temp");
                }
            }
        }

        public function toggleInventory():void
        {
            var _local_1:* = MovieClip(stage.getChildAt(0));
            if (!_local_1.world.uiLock)
            {
                if (_local_1.ui.mcPopup.currentLabel == "Inventory")
                {
                    MovieClip(_local_1.ui.mcPopup.getChildByName("mcInventory")).fClose();
                }
                else
                {
                    _local_1.ui.mcPopup.fOpen("Inventory");
                }
            }
        }

        public function toggleLootTemporary():void
        {
            var _local_1:* = MovieClip(stage.getChildAt(0));
            if (!_local_1.world.uiLock)
            {
                if (_local_1.ui.mcPopup.currentLabel == "Loot")
                {
                    MovieClip(_local_1.ui.mcPopup.getChildByName("mcLoot")).fClose();
                }
                else
                {
                    _local_1.ui.mcPopup.fOpen("Loot");
                }
            }
        }

        private function frame1() : void
        {
			mcLootContainer.visible = false;
            btnRest.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            btnRest.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
            btnBag.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            btnBag.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
            btnMenu.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            btnMenu.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
            btnMap.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            btnMap.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
            btnOption.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            btnOption.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
            btnQuest.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            btnQuest.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
            btnRest.addEventListener(MouseEvent.CLICK, onMouseClick);
            btnBag.addEventListener(MouseEvent.CLICK, onMouseClick);
            btnMenu.addEventListener(MouseEvent.CLICK, onMouseClick);
            btnOption.addEventListener(MouseEvent.CLICK, onMouseClick);
            btnMap.addEventListener(MouseEvent.CLICK, onMouseClick);
            btnQuest.addEventListener(MouseEvent.CLICK, onMouseClick);
            btnBook.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            btnBook.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
            btnBook.addEventListener(MouseEvent.CLICK, onMouseClick);
            btnHouse.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            btnHouse.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
            btnHouse.addEventListener(MouseEvent.CLICK, onMouseClick);
            btnLoot.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            btnLoot.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
            btnLoot.addEventListener(MouseEvent.CLICK, onMouseClick);
            btnChar.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            btnChar.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
            btnChar.addEventListener(MouseEvent.CLICK, onMouseClick);
        }


    }
}//package Game_fla

