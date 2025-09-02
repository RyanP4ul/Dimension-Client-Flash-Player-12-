// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//LPFFrameSlotDisplay

package UI.LPF.Frame
{
    import flash.text.TextField;
    import flash.display.MovieClip;
    import flash.text.*;

    public class LPFFrameSlotDisplay extends LPFFrame 
    {

        public var ti:TextField;
        private var game:Game;
        private var isBank:Boolean = false;

        public function LPFFrameSlotDisplay():void
        {
            x = 0;
            y = 0;
            fData = {};
        }

        override public function fOpen(_arg_1:Object):void
        {
            game = Game.root;
            fData = _arg_1.fData;
            positionBy(_arg_1.r);
            if (("eventTypes" in _arg_1))
            {
                eventTypes = _arg_1.eventTypes;
            }
            if (("isBank" in _arg_1))
            {
                isBank = (((_arg_1.isBank == true) || (_arg_1.isBank == "true")) || (_arg_1.isBank == 1));
            }
            fDraw();
            getLayout().registerForEvents(this, eventTypes);
        }

        override public function fClose():void
        {
            fData = {};
            getLayout().unregisterFrame(this);
            if (parent != null)
            {
                parent.removeChild(this);
            }
        }

        private function fDraw():void
        {
            if (isBank)
            {
                ti.htmlText = "<font color='#FFFFFF'>";
                ti.htmlText = (ti.htmlText + fData.avatar.iBankCount);
                ti.htmlText = (ti.htmlText + "</font><font color='#CCCCCC'> / </font>");
                ti.htmlText = (ti.htmlText + "<font color='#FFFFFF'>");
                ti.htmlText = (ti.htmlText + fData.avatar.objData.iBankSlots);
                ti.htmlText = (ti.htmlText + " </font><font color='#CCCCCC'>Bank Spaces</font>");
            }
            else
            {
                ti.htmlText = "<font color='#FFFFFF'>";
                ti.htmlText = (ti.htmlText + fData.list.length);
                ti.htmlText = (ti.htmlText + "</font><font color='#CCCCCC'> / </font>");
                ti.htmlText = (ti.htmlText + "<font color='#FFFFFF'>");
                ti.htmlText = (ti.htmlText + (game.ui.mcPopup.currentLabel == "HouseInventory" ? fData.iHouseSlots : fData.iBagSlots));
                ti.htmlText = (ti.htmlText + " </font><font color='#CCCCCC'>Backpack Spaces</font>");
            }
        }

        override public function notify(_arg_1:Object):void
        {
            fDraw();
        }


    }
}//package 

