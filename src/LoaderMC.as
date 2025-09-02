// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

//LoaderMC

package
{
import flash.display.MovieClip;
import flash.text.TextField;
import flash.display.SimpleButton;
import flash.events.MouseEvent;
import flash.display.Loader;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.system.LoaderContext;
import flash.system.ApplicationDomain;
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.events.*;

public class LoaderMC extends MovieClip
{

    public var mcPct:TextField;
    public var btnCancel:SimpleButton;
    public var strLoad:TextField;
    internal var mcDest:MovieClip;
    internal var isEvent:Boolean = false;
    private var rootClass:MovieClip;
    public var history:Object = {};

    public function LoaderMC(rootClassMC:MovieClip)
    {
        btnCancel.addEventListener(MouseEvent.CLICK, onCancelClick);
        rootClass = rootClassMC;
    }

    public function loadFile(mcDestination:MovieClip, strFilename:String, strDescription:String, isEvt:Boolean=false):void
    {
        var now:Number = new Date().getTime();
        var assetsDomain:ApplicationDomain = new ApplicationDomain();
        var assetsContext:LoaderContext = new LoaderContext(false, assetsDomain);
        assetsContext.checkPolicyFile = false;
        assetsContext.allowCodeImport = true;
        isEvent = isEvt;
        if (strDescription != "Inline Asset")
        {
            MovieClip(Game.root).addChild(this);
        }
        mcDest = mcDestination;
        rootClass.onLoadMaster(this.onFileLoadComplete, assetsContext, strFilename, onFileLoadProgress, onFileLoadError);
    }

    private function onFileLoadComplete(evt:Event):void
    {
        var s:String;
        var o:Object;
        var world:* = rootClass.world;
        var ldr:Loader = Loader(evt.target.loader);
        try
        {
            for each (s in history)
            {
                if (history[s].ldr == ldr)
                {
                    delete history[s];
                }
            }
        }
        catch(e:Error)
        {
        }
        ldr.removeEventListener(Event.COMPLETE, onFileLoadComplete);
        ldr.removeEventListener(ProgressEvent.PROGRESS, onFileLoadProgress);
        var swf:* = MovieClip(ldr.content);
        mcDest.addChild(swf);
        if (((isEvent) && ("eventTrigger" in world.map)))
        {
            o = {
                "cmd":"fileLoaded",
                "args":{"loc":"default"}
            };
            world.map.eventTrigger(o);
        }
        mcDest = null;
        try
        {
            MovieClip(parent).removeChild(this);
        }
        catch(e:Error)
        {
        }
    }

    private function onFileLoadError(_arg_1:IOErrorEvent):void
    {
        trace("File Not Found!");
    }

    private function onFileLoadProgress(evt:ProgressEvent):void
    {
        var procentLoaded:int = int(Math.floor(((evt.bytesLoaded / evt.bytesTotal) * 100)));
        if (evt.bytesTotal <= 0)
        {
            procentLoaded = 0;
        }
        strLoad.text = "Loading!";
        mcPct.text = (procentLoaded + "%");
    }

    public function closeHistory():void
    {
        var s:String;
        for each (s in history)
        {
            try
            {
                history[s].ldr.close();
            }
            catch(e:Error)
            {
            }
            delete history[s];
        }
        history = {};
    }

    private function onCancelClick(evt:MouseEvent):void
    {
        rootClass.world.moveToCell("Enter", "Spawn");
        rootClass.clearExternamSWF();
        try {
            MovieClip(parent).removeChild(this);
        }
        catch(e:Error) {
        }
        //MovieClip(Game.root).logout();
        //MovieClip(parent).removeChild(this);
    }


}
}//package 

