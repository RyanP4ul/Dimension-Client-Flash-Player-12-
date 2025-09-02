package game.select {
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.MouseEvent;
import flash.text.TextField;

public class Selector extends MovieClip {

    private var game:Game = Game.root;

    public var main:SimpleButton;
    public var currentOption:String = "Default";

    private var _data:Object = {};
    private var _lists:MovieClip = new MovieClip();
    private var _isOpen:Boolean = false;

    public function get data(): Object
    {
        return _data;
    }

    public function set data(newData:Object)
    {
        _data = newData;
    }

    public function init():void
    {
        main.addEventListener(MouseEvent.CLICK, onClick);
//        stage.addEventListener(MouseEvent.CLICK, onStageClick);
    }

    public function get isOpen():Boolean
    {
        return _isOpen;
    }

    private function onStageClick(event:MouseEvent):void {
        if (_isOpen && event.target != main) {
            _isOpen = false;
            closeOption();
        }
    }

    public function closeOption():void
    {
        game.onRemoveChildren(_lists);
        _isOpen = false;
    }

    private function onClick(event:MouseEvent): void {
        if (_isOpen)
        {
            closeOption();
            return;
        }

        _isOpen = true;

        _lists.x = main.x;
        _lists.y = main.y + 27;

        for (var data:String in _data)
        {
            var item:SelectorOptionItem = new SelectorOptionItem();

            item.tOption.text = _data[data].name;
            item.tOption.textColor = _data[data].name.toString() == currentOption ? 0xCCCCCC : 0x666666;
            item.y = _lists.numChildren * 25;
            item.buttonMode = true;
            item.addEventListener(MouseEvent.CLICK, function (event:MouseEvent):void {
                var tempCurrentOption:String = (event.currentTarget as SelectorOptionItem).tOption.text;

                if (currentOption == tempCurrentOption) return

                currentOption = tempCurrentOption;
                closeOption();

                switch (String(game.ui.mcPopup.currentLabel))
                {
                    case "Inventory":
                        MovieClip(game.ui.mcPopup.getChildByName("mcInventory")).update({
                            fData: { sTypeSort: currentOption },
                            eventType: "refreshOption"
                        });
                        break;
                    case "MergeShop":
                    case "Shop":
                        MovieClip(game.ui.mcPopup.getChildByName("mcShop")).update({
                            fData: { sTypeSort: currentOption },
                            eventType: "refreshOption"
                        });
                        break;
                    case "Temporary":
                    case "Loot":
                        MovieClip(game.ui.mcPopup.getChildByName("mcLoot")).update({
                            fData: { sTypeSort: currentOption },
                            eventType: "refreshOption"
                        });
                        break;
                }
            });
            _lists.addChild(item);
        }

        addChild(_lists);
    }

}
}
