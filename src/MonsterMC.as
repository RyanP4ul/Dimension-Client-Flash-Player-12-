// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//MonsterMC

package
{
    import flash.display.MovieClip;
    import flash.display.Loader;
    import flash.geom.Point;
    import flash.geom.ColorTransform;
    import flash.utils.Timer;
    import flash.geom.Rectangle;
    import flash.display.DisplayObject;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.events.Event;
    import flash.display.Sprite;
    import flash.display.Graphics;
import flash.utils.getTimer;

public class MonsterMC extends MovieClip
    {

        private var game:Game = Game.root;

        public var pname:MovieClip;
        public var shadow:MovieClip;
        public var fx:MovieClip;
        public var mc:MovieClip;
        public var bubble:MovieClip;
        internal var ldr:Loader = new Loader();
        internal var xDep:*;
        internal var yDep:*;
        internal var xTar:*;
        internal var yTar:Number;
        internal var op:Point;
        internal var tp:Point;
        internal var walkTS:Number;
        internal var walkD:Number;
        public var ox:*;
        public var oy:*;
        internal var px:*;
        internal var py:*;
        internal var tx:*;
        internal var ty:Number;
        internal var nDuration:*;
        internal var nXStep:*;
        internal var nYStep:Number;
        internal var cbx:*;
        internal var cby:Number;
        internal var defaultCT:ColorTransform;
        internal var iniTimer:Timer;
        public var hitbox:Rectangle;
        public var hitboxDO:DisplayObject;
        public var spFX:Object;
        public var pAV:Avatar;
        internal var mcChar:MovieClip;
        public var isMonster:Boolean = true;
        public var isStatic:Boolean = false;
        public var noMove:Boolean = false;
        private var despawnTimer:Timer;
        private var totalTransform:Object;
        private var clampedTransform:ColorTransform;
        private var animQueue:Array;
        private var attacks:Array;
        public var lastFlickerTime:int = 0;



        private var _lastFrameTime:int = 0;
        private var _frameInterval:int = 33; // ~30 FPS
        private var _lastVisibilityCheck:int = 0;
        private var _visibilityCheckInterval:int = 500; // Check visibility every 500ms

        public function MonsterMC(_arg_1:String)
        {
            defaultCT = MovieClip(this).transform.colorTransform;
            spFX = {};
            despawnTimer = new Timer(5000, 1);
            totalTransform = {
                "alphaMultiplier":1,
                "alphaOffset":0,
                "redMultiplier":1,
                "redOffset":0,
                "greenMultiplier":1,
                "greenOffset":0,
                "blueMultiplier":1,
                "blueOffset":0
            };
            clampedTransform = new ColorTransform();
            animQueue = [];
            attacks = ["Attack1", "Attack2", "Buff", "Cast"];
            super();
            bubble.visible = false;
            bubble.t = "";
            pname.ti.text = _arg_1;
            pname.typ.text = "";
        }

        public function init():*
        {
            mcChar = MovieClip(this.getChildAt(1));
            mcChar.addEventListener(MouseEvent.CLICK, onClickHandler);
            pname.addEventListener(MouseEvent.CLICK, onClickHandler);
            despawnTimer.addEventListener(TimerEvent.TIMER, despawn);
            this.addEventListener(Event.ENTER_FRAME, onOptimizedEnterFrame, false, 0, true);
            pname.mouseChildren = false;
            mcChar.buttonMode = true;
            pname.buttonMode = true;
            shadow.mouseEnabled = (shadow.mouseChildren = false);
            mcChar.cacheAsBitmap = true;
            setVisible();
            game.world.animationController.addClip(mcChar, this.name, 2.0);
        }

        private function onOptimizedEnterFrame(event:Event):void
        {
            var currentTime:int = getTimer();

            // Frame rate limiting
            if (currentTime - _lastFrameTime < _frameInterval) {
                return;
            }
            _lastFrameTime = currentTime;

            // Check visibility periodically instead of every frame
            if (currentTime - _lastVisibilityCheck > _visibilityCheckInterval) {
                _lastVisibilityCheck = currentTime;
                updateVisibility();
            }

            // Check animation queue
            checkQueue(event);
        }

        private function updateVisibility():void
        {
            // Only update if this monster is actually visible on screen
            if (stage && this.visible)
            {
                var globalPos:Point = localToGlobal(new Point(0, 0));
                var viewRect:Rectangle = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);

                // If monster is not in view, reduce its update frequency
                if (!viewRect.containsPoint(globalPos))
                {
                    // Skip some updates for off-screen monsters
                    if (Math.random() > 0.3) // 70% chance to skip update
                    {
                        return;
                    }
                }
            }
        }

        public function setVisible():*
        {
            this.visible = game.world.showMonsters;
        }

        public function setData():*
        {
            pAV.objData.strMonName = pname.ti.text;
        }

        public function updateNamePlate():void
        {
            if (((((game.world.bPvP) && (!(pAV.dataLeaf == null))) && (!(pAV.dataLeaf.react == null))) && (pAV.dataLeaf.react[game.world.myAvatar.dataLeaf.pvpTeam] == 1)))
            {
                pname.ti.textColor = 0xFFFFFF;
            }

            if (pAV.objData.title != null) {
                pname.tt.text = pAV.objData.title.Name;
                pname.tt.textColor = pAV.objData.title.Color;
            } else {
                pname.tt.text = "";
            }

            if (pname.typ.text.length < 1)
            {
                pname.tt.y = pname.ti.y;
                pname.ti.y = pname.typ.y;
            }
        }

        public function fClose():*
        {
            var _local_1:* = MovieClip(stage.getChildAt(0)).world;
            var _local_2:* = _local_1.CHARS;
            mcChar.removeEventListener(MouseEvent.CLICK, onClickHandler);
            pname.removeEventListener(MouseEvent.CLICK, onClickHandler);
            despawnTimer.removeEventListener(TimerEvent.TIMER, despawn);
            this.removeEventListener(Event.ENTER_FRAME, onEnterFrameWalk);
            this.removeEventListener(Event.ENTER_FRAME, onDespawn);
            this.removeEventListener(Event.ENTER_FRAME, checkQueue);
            if (_local_1.CHARS.contains(this))
            {
                _local_1.CHARS.removeChild(this);
            }
            if (_local_1.TRASH.contains(this))
            {
                _local_1.TRASH.removeChild(this);
            }
        }

        public function hasLabel(_arg_1:String):Boolean
        {
            var _local_2:Array = mcChar.currentLabels;
            var _local_3:int;
            while (_local_3 < _local_2.length)
            {
                if (_local_2[_local_3].name == _arg_1)
                {
                    return (true);
                }
                _local_3++;
            }
            return (false);
        }

        public function onClickHandler(event:MouseEvent):void
        {
            if (event.shiftKey)
            {
                game.world.onWalkClick();
            }
            else
            {
                if (event.ctrlKey)
                {
                    if (game.world.myAvatar.objData.intAccessLevel >= 40)
                    {
                        if (pAV.npcType == "monster") game.world.game.net.send("cmd", ["km", ("m:" + pAV.objData.MonMapID)]);
                        if (pAV.npcType == "player") game.world.game.net.send("cmd", ["km", ("p:" + pAV.objData.unm.toLowerCase())]);
                    }
                }
                else
                {
                    if (event.currentTarget.parent == this)
                    {
                        if (game.world.myAvatar.target != pAV)
                        {
                            game.world.setTarget(pAV);
                        }
                        else
                        {
                            if (((!(game.world.bPvP)) || ((pAV.dataLeaf.react == null) || (pAV.dataLeaf.react[game.world.myAvatar.dataLeaf.pvpTeam] == 0))))
                            {
                                game.world.approachTarget();
                            }
                        }
                    }
                }
            }
        }

        public function modulateColor(_arg_1:ColorTransform, _arg_2:String):void
        {
            var _local_3:MovieClip = (this.stage.getChildAt(0) as MovieClip);
            if (_arg_2 == "+")
            {
                totalTransform.alphaMultiplier = (totalTransform.alphaMultiplier + _arg_1.alphaMultiplier);
                totalTransform.alphaOffset = (totalTransform.alphaOffset + _arg_1.alphaOffset);
                totalTransform.redMultiplier = (totalTransform.redMultiplier + _arg_1.redMultiplier);
                totalTransform.redOffset = (totalTransform.redOffset + _arg_1.redOffset);
                totalTransform.greenMultiplier = (totalTransform.greenMultiplier + _arg_1.greenMultiplier);
                totalTransform.greenOffset = (totalTransform.greenOffset + _arg_1.greenOffset);
                totalTransform.blueMultiplier = (totalTransform.blueMultiplier + _arg_1.blueMultiplier);
                totalTransform.blueOffset = (totalTransform.blueOffset + _arg_1.blueOffset);
            }
            else
            {
                if (_arg_2 == "-")
                {
                    totalTransform.alphaMultiplier = (totalTransform.alphaMultiplier - _arg_1.alphaMultiplier);
                    totalTransform.alphaOffset = (totalTransform.alphaOffset - _arg_1.alphaOffset);
                    totalTransform.redMultiplier = (totalTransform.redMultiplier - _arg_1.redMultiplier);
                    totalTransform.redOffset = (totalTransform.redOffset - _arg_1.redOffset);
                    totalTransform.greenMultiplier = (totalTransform.greenMultiplier - _arg_1.greenMultiplier);
                    totalTransform.greenOffset = (totalTransform.greenOffset - _arg_1.greenOffset);
                    totalTransform.blueMultiplier = (totalTransform.blueMultiplier - _arg_1.blueMultiplier);
                    totalTransform.blueOffset = (totalTransform.blueOffset - _arg_1.blueOffset);
                }
            }
            clampedTransform.alphaMultiplier = _local_3.clamp(totalTransform.alphaMultiplier, -1, 1);
            clampedTransform.alphaOffset = _local_3.clamp(totalTransform.alphaOffset, -255, 0xFF);
            clampedTransform.redMultiplier = _local_3.clamp(totalTransform.redMultiplier, -1, 1);
            clampedTransform.redOffset = _local_3.clamp(totalTransform.redOffset, -255, 0xFF);
            clampedTransform.greenMultiplier = _local_3.clamp(totalTransform.greenMultiplier, -1, 1);
            clampedTransform.greenOffset = _local_3.clamp(totalTransform.greenOffset, -255, 0xFF);
            clampedTransform.blueMultiplier = _local_3.clamp(totalTransform.blueMultiplier, -1, 1);
            clampedTransform.blueOffset = _local_3.clamp(totalTransform.blueOffset, -255, 0xFF);
            this.transform.colorTransform = clampedTransform;
        }

        public function queueAnim(_arg_1:String):void
        {
            var _local_2:MovieClip = (MovieClip(stage.getChildAt(0)).world as MovieClip);
            var _local_3:String = mcChar.currentLabel;

            if ((((hasLabel(_arg_1)) && (pAV.dataLeaf.intState > 0)) && (_local_2.staticAnims.indexOf(_local_3) == -1)))
            {
                if (((_local_2.combatAnims.indexOf(_arg_1) > -1) && (_local_2.combatAnims.indexOf(_local_3) > -1)))
                {
                    // Limit queue size to prevent memory issues
                    if (animQueue.length < 3) {
                        animQueue.push(_arg_1);
                    }
                }
                else
                {
                    trace("QueueAnim: " + _arg_1);
                    game.world.animationController.gotoAndPlay(this.name, _arg_1, true);
//                    mcChar.gotoAndPlay(_arg_1);
                }
            }
        }

        private function checkQueue(_arg_1:Event):Boolean
        {
            if (animQueue.length > 0)
            {
                var _local_2:MovieClip = (MovieClip(stage.getChildAt(0)).world as MovieClip);
                var _local_3:String = mcChar.currentLabel;
                var _local_4:int = emoteLoopFrame();

                if (((_local_2.combatAnims.indexOf(_local_3) > -1) && (mcChar.currentFrame >= (_local_4 + 4))))
                {
                    trace("QueueAnim: " + animQueue[0]);
                    game.world.animationController.gotoAndPlay(this.name, animQueue[0], true);
//                    mcChar.gotoAndPlay(animQueue[0]);
                    animQueue.shift();
                    return true;
                }
            }
            return false;
        }

        public function clearQueue():void
        {
            animQueue = [];
        }

        private function emoteLoopFrame():int
        {
            var _local_1:Array = mcChar.currentLabels;
            var i:int = 0;
            while (i < _local_1.length)
            {
                if (_local_1[i].name == currentLabel)
                {
                    return (_local_1[i].frame);
                }
                i++;
            }
            return (8);
        }

        private function linearTween(_arg_1:*, _arg_2:*, _arg_3:*, _arg_4:*):Number
        {
            return (((_arg_3 * _arg_1) / _arg_4) + _arg_2);
        }

        public function walkTo(_arg_1:int, _arg_2:int, _arg_3:int):void
        {
            var _local_4:Number;
            var _local_5:Number;
            if (!noMove)
            {
                if (((!(pAV.petMC == null)) && (!(pAV.petMC.mcChar == null))))
                {
                    pAV.petMC.walkTo((_arg_1 - 20), (_arg_2 + 5), (_arg_3 - 3));
                }
                op = new Point(this.x, this.y);
                tp = new Point(_arg_1, _arg_2);
                _local_4 = Point.distance(op, tp);
                walkTS = new Date().getTime();
                walkD = Math.round((1000 * (_local_4 / (_arg_3 * 22))));
                if (walkD > 0)
                {
                    _local_5 = (op.x - tp.x);
                    if (_local_5 < 0)
                    {
                        this.turn("right");
                    }
                    else
                    {
                        this.turn("left");
                    }
                    if (!this.mcChar.onMove)
                    {
                        this.mcChar.onMove = true;
                        if (!Game.root.preference.data.bDisLoadMon && this.mcChar.currentLabel != "Walk")
                        {
                            this.mcChar.gotoAndPlay("Walk");
                        }
                    }
                    this.addEventListener(Event.ENTER_FRAME, onEnterFrameWalk);
                }
            }
        }

        private function onEnterFrameWalk(_arg_1:Event):void
        {
            var _local_4:*;
            var _local_5:*;
            var _local_6:Boolean;
            var _local_7:*;
            var _local_8:*;
            var _local_9:*;
            var _local_10:*;
            var _local_2:Number = new Date().getTime();
            var _local_3:Number = ((_local_2 - walkTS) / walkD);
            if (_local_3 > 1)
            {
                _local_3 = 1;
            }
            if (((Point.distance(op, tp) > 0.5) && (this.mcChar.onMove)))
            {
                _local_4 = this.x;
                _local_5 = this.y;
                this.x = Point.interpolate(tp, op, _local_3).x;
                this.y = Point.interpolate(tp, op, _local_3).y;
                _local_6 = false;
                _local_7 = 0;
                while (_local_7 < game.world.arrSolid.length)
                {
                    if (this.shadow.hitTestObject(game.world.arrSolid[_local_7].shadow))
                    {
                        _local_6 = true;
                        _local_7 = game.world.arrSolid.length;
                    }
                    _local_7++;
                }
                if (_local_6)
                {
                    _local_8 = this.y;
                    this.y = _local_5;
                    _local_6 = false;
                    _local_9 = 0;
                    while (_local_9 < game.world.arrSolid.length)
                    {
                        if (this.shadow.hitTestObject(game.world.arrSolid[_local_9].shadow))
                        {
                            this.y = _local_8;
                            _local_6 = true;
                            break;
                        }
                        _local_9++;
                    }
                    if (_local_6)
                    {
                        this.x = _local_4;
                        _local_6 = false;
                        _local_10 = 0;
                        while (_local_10 < game.world.arrSolid.length)
                        {
                            if (this.shadow.hitTestObject(game.world.arrSolid[_local_10].shadow))
                            {
                                _local_6 = true;
                                break;
                            }
                            _local_10++;
                        }
                        if (_local_6)
                        {
                            this.x = _local_4;
                            this.y = _local_5;
                            this.stopWalking();
                        }
                    }
                }
                if ((((Math.round(_local_4) == Math.round(this.x)) && (Math.round(_local_5) == Math.round(this.y))) && (_local_2 > (walkTS + 50))))
                {
                    this.stopWalking();
                }
            }
            else
            {
                this.stopWalking();
            }
        }

        public function stopWalking():void
        {
            if (this.mcChar.onMove)
            {
                this.mcChar.onMove = false;
                if (pAV.dataLeaf.intState != 2 && !Game.root.preference.data.bDisLoadMon)
                {
                    this.mcChar.gotoAndPlay("Idle");
                }
                this.removeEventListener(Event.ENTER_FRAME, onEnterFrameWalk);
            }
        }

        public function turn(_arg_1:String):void
        {
            if (!isStatic)
            {
                if ((((_arg_1 == "right") && (this.mcChar.scaleX < 0)) || ((_arg_1 == "left") && (this.mcChar.scaleX > 0))))
                {
                    this.mcChar.scaleX = (this.mcChar.scaleX * -1);
                }
            }
        }

        public function scale(_arg_1:Number):void
        {
            if ((this.mcChar.scaleX >= 0))
            {
                this.mcChar.scaleX = _arg_1;
            }
            else
            {
                this.mcChar.scaleX = -(_arg_1);
            }
            this.mcChar.scaleY = _arg_1;
            this.shadow.scaleX = (this.shadow.scaleY = _arg_1);
            this.bubble.y = (-(this.mcChar.height) - 10);
            this.pname.y = (-(this.mcChar.height) - 10);
            var _local_2:Point = new Point(0, (-(this.mcChar.height) - 10));
            var _local_3:Point = this.localToGlobal(_local_2);
            if (_local_3.y < 50)
            {
                _local_3.y = 50;
            }
            _local_2 = this.globalToLocal(_local_3);
            this.pname.y = _local_2.y;
            drawHitBox();
        }

        public function die():void
        {
            animQueue = [];

            if (!Game.root.preference.data.bDisLoadMon)
            {
                if (this.visible && stage)
                {
                    MovieClip(this.getChildAt(1)).gotoAndPlay("Die");
                }
            }

            mcChar.mouseEnabled = false;
            mcChar.mouseChildren = false;
            despawnTimer.reset();
            despawnTimer.start();
        }

        private function despawn(_arg_1:TimerEvent):void
        {
            var _local_2:* = MovieClip(stage.getChildAt(0)).world;
            if (_local_2.myAvatar.target == this.pAV)
            {
                _local_2.setTarget(null);
            }
            this.addEventListener(Event.ENTER_FRAME, onDespawn);
        }

        private function onDespawn(_arg_1:Event):void
        {
            this.alpha = (this.alpha - 0.05);
            if (this.alpha < 0)
            {
                this.visible = false;
                this.alpha = 1;
                this.removeEventListener(Event.ENTER_FRAME, onDespawn);
            }
        }

        public function respawn(_arg_1:String=""):void
        {
            despawnTimer.reset();
            this.removeEventListener(Event.ENTER_FRAME, onDespawn);

            if (!Game.root.preference.data.bDisLoadMon)
            {
                if (hasLabel("Start"))
                {
                    MovieClip(this.getChildAt(1)).gotoAndPlay("Start");
                }
                else
                {
                    if (MovieClip(this.getChildAt(1)).currentLabel != "Walk")
                    {
                        MovieClip(this.getChildAt(1)).gotoAndStop("Idle");
                    }
                }
            }

            if (_arg_1 != "")
            {
                pname.ti.text = _arg_1;
            }
            this.alpha = 1;
            this.visible = true;
            mcChar.mouseEnabled = true;
            mcChar.mouseChildren = true;
        }

        private function drawHitBox():void
        {
            // Only draw hitbox if debugging is enabled
            if (hitboxDO != null)
            {
                mcChar.removeChild(hitboxDO);
                hitboxDO = null;
                return;
            }

            if (hitboxDO != null)
            {
                mcChar.removeChild(hitboxDO);
            }
            hitboxDO = null;

            var _local_1:Rectangle = mcChar.getBounds(stage);
            var _local_2:Point = _local_1.topLeft;
            var _local_3:Point = _local_1.bottomRight;
            _local_2 = mcChar.globalToLocal(_local_2);
            _local_3 = mcChar.globalToLocal(_local_3);
            _local_1 = new Rectangle(_local_2.x, _local_2.y, (_local_3.x - _local_2.x), (_local_3.y - _local_2.y));

            var _local_4:int = (_local_1.x + (_local_1.width * 0.2));
            if (_local_4 > (shadow.x - shadow.width))
            {
                _local_4 = (shadow.x - shadow.width);
            }

            var _local_5:int = (_local_1.width * 0.6);
            if (_local_5 < (2 * shadow.width))
            {
                _local_5 = (2 * shadow.width);
            }

            var _local_6:int = (_local_1.y + (_local_1.height * 0.2));
            var _local_7:int = (_local_1.height * 0.6);
            hitbox = new Rectangle(_local_4, _local_6, _local_5, _local_7);

            var _local_8:Sprite = new Sprite();
            var _local_9:Graphics = _local_8.graphics;
            _local_9.lineStyle(0, 0xFFFFFF, 0);
            _local_9.beginFill(0xAA00FF, 0);
            _local_9.drawRect(_local_4, _local_6, _local_5, _local_7);
            _local_9.endFill();

            hitboxDO = mcChar.addChild(_local_8);
        }

        public function get Animation():String
        {
            return (attacks[Math.round(Math.random())]);
        }


    }
}//package

