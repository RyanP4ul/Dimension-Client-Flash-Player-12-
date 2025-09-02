package game.character {
import flash.display.MovieClip;

public class LevelUpProgress extends MovieClip {

    private var game:Game = Game.root;
    private var _data:Object = {
        "levelUp": 100,
        "rewards": [
            {
                "type": "Copper",
                "desc": "+500 copper"
            },
            {
                "type": "Items",
                "desc": "Random Items"
            },
            {
                "type": "BagSlots",
                "desc": "+5 BagSlots"
            }
        ]
    }
    public var lists:MovieClip = new MovieClip();

    public function LevelUpProgress() {
        lists.x = 27;
        lists.y = 133;
        addChild(lists);

        for each(var reward:Object in _data.rewards)
        {
            var item:LevelUpProgressListItem = new LevelUpProgressListItem();
            item.tDesc.text = reward.desc;
            item.gotoAndStop(reward.type);
            item.x = item.width * lists.numChildren;
            lists.addChild(item);
        }
    }
}
}
