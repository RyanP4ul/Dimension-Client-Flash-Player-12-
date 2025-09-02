// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//hitDisplay

package UI.Display
{
    import flash.display.MovieClip;

    public dynamic class hitDisplay extends MovieClip 
    {

        public var t:MovieClip;
        public var recycler:Function;

        public function hitDisplay()
        {
            addFrameScript(19, this.frame20);
        }

        private function frame20() : void
        {
            if (recycler != null) recycler(this);
            stop();
        }

        public function setData(data:*):void {
            t.ti.text = String(data);
        }


    }
}//package 

