package game.pve {
import flash.display.MovieClip;
import flash.text.TextField;

public dynamic class TowerListItem extends MovieClip {

    public var tTitle:TextField;
    public var isLocked:Boolean = false;
    public var preview:MovieClip;
    public var loader:mcLoader;

    public function TowerListItem() {
        tTitle.mouseEnabled = false;
    }
}
}
