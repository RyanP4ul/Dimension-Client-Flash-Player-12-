// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//Game_fla.mcGuildpanel_500

package Game_fla
{

import abstracts.IScroll;
import abstracts.TestAbstractScroll;
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import flash.events.*;

    public dynamic class mcGuildpanel_500 extends TestAbstractScroll implements IScroll
    {

        private var game:Game = Game.root;

        public var tMemCount:TextField;
        public var tTitle:TextField;
        public var tSlots:TextField;
        public var tMotd:TextField;
        public var txtRestCost:TextField;
        public var txtSearch:TextField;

        public var btnClose:SimpleButton;
        public var btnOne:SimpleButton;
        public var btnRest:SimpleButton;

        public var bg:MovieClip;
        public var mcBuyButtons:MovieClip;

        public function mcGuildpanel_500()
        {
            addFrameScript(0, Main);

            tMotd.text = game.world.myAvatar.objData.guild.MOTD;
            tSlots.htmlText = game.world.myAvatar.objData.guild.MaxMembers + " / " + 225 + " <font color='#E2C552'>Slots</font>";
            btnClose.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        }

        private function Main(): void
        {
            displayMemberLists();

            txtRestCost.mouseEnabled = false;
            txtRestCost.text = "ADD " + String(game.world.myAvatar.objData.guild.MaxMembers - 225);

            txtSearch.addEventListener(KeyboardEvent.KEY_DOWN, onSearch, false, 0, true);
            txtSearch.addEventListener(FocusEvent.FOCUS_IN, onSearchFocusIn, false, 0, true);
            txtSearch.addEventListener(FocusEvent.FOCUS_OUT, onSearchFocusOut, false, 0, true);

            btnOne.addEventListener(MouseEvent.CLICK, onBuyClick, false, 0, true);
            btnRest.addEventListener(MouseEvent.CLICK, onBuyClick, false, 0, true);

            stop();
        }

        private function displayMemberLists(search:Boolean = false): void
        {
            if (lists.numChildren > 0) game.onRemoveChildren(lists);

            resetScroll();

            var memberOnline:int = 0;
            var members:Object = game.world.myAvatar.objData.guild.Members;

            for (var member:String in members)
            {
                if (search && txtSearch.text.length > 0 && members[member].userName.toLowerCase().indexOf(txtSearch.text.toLowerCase()) == -1) continue;

                var item:mcGuildListItem = new mcGuildListItem();
                item.tName.text = members[member].userName;
                item.tRank.text = getRank(members[member].Rank);
                item.tServer.text = members[member].Server.toLowerCase() != "offline" ? "Online" : "Offline";
                item.tLevel.text = members[member].Level;
                item.y = lists.numChildren * 17;
                lists.addChild(item);

                if (members[member].Server.toLowerCase() != "offline")
                {
                    ++memberOnline;
                }
            }

            tMemCount.text = memberOnline + "/" + members.length + " Online";

            initScroll();
        }

        private function onSearch(event:KeyboardEvent): void
        {
            if (event.charCode == 13)
            {
                displayMemberLists(true);
            }
        }

        private function onSearchFocusIn(event:FocusEvent): void
        {
            if (txtSearch.text == "Search for member")
            {
                txtSearch.text = "";
            }
        }

        private function onSearchFocusOut(event:FocusEvent): void
        {
            if (txtSearch.text == "")
            {
                txtSearch.text = "Search for member";
            }
        }

        private function getRank(rank:int):String {
            var str:String = "";

            switch (Number(rank)) {
                case 0:
                    str = "Duffer";
                    break;
                case 1:
                    str = "Member";
                    break;
                case 2:
                    str = "Officer";
                    break;
                case 3:
                    str = "Leader";
                    break;
            }

            return str;
        }

        private function onClick(event:MouseEvent): void {
            switch (event.target.name) {
                case "btnClose":
                    MovieClip(parent).onClose();
                    break;
            }
        }

        private function onBuyClick(event:MouseEvent): void {
            var amount:int = 0;

            switch (event.target.name) {
                case "btnOne":
                    amount = 1;
                    break;
                case "btnRest":
                    amount = game.world.myAvatar.objData.guild.MaxMembers - 225;
                    break;
            }

            if (amount * 200 > game.world.myAvatar.objData.intSilver)
            {
                game.MsgBox.notify("You do not have enough Silver to purchase this.");
            }
            else
            {
                game.world.addMemSlots(amount);
            }
        }

    }
}//package Game_fla

