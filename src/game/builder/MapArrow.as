package game.builder {

import flash.display.MovieClip;

import game.builder.BuilderObjectDraggable;

dynamic public class MapArrow extends BuilderObjectDraggable {

    public var shadow:MovieClip;

    public function MapArrow() {
        SetBaseMc(shadow);
        shadow.gotoAndStop(1);
//        addFrameScript(0, arrow_1, 1, arrow_2, 2, arrow_3);
    }
//
//    private function arrow_1() : void { stop(); }
//    private function arrow_2() : void { stop(); }
//    private function arrow_3() : void { stop(); }

}
}
