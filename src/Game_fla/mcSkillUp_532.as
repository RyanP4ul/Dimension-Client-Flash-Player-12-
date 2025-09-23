// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//Game_fla.mcSkillUp_532

package Game_fla
{
    import flash.display.MovieClip;
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

    public dynamic class mcSkillUp_532 extends MovieClip 
    {

        public var rootClass:Game = Game.root;
        public var c:int;
        public var t:int;

        public function mcSkillUp_532()
        {
            addFrameScript(0, frame1, 1, frame2, 10, frame11, 41, frame42);
        }

        public function fClose():void
        {
            this.gotoAndStop("reset");
            
            setTimeout(function () : void {
                rootClass.ui.removeChild(this);
            }, 2000);
        }

        public function onSkillUpClick(_arg_1:MouseEvent):void
        {
            rootClass.toggleCharStatspanel();
            fClose();
        }

        internal function frame1():*
        {
            this.visible = false;
            this.x = 1140;
            c = 0;
            t = 60;
            this.addEventListener(MouseEvent.CLICK, onSkillUpClick, false, 0, true);
            this.buttonMode = true;
            stop();
        }

        internal function frame2():*
        {
            visible = false;
            x = 1140;
            stop();
        }

        internal function frame11():*
        {
            visible = true;
            x = 1069;
            c = 0;
        }

        internal function frame42():*
        {
            if (++c < t)
            {
                this.gotoAndPlay((this.currentFrame - 1));
            }
            else
            {
                fClose();
            }
        }


    }
}//package Game_fla

