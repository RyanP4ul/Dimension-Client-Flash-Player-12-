package game.loadouts {
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.text.TextField;

dynamic public class LoadoutListItem extends MovieClip {

    public var tName:TextField;
    public var highlighter:MovieClip;
    public var btnEdit:SimpleButton;
    public var btnDelete:SimpleButton;

    public function LoadoutListItem()
    {
        tName.mouseEnabled = false;
        highlighter.visible = false;
    }

}
}
