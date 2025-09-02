// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

//LPFFrameHousePreview

package UI.LPF.Frame
{
import flash.events.MouseEvent;
import flash.events.Event;
import flash.net.*;
import flash.text.*;

public class LPFFrameHousePreview extends LPFFrameItemPreview
{

    public function LPFFrameHousePreview():void
    {
        mcUpgrade.visible = false;
        btnDelete.addEventListener(MouseEvent.CLICK, super.onBtnDeleteClick, false, 0, true);
        btnDelete.addEventListener(MouseEvent.MOUSE_OVER, super.onDeleteTTOver, false, 0, true);
        btnDelete.addEventListener(MouseEvent.MOUSE_OUT, super.onDeleteTTOut, false, 0, true);
        mcUpgrade.addEventListener(MouseEvent.MOUSE_OVER, super.onUpgradeTTOver, false, 0, true);
        mcUpgrade.addEventListener(MouseEvent.MOUSE_OUT, super.onUpgradeTTOut, false, 0, true);
        addEventListener(Event.ENTER_FRAME, super.onEF, false, 0, true);
    }

    override public function fClose():void
    {
        btnDelete.removeEventListener(MouseEvent.CLICK, super.onBtnDeleteClick);
        btnDelete.removeEventListener(MouseEvent.MOUSE_OVER, super.onDeleteTTOver);
        btnDelete.removeEventListener(MouseEvent.MOUSE_OUT, super.onDeleteTTOut);
        mcUpgrade.removeEventListener(MouseEvent.MOUSE_OVER, super.onUpgradeTTOver);
        mcUpgrade.removeEventListener(MouseEvent.MOUSE_OUT, super.onUpgradeTTOut);
        getLayout().unregisterFrame(this);
        if (parent != null)
        {
            parent.removeChild(this);
        }
    }

    override protected function fDraw():void
    {
        tInfo.visible = false;
        btnDelete.visible = false;
        var item:Object = iSel;
        if (item != null)
        {
            btnDelete.visible = true;
            mcUpgrade.visible = false;
            if (item.bUpg == 1)
            {
                mcUpgrade.visible = true;
            }
            loadPreview(item);
        }
        else
        {
            tInfo.htmlText = "Please select an item to preview.";
            while (mcPreview.numChildren > 0)
            {
                mcPreview.removeChildAt(0);
            }
            super.clearPreview();
        }
        btnDelete.visible = true;
        if (getLayout().sMode.toLowerCase().indexOf("shop") > -1)
        {
            btnDelete.visible = false;
        }
    }

    override protected function loadPreview(item:Object):void
    {
        if (curItem != item)
        {
            curItem = item;
            switch (item.sType)
            {
                case "House":
                    super.loadHouse(item.sFile);
                    break;
                case "Wall Item":
                case "Floor Item":
                    super.loadHouseItem(item.sFile, item.sLink);
                    break;
                default:
                    super.clearPreview();
            }
        }
    }


}
}//package

