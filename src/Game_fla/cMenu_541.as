// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//Game_fla.cMenu_541

package Game_fla
{
    import flash.display.MovieClip;

    public dynamic class cMenu_541 extends MovieClip 
    {

        public var bg:MovieClip;
        public var mHi:MovieClip;
        public var iproto:cProto;

        public function cMenu_541()
        {
            addFrameScript(0, frame1, 19, frame20);
        }

        internal function frame1():*
        {
            stop();
        }

        internal function frame20():*
        {
            MovieClip(parent).gotoAndPlay("out");
            gotoAndStop("hold");
        }


    }
}//package Game_fla

