// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//Game_fla.game_1_cnt_6

package Game_fla
{
import com.greensock.TweenLite;

import fl.motion.Color;

import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import flash.utils.Dictionary;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;
    import flash.events.MouseEvent;
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

import game.builder.MapBuilder;
import game.builder.MapWalkable;
import game.config.ConfigurationData;
import game.handler.DisplayHandler;
import game.utils.Queue;

import popup.Stats.StatsListItem;
import popup.Stats.StatsSubItem;

import test.Characters;

public dynamic class game_1_cnt_6 extends MovieClip
    {

        public var mcTitle:MovieClip;
        public var chkUserName:chkBox_32;
        public var chkPassword:chkBox_32;
        public var chkAutoLogin:chkBox_32;
        public var ni:TextField;
        public var pi:TextField;
        public var ModalStack:MovieClip;
        public var warning:MovieClip;
        public var mcLogo:MovieClip;
        public var btnLogin:SimpleButton;

        public function game_1_cnt_6()
        {
            addFrameScript(0, Init, 9, Characters, 15, CreateCharacter, 21, Test);
        }

        private function Init(): void
        {
            Game.root.initLogin();
            try
            {
                mcLogo.txtTitle.htmlText = ('<font color="#FFB231">New Release:</font> ' + Game.root.params.sTitle);
            }
            catch(e:Error)
            {
                trace("no sTitle");
            }
            stop();
        }



        private function Characters(): void { stop(); }
        private function CreateCharacter(): void { stop(); }

        private var data:Object = {
            "1": {
                "Name": "Iron",
                "Linkage": "Iron",
                "PropMapID": 1,
                "File": "Iron.swf"
            },
            "2": {
                "Name": "Flower",
                "Linkage": "Flower1",
                "PropMapID": 2,
                "File": "Flower1_r2.swf"
            },
            "r-2": {
                "Name": "Tree",
                "Linkage": "Tree1",
                "File": "Tree1.swf"
            }
        };

        public var queue:Queue = new Queue();
        public var loaderD:ApplicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
        public var loaderC:LoaderContext = new LoaderContext(false, loaderD);

        private function Test(): void {
            for each (var o:Object in data)
            {
                trace("Test > " + o.File + ", " + o.Linkage);
                queue.add("props/" + o.File, o.Linkage, function():void {

                    trace("Loaded > " + queue.File + ", " + queue.Linkage + " (" + queue.Count + " left)");

                    if (queue.Count == 0)
                    {
                        var assetClass:Class = loaderD.getDefinition("Iron") as Class;
                        var prop:MovieClip = new (assetClass);
                        prop.y = 300;
                        addChild(prop);

                        var assetClass1:Class = loaderD.getDefinition("Flower1") as Class;
                        var prop1:MovieClip = new (assetClass1);
                        prop1.x = 400;
                        prop1.y = 300;
                        addChild(prop1);

                        var assetClass2:Class = loaderD.getDefinition("Tree1") as Class;
                        var prop2:MovieClip = new (assetClass2);
                        prop2.x = 700;
                        prop2.y = 300;
                        addChild(prop2);

                        trace("ALL DONE!");
                    }

                    queue.next();

                }, null, loaderC);
            }
            stop();
        }

//        private function Test(): void {
//            rewardLists = new MovieClip();
//            rewardLists.x = 0;
//            rewardLists.y = 0;
//            addChild(rewardLists);
//
//            rewardObject = Game.root.objectSort(["Static", "Choice", "Roll", "Random"], rewardObject);
//
//            for (var i:String in rewardObject)
//            {
//                trace(i);
//                var property : MovieClip = reward["reward" + i];
//                property.visible = true;
//                property.y = (rewardLists.numChildren * 47) + 15;
//                rewardLists.addChild(property);
//
//                var ct:int = 0;
//
//                for (var j:String in rewardObject[i])
//                {
//                    var cnt:DFrameMCcnt = new DFrameMCcnt();
//
//                    cnt.x = 0;
//                    cnt.y = (ct * 47);
//                    ct++;
//
//                    rewardLists.addChild(cnt);
//                }
//            }
//
//            stop();
//        }

    }
}//package Game_fla

