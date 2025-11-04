package utils {

import com.adobe.images.PNGEncoder;
import com.jpauclair.Base64;

import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.FrameLabel;
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.utils.ByteArray;
import flash.utils.setTimeout;

import game.config.ConfigurationData;

public class SwfToImageConverter {

    public static function updateCharacterImage():void {

        var world:World = Game.root.world;
        var mc:MovieClip = world.myAvatar.pMC.mcChar;
        if (!mc) return;

        var bounds:Rectangle = mc.getBounds(mc);
        var scale:Number = 2;
        var w:int = Math.max(1, Math.ceil(bounds.width  * scale));
        var h:int = Math.max(1, Math.ceil(bounds.height * scale));

        var mtx:Matrix = new Matrix();
        mtx.scale(scale, scale);
        mtx.translate(-bounds.x * scale, -bounds.y * scale);

        var bmd:BitmapData = new BitmapData(w, h, true, 0x00000000);
        bmd.draw(mc, mtx, null, null, null, true);

        var png:ByteArray = PNGEncoder.encode(bmd);

        var req:URLRequest = new URLRequest(Game.serverBaseURL + "api/game/character/image/" + world.myAvatar.objData.CharID);
        req.method = URLRequestMethod.POST;
        req.contentType = "image/png";
        req.data = png;

        var loader:URLLoader = new URLLoader();
        loader.addEventListener(Event.COMPLETE, function(e:Event):void {
            trace("Character Image Updated!");
        });
        loader.load(req);

        bmd.dispose();
    }

    public static function convertItemToImage(id:int, itemName:String, equipment:String, mc:MovieClip) : void {
        if (!mc) return;

        var bounds:Rectangle = mc.getBounds(mc);
        var scale:Number = 2;
        var w:int = Math.max(1, Math.ceil(bounds.width  * scale));
        var h:int = Math.max(1, Math.ceil(bounds.height * scale));

        var mtx:Matrix = new Matrix();
        mtx.scale(scale, scale);
        mtx.translate(-bounds.x * scale, -bounds.y * scale);

        var bmd:BitmapData = new BitmapData(w, h, true, 0x00000000);
        bmd.draw(mc, mtx, null, null, null, true);

        var png:ByteArray = PNGEncoder.encode(bmd);
		var base64:String = Base64.encodeByteArray(png);

        var req:URLRequest = new URLRequest(Game.serverBaseURL + "api/game/convert/item");
        req.method = URLRequestMethod.POST;
        req.contentType = "application/json";
        req.data = JSON.stringify({
			id: id,
            name: itemName,
			equipment: equipment,
            image: base64
        });

        var loader:URLLoader = new URLLoader();
        loader.addEventListener(Event.COMPLETE, function(e:Event):void {
			Game.root.Modal("Successfully converted!", null, {}, "green,medium", "mono");
        });
        loader.load(req);

        bmd.dispose();
    }

    public static function convertMapsToImages() : void {
        var world:World = Game.root.world;
        var parts:Array = [];
        var labels:Array = [];
        var currentIndex:int = 0;

        var bm_width:int = ConfigurationData.CLIENT_WIDTH;
        var bm_height:int = ConfigurationData.CLIENT_HEIGHT;
        var isTimeline:Boolean = world.isTimeline && world.timeline;

        // Collect valid labels first
        for each (var label:FrameLabel in world.map.currentScene.labels) {
            if (label.name != "Wait" && label.name != "Blank") {
                labels.push(label);
            }
        }
		
		Game.root.mcConnDetail.showConn("Converting Files...");

        trace("[Map Convert] Found " + labels.length + " valid frames.");

        // Recursive async processor
        function processNextLabel():void {
            // If finished, upload all parts
            if (currentIndex >= labels.length) {
                uploadAllParts();
                return;
            }

            var label:FrameLabel = labels[currentIndex];
            currentIndex++;

            try {
                // Delay per frame so Flash can render between conversions
                setTimeout(function():void {
                    world.map.gotoAndStop(label.name);

                    // Adjust size if using timeline data
                    if (isTimeline) {
                        var timeline:Object = world.timeline[label.name];
                        if (timeline) {
                            bm_width = int(timeline.Width);
                            bm_height = int(timeline.Height);
                        }
                    }

                    bm_width = Math.max(ConfigurationData.CLIENT_WIDTH, bm_width);
                    bm_height = Math.max(ConfigurationData.CLIENT_HEIGHT, bm_height);

                    // Capture visible map region
                    var bmd:BitmapData = new BitmapData(bm_width, bm_height, true, 0x00000000);
                    var matrix:Matrix = new Matrix();
                    matrix.translate(world.map.x, world.map.y);
                    bmd.draw(world.map, matrix, null, null, new Rectangle(0, 0, bm_width, bm_height), true);

                    // Encode image
                    var png:ByteArray = PNGEncoder.encode(bmd);
                    var base64:String = Base64.encodeByteArray(png);
                    bmd.dispose();

                    parts.push({ name: label.name, image: base64 });

                    trace("[Map Convert] Done: " + label.name + " (" + currentIndex + "/" + labels.length + ")");

                    // Schedule next label
                    processNextLabel();

                }, 500);

            } catch (e:Error) {
                trace("[Map Convert] Error processing " + label.name + ": " + e.message);
                processNextLabel(); // Continue next even if error
            }
        }

        function uploadAllParts():void {
            trace("[Map Convert] Uploading all " + parts.length + " parts...");

            var req:URLRequest = new URLRequest(Game.serverBaseURL + "api/game/convert/map");
            req.method = URLRequestMethod.POST;
            req.contentType = "application/json";
            req.data = JSON.stringify({
                id: world.curRoom,
                name: world.strMapName,
                parts: parts
            });

            var loader:URLLoader = new URLLoader();
            loader.addEventListener(Event.COMPLETE, function(e:Event):void {
                trace("[Map Convert] All map images uploaded successfully!");
                Game.root.mcConnDetail.hideConn();
				world.map.gotoAndStop(world.strFrame);
            });
            loader.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void {
                trace("[Map Convert] Error uploading map images: " + e.text);
                Game.root.mcConnDetail.hideConn();
            });
            loader.load(req);
			
			Game.root.net.send("mapConverted", [world.strMapName]);
        }

        // Start async process
        processNextLabel();
    }

}
}
