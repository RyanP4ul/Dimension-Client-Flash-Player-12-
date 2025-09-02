package game.builder {
import flash.display.MovieClip;

dynamic public class MapMining extends BuilderObjectDraggable {

    public var shadow:MovieClip;
    public var isProp:Boolean = true;

    public function MapMining() {
        SetBaseMc(shadow);
    }

}
}
