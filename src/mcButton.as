package {
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.text.TextField;

public class mcButton extends MovieClip {

    public var btn:SimpleButton;
    public var tName:TextField;

    public function mcButton() {
        tName.mouseEnabled = false;
    }
}

}
