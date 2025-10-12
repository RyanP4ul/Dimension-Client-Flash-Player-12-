package game.quest {

import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.filters.GlowFilter;
import flash.text.TextField;
import flash.utils.Timer;

import game.character.detailedCheck;
import game.controller.QuestController;

import game.controller.QuestController;

public class Quests extends MovieClip {

    private var game:Game = Game.root;

    public var preview:QuestPreviewMC;

    public var listScrLoader:TestLoader;
    public var previewScrLoader:TestLoader;

    public var currentListItem:QuestListItem;
    public var prevListItem:QuestListItem;

    public var questLists:MovieClip;
    public var rewardLists:MovieClip;
    private var _buttons:MovieClip = new MovieClip();

    public var listMask:MovieClip;
    public var previewMask:MovieClip;

    public var btnClose:SimpleButton;

    public var bgLists:MovieClip;
    public var bgPreview:MovieClip;

    public var listScr:MovieClip;
    public var previewScr:MovieClip;

    public var emptyLists:TextField;
    public var txtQuestName:TextField;
    public var txtAvailableQuest:TextField;

    private var _currentQuestId:int = -1;
    private var _choiceId:int = -1;
    private var _isTracker:Boolean = false;

    private var _timer:Timer = new Timer(1000);

    private var _currentSelectItem:DFrameMCcnt;
    private var _previousSelectItem:DFrameMCcnt;

    private var _rewardTypeOrder:Array = ["Static", "Choice", "Roll", "Random"];

    public function Quests() {
        emptyLists.visible = false;
        preview.visible = false;
        previewScr.visible = false;
        bgPreview.visible = false;
        questLists.mouseEnabled = true;
        questLists.buttonMode = false;

        preview.strNote.mouseWheelEnabled = false;
        preview.strNote.autoSize = "left";
        preview.strDesc.mouseWheelEnabled = false;
        preview.strDesc.autoSize = "left";
        preview.strReq.mouseWheelEnabled = false;
        preview.strReq.autoSize = "left";
        preview.rewards.strRew.mouseWheelEnabled = false;
        preview.rewards.strRew.autoSize = "left";

        txtQuestName.text = "Select a quest";

        _buttons.x = bgPreview.x;
        _buttons.y = bgPreview.height + 95;
        addChild(_buttons);

        btnClose.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);

        open();
    }

    public function open(isTracker:Boolean = false) : void
    {
        _isTracker = isTracker;
        initQuestLists();
    }

    private function initQuestLists() : void
    {
        game.onRemoveChildrens([questLists, rewardLists]);

        var data:Object = _isTracker ? QuestController.AcceptData : QuestController.Data;

        for (var quest:String in data)
        {
            if (QuestController.isQuestComplete(data[quest].ChainID, data[quest].Prerequisite) || (data[quest].hasOwnProperty("ExpireDate") && game.stringToDate(data[quest].ExpireDate).getTime() - new Date().getTime() <= 0)) continue;

            var listItem:QuestListItem = new QuestListItem();
            listItem.txtLevel.text = data[quest].Level;
            listItem.txtName.text = data[quest].Name;
            listItem.hasRequired = data[quest].Locked != null || QuestController.hasRequiredItem(int(quest)).length > 0;
            listItem.txtName.textColor = listItem.hasRequired ? 0xFF0000 : 0x999999;
            listItem.mcDailyAndMonthly.visible = ["Daily", "Weekly", "Monthly"].indexOf(data[quest].Schedule) != -1;
            listItem.select.alpha = 0;
            listItem.mcTimer.visible = data[quest].hasOwnProperty("ExpireDate");

            if (listItem.hasRequired)
            {
                listItem.lock.visible = true;
                listItem.unlocked.visible = false;
            }
            else
            {
                listItem.lock.visible = false;
                listItem.unlocked.visible = true;
            }

            listItem.y = questLists.numChildren * 31;
            listItem.name = "q-" + quest;
            listItem.mcProgress.visible = !listItem.hasRequired && QuestController.AcceptData[quest] != null;
            listItem.buttonMode = true;
            listItem.addEventListener(MouseEvent.MOUSE_OVER, onItemMouseOver, false, 0, true);
            listItem.addEventListener(MouseEvent.MOUSE_OUT, onItemMouseOut, false, 0, true);
            listItem.addEventListener(MouseEvent.CLICK, onItemClick, false, 0, true);

            questLists.addChild(listItem);
        }

        txtAvailableQuest.htmlText = "Available Quests<font color='#E2C552'>: " + questLists.numChildren + "</font>";

        questLists.x = listMask.x;
        questLists.y = listMask.y;

        listScrLoader = new TestLoader(listMask, questLists, listScr);
        listScrLoader.open();

        if (questLists.numChildren < 1)
        {
            emptyLists.visible = true;
        }

        previewVisible();
    }

    private function onItemClick (event:MouseEvent) : void
    {
        currentListItem = QuestListItem(event.currentTarget);
        initQuest(parseInt(currentListItem.name.slice(2)));
        removeEventListener(MouseEvent.CLICK, onItemClick);
    }

    private function onItemMouseOver (event:MouseEvent) : void
    {
        var listItem:QuestListItem = QuestListItem(event.currentTarget);

        if (listItem.select.alpha != 1) {
            listItem.txtName.textColor = listItem.hasRequired ? 0x7B2900 : 0xCACACA;
            listItem.select.alpha = 0.45;
        }
    }

    private function onItemMouseOut (event:MouseEvent) : void
    {
        var listItem:QuestListItem = QuestListItem(event.currentTarget);

        if (listItem.select.alpha != 1) {
            listItem.txtName.textColor = listItem.hasRequired ? 0xFF0000 : 0x999999;
            listItem.select.alpha = 0;
        }
    }

    private function initQuest(questId:int = -1) : void
    {
        if (preview.visible && preview.hasEventListener(TimerEvent.TIMER)) _timer.removeEventListener(TimerEvent.TIMER, updateCountdown);

        var strNote:String = "";
        var assetClass:Class;
        var icon:DisplayObject;

        if (prevListItem != null) {
            prevListItem.txtName.textColor = prevListItem.hasRequired ? 0xFF0000 : 0x999999;
            prevListItem.select.alpha = 0;
        }

        if (prevListItem == null || prevListItem.name != currentListItem.name) prevListItem = currentListItem;

        currentListItem.txtName.textColor = currentListItem.hasRequired ? 0xFF0000 : 0xFFFFFF;
        currentListItem.select.alpha = 1;

        if (questId < 1) return;

        _currentQuestId = questId;

        game.onRemoveChildren(rewardLists);

        var quest:Object = QuestController.Data[questId];
        var isAccepted:Boolean = QuestController.AcceptData.hasOwnProperty(String(questId));
        var hasRequirements:Boolean = QuestController.hasRequirements();

        txtQuestName.htmlText = quest.Name;

        preview.y = 64.85;

        preview.strNote.htmlText = "";
        preview.strDesc.htmlText = quest.Description;
        preview.strReq.htmlText = "";

        preview.rewards.strRew.htmlText =
                (quest.Copper > 0 ? quest.Copper + " <font color=\"#B87333\">copper</font><br>" : "") +
                (quest.Silver > 0 ? quest.Silver + " <font color=\"#C0C0C0\">silver</font><br>" : "") +
                (quest.Gold > 0 ? quest.Gold + " <font color=\"#FFCC00\">gold</font><br>" : "") +
                (quest.Exp > 0 ? quest.Exp + " <font color=\"#FF00FF\">xp</font><br>" : "") +
                (quest.FactionID != null && quest.Rep != null && quest.FactionID > 1 && quest.Rep > 0 ? quest.Rep + " <font color='#00FF66'>rep: " + quest.Faction + "</font><br>" : "") +
                (quest.hasOwnProperty("Achievement") ? "achievement <font color='#FFFF00'>" + quest.Achievement.Name + "</font>" : "");

        preview.rewards.title.visible = preview.rewards.strRew.htmlText.length > 0;
        preview.strNote.visible = false;
        preview.reqTitle.visible = false;
        preview.rewardStatic.visible = false;
        preview.rewardChoice.visible = false;
        preview.rewardRoll.visible = false;
        preview.rewardRandom.visible = false;

        preview.container.height = bgLists.height - 5;

        if (quest.hasOwnProperty("ExpireDate"))
        {
            _timer.addEventListener(TimerEvent.TIMER, updateCountdown);
            _timer.start();
            preview.strTimer.visible = true;
        }
        else
        {
            preview.strTimer.visible = false;
        }

        if (quest.Locked != null)
        {
            switch (quest.Locked)
            {
                case "Quests":
                    strNote += "Quest has not been unlocked!";
                    break;
                case "Daily":
                    strNote += "Daily Quests are only available once per day.";
                    break;
                case "Weekly":
                    strNote += "Weekly Quests are only available once per day.";
                    break;
                case "Monthly":
                    strNote += "Monthly Quests are only available once per month.";
                    break;
				case "Limited":
					strNote += "Limited Quests are no longer available.";
					break;
				default:
					strNote += "Locked!";
					break;
            }
        }

        if (quest.Upgrade == 1 && !game.world.myAvatar.isUpgraded()) strNote += "Upgrade is required for this quest!<br>";
        if (quest.Level > game.world.myAvatar.objData.intLevel) strNote += "Unlocks at level " + quest.Level + ".<br>";

        if (quest.ReqClassId != null && quest.Class != null && quest.ReqClassId > 0 && game.world.myAvatar.getCPByID(quest.ReqClassId) < quest.ReqClassPoints)
        {
            var qClassRank:int = game.getRankFromPoints(quest.ReqClassPoints);
            var qSpillClassPoints: int = quest.ReqClassPoints - game.arrRanks[qClassRank - 1];

            strNote += qSpillClassPoints > 0
                    ? ("Requires " + qSpillClassPoints + " Class Points on " + quest.Class + ", Rank" + qClassRank)
                    : ("Requires " + quest.Class + ", Rank " + qClassRank + ".");
        }

        if (quest.FactionID != null && quest.Faction != null && quest.FactionID > 0 && game.world.myAvatar.getRep(quest.FactionID) < quest.ReqReputation)
        {
            var repRank:int = game.getRankFromPoints(quest.ReqReputation);
            var spillRepRank:int = quest.ReqReputation - game.arrRanks[repRank - 1];

            strNote += spillRepRank > 0
                    ? ("Requires " + spillRepRank + " Reputation for " + quest.Faction + ", Rank " + repRank + ".")
                    : ("Requires " + quest.Faction + ", Rank " + repRank + ".");
        }

        if (quest.RequiredItem != null && quest.RequiredItem.length > 0) strNote += "Required Item(s): " + QuestController.hasRequiredItem(questId);

        if (quest.Requirements != null && quest.Requirements.length > 0)
        {
            for (var requirement:String in quest.Requirements)
            {
                var itemQty:int = game.world.invTree[quest.Requirements[requirement].ItemID] != null ? game.world.invTree[quest.Requirements[requirement].ItemID].iQty : 0;
                preview.strReq.htmlText += " ● <u>" + quest.Requirements[requirement].Data.sName + "</u>  <font color='#" + (itemQty >= quest.Requirements[requirement].iQty ? "00CC00" : "999999") + "'>" + itemQty + "</font>/" + quest.Requirements[requirement].iQty + "<br>";
            }

            preview.reqTitle.visible = true;
        }

        if (quest.Rewards != null && quest.Rewards.length > 0)
        {
            var rewardObject:Object = {};

            for (var reward:String in quest.Rewards)
            {
                if (!rewardObject.hasOwnProperty(quest.Rewards[reward].rewardType)) rewardObject[quest.Rewards[reward].rewardType] = [];
                rewardObject[quest.Rewards[reward].rewardType].push(quest.Rewards[reward]);
            }

            var sectionY:int = 0;

            for (var i:String in _rewardTypeOrder)
            {
                if (!rewardObject.hasOwnProperty(_rewardTypeOrder[i])) continue;

                var property : MovieClip = preview["reward" + _rewardTypeOrder[i]];
                property.visible = true;
                property.x = 0;
                property.y = sectionY;
                rewardLists.addChild(property);

                var ct:int = 0;

                for (var j:String in rewardObject[_rewardTypeOrder[i]])
                {
                    var cnt:DFrameMCcnt = new DFrameMCcnt();
                    var rarity:Object = game.world.rarity[rewardObject[_rewardTypeOrder[i]][j].iRty];

                    cnt.name = "r-" + rewardObject[_rewardTypeOrder[i]][j].Data.ItemID;
                    cnt.data = rewardObject[_rewardTypeOrder[i]][j].Data;
                    cnt.strName.text = rewardObject[_rewardTypeOrder[i]][j].Data.sName;
                    cnt.strQ.text = "x" + int(rewardObject[_rewardTypeOrder[i]][j].iQty); // int(rewardObject[i][j].iQty) < 2 ? "" : "x" + int(rewardObject[i][j].iQty);
                    cnt.strRate.text = int(rewardObject[_rewardTypeOrder[i]][j].iRate) + "%";
                    cnt.strType.text = (rarity != null ? "<font color='" + String(rarity.Color).replace("0x", "#") + "'>" + rarity.Name + " Rarity" : "Unknown Rarity") + " • " +  rewardObject[_rewardTypeOrder[i]][j].Data.sType;

                    cnt.buttonMode = true;
                    cnt.mouseEnabled = true;
                    cnt.mouseChildren = false;

                    if (i == "Choice" && isAccepted && !hasRequirements)
                    {
                        cnt.addEventListener(MouseEvent.CLICK, function (event:MouseEvent) : void {
                            var item:DFrameMCcnt = DFrameMCcnt(event.currentTarget);
                            var itemId: int = parseInt(item.name.slice(2));

                            if (itemId < 1) return;

                            _choiceId = itemId;

                            if (_previousSelectItem != null)
                            {
                                var previousFilters:Array = _previousSelectItem.bg.filters;
                                previousFilters.pop();
                                _previousSelectItem.bg.filters = previousFilters;
                            }

                            var filters:Array = item.bg.filters;
                            filters.push(new GlowFilter(0xFF0000, 1, 8, 8, 2, 1, false, false));
                            item.bg.filters = filters;
                            _currentSelectItem = item;
                            _previousSelectItem = item;
                        }, false, 0, true);
                    }
                    else
                    {
                        cnt.addEventListener(MouseEvent.CLICK, function (event:MouseEvent) : void {
                            var item:DFrameMCcnt = DFrameMCcnt(event.currentTarget);

                            if (game.ui.mcPopup.currentLabel == "ItemPreview") game.ui.mcPopup.fClose();

                            game.mixer.playSound("Click");
                            game.world.selectPreview = item.data;
                            game.ui.mcPopup.fOpen("ItemPreview");
                        });
                    }

                    game.onRemoveChildren(cnt.icon);

                    if (game.world.myAvatar.IsOwned(rewardObject[_rewardTypeOrder[i]][j].bHouse, rewardObject[_rewardTypeOrder[i]][j].ItemID)) {
                        var checkItem:detailedCheck = new detailedCheck();
                        checkItem.x = 20.75;
                        checkItem.y = 7.7;
                        cnt.addChild(checkItem);
                    }

                    try {
                        assetClass = (game.world.getClass(rewardObject[_rewardTypeOrder[i]][j].Data.sIcon) as Class);
                        icon = cnt.icon.addChild(new (assetClass));
                    } catch (e:Error) {
                        assetClass = (game.world.getClass("iibag") as Class);
                        icon = cnt.icon.addChild(new (assetClass));
                    }

                    icon.scaleX = icon.scaleY = 0.6;
                    cnt.x = 0;// ct % 2 > 0 ? cnt.x + 185 : 0;
                    cnt.y = (ct * 49) + 20; // (Math.floor(ct / 2) * 43) + 25;
                    cnt.bg.filters = [new GlowFilter((game.world.rarity[rewardObject[_rewardTypeOrder[i]][j].iRty] != null ? game.world.rarity[rewardObject[_rewardTypeOrder[i]][j].iRty].Color : 0xFFFFFF), 1, 8, 8, 2, 1, false, false)];

                    property.addChild(cnt);

                    ct++;
                }

                sectionY += property.height + 13;
            }

//            for (var i:String in rewardObject)
//            {
//                var property : MovieClip = preview["reward" + i];
//                property.visible = true;
//                property.y = (rewardLists.numChildren * 47) + 15;
//                rewardLists.addChild(property);
//
//                var ct:int = 0;
//
//                for (var j:String in rewardObject[i])
//                {
//
//                }
//            }

            preview.addChild(rewardLists);
        }

        if (strNote.length > 1)
        {
            preview.strNote.htmlText = strNote;
            preview.strNote.visible = true;
        }

        preview.strNote.y = preview.strTimer.visible ? preview.strTimer.textHeight + 15 : 8.5;
        preview.descTitle.y = getPreviewTitlePositionY();
        preview.strDesc.y = Math.round(preview.descTitle.y + 13);
        preview.reqTitle.y = preview.strDesc.y + preview.strDesc.textHeight + 10;
        preview.strReq.y = preview.reqTitle.y + 15;
        preview.rewards.y = preview.reqTitle.visible ? preview.strReq.y + preview.strReq.textHeight + 10 : preview.strDesc.y + preview.strDesc.textHeight + 10;

        if (rewardLists.numChildren > 0)
        {
            rewardLists.x = preview.rewards.x;
            rewardLists.y = preview.rewards.y + preview.rewards.height + 10;
        }

        preview.container.height = preview.height;

        previewScrLoader = new TestLoader(previewMask, preview, previewScr);
        previewScrLoader.open();

        previewVisible(true);
        initQuestButton(questId, strNote.length > 0, isAccepted, hasRequirements);
    }

    private function getPreviewTitlePositionY() : int {
        if (!preview.strTimer.visible && preview.strNote.visible) return preview.strNote.y + preview.strNote.textHeight + 10;
        if (preview.strTimer.visible && !preview.strNote.visible) return preview.strTimer.textHeight + 20;
        if (preview.strTimer.visible && preview.strNote.visible) return preview.strNote.y + preview.strNote.textHeight + 10;
        if (!preview.strTimer.visible && !preview.strNote.visible) return 8.5;
        return 0;
    }

    private function updateCountdown(event:TimerEvent):void {
        try {
            var quest:Object = QuestController.Data[_currentQuestId];

            if (quest == null) return;

            var expireDate:Date = game.stringToDate(quest.ExpireDate);

            var timeDifference:Number = expireDate.getTime() - new Date().getTime();

            if (timeDifference <= 0) {
                initQuestLists();
                previewVisible(false);
                _timer.stop();
            } else {
                var seconds:Number = Math.floor(timeDifference / 1000);
                var minutes:Number = Math.floor(seconds / 60);
                var hours:Number = Math.floor(minutes / 60);
                var days:Number = Math.floor(hours / 24);

                hours %= 24;
                minutes %= 60;
                seconds %= 60;

                preview.strTimer.text = days + " days, " + hours + " hours, " + minutes + " minutes, " + seconds + " seconds";
            }
        } catch (e:Error) {
            _timer.removeEventListener(TimerEvent.TIMER, updateCountdown);
        }
    }

    private function initQuestButton(questId:int, hasRequired:Boolean, isAccepted:Boolean, hasRequirements:Boolean) : void
    {
        game.onRemoveChildren(_buttons);

        var buttonArray:Array = [];

        if (_isTracker)
        {
            buttonArray = ["Unaccept"];
        }
        else if (!hasRequired && isAccepted && !hasRequirements && !_isTracker)
        {
            buttonArray = ["TurnIn", "Unaccept"];
        }
        else if (!hasRequired && isAccepted && hasRequirements && !_isTracker)
        {
            buttonArray = ["Unaccept"];
        }
        else if (!hasRequired && !isAccepted && !hasRequirements && !_isTracker)
        {
            buttonArray = ["Accept"];
        }

        for (var name:String in buttonArray)
        {
            var questBtn:QuestButton = new QuestButton();
            questBtn.ti.text = buttonArray[name];
            questBtn.x = _buttons.numChildren * 120;
            questBtn.name = "btnQuest" + buttonArray[name];
            questBtn.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
            _buttons.addChild(questBtn);
        }
    }

    public function reset() : void
    {
        _currentQuestId = -1;

        if (prevListItem != null) prevListItem.select.alpha = 0;
        if (currentListItem != null) currentListItem = null;

        game.onRemoveChildrens([questLists, _buttons, rewardLists]);

        previewVisible(false);
        initQuestLists();
    }

    private function onClick(event:MouseEvent) : void
    {
        game.mixer.playSound("Click")

        switch (String(event.currentTarget.name))
        {
            case "btnClose":
                btnClose.removeEventListener(MouseEvent.CLICK, onClick);

                if (_timer != null)
                {
                    if (_timer.hasEventListener(TimerEvent.TIMER))
                    {
                        _timer.removeEventListener(TimerEvent.TIMER, updateCountdown)
                    }

                    _timer.stop();
                    _timer = null;
                }

                if (game.ui.mcPopup.currentLabel == "ItemPreview") game.ui.mcPopup.fClose();
                if (listScrLoader != null) listScrLoader.close();
                if (previewScrLoader != null) previewScrLoader.close();
                stage.focus = stage;
                parent.removeChild(this);
                break;
            case "btnQuestAccept":
                if (_currentQuestId < 1 || !game.world.coolDown("acceptQuest")) return;

                QuestController.addAccept(_currentQuestId, QuestController.Data[_currentQuestId]);

                game.net.send("acceptQuest", [_currentQuestId]);
                game.ui.mcQuestTracker.update();

                currentListItem.mcProgress.visible = true;

                initQuest(_currentQuestId);
                break;
            case "btnQuestUnaccept":
                if (_currentQuestId < 1 || !game.world.coolDown("unacceptQuest")) return;

                QuestController.Unaccept(_currentQuestId);

                game.net.send("unacceptQuest", [_currentQuestId]);
                game.ui.mcQuestTracker.update();

                if (currentListItem.mcProgress.visible) currentListItem.mcProgress.visible = false;

                initQuest(_currentQuestId);
                break;
            case "btnQuestTurnIn":
                if (_currentQuestId < 1 || !game.world.coolDown("questComplete")) return;

                if (preview.rewardChoice.visible && _choiceId == -1)
                {
                    game.addUpdate("Please choose a reward before turning the quest in!");
                    game.chatF.pushMsg("warning", "Please choose a reward before turning the quest in!", "SERVER", "", 0);
                    return;
                }

                if (QuestController.maximumQuestTurnIns(_currentQuestId) > 1 && !QuestController.Data[_currentQuestId].Repeat)
                {
                    game.Modal("Turn-in the quest how many times?", function onQtyComplete(o:Object) : void {
                        if (o.accept) game.net.send("questComplete", [_currentQuestId, _choiceId, o.iQty]);
                    }, {}, "white,medium", null, false, {
                        min: 1,
                        max: QuestController.maximumQuestTurnIns(_currentQuestId),
                        base: 1
                    });
                }
                else
                {
                    game.net.send("questComplete", [_currentQuestId, _choiceId, 1]);
                }
                break;
        }
    }

    public function previewVisible(visible:Boolean = false) : void
    {
        preview.visible = visible;
        previewScr.visible = visible;
        bgPreview.visible = visible;
    }

    private function getRewardType(str:String) : String
    {
		var rewardType:String = "";
        switch (str.toUpperCase()) {
            case "S":
				rewardType = "Static";
				break;
            case "R": 
				rewardType = "Random";
            case "C": 
				rewardType = "Choice";
				break;
        }
		
		return rewardType;
    }

}

}
