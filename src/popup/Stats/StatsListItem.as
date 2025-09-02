package popup.Stats {

import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.text.TextField;

dynamic public class StatsListItem extends MovieClip {

    public var tName:TextField;
    public var tValue:TextField;
    public var oValue:int;
    public var iValue:int;
    public var isHide:Boolean = true;

    public var select:MovieClip;
    public var subLists:MovieClip;

    public var bIncrease:SimpleButton;
    public var bDecrease:SimpleButton;

    public function StatsListItem() {
        tName.mouseEnabled = false;
        tValue.mouseEnabled = false;
        tValue.text = "0";

        select.visible = false;

        subLists = new MovieClip();
        subLists.visible = !isHide;
        subLists.y = height;
        addChild(subLists);
    }

}

}
