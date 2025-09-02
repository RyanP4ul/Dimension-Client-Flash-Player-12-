package game.builder {
import flash.display.MovieClip;

dynamic public class MapUnwalkable extends BuilderObjectDraggable {

    public var shadow:MovieClip;
    public var isSolid:Boolean = true;

    public function MapUnwalkable() {
        SetBaseMc(shadow);
        visible = game.mapBuilder.visible;
    }

}

}
