package game.builder {
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.MouseEvent;

import game.config.ConfigurationData;

dynamic public class BuilderObjectDraggable extends MovieClip {

    private var _baseMc:MovieClip;
    private var _drag:Object = {};
    private var _isLock:Boolean = false;
    public var game:Game = Game.root;
    public var form:MovieClip;

    public function BuilderObjectDraggable() {
        _baseMc = this;
        buttonMode = true;
        addEventListener(MouseEvent.MOUSE_DOWN, onMoveClick, false, 0, true);
    }

    public function SetBaseMc(baseMc:MovieClip) : void
    {
        _baseMc = baseMc;
    }

    public function onMoveClick(event:MouseEvent):void
    {
        _drag.ox = this.x;
        _drag.oy = this.y;
        _drag.mox = stage.mouseX;
        _drag.moy = stage.mouseY;
        stage.addEventListener(MouseEvent.MOUSE_UP, onMoveRelease, false, 0, true);
        addEventListener(Event.ENTER_FRAME, onMoveEnterFrame, false, 0, true);

        if (form == null) form = getChildByName("form") as MovieClip;
        if (form != null) _isLock = this.bLock;
    }

    public function onMoveRelease(_arg_1:MouseEvent) : void
    {
        stage.removeEventListener(MouseEvent.MOUSE_UP, onMoveRelease);
        this.removeEventListener(Event.ENTER_FRAME, onMoveEnterFrame);
    }

    public function onMoveEnterFrame(event:Event) : void
    {
        if (_isLock) return;

        x = (_drag.ox + (stage.mouseX - _drag.mox));

        if (x < 0) x = 0;
        if ((x + _baseMc.width) > game.world.mapWidth) x = (game.world.mapWidth - _baseMc.width);

        y = (_drag.oy + (stage.mouseY - _drag.moy));

        if (y < 0) y = 0;
        if ((y + _baseMc.height) > game.world.mapHeight) y = (game.world.mapHeight - _baseMc.height);

        if (form != null)
        {
//            if (x + form.width > ConfigurationData.CLIENT_WIDTH)
//            {
//                form.x = 50;
//                trace("FORM > 1");
//            }
//            else
//            {
//                form.x = 0;
//            }

            var inputX:BuilderInput = form.getChildByName("input-pos-x") as BuilderInput;
            if (inputX != null) inputX.tInput.text = x;

            var inputY:BuilderInput = form.getChildByName("input-pos-y") as BuilderInput;
            if (inputY != null) inputY.tInput.text = y;
        }

//        if (this is MapMining)
//        {
//            parent.x = x;
//            parent.y = y;
//        }
        if (this is MapMonster && this.MonMapID > 0)
        {
            var mon:Avatar = game.world.getMonster(this.MonMapID);

            if (mon != null && mon.pMC != null)
            {
                mon.pMC.x = x;
                mon.pMC.y = y;

                mon.pMC.ox = x;
                mon.pMC.oy = y;
            }
        }
        else if (this is MapNpc && this.NpcMapID > 0)
        {
            var npc:Avatar = game.world.getNpc(this.NpcMapID);

            if (npc != null && npc.pMC != null)
            {
                npc.pMC.x = x;
                npc.pMC.y = y;
            }
        }
    }

}
}
