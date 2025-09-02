package game.manager {
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;

public class MonsterManager {

    private var game:Game = Game.root;
    private var queue:Array;
    private var loader:URLLoader;

    public function URLRequestQueue(onComplete:Function, onError:Function): void {
        queue = [];
        loader = new URLLoader();
        loader.addEventListener(Event.COMPLETE, onComplete);
        loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
    }

    public function addRequest(request:URLRequest):void {
        queue.push(request);

        if (queue.length == 1) {
            loadNext();
        }
    }

    private function loadNext():void {
        if (queue.length > 0) {
            var request:URLRequest = queue[0];
            loader.load(request);
        } else {
            trace("Queue empty");
        }
    }

}
}
