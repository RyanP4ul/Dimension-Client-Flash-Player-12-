// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//Game_fla.mcCharpage_472

package Game_fla
{
    import flash.display.MovieClip;
    import flash.text.TextField;

    public dynamic class mcCharpage_472 extends MovieClip 
    {

        public var hitL:MovieClip;
        public var t1:TextField;
        public var t2:TextField;
        public var hitR:MovieClip;
        public var bar:MovieClip;
        public var signs:MovieClip;

        public function mcCharpage_472()
        {
            addFrameScript(0, frame1, 9, frame10, 19, frame20);
        }

        internal function frame1():*
        {
            stop();
        }

        internal function frame10():*
        {
            stop();
        }

        internal function frame20():*
        {
            gotoAndStop("hold");
        }


    }
}//package Game_fla

