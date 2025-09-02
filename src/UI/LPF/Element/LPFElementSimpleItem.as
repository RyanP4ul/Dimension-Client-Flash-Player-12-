// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//LPFElementSimpleItem

package UI.LPF.Element
{
import UI.LPF.Frame.LPFFrame;

import flash.display.MovieClip;
    import flash.text.TextField;
    import flash.events.MouseEvent;
    import flash.text.*;

    public class LPFElementSimpleItem extends MovieClip 
    {

        public var tQty:TextField;
        public var tName:TextField;
        private var game:Game;
        protected var eventType:String = "";
        protected var sMode:String;
        public var fData:Object = {};
        public var fParent:LPFFrame;

        public function LPFElementSimpleItem():void
        {
        }

        protected function update():void
        {
        }

        public function fOpen(_arg_1:Object):void
        {
            fData = _arg_1.fData;
            if (("eventType" in _arg_1))
            {
                eventType = _arg_1.eventType;
            };
            game = Game.root;
            fDraw();
        }

        public function fClose():void
        {
            fData = null;
            parent.removeChild(this);
        }

        protected function fDraw():void
        {
            var _local_8:String;
            tName.htmlText = fData.sName;
            var _local_1:* = "#FFFFFF";
            var _local_2:* = "#FFD900";
            var _local_3:* = "#999999";
            var _local_4:* = "#666666";
            var _local_5:Object = game.world.invTree[fData.ItemID];
            var _local_6:int;
            var _local_7:Boolean;
            if (_local_5 != null)
            {
                _local_6 = _local_5.iQty;
            };
            if (_local_6 >= fData.iQty)
            {
                _local_7 = true;
            };
            if (_local_7)
            {
                _local_8 = (((("<font color='" + _local_1) + "'>") + _local_6) + "</font>");
                _local_8 = (_local_8 + (("<font color='" + _local_2) + "'>/</font>"));
                _local_8 = (_local_8 + (((("<font color='" + _local_1) + "'>") + fData.iQty) + "</font>"));
            }
            else
            {
                _local_8 = (((("<font color='" + _local_4) + "'>") + _local_6) + "</font>");
                _local_8 = (_local_8 + (("<font color='" + _local_3) + "'>/</font>"));
                _local_8 = (_local_8 + (((("<font color='" + _local_4) + "'>") + fData.iQty) + "</font>"));
            };
            tQty.htmlText = _local_8;
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
        }

        protected function onMouseOver(_arg_1:MouseEvent):void
        {
        }

        protected function onMouseOut(_arg_1:MouseEvent):void
        {
        }


    }
}//package 

