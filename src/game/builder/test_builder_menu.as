package game.builder {
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.Event;
import flash.events.MouseEvent;

import game.character.Boosts;

public class test_builder_menu extends MovieClip {

    public var preview:MovieClip;
    public var fxmask:MovieClip;
    public var btnClose:SimpleButton;
    public var tTitle:MovieClip;
    public var bg:MovieClip;
    public var iListA:MovieClip;
    public var iListB:MovieClip;
    public var hit:MovieClip;
    public var fData:Object = null;
    internal var mDown:Boolean = false;
    internal var hRun:int = 0;
    internal var dRun:int = 0;
    internal var mbY:int = 0;
    internal var mhY:int = 0;
    internal var mbD:int = 0;
    internal var ox:int = 0;
    internal var oy:int = 0;
    internal var mox:int = 0;
    internal var moy:int = 0;
    internal var scrTgt:MovieClip;


    private  var active:Object = [{"cd":"1900","sArg2":"","auto":true,"ts":0,"ref":"aa","icon":"i,i,i,i,NotAModaa","nam":"Auto Attack","strl":"","mp":"0","isOK":true,"id":35,"actID":-1,"typ":"aa","damage":1,"lock":false,"fx":"m","tgt":"h","range":"808","desc":"You already know how this one works.","tgtMax":"1","tgtMin":"1","anim":"Attack1,Attack2","sArg1":""},{"cd":"1425","sArg2":"","auto":false,"ts":0,"ref":"a1","icon":"i,i,i,i,NotAModa1","nam":"Button Mash","strl":"","mp":"10","isOK":true,"id":36,"actID":-1,"typ":"p","damage":2.5,"lock":false,"fx":"m","tgt":"h","range":"808","desc":"Don't think about what this skill does, just use it because it comes off cooldown really fast. Deals stacking bonus damage and increases your Dodge by 10% if the last skill used was this one, up to 15 times. Using another skill removes the Dodge and damage bonus. Can't crit.","tgtMax":"1","tgtMin":"1","anim":"UnarmedAttack1,UnarmedAttack2","sArg1":""},{"cd":"3800","sArg2":"","auto":false,"ts":0,"ref":"a2","icon":"i,i,i,i,NotAModa2","nam":"Reasonable Strike","strl":"","mp":"0","isOK":true,"id":37,"actID":-1,"typ":"p","damage":1.2,"lock":false,"fx":"m","tgt":"h","range":"808","desc":"This is a completely average hit which does perfectly normal damage…","tgtMax":"1","tgtMin":"1","anim":"Attack3","sArg1":""},{"cd":"9500","sArg2":"","auto":false,"ts":0,"ref":"a3","icon":"i,i,i,i,NotAModa3","nam":"Gamer Fuel","strl":"","mp":"0","isOK":true,"id":38,"actID":-1,"typ":"p","damage":-1,"lock":false,"fx":"m","tgt":"s","range":"808","desc":"Eat a handful of chips, healing you and applying Fueled, increasing your Hit Chance and Haste Chance by 20% for 20 seconds.","tgtMax":"1","tgtMin":"1","anim":"Mining","sArg1":""},{"cd":"2375","sArg2":"","auto":false,"ts":0,"ref":"a4","icon":"i,i,i,i,NotAModa4","nam":"Keyboard Smash","strl":"sp_NotAModa4","mp":"0","isOK":true,"id":41,"actID":-1,"typ":"p","damage":3,"lock":false,"fx":"p","tgt":"h","range":"3000","desc":"Furious that your button mashing is getting you nowhere, you throw your keyboard at your target in a fit of rage, dealing increased damage based on how much you Button Mashed and stunning them for 3 seconds. Smashing your keyboard generates a stack of Gamer Rage. Removes any active Combo count you have. Can't miss.","tgtMax":"1","tgtMin":"1","anim":"Cast1","sArg1":""},{"cd":60000,"sArg2":"","auto":false,"ts":0,"sArg1":"","ref":"i1","icon":"icu1","nam":"Potion","strl":"","mp":0,"isOK":true,"id":0,"actID":-1,"typ":"i","damage":0,"lock":false,"fx":"","tgt":"f","range":808,"desc":"Equip a potion or scroll from your inventory to use it here.","anim":"Cheer","dsrc":""}];

    public function getActionByRef(_arg_1:String):Object {
        var _local_2:*;
        for each (_local_2 in active) {
            if (_local_2.ref == _arg_1) {
                return (_local_2);
            }
        }
        return null;
    }

    public function test_builder_menu() {
        var lists:MovieClip = new MovieClip();

        var refs:Array = ["aa", "a1", "a2", "a3", "a4"];

        for each (var ref:String in refs) {
            var item:mcSkillListItem = new mcSkillListItem();

            var skill:Object = getActionByRef(ref);

            item.tName.text = skill.nam;
            item.tSub.text = skill.ref;
            item.y = item.height * lists.numChildren;

            lists.addChild(item);

            trace(JSON.stringify(skill));
        }

        lists.x = 250;

        addChild(lists);
    }

//    public function test_builder_menu() {
//        tTitle.mouseEnabled = false;
//        preview.tPreview.mouseEnabled = false;
//        hit.alpha = 0;
//        hit.buttonMode = true;
//    }
//
//    public function fOpen(status:String) : void {
//        preview.bAdd.buttonMode = true;
//        preview.t2.mouseEnabled = false;
//        preview.bAdd.addEventListener(MouseEvent.CLICK, onItemAddClick, false, 0, true);
//        btnClose.addEventListener(MouseEvent.CLICK, btnCloseClick, false, 0, true);
//        bg.addEventListener(MouseEvent.MOUSE_DOWN, onHouseMenuBGClick, false, 0, true);
//        bg.addEventListener(Event.ENTER_FRAME, onHouseMenuBGEnterFrame, false, 0, true);
//        hit.addEventListener(MouseEvent.MOUSE_DOWN, onHouseMenuBGClick, false, 0, true);
//        hit.addEventListener(Event.ENTER_FRAME, onHouseMenuBGEnterFrame, false, 0, true);
//
//        if (status.toLowerCase() == "edit") showEditMenu();
//    }
//
//    public function showEditMenu():void
//    {
//        buildHouseMenu();
//        visible = true;
//        y = 315;
//        x = int(480 - (bg.width / 2));
//    }

}
}
