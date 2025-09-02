package game.builder {
import flash.display.MovieClip;

dynamic public class MapNpc extends BuilderObjectDraggable {

    public var shadow:MovieClip;
    public var isNpc:Boolean = true;
    public var NpcMapID:int = -1;

    public function MapNpc() {
        SetBaseMc(shadow);
        visible = game.mapBuilder.visible;
    }

}

}
