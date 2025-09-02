// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//Game_fla.Symbol25_309

package Game_fla
{
    import flash.display.MovieClip;

    public dynamic class Symbol25_309 extends MovieClip 
    {

        public var buttons:Array;

        public function Symbol25_309()
        {
            addFrameScript(0, frame1);
        }

        private function frame1() : void
        {
            buttons = [{
                "txt":"Temp Inventory",
                "fct":"toggleTempInventory"
            }, {
                "txt":"Quests",
                "fct":"rootClass.world.showQuestTrackerList"
            }, {
                "txt":"Quests"
            }];
        }


    }
}//package Game_fla

