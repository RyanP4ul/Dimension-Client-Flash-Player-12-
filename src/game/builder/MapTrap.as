package game.builder {
import flash.display.MovieClip;
import flash.events.Event;
import flash.utils.getDefinitionByName;

dynamic public class MapTrap extends BuilderObjectDraggable {

    public var isEntered:Boolean = false;

    public var shadow:MovieClip;
    public var isEvent:Boolean = true;

    public var iDamage:Number = 0;
    public var strStrl:String;
    public var strSound:String;

    public function MapTrap() {
        SetBaseMc(shadow);
        visible = game.mapBuilder.visible;
        addEventListener("enter", onEnter);
    }

    private function onEnter(event:Event) : void {
        if (isEntered) return;

        isEntered = true;
        game.net.send("trap", [iDamage]);

        game.mixer.playSound(strSound);

        var assetClass:Class = game.world.getClass(strStrl);
        var spell:MovieClip = new (assetClass);
        spell.x = x + 22;
        spell.y = y + 22;
        game.world.CHARS.addChild(spell);
    }

}

}
