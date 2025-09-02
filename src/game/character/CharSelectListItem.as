package game.character {

import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.text.TextField;

public class CharSelectListItem extends MovieClip {

    public var tName:TextField;
    public var tInfo:TextField;
    public var tNewChar:TextField;
    public var slot:MovieClip;
    public var lock:MovieClip;
    public var btnDelete:SimpleButton;
    public var btnEdit:SimpleButton;
    public var highlighter:MovieClip;

    public function CharSelectListItem()
    {
        tNewChar.text = "New Character";

        tName.mouseEnabled = false;
        tNewChar.mouseEnabled = false;
        tInfo.mouseEnabled = false;

        btnEdit.visible = false;

        tNewChar.visible = false;
        slot.visible = false;
        lock.visible = false;
        highlighter.visible = false;
    }

}
}
