package game.option {

import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.MouseEvent;
import flash.text.TextField;

public dynamic class OptionListItem extends MovieClip {

    public var tName:TextField;
    public var tStatus:TextField;
    public var btnLeft:SimpleButton;
    public var btnRight:SimpleButton;
    public var btnKey:SimpleButton;
    public var chkActive:MovieClip;
    public var bg:MovieClip;
    public var isSub:Boolean = false;

    public function OptionListItem()
    {
        btnKey.visible = false;
        btnLeft.visible = false;
        btnRight.visible = false;
        tName.mouseEnabled = false;
        tStatus.mouseEnabled = false;
        tStatus.mouseWheelEnabled = false;
    }

}

}
