// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//LPFPanel

package UI.LPF.Panel
{
import UI.LPF.Frame.LPFFrame;
import UI.LPF.Layout.LPFLayout;

import flash.display.MovieClip;
    import flash.events.MouseEvent;
import flash.filters.GlowFilter;
import flash.text.*;

import game.select.Selector;

public class LPFPanel extends MovieClip
    {

        public var frames:Array;
        public var w:int;
        public var h:int;
        public var xo:int;
        public var yo:int;
        public var xBuffer:int;
        public var yBuffer:int;
        public var frameID:int = 0;
        public var fParent:LPFLayout;
        public var bg:MovieClip;
        public var isOpen:Boolean = false;
        protected var fData:Object;
        protected var sMode:String;
        protected var closeType:String;
        protected var hideDir:String = "";
        protected var hidePad:int = 0;
        public var search:*;

        public function LPFPanel():void
        {
        }

        public function notify(o:Object):void
        {
            var i:int = 0;
            while (i < frames.length)
            {
                frames[i].mc.notify(o);
                i++;
            }
        }

        public function addFrame(o:Object):void
        {
            var frame:LPFFrame = (addChild(o.frame) as LPFFrame);
            frame.subscribeTo(this);
            frames.push({
                "mc":frame,
                "id":frameID++
            });
            frame.fOpen(o);
        }

        public function delFrame(frame:LPFFrame):void
        {
            var i:int = 0;
            while (i < frames.length)
            {
                if (frames[i].mc == frame)
                {
                    frames[i].fClose();
                    frames.splice(i, 1);
                }
                i++;
            }
        }

        public function subscribeTo(_arg_1:LPFLayout):void
        {
            fParent = _arg_1;
        }

        public function fOpen(_arg_1:Object):void
        {
            var _local_3:int;
            fData = _arg_1.fData;
            var _local_2:Object = _arg_1.r;
            x = _local_2.x;
            if (_local_2.y > -1)
            {
                y = _local_2.y;
            }
            else
            {
                _local_3 = fParent.numChildren;
                if (_local_3 > 1)
                {
                    y = ((fParent.getChildAt((_local_3 - 2)).y + fParent.getChildAt((_local_3 - 2)).height) + 10);
                }
                else
                {
                    y = 10;
                }
            }
            w = _local_2.w;
            h = _local_2.h;
            xo = x;
            yo = y;
        }

        public function fClose():void
        {
            if (((!(bg == null)) && (!(bg.btnClose == null))))
            {
                bg.btnClose.removeEventListener(MouseEvent.CLICK, onCloseClick);
            }
            while (frames.length > 0)
            {
                frames[0].mc.fClose();
                frames.shift();
            }
            if (search)
            {
                search.reset();
            }
            search = null;
            MovieClip(fParent).delPanel(this);
        }

        public function fHide():void
        {
            isOpen = false;
            visible = false;
            switch (hideDir.toLowerCase())
            {
                case "left":
                    x = ((xo - w) - hidePad);
                    return;
                case "right":
                    x = ((xo + w) + hidePad);
                    return;
                case "top":
                    y = ((yo - h) - hidePad);
                    return;
                case "bottom":
                    y = ((yo + h) + hidePad);
                    return;
                case "":
            }
        }

        public function fShow(_arg_1:int=-1):void
        {
            isOpen = true;
            visible = true;
            if (_arg_1 > -1)
            {
                x = _arg_1;
            }
            else
            {
                x = xo;
            }
        }

        protected function drawBG(_arg_1:*=null):void
        {
            if (_arg_1 == null)
            {
                bg = new LPFPanelBg();
                bg.frame.width = w;
                bg.frame.height = h;
                bg.bg.width = (w - (6 * 2));
                bg.bg.height = (h - (5 * 2));
                bg.btnClose.x = (w - 31);
                bg.dragonRight.x = (bg.frame.width + 21);
                bg.tTitle.x = int(((w / 2) - (bg.tTitle.width / 2)));
                addChildAt(bg, 0);
            }
            else
            {
                bg = (addChildAt(new (_arg_1)(), 0) as MovieClip);
            }

            if (("sName" in fData))
            {
                bg.tTitle.text = fData.sName;
            }

            if (["Equipped", "Preview"].indexOf(fData.sName) == -1 && !bg.getChildByName("mcSearch") && (fParent.sMode.indexOf("shop") > -1 || ["Bank", "MergeShop", "Inventory", "HouseInventory", "Temporary", "Loot"].indexOf(Game.root.ui.mcPopup.currentLabel) != -1))
            {
                search = bg.addChild(new mcSearch());
                search.name = "mcSearch";

                switch (Game.root.ui.mcPopup.currentLabel.toLowerCase()) {
                    case "mergeshop":
                    case "bank":
                        search.x = 650;
                        search.y = 36;
                        break;
                    default:
                        search.x = 20;
                        search.y = 66;
                        break;
                }
            }
        }

        protected function onCloseClick(_arg_1:MouseEvent=null):void
        {
            switch (closeType)
            {
                case "hide":
                    fHide();
                    return;
                case "close":
                default:
                    search = null;
                    bg.btnClose.removeEventListener(MouseEvent.CLICK, onCloseClick);
                    fParent.fClose();
            }
        }


    }
}//package 

