// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//Game_fla.chkBox_32

package Game_fla
{
    import flash.display.MovieClip;
    import flash.events.MouseEvent;

    public dynamic class chkBox_32 extends MovieClip 
    {

        public var checkmark:MovieClip;
        public var bitChecked:Boolean;

        public function chkBox_32()
        {
            addFrameScript(0, frame1);
        }

        public function onClick(event:MouseEvent) : void
        {
            bitChecked = (!(bitChecked));
            checkmark.visible = bitChecked;
        }

        private function frame1() : void
        {
            checkmark.mouseEnabled = false;
            checkmark.visible = bitChecked;
            this.addEventListener(MouseEvent.CLICK, onClick);
        }


    }
}//package Game_fla

