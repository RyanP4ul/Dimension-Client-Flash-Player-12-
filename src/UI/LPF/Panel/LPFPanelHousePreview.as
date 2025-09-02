// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

//LPFPanelHousePreview

package UI.LPF.Panel
{
import UI.LPF.Frame.LPFFrameBackdrop;
import UI.LPF.Frame.LPFFrameCostDisplay;
import UI.LPF.Frame.LPFFrameGenericButton;
import UI.LPF.Frame.LPFFrameHouseDesc;
import UI.LPF.Frame.LPFFrameHousePreview;

import flash.events.MouseEvent;
import flash.text.*;

public class LPFPanelHousePreview extends LPFPanel
{

    public function LPFPanelHousePreview():void
    {
        x = 0;
        y = 0;
        frames = [];
        fData = {};
    }

    override public function fOpen(o:Object):void
    {
        var n:int;
        fData = o.fData;
        var r:Object = o.r;
        x = r.x;
        if (r.y > -1)
        {
            y = r.y;
        }
        else
        {
            n = fParent.numChildren;
            if (n > 1)
            {
                y = ((fParent.getChildAt((n - 2)).y + fParent.getChildAt((n - 2)).height) + 10);
            }
            else
            {
                y = 10;
            };
        };
        w = r.w;
        h = r.h;
        xo = x;
        yo = y;
        if (("closeType" in o))
        {
            closeType = o.closeType;
        };
        if (("hideDir" in o))
        {
            hideDir = o.hideDir;
        };
        if (("hidePad" in o))
        {
            hidePad = o.hidePad;
        };
        if (("xBuffer" in o))
        {
            xBuffer = o.xBuffer;
        };
        var frameDef:Object = {};
        frameDef = {};
        frameDef.frame = new LPFFrameBackdrop();
        frameDef.fData = null;
        frameDef.r = {
            "x":14,
            "y":36,
            "w":(w - 26),
            "h":204
        };
        addFrame(frameDef);
        frameDef = {};
        frameDef.frame = new LPFFrameBackdrop();
        frameDef.fData = null;
        frameDef.r = {
            "x":14,
            "y":244,
            "w":(w - 26),
            "h":121
        };
        addFrame(frameDef);
        frameDef = {};
        frameDef.frame = new LPFFrameHousePreview();
        frameDef.fData = null;
        frameDef.r = {
            "x":18,
            "y":40,
            "w":(w - 20),
            "h":-1
        };
        frameDef.eventTypes = ["listItemASel", "listItemBSel", "refreshItems"];
        addFrame(frameDef);
        frameDef = {};
        frameDef.frame = new LPFFrameHouseDesc();
        frameDef.fData = null;
        frameDef.r = {
            "x":18,
            "y":245,
            "w":(w - 20),
            "h":-1
        };
        frameDef.eventTypes = ["listItemASel", "listItemBSel", "refreshItems"];
        addFrame(frameDef);
        frameDef = {};
        frameDef.frame = new LPFFrameCostDisplay();
        frameDef.fData = null;
        frameDef.r = {
            "x":int((173 + (96 / 2))),
            "y":-66,
            "w":-1,
            "h":-1,
            "xPosRule":"centerOnX"
        };
        frameDef.eventTypes = ["listItemASel"];
        addFrame(frameDef);
        frameDef = {};
        frameDef.frame = new LPFFrameGenericButton();
        frameDef.fData = null;
        frameDef.r = {
            "x":46,
            "y":-40,
            "w":-1,
            "h":-1
        };
        frameDef.eventTypes = ["previewButton1Update"];
        addFrame(frameDef);
        frameDef = {};
        frameDef.frame = new LPFFrameGenericButton();
        frameDef.fData = null;
        frameDef.r = {
            "x":173,
            "y":-40,
            "w":-1,
            "h":-1
        };
        frameDef.eventTypes = ["previewButton2Update"];
        addFrame(frameDef);
        drawBG();
        bg.btnClose.addEventListener(MouseEvent.CLICK, onCloseClick, false, 0, true);
        if (!(("showDragonLeft" in o) && (o.showDragonLeft == true)))
        {
            bg.dragonLeft.visible = false;
        };
        if (!(("showDragonRight" in o) && (o.showDragonRight == true)))
        {
            bg.dragonRight.visible = false;
        };
    }


}
}//package

