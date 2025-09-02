package game.fia {

import flash.display.MovieClip;
import flash.text.TextField;

public class FiaListItem extends MovieClip {

    public var opacity:Number = 1;
    public var bg:MovieClip;
    public var tHeader1:TextField;
    public var tHeader2:TextField;
    public var tHeader3:TextField;

    public function FiaListItem()
    {
        tHeader1.mouseEnabled = false;
        tHeader2.mouseEnabled = false;
        tHeader3.mouseEnabled = false;
    }

}

}
