package game.npc {

import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.MouseEvent;
import flash.net.URLRequest;
import flash.net.navigateToURL;
import flash.text.TextField;

public class NpcContentButton extends MovieClip {

    public var game:Game = Game.root;
    public var npcButton:NpcButton;
    public var btnAction:SimpleButton;
    public var txtTitle:TextField;
    public var txtSubTitle:TextField;
    public var icon:MovieClip;
    public var action:Object;

    public function NpcContentButton(npcButton:NpcButton, action:Object)
    {
        this.npcButton = npcButton;
        this.action = action;

        txtTitle.text = action.Title != null ? action.Title : "";
        txtSubTitle.text = action.SubTitle != null ? action.SubTitle : "";

        var iconClass:Class = game.world.getClass(action.Icon);
        iconClass = iconClass != null ? iconClass : game.world.getClass("iibag");
        icon.addChild(new iconClass());
        icon.scaleX = 0.4;
        icon.scaleY = 0.4;

        txtTitle.mouseEnabled = false;
        txtSubTitle.mouseEnabled = false;
        icon.mouseEnabled = false;

        btnAction.addEventListener(MouseEvent.CLICK, onClick)
    }

    private function onClick(event:MouseEvent):void
    {
        game.mixer.playSound("Click");

        switch (action.Action) {
            case "Goto":
                npcButton.initInteract(action.Value);
                break;
            case "Shop":
                game.world.sendLoadShopRequest(action.Value);
                break;
            case "Map":
                var splitMap:Array = String(action.Value).split(",");
                if (splitMap.length > 1)
                {
                    game.world.gotoTown(splitMap[0], splitMap[1], splitMap[2]);
                    game.world.removeMovieFront();
                }
                break;
            case "Test":
            case "Quest":
                game.world.showTestQuestList([action.Value]);
                break;
            case "Link":
                navigateToURL(new URLRequest(action.Value), "_blank");
                break;
            case "Move":
                var splitMove:Array = String(action.Value).split(",");
                if (splitMove.length > 1)
                {
                    game.world.moveToCell(splitMove[0], splitMove[1]);
                }
                break;
        }
    }

}

}
