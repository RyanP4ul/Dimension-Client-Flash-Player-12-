package game.daily {

import assets.ib1;

import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

import game.config.ConfigurationData;

public class DailyLogin extends MovieClip {

    private var game:Game = Game.root;
    private var _lists:MovieClip;

    public var btnClose:SimpleButton;

    private var _data:Object = ["Test 1", "Test 2", "Test 3", "Test 4", "Test 5"];

    public function DailyLogin() {

        _lists = new MovieClip();
        _lists.x = 18;
        _lists.y = 54;
        addChild(_lists);

        for (var am:int = 0; am < 7; am++)
        {
            var blank:ib1 = new ib1();
            blank.width = 42;
            blank.height = 39;
            blank.name = "blank-" + am;
            blank.x = 45 * am;

            addChild(blank);

            var txtCoolDown:TextField = new TextField();

            txtCoolDown.text = "5m";

            var textFormat:TextFormat = new TextFormat();

            textFormat.font = "Space Mono";
            textFormat.size = 14;
            textFormat.color = 0xFFFFFF;
            textFormat.align = TextFormatAlign.CENTER;
            textFormat.bold = true;

            txtCoolDown.name = "txtCD" + am;
            txtCoolDown.setTextFormat(textFormat);
            txtCoolDown.wordWrap = true;
            txtCoolDown.autoSize = TextFieldAutoSize.LEFT;

            txtCoolDown.x = blank.x + (blank.width - txtCoolDown.width) / 2;
            txtCoolDown.y = blank.y + (blank.height - txtCoolDown.height) / 2;

            txtCoolDown.mouseEnabled = false;
            txtCoolDown.mouseWheelEnabled = false;

            addChild(txtCoolDown);

            var bind:keyBind = new keyBind();
            bind.key.text = am;
            bind.name = "keyA" + am;
            bind.x = txtCoolDown.x + 6 + (txtCoolDown.width - bind.width) / 2;
            bind.y = blank.height + 7;

            addChild(bind);
        }
        initLists();
    }

    private function initLists() : void
    {
        for (var i:int = 1; i <= 6; i++)
        {
            var list:DailyLoginList = new DailyLoginList();
            list.tDay.text = i + " DAY";
            list.name = "day-" + i;
            list.x = 167 * _lists.numChildren;
            list.mcCheck.visible = false;
            list.btnClaim.removeEventListener(MouseEvent.CLICK, onClick);
            list.btnClaim.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
            _lists.addChild(list);
        }
    }

    public function onClick(event:MouseEvent) : void {
        switch (event.currentTarget.name)
        {
            case "btnClose":
                break;
            case "btnClaim":
                trace(event.currentTarget.parent.name);
                break;
        }
    }

}
}
