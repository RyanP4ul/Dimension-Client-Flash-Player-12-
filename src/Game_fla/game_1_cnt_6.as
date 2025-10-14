// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//Game_fla.game_1_cnt_6

package Game_fla
{
import features.AnimationController;
import features.AnimationEvent;
import features._AnimationController;
import features.FloatingDisplayHandler;

import flash.display.Bitmap;

import flash.display.BitmapData;

import flash.display.Loader;

import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.*;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;
import flash.text.TextField;
import flash.utils.*;

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

        public var loaderD:ApplicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
        public var loaderC:LoaderContext = new LoaderContext(false, loaderD);

        private function Test(): void {
            Game.root.onLoadMaster(mapComplete, loaderC, ("maps/limbo/Limbo_r1.swf"), null, null);
            stop();
        }

        private function mapComplete(event:Event) : void {
            trace("map loaded");
            var map:MovieClip = MovieClip(Loader(event.target.loader).content);
            map.gotoAndStop("Enter");
            map.x = map.y = 0;

            var stageWidth:int = 900;
            var stageHeight:int = 500;
            var bmd:BitmapData = new BitmapData(stageWidth, stageHeight, true, 0x00000000);

            var cameraMatrix:Matrix = new Matrix();
            cameraMatrix.translate(map.x, map.y);

            bmd.draw(map, cameraMatrix, null, null, new Rectangle(0, 0, stageWidth, stageHeight), true);

            var bm:Bitmap = new Bitmap(bmd);

            addChild(bm);
        }

//        public var timer:Timer = new Timer(1000);
//        public var animController:AnimationController = new AnimationController(stage);
//
//        private function Test(): void {
//            loaderC.checkPolicyFile = false;
//            loaderC.allowCodeImport = true;
//
//            Game.root.onLoadMaster(onMonComplete, loaderC, "mon/Slimegreen.swf");
//
//            animController.addEventListener(AnimationController.ANIMATION_END, onAnimEnd);
//
//            stop();
//        }
//
//        function onAnimEnd(e:AnimationEvent):void
//        {
//            trace("Animation ended:", e.clip.name, "Label:", e.label);
////            animController.gotoAndPlay(e.clip, "Idle");
//        }
//
//        private function onMonComplete(event:Event) : void {
//            var assetClass:Class = loaderD.getDefinition("Slimegreen") as Class;
//            var mon:MovieClip = new (assetClass);
//            mon.x = 500;
//            mon.y = 350;
//            addChild(mon);
//
//            animController.addClip(mon, "Monster-1", 2.0);
//
//            timer.addEventListener(TimerEvent.TIMER, function (e:TimerEvent) : void {
//                var heal:sp_eh1 = new sp_eh1();
//                heal.x = 500;
//                heal.y = 350;
//                addChild(heal);
//                animController.addClip(heal, "Heal-1", 2.0);
//
//                animController.gotoAndPlay("Monster-1", "Attack1", true);
//            });
//
//            timer.start();
//        }

    }
}//package Game_fla

