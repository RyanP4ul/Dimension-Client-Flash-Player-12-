// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//dummyMC

package 
{
    import flash.display.MovieClip;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.net.*;
    import flash.media.*;
    import flash.geom.*;
    import flash.system.*;
    import flash.utils.*;
    import flash.filters.*;
    import flash.external.*;
    import flash.ui.*;
    import adobe.utils.*;
    import flash.accessibility.*;
    import flash.errors.*;
    import flash.printing.*;
    import flash.profiler.*;
    import flash.sampler.*;
    import flash.xml.*;

    public dynamic class dummyMC extends MovieClip 
    {

        public var idlefoot:MovieClip;
        public var chest:MovieClip;
        public var frontthigh:MovieClip;
        public var cape:MovieClip;
        public var frontshoulder:MovieClip;
        public var head:MovieClip;
        public var backshoulder:MovieClip;
        public var hip:MovieClip;
        public var backthigh:MovieClip;
        public var backhair:MovieClip;
        public var backshin:MovieClip;
        public var robe:MovieClip;
        public var weapon:MovieClip;
        public var frontshin:MovieClip;
        public var backfoot:MovieClip;
        public var backrobe:MovieClip;
        public var frontfoot:MovieClip;
        public var backhand:MovieClip;
        public var fronthand:MovieClip;
        public var avtMC:*;
        public var rootClass:*;
        public var AssetClass:*;
        public var spellFX:*;
        public var rand:int;
        public var strSpell:String;
        public var spells:Array;

        public function dummyMC()
        {
            addFrameScript(0, frame1, 14, frame15, 19, frame20, 31, frame32, 40, frame41, 47, frame48, 59, frame60, 72, frame73, 84, frame85, 96, frame97, 111, frame112, 127, frame128, 136, frame137, 150, frame151);
        }

        public function showIdleFoot():*
        {
            frontfoot.visible = false;
            idlefoot.visible = true;
        }

        public function showFrontFoot():*
        {
            idlefoot.visible = false;
            frontfoot.visible = true;
        }

        internal function frame1():*
        {
            spells = new Array("sp_ea2", "sp_ea3", "sp_ed1", "sp_ee1", "sp_ee2", "sp_ef2", "sp_ef3", "sp_ef5", "sp_eh2", "sp_ei3", "sp_el2", "sp_ice2", "sp_sp1");
            showIdleFoot();
            stop();
        }

        internal function frame15():*
        {
            stop();
        }

        internal function frame20():*
        {
            if (this.onMove)
            {
                gotoAndPlay("Walk");
            };
        }

        internal function frame32():*
        {
            avtMC = MovieClip(parent);
            rootClass = avtMC.pAV.rootClass;
            trace(("avtMC.target: " + avtMC.pAV.target));
            rand = Math.round((Math.random() * 11));
            if (((rand > 0) && (rand < 4)))
            {
                AssetClass = (rootClass.world.getClass(("sp_chaos" + rand)) as Class);
                if (AssetClass != null)
                {
                    spellFX = new AssetClass();
                    spellFX.spellDur = 0;
                    rootClass.world.CHARS.addChild(spellFX);
                    spellFX.mouseEnabled = false;
                    spellFX.mouseChildren = false;
                    spellFX.visible = true;
                    spellFX.world = rootClass.world;
                    spellFX.strl = "sp_chaos1";
                    spellFX.tMC = avtMC.pAV.target.pMC;
                    spellFX.x = spellFX.tMC.x;
                    spellFX.y = (spellFX.tMC.y + 3);
                    if (spellFX.tMC.x < avtMC.x)
                    {
                        spellFX.scaleX = (spellFX.scaleX * -1);
                    };
                };
            };
        }

        internal function frame41():*
        {
            stop();
        }

        internal function frame48():*
        {
            avtMC = MovieClip(parent);
            rootClass = avtMC.pAV.rootClass;
            trace(("avtMC.target: " + avtMC.pAV.target));
            rand = Math.round((Math.random() * 11));
            if (((rand > 0) && (rand < 4)))
            {
                AssetClass = (rootClass.world.getClass(("sp_chaos" + rand)) as Class);
                if (AssetClass != null)
                {
                    spellFX = new AssetClass();
                    spellFX.spellDur = 0;
                    rootClass.world.CHARS.addChild(spellFX);
                    spellFX.mouseEnabled = false;
                    spellFX.mouseChildren = false;
                    spellFX.visible = true;
                    spellFX.world = rootClass.world;
                    spellFX.strl = "sp_chaos1";
                    spellFX.tMC = avtMC.pAV.target.pMC;
                    spellFX.x = spellFX.tMC.x;
                    spellFX.y = (spellFX.tMC.y + 3);
                    if (spellFX.tMC.x < avtMC.x)
                    {
                        spellFX.scaleX = (spellFX.scaleX * -1);
                    };
                };
            };
        }

        internal function frame60():*
        {
            stop();
        }

        internal function frame73():*
        {
            avtMC = MovieClip(parent);
            rootClass = avtMC.pAV.rootClass;
            trace(("avtMC.target: " + avtMC.pAV.target));
            strSpell = spells[Math.round((Math.random() * (spells.length - 1)))];
            AssetClass = (rootClass.world.getClass(strSpell) as Class);
            if (AssetClass != null)
            {
                spellFX = new AssetClass();
                spellFX.spellDur = 0;
                rootClass.world.CHARS.addChild(spellFX);
                spellFX.mouseEnabled = false;
                spellFX.mouseChildren = false;
                spellFX.visible = true;
                spellFX.world = rootClass.world;
                spellFX.strl = strSpell;
                spellFX.tMC = avtMC.pAV.target.pMC;
                spellFX.x = spellFX.tMC.x;
                spellFX.y = (spellFX.tMC.y + 3);
                if (spellFX.tMC.x < avtMC.x)
                {
                    spellFX.scaleX = (spellFX.scaleX * -1);
                };
            };
        }

        internal function frame85():*
        {
            stop();
        }

        internal function frame97():*
        {
            avtMC = MovieClip(parent);
            rootClass = avtMC.pAV.rootClass;
            trace(("avtMC.target: " + avtMC.pAV.target));
            strSpell = spells[Math.round((Math.random() * (spells.length - 1)))];
            AssetClass = (rootClass.world.getClass(strSpell) as Class);
            if (AssetClass != null)
            {
                spellFX = new AssetClass();
                spellFX.spellDur = 0;
                rootClass.world.CHARS.addChild(spellFX);
                spellFX.mouseEnabled = false;
                spellFX.mouseChildren = false;
                spellFX.visible = true;
                spellFX.world = rootClass.world;
                spellFX.strl = strSpell;
                spellFX.tMC = avtMC.pAV.target.pMC;
                spellFX.x = spellFX.tMC.x;
                spellFX.y = (spellFX.tMC.y + 3);
                if (spellFX.tMC.x < avtMC.x)
                {
                    spellFX.scaleX = (spellFX.scaleX * -1);
                };
            };
        }

        internal function frame112():*
        {
            stop();
        }

        internal function frame128():*
        {
            stop();
        }

        internal function frame137():*
        {
            stop();
        }

        internal function frame151():*
        {
            stop();
        }


    }
}//package 

