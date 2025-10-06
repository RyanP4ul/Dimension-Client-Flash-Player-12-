package game.builder {
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.GlowFilter;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

import flashx.textLayout.formats.TextAlign;

dynamic public class MapResource extends BuilderObjectDraggable {

    public var shadow:MovieClip;
    public var isProp:Boolean = true;
    public var ResMapID:int = -1;
    public var Quantity:int = 1;

    private var resource:Object = null;
    private var isMining:Boolean = false;
    private var miningInteraction:MapButtonInteract;
    private var tQuantity:TextField;
    private var asset:MovieClip;

    public function MapResource() {
        SetBaseMc(shadow);
        shadow.visible = game.mapBuilder.visible;
        mouseEnabled = false;
//        mouseChildren = false;
    }

    public function init() :void
    {
        asset = MovieClip(getChildByName("asset"));

        if (!asset)
        {
            if (game.world.myAvatar.isStaff())
                game.Modal("Asset MovieClip not found!", null, {}, "red,medium", "mono");
            return;
        }

        resource = game.world.resources[ResMapID];

        if (!resource) {
            if (game.world.myAvatar.isStaff())
                game.Modal("Resource Map ID " + ResMapID + " dont have data!", null, {}, "red,medium", "mono");
            return;
        }

        asset.mouseEnabled = false;
        asset.mouseChildren = false;

        tQuantity = new TextField();
        tQuantity.defaultTextFormat = new TextFormat("Space Mono", 14, 0xFFFFFF);
        tQuantity.autoSize = TextFieldAutoSize.CENTER;
        tQuantity.text = resource && resource.hasOwnProperty("Name") ? String(resource.Name) : "Unknown";
        tQuantity.selectable = false;
        tQuantity.x = asset.x - (tQuantity.width / 2); //-(asset.width / 2 + tQuantity.width);
        tQuantity.y = -(asset.height + tQuantity.height);
        tQuantity.visible = false;
        addChild(tQuantity);

        miningInteraction = new MapButtonInteract();
        miningInteraction.x = asset.x - (miningInteraction.width / 2);
        miningInteraction.y = -(asset.height + miningInteraction.height + tQuantity.height);
        miningInteraction.buttonMode = true;
        miningInteraction.visible = false;

        miningInteraction.removeEventListener(MouseEvent.CLICK, onClick);
        miningInteraction.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);

        addChild(miningInteraction);

        asset.addEventListener(Event.ENTER_FRAME, onCheckCollision)
    }

    private function onCheckCollision(e:Event):void {
        try {
            if (asset.hitTestObject(game.world.myAvatar.pMC.shadow)) {
                miningInteraction.visible = true;
                tQuantity.visible = true;
            } else {
                miningInteraction.visible = false;
                tQuantity.visible = false;
                isMining = false;
            }
        } catch (e:Error) {
            if (asset.hasEventListener(Event.ENTER_FRAME)) {
                asset.removeEventListener(Event.ENTER_FRAME, onCheckCollision);
            }
        }
    }

    private function onClick(event:MouseEvent) : void {
        if (isMining || !miningInteraction.visible || !resource) return;

        var xtObj:Object = {
            cmd: "resource",
            args: [ResMapID, Quantity]
        };

        game.world.myAvatar.pMC.mcChar.gotoAndPlay(resource.Animation);

        game.ui.mcCastBar.fOpenWith({
            typ: "generic",
            dur: Number(resource.Duration),
            repeat: Boolean(resource.Repeat),
            txt: resource.Text,
            msg: resource.Message,
            callback: function (o:Object):void {
                trace("CALL BACK!");
            },
            args: {},
            xtObj: xtObj
        });

//        if (resource.Type == "Mining")
//        {
//            game.world.myAvatar.pMC.mcChar.gotoAndPlay("Mining");
//
//            game.ui.mcCastBar.fOpenWith({
//                typ: "generic",
//                dur: Number(resource.Mining),
//                repeat: Boolean(resource.Repeat),
//                txt: resource.Text,
//                msg: resource.Message,
//                callback: onCallBack,
//                args: {},
//                xtObj: xtObj
//            });
//        }
//        else if (resource.Type == "Collect")
//        {
//            game.world.myAvatar.pMC.mcChar.gotoAndPlay("Use");
//
//            game.ui.mcCastBar.fOpenWith({
//                typ: "generic",
//                dur: 10,
//                repeat: true,
//                txt: "Collecting...",
//                msg: "Success",
//                callback: onCallBack,
//                args: {},
//                xtObj: xtObj
//            });
//        }

        isMining = true;
    }

}
}
