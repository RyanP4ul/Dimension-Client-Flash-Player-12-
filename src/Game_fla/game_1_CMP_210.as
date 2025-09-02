// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//Game_fla.game_1_CMP_210

package Game_fla
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.events.MouseEvent;

    public dynamic class game_1_CMP_210 extends MovieClip 
    {

        public var chkBtn:SimpleButton;
        public var checkmark:MovieClip;
        public var bitChecked:Boolean;

        public function game_1_CMP_210()
        {
            addFrameScript(0, frame1);
        }

        public function onClick(_arg_1:MouseEvent):*
        {
            bitChecked = (!(bitChecked));
            checkmark.visible = bitChecked;
        }

        internal function frame1():*
        {
            checkmark.mouseEnabled = false;
            chkBtn.addEventListener(MouseEvent.CLICK, onClick, false, 1, true);
        }


    }
}//package Game_fla

