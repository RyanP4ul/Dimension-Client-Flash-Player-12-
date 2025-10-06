package game.builder {
import flash.display.MovieClip;

dynamic public class MapProp extends BuilderObjectDraggable {

    public var shadow:MovieClip;
    public var isProp:Boolean = true;

    public function MapProp() {
        SetBaseMc(shadow);
        shadow.visible = game.mapBuilder.visible;
        mouseEnabled = false;
        mouseChildren = false;
    }

}

}
