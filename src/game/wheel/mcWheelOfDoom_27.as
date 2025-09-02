// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//town_fla.mcWheelOfDoom_27

package game.wheel
{

    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.events.MouseEvent;
import flash.text.TextField;

import game.config.ConfigurationData;

public dynamic class mcWheelOfDoom_27 extends MovieClip
    {

        private var game:Game = Game.root;

        public var tTicket:TextField;

        public var btnWheel:SimpleButton;
        public var btnClose:SimpleButton;

        public var btnLever:MovieClip;
        public var mcWheel:MovieClip;

        public var bHasItem:Boolean;
        public var bIsMember:Boolean;
        public var bCooldown:Boolean;

        public var sFrame:String = null;

        public function mcWheelOfDoom_27()
        {
            addFrameScript(0, frame1, 7, frame8, 8, frame9, 9, frame10, 10, frame11, 11, frame12, 12, frame13, 13, frame14, 14, frame15, 15, frame16, 17, frame18, 19, frame20, 21, frame22, 23, frame24, 25, frame26, 27, frame28, 29, frame30, 31, frame32, 32, frame33, 33, frame34, 35, frame36, 36, frame37, 38, frame39, 42, frame43, 50, frame51, 57, frame58, 68, frame69);
            btnClose.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
            update();
        }

        private function onClick(event:MouseEvent) : void
        {
            MovieClip(parent).onClose();
        }

        public function update() : void {
            var item:Object = game.world.myAvatar.getItemByID(ConfigurationData.WHEEL_FORTUNE_TICKET_ITEM_ID);
            tTicket.text = item != null ? item.iQty : "0";
        }

        public function onButtonPress(_arg_1:MouseEvent):void
        {
            if (!bCooldown)
            {
                bHasItem = false;

                if (hasItem(ConfigurationData.WHEEL_FORTUNE_TICKET_ITEM_ID))
                {
                    bHasItem = true;
                    bCooldown = true;
					
					game.net.send("wheel", []);
                }
                else
                {
                    game.MsgBox.notify("You need a Fortune Ticket to spin for Amazing Prizes!");
                }
            }
            else
            {
                game.mixer.playSound("Bad");
                game.addUpdate("Swaggy: Slow down! One spin at a time.");
            }
        }

        public function hasItem(itemId:int) : Boolean
        {
            if (game.world.myAvatar.isItemInInventory(itemId))
            {
                var item:Object = game.world.myAvatar.getItemByID(itemId);
                bHasItem = item.iQty >= 1;
            }
            else
            {
                bHasItem = false;
            }

            return (bHasItem);
        }

        private function frame1() : void
        {
            bIsMember = game.world.myAvatar.isUpgraded();
            bCooldown = false;
            btnLever.addEventListener(MouseEvent.MOUSE_DOWN, onButtonPress, false, 0, true);
            btnWheel.addEventListener(MouseEvent.MOUSE_DOWN, onButtonPress, false, 0, true);
            stop();
        }

        private function frame8() : void
        {
            game.mixer.playSound("Click");
        }

        private function frame9() : void
        {
            game.mixer.playSound("Click");
        }

        private function frame10() : void
        {
            game.mixer.playSound("Click");
        }

        private function frame11() : void
        {
            game.mixer.playSound("Click");
        }

        private function frame12() : void
        {
            game.mixer.playSound("Click");
        }

        private function frame13() : void
        {
            game.mixer.playSound("Click");
        }

        private function frame14() : void
        {
            game.mixer.playSound("Click");
        }

        private function frame15() : void
        {
            game.mixer.playSound("Click");
        }

        private function frame16() : void
        {
            game.mixer.playSound("Click");
        }

        private function frame18() : void
        {
            game.mixer.playSound("Click");
        }

        private function frame20() : void
        {
            game.mixer.playSound("Click");
        }

        private function frame22() : void
        {
            game.mixer.playSound("Click");
        }

        private function frame24() : void
        {
            game.mixer.playSound("Click");
        }

        private function frame26() : void
        {
            game.mixer.playSound("Click");
        }

        private function frame28() : void
        {
            game.mixer.playSound("Click");
        }

        private function frame30() : void
        {
            game.mixer.playSound("Click");
        }

        private function frame32() : void
        {
            game.mixer.playSound("Click");
        }

        private function frame33() : void
        {
//            if (game.world.map.sFrame == undefined)
//            {
//                trace("lag looping");
//                gotoAndPlay(11);
//            }
//            else
//            {
//                objReward = game.world.map.objReward;
//                sFrame = game.world.map.sFrame;
//                trace(("sFrame: " + sFrame));
//            }
//            var frames:Array = ["Potion", "Class", "Cape", "Helm", "Treasure", "Gold", "Weapon", "Armor"];
//
//            sFrame = frames[Math.floor(Math.random() * frames.length)];

            trace("sFrame => " + sFrame);
        }

        private function frame34() : void
        {
            game.mixer.playSound("Click");
        }

        private function frame36() : void
        {
            game.mixer.playSound("Click");
        }

        private function frame37() : void
        {
            mcWheel.gotoAndPlay(sFrame);
        }

        private function frame39() : void
        {
            game.mixer.playSound("Click");
        }

        private function frame43() : void
        {
            game.mixer.playSound("Click");
        }

        private function frame51() : void
        {
            game.mixer.playSound("Click");
        }

        private function frame58() : void
        {
            btnLever.gotoAndPlay("Closing");
        }

        private function frame69() : void
        {
            bCooldown = false;

//            if (objReward != null)
//            {
//                game.showItemDrop(objReward, false);
//                game.showItemDrop(game.world.map.prize1, false);
//                game.showItemDrop(game.world.map.prize2, false);
//            }
//            else
//            {
//                game.showItemDrop(game.world.map.prize1, false);
//                game.showItemDrop(game.world.map.prize2, false);
//            }
//
//            game.world.map.sFrame = (sFrame = null);
//            game.world.map.objReward = (objReward = null);

            gotoAndStop("Init");
        }


    }
}//package town_fla

