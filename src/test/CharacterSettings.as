package test {
import Game_fla.chkBox_32;

import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.MouseEvent;

public class CharacterSettings extends MovieClip {

//    private var game:Game = Game.root;
//    private var characters:Characters;
    public var btnCloseSettings:SimpleButton;
    public var chkAskPassword:chkBox_32;
    public var chkHideCharacter:chkBox_32;

//    public function CharacterSettings(characters:Characters) {
//        this.characters = characters;
//
//        if (game.preference.data.bAskPassword as Boolean) {
//            chkAskPassword.bitChecked = true;
//        }
//
//        if (game.preference.data.bHideOtherCharacter as Boolean) {
//            chkHideCharacter.bitChecked = true;
//        }
//
//        chkAskPassword.checkmark.visible = chkAskPassword.checkmark.bitChecked;
//        chkHideCharacter.checkmark.visible = chkHideCharacter.checkmark.bitChecked;
//        btnClose.addEventListener(MouseEvent.CLICK, onClick);
//    }
//
//    private function onClick(event:MouseEvent):void {
//        switch (event.currentTarget.name) {
//            case "btnClose":
//                game.removeChildrenByName(game.mcLogin.characters, ["CharacterSettings"]);
//
//                if (!(chkAskPassword.bitChecked) != game.preference.data.bAskPassword) {
//                    characters.initAskPassword(characters[characters.selected].charId, "Change");
//                    return;
//                }
//
//                var oldHideOtherCharacter:Boolean = game.preference.data.bHideOtherCharacter;
//
//                game.preference.data.bAskPassword = chkAskPassword.bitChecked;
//                game.preference.data.bHideOtherCharacter = chkHideCharacter.bitChecked;
//                game.preference.flush();
//
//                if (oldHideOtherCharacter != game.preference.data.bHideOtherCharacter) {
//                    characters.initInterface();
//                }
//                break;
//        }
//    }

}
}
