// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//LPFFrameGoldDisplay

package UI.LPF.Frame
{
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.text.*;

    public class LPFFrameGoldDisplay extends LPFFrame 
    {

        public var mcCopper:MovieClip;
        public var mcSilver:MovieClip;
        public var mcGold:MovieClip;
        private var game:Game;

        public function LPFFrameGoldDisplay():void
        {
            x = 0;
            y = 0;
            fData = {};
        }

        override public function fOpen(o:Object):void
        {
            game = Game.root;
            fData = o.fData;

            if (("eventTypes" in o)) eventTypes = o.eventTypes;

            fDraw();
            positionBy(o.r);
            getLayout().registerForEvents(this, eventTypes);

            mcCopper.addEventListener(MouseEvent.MOUSE_OVER, onCopperTTOver, false, 0, true);
            mcCopper.addEventListener(MouseEvent.MOUSE_OUT, onTTOut, false, 0, true);

            mcSilver.addEventListener(MouseEvent.MOUSE_OVER, onSilverTTOver, false, 0, true);
            mcSilver.addEventListener(MouseEvent.MOUSE_OUT, onTTOut, false, 0, true);

            mcGold.addEventListener(MouseEvent.MOUSE_OVER, onGoldTTOver, false, 0, true);
            mcGold.addEventListener(MouseEvent.MOUSE_OUT, onTTOut, false, 0, true);
        }

        override public function fClose():void
        {
            mcCopper.removeEventListener(MouseEvent.MOUSE_OVER, onCopperTTOver);
            mcCopper.removeEventListener(MouseEvent.MOUSE_OUT, onTTOut);
            mcSilver.removeEventListener(MouseEvent.MOUSE_OVER, onSilverTTOver);
            mcSilver.removeEventListener(MouseEvent.MOUSE_OUT, onTTOut);
            mcGold.removeEventListener(MouseEvent.MOUSE_OVER, onGoldTTOver);
            mcGold.removeEventListener(MouseEvent.MOUSE_OUT, onTTOut);
            getLayout().unregisterFrame(this);

            if (parent != null) parent.removeChild(this);
        }

        private function fDraw():void
        {
            mcCopper.ti.text = game.strNumWithCommas(fData.intCopper);
            mcCopper.hit.width = mcCopper.ti.x + mcCopper.ti.textWidth + 2;
            mcCopper.hit.alpha = 0;

            mcSilver.ti.text = game.strNumWithCommas(fData.intSilver);
            mcSilver.hit.width = mcSilver.ti.x + mcSilver.ti.textWidth + 2;
            mcSilver.hit.alpha = 0;

            mcGold.ti.text = game.strNumWithCommas(fData.intGold);
            mcGold.hit.width = mcGold.ti.x + mcGold.ti.textWidth + 2;
            mcGold.hit.alpha = 0;
        }

        override public function notify(_arg_1:Object):void
        {
            if (_arg_1.eventType == "refreshCurrency") fDraw();
        }

        private function onCopperTTOver(_arg_1:MouseEvent):void
        {
            game.ui.ToolTip.openWith({"str":"Copper"});
        }

        private function onSilverTTOver(_arg_1:MouseEvent):void
        {
            game.ui.ToolTip.openWith({"str":"Silver"});
        }

        private function onGoldTTOver(_arg_1:MouseEvent):void
        {
            game.ui.ToolTip.openWith({"str":"Gold"});
        }

        private function onTTOut(_arg_1:MouseEvent=null):void
        {
            game.ui.ToolTip.close();
        }


    }
}//package 

