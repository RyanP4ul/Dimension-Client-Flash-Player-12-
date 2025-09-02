package game.builder {

import flash.display.MovieClip;
import flash.events.Event;

dynamic public class MapNavigation extends BuilderObjectDraggable {

    public var shadow:MovieClip;
    public var isEvent:Boolean = true;

    public var tCell:String;
    public var tPad:String;

    public function MapNavigation() {
        SetBaseMc(shadow);
        visible = game.mapBuilder.visible;
        addEventListener("enter", onEnter);
    }

    private function onEnter(event:Event) : void {
        game.world.moveToCell(tCell, tPad);
    }

}

}
