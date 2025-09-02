// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//LPFFrameSimpleList

package UI.LPF.Frame
{
import UI.LPF.Element.LPFElementSimpleItem;

import flash.display.MovieClip;
import flash.display.Shape;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
    import flash.display.DisplayObject;
    import flash.text.*;

    public class LPFFrameSimpleList extends LPFFrame 
    {

        public var bg:MovieClip;
        public var iList:MovieClip;
        public var ti:TextField;
        private var game:Game;
        private var r:Object;
        public var maskMC:Shape;
        public var scrollMC:LPFFrameScroll;
        public var mDown:Boolean = false;
        public var hRun:int = 0;
        public var dRun:int = 0;
        public var mbY:int = 0;
        public var mhY:int = 0;
        public var mbD:int = 0;

        public function LPFFrameSimpleList():void
        {
            x = 0;
            y = 0;
            fData = null;
        }

        override public function fOpen(_arg_1:Object):void
        {
            trace("simple list opened");
            game = Game.root;
            if (("fData" in _arg_1))
            {
                fData = _arg_1.fData;
            }
            r = _arg_1.r;
            w = int(r.w);
            ti.autoSize = "left";
            if (("eventTypes" in _arg_1))
            {
                eventTypes = _arg_1.eventTypes;
            }
            if ((("msg" in fData) && (fData.msg.length > 0)))
            {
                ti.htmlText = fData.msg;
            }
            fDraw();
            positionBy(r);
            getLayout().registerForEvents(this, eventTypes);
        }

        override public function fClose():void
        {
            fData = null;
            getLayout().unregisterFrame(this);
            if (parent != null)
            {
                parent.removeChild(this);
            }
        }

        private function fDraw():void
        {
            var simpleItem:LPFElementSimpleItem;
            var child:DisplayObject;
            var prevChild:DisplayObject;
            var items:Array;
            var item:Object;
            var i:int;
            while (iList.numChildren > 0)
            {
                iList.removeChildAt(0);
            }
            if (scrollMC)
            {
                scrollMC.visible = false;
                scrollMC.h.y = 0;
                iList.y = 0;
                bg.height = (iList.height + 1);
                ti.y = (bg.height + 2);
                scrollMC.hit.removeEventListener(MouseEvent.MOUSE_DOWN, merge_scrDown);
                scrollMC.h.removeEventListener(Event.ENTER_FRAME, merge_hEF);
                iList.removeEventListener(Event.ENTER_FRAME, merge_dEF);
                removeEventListener(MouseEvent.MOUSE_WHEEL, onMergeBoxScroll);
                removeChild(scrollMC);
                removeChild(maskMC);
                scrollMC = null;
                maskMC = null;
                iList.mask = null;
            }
            if (fData != null && fData.turnin != null)
            {
                items = fData.turnin;
                i = 0;
                while (i < items.length)
                {
                    item = items[i];
                    simpleItem = new LPFElementSimpleItem();
                    child = iList.addChild(simpleItem);
                    simpleItem.fOpen({"fData":item});
                    if (i > 0)
                    {
                        prevChild = iList.getChildAt((i - 1));
                        child.y = ((prevChild.y + prevChild.height) + 4);
                    }
                    child.x = int(((w / 2) - (child.width / 2)));
                    i++;
                }
                bg.height = (int((iList.height + (iList.y * 2))) + 1);
                bg.width = int(w);
                ti.width = int((w - 2));
                if (ti.htmlText.length > 0)
                {
                    ti.y = (bg.height + 2);
                    ti.visible = true;
                }
                else
                {
                    ti.visible = false;
                }
                visible = true;
                if (items.length >= 5)
                {
                    bg.height = 166;
                    maskMC = new Shape();
                    maskMC.graphics.beginFill(0);
                    maskMC.graphics.drawRect(0, 0, bg.width, bg.height);
                    maskMC.graphics.endFill();
                    addChild(maskMC);
                    maskMC.name = "maskMC";
                    maskMC.x = bg.x;
                    maskMC.y = bg.y;
                    iList.mask = maskMC;
                    scrollMC = new LPFFrameScroll();
                    addChild(scrollMC);
                    scrollMC.name = "scrollMC";
                    scrollMC.x = ((bg.x + bg.width) - (scrollMC.width / 2));
                    scrollMC.y = (bg.y + 5);
                    scrollMC.height = (bg.height - 10);
                    scrollMC.h.height = (scrollMC.h.height / 2);
                    hRun = (scrollMC.b.height - scrollMC.h.height);
                    dRun = (((int((iList.height + (iList.y * 2))) + 1) - maskMC.height) + 5);
                    scrollMC.h.y = 0;
                    iList.y = 0;
                    iList.oy = iList.y;
                    scrollMC.hit.alpha = 0;
                    mDown = false;
                    scrollMC.hit.addEventListener(MouseEvent.MOUSE_DOWN, merge_scrDown, false, 0, true);
                    scrollMC.h.addEventListener(Event.ENTER_FRAME, merge_hEF, false, 0, true);
                    iList.addEventListener(Event.ENTER_FRAME, merge_dEF, false, 0, true);
                    ti.y = (bg.height + 2);
                    addEventListener(MouseEvent.MOUSE_WHEEL, onMergeBoxScroll, false, 0, true);
                }
            }
            else
            {
                visible = false;
            }
        }

        override public function notify(_arg_1:Object):void
        {
            if (_arg_1.eventType == "listItemASel")
            {
                fData = null;
                if (((!(_arg_1.fData == null)) && (!(_arg_1.fData.oSel == null))))
                {
                    fData = _arg_1.fData.oSel;
                }
                fDraw();
                positionBy(r);
            }
            if (_arg_1.eventType == "refreshItems")
            {
                fDraw();
                positionBy(r);
            }
            if (_arg_1.eventType == "updateQtyValue")
            {
                fDraw();
                positionBy(r);
            }
        }

        private function merge_scrDown(param1:MouseEvent):*
        {
            mbY = int(param1.currentTarget.parent.mouseY);
            mhY = int(MovieClip(param1.currentTarget.parent).h.y);
            mDown = true;
            game.stage.addEventListener(MouseEvent.MOUSE_UP, merge_scrUp, false, 0, true);
        }

        private function merge_scrUp(param1:MouseEvent):*
        {
            mDown = false;
            game.stage.removeEventListener(MouseEvent.MOUSE_UP, merge_scrUp);
        }

        private function merge_hEF(param1:Event):*
        {
            var _loc2_:* = undefined;
            if (mDown)
            {
                _loc2_ = MovieClip(param1.currentTarget.parent);
                mbD = (int(param1.currentTarget.parent.mouseY) - mbY);
                _loc2_.h.y = (mhY + mbD);
                if ((_loc2_.h.y + _loc2_.h.height) > _loc2_.b.height)
                {
                    _loc2_.h.y = int((_loc2_.b.height - _loc2_.h.height));
                }
                if (_loc2_.h.y < 0)
                {
                    _loc2_.h.y = 0;
                }
            }
        }

        private function merge_dEF(param1:Event):*
        {
            var _loc2_:* = MovieClip(param1.currentTarget.parent).getChildByName("scrollMC");
            var _loc3_:* = MovieClip(param1.currentTarget);
            var _loc4_:* = (-(_loc2_.h.y) / hRun);
            var _loc5_:* = (int((_loc4_ * dRun)) + _loc3_.oy);
            if (Math.abs((_loc5_ - _loc3_.y)) > 0.2)
            {
                _loc3_.y = (_loc3_.y + ((_loc5_ - _loc3_.y) / 4));
            }
            else
            {
                _loc3_.y = _loc5_;
            }
        }

        public function onMergeBoxScroll(e:MouseEvent):void
        {
            var mc_merge:MovieClip = MovieClip(e.currentTarget.getChildByName("scrollMC"));
            mc_merge.h.y = (mc_merge.h.y + ((e.delta * -1) * 6));
            if (mc_merge.h.y < 0)
            {
                mc_merge.h.y = 0;
            }
            if ((mc_merge.h.y + mc_merge.h.height) > mc_merge.b.height)
            {
                mc_merge.h.y = int((mc_merge.b.height - mc_merge.h.height));
            }
        }


    }
}//package 

