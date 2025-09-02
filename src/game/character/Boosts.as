package game.character {

import assets.ib2;

import flash.display.MovieClip;
import flash.display.Shape;
import flash.events.MouseEvent;
import flash.utils.Dictionary;
import flash.utils.getDefinitionByName;

import game.boost.XpBoost;

public class Boosts extends MovieClip {

    private var game:Game = Game.root;
    public var container:MovieClip = new MovieClip();
    public var scalar:Number = 0.6;
    public var icons:Dictionary = new Dictionary();
	
    public function Boosts()
    {
        name = "Boosts";

        x = 68;
        y = 75;

        container.mouseEnabled = (container.mouseChildren = false);
        addChild(container);

        game.onRemoveChildren(container);
    }

    public function createIconMC(name:String, asset:String = null, minutes:Number = 0) : void
    {
        if (icons == null) icons = new Dictionary();

        var assetClass:Class;

        if (name in icons)
        {
            icons[name].hitbox.minutes = minutes;
        }
        else
        {
            assetClass = game.world.getClass(asset) as Class;
            var icon:* = new assetClass();
            var assetClassSlot:Class = getDefinitionByName("assets.ib2") as Class;
            var slot:ib2 = new assetClassSlot() as ib2;

            var maskShape:Shape = new Shape();
            maskShape.graphics.beginFill(0xFFFFFF);
            maskShape.graphics.drawRect(0, 0, 23, 21);
            maskShape.graphics.endFill();

            var maskMc:MovieClip = new MovieClip();
            maskMc.addChild(maskShape);
            maskMc.alpha = 0;
            addChild(maskMc);

            icons[name] = container.addChild(slot);
            icons[name].name = "boosts@" + name;
            icons[name].boostTS = new Date().getTime();
            icons[name].bootsName = name;
            icons[name].hitbox = maskMc;
            icons[name].hitbox.bootsName = name;
            icons[name].hitbox.minutes = minutes;
            icons[name].width = 32;
            icons[name].height = 29;
            icons[name].cnt.removeChildAt(0);
            icons[name].scaleX = scalar;
            icons[name].scaleY = scalar;
            icons[name].tQty.visible = false;

            var temp:MovieClip = icons[name].cnt.addChild(icon);
            temp.scaleX = temp.width > temp.height ? (temp.scaleY = 34 / temp.width) : (temp.scaleY = 31 / temp.height);
            temp.x = icons[name].bg.width / 2 - temp.width / 2;
            temp.y = icons[name].bg.height / 2 - temp.height / 2;

            // icons[name].hitbox.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
            // icons[name].hitbox.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
            // icons[name].hitbox.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
            // icons[name].hitbox.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
        }
    }

    public function onMouseOver(event:MouseEvent) : void
    {
        game.ui.ToolTip.openWith({ "str":event.currentTarget.bootsName + " (" + event.currentTarget.minutes + " minute(s))" });
    }

    public function onMouseOut(event:MouseEvent) : void
    {
        game.ui.ToolTip.close();
    }

    public function rearrangeIconMC():void
    {
        var y:Number = 0;
        var i:int = 0;

        for each (var icon:Object in icons)
        {
            if (i % 4 == 0 && i != 0)
            {
                y += 28;
            }

            icon.x = 32 * i - 4 * (i / 4 | 0) + 3;
            icon.y = y;
            icon.hitbox.x = icon.x + 2;
            icon.hitbox.y = icon.y + 1;

            i++;
        }
    }

    public function removeIcon(name:String) : void
    {
        if (!(name in icons)) return;
        container.removeChild(container.getChildByName("boosts@" + name));
        delete icons[name];
        rearrangeIconMC()
    }

}
}
