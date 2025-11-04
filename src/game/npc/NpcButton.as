package game.npc {

import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.MouseEvent;

public class NpcButton extends MovieClip {

    private var game:Game = Game.root;
    public var interact:SimpleButton;
    private var pAV:Avatar;
    public var content:Object;

    public function NpcButton(pAv:Avatar) {
        this.pAV = pAv;

        interact.addEventListener(MouseEvent.CLICK, function (event:MouseEvent):void {
            initInteract("Main");
        });
    }

    public function initInteract(label:String):void {
        var npcLinkage:MovieClip;

        if (pAV.objData.strEntityType == "Generic") {
            var AssetClass:Class = game.world.getClass(pAV.objData.strLinkage);
            npcLinkage = new (AssetClass)();
            npcLinkage.scaleX = npcLinkage.scaleY = 4;
            npcLinkage.x = -60;
            npcLinkage.y = (npcLinkage.height / 2) + 60;
        } else {
            var avatar:AvatarMC = game.world.loadAvatar(game.world, pAV, true, 5); // "npc-" + pAV.objData.NpcID in game.cache.apop ? game.cache.apop[pAV.objData.NpcID] as AvatarMC : game.world.loadAvatar(game.world, pAV, true, 5);
            avatar.pname.visible = false;
            avatar.mcChar.x = -60;
            avatar.mcChar.y = 450;
            npcLinkage = avatar.mcChar;
        }

        trace(">>> initInterface = " + label);

        content = pAV.objData.content[label];
        
        trace(">>> " + JSON.stringify(content));
        var npcContent:NpcContent = new NpcContent(this, pAV.objData.strNpcName);

        game.world.openApop({
            npcLinkage: npcLinkage,
            cnt: npcContent,
            npcEntry: String(content.Entry).toLowerCase(),
            scene: String(content.Scene).toLowerCase(),
            frame: "none"
        }, true);
    }


}

}
