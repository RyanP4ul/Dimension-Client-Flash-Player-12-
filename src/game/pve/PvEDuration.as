package game.pve {
import flash.display.MovieClip;
import flash.events.TimerEvent;
import flash.text.TextField;
import flash.utils.Timer;

public class PvEDuration extends MovieClip {

    private var game:Game = Game.root;
    private var countdownTime:int = 300;

    public var timer:Timer = null;
    public var tTimerDisplay:TextField;

    public function start(time:int) : void
    {
        this.countdownTime = time;

        timer = new Timer(1000, countdownTime);
        timer.removeEventListener(TimerEvent.TIMER, onTimer);
        timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
        timer.addEventListener(TimerEvent.TIMER, onTimer);
        timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
        timer.start();

        visible = true;
    }

    public function close() : void
    {
        if (timer != null)
        {
            timer.removeEventListener(TimerEvent.TIMER, onTimer);
            timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
            timer.stop();
            timer = null;
        }

        visible = false;
    }

    public function padZero(value:int):String {
        return (value < 10) ? "0" + value : value.toString();
    }

    private function onTimer(event:TimerEvent) : void
    {
        try
        {
            if (!game.world.isFloor) return;

            countdownTime--;
            tTimerDisplay.text = formatTime();
        }
        catch(e:Error)
        {
            close();
        }
    }

    public function formatTime():String {
        var minutes:int = Math.floor(countdownTime / 60);
        var secs:int = countdownTime % 60;
        return padZero(minutes) + ":" + padZero(secs);
    }

    private function onTimerComplete(event:TimerEvent) : void
    {
        tTimerDisplay.text = "Time Expired!";
        game.net.send("floorExpired", []);
    }

}

}
