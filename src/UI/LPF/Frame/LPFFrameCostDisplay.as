// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//LPFFrameCostDisplay

package UI.LPF.Frame
{
import flash.display.DisplayObject;
import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.text.*;

    public class LPFFrameCostDisplay extends LPFFrame 
    {

        public var bg:MovieClip;
        private var game:Game;
        private var r:Object;

        private var padding:int = 8;
        private var gap:int = 4;
        private var spacing:int = 8;
        private var maxWidth:int = 250;

        public function LPFFrameCostDisplay():void
        {
            x = 0;
            y = 0;
            fData = {};
        }

        override public function fOpen(_arg_1:Object):void
        {
            game = Game.root;
            fData = _arg_1.fData;
            if (("eventTypes" in _arg_1))
            {
                eventTypes = _arg_1.eventTypes;
            }
            if (("r" in _arg_1))
            {
                r = _arg_1.r;
            }
            fDraw();
            positionBy(r);
            getLayout().registerForEvents(this, eventTypes);
        }

        override public function fClose():void
        {
            getLayout().unregisterFrame(this);
            if (parent != null)
            {
                parent.removeChild(this);
            }
        }

        private function get qty_parent() : Object
        {
            return ((MovieClip(MovieClip(parent).parent).iQty) ? MovieClip(MovieClip(parent).parent) : MovieClip(parent));
        }

        private function fDraw():void {
            for (var i:int = numChildren - 1; i >= 0; i--) {
                var child:DisplayObject = getChildAt(i);
                if (child && child.name && child.name.indexOf("_") != -1) {
                    removeChildAt(i);
                }
            }

            visible = false;

            var quantity:int = 1;
            var isShopSell:Boolean = getLayout().sMode == "shopSell";

            if (getLayout().sMode.indexOf("shop") > -1 && fData != null) {
                var intCopper:int = fData ? (isShopSell ? fData.intCopper / 4 : fData.intCopper) : 0;
                var intSilver:int = fData ? (isShopSell ? fData.intSilver / 4 : fData.intSilver) : 0;
                var intGold:int   = fData ? (isShopSell ? fData.intSilver / 4 : fData.intGold) : 0;

                if (intCopper == 0 && intSilver == 0 && intGold == 0) return;

                if (qty_parent && getLayout().sMode == "shopBuy" && "splitPanel" in getLayout() && getLayout().splitPanel.visible) {
                    var selectedQuantity:int = getLayout().splitPanel.frames[2].mc.getSelected();
                    if (selectedQuantity > 1) quantity = selectedQuantity;
                }
                else if (qty_parent && hasSlider() && qty_parent.iQty > 1 && fData.sES != "ar") {
                    quantity = qty_parent.iQty;
                }

                setCurrency(intCopper * quantity, intSilver * quantity, intGold * quantity);

                // MergeShop positioning
                if (game.ui.mcPopup.currentLabel == "MergeShop") {
                    if (hasSlider()) {
                        positionBy({ x:450, y:-102, w:-1, h:-1, xPosRule:"centerOnX" });
                    } else {
                        positionBy(r);
                    }
                }

                visible = true;
            }
        }

        public function setCurrency(copper:int = 0, silver:int = 0, gold:int = 0):void
        {
            var xPos:int = padding;

            if (gold > 0)  xPos = addPart(gold, game.world.myAvatar.objData.intGold, new CurrencyIconGold(), "_gold", xPos);
            if (silver > 0) xPos = addPart(silver, game.world.myAvatar.objData.intSilver ,new CurrencyIconSilver(), "_silver", xPos);
            if (copper > 0) xPos = addPart(copper, game.world.myAvatar.objData.intCopper, new CurrencyIconCopper(), "_copper", xPos);

            if (gold == 0 && silver == 0 && copper == 0)
                xPos = addPart(0, game.world.myAvatar.objData.intCopper, new CurrencyIconCopper(), "_copper", xPos);

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

            bg.width = totalW;
            bg.height = 35;
        }

        private function addPart(amount:int, current:int, icon:MovieClip, name:String, xPos:int):int
        {
            var tf:TextField = new TextField();
            tf.name = "_cost";
            tf.defaultTextFormat = new TextFormat("Calibri", 14, amount > current ? 0xFF0000 : 0xFFFFFF);
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
            tf.y = padding - 2;

            icon.name = name;
            icon.x = tf.x + tf.width + gap;
            icon.y = padding + 2;
            addChild(icon);

            return icon.x + icon.width + spacing;
        }


        private function hasSlider():Boolean
        {
            if (getLayout().sMode == "shopBuy" && (game.world.maximumShopBuys(fData) < 2))
            {
                return false;
            }

            if (((getLayout().sMode == "shopSell") && (game.world.maximumShopSells(fData) < 2)))
            {
                return false;
            }
            return true;
        }

        override protected function positionBy(_arg_1:Object):*
        {
            var _local_3:int;
            var _local_2:int;

//            if (mcGold.visible)
//            {
//                bg.width = (((mcGold.x + mcGold.ti.x) + mcGold.ti.textWidth) + 10);
//                w = bg.width;
//                _local_2 = 1;
//            }
//            else if (mcSilver.visible)
//            {
//                bg.width = (((mcSilver.x + mcSilver.ti.x) + mcSilver.ti.textWidth) + 10);
//                w = bg.width;
//                _local_2 = 1;
//            }
//            else
//            {
//                bg.width = (((mcCopper.x + mcCopper.ti.x) + mcCopper.ti.textWidth) + 10);
//                w = bg.width;
//            }

            if (((!(_arg_1 == null)) && ("xPosRule" in _arg_1)))
            {
                if (_arg_1.xPosRule == "centerOnX")
                {
                    x = (int((_arg_1.x - (w / 2))) + _local_2);
                }
            }
            else
            {
                if (_arg_1.x > -1)
                {
                    x = _arg_1.x;
                }
                else
                {
                    x = (int(((fParent.w / 2) - (w / 2))) + _local_2);
                }
            }
            if (_arg_1.y > -1)
            {
                y = _arg_1.y;
            }
            else
            {
                if (_arg_1.y == -1)
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
                else
                {
                    y = (fParent.h + _arg_1.y);
                }
            }
        }

        override public function notify(o:Object):void
        {
            if (o.eventType == "listItemASel" || o.eventType == "listItemBSel")
            {
                if (((!(o.fData == null)) && (!(o.fData.oSel == null))))
                {
                    fData = o.fData.oSel;
                }
                fDraw();
            }
            if (o.eventType == "updateQtyValue")
            {
                fDraw();
            }
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

        private function onTTOut(_arg_1:MouseEvent):void
        {
            game.ui.ToolTip.close();
        }


    }
}//package 

