package game.controller {
import game.controller.QuestController;

public class QuestController {

    private static var game:Game = Game.root;

    private static var _data:Object = {};
    private static var _trackerData:Object = {};

    public static function get Data() : Object { return _data; }
    public static function set Data(o:Object) : void { _data = o; }
    public static function get AcceptData() : Object { return _trackerData; }
    public static function ClearData() : void { _data = {}; }
    public static function ClearTrackerData() : void { _trackerData = {}; }

    public static function addQuest(questId:int, data:Object):void
    {
        if (_data[questId] != null) return;
        _data[questId] = data;
    }

    public static function removeQuest(questId:int):void
    {
        if (!_data.hasOwnProperty(String(questId))) return;
        delete _data[questId];
    }

    public static function isQuestComplete(chainId:int, prerequisite:int) : Boolean
    {
        return game.world.myAvatar.objData.quests.hasOwnProperty(chainId) && game.world.myAvatar.objData.quests[chainId] >= prerequisite;
    }

    public static function addAccept(questId:int, data:Object):void
    {
        if (_trackerData[questId] != null) return;
        if (!data.hasOwnProperty("isComplete")) data.isComplete = false;

        _trackerData[questId] = data;
    }

    public static function Unaccept(questId:int):void
    {
        if (!_trackerData.hasOwnProperty(String(questId))) return;
        delete _trackerData[questId];
    }

    public static function maximumQuestTurnIns(questId:int) : int
    {
        var turnInCount:int = -1;
        var quest:Object = _data[questId];

        if (quest == null || !quest.hasOwnProperty("Requirements")) return 0;

        for (var key:String in quest.Requirements)
        {
            var itemId:int = int(quest.Requirements[key].ItemID);
            var quantity:int = int(quest.Requirements[key].iQty);

            if (game.world.invTree[itemId] == null || game.world.invTree[itemId].iQty < quantity) return 0;

            if (game.world.myAvatar.isItemEquipped(itemId))
            {
                game.MsgBox.notify("Cannot turn in equipped item(s)!");
                return 0;
            }

            var tempQty:int = Math.floor(game.world.invTree[itemId].iQty / quantity);
            if (turnInCount == -1 || turnInCount > tempQty) turnInCount = tempQty;
        }

        return Math.min(turnInCount, 250);
    }

    public static function hasRequiredItem(questId:int) : String
    {
        var quest:Object = QuestController.Data[questId];
        var strNote:String = "";

        for (var requiredItem:String in quest.RequiredItem)
        {
            if (quest.RequiredItem[requiredItem] == null
                    || (game.world.invTree[quest.RequiredItem[requiredItem].Data.ItemID] != null
                            && game.world.invTree[quest.RequiredItem[requiredItem].Data.ItemID].iQty >= quest.RequiredItem[requiredItem].iQty)) continue;

            if (quest.RequiredItem[requiredItem].Data.sES == "ar")
            {
                var classRank:int = game.getRankFromPoints(quest.RequiredItem[requiredItem].iQty);
                var spillClassPoints: int = quest.RequiredItem[requiredItem].iQty - game.arrRanks[classRank - 1];

                strNote += (spillClassPoints > 0 ? spillClassPoints + " Class Points on " : "") + quest.RequiredItem[requiredItem].Data.sName + ", Rank " + classRank + ". ";
            }
            else
            {
                strNote += quest.RequiredItem[requiredItem].Data.sName + (quest.RequiredItem[requiredItem].iQty > 1 ? " x" + quest.RequiredItem[requiredItem].iQty : " ");
            }

            strNote += "  ";
        }

        return strNote;
    }

    public static function hasRequirements() : Boolean
    {
        for (var itemId:String in _trackerData)
        {
            if (_trackerData[itemId] == null || _trackerData[itemId].length < 1) continue;

            for each(var key:int in _trackerData[itemId].Requirements)
            {
                var rItemId:int = _trackerData[itemId].Requirements[key].ItemID;
                var rQty:int = _trackerData[itemId].Requirements[key].iQty;
                var invItemObj:Object = game.world.invTree[rItemId];

                if (invItemObj == null || invItemObj.iQty < rQty) return true;
            }
        }

        return false;
    }

    public static function refreshTracker() : void
    {
        for (var questId:String in _trackerData)
        {
            if (_trackerData[questId] == null || _trackerData[questId].length < 1) continue;

            var hasRequirements:Boolean = false;

            for each(var key:int in _trackerData[questId].Requirements)
            {
                var rItemId:int = _trackerData[questId].Requirements[key].ItemID;
                var rQty:int = _trackerData[questId].Requirements[key].iQty;
                var invItemObj:Object = game.world.invTree[rItemId];

                if (invItemObj == null || invItemObj.iQty < rQty)
                {
                    hasRequirements = true;
                    break;
                }
            }

            if (!hasRequirements) _trackerData[questId].isComplete = true;
        }

        game.ui.mcQuestTracker.update();
    }

    public static function updateQuest(itemObj:Object) : void
    {
        for (var questId:String in _trackerData)
        {
            if (_trackerData[questId] == null || !_trackerData[questId].hasOwnProperty("Requirements") || _trackerData[questId].Requirements.length < 1) continue;

            for each(var key:int in _trackerData[questId].Requirements)
            {
                var rItemId:int = _trackerData[questId].Requirements[key].ItemID;
                var rQty:int = _trackerData[questId].Requirements[key].iQty;
                var invItemObj:Object = game.world.invTree[rItemId];

                if (itemObj.ItemID == rItemId && invItemObj != null && invItemObj.iQty <= rQty) game.addUpdate(_trackerData[questId].Name + ": " + invItemObj.sName + " " + invItemObj.iQty + "/" + rQty);
            }

            refreshTracker();

            if (_trackerData[questId].isComplete)
            {
                game.addUpdate(_trackerData[questId].Name + " complete!");
                game.mixer.playSound("Good");
            }
        }
    }

}
}