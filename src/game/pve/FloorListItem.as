package game.pve {
import flash.display.MovieClip;
import flash.text.TextField;

public class FloorListItem extends MovieClip {

    public var tName:TextField;
    public var tStatus:TextField;

    public var ready:MovieClip;
    public var lock:MovieClip;
    public var check:MovieClip;

    public function FloorListItem() {
        tName.mouseEnabled = false;
        tStatus.mouseEnabled = false;
        ready.visible = false;
        check.visible = false;
    }

}
}
