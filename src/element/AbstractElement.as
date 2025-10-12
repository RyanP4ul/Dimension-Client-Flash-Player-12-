package element {
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.MouseEvent;

public class AbstractElement extends MovieClip {


    public var game:Game = Game.root;
    public var Type:String = "";

    public function AbstractElement() {
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    private function onAddedToStage(event:Event) : void {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        removeEventListener(MouseEvent.MOUSE_OVER, onTTOver);
        removeEventListener(MouseEvent.MOUSE_OUT, onTTOut);

        addEventListener(MouseEvent.MOUSE_OVER, onTTOver, false, 0, true);
        addEventListener(MouseEvent.MOUSE_OUT, onTTOut, false, 0, true);

        buttonMode = true;
    }

    private function onTTOver(event:MouseEvent) : void {
        game.ui.ToolTip.openWith({"str": Type + " Element"});
    }

    private function onTTOut(event:MouseEvent) : void {
        game.ui.ToolTip.close();
    }

}
}
