package test {

import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.net.URLLoader;
import flash.text.TextField;

public class CharacterAskPassword extends MovieClip {

//    private var game:Game = Game.root;
//    private var characters:Characters;
//    private var id:int = 0;
    public var sType:String = null;
    private var data:Object;
    public var txtPassword:TextField;
    public var btnCloseAskPassword:SimpleButton;
    public var btnConfirm:SimpleButton;

//    public function CharacterAskPassword(characters:Characters, id:int = 0, sType:String = null, data:Object = null) {
//        this.characters = characters;
//        this.id = id;
//        this.sType = sType;
//        this.data = data;
//
//        initButton();
//    }
//
//    public function initButton():void {
//        btnClose.addEventListener(MouseEvent.CLICK, onClick);
//        btnConfirm.addEventListener(MouseEvent.CLICK, onClick);
//    }
//
//    private function initRequest():void {
//        game.onLoadMaster(onComplete, null, "api/ask/password", null, null, "POST", {
//            userId: game.getLogin().userId,
//            charId: data != null ? data.charId : id,
//            pass: txtPassword.text
//        }, false);
//    }
//
//    private function onDeleteComplete(event:Event): void {
//        var response:Object = JSON.parse(event.currentTarget.data);
//
//        if (response.bSuccess == 1 && data != null) {
//            delete game.cache.characters[data.strUsername];
//
//            characters.characters.splice(id, 1);
//            characters.selected = 0;
//            characters.updateCharacters();
//
//            if (characters.characters.length < 1) {
//                game.mcLogin.gotoAndStop("Init");
//            }
//        } else {
//            game.MsgBox.notify(response.sMsg);
//        }
//    }
//
//    private function onComplete(event:Event):void {
//        var response:Object = JSON.parse(event.target.data);
//
//        if (response.bSuccess == 1) {
//            switch (sType) {
//                case "Play":
//                    characters.initGame();
//                    break;
//                case "Change":
//                    game.preference.data.bAskPassword = false;
//                    game.preference.flush();
//                    break;
//                case "Delete":
//                    game.onLoadMaster(onDeleteComplete, null, 'api/delete/character', null, null, 'POST', {
//                        userId: game.getLogin().userId,
//                        charId: data.charId
//                    }, false);
//                    break;
//            }
//
//            game.removeChildrenByName(game.mcLogin.characters, ["CharacterAskPassword"]);
//        } else {
//            game.MsgBox.notify(response.sMsg);
//        }
//    }
//
//    public function onClick(event:MouseEvent):void {
//        switch (event.currentTarget.name) {
//            case "btnClose":
//                game.removeChildrenByName(game.mcLogin.characters, ["CharacterAskPassword"]);
//                break;
//            case "btnConfirm":
//                initRequest();
//                break;
//        }
//    }

}

}
