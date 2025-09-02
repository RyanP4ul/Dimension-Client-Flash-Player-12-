// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//HealIconMC

package 
{
    import flash.display.MovieClip;
    import flash.events.MouseEvent;

    public class HealIconMC extends MovieClip 
    {

        public var shp:MovieClip;
        public var hit:MovieClip;
        private var world:MovieClip;
        private var avt:Avatar;

        public function HealIconMC(_arg_1:Avatar, _arg_2:MovieClip):void
        {
            addFrameScript(35, frame36);
            world = _arg_2;
            avt = _arg_1;
            hit.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
            hit.buttonMode = true;
            hit.alpha = 0;
            shp.mouseEnabled = false;
            shp.mouseChildren = false;
            y = ((avt.pMC.pname.y - height) - 5);
            x = (x - int((width / 2)));
        }

        public function onClick(_arg_1:MouseEvent):void
        {
            world.healByIcon(avt);
            fClose();
        }

        public function fClose():void
        {
            stop();
            hit.removeEventListener(MouseEvent.CLICK, onClick);
            parent.removeChild(this);
        }

        internal function frame36():*
        {
            gotoAndPlay("loop");
        }


    }
}//package 

