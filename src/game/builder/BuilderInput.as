package game.builder {
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.text.TextField;

public class BuilderInput extends MovieClip {

    public var tLabel:TextField;
    public var tInput:TextField;
    public var btnLeft:SimpleButton;
    public var btnRight:SimpleButton;

    public function BuilderInput() {
        btnLeft.visible = false;
        btnRight.visible = false;
        tLabel.mouseEnabled = false;
    }

}

}
