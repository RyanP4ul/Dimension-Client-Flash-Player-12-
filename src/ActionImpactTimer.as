// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//ActionImpactTimer

package 
{
    import flash.events.EventDispatcher;
    import flash.utils.Timer;
    import flash.display.MovieClip;
    import flash.events.TimerEvent;
    import flash.events.*;

    public class ActionImpactTimer extends EventDispatcher 
    {

        internal var actID:int;
        internal var actionResult:Object;
        internal var aTimer:Timer;
        internal var world:World;


        public function showImpact(_arg_1:int):*
        {
            aTimer = new Timer(_arg_1, 1);
            aTimer.addEventListener(TimerEvent.TIMER, triggerResult, false, 0, true);
            aTimer.start();
        }

        public function kill():*
        {
            if (((!(aTimer == null)) && (aTimer.running)))
            {
                aTimer.stop();
            };
            aTimer.removeEventListener(TimerEvent.TIMER, triggerResult);
            aTimer = null;
            actionResult = null;
            world = null;
        }

        public function triggerResult(_arg_1:TimerEvent):*
        {
            world.showActionImpact(actionResult);
            kill();
        }


    }
}//package 

