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
            initInteract(game.world.intNpc);
        });
    }

    public function initInteract(intNpc:int):void {
        game.world.intNpc = intNpc;

        trace("NPC INDEX => " + intNpc);

        var avatar:AvatarMC = game.world.loadAvatar(game.world, pAV, true, 5); // "npc-" + pAV.objData.NpcID in game.cache.apop ? game.cache.apop[pAV.objData.NpcID] as AvatarMC : game.world.loadAvatar(game.world, pAV, true, 5);

        avatar.pname.visible = false;
        avatar.mcChar.x = -60;
        avatar.mcChar.y = 450;

//        if (!(game.cache.apop[pAV.objData.NpcID])) {
//            game.cache.apop[pAV.objData.NpcID] = avatar;
//        }

        trace("INIT INTERACT => " + JSON.stringify(pAV.objData));

        content = pAV.objData.content[game.world.intNpc];
        var npcContent:NpcContent = new NpcContent(this, pAV.objData.strUsername);

        game.world.openApop({
            npcLinkage: avatar.mcChar,
            cnt: npcContent,
            npcEntry: String(content.Entry).toLowerCase(),
            scene: String(content.Scene).toLowerCase(),
            frame: "none"
        }, true);
    }


}

}
