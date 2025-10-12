// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//CastBarMC

package UI
{
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.text.*;

    public class CastBarMC extends MovieClip 
    {

        public var cnt:MovieClip;
        public var o:Object = null;
        public var isOpen:Boolean = false;
        public var callback:Object = null;
        public var state:int = -1;
        public var dur:int = 1000;
        private var game:Game = Game.root;
        private var mc:MovieClip;
        private var run:int;
        private var ts:Number;
        private var date:Date;

        public function CastBarMC():void
        {
            addFrameScript(0, frame1, 4, frame5, 5, frame6, 9, frame10);
        }

        public function init():void
        {
            mc = MovieClip(this);
        }

        public function fOpenWith(_arg_1:Object):void
        {
            var l1:*;
            var l2:*;
            o = _arg_1;
            isOpen = true;
            switch (o.typ)
            {
                case "sia":
                    state = o.args.ID;
                case "generic":
                    mc.cnt.t1.text = o.txt;
                    l1 = mc.cnt.fill;
                    l2 = mc.cnt.fillMask;
                    l2.x = int((l1.x - l2.width));
                    run = int((l1.x - l2.x));
                    date = new Date();
                    ts = Number(date.getTime());
                    dur = int((1000 * o.dur));
                    l2.removeEventListener(Event.ENTER_FRAME, slide);
                    l2.addEventListener(Event.ENTER_FRAME, slide);
                    mc.cnt.tip.removeEventListener(Event.ENTER_FRAME, tipFollow);
                    mc.cnt.tip.addEventListener(Event.ENTER_FRAME, tipFollow);
                    mc.gotoAndPlay("in");
                    return;
            }
        }

        public function fClose():void
        {
            var _local_1:*;
            if (isOpen)
            {
                o = null;
                state = -1;
                isOpen = false;
                _local_1 = mc.cnt.fillMask;
                _local_1.removeEventListener(Event.ENTER_FRAME, slide);
                mc.cnt.tip.removeEventListener(Event.ENTER_FRAME, tipFollow);
                mc.gotoAndPlay("out");
                game.world.myAvatar.pMC.endAction();
            }
        }

        private function slide(event:Event):void
        {
            try {
                var bar:MovieClip = MovieClip(event.currentTarget);
                date = new Date();
                var len:Number = (date.getTime() - ts);
                var pc:Number = (len / dur);

                if (game.world.myAvatar.pMC.mcChar.onMove) // (game.world.mvTimerObj != null)
                {
                    mc.gotoAndPlay("out");
                    bar.removeEventListener(Event.ENTER_FRAME, slide);
                    mc.cnt.tip.removeEventListener(Event.ENTER_FRAME, tipFollow);
                    fClose();
                }
                else if (pc >= 1)
                {
                    if (o.hasOwnProperty("repeat") && Boolean(o.repeat))
                    {
                        date = new Date();
                        ts = date.getTime();
                        mc.gotoAndPlay("in");
                    }
                    else
                    {
                        mc.gotoAndPlay("out");
                        bar.removeEventListener(Event.ENTER_FRAME, slide);
                        mc.cnt.tip.removeEventListener(Event.ENTER_FRAME, tipFollow);
                        fClose();
                    }

                    fCallback();
                }
                else
                {
                    bar.x = ((mc.cnt.fill.x - mc.cnt.fillMask.width) + (run * pc));
                }
            } catch (e:Error) {
                if (bar.hasEventListener(Event.ENTER_FRAME))
                    bar.removeEventListener(Event.ENTER_FRAME, slide);
            }
        }

        private function tipFollow(event:Event):void
        {
            var tip:MovieClip = mc.cnt.tip;
            var l2:MovieClip = mc.cnt.fillMask;
            tip.x = ((l2.x + l2.width) - tip.width);
        }

        private function fCallback():void
        {
            if (o.msg != null) game.chatF.pushMsg("event", o.msg, "SERVER", "", 0);

            if (o.callback != null)
            {
                if (o.args != null)
                {
                    o.callback(o.args);
                }
                else
                {
                    o.callback();
                }
            }

            if (o.xtObj != null) game.net.send(o.xtObj.cmd, o.xtObj.args);
        }

        private function frame1() : void
        {
            cnt.visible = false;
            init();
            stop();
        }

        private function frame5() : void
        {
            cnt.visible = true;
            cnt.tip.visible = true;
        }

        private function frame6() : void
        {
            stop();
        }

        private function frame10() : void
        {
            cnt.tip.visible = false;
        }


    }
}//package 

