// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

//LPFFrameHouseDesc

package UI.LPF.Frame
{
import flash.net.*;
import flash.text.*;

public class LPFFrameHouseDesc extends LPFFrameItemPreview
{

    public function LPFFrameHouseDesc():void
    {
        mcPreview.visible = false;
        mcUpgrade.visible = false;
        btnDelete.visible = false;
    }

    override public function fClose():void
    {
        getLayout().unregisterFrame(this);
        if (parent != null)
        {
            parent.removeChild(this);
        }
    }

    override protected function fDraw():void
    {
        var item:Object = iSel;
        if (item != null)
        {
            tInfo.htmlText = game.getItemInfoStringB(item);
            tInfo.y = 0;
            tInfo.height = 121;
        }
        else
        {
            tInfo.htmlText = "Please select an item to preview.";
        }
    }


}
}//package

