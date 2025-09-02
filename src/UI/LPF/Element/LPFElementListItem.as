package UI.LPF.Element
{

import UI.LPF.Frame.LPFFrame;

import flash.display.MovieClip;
    import flash.events.MouseEvent;

    public class LPFElementListItem extends MovieClip 
    {

        protected var eventType:String = "";
        protected var sMode:String;
        public var fData:Object = {};
        public var fParent:LPFFrame;
        public var state:int = 0;

        protected function update():void
        {
            fParent.update({
                "fData":fData,
                "eventType":eventType,
                "fCaller":fParent.sName
            });
        }

        public function fOpen(o:Object):void
        {
            fData = o.fData;
            if (("eventType" in o))
            {
                eventType = o.eventType;
            }
        }

        public function fClose():void
        {
            fData = null;
            removeEventListener(MouseEvent.CLICK, onClick);
            parent.removeChild(this);
        }

        protected function fDraw():void
        {
        }

        public function subscribeTo(_arg_1:LPFFrame):void
        {
            fParent = _arg_1;
        }

        public function select():void
        {
        }

        public function deselect():void
        {
        }

        protected function onClick(_arg_1:MouseEvent):void
        {
            update();
        }

        protected function onMouseOver(_arg_1:MouseEvent):void
        {
        }

        protected function onMouseOut(_arg_1:MouseEvent):void
        {
        }


    }
}//package 

