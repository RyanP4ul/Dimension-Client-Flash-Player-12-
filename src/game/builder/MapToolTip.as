package game.builder {

import UI.ToolTipMC;

import flash.display.MovieClip;
import flash.events.MouseEvent;

dynamic public class MapToolTip extends BuilderObjectDraggable {

    public var shadow:MovieClip;
    public var toolTip:ToolTipMC;

    public function MapToolTip() {
        SetBaseMc(shadow);
        alpha = game.mapBuilder.visible ? 1 : 0;
        toolTip = game.ui.ToolTip;
        shadow.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler, false, 0, true);
        shadow.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler, false, 0, true);
    }

    public function mouseOverHandler(event:MouseEvent) : void
    {
        toolTip.openWith( {"str": String(this.strMessage).replace("<c-name>", game.world.myAvatar.objData.strUsername) });
    }

    public function mouseOutHandler(event:MouseEvent) : void
    {
        toolTip.close();
    }

}

}
