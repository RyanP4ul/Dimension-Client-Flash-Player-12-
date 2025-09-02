package game.builder {

import flash.display.MovieClip;
import flash.events.Event;
import flash.events.MouseEvent;

dynamic public class MapMonster extends BuilderObjectDraggable {

    public var shadow:MovieClip;
    public var isMonster:Boolean;
    public var MonMapID:int;

    public function MapMonster() {
        SetBaseMc(shadow);
        isMonster = true;
        visible = game.mapBuilder.visible;
    }

}

}
