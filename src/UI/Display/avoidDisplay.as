package UI.Display
{

    import flash.display.MovieClip;

    public dynamic class avoidDisplay extends MovieClip 
    {

        public var t:MovieClip;
        public var recycler:Function;

        public function avoidDisplay()
        {
            addFrameScript(19, this.frame20);
        }

        private  function frame20() : void
        {
            if (recycler != null) recycler(this);
            stop();
        }


    }
}