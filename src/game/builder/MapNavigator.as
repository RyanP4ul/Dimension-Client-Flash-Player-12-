package game.builder {

import flash.display.MovieClip;
import flash.events.Event;

dynamic public class MapNavigator extends BuilderObjectDraggable {

    public var shadow:MovieClip;
    public var isEvent:Boolean = true;

    public var strNewMap:String;
    public var strSpawnCell:String;
    public var strSpawnPad:String;

    public function MapNavigator() {
        visible = game.mapBuilder.visible;
        SetBaseMc(shadow);
        addEventListener("enter", onEnter);
    }

    public function onEnter(event:Event) : void
    {
        game.showConfirmtaionBox("Head over to the " + strNewMap + " ?", done);
    }

    public function done(con:Boolean):void
    {
        if (con)
        {
            game.world.gotoTown(strNewMap, strSpawnCell, strSpawnPad);
        }
        else
        {
            trace("REJECTED!!!");
        }
    }

}
}
