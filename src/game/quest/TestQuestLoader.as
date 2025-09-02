package game.quest {
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

public class TestQuestLoader extends MovieClip {

    private var _mask:MovieClip;
    private var _lists:MovieClip;
    private var _scr:MovieClip;
    private var _mDown:Boolean;

    public function TestQuestLoader(mask:MovieClip, lists:MovieClip, scr:MovieClip)
    {
        _mask = mask;
        _lists = lists;
        _scr = scr;
    }

    public function reset() : void
    {
        _scr.h.y = 0;
        _lists.y = (_mask.y + (_scr.h.y * ((_mask.height - _lists.height) / 176)));
    }

    public function initScroll() : void
    {
        reset();

        if (_lists.height < _mask.height) {
            _scr.alpha = 0;
        } else {
            _scr.alpha = 1;
            _scr.hit.alpha = 0;

            _scr.hit.addEventListener(MouseEvent.MOUSE_DOWN, this.btnHold, false, 0, true);
            _scr.addEventListener(Event.ENTER_FRAME, this.onChange, false, 0, true);
            ((_lists.parent) as MovieClip).addEventListener(MouseEvent.MOUSE_WHEEL, onScroll, false, 0, true);
        }
    }

    private function btnHold(e:MouseEvent) : void {
        _mDown = true;
        Game.root.addEventListener(MouseEvent.MOUSE_UP, this.btnRelease, false, 0, true);
    }

    private function btnRelease(e:MouseEvent) : void {
        _mDown = false;
        Game.root.removeEventListener(MouseEvent.MOUSE_UP, this.btnRelease);
    }

    private function onChange(e:Event) : void {
        if (!_mDown || _lists.height < _mask.height) return;

        var point:Point = new Point(Game.root.mouseX, Game.root.mouseY);

        _scr.h.y = _scr.globalToLocal(point).y;

        if (_scr.h.y <= 0) {
            _scr.h.y = 0;
        }

        if (_scr.h.y + _scr.h.height > _scr.b.height) {
            _scr.h.y = _scr.b.height + _scr.h.height;
        }


        _lists.y = (_mask.y + (_scr.h.y * ((_mask.height - _lists.height) / 176)));
    }

    private function onScroll(e:MouseEvent) : void {
        if (_lists.height < _mask.height) return;

        e.delta = (e.delta * 6);
        _lists.y = (_lists.y + e.delta);

        if (_lists.y >= _mask.y) {
            _lists.y = _mask.y;
        }

        if (_lists.y <= (_mask.y + (_mask.height - _lists.height))) {
            _lists.y = (_mask.y + (_mask.height - _lists.height));
        }

        _scr.h.y = ((_lists.y - _mask.y) / ((_mask.height - _lists.height)));

        // scr b = 220
        // scr h = 38.5


    }

}
}
