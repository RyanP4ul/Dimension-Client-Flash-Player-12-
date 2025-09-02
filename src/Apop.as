// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//Apop

package 
{
    import flash.display.MovieClip;
import flash.display.Shape;
import flash.events.MouseEvent;
    import flash.media.SoundTransform;
    import flash.text.*;

import game.npc.NpcContent;

public class Apop extends MovieClip
    {

        public var npc:MovieClip;
        public var btnClose:MovieClip;
        public var nMask:MovieClip;
        public var placement:MovieClip;
        public var cnt:MovieClip;
        public var world:World;
        public var rootClass:Game;
        public var o:Object = null;
        private var mc:MovieClip;

        public function Apop():void
        {
            addFrameScript(5, this.frame6);
            this.mc = MovieClip(this);
            this.mc.btnClose.addEventListener(MouseEvent.CLICK, this.xClick, false, 0, true);
        }

        public function update(apopObject:Object, custom:Boolean = false):void
        {
            var _local_7:*;
            var _local_8:MovieClip;
            var _local_9:MovieClip;
            var _local_10:*;
            var _local_11:*;
            var _local_12:MovieClip;
            var _local_13:Boolean;
            var _local_14:int;
            this.rootClass = Game.root;
            this.world = this.rootClass.world;
            this.o = apopObject;

            var _local_2:* = "none";
            var _local_3:* = "none";
            var _local_4:* = "none";
            var _local_5:* = "none";
            var _local_6:* = "none";

            if (("npcLinkage" in this.o))
            {
                _local_2 = this.o.npcLinkage;
            }
            if (("npcEntry" in this.o))
            {
                _local_3 = this.o.npcEntry;
            }
            if (("cnt" in this.o))
            {
                _local_5 = this.o.cnt;
            }
            if (("scene" in this.o))
            {
                _local_4 = this.o.scene;
            }
            if (("frame" in this.o))
            {
                _local_6 = String(this.o.frame).toLowerCase();
            }

            if (_local_2 != "none")
            {
                _local_7 = custom ? _local_2 : world.getClass(_local_2) as Class;
                if (_local_7 != null)
                {
                    trace("APOP ENTRY => " + _local_3);

                    if (_local_3 == "right")
                    {
                        _local_8 = this.mc.npc.npcRight;
                        _local_9 = this.mc.npc.npcLeft;
                        if (_local_9.currentLabel != "init")
                        {
                            _local_9.gotoAndPlay("slide-out");
                        }
                        else
                        {
                            _local_9.visible = false;
                        }
                    }
                    else
                    {
                        _local_8 = this.mc.npc.npcLeft;
                        _local_9 = this.mc.npc.npcRight;
                        if (_local_9.currentLabel != "init")
                        {
                            _local_9.gotoAndPlay("slide-out");
                        }
                        else
                        {
                            _local_9.visible = false;
                        }
                    }

                    if (_local_3 == "right")
                    {
                        _local_7.x = 0;
                    }

                    _local_8.visible = true;
                    _local_8.npc.removeChildAt(0);
                    _local_8.npc.addChild(custom ? _local_7 : new (_local_7)());

                    if (_local_8.currentLabel != "init")
                    {
                        _local_8.gotoAndPlay("slide-hook");
                    }
                    else
                    {
                        _local_8.gotoAndPlay("slide-in");
                    }
                }
                else
                {
                    this.mc.npc.npcRight.visible = false;
                    this.mc.npc.npcLeft.visible = false;
                }
            }
            if (_local_5 != "none")
            {
                _local_10 = custom ? _local_5 : (this.world.getClass(_local_5) as Class);

                if (_local_10 != null)
                {
                    this.mc.cnt.removeChildAt(0);
                    _local_11 = this.mc.cnt.addChild(custom ? _local_10 : new (_local_10)());
                    _local_11.name = "cnt";
                    if (_local_4 != "none")
                    {
                        _local_11.gotoAndPlay(_local_4);
                    }
                }
            }

            if (_local_6 != "none")
            {
                _local_12 = MovieClip(this.mc.cnt.getChildByName("cnt"));
                _local_13 = false;
                _local_14 = 0;
                while (_local_14 < _local_12.currentLabels.length)
                {
                    if (_local_12.currentLabels[_local_14].name == _local_6)
                    {
                        _local_13 = true;
                    }
                    _local_14++;
                }
                if (_local_13)
                {
                    _local_12.gotoAndPlay(_local_6);
                }
                else
                {
                    this.rootClass.addUpdate((("Label " + _local_6) + " not found!"));
                }
            }

            if (this.mc.currentLabel == "init")
            {
                this.mc.gotoAndPlay("in");
            }
        }

        public function updateWithClasses(_arg_1:Object, _arg_2:Class, _arg_3:Class):void
        {
            var _local_7:MovieClip;
            var _local_8:MovieClip;
            var _local_9:*;
            var _local_10:MovieClip;
            var _local_11:Boolean;
            var _local_12:int;
            this.rootClass = Game.root;
            this.world = this.rootClass.world;
            this.o = _arg_1;
            var _local_4:* = "none";
            var _local_5:* = "none";
            var _local_6:* = "none";
            if (("npcEntry" in o))
            {
                _local_4 = String(o.npcEntry).toLowerCase();
            }
            if (("scene" in o))
            {
                _local_5 = o.scene;
            }
            if (("frame" in o))
            {
                _local_6 = o.frame;
            }
            if (_arg_2 != null)
            {
                if (_local_4 == "right")
                {
                    _local_7 = this.mc.npc.npcRight;
                    _local_8 = this.mc.npc.npcLeft;
                    if (_local_8.currentLabel != "init")
                    {
                        _local_8.gotoAndPlay("slide-out");
                    }
                    else
                    {
                        _local_8.visible = false;
                    }
                }
                else
                {
                    _local_7 = this.mc.npc.npcLeft;
                    _local_8 = this.mc.npc.npcRight;
                    if (_local_8.currentLabel != "init")
                    {
                        _local_8.gotoAndPlay("slide-out");
                    }
                    else
                    {
                        _local_8.visible = false;
                    }
                }
                _local_7.visible = true;
                _local_7.npc.removeChildAt(0);
                _local_7.npc.addChild(new (_arg_2)());
                if (_local_7.currentLabel != "init")
                {
                    _local_7.gotoAndPlay("slide-hook");
                }
                else
                {
                    _local_7.gotoAndPlay("slide-in");
                }
            }
            else
            {
                this.mc.npc.npcRight.visible = false;
                this.mc.npc.npcLeft.visible = false;
            }
            if (_arg_3 != null)
            {
                this.mc.cnt.removeChildAt(0);
                _local_9 = this.mc.cnt.addChild(new (_arg_3)());
                _local_9.name = "cnt";
                if (_local_5 != "none")
                {
                    _local_9.gotoAndPlay(_local_5);
                }
            }
            if (_local_6 != "none")
            {
                _local_10 = MovieClip(this.mc.cnt.getChildByName("cnt"));
                _local_11 = false;
                _local_12 = 0;
                while (_local_12 < _local_10.currentLabels.length)
                {
                    if (_local_10.currentLabels[_local_12].name == _local_6)
                    {
                        _local_11 = true;
                    }
                    _local_12++;
                }
                if (_local_11)
                {
                    _local_10.gotoAndPlay(_local_6);
                }
                else
                {
                    this.rootClass.addUpdate((("Label " + _local_6) + " not found!"));
                }
            }
            if (this.mc.currentLabel == "init")
            {
                this.mc.gotoAndPlay("in");
            }
        }

        public function fClose():void
        {
            var _local_1:MovieClip = MovieClip(this.mc.cnt.getChildByName("cnt"));
            _local_1.soundTransform = new SoundTransform(0);
            _local_1.stop();
            this.mc.btnClose.removeEventListener(MouseEvent.CLICK, this.xClick);
            this.mc.parent.removeChild(this);
            world.intNpc = 0;
        }

        private function xClick(_arg_1:MouseEvent):void
        {
            this.fClose();
        }

        public function exit():void
        {
            this.fClose();
        }

        public function warn(_arg_1:String):*
        {
            trace("");
            trace("*^*^* NPC DIALOGUE ERROR *^*^*");
            trace(("  > " + _arg_1));
            trace("");
        }

        internal function frame6():*
        {
            stop();
        }


    }
}//package 

