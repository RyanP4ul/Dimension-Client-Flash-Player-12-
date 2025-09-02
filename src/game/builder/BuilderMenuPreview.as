package game.builder {
import flash.display.MovieClip;
import flash.text.TextField;

public class BuilderMenuPreview extends MovieClip {

    public var tX:TextField;
    public var tY:TextField;
    public var param1:TextField;
    public var param2:TextField;

    public function BuilderMenuPreview() {
        addFrameScript(0, Default, 1, Monster, 2, Navigator, 3, Navigation);
    }

    private function Default(): void
    {
        stop();
    }

    private function Monster() : void
    {
        stop();
    }

    private function Navigator() : void
    {
        stop();
    }

    private function Navigation() : void
    {
        stop();
    }

}
}
