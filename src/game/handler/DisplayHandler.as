package game.handler {
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.text.TextField;
import flash.utils.Dictionary;

public class DisplayHandler extends MovieClip {

    private var pools:Dictionary = new Dictionary();
    private var activeDisplays:Array = [];

    public function registerDisplayType(type:String, factory:Function, initialPoolSize:int = 10, maxPoolSize:int = 50):void {
        if (!pools[type]) {
            pools[type] = {
                available: [],
                factory: factory,
                maxSize: maxPoolSize
            };

            for (var i:int = 0; i < initialPoolSize; i++) {
                pools[type].available.push(factory());
            }
        }
    }

    public function show(type:String, x:int, y:int, data:Object = null):DisplayObject {
        var pool = pools[type];

        if (!pool) throw new Error("Display type not registered: " + type);

        var obj:DisplayObject;

        // Get from pool if available
        if (pool.available.length > 0) {
            obj = pool.available.pop();
        } else {
            // If too many active, recycle the oldest one
            var activeOfType:Array = activeDisplays.filter(function(d:*, ...rest):Boolean {
                return d.type === type;
            });

            if (activeOfType.length >= pool.maxSize) {
                recycle(activeOfType[0].obj);
            }

            obj = pool.factory();
        }

        // Reset and reuse
        obj.x = x;
        obj.y = y;

        if (obj.hasOwnProperty("recycler")) obj["recycler"] = recycle;

		if (type == "dotDisplay")
        {
            if (obj.hasOwnProperty("hpDisplay"))
            {
                obj["hpDisplay"] = int(data["text"]);
            }

            MovieClip(obj).init();
        }
        else
        {
			var textField:TextField = obj["t"]["ti"];

			if (textField != null)
			{
				if (data.hasOwnProperty("text")) textField.text = data["text"];
				if (data.hasOwnProperty("textColor")) textField.textColor = data["textColor"];
				if (data.hasOwnProperty("filters")) textField.filters = data["filters"];
			}
		
            MovieClip(obj).gotoAndPlay(1);
        }

        addChild(obj);
        activeDisplays.push({ type: type, obj: obj });

        return obj;
    }

    public function recycle(obj:DisplayObject):void {
        if (obj.parent) obj.parent.removeChild(obj);

        for (var i:int = 0; i < activeDisplays.length; i++) {
            if (activeDisplays[i].obj === obj) {
                var type:String = activeDisplays[i].type;
                activeDisplays.splice(i, 1);

                var pool = pools[type];
                if (pool && pool.available.length < pool.maxSize) { // ADD NEW OBJ
                    pool.available.push(obj);
                }
                return;
            }
        }
    }

}
}
