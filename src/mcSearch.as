package {

import flash.display.MovieClip;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.text.TextField;

import game.loadouts.Loadouts;

import game.select.Selector;

public class mcSearch extends MovieClip {

    public var txtSearch:TextField;
    public var bLoadOuts:MovieClip;
    private var game:Game = Game.root;

    public function mcSearch() {
        if (game.ui.mcPopup.currentLabel == "Inventory")
        {
            bLoadOuts.buttonMode = true;
            bLoadOuts.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
            bLoadOuts.visible = true;
        }
        else
        {
            bLoadOuts.visible = false;
        }

        txtSearch.addEventListener(KeyboardEvent.KEY_DOWN, onSearch, false, 0, true);
        txtSearch.addEventListener(FocusEvent.FOCUS_IN, onSearchFocusIn, false, 0, true);
        txtSearch.addEventListener(FocusEvent.FOCUS_OUT, onSearchFocusOut, false, 0, true);
    }

    public function onFilter(data:Object, index:int, arr:Array):Boolean
    {
        return data != null && (data.sName.toLowerCase().indexOf(this.txtSearch.text.toLowerCase()) > -1);
    }

    public function apply(): void
    {
        switch (game.ui.mcPopup.currentLabel) {
            case "HouseInventory":
                game.world.myAvatar.filtered_list = txtSearch.text != "" ? game.world.myAvatar.houseitems.filter(onFilter) : null;
                MovieClip(game.ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshInv"});
                break;
            case "Temporary":
                game.world.filtered_list = txtSearch.text != "" ? game.world.myAvatar.tempitems.filter(onFilter) : null;
                MovieClip(game.ui.mcPopup.getChildByName("mcLoot")).update({"eventType":"refreshInv"});
                break;
            case "Loot":
                game.world.filtered_list = txtSearch.text != "" ? game.world.dropMenu.filter(onFilter) : game.world.dropMenu;
                MovieClip(game.ui.mcPopup.getChildByName("mcLoot")).update({"eventType":"refreshInv"});
                break;
            case "MergeShop":
                game.world.filtered_list = txtSearch.text != "" ? game.world.shopinfo.items.filter(onFilter) : game.world.shopinfo.items;
                MovieClip(game.ui.mcPopup.getChildByName("mcShop")).update({"eventType":"refreshInv"});
                break;
            case "Shop":
                var shop:MovieClip = MovieClip(game.ui.mcPopup.getChildByName("mcShop"));

                txtSearch.text = "";

                game.world.filtered_list = shop.sMode == "shopBuy" ? txtSearch.text != "" ? game.world.shopinfo.items.filter(onFilter) : game.world.shopinfo.items : txtSearch.text != "" ? game.world.myAvatar.items.filter(onFilter) : game.world.myAvatar.items;

                shop.update({"eventType":"refreshInv"});
                break;
            case "Bank":
                game.world.filtered_list = txtSearch.text != "" ? game.world.myAvatar.items.filter(onFilter) : game.world.myAvatar.items;
                MovieClip(game.ui.mcPopup.getChildByName("mcBank")).update({"eventType":"refreshInv"});
                break;
            case "Inventory":
                game.world.filtered_list = txtSearch.text != "" ? game.world.myAvatar.items.filter(onFilter) : game.world.myAvatar.items;
                MovieClip(game.ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshInv"});
                break;
        }
    }

    private function onSearch(event:KeyboardEvent): void
    {
        if (event.charCode == 13)
        {
            apply()
        }
    }

    private function onSearchFocusIn(event:FocusEvent): void
    {
        if (txtSearch.text == "Search for an item")
        {
            txtSearch.text = "";
        }
    }

    private function onSearchFocusOut(event:FocusEvent): void
    {
        if (txtSearch.text == "")
        {
            txtSearch.text = "Search for an item";
        }
    }

    public function reset(): void
    {
        game.world.myAvatar.filtered_list = null;
    }

    private function onClick(event:MouseEvent) : void {
        game.mixer.playSound("Click");

        if (game.ui.getChildByName("LoadOuts")) return;

        var loadouts:Loadouts = new Loadouts();
        loadouts.name = "LoadOuts";
        loadouts.x = 985;
        loadouts.y = 70;
        game.ui.addChild(loadouts);
    }

}
}
