package game.utils {

import flash.events.IOErrorEvent;
import flash.system.LoaderContext;

public class Queue {

    private var game:Game = Game.root;
    private var _queue:Array;
    private var _isLoading:Boolean;
    private var _count:Number = 0;
    private var _file:String = "";
    private var _linkage:String = "";

    public function Queue() : void {
        _queue = [];
        _isLoading = false;

    }

    public function get Count() : Number { return _count; }
    public function get File() : String { return _file; }
    public function get Linkage() : String { return _linkage; }

    public function add(file:String, linkage:String, onComplete:Function, onProgress:Function, context:LoaderContext):void {
        _file = file;
        _linkage = file;

        _queue.push({
            file: _file,
            linkage: _linkage,
            onComplete: onComplete,
            context: context,
            onProgress: onProgress,
            onError: function (event:IOErrorEvent) : void { next(); }
        });

        _count++;

        if (!_isLoading) {
            next();
        }
    }

    public function next() : void {
        if (_queue.length > 0) {
            var item:Object = _queue.shift();
            _file = item.file;
            _linkage = item.linkage;
            _isLoading = true;
            game.onLoadMaster(item.onComplete, item.context, item.file, item.onProgress, item.onError);
        } else {
            _isLoading = false;
        }
    }

}
}
