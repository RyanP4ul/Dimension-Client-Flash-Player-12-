package game {
import flash.display.MovieClip;

public class ThreeDotLoading extends MovieClip {

    public function ThreeDotLoading() {
        addFrameScript(30, repeat);
    }

    private function repeat() : void
    {
        gotoAndPlay(1);
    }


}

}
