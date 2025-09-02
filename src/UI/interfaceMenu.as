// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//interfaceMenu

package UI
{
import UI.Components.menuBottom;
import UI.Components.menuListItem;
import UI.Components.menuTop;

import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;

    public class interfaceMenu extends MovieClip 
    {

        public var mcMenu:MovieClip;
        private var currentPos:Number;
        private var h:Number = 25.2;
        private var w:Number = 118.25;
        public var btnOpen:String = "";
        private var game:Game = Game.root;

        public function interfaceMenu(buttons:Array, clicked:String)
        {
            var mc:MovieClip;
            var i:uint;
            super();
            btnOpen = clicked;
            mcMenu = new MovieClip();
            mc = (new menuBottom() as MovieClip);
            mc.height--;
            mc.width--;
            mc.x = (mc.x - 43);
            mc.y = (mc.y - 10.7);
            currentPos = (mc.y - 2);
            mcMenu.addChild(mc);
            mc = (new menuListItem() as MovieClip);
            mc.x = (mc.x + 17);
            mc.height = h;
            mc.width = w;
            mc.mTxt.text = buttons[0].txt;
            mc.y = ((currentPos - (h >> 1)) + 1);
            mc.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
            mc.buttonMode = true;
            mc.mouseChildren = false;
            mc.name = buttons[0].fct;
            currentPos = mc.y;
            mcMenu.addChild(mc);
            i = 1;
            while (i < (buttons.length - 1))
            {
                if (!buttons[i].hasOwnProperty("fct")) continue;

                mc = (new menuListItem() as MovieClip);
                mc.x = (mc.x + 17);
                mc.height = h;
                mc.width = w;
                mc.y = ((currentPos - h) + 1);
                currentPos = mc.y;
                mc.mTxt.text = buttons[i].txt;
                mc.addEventListener(MouseEvent.CLICK, buttons[i].fct, false, 0, true);
//                mc.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
                mc.buttonMode = true;
                mc.mouseChildren = false;
                mc.name = buttons[i].fct;
                mcMenu.addChild(mc);
                i++;
            };
            mc = (new menuTop() as MovieClip);
            mc.height--;
            mc.width--;
            mc.y = (currentPos - mc.height);
            mc.txt.text = buttons[(buttons.length - 1)].txt;
            mc.x = (mc.x + 17);
            mcMenu.addChild(mc);
        }

        private function onClick(_arg_1:MouseEvent):void
        {
            game.mixer.playSound("Click");

//            var _local_3:Function;
//            var _local_2:Array = _arg_1.currentTarget.name.split(".");
//            switch (_local_2.length)
//            {
//                case 1:
//                    _local_3 = this[_arg_1.currentTarget.name];
//                    break;
//                case 2:
//                    _local_3 = game[_local_2[1]];
//                    break;
//                case 3:
//                    _local_3 = game.world[_local_2[2]];
//                    break;
//            }
//            (_local_3());
        }

    }
}//package 

