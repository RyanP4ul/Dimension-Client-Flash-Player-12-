package popup.Stats {
import flash.display.MovieClip;
import flash.text.TextField;

dynamic public class StatsSubItem extends MovieClip {

    public var tStatName:TextField;
    public var tValue:TextField;

    public var stat:String;

    public function StatsSubItem() {
        tStatName.mouseEnabled = false;
        tValue.mouseEnabled = false;
    }

}

}
