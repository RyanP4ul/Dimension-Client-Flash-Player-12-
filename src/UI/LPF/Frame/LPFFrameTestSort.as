package UI.LPF.Frame {
import flash.display.MovieClip;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.ui.Mouse;

import game.select.SelectorOptionItem;

public class LPFFrameTestSort extends LPFFrame {

    private var game:Game = Game.root;
    public var tOption:TextField;
    public var up:MovieClip;
    public var down:MovieClip;
    public var lists:MovieClip;
    public var currentSelected:String = "Default";
    public var isSelectionOpen:Boolean = false;

    public function LPFFrameTestSort()
    {
        buttonMode = true;
        tOption.mouseEnabled = false;

        lists = new MovieClip();
        lists.visible = false;
        addChild(lists);

        addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
    }

    override public function fOpen(o:Object):void
    {
        positionBy(o.r);

        if (("fData" in o)) fData = o.fData;
        if (("eventTypes" in o)) eventTypes = o.eventTypes;

        fDraw();
        getLayout().registerForEvents(this, eventTypes);
    }

    override public function fClose():void
    {
        removeEventListener(MouseEvent.CLICK, onClick);

        getLayout().unregisterFrame(this);

        if (parent != null)
        {
            var loadOuts:MovieClip = game.ui.getChildByName("LoadOuts") as MovieClip;
            if (loadOuts) game.ui.removeChild(loadOuts);

            parent.removeChild(this);
        }
    }

    protected function fDraw():void
    {
        game.onRemoveChildren(lists);

        up.visible = false;
        down.visible = true;

        if (game.preference.data.hasOwnProperty("sSortType"))
        {
            tOption.text = game.preference.data.sSortType;
            currentSelected = game.preference.data.sSortType;
        }
        else
        {
            tOption.text = String(fData.items[0].name);
        }
    }

    override public function notify(o:Object):void
    {
        if ("fData" in o) fData = o.fData;
        if ("r" in o) positionBy(o.r);
        fDraw();
    }

    private function displaySelectionOption() : void
    {
        game.onRemoveChildren(lists);

        for each (var o:Object in fData.items)
        {
            var item:SelectorOptionItem = new SelectorOptionItem();
            item.tOption.text = o.name;
            item.tOption.textColor = o.name == currentSelected ? 0xCCCCCC : 0x666666;
            item.x = -53;
            item.y = lists.numChildren * item.height + 2;
            item.buttonMode = true;
            item.addEventListener(MouseEvent.CLICK, function (event:MouseEvent) : void {
                var item:SelectorOptionItem = SelectorOptionItem(event.currentTarget);

                if (currentSelected == item.tOption.text) return;

                currentSelected = item.tOption.text;

                listVisible(false);

                tOption.text = currentSelected.toUpperCase();

                switch (String(game.ui.mcPopup.currentLabel))
                {
                    case "Inventory":
                        MovieClip(game.ui.mcPopup.getChildByName("mcInventory")).update({
                            fData: { sTypeSort: currentSelected },
                            eventType: "refreshOption"
                        });
                        break;
                    case "MergeShop":
                    case "Shop":
                        MovieClip(game.ui.mcPopup.getChildByName("mcShop")).update({
                            fData: { sTypeSort: currentSelected },
                            eventType: "refreshOption"
                        });
                        break;
                    case "Temporary":
                    case "Loot":
                        MovieClip(game.ui.mcPopup.getChildByName("mcLoot")).update({
                            fData: { sTypeSort: currentSelected },
                            eventType: "refreshOption"
                        });
                        break;
                }
            })

            lists.addChild(item);
        }

        lists.y = 19;
    }

    private function listVisible(isListVisible:Boolean) : void
    {
        if (isListVisible)
        {
            lists.visible = true;
            up.visible = true;
            down.visible = false;
        }
        else
        {
            lists.visible = false;
            up.visible = false;
            down.visible = true;
        }
    }

    private function onClick(event:MouseEvent) : void
    {
        game.mixer.playSound("Click");

        isSelectionOpen = !isSelectionOpen;

        if (isSelectionOpen)
        {
            displaySelectionOption();
            listVisible(true);
            lists.visible = true;
            up.visible = true;
            down.visible = false;
        }
        else
        {
            listVisible(false);
        }
    }

}
}
