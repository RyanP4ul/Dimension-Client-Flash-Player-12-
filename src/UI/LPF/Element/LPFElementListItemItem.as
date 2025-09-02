// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//LPFElementListItemItem

package UI.LPF.Element
{
import UI.LPF.Frame.LPFFrameListViewTabbed;

import flash.display.MovieClip;
import flash.filters.GlowFilter;
import flash.text.TextField;
    import flash.geom.ColorTransform;
    import flash.events.MouseEvent;
    import flash.text.*;
import flash.utils.getTimer;

public class LPFElementListItemItem extends LPFElementListItem
    {

        public var icon:MovieClip;
        public var tName:TextField;
        public var tType:TextField;
        public var tNew:TextField;
        public var defBG:MovieClip;
        public var lvlBG:MovieClip;
        public var favBG:MovieClip;
        public var selBG:MovieClip;
        public var tLevel:TextField;
        public var eqpBG:MovieClip;
        public var iconRing:MovieClip;
        public var mcFav:MovieClip;
        public var mcBoost:MovieClip;
        public var ownedItem:MovieClip;
        public var hit:MovieClip;
        public var sel:Boolean = false;
        private var game:Game;
        private var allowDesel:Boolean = false;
        private var bLimited:Boolean = false;
        private var redCT:ColorTransform = new ColorTransform(1, 1, 1, 1, 96, 0, 0, 0);
        private var greenCT:ColorTransform = new ColorTransform(1, 1, 1, 1, 0, 96, 0, 0);
        private var blueCT:ColorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 96, 0);
        private var whiteCT:ColorTransform = new ColorTransform(1, 1, 1, 1, 64, 64, 64, 0);
        private var orangeCT:ColorTransform = new ColorTransform(1, 1, 1, 1, 96, 36, 0, 0);
        private var yellowCT:ColorTransform = new ColorTransform(1, 1, 1, 1, 96, 64, 24, 0);
        private var purpleCT:ColorTransform = new ColorTransform(1, 1, 1, 1, 96, 0, 96, 0);
        private var greyCT:ColorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0);
        private var blackoutCT:ColorTransform = new ColorTransform(0, 0, 0, 1, 0, 0, 0, 0);
        private var greyoutCT:ColorTransform = new ColorTransform(0, 0, 0, 1, 40, 40, 40, 0);

        public function LPFElementListItemItem():void
        {
            addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
            addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
            addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
        }

        override public function fOpen(o:Object):void
        {
            fData = o.fData;
            if (("eventType" in o))
            {
                eventType = o.eventType;
            }
            if (("allowDesel" in o))
            {
                allowDesel = o.allowDesel;
            }
            if (("bLimited" in o))
            {
                bLimited = o.bLimited;
            }
            game = Game.root;
            fDraw();
        }

        override protected function fDraw():void
        {
            var enh:Object;
            var iRank:Number;
            var AssetClass:Class;
            var iconShapeMC:*;
            var dx:int;
            var dy:int;
            var uoLeaf:Object = game.world.myAvatar.dataLeaf;
            var nameText:String = "<font color='#FFFFFF'>" + fData.sName + "</font>";

            tNew.visible = (new Date().time - Number(fData.dPurchase) <= (5 * 60 * 1000));
            ownedItem.visible = game.ui.mcPopup.currentLabel == "Loot" && game.world.myAvatar.IsOwned(false, fData.ItemID);

            if (fData.bUpg == 1) nameText = (("<font color='#FCC749'>" + fData.sName) + "</font>");
            if (fData.iLvl > uoLeaf.intLevel || fData.EnhLvl != null && fData.EnhLvl > uoLeaf.intLevel) nameText = (("<font color='#FF0000'>" + fData.sName) + "</font>");
            if (bLimited && fData.iQtyRemain <= 0) nameText = (("<font color='#666666'>" + fData.sName) + "</font>");

            mcFav.visible = fData.bFav == 1;
            favBG.visible = fData.bFav == 1;
            mcBoost.visible = fData.sMeta != null && hasEffects(String(fData.sMeta)) || fData.hasOwnProperty("skills");
            tType.htmlText = fData.sType;

            if (["Weapon", "he", "ar", "ba"].indexOf(fData.sES) > -1)
            {
                if (fData.PatternID != null)
                {
                    enh = game.world.enhPatternTree[fData.PatternID];
                }
                if (fData.EnhPatternID != null)
                {
                    enh = game.world.enhPatternTree[fData.EnhPatternID];
                }
                if (enh != null)
                {
                }
            }

            if (bLimited)
            {
				nameText += "<font color='#AA0000'> x" + fData.iQtyRemain + "</font>";
            }
            else
            {
                if (fData.iStk > 1)
                {
					nameText += "<font color='#999999'> x" + fData.iQty + "</font>";
                }
            }
            if (((fData.sES == "ar") && (fData.EnhID > 0)))
            {
                iRank = game.getRankFromPoints(fData.iQty);
				nameText += "<font color='#999999'>, Rank " + iRank + "</font>";
            }
            if (((!(fData.EnhLvl == null)) && (fData.EnhLvl > 0)))
            {
                tLevel.htmlText = (("<font color='#00CCFF'>" + fData.EnhLvl) + "</font>");
            }
            else
            {
                if (((!(fData.iLvl == null)) && (fData.iLvl > 0)))
                {
                    tLevel.htmlText = (("<font color='#FFFFFF'>" + fData.iLvl) + "</font>");
                }
                else
                {
                    tLevel.visible = false;
                }
            }

			tName.htmlText = nameText;

            var _local_5:* = 23;
            var _local_6:* = 19;
            var _local_7:* = 13;
            var _local_8:* = 11;
            var _local_9:* = _local_5;
            var _local_10:* = _local_6;
            var _local_11:* = "";
			game.onRemoveChildren(icon);
            icon.visible = false;
            try
            {
                if (fData.sType.toLowerCase() == "enhancement")
                {
                    _local_11 = game.getIconBySlot(fData.sES);
                }
                else
                {
                    if (((fData.sType.toLowerCase() == "serveruse") || (fData.sType.toLowerCase() == "clientuse")))
                    {
                        if (((("sFile" in fData) && (fData.sFile.length > 0)) && (!(game.world.getClass(fData.sFile) == null))))
                        {
                            _local_11 = fData.sFile;
                        }
                        else
                        {
                            _local_11 = fData.sIcon;
                        }
                    }
                    else
                    {
                        if ((((fData.sIcon == null) || (fData.sIcon == "")) || (fData.sIcon == "none")))
                        {
                            if (fData.sLink.toLowerCase() != "none")
                            {
                                _local_11 = "iidesign";
                            }
                            else
                            {
                                _local_11 = "iibag";
                            }
                        }
                        else
                        {
                            _local_11 = fData.sIcon;
                        }
                    }
                }
                try
                {
                    AssetClass = (game.world.getClass(_local_11) as Class);
                    iconShapeMC = icon.addChild(new (AssetClass)());
                    _local_9 = iconShapeMC.width;
                    _local_10 = iconShapeMC.height;
                    dx = 0;
                    dy = 0;
                    if (fData.sType.toLowerCase() == "enhancement")
                    {
                        dx = int((((_local_5 - _local_7) / 4) - 1));
                        dy = int((((_local_6 - _local_8) / 4) - 1));
                        _local_5 = _local_7;
                        _local_6 = _local_8;
                    }
                    if (_local_9 > _local_10)
                    {
                        iconShapeMC.scaleX = (iconShapeMC.scaleY = (_local_5 / _local_9));
                    }
                    else
                    {
                        iconShapeMC.scaleX = (iconShapeMC.scaleY = (_local_6 / _local_10));
                    }
                    iconShapeMC.x = (-(iconShapeMC.width / 2) + dx);
                    iconShapeMC.y = (-(iconShapeMC.height / 2) + dy);
                    icon.visible = true;
                }
                catch(e:Error)
                {
                }
                iconRing.visible = true;
                iconRing.y = (iconRing.y = 2);
                iconRing.width = (iconRing.height = 25);
                if (fData.sType.toLowerCase() == "enhancement")
                {
                    icon.transform.colorTransform = blackoutCT;
                }
                else
                {
                    if (((!(fData.EnhLvl == null)) && (fData.EnhLvl > 0)))
                    {
                        iconRing.width = (iconRing.height = 19);
                        iconRing.x = (iconRing.x + 3);
                        iconRing.y = (iconRing.y + 3);
                    }
                    else
                    {
                        iconRing.visible = false;
                        if (["Weapon", "he", "ar", "ba"].indexOf(fData.sES) > -1)
                        {
                            icon.transform.colorTransform = greyoutCT;
                        }
                    }
                }

//                if (fData.hasOwnProperty("iRty"))
//                {
//                    iconRing.bg.transform.colorTransform = game.hexToColorTransform(game.world.rarity[fData.iRty].Color);
//                }

//                if (enh != null)
//                {
//                    iconRing.bg.transform.colorTransform = getCatCT(enh.sDesc);
//                }

                icon.filters = [new GlowFilter(game.world.rarity[fData.hasOwnProperty("iRty") ? fData.iRty : 1].Color, 0.5, 10, 10, 2, 3, false, false)];

                eqpBG.visible = false;
                if (fData.bEquip == 1)
                {
                    eqpBG.visible = true;
                    defBG.alpha = 0.15;
                }

                selBG.alpha = 0;
                if (fData.iLvl > game.world.myAvatar.dataLeaf.intLevel)
                {
                    lvlBG.alpha = 1;
                    defBG.alpha = 0;
                }
                else
                {
                    lvlBG.alpha = 0;
                    defBG.alpha = 0.5;
                }
                buttonMode = true;
                mouseChildren = false;
            }
            catch(e)
            {
            }
        }

        override public function select():void
        {
            sel = true;
            selBG.alpha = 1;
        }

        override public function deselect():void
        {
            sel = false;
            selBG.alpha = 0;
        }

        override protected function onClick(event:MouseEvent):void
        {
            var _local_2:MovieClip;
            if (!game.isGreedyModalInStack())
            {
                if (!sel)
                {
                    _local_2 = LPFFrameListViewTabbed(fParent).getListItemByiSel();
                    if (_local_2 != null)
                    {
                        _local_2.deselect();
                    }
                    select();
                }
                else
                {
                    if (allowDesel)
                    {
                        deselect();
                    }
                }
                update();
            }
        }

        override protected function onMouseOver(_arg_1:MouseEvent):void
        {
            if (!sel)
            {
                selBG.alpha = 0.6;
            }
        }

        override protected function onMouseOut(_arg_1:MouseEvent):void
        {
            if (!sel)
            {
                selBG.alpha = 0;
            }
        }

        private function getCatCT(_arg_1:String):ColorTransform
        {
            var color:ColorTransform = greyCT;

            if (_arg_1 == "M1")
            {
                color = redCT;
            }
            if (_arg_1 == "M2")
            {
                color = greenCT;
            }
            if (_arg_1 == "M3")
            {
                color = yellowCT;
            }
            if (_arg_1 == "C1")
            {
                color = blueCT;
            }
            if (_arg_1 == "C2")
            {
                color = whiteCT;
            }
            if (_arg_1 == "C3")
            {
                color = orangeCT;
            }
            if (_arg_1 == "S1")
            {
                color = purpleCT;
            }
            if (_arg_1 == "none")
            {
                color = greyCT;
            }
            return (color);
        }

        private function hasEffects(meta:String) : Boolean
        {
            var effects:Array = ["dmgall", "undead", "human", "chaos", "dragonkin", "orc", "drakath", "elemental", "cp", "gold", "rep", "exp"];

            for (var key:String in effects)
            {
                if (meta.toLowerCase().indexOf(effects[key].toLowerCase()) > -1)
                {
                    return true;
                }
            }

            return false;
        }


    }
}//package 

