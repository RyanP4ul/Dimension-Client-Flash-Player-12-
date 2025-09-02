package game.builder {
import flash.display.MovieClip;

dynamic public class MapPad extends BuilderObjectDraggable {

    public var shadow:MovieClip;

    public function MapPad() {
        SetBaseMc(shadow);
        visible = game.mapBuilder.visible;
    }

}
}
