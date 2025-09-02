// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//LPFFrameGenericButton

package UI.LPF.Frame
{
    import flash.text.TextField;
    import flash.display.SimpleButton;
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.text.*;

    public class LPFFrameGenericButton extends LPFFrame 
    {

        public var t1:TextField;
        public var t2:TextField;
        public var t3:TextField;
        public var btn1:SimpleButton;
        public var btn2:SimpleButton;
        public var btn3:SimpleButton;
        public var btn4:MovieClip;
        public var btnRuneSlot:MovieClip;
        public var active:MovieClip;
        private var isActive:Boolean = false;
        private var tempName:String = "";
        private var game:Game;
        protected var eventType:String = "";

        public function LPFFrameGenericButton():void
        {
            t1.mouseEnabled = false;
            t2.mouseEnabled = false;
            t3.mouseEnabled = false;
            active.visible = false;
            addEventListener(MouseEvent.CLICK, onBtnClick, false, 0, true);
        }

        override public function fOpen(_arg_1:Object):void
        {
            game = Game.root;
            positionBy(_arg_1.r);
            sMode = "grey";
            if (("fData" in _arg_1))
            {
                fData = _arg_1.fData;
            }
            if (("buttonNewEventType" in _arg_1))
            {
                eventType = _arg_1.buttonNewEventType;
            }
            if (("sMode" in _arg_1))
            {
                sMode = _arg_1.sMode.toLowerCase();
            }
            if (("eventTypes" in _arg_1))
            {
                eventTypes = _arg_1.eventTypes;
            }
            if ("isActive" in _arg_1)
            {
                isActive = _arg_1.isActive;
            }
            fDraw();
            getLayout().registerForEvents(this, eventTypes);
        }

        override public function fClose():void
        {
            removeEventListener(MouseEvent.CLICK, onBtnClick);
            getLayout().unregisterFrame(this);

            if (parent != null)
            {
                parent.removeChild(this);
                btnRuneSlot.removeEventListener(MouseEvent.MOUSE_OVER, onRuneTTOver);
                btnRuneSlot.removeEventListener(MouseEvent.MOUSE_OUT, onRuneTTOut);
            }
        }

        protected function fDraw():void
        {
            if (fData != null && fData.sText != "")
            {
                switch (sMode) {
                    case "red":
                        t1.text = "";
                        t2.text = fData.sText;
                        t3.text = "";
                        btn1.visible = false;
                        btn2.visible = true;
                        btn3.visible = false;
                        btn4.visible = false;
                        btnRuneSlot.visible = false;
                        break;
                    case "dark":
                        t1.text = "";
                        t2.text = "";
                        t3.text = fData.sText;
                        btn1.visible = false;
                        btn2.visible = false;
                        btn3.visible = true;
                        btn4.visible = false;
                        btnRuneSlot.visible = false;
                        break;
                    case "slot":
                        t1.text = "";
                        t2.text = "";
                        t3.text = "";
                        btn1.visible = false;
                        btn2.visible = false;
                        btn3.visible = false;
                        btn4.visible = true;
                        btnRuneSlot.visible = false;
                        break;
                    case "rune":
                        t1.text = "";
                        t2.text = "";
                        t3.text = "";
                        btn1.visible = false;
                        btn2.visible = false;
                        btn3.visible = false;
                        btn4.visible = false;
                        btnRuneSlot.visible = true;
                        break;
                    default:
                        t1.text = fData.sText;
                        t2.text = "";
                        t3.text = "";
                        btn1.visible = true;
                        btn2.visible = false;
                        btn3.visible = false;
                        btn4.visible = false;
                        btnRuneSlot.visible = false;
                        break;
                }

                active.visible = sMode == "dark" && isActive;

                if (sMode == "rune" && fData.rune != null)
                {
                    var iconClass:Class = (game.world.getClass(fData.rune.icon) as Class);
                    var icon:MovieClip = new (iconClass)();

                    icon.scaleX = icon.width > icon.height ? (icon.scaleY = (23 / icon.width)) : (icon.scaleY = (19 / icon.height));

                    tempName = fData.rune.name;

                    btnRuneSlot.mouseEnabled = false;
                    btnRuneSlot.icon.addChild(icon);
                    btnRuneSlot.slot.visible = false;

                    btnRuneSlot.addEventListener(MouseEvent.MOUSE_OVER, onRuneTTOver, false, 0, true);
                    btnRuneSlot.addEventListener(MouseEvent.MOUSE_OUT, onRuneTTOut, false, 0, true);
                }

                visible = true;
            }
            else
            {
                t1.text = "";
                t2.text = "";
                t3.text = "";
                btn1.visible = false;
                btn2.visible = false;
                btn3.visible = false;
                btn4.visible = false;
                btnRuneSlot.visible = false;
                visible = false;
            }
        }

        override public function notify(o:Object):void
        {
            if (("fData" in o))
            {
                fData = o.fData;
            }
            if (("buttonNewEventType" in o))
            {
                eventType = o.buttonNewEventType;
            }
            if (("sMode" in o))
            {
                sMode = o.sMode.toLowerCase();
            }
            if (("r" in o))
            {
                positionBy(o.r);
            }
            fDraw();
        }

        private function onBtnClick(_arg_1:MouseEvent):void
        {
            if (eventType != "none")
            {
                game.mixer.playSound("Click");
                if (("sModeBroadcast" in fData))
                {
                    update({
                        "eventType":eventType,
                        "sModeBroadcast":fData.sModeBroadcast
                    });
                }
                else
                {
                    update({"eventType":eventType});
                }
            }
        }

        private function onRuneTTOver(event:MouseEvent):void
        {
            game.ui.ToolTip.openWith({"str":tempName});
        }

        private function onRuneTTOut(event:MouseEvent):void
        {
            game.ui.ToolTip.close();
        }


    }
}//package 

