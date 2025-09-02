package game.aura {
import assets.ib2;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.Shape;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.ColorTransform;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.utils.getDefinitionByName;

public class TargetAura extends MovieClip {

    private var game:Game = Game.root;
    private var auraContainer:MovieClip = new MovieClip();
    private var iconPriority:Array;

    public var icons:Object;
    public var scalar:Number = 0.6;
    public var auras:Object = {};

    public function TargetAura(game:Game) {
        this.game = game;

        name = "targetAuras"
        x = 1023;
        y = 65;
        visible = true;

        auraContainer.mouseEnabled = (auraContainer.mouseChildren = false);
        auraContainer.name = "tAuraContainer";
        addChild(auraContainer);
    }

    public function createIconMC(name:String, stack:Number, asset:String = null) : void
    {
        if (!game.world.myAvatar.target) return;

        if (icons == null)
        {
            icons = {};
            iconPriority = [];
        }

        var assetClass:Class;

        if (!icons.hasOwnProperty(name))
        {
            assetClass = asset && asset != "undefined"
                    ? asset.indexOf(",") > -1
                            ? game.world.getClass(asset.split(",")[asset.split(",").length - 1]) as Class
                            : game.world.getClass(asset) as Class
                    : game.world.getClass("isp2") ;

            var icon:MovieClip = new assetClass();
            var assetClassSlot:Class = getDefinitionByName("assets.ib2") as Class;
            var slot:ib2 = new assetClassSlot() as ib2;

            var maskShape:Shape = new Shape();
            maskShape.graphics.beginFill(0xFFFFFF);
            maskShape.graphics.drawRect(0, 0, 23, 21);
            maskShape.graphics.endFill();

            var maskMc:MovieClip = new MovieClip();
            maskMc.addChild(maskShape);
            maskMc.alpha = 0;
            addChild(maskMc);

            icons[name] = auraContainer.addChild(slot);
            icons[name].name = "aura@" + name;
            icons[name].auraName = name;
            icons[name].hitbox = maskMc;
            icons[name].hitbox.auraName = name;
            icons[name].width = 42;
            icons[name].height = 39;
            icons[name].cnt.removeChildAt(0);
            icons[name].scaleX = scalar;
            icons[name].scaleY = scalar;
            icons[name].tQty.visible = false;

            var temp:MovieClip = icons[name].cnt.addChild(icon);
            temp.scaleX = temp.width > temp.height ? (temp.scaleY = 34 / temp.width) : (temp.scaleY = 31 / temp.height);
            temp.x = icons[name].bg.width / 2 - temp.width / 2;
            temp.y = icons[name].bg.height / 2 - temp.height / 2;

            icons[name].hitbox.addEventListener(MouseEvent.MOUSE_OVER, function (event:MouseEvent) : void
            {
                game.ui.ToolTip.openWith({ "str":event.currentTarget.auraName + " (" + event.currentTarget.auraStacks + ")" });
            }, false, 0, true);

            icons[name].hitbox.addEventListener(MouseEvent.MOUSE_OUT, function (event:MouseEvent):void
            {
                game.ui.ToolTip.close();
            }, false, 0, true);

            iconPriority.push(name);
        }

        icons[name].auraStacks = stack;
        icons[name].hitbox.auraStacks = stack;

        trace("PLAYER AURA => :)");
    }

    public function rearrangeIconMC():void
    {
        var nextRow:Number = 0;
        var rowCtr:Number = 0;
        var i:int = 0;
        while (i < iconPriority.length)
        {
            if (((!(i == 0)) && ((i % 6) == 0)))
            {
                nextRow = (nextRow + 28);
                rowCtr++;
            }
            icons[iconPriority[i]].x = ((32 * (i - (4 * rowCtr))) + 3);
            icons[iconPriority[i]].y = nextRow;
            icons[iconPriority[i]].hitbox.x = (icons[iconPriority[i]].x + 2);
            icons[iconPriority[i]].hitbox.y = (icons[iconPriority[i]].y + 1);
            i++;
        }
    }

    public function cleanup():void
    {
        game.onRemoveChildren(this);
        parent.removeChild(this);
    }

    public function clearMCs():void
    {
        if (!game.ui) return;
        game.onRemoveChildren(auraContainer);
        icons = {};
        iconPriority = [];
    }

    public function handleAura(_arg_1:Object):*
    {
        var _local_2:Date;
        var _local_3:*;
        var _local_4:*;
        var _local_5:*;
        var _local_6:*;
        var _local_7:*;

        if (!game.world.myAvatar.target || _arg_1.a == null) return;

        for each (_local_4 in _arg_1.a)
        {
            if (game.world.myAvatar.target)
            {
                if (game.world.myAvatar.target.npcType == "monster")
                {
                    if (_local_4.tInf != ("m:" + game.world.myAvatar.target.dataLeaf.MonMapID.toString())) continue;
                }
                else if (game.world.myAvatar.target.npcType == "player")
                {
                    if (_local_4.tInf != ("p:" + game.world.myAvatar.target.dataLeaf.entID.toString())) continue;
                }
                else if (game.world.myAvatar.target.npcType == "npc")
                {
                    if (_local_4.tInf != ("n:" + game.world.myAvatar.target.dataLeaf.NpcMapID.toString())) continue;
                }
                else
                {
                    trace("Unknown Target Aura!");
                }
            }
            if (_local_4.auras)
            {
                for each (_local_5 in _local_4.auras)
                {
                    if (_local_4.cmd.indexOf("+") > -1)
                    {
                        if (!auras.hasOwnProperty(_local_5.nam))
                        {
                            auras[_local_5.nam] = 1;
                            createIconMC(_local_5.nam, 1, _local_5.icon);
                            coolDownAct(icons[_local_5.nam], (_local_5.dur * 1000), new Date().getTime());
                        }
                        else
                        {
                            auras[_local_5.nam] = (auras[_local_5.nam] + 1);
                            if (!game.world.myAvatar.target)
                            {
                                auras = {};
                                clearMCs();
                            }
                            for each (_local_6 in game.world.myAvatar.target.dataLeaf.auras)
                            {
                                if (_local_6.nam == _local_5.nam)
                                {
                                    _local_6.ts = _local_5.ts;
                                    createIconMC(_local_5.nam, auras[_local_5.nam]);
                                    coolDownAct(icons[_local_5.nam], (_local_5.dur * 1000), _local_6.ts);
                                    break;
                                }
                            }
                        }
                    }
                    else
                    {
                        if (_local_4.cmd.indexOf("-") > -1)
                        {
                            delete auras[_local_5.nam];
                        }
                    }
                }
            }
            else
            {
                if (_local_4.cmd.indexOf("+") > -1)
                {
                    if (!auras.hasOwnProperty(_local_4.aura.nam))
                    {
                        auras[_local_4.aura.nam] = 1;
                        createIconMC(_local_4.aura.nam, 1, _local_4.aura.icon);
                        coolDownAct(icons[_local_4.aura.nam], (_local_4.aura.dur * 1000), new Date().getTime());
                    }
                    else
                    {
                        auras[_local_4.aura.nam] = (auras[_local_4.aura.nam] + 1);
                        if (!game.world.myAvatar.target)
                        {
                            auras = {};
                            clearMCs();
                        }
                        for each (_local_7 in game.world.myAvatar.target.dataLeaf.auras)
                        {
                            if (_local_7.nam == _local_4.aura.nam)
                            {
                                _local_7.ts = _local_4.aura.ts;
                                auras[_local_4.aura.nam] = 1;
                                createIconMC(_local_4.aura.nam, auras[_local_4.aura.nam]);
                                coolDownAct(icons[_local_4.aura.nam], (_local_4.aura.dur * 1000), _local_7.ts);
                                break;
                            }
                        }
                    }
                }
                else
                {
                    if (_local_4.cmd.indexOf("-") > -1)
                    {
                        delete auras[_local_4.aura.nam];
                    }
                }
            }
        }
    }

    public function classChanged():void
    {
        clearMCs();
    }

    public function coolDownAct(_arg_1:*, _arg_2:int=-1, _arg_3:Number=127):*
    {
        var _local_6:MovieClip;
        var _local_7:int;
        var _local_8:*;
        var _local_9:MovieClip;
        var _local_10:*;
        var _local_11:*;
        var _local_12:int;
        var _local_13:DisplayObject;
        var _local_14:TextField;
        var _local_15:TextFormat;
        if (!game.world.myAvatar.target)
        {
            auras = {};
            clearMCs();
            return;
        }
        var _local_4:Class = (game.world.getClass("ActMask") as Class);
        var _local_5:ColorTransform = new ColorTransform(0.5, 0.5, 0.5, 1, -50, -50, -50, 0);
        _local_6 = _arg_1;
        _local_8 = null;
        _local_9 = null;
        if (_local_6.icon2 == null)
        {
            _local_10 = new BitmapData(50, 50, true, 0);
            _local_10.draw(_local_6, null, _local_5);
            _local_11 = new Bitmap(_local_10);
            _local_8 = _local_6.addChild(_local_11);
            _local_6.icon2 = _local_8;
            _local_8.transform = _local_6.transform;
            _local_8.scaleX = 1;
            _local_8.scaleY = 1;
            _local_6.ts = _arg_3;
            _local_6.cd = _arg_2;
            _local_6.auraName = _local_6.auraName;
            _local_9 = (_local_6.addChild(new (_local_4)()) as MovieClip);
            _local_9.scaleX = 0.33;
            _local_9.scaleY = 0.33;
            _local_9.x = int(((_local_8.x + (_local_8.width / 2)) - (_local_9.width / 2)));
            _local_9.y = int(((_local_8.y + (_local_8.height / 2)) - (_local_9.height / 2)));
            _local_12 = 0;
            while (_local_12 < 4)
            {
                _local_9[(("e" + _local_12) + "oy")] = _local_9[("e" + _local_12)].y;
                _local_12++;
            }
            _local_8.mask = _local_9;
            _local_14 = new TextField();
            _local_15 = new TextFormat();
            _local_15.size = 12;
            _local_15.bold = true;
            _local_15.font = "Arial";
            _local_15.color = 0xFFFFFF;
            _local_14.defaultTextFormat = _local_15;
            _local_6.stacks = _local_6.addChild(_local_14);
            _local_6.stacks.x = 32;
            _local_6.stacks.y = 27;
            _local_6.stacks.mouseEnabled = false;
        }
        else
        {
            _local_8 = _local_6.icon2;
            _local_9 = _local_8.mask;
            _local_6.ts = _arg_3;
            _local_6.cd = _arg_2;
            _local_6.auraName = _local_6.auraName;
        }
        _local_6.stacks.text = _local_6.auraStacks;
        _local_9.e0.stop();
        _local_9.e1.stop();
        _local_9.e2.stop();
        _local_9.e3.stop();
        _local_6.removeEventListener(Event.ENTER_FRAME, countDownAct);
        _local_6.addEventListener(Event.ENTER_FRAME, countDownAct, false, 0, true);
        rearrangeIconMC();
    }

    public function countDownAct(e:Event):void
    {
        try
        {
            var dat:* = undefined;
            var ti:* = undefined;
            var ct1:* = undefined;
            var ct2:* = undefined;
            var cd:* = undefined;
            var tp:* = undefined;
            var mc:* = undefined;
            var fr:* = undefined;
            var i:* = undefined;
            var iMask:* = undefined;

            if (!game.world.myAvatar.target)
            {
                auras = {};
                clearMCs();
                return;
            }

            dat = new Date();
            ti = dat.getTime();
            ct1 = MovieClip(e.target);
            ct2 = ct1.icon2;
            cd = (ct1.cd + 350);
            tp = ((ti - ct1.ts) / cd);
            mc = Math.floor((tp * 4));
            fr = (int(((tp * 360) % 90)) + 1);
            if (auras[ct1.auraName] == null)
            {
                tp = 1;
            }
            if (((tp < 0.99) && (game.world.myAvatar.target)))
            {
                i = 0;
                while (i < 4)
                {
                    if (i < mc)
                    {
                        ct2.mask[("e" + i)].y = -300;
                    }
                    else
                    {
                        ct2.mask[("e" + i)].y = ct2.mask[(("e" + i) + "oy")];
                        if (i > mc)
                        {
                            ct2.mask[("e" + i)].gotoAndStop(0);
                        }
                    }
                    i++;
                }
                MovieClip(ct2.mask[("e" + mc)]).gotoAndStop(fr);
            }
            else
            {
                try
                {
                    if (!game.world.myAvatar.target)
                    {
                        auras = {};
                        clearMCs();
                        return;
                    }
                    iMask = ct2.mask;
                    ct2.mask = null;
                    ct2.parent.removeChild(iMask);
                    ct1.removeEventListener(Event.ENTER_FRAME, countDownAct);
                    stopDrag();
                    ct2.parent.removeChild(ct2);
                    ct2.bitmapData.dispose();
                    ct1.icon2 = null;
                    removeChild(icons[ct1.auraName].hitbox);
                    auraContainer.removeChild(icons[ct1.auraName]);
                    iconPriority.splice(iconPriority.indexOf(ct1.auraName), 1);
                    delete icons[ct1.auraName];
                    rearrangeIconMC();
                }
                catch(e:Error)
                {
                }
            }
        }
        catch(ex:Error)
        {
            MovieClip(e.target).removeEventListener(Event.ENTER_FRAME, countDownAct);
        }
    }

}
}
