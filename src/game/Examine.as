package game {

import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.MouseEvent;
import flash.text.TextField;

public class Examine extends MovieClip {

    private var mode:String;
    private var data:Object;

    public var tStats:TextField;
    public var tResistance:TextField;

    public var btnClose:SimpleButton;

    public function Examine(mode:String, data:Object)
    {
        this.mode = mode;
        this.data = data;

        btnClose.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);

        tStats.htmlText = (mode == "character" ? data.intLevel : data.iLvl) + "\n" + data.intHPMax + "\n" + data.intMPMax + "\n" + (mode == "character" ? int(data.tempSta.innate.STR + data.sta.$STR) + "\n" + int(data.tempSta.innate.INT + data.sta.$INT) + "\n" + int(data.tempSta.innate.DEX + data.sta.$DEX) + "\n" + int(data.tempSta.innate.LCK + data.sta.$LCK) : int(data.sta.$STR) + "\n" + int(data.sta.$INT) + "\n" + int(data.sta.$DEX) + "\n" + int(data.sta.$LCK));
        tResistance.htmlText = int(data.sta.$cai - data.sta.$cao) + "\n" + int(data.sta.$cpi - data.sta.$cpo) + "\n" + int(data.sta.$cmi - data.sta.$cmo) + "\n" + int(data.sta.$cdi - data.sta.$cdo);
    }

    public function onClick(event:MouseEvent) : void
    {
//        game.mixer.playSound("Click");

        switch (event.currentTarget.name) {
            case "btnClose":
                Game.root.mcExamine = null;
                parent.removeChild(this);
                break;
        }
    }

}

}
