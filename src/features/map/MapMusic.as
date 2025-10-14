package features.map {
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;

public class MapMusic extends MovieClip {

    private var game:Game = Game.root;
    public var btnMusic:SimpleButton;
    public var tMusic:TextField;

    public function MapMusic() {
        addEventListener(Event.ADDED_TO_STAGE, onAdded);
    }

    private function onAdded(e:Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, onAdded);

        tMusic.mouseEnabled = false;
        tMusic.text = "Music On";

        btnMusic.addEventListener(MouseEvent.CLICK, toggle, false, 0, true);
    }

    private function toggle(event:MouseEvent) : void
    {
        game.world.bMapMusic = !game.world.bMapMusic;

        if (game.world.bMapMusic)
        {
            game.world.playMapMusic();
            tMusic.text = "Music On";
        }
        else
        {
            if (game.world.mapMusicChannel) {
                game.world.mapMusicChannel.stop();
                game.world.mapMusicChannel = null;
            }

            tMusic.text = "Music Off";
        }
    }

}

}
