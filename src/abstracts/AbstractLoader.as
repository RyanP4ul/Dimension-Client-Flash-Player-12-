package abstracts {

import flash.display.MovieClip;
import flash.display.Shape;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

public class AbstractLoader extends MovieClip {

    public var mDown:Boolean = false;
    public var lists:MovieClip;
    public var bg:MovieClip;
    private var _scr:MovieClip = null;

    public function AbstractLoader() {
        bg.alpha = 0;

        setChildIndex(bg, 0);

        var mask_shape:Shape = new Shape();
        mask_shape.graphics.beginFill(0);
        mask_shape.graphics.drawRect(bg.x, bg.y, bg.width, bg.height);
        mask_shape.graphics.endFill();
        addChildAt(mask_shape, 1);

        lists = new MovieClip();
        lists.x = bg.x // 694;
        lists.y = bg.y // 243.95;
        addChildAt(lists, 2);

        lists.mask = mask_shape;
    }

    public function get scr():MovieClip {
        return _scr;
    }

    public function set scr(scr:MovieClip):void {
        _scr = scr;
    }

    protected function resetScroll():void {
        scr.h.y = 0;
        lists.y = (bg.y + (scr.h.y * ((bg.height - lists.height) / 176)));
    }

    protected function initScroll():void {
        if (lists.height < this.bg.height) {
            scr.alpha = 0;
        } else {
            scr.alpha = 1;
            scr.hit.alpha = 0;
            scr.hit.addEventListener(MouseEvent.MOUSE_DOWN, this.btnHold, false, 0, true);
            scr.addEventListener(Event.ENTER_FRAME, this.onChange, false, 0, true);
        }
    }

    public function btnHold(e:MouseEvent):void {
        mDown = true;
        MovieClip(stage.getChildAt(0)).addEventListener(MouseEvent.MOUSE_UP, this.btnRelease, false, 0, true);
    }

    public function btnRelease(e:MouseEvent):void {
        mDown = false;
        MovieClip(stage.getChildAt(0)).removeEventListener(MouseEvent.MOUSE_UP, this.btnRelease);
    }

    public function onChange(e:Event):void {
        var point:Point;
        if (mDown) {
            if (lists.height < this.bg.height) {
                return;
            }

            point = new Point(MovieClip(stage.getChildAt(0)).mouseX, MovieClip(stage.getChildAt(0)).mouseY);

            scr.h.y = this.scr.globalToLocal(point).y;

            if (scr.h.y <= 0) {
                scr.h.y = 0;
            }

            if (scr.h.y >= 176) {
                scr.h.y = 176;
            }

            lists.y = (bg.y + (scr.h.y * ((bg.height - lists.height) / 176)));
        }
    }

    public function onScroll(e:MouseEvent):void {
        if (lists.height < bg.height) {
            return;
        }
        e.delta = (e.delta * 6);
        lists.y = (lists.y + e.delta);
        if (lists.y >=  bg.y) {
            lists.y =  bg.y;
        }
        if (lists.y <= ( bg.y + ( bg.height - lists.height))) {
            lists.y = ( bg.y + ( bg.height - lists.height));
        }
        this.scr.h.y = ((lists.y -  bg.y) / (( bg.height - lists.height) / 176));
    }

}
}
