// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//Game_fla.cnt_181

package Game_fla
{
    import flash.display.MovieClip;
    import flash.net.sendToURL;
    import flash.net.URLRequest;
    import flash.net.navigateToURL;
    import flash.events.MouseEvent;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.net.*;
    import flash.media.*;
    import flash.geom.*;
    import flash.system.*;
    import flash.utils.*;
    import flash.filters.*;
    import flash.external.*;
    import flash.ui.*;
    import adobe.utils.*;
    import flash.accessibility.*;
    import flash.errors.*;
    import flash.printing.*;
    import flash.profiler.*;
    import flash.sampler.*;
    import flash.xml.*;

    public dynamic class cnt_181 extends MovieClip 
    {

        public var mcTomb:MovieClip;
		public var tDeduce:TextField;
		private var game:Game = Game.root;

        public function cnt_181()
        {
            addFrameScript(0, frame1, 4, frame5, 19, frame20, 56, frame57);
        }

        private function frame1() : void
        {
			var deduceExp:Number = Number(game.world.myAvatar.objData.intExpToLevel) * 0.1;
			var newExp:Number = Math.max(Number(game.world.myAvatar.objData.intExp) - deduceExp, 0);
			
			game.world.myAvatar.objData.intExp = newExp;
			tDeduce.text = "-" + deduceExp + " Experience";
			game.updateXPBar();
			
			game.net.send("dead", []);
			
            stop();
        }

        private function frame5() : void
        {
            visible = true;
        }

        private function frame20() : void
        {
            stop();
        }

        private function frame57() : void
        {
            stop();
        }


    }
}//package Game_fla

