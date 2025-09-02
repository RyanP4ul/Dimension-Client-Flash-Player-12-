// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//Game_fla.charicon_312

package Game_fla
{
    import flash.display.MovieClip;

    public dynamic class charicon_312 extends MovieClip 
    {

        public var buttons:Array;

        public function charicon_312()
        {
            addFrameScript(0, frame1);
        }

        private function frame1() : void
        {
            buttons = [{
                "txt":"Panels",
                "fct": function () : void {
                    Game.root.togglePanel();
                }
            }, {
                "txt":"Quests",
                "fct": function () : void {
                    Game.root.world.showQuestTrackerList();
                }
            }, {
                "txt":"Guild",
                "fct": function () : void {
                    Game.root.world.showGuildList();
                }
            }, {
                "txt":"PvP",
                "fct": function () : void {
                    Game.root.togglePVPPanel("maps");
                }
            }, {
                "txt":"Pet Stats",
                "fct": function () : void {
                    Game.root.togglePetPanel();
                }
            }, {
                "txt":"Char Stats",
                "fct": function () : void {
                    Game.root.toggleCharStatspanel();
                }
            }, {
                "txt":"Stats",
                "fct": function () : void {
                    Game.root.toggleStatsPanel();
                }
            }, {
                "txt":"Outfit",
                "fct": function () : void {
                    Game.root.toggleOutfit();
                }
            }, {
                "txt":"Wheel",
                "fct": function () : void {
                    Game.root.toggleWheel();
                }
            }, {
                "txt":"Trade (Test)",
                "fct": function () : void {
                    Game.root.toggleTrade();
                }
            }, {
                "txt":"Your Hero"
            }];
        }


    }
}//package Game_fla

