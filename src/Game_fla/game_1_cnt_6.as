// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//Game_fla.game_1_cnt_6

package Game_fla
{
import features.AnimationController;
import features.AnimationEvent;
import features._AnimationController;
import features.FloatingDisplayHandler;

import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.*;
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

        public var timer:Timer = new Timer(1000);
        public var loaderD:ApplicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
        public var loaderC:LoaderContext = new LoaderContext(false, loaderD);
        public var animController:AnimationController = new AnimationController(stage);

        private function Test(): void {
            loaderC.checkPolicyFile = false;
            loaderC.allowCodeImport = true;

            Game.root.onLoadMaster(onMonComplete, loaderC, "mon/Slimegreen.swf");

            animController.addEventListener(AnimationController.ANIMATION_END, onAnimEnd);

            stop();
        }

        function onAnimEnd(e:AnimationEvent):void
        {
            trace("Animation ended:", e.clip.name, "Label:", e.label);
//            animController.gotoAndPlay(e.clip, "Idle");
        }

        private function onMonComplete(event:Event) : void {
            var assetClass:Class = loaderD.getDefinition("Slimegreen") as Class;
            var mon:MovieClip = new (assetClass);
            mon.x = 500;
            mon.y = 350;
            addChild(mon);

            animController.addClip(mon, "Monster-1", 2.0);

            timer.addEventListener(TimerEvent.TIMER, function (e:TimerEvent) : void {
                var heal:sp_eh1 = new sp_eh1();
                heal.x = 500;
                heal.y = 350;
                addChild(heal);
                animController.addClip(heal, "Heal-1", 2.0);

                animController.gotoAndPlay("Monster-1", "Attack1", true);
            });

            timer.start();
        }

    }
}//package Game_fla

