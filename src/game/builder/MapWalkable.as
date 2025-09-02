package game.builder {

import flash.display.MovieClip;
import flash.events.MouseEvent;

dynamic public class MapWalkable extends MovieClip {

    public var btnWalkingArea:MovieClip;

    public function MapWalkable()
    {
        btnWalkingArea.addEventListener(MouseEvent.CLICK, this.walk);
        btnWalkingArea.useHandCursor = false;
        alpha = 0;
    }

    public function walk(event:MouseEvent) : void
    {
        MovieClip(parent.parent).onWalkClick();
    }

}
}
