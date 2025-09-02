package game.pve {
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.MouseEvent;
import flash.filters.GlowFilter;
import flash.text.TextField;

import game.character.detailedCheck;

import game.quest.TestLoader;

public class FloorReward extends MovieClip {

    private var game:Game = Game.root;

    public var data:Object;

    public var tTitle:TextField;
    public var tCompletionTime:TextField;
    public var tTotalEnemiesDefeated:TextField;
    public var tRewards:TextField;

    public var leaderBoardLists:MovieClip;
    public var leaderBoardMask:MovieClip;

    public var itemLists:MovieClip;
    public var itemMask:MovieClip;

    public var leaderBoardScr:MovieClip;
    public var itemScr:MovieClip;

    public var leaderBoardScrLoader:TestLoader;
    public var itemScrLoader:TestLoader;

    public var btnClose:SimpleButton;
    public var btnLeave:SimpleButton;
    public var btnHide:SimpleButton;
    public var btnFloor:SimpleButton;

    public function FloorReward(o:Object)
    {
        data = o;

        tRewards.mouseEnabled = false;
        tRewards.mouseWheelEnabled = false;
        tTitle.text = "Floor " + data.Level + " Cleared!";
        tRewards.htmlText = data.Copper + " <font color=\"#B87333\">copper,</font> " + data.Silver + " <font color=\"#C0C0C0\">silver,</font> " + data.Gold + " <font color=\"#FFCC00\">gold,</font> " + data.Exp + " <font color=\"#FF00FF\">exp</font>";

        btnClose.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        btnHide.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        btnLeave.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);

        initLeaderBoard();
        initRewardItems();
    }

    private function initLeaderBoard() : void
    {
        var totalEnemiesDefeated:int = 0;

        for each (var o:Object in data.leaderBoard)
        {
            totalEnemiesDefeated += int(o.defeated);

            var item:FloorRewardItemLists = new FloorRewardItemLists();
            item.tName.text = o.name;
            item.tDamageDealt.text = o.damageDealt;
            item.tDefeated.text = o.defeated;
            item.tContribution.text = o.contribution;
            item.bg.visible = leaderBoardLists.numChildren % 2 == 0;
            item.y = item.height * leaderBoardLists.numChildren;
            leaderBoardLists.addChild(item);
        }

        leaderBoardScrLoader = new TestLoader(leaderBoardMask, leaderBoardLists, leaderBoardScr);
        leaderBoardScrLoader.open();

        tTotalEnemiesDefeated.text = "Total Enemies Defeated: " + totalEnemiesDefeated + " / " + data.TotalMonsters;
    }

    private function initRewardItems() : void
    {
        for each (var o:Object in data.items)
        {
            var cnt:DFrameMCcnt = new DFrameMCcnt();
            var assetClass:Class;
            var icon:DisplayObject;

            cnt.name = "r-" + o.ItemID;
            cnt.strName.text = o.sName;
            cnt.strQ.text = int(o.iQty) < 2 ? "" : "x" + int(o.iQty);
            cnt.strRate.visible = false;
            cnt.strType.text = o.sType;

            cnt.buttonMode = false;
            cnt.mouseEnabled = true;
            cnt.mouseChildren = false;

            game.onRemoveChildren(cnt.icon);

            if (game.world.myAvatar.IsOwned(o.bHouse, o.ItemID)) {
                var checkItem:detailedCheck = new detailedCheck();
                checkItem.x = 20.75;
                checkItem.y = 7.7;
                cnt.addChild(checkItem);
            }

            try {
                assetClass = (game.world.getClass(o.sIcon) as Class);
                icon = cnt.icon.addChild(new (assetClass));
            } catch (e:Error) {
                assetClass = (game.world.getClass("iibag") as Class);
                icon = cnt.icon.addChild(new (assetClass));
            }

            icon.scaleX = icon.scaleY = 0.5;
            cnt.x = itemLists.numChildren % 2 > 0 ? cnt.x + 185 : 0;
            cnt.y = (Math.floor(itemLists.numChildren / 2) * 43) + 5;
            cnt.bg.filters = [new GlowFilter((game.world.rarity[o.iRty] != null ? game.world.rarity[o.iRty].Color : 0xFFFFFF), 1, 8, 8, 2, 1, false, false)];

            itemLists.addChild(cnt);
        }

        itemScrLoader = new TestLoader(itemMask, itemLists, itemScr);
        itemScrLoader.open();
    }

    public function onClick(event:MouseEvent) : void
    {
        switch (event.currentTarget.name)
        {
            case "btnClose":
            case "btnHide":
                visible = false;

                var btnFloorReward:mcButton = game.ui.getChildByName("btnFloorReward") as mcButton;
                if (btnFloorReward != null)
                {
                    btnFloorReward.visible = !visible;
                }
                break;
            case "btnLeave":
                game.destroyFloorReward();
                game.net.send("floorExit", []);
                break;
        }
    }

}
}
