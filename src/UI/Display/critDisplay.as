package UI.Display
{
    import flash.display.MovieClip;

    public dynamic class critDisplay extends MovieClip 
    {

        public var t:MovieClip;
        public var recycler:Function;

        public function critDisplay()
        {
            addFrameScript(24, this.frame25);
        }

        private function frame25() : void
        {
            if (recycler != null) recycler(this);
            stop();
        }


    }
}