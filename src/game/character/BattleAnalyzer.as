package game.character {
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;

public class BattleAnalyzer extends MovieClip {

    public var btnClose:SimpleButton;
    public var btnStart:SimpleButton;
    public var txtValues:TextField;
    public var txtStart:TextField;

    private var startTime:Number;
    private var seconds:Number = 0;
    private var _running:Boolean = false;
    private var dmg:Number = 0;
    private var heal:Number = 0;
    private var dmgRecv:Number = 0;
    private var copper:Number = 0;
    private var silver:Number = 0;
    private var gold:Number = 0;
    private var xp:Number = 0;
    private var kills:Number = 0;

    public function BattleAnalyzer()
    {
        btnStart.addEventListener(MouseEvent.CLICK, onStart, false, 0, true);
        txtStart.mouseEnabled = false;
        addEventListener(MouseEvent.MOUSE_DOWN, onDrag, false, 0, true);
        addEventListener(MouseEvent.MOUSE_UP, onStopDrag, false, 0, true);
        btnClose.addEventListener(MouseEvent.CLICK, onBtnClose, false, 0, true);
    }

    public function onBattleTimer(event:Event):void
    {
        seconds = Math.round((Math.abs((startTime - new Date().getTime())) / 1000));
        updateDisplay();
    }

    public function updateDisplay():void
    {
        var dmgPerSec:String = addCommas(Math.round(dmg / seconds)) + "/sec";
        var healPerSec:String = addCommas(Math.round(heal / seconds)) + "/sec";
        var dmgRecvPerSec:String = addCommas(Math.round(dmgRecv / seconds)) + "/sec";
        var copperPerSec:String = addCommas(Math.round(copper / seconds)) + "/sec";
        var silverPerSec:String = addCommas(Math.round(silver / seconds)) + "/sec";
        var goldPerSec:String = addCommas(Math.round(gold / seconds)) + "/sec";
        var xpPerSec:String = addCommas(Math.round(xp / seconds)) + "/sec";
        var killsPerMin:String = (seconds == 0) ? "0" : Number((kills / (seconds / 60))).toFixed(2) + "/min";

        txtValues.text = formatSeconds() + "\n" +
                addCommas(dmg) + " (" + dmgPerSec + ")\n" +
                addCommas(heal) + " (" + healPerSec + ")\n" +
                addCommas(dmgRecv) + " (" + dmgRecvPerSec + ")\n" +
                addCommas(copper) + " (" + copperPerSec + ")\n" +
                addCommas(silver) + " (" + silverPerSec + ")\n" +
                addCommas(gold) + " (" + goldPerSec + ")\n" +
                addCommas(xp) + " (" + xpPerSec + ")\n" +
                addCommas(kills) + " (" + killsPerMin + ")";
//        txtValues.text = ((((((((((((((((((formatSeconds() + "\n") + addCommas(dmg)) + ((" (" + addCommas(Math.round((dmg / seconds)))) + "/sec)")) + "\n") + addCommas(heal)) + ((" (" + addCommas(Math.round((heal / seconds)))) + "/sec)")) + "\n") + addCommas(dmgRecv)) + ((" (" + addCommas(Math.round((dmgRecv / seconds)))) + "/sec)")) + "\n") + addCommas(gold)) + ((" (" + addCommas(Math.round((gold / seconds)))) + "/sec)")) + "\n") + addCommas(xp)) + ((" (" + addCommas(Math.round((xp / seconds)))) + "/sec)")) + "\n") + addCommas(kills)) + ((" (" + ((seconds == 0) ? "0" : Number((kills / (seconds / 60))).toFixed(2))) + "/min)"));
    }

    public function addCommas(num:uint):String
    {
        if (num == 0) return "0";

        var _local_4:uint;
        var _local_2:* = "";
        var _local_3:uint = num;
        while (_local_3 > 0)
        {
            _local_4 = (_local_3 % 1000);
            _local_2 = ((((_local_3 > 999) ? ("," + ((_local_4 < 100) ? ((_local_4 < 10) ? "00" : "0") : "")) : "") + _local_4) + _local_2);
            _local_3 = uint((_local_3 / 1000));
        }
        return (_local_2);
    }

    public function get isRunning() : Boolean
    {
        return (_running);
    }

    public function formatSeconds():String
    {
        var _local_1:* = Math.floor((seconds / 3600));
        var _local_2:* = Math.floor(((seconds % 3600) / 60));
        var _local_3:* = (seconds % 60);
        if (_local_1 < 10)
        {
            _local_1 = ("0" + _local_1);
        }
        if (_local_2 < 10)
        {
            _local_2 = ("0" + _local_2);
        }
        if (_local_3 < 10)
        {
            _local_3 = ("0" + _local_3);
        }
        return ((((_local_1 + ":") + _local_2) + ":") + _local_3);
    }

    public function addDamage(_arg_1:Number):void
    {
        dmg = (dmg + _arg_1);
    }

    public function addHeal(_arg_1:Number):void
    {
        heal = (heal + _arg_1);
    }

    public function addReceived(_arg_1:Number):void
    {
        dmgRecv = (dmgRecv + _arg_1);
    }

    public function addCopper(num:Number):void
    {
        copper += num;
    }

    public function addSilver(num:Number):void
    {
        silver += num;
    }

    public function addGold(num:Number):void
    {
        gold += num;
    }

    public function addExp(_arg_1:Number):void
    {
        xp = (xp + _arg_1);
    }

    public function addKill():void
    {
        kills = (kills + 1);
    }

    public function reset():void
    {
        startTime = new Date().getTime();
        seconds = 0;
        dmg = 0;
        heal = 0;
        dmgRecv = 0;
        gold = 0;
        xp = 0;
        kills = 0;
        updateDisplay();
    }

    public function toggle():void
    {
        btnStart.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
    }

    public function onStart(_arg_1:MouseEvent):void
    {
        if (_running)
        {
            removeEventListener(Event.ENTER_FRAME, onBattleTimer);
        }
        else
        {
            reset();
            addEventListener(Event.ENTER_FRAME, onBattleTimer, false, 0, true);
        }

        _running = (!(_running));
        txtStart.text = ((_running) ? "Stop" : "Start");
    }

    public function onBtnClose(_arg_1:MouseEvent):void
    {
        removeEventListener(Event.ENTER_FRAME, onBattleTimer);
        Game.root.bAnalyzer = null;
        parent.removeChild(this);
    }

    public function onDrag(_arg_1:MouseEvent):void
    {
        startDrag();
    }

    public function onStopDrag(_arg_1:MouseEvent):void
    {
        stopDrag();
    }

}

}
