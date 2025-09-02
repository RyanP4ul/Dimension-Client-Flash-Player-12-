package game.builder {

import flash.display.MovieClip;
import flash.events.Event;

dynamic public class MapAggro extends BuilderObjectDraggable {

    public var shadow:MovieClip;
    public var isEvent:Boolean = true;
    public var strMonsters:Array = [];

    public function MapAggro() {
        SetBaseMc(shadow);
        visible = game.mapBuilder.visible;
        addEventListener("enter", onEnter);
    }

    private function onEnter(event:Event) : void {
        if (strMonsters.length < 1) return;

        var aggro:Boolean = true;
        var i:int = 0;

        while (i < strMonsters.length && aggro)
        {
            var avt:Avatar = game.world.getMonster(strMonsters[i]);
            if (avt.pMC == null)
            {
                aggro = false;
            }
            i++;
        }

        if (aggro)
        {
            game.world.aggroMons(strMonsters);
            removeEventListener(Event.ENTER_FRAME, onEnter);
        }
    }

}

}
