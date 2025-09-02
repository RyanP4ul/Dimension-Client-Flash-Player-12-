package game.builder {
import flash.display.MovieClip;
import flash.events.Event;

public class MapCollision extends BuilderObjectDraggable {

    public var shadow:MovieClip;

    public function MapCollision() {
        SetBaseMc(shadow);
        addEventListener("enter", onEnter);
    }

    private function onEnter(event:Event) : void {

    }

}

}
