package game.fia {

import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.text.TextField;

import game.quest.TestLoader;
import game.select.SelectorOptionItem;

public class FiaPanel extends MovieClip {

    private var game:Game = Game.root;
    private var currentSelected:String = "Default";
    private var selectionData:Array = [];
    private var isSelectionOpen:Boolean = false;

    public var currentTab:String = "friends";

    public var tHeader1:TextField;
    public var tHeader2:TextField;
    public var tHeader3:TextField;
    public var txtSearch:TextField;
    public var totalRows:TextField;
    public var emptyLists:TextField;

    public var tabs:MovieClip;
    public var mcLoading:MovieClip;
    public var selector:MovieClip;
    public var listScr:MovieClip;
    public var lists:MovieClip = new MovieClip();
    public var selectionLists:MovieClip = new MovieClip();
    public var masks:MovieClip = new MovieClip();

    public var btnClose:SimpleButton;

    public var listScrLoader:TestLoader;

    private var _data:Array = [];

    public function FiaPanel() {
        var fData:Object = MovieClip(parent).fData;

        if (fData.hasOwnProperty("tab")) currentTab = fData.tab;

        trace("FIA PANEL => GAME => " + game != null);

        txtSearch.text = "Search";

        txtSearch.addEventListener(KeyboardEvent.KEY_DOWN, onSearch, false, 0, true);
        txtSearch.addEventListener(FocusEvent.FOCUS_IN, onSearchFocusIn, false, 0, true);
        txtSearch.addEventListener(FocusEvent.FOCUS_OUT, onSearchFocusOut, false, 0, true);

        mcLoading.visible = true;

        selectionLists.x = 240.15;
        selectionLists.y = 122.45;
        addChildAt(selectionLists, 13);

        masks.x = 7.1;
        masks.y = 154.15;
        masks.graphics.beginFill(52479);
        masks.graphics.drawRect(0, 0, 531, 423);
        masks.graphics.endFill();
        addChild(masks);

        lists.x = masks.x;
        lists.y = masks.y;
        lists.mask = masks;
        addChildAt(lists, 1);

        initTabs();
        initSelection();
        initButtons();
        initLists();
    }

    private function initLists() : void
    {
        switch (currentTab) {
            case "friends":
                tHeader1.text = "Name";
                tHeader2.text = "Status";
                tHeader3.text = "Level";

                tHeader1.visible = true;
                tHeader2.visible = true;
                tHeader3.visible = true;

                if (currentTab == "friends" && game.world.myAvatar.friends == null || !game.world.myAvatar.friendsLoaded)
                {
                    game.world.myAvatar.friendsLoaded = true;
                    game.net.send("getfriendlist", []);
                }
                else
                {
                    displayLists(game.world.myAvatar.friends);
                }
                break;
            case "reputation":
                tHeader1.text = "Faction";
                tHeader2.text = "Rep";
                tHeader3.text = "Rank";

                tHeader1.visible = true;
                tHeader2.visible = true;
                tHeader3.visible = true;

                displayLists(game.world.myAvatar.factions);
                break;
            case "charArea":
                tHeader1.text = "Name";
                tHeader2.text = "Class";
                tHeader3.text = "Level";

                tHeader1.visible = true;
                tHeader2.visible = true;
                tHeader3.visible = true;

                displayLists(getCharData());
                break;
            case "ignore":
                tHeader1.text = "Name";

                tHeader1.visible = true;
                tHeader2.visible = false;
                tHeader3.visible = false;

                displayLists(game.chatF.ignoreList.data.users);
                break;
        }
    }

    private function initTabs() : void
    {
        tabs.friends.alpha = currentTab == "friends" ? 1 : 0.3;
        tabs.reputation.alpha = currentTab == "reputation" ? 1 : 0.3;
        tabs.charArea.alpha = currentTab == "charArea" ? 1 : 0.3;
        tabs.ignore.alpha = currentTab == "ignore" ? 1 : 0.3;
    }

    private function initSelection() : void
    {
        game.onRemoveChildren(selectionLists);

        isSelectionOpen = false;
        selector.buttonMode = true;
        selector.tOption.mouseEnabled = false;
        selector.up.visible = false;
        selector.down.visible = true;

        switch (currentTab) {
            case "friends":
                selectionData = ["Default", "Online", "Offline", "Level"];
                break;
            case "reputation":
                selectionData = ["Default", "Rank"];
                break;
            case "charArea":
                selectionData = ["Default", "Level"];
                break;
            case "ignore":
                selectionData = ["Default", "Level"];
                break;
        }
    }

    private function initButtons() : void
    {
        for each (var tabName:String in ["friends", "reputation", "charArea", "ignore"])
        {
            tabs[tabName].buttonMode = true;
            tabs[tabName].addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
            tabs[tabName].addEventListener(MouseEvent.MOUSE_OVER, onMouseHover, false, 0, true);
            tabs[tabName].addEventListener(MouseEvent.MOUSE_OUT, onMouseHover, false, 0, true);
        }

        selector.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        btnClose.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
    }

    public function displayLists(arr:Array) : void
    {
        game.onRemoveChildren(lists);

        _data = arr;

        if (arr.length < 1)
        {
            emptyLists.visible = true;
        }
        else
        {
            for (var i:int = 0; i < arr.length; i++)
            {
                var item:FiaListItem = new FiaListItem();

                item.bg.alpha = i % 2 == 0 ? 0.7 : 0.5;
                item.opacity = item.bg.alpha;

                switch (currentTab) {
                    case "friends":
                        item.tHeader1.text = arr[i].sName;
                        item.tHeader2.text = arr[i].sServer;
                        item.tHeader3.text = arr[i].iLvl;
                        break;
                    case "reputation":
                        item.tHeader1.text = arr[i].sName;
                        item.tHeader2.text = arr[i].iSpillRep + " / " + arr[i].iRepToRank;
                        item.tHeader3.text = "Rank " + arr[i].iRank;
                        break;
                    case "charArea":
                        item.tHeader1.text = arr[i].sName;
                        item.tHeader2.text = arr[i].sClassName;
                        item.tHeader3.text = arr[i].iLvl;
                        break;
                    case "ignore":
                        item.tHeader1.text = arr[i];
                        item.tHeader2.visible = false;
                        item.tHeader3.visible = false;
                        break;
                }

                item.y = i * item.height + 2;

                item.addEventListener(MouseEvent.MOUSE_OVER, function (event:MouseEvent) : void {
                    var item:FiaListItem = FiaListItem(event.currentTarget);
                    item.tHeader1.textColor = 0xFFFFFF;
                    item.tHeader2.textColor = 0xFFFFFF;
                    item.tHeader3.textColor = 0xFFFFFF;
                    item.bg.alpha = 1;
                });

                item.addEventListener(MouseEvent.MOUSE_OUT, function (event:MouseEvent) : void {
                    var item:FiaListItem = FiaListItem(event.currentTarget);
                    item.tHeader1.textColor = 0x999999;
                    item.tHeader2.textColor = 0x999999;
                    item.tHeader3.textColor = 0x999999;
                    item.bg.alpha = item.opacity;
                });

                lists.addChild(item);
            }

            emptyLists.visible = false;
        }

        totalRows.text = "Total Row(s): " + lists.numChildren;

        listScrLoader = new TestLoader(masks, lists, listScr);
        listScrLoader.open();

        mcLoading.visible = false;
    }

    private function displaySelectionOption() : void
    {
        game.onRemoveChildren(selectionLists);

        for (var option:String in selectionData)
        {
            var item:SelectorOptionItem = new SelectorOptionItem();
            item.tOption.text = selectionData[option];
            item.tOption.textColor = selectionData[option] == currentSelected ? 0xCCCCCC : 0x666666;
            item.y = selectionLists.numChildren * item.height + 2;
            item.buttonMode = true;
            item.addEventListener(MouseEvent.CLICK, function (event:MouseEvent) : void {
                var item:SelectorOptionItem = SelectorOptionItem(event.currentTarget);

                if (currentSelected == item.tOption.text) return;

                currentSelected = item.tOption.text;

                var clone:Array = game.copyObj(_data);

                switch (currentTab) {
                    case "friends":
                        initSelection();

                        switch (currentSelected) {
                                case "Online":
                                    displayLists(clone.filter(function (data:Object, index:int, arr:Array) : Boolean { return data != null && data.sServer == "Online"; }));
                                    break;
                                case "Offline":
                                    displayLists(clone.filter(function (data:Object, index:int, arr:Array) : Boolean  { return data != null && data.sServer == "Offline"; }));
                                    break;
                            case "Level":
                                    displayLists(clone.sortOn("iLvl", Array.NUMERIC).reverse());
                                    break;
                                default:
                                    displayLists(_data);
                                    break;
                        }
                        break;
                    case "reputation":
                        break;
                    case "charArea":
                        break;
                    case "ignore":
                        break;
                }
            })
            selectionLists.addChild(item);
        }
    }

    private function onSearch(event:KeyboardEvent): void
    {
        if (event.charCode == 13)
        {
            var search:Array = _data.filter(onFilter);

            displayLists(search.length < 1 ? _data : search);
        }
    }

    public function onFilter(data:Object, index:int, arr:Array):Boolean
    {
        return data != null && (data.sName.toLowerCase().indexOf(txtSearch.text.toLowerCase()) > -1);
    }

    private function onSearchFocusIn(event:FocusEvent): void
    {
        if (txtSearch.text == "Search")
        {
            txtSearch.text = "";
        }
    }

    private function onSearchFocusOut(event:FocusEvent): void
    {
        if (txtSearch.text == "")
        {
            txtSearch.text = "Search";
        }
    }

    private function getCharData() : Array
    {
        var data:Array = [];

        for each (var avt:Avatar in game.world.avatars)
        {
            if (avt == null) continue;

            data.push({
                sName : avt.objData.strUsername,
                sClassName : avt.objData.strClassName,
                iLvl: avt.objData.intLevel
            });
        }

        return data;
    }

    private function onClick(event:MouseEvent) : void
    {
        switch (event.currentTarget.name)
        {
            case "selector":
                isSelectionOpen = !isSelectionOpen;

                if (isSelectionOpen)
                {
                    displaySelectionOption();
                    selectionLists.visible = true;
                    selector.up.visible = true;
                    selector.down.visible = false;
                }
                else
                {
                    selectionLists.visible = false;
                    selector.up.visible = false;
                    selector.down.visible = true;
                }
                break;
            case "friends":
                if (currentTab == "friends") return;
                currentTab = "friends";
                initTabs();
                initSelection();
                initLists();
                break;
            case "reputation":
                if (currentTab == "reputation") return;
                currentTab = "reputation";
                initTabs();
                initSelection();
                initLists();
                break;
            case "charArea":
                if (currentTab == "charArea") return;
                currentTab = "charArea";
                initTabs();
                initSelection();
                initLists();
                break;
            case "ignore":
                if (currentTab == "ignore") return;
                currentTab = "ignore";
                initTabs();
                initSelection();
                initLists();
                break;
            case "btnClose":
                MovieClip(parent).onClose();
                break;
        }
    }

    private function onMouseHover(event:MouseEvent) : void
    {
        var currentTarget:MovieClip = MovieClip(event.currentTarget);

        if (currentTarget.alpha == 1) return;

        if (["friends", "reputation", "charArea", "ignore"].indexOf(currentTarget.name) > -1)
        {
            currentTarget.alpha = event.type == MouseEvent.MOUSE_OVER ? 0.7 : 0.3;
        }
    }


}

}
