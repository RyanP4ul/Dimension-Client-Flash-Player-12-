package {
import assets.ib2;

import flash.display.MovieClip;
import flash.text.TextField;

public dynamic class mcSkillListItem extends MovieClip {

    public var actIcon:ib2;
    public var tName:TextField;
    public var tSub:TextField;

    public function mcSkillListItem() {
        tName.mouseEnabled = false;
        tSub.mouseEnabled = false;
    }
}
}
