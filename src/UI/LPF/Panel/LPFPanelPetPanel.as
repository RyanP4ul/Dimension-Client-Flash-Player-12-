// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//LPFPanelPetPanel

package UI.LPF.Panel
{
import UI.LPF.Frame.LPFFrameBackdrop;
import UI.LPF.Frame.LPFFrameItemPreview;
import UI.LPF.Frame.LPFFramePet;

import flash.geom.Point;
    import flash.display.*;
    import flash.geom.*;
    import flash.text.*;
    import flash.events.*;

    public class LPFPanelPetPanel extends LPFPanel 
    {

        public function LPFPanelPetPanel():void
        {
            x = 0;
            y = 0;
            frames = [];
            fData = {};
        }

        override public function fOpen(_arg_1:Object):void
        {
            var _local_2:Object;
            var _local_3:int;
            fData = _arg_1.fData;
            drawBG(LPFPanelBg2);
            bg.tTitle.text = "Pet";
            bg.tPane1.text = "";
            bg.tPane2.text = "";
            bg.tPane3.text = "";
            bg.tPane1.visible = false;
            bg.tPane2.visible = false;
            bg.tPane3.visible = false;
            _local_2 = _arg_1.r;
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

            var _local_4:Point = new Point(0, 0);
            _local_4 = bg.localToGlobal(_local_4);
            bg.y = 0;
            w = _local_2.w;
            h = _local_2.h;
            xo = x;
            yo = y;
            if (("closeType" in _arg_1))
            {
                closeType = _arg_1.closeType;
            }
            if (("hideDir" in _arg_1))
            {
                hideDir = _arg_1.hideDir;
            }
            if (("hidePad" in _arg_1))
            {
                hidePad = _arg_1.hidePad;
            }
            if (("xBuffer" in _arg_1))
            {
                xBuffer = _arg_1.xBuffer;
            }
            if (("isOpen" in _arg_1))
            {
                isOpen = _arg_1.isOpen;
            }

            var _local_5:Object = {};
            _local_5.frame = new LPFFrameBackdrop();
            _local_5.fData = null;
            _local_5.r = {
                "x":25,
                "y":23.9,
                "w":345.7,
                "h":379.15
            };
            addFrame(_local_5);
            _local_5 = {};
            _local_5.frame = new LPFFrameItemPreview();
            _local_5.fData = null;
            _local_5.r = {
                "x":55,
                "y":130,
                "w":284,
                "h":-1
            };
            _local_5.isPet = true;
            _local_5.eventTypes = [];
            addFrame(_local_5);

            _local_5 = {};
            _local_5.frame = new LPFFramePet();
            _local_5.fData = null;
            _local_5.r = {
                "x":24,
                "y":18,
                "w":284,
                "h":-1
            };
            _local_5.eventTypes = ["updatePetExp"];
            addFrame(_local_5);

            bg.btnClose.addEventListener(MouseEvent.CLICK, onCloseClick, false, 0, true);
            if (!(("showDragonLeft" in _arg_1) && (_arg_1.showDragonLeft == true)))
            {
                bg.dragonLeft.visible = true;
            }
            if (!(("showDragonRight" in _arg_1) && (_arg_1.showDragonRight == true)))
            {
                bg.dragonRight.visible = true;
            }
        }


    }
}//package 

