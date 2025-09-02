package game.builder {
import flash.display.MovieClip;
import flash.events.Event;

dynamic public class MapPassiveAgro extends BuilderObjectDraggable {

    public var shadow:MovieClip;
    public var strMonsters:Array = [];

    public function MapPassiveAgro() {
        SetBaseMc(shadow);
        visible = game.mapBuilder.visible;
        addEventListener(Event.ENTER_FRAME, onEnter, false, 0, true);
    }

    public function onEnter(event:Event):void
    {
        if (strMonsters.length < 1) return;

        var avt:Avatar;
        var aggro:Boolean = true;
        var i:int = 0;

        while (i < strMonsters.length && aggro)
        {
            avt = game.world.getMonster(strMonsters[i]);
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
