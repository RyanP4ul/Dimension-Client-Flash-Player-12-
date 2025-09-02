// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//Game_fla.game_1_cnt_6

package Game_fla
{
import com.greensock.TweenLite;

import fl.motion.Color;

import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import flash.utils.Dictionary;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;
    import flash.events.MouseEvent;
    import flash.events.Event;
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

import game.builder.MapBuilder;
import game.builder.MapWalkable;
import game.config.ConfigurationData;
import game.handler.DisplayHandler;

import popup.Stats.StatsListItem;
import popup.Stats.StatsSubItem;

import test.Characters;

public dynamic class game_1_cnt_6 extends MovieClip
    {

        public var mcTitle:MovieClip;
        public var chkUserName:chkBox_32;
        public var chkPassword:chkBox_32;
        public var chkAutoLogin:chkBox_32;
        public var ni:TextField;
        public var pi:TextField;
        public var ModalStack:MovieClip;
        public var warning:MovieClip;
        public var mcLogo:MovieClip;
        public var btnLogin:SimpleButton;

        public function game_1_cnt_6()
        {
            addFrameScript(0, Init, 9, Characters, 15, CreateCharacter, 21, Test);
        }

        private function Init(): void
        {
            Game.root.initLogin();
            try
            {
                mcLogo.txtTitle.htmlText = ('<font color="#FFB231">New Release:</font> ' + Game.root.params.sTitle);
            }
            catch(e:Error)
            {
                trace("no sTitle");
            }
            stop();
        }



        private function Characters(): void { stop(); }
        private function CreateCharacter(): void { stop(); }

        private function Test(): void {
//            telegraphedAttack(250, 500, 2); // 2 sec delay

            var mc:MovieClip = new MovieClip();
            var shape:Shape = new Shape();
            var width:int = 50;
            var height:int = 50;

            shape.graphics.beginFill(0xFF0000, 0.5);
            shape.graphics.drawRect(-width / 2, -height / 2, width, height);
            shape.graphics.endFill();

            mc.x = 500;
            mc.y = 500;
            mc.addChild(shape);

            addChild(mc);

            stop();
        }

//        function createTelegraphCircle(radius:Number):Sprite {
//            var s:Sprite = new Sprite();
//            s.graphics.beginFill(0xFF0000, 0.4);
//            s.graphics.drawCircle(0, 0, radius);
//            s.graphics.endFill();
//            return s;
//        }
//
//        function telegraphedAttack(x:Number, y:Number, delay:Number):void {
//            var circle:Sprite =createTelegraphCircle(40);
//            circle.x = x;
//            circle.y = y;
//            circle.width = 50;
//            circle.height = 50;
//            circle.alpha = 0.1;
//            addChild(circle);
//
//            TweenLite.to(circle, 3.5, {
//                alpha: 0.5,
//                repeat: int(delay / 500) - 1,
//                yoyo: true,
//                onComplete: function():void {
//                    removeChild(circle);
//                }
//            });
//        }


    }
}//package Game_fla

