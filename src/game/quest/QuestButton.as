package game.quest {
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.text.TextField;

public class QuestButton extends MovieClip {

    public var bg:MovieClip;
    public var fx:MovieClip;
    public var ti:TextField;

    public function QuestButton() {
        ti.mouseEnabled = false;
        fx.buttonMode = true;
    }
}
}
