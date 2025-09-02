package game.builder {
import flash.display.MovieClip;

dynamic public class MapZone extends BuilderObjectDraggable {

    public var shadow:MovieClip;

    public function MapZone() {
        visible = game.mapBuilder.visible;
        SetBaseMc(shadow);
    }

}

}
