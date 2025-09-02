package game.controller {
import flash.display.MovieClip;

public class ShopController {

    private var game:Game = Game.root;
    private var itemArr:Array = [];
    private var searchArr:Array = [];

    public function ShopController() {
    }

    public function get ShopItemArray(): Array
    {
        return itemArr;
    }

}
}
