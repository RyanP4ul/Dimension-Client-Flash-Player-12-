// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//LPFFrameCostDisplay

package UI.LPF.Frame
{
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.text.*;

    public class LPFFrameCostDisplay extends LPFFrame 
    {

        public var mcCopper:MovieClip;
        public var mcSilver:MovieClip;
        public var mcGold:MovieClip;
        public var bg:MovieClip;
        private var game:Game;
        private var r:Object;

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
            mcCopper.addEventListener(MouseEvent.MOUSE_OVER, onCopperTTOver, false, 0, true);
            mcCopper.addEventListener(MouseEvent.MOUSE_OUT, onTTOut, false, 0, true);
            mcSilver.addEventListener(MouseEvent.MOUSE_OVER, onSilverTTOver, false, 0, true);
            mcSilver.addEventListener(MouseEvent.MOUSE_OUT, onTTOut, false, 0, true);
            mcGold.addEventListener(MouseEvent.MOUSE_OVER, onGoldTTOver, false, 0, true);
            mcGold.addEventListener(MouseEvent.MOUSE_OUT, onTTOut, false, 0, true);
            mcCopper.hit.alpha = 0;
            mcSilver.hit.alpha = 0;
            mcGold.hit.alpha = 0;
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
            if (parent != null)
            {
                parent.removeChild(this);
            }
        }

        private function get qty_parent():*
        {
            return ((MovieClip(MovieClip(parent).parent).iQty) ? MovieClip(MovieClip(parent).parent) : MovieClip(parent));
        }

        private function fDraw():void
        {
            visible = false;
            var _local_1:* = (getLayout().sMode == "shopSell");
            var _local_2:Number = 0;
            var _local_3:* = "#FFFFFF";
            var _local_4:int;

            if (((getLayout().sMode.indexOf("shop") > -1) && (!(fData == null))))
            {
                visible = true;
                mcCopper.visible = false;
                mcSilver.visible = false;
                mcGold.visible = false;
                mcCopper.x = 0;
                mcSilver.x = 0;
                mcGold.x = 0;
                mcCopper.ti.text = "";
                mcSilver.ti.text = "";
                mcGold.ti.text = ""

                _local_2 = Number(fData.iCost);

                if ((((!(qty_parent.eSel == null)) && (getLayout().sMode == "shopBuy")) && (getLayout().hasOwnProperty("splitPanel"))))
                {
                    if (getLayout().splitPanel.visible)
                    {
                        _local_4 = getLayout().splitPanel.frames[2].mc.getSelected();
                        if (_local_4 > 1)
                        {
                            _local_2 = (_local_2 * _local_4);
                        }
                    }
                }
                else
                {
                    if (((((getLayout().sMode.indexOf("shop") > -1) && (qty_parent)) && (hasSlider())) && (qty_parent.iQty > 1)))
                    {
                        if (fData.sES != "ar")
                        {
                            _local_2 = (_local_2 * qty_parent.iQty);
                        }
                    }
                }

                if (_local_2 > 0)
                {
                    if ("bGold" in fData && fData.bGold == 1)
                    {
                        if (_local_1)
                        {
                            if (fData.iHrs < 24)
                            {
                                _local_2 = Math.ceil(((_local_2 * 9) / 10));
                            }
                            else
                            {
                                _local_2 = Math.ceil((_local_2 / 4));
                            }
                        }
                        else
                        {
                            if (_local_2 > game.world.myAvatar.objData.intGold)
                            {
                                _local_3 = "#FF0000";
                            }
                        }

                        mcGold.ti.htmlText = (((("<font color='" + _local_3) + "'>") + game.strNumWithCommas(_local_2)) + "</font>");
                        mcGold.visible = true;
                    }
                    else if ("bSilver" in fData && fData.bSilver == 1)
                    {
                        if (_local_1)
                        {
                            _local_2 = Math.ceil((_local_2 / 4));
                        }
                        else
                        {
                            if (_local_2 > game.world.myAvatar.objData.intSilver)
                            {
                                _local_3 = "#FF0000";
                            }
                        }

                        mcSilver.ti.htmlText = (((("<font color='" + _local_3) + "'>") + game.strNumWithCommas(_local_2)) + "</font>");
                        mcSilver.visible = true;
                    }
                    else
                    {
                        if (_local_1)
                        {
                            _local_2 = Math.ceil((_local_2 / 4));
                        }
                        else
                        {
                            if (_local_2 > game.world.myAvatar.objData.intCopper)
                            {
                                _local_3 = "#FF0000";
                            }
                        }

                        mcCopper.ti.htmlText = (((("<font color='" + _local_3) + "'>") + game.strNumWithCommas(_local_2)) + "</font>");
                        mcCopper.visible = true;
                    }

                    mcCopper.hit.width = ((mcCopper.ti.x + mcCopper.ti.textWidth) + 2);
                    mcSilver.hit.width = ((mcSilver.ti.x + mcSilver.ti.textWidth) + 2);
                    mcGold.hit.width = ((mcGold.ti.x + mcGold.ti.textWidth) + 2);

                    if (((game.ui.mcPopup.currentLabel == "MergeShop") && (hasSlider())))
                    {
                        positionBy({
                            "x":450,
                            "y":-102,
                            "w":-1,
                            "h":-1,
                            "xPosRule":"centerOnX"
                        });
                    }
                    else
                    {
                        if (game.ui.mcPopup.currentLabel == "MergeShop" && !hasSlider())
                        {
                            positionBy(r);
                        }
                    }

                    visible = true;
                }
                else
                {
                    visible = false;
                }
            }
        }

        private function hasSlider():Boolean
        {
            if (((getLayout().sMode == "shopBuy") && ((game.world.maximumShopBuys(fData) < 2) || ((fData.bGold == 1) && (fData.iCost > 0)))))
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
            if (mcGold.visible)
            {
                bg.width = (((mcGold.x + mcGold.ti.x) + mcGold.ti.textWidth) + 10);
                w = bg.width;
                _local_2 = 1;
            }
            else if (mcSilver.visible)
            {
                bg.width = (((mcSilver.x + mcSilver.ti.x) + mcSilver.ti.textWidth) + 10);
                w = bg.width;
                _local_2 = 1;
            }
            else
            {
                bg.width = (((mcCopper.x + mcCopper.ti.x) + mcCopper.ti.textWidth) + 10);
                w = bg.width;
            }

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

