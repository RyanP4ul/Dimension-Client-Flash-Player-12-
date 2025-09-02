// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//Game_fla.mcIterator_132

package Game_fla
{
    import flash.display.MovieClip;

    public dynamic class mcIterator_132 extends MovieClip 
    {

        public var cheats:MovieClip;
        public var serverStack:MovieClip;
        public var cmd:MovieClip;
        public var bg:MovieClip;
        public var bgfx:MovieClip;
        public var eventStack:MovieClip;
        public var iClass:IteratorMC;

        public function mcIterator_132()
        {
            addFrameScript(0, frame1);
        }

        internal function frame1():*
        {
            iClass = new IteratorMC();
            iClass.init(MovieClip(this.parent.parent), this, Game.objLogin);
        }


    }
}//package Game_fla

