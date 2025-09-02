package game.quest {

import flash.display.MovieClip;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextLineMetrics;

import game.config.ConfigurationData;

import game.controller.QuestController;

public class QuestTracker extends MovieClip {

    private var game:Game = Game.root;

    public var scrLoader:TestQuestLoader;

    public var scr:MovieClip;
    public var progress:MovieClip;
    public var bg:MovieClip;

    private var _mask:MovieClip = new MovieClip();
    private var _drag:Object = {};

    public function QuestTracker() {
        QuestController.ClearTrackerData();

        progress.txtDetail.text = "";
        progress.txtDetail.mouseEnabled = false;
        progress.txtDetail.mouseWheelEnabled = false;
        progress.txtDetail.autoSize = "left";

        bg.visible = false;
        scr.visible = false;

        _mask.graphics.beginFill(52479);
        _mask.graphics.drawRect(0, 0, 239.25, 112.25);
        _mask.graphics.endFill();
        _mask.x = 8.85;
        _mask.y = 29;
        progress.mask = _mask;
        addChild(_mask);

        init();
    }

    public function init(): void {
        update();

        addEventListener(MouseEvent.ROLL_OVER, onRollOver, false, 0, true);
        addEventListener(MouseEvent.ROLL_OUT, onRollOut, false, 0, true);
        addEventListener(MouseEvent.MOUSE_DOWN, onMoveClick, false, 0, true);
    }

    public function update() : void {
        progress.txtDetail.text = "";

        var questCount:int = 0;
        var trackerData:Object = QuestController.AcceptData;

        for (var i:String in trackerData)
        {
            var quest:Object = trackerData[i];

            progress.txtDetail.htmlText += "<font color='#00CC00'>" + quest.Name + "</font><br>";

            for (var j:String in quest.Requirements)
            {
                var requirement:Object = quest.Requirements[j];
                var invItem:Object = game.world.invTree[requirement.ItemID];

                progress.txtDetail.htmlText += " ● <u>" + requirement.Data.sName + "</u>  " + (invItem != null ? invItem.iQty : "0") +"/" + requirement.iQty;
            }

            progress.txtDetail.htmlText += "\n";

            questCount++;
        }

        if (questCount < 1) progress.txtDetail.text = "You are not on any quest!";
        if (progress.height < _mask.height) bg.height = progress.height + 40;

        scrLoader = new TestQuestLoader(_mask, progress, scr);
        scrLoader.initScroll();
    }

    private function onRollOver(_arg_1:MouseEvent):void
    {
        bg.visible = true;
        scr.visible = (progress.height > _mask.height);
    }

    private function onRollOut(_arg_1:MouseEvent):void
    {
        bg.visible = false;
        scr.visible = false;
    }

    public function onMoveClick(event:MouseEvent):void
    {
        _drag.ox = this.x;
        _drag.oy = this.y;
        _drag.mox = stage.mouseX;
        _drag.moy = stage.mouseY;
        stage.addEventListener(MouseEvent.MOUSE_UP, onMoveRelease, false, 0, true);
        addEventListener(Event.ENTER_FRAME, onMoveEnterFrame, false, 0, true);
    }

    public function onMoveRelease(_arg_1:MouseEvent) : void
    {
        stage.removeEventListener(MouseEvent.MOUSE_UP, onMoveRelease);
        this.removeEventListener(Event.ENTER_FRAME, onMoveEnterFrame);
    }

    public function onMoveEnterFrame(_arg_1:Event) : void
    {
        x = (_drag.ox + (stage.mouseX - _drag.mox));
        if (x < 0)
        {
            x = 0;
        }
        if ((x + bg.width) > ConfigurationData.CLIENT_WIDTH)
        {
            x = (ConfigurationData.CLIENT_WIDTH - bg.width);
        }
        y = (_drag.oy + (stage.mouseY - _drag.moy));
        if (y < 0)
        {
            y = 0;
        }
        if ((y + bg.height) > ConfigurationData.CLIENT_HEIGHT)
        {
            y = (ConfigurationData.CLIENT_HEIGHT - bg.height);
        }
    }

    public function toggle() : void {
        visible = !visible;
    }

}

}
