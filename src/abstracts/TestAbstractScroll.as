package abstracts {
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

public class TestAbstractScroll extends MovieClip implements IScroll {

    public var cntMask:MovieClip;
    public var lists:MovieClip;
    public var scr:MovieClip;
    public var mDown:Boolean;

    public function TestAbstractScroll() {
        lists.addEventListener(MouseEvent.MOUSE_WHEEL, onScroll, false, 0, true);
    }

    public function resetScroll(): void
    {
        scr.h.y = 0;
        lists.y = (cntMask.y + (scr.h.y * ((cntMask.height - lists.height) / 176)));
    }

    public function initScroll(): void
    {
        if (lists.height < cntMask.height) {
            scr.alpha = 0;
        } else {
            scr.alpha = 1;
            scr.hit.alpha = 0;
            scr.hit.addEventListener(MouseEvent.MOUSE_DOWN, this.btnHold, false, 0, true);
            scr.addEventListener(Event.ENTER_FRAME, this.onChange, false, 0, true);
        }
    }

    private function btnHold(e:MouseEvent):void {
        mDown = true;
        MovieClip(stage.getChildAt(0)).addEventListener(MouseEvent.MOUSE_UP, this.btnRelease, false, 0, true);
    }

    private function btnRelease(e:MouseEvent):void {
        mDown = false;
        MovieClip(stage.getChildAt(0)).removeEventListener(MouseEvent.MOUSE_UP, this.btnRelease);
    }

    private function onChange(e:Event):void {
        if (!mDown || lists.height < cntMask.height) return;

        var point:Point = new Point(MovieClip(stage.getChildAt(0)).mouseX, MovieClip(stage.getChildAt(0)).mouseY);

        scr.h.y = scr.globalToLocal(point).y;

        if (scr.h.y <= 0) {
            scr.h.y = 0;
        }

        if (scr.h.y >= 176) {
            scr.h.y = 176;
        }

        lists.y = (cntMask.y + (scr.h.y * ((cntMask.height - lists.height) / 176)));
    }

    private function onScroll(e:MouseEvent):void {
        if (lists.height < cntMask.height) return;

        e.delta = (e.delta * 6);
        lists.y = (lists.y + e.delta);

        if (lists.y >= cntMask.y) {
            lists.y = cntMask.y;
        }

        if (lists.y <= (cntMask.y + (cntMask.height - lists.height))) {
            lists.y = (cntMask.y + (cntMask.height - lists.height));
        }

        scr.h.y = ((lists.y - cntMask.y) / ((cntMask.height - lists.height) / 176));
    }

}
}
