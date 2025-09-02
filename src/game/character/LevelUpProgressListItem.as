package game.character {

import flash.display.MovieClip;
import flash.text.TextField;

public class LevelUpProgressListItem extends MovieClip {

    public var tDesc:TextField;

    public function LevelUpProgressListItem()
    {
        addFrameScript(0, Copper, 1, Silver, 2, Gold, 3, BagSlots, 4, Items);
    }

    private function Copper() : void
    {
        stop();
    }

    private function Silver() : void
    {
        stop();
    }

    private function Gold() : void
    {
        stop();
    }

    private function BagSlots() : void
    {
        stop();
    }

    private function Items() : void
    {
        stop();
    }

}

}
