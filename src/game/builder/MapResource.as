package game.builder {
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.GlowFilter;
import flash.text.TextField;
import flash.text.TextFormat;

dynamic public class MapResource extends BuilderObjectDraggable {

    public var shadow:MovieClip;
    public var ResMapID:int = -1;
    public var Quantity:int = 1;

    private var isMining:Boolean = false;
    private var miningInteraction:MapButtonInteract;
    private var tQuantity:TextField;

    public function MapResource() {
        SetBaseMc(shadow);
        shadow.visible = game.mapBuilder.visible;

        // DISPLAY TEXT QUANTITY
        tQuantity = new TextField();
        tQuantity.defaultTextFormat = new TextFormat("Space Mono", 14, 0xFFFFFF);
        tQuantity.autoSize = "left";
        tQuantity.text = Quantity;
        tQuantity.selectable = false;
        tQuantity.height = height + 10;
        tQuantity.x = (width - tQuantity.width) / 2;
        tQuantity.visible = false;
        addChild(tQuantity);

        // DISPLAY BUTTON INTERACT TO TRIGGER MINING
        miningInteraction = new MapButtonInteract();
        miningInteraction.x = miningInteraction.width + width / 2;
        miningInteraction.y = tQuantity.height + 5;
        miningInteraction.buttonMode = true;
        miningInteraction.visible = false;

        miningInteraction.removeEventListener(MouseEvent.CLICK, onClick);
        miningInteraction.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);

        addChild(miningInteraction);
    }

    public function init() :void
    {
        removeEventListener(Event.ENTER_FRAME, checkCollision);
        addEventListener(Event.ENTER_FRAME, checkCollision);
    }

    private function checkCollision(e:Event):void {
        try {
            if (this.hitTestObject(game.world.myAvatar.pMC.shadow)) {
                miningInteraction.visible = true;
                tQuantity.visible = true;
            } else {
                miningInteraction.visible = false;
                tQuantity.visible = false;
                isMining = false;
            }
        } catch (e:Error) {
            if (this.hasEventListener(Event.ENTER_FRAME)) {
                this.removeEventListener(Event.ENTER_FRAME, checkCollision);
            }
        }
    }

    private function onClick(event:MouseEvent) : void {
        if (isMining || !miningInteraction.visible || !game.world.resources.hasOwnProperty(String(ResMapID))) return;

        var resource:Object = game.world.resources[ResMapID];
        var xtObj:Object = {
            cmd: "resource",
            args: [ResMapID, Quantity]
        };

        if (resource.Type == "Mining")
        {
            game.world.myAvatar.pMC.mcChar.gotoAndPlay("Mining");

            game.ui.mcCastBar.fOpenWith({
                typ: "generic",
                dur: 10,
                repeat: true,
                txt: "Mining...",
                msg: "Success",
                callback: onCallBack,
                args: {},
                xtObj: xtObj
            });
        }
        else if (resource.Type == "Collect")
        {
            game.world.myAvatar.pMC.mcChar.gotoAndPlay("Use");

            game.ui.mcCastBar.fOpenWith({
                typ: "generic",
                dur: 10,
                repeat: true,
                txt: "Collecting...",
                msg: "Success",
                callback: onCallBack,
                args: {},
                xtObj: xtObj
            });
        }

        isMining = true;
    }

    private function onCallBack(o:Object):void {
        trace("CALL BACK!");
    }

}
}
