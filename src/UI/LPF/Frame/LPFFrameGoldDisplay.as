// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//LPFFrameGoldDisplay

package UI.LPF.Frame
{
import flash.display.DisplayObject;
import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.text.*;

    public class LPFFrameGoldDisplay extends LPFFrame 
    {

        private var game:Game;
        private var padding:int = 8;
        private var gap:int = 4;
        private var spacing:int = 8;
        private var maxWidth:int = 250;

        public var btnTestConvert:MovieClip;
        public var bg:MovieClip;

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
        }

        override public function fClose():void
        {
            getLayout().unregisterFrame(this);
            if (parent != null) parent.removeChild(this);
        }

        private function fDraw():void
        {
            for (var i:int = numChildren - 1; i >= 0; i--) {
                var child:DisplayObject = getChildAt(i);
                if (child && child.name && child.name.indexOf("_") != -1) {
                    removeChildAt(i);
                }
            }

            setCurrency(fData.intCopper, fData.intSilver, fData.intGold);

            btnTestConvert.addEventListener(MouseEvent.CLICK, onTestConvertClick, false, 0, true);
        }

        override public function notify(_arg_1:Object):void
        {
            if (_arg_1.eventType == "refreshCurrency") fDraw();
        }

        private function onTestConvertClick(event:MouseEvent) : void
        {
            var copperToSilver:Number = game.statsController.intCopperToSilver;
            var iMax:Number = (game.world.myAvatar.objData.intCopper / copperToSilver);

            if (iMax < 1)
            {
                game.Modal("You do not have enough copper to convert.", null, {}, "red,medium");
                return;
            }

            game.Modal(iMax == 1
                    ? "<b>" + copperToSilver + " Copper = 1 Silver.</b> <br><br> You only have enough copper to convert to one silver. Do you wish to continue?"
                    : "<b>" + copperToSilver + " Copper = 1 Silver.</b> <br><br> Please select the amount of silver you want.", ConvertCopperToSilver, {}, "white,medium", "dual", true, {
                min:1,
                max:iMax
            });
        }

        private function ConvertCopperToSilver(o:Object) : void
        {
            if (o.accept)
            {
                game.net.send("convertCopperToSilver", [o.hasOwnProperty("iQty") ? o.iQty : 1]);
            }
        }

        public function setCurrency(copper:int = 0, silver:int = 0, gold:int = 0):void
        {
            var xPos:int = padding;

            xPos = addPart(gold, new CurrencyIconGold(), "_gold", xPos);
            xPos = addPart(silver, new CurrencyIconSilver(), "_silver", xPos);
            xPos = addPart(copper, new CurrencyIconCopper(), "_copper", xPos);

            var totalW:int = xPos + padding;

            if (totalW > maxWidth)
            {
                var scale:Number = maxWidth / totalW;
                this.scaleX = scale;
                this.scaleY = scale;
                totalW = maxWidth;
            }
            else
            {
                this.scaleX = 1;
                this.scaleY = 1;
            }
        }

        private function addPart(amount:int, icon:MovieClip, name:String, xPos:int):int
        {
            var tf:TextField = new TextField();
            tf.name = "_cost";
            tf.defaultTextFormat = new TextFormat("Calibri", 14, 0xFFFFFF);
            tf.autoSize = "left";
            tf.text = game.strNumWithCommas(amount); // amount.toString();
            tf.selectable = false;
            addChild(tf);

            var expectedW:int = xPos + tf.textWidth + gap + icon.width;
            if (expectedW > maxWidth)
            {
                // Shrink text only (reduce font size until it fits)
                var size:int = 14;
                while (expectedW > maxWidth && size > 8)
                {
                    size--;
                    tf.setTextFormat(new TextFormat("Calibri", size, 0xFFFFFF));
                    expectedW = xPos + tf.textWidth + gap + icon.width;
                }
            }

            tf.x = xPos;
            tf.y = padding - 5;

            icon.name = name;
            icon.x = tf.x + tf.width + gap;
            icon.y = padding;
            addChild(icon);

            return icon.x + icon.width + spacing;
        }

    }
}//package 

