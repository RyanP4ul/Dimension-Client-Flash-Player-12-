// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//auraDisplay

package UI.Display
{
    import flash.display.MovieClip;

    public dynamic class auraDisplay extends MovieClip 
    {

        public var t:MovieClip;

        public function auraDisplay()
        {
            addFrameScript(34, this.frame35);
        }

        private function frame35() : void
        {
            MovieClip(parent).removeChild(this);
            stop();
        }


    }
}//package 

