package game.quest {

import flash.display.MovieClip;
import flash.text.TextField;

public class QuestListItem extends MovieClip {

    public var difficult:MovieClip;
    public var select:MovieClip;
    public var mcProgress:MovieClip;
    public var mcDailyAndMonthly:MovieClip;
    public var lock:MovieClip;
    public var unlocked:MovieClip;
    public var mcTimer:MovieClip;
    public var bg:MovieClip;
    public var txtLevel:TextField;
    public var txtName:TextField;
    public var hasRequired:Boolean = false;

    public function QuestListItem() {
        txtLevel.mouseEnabled = false;
        txtName.mouseEnabled = false;
        mcProgress.visible = false;
        mcDailyAndMonthly.visible = false;
        mcTimer.visible = false;
        lock.visible = false;
        unlocked.visible = false;
    }

}
}
