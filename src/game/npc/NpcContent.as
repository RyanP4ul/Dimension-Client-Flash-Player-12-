package game.npc {


import flash.display.MovieClip;
import flash.display.Shape;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.text.TextField;

public class NpcContent extends MovieClip {

    public var npcButton:NpcButton;
    private var content:Object;
    private var npcName:String;
    public var txtName:TextField;
    public var txtCat:TextField;
    public var txtDesc:TextField;
    public var lists:MovieClip;
    public var centerLists:MovieClip;
    public var scr:MovieClip;
    public var bg:MovieClip;
    public var mDown:Boolean;

    public function NpcContent(npcButton:NpcButton, npcName:String) {
        this.npcButton = npcButton;
        this.content = npcButton.content;
        this.npcName = npcName;

        initInterface();
        initDisplay();
    }

    private function initInterface():void {
        trace(JSON.stringify(content));
        txtName.text = npcName;
        txtCat.text = content.Category;
        txtDesc.text = content.Description;

        if (content.Entry == "Left") {
            bg.x = 715.9;
            scr.x = 885.4;
        } else {
            bg.x = 65.8;
            scr.x = 235.3;
        }

        var mask_shape:Shape = new Shape();
        mask_shape.graphics.beginFill(0);
        mask_shape.graphics.drawRect(bg.x, bg.y, bg.width, bg.height);
        mask_shape.graphics.endFill();
        addChild(mask_shape);

        lists = new MovieClip();
        lists.x = bg.x;
        lists.y = bg.y;
        addChild(lists);

        centerLists = new MovieClip();
        centerLists.y = 365;
        addChild(centerLists);

        lists.mask = mask_shape;
        lists.addEventListener(MouseEvent.MOUSE_WHEEL, onScroll, false, 0, true);
        bg.addEventListener(MouseEvent.MOUSE_WHEEL, onScroll, false, 0, true);
    }

    private function initDisplay():void {
        resetScroll();

        for each(var action:Object in content.Actions) {
            var cntButton:NpcContentButton = new NpcContentButton(npcButton, action);

            if (String(action.Position).toLowerCase() == "auto")
            {
                cntButton.y = lists.numChildren * 36;
                lists.addChild(cntButton);
            }
            else
            {
                cntButton.x = centerLists.numChildren * 167;
                centerLists.addChild(cntButton);
            }
        }

        centerLists.x = (960 - centerLists.width) / 2;

        initScroll();
    }

    public function resetScroll():void {
        scr.h.y = 0;
        lists.y = (this.bg.y + (this.scr.h.y * ((this.bg.height - this.lists.height) / 176)));
    }

    public function initScroll():void {
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

    private function onScroll(e:MouseEvent):void {
        if (lists.height < bg.height) {
            return;
        }
        e.delta = (e.delta * 6);
        lists.y = (lists.y + e.delta);
        if (lists.y >= bg.y) {
            lists.y = bg.y;
        }
        if (lists.y <= (bg.y + (bg.height - lists.height))) {
            lists.y = (bg.y + (bg.height - lists.height));
        }
        this.scr.h.y = ((lists.y - bg.y) / ((bg.height - lists.height) / 176));
    }

}

}
