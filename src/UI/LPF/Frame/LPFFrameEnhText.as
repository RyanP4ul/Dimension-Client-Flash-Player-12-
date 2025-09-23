// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//LPFFrameEnhText

package UI.LPF.Frame
{
    import flash.display.MovieClip;
    import flash.text.TextField;
    import flash.display.DisplayObject;
    import flash.events.MouseEvent;
    import flash.text.*;

import game.boost.BoostContainer;
import game.boost.ClassBoost;

import game.boost.DamageBoost;
import game.boost.GoldBoost;
import game.boost.RepBoost;
import game.boost.XpBoost;

public class LPFFrameEnhText extends LPFFrame
    {

        public var mcStats:MovieClip;
        public var tDesc:TextField;

        public var tEnh:TextField;

        internal var mcContainer:MovieClip;
        internal var mcRuneContainer:MovieClip;
        internal var boostsObj:Object;

        private var iSel:Object;
        private var eSel:Object;
        private var iEnh:Object;
        private var eEnh:Object;
        private var game:Game;
        private var curItem:Object;
        private var isEquip:Boolean = false;

        public function LPFFrameEnhText():void
        {
            mcStats.sproto.visible = false;
        }

        override public function fOpen(_arg_1:Object):void
        {
            game = Game.root;
            positionBy(_arg_1.r);
            iEnh = null;
            eEnh = null;

            if (("eventTypes" in _arg_1))
            {
                eventTypes = _arg_1.eventTypes;
            }

            if (("isEquip" in _arg_1))
            {
                isEquip = _arg_1.isEquip;
            }

            fDraw();
            getLayout().registerForEvents(this, eventTypes);
        }

        override public function fClose():void
        {
            var _local_1:DisplayObject;
            while (mcStats.numChildren > 1)
            {
                _local_1 = mcStats.getChildAt(1);
                _local_1.removeEventListener(MouseEvent.MOUSE_OVER, onTTFieldMouseOver);
                _local_1.removeEventListener(MouseEvent.MOUSE_OUT, onTTFieldMouseOut);
                _local_1.removeEventListener(MouseEvent.MOUSE_OVER, onRuneSlotMouseOver);
                _local_1.removeEventListener(MouseEvent.MOUSE_OUT, onRuneSlotMouseOut);
                mcStats.removeChildAt(1);
            }

            getLayout().unregisterFrame(this);
            if (parent != null)
            {
                parent.removeChild(this);
            }
        }

        protected function fDraw():void
        {
            var wItem:Object;
            var procID:String;
            var isEnh:Boolean;
            var iDPS:Number;
            var iRNG:Number;
            var iRty:int;
            var iLvl:int;
            var HPTgt:int;
            var TTD:int;
            var wSPD:int;
            var wDPS:int;
            var wDMG:int;
            var AA:Object;
            var wDMN:int;
            var wDMX:int;
            var tDescStr:String = "";
            var patternNameColor:String = "#00CCFF";

            trace("EnhText > iSel > " + JSON.stringify(iSel));
            trace("EnhText > eSel > " + JSON.stringify(eSel));

            if (eSel != null && eSel.sType.toLowerCase() == "rune") return;
            if (iSel != null && iSel.sType.toLowerCase() == "rune")
            {
                while (mcStats.numChildren > 1)
                {
                    mcStats.removeChildAt(1);
                }

                tDesc.htmlText =  "Rune for <b><font color='#00CCFF'>" + iSel.sES + "</font></b><br><font color='#FF0000'>Runes cannot be enhanced!</font>";
                return;
            }

            if (iSel != null)
            {
                tDescStr = "<font size='10' color='#FFFFFF'>Enhancement: </font>";
                if (["Weapon", "he", "ar", "ba", "ti"].indexOf(iSel.sES) > -1)
                {
                    game.world.initPatternTree();
                    iEnh = null;
                    eEnh = null;
                    if (iSel.PatternID != null)
                    {
                        iEnh = game.world.enhPatternTree[iSel.PatternID];
                    }
                    if (iSel.EnhPatternID != null)
                    {
                        iEnh = game.world.enhPatternTree[iSel.EnhPatternID];
                    }
                    if (eSel != null)
                    {
                        if (eSel.sES == iSel.sES)
                        {
                            if (eSel.PatternID != null)
                            {
                                eEnh = game.world.enhPatternTree[eSel.PatternID];
                            }
                            if (eSel.EnhPatternID != null)
                            {
                                eEnh = game.world.enhPatternTree[eSel.EnhPatternID];
                            }
                            tDescStr = (tDescStr + ((("<font size='11' color='" + patternNameColor) + "'>") + eEnh.sName));
                            if (eSel.iRty > 1)
                            {
                                tDescStr = (tDescStr + (" +" + (eSel.iRty - 1)));
                            }
                            tDescStr = (tDescStr + "</font>");
                            tDescStr = (tDescStr + "<font size='11' color='#FFFFFF'> vs. </font>");
                            patternNameColor = "#999999";
                            if (iEnh != null)
                            {
                                tDescStr = (tDescStr + ((("<font size='11' color='" + patternNameColor) + "'>") + iEnh.sName));
                                if (iSel.EnhRty > 1)
                                {
                                    tDescStr = (tDescStr + (" +" + (iSel.EnhRty - 1)));
                                }
                                tDescStr = (tDescStr + "</font>");
                            }
                            else
                            {
                                tDescStr = (tDescStr + "<font size='10' color='#00CCFF'>No enhancement</font>");
                            }
                        }
                        else
                        {
                            tDescStr = (tDescStr + "<font size='11' color='#00CCFF'>Enhancement type must match item slot!</font>");
                        }
                    }
                    else
                    {
                        if (iEnh != null)
                        {
                            tDescStr = (tDescStr + ((("<font size='10' color='" + patternNameColor) + "'>") + iEnh.sName));
                            if ((("EnhRty" in iSel) && (iSel.EnhRty > 1)))
                            {
                                tDescStr = (tDescStr + (" +" + (iSel.EnhRty - 1)));
                            }
                            else
                            {
                                if (((("iRty" in iSel) && (iSel.iRty < 10)) && (iSel.iRty > 1)))
                                {
                                    tDescStr = (tDescStr + (" +" + (iSel.iRty - 1)));
                                }
                            }
                            if (iSel.ProcID)
                            {
                                switch (iSel.ProcID)
                                {
                                    case 2:
                                        procID = "Spiral Carve";
                                        break;
                                    case 3:
                                        procID = "Awe Blast";
                                        break;
                                    case 4:
                                        procID = "Health Vamp";
                                        break;
                                    case 5:
                                        procID = "Mana Vamp";
                                        break;
                                    case 6:
                                        procID = "Powerword DIE";
                                        break;
                                    default:
                                        procID = "Unknown";
                                }
                                tDescStr = (tDescStr + (", " + procID));
                            }
                            tDescStr = (tDescStr + "</font>");
                        }
                        else
                        {
                            tDescStr = (tDescStr + "<font size='11' color='#00CCFF'>No enhancement</font>");
                        }
                    }
                    if (iSel.sType.toLowerCase() == "enhancement")
                    {
                        tDescStr = (tDescStr + " <font size='11' color='#FFFFFF'>imbues an item with: </font>");
                    }
                    wItem = game.copyObj(iSel);
                    if (eSel != null)
                    {
                        wItem = game.copyObj(eSel);
                        if (iSel != null)
                        {
                            wItem.sType = iSel.sType;
                            if (("EnhRty" in iSel))
                            {
                                wItem.EnhRty = iSel.EnhRty;
                            }
                            if (("iRng" in iSel))
                            {
                                wItem.iRng = iSel.iRng;
                            }
                            else
                            {
                                wItem.iRng = 10;
                            }
                        }
                    }
                    if (wItem.sES.toLowerCase() == "weapon")
                    {
                        isEnh = (wItem.sType.toLowerCase() == "enhancement");
                        if (isEnh)
                        {
                            iDPS = wItem.iDPS;
                        }
                        else
                        {
                            if (("EnhDPS" in wItem))
                            {
                                iDPS = wItem.EnhDPS;
                            }
                            else
                            {
                                if (((!(eSel == null)) && ("iDPS" in eSel)))
                                {
                                    iDPS = eSel.iDPS;
                                }
                                else
                                {
                                    iDPS = -1;
                                }
                            }
                        }
                        if (iDPS == 0)
                        {
                            iDPS = 100;
                        }
                        if (iDPS == -1)
                        {
                            iDPS = 100;
                        }
                        iDPS = (iDPS / 100);
                        iRNG = (("iRng" in wItem) ? wItem.iRng : 0);
                        iRNG = (iRNG / 100);
                        iRty = 0;
                        if (("iRty" in wItem))
                        {
                            iRty = (wItem.iRty - 1);
                        }
                        if (("EnhRty" in wItem))
                        {
                            iRty = (wItem.EnhRty - 1);
                        }
                        if (isEnh)
                        {
                            iLvl = wItem.iLvl;
                        }
                        else
                        {
                            if (("EnhLvl" in wItem))
                            {
                                iLvl = wItem.EnhLvl;
                            }
                            else
                            {
                                if (((!(eSel == null)) && ("iLvl" in eSel)))
                                {
                                    iLvl = eSel.iLvl;
                                }
                                else
                                {
                                    iLvl = iSel.iLvl;
                                }
                            }
                        }
                        HPTgt = game.statsController.getBaseHPByLevel((iLvl + iRty));
                        TTD = 20;
                        wSPD = 2;
                        wDPS = Math.round((((HPTgt / TTD) * iDPS) * game.statsController.PCDPSMod));
                        wDMG = Math.round((wDPS * wSPD));
                        AA = game.world.getAutoAttack();
                        wDMG = (wDMG * AA.damage);
                        wDMN = Math.floor((wDMG - (wDMG * iRNG)));
                        wDMX = Math.ceil((wDMG + (wDMG * iRNG)));
                        if (((wItem.sType.toLowerCase() == "enhancement") || (("EnhLvl" in wItem) || (!(eSel == null)))))
                        {
                            tDescStr = (tDescStr + (("<br><font color='#FFFFFF'>" + wDPS) + " DPS"));
                        }
                        if (((!(wItem.sType.toLowerCase() == "enhancement")) && (("EnhLvl" in wItem) || (!(eSel == null)))))
                        {
                            tDescStr = (tDescStr + ((((((" ( <font color='#999999'>" + wDMN) + "-") + wDMX) + ", ") + game.numToStr((AA.cd / 1000), 1)) + " speed</font> )</font>"));
                        }
                    }
                }
                else
                {
                    tDescStr = (tDescStr + "<font size='10' color='#00CCFF'>This item cannot be enhanced.</font>");
                }
                tDesc.htmlText = tDescStr;
                showStats();
            }
            else
            {
                if (((!(MovieClip(getLayout()).iSel == null)) && (!(game.doIHaveEnhancements()))))
                {
                    tDesc.htmlText = "<font color='#FF0000'>You need an Enhancement!</font><br>";
                    tDesc.htmlText = (tDesc.htmlText + "<font color='#FFFFFF'>No enhancments for this type of item were found in your backpack. Enhancements are used to power up your item. You can buy at shops or find them on monsters.</font>");
                }
                else
                {
                    tDesc.htmlText = "No item selected.";
                }
                showStats();
            }
            tDesc.x = 2;
            tDesc.y = 7;
//            mcStats.x = 13;
            tDesc.y--;
        }

        override public function notify(o:Object):void
        {
            if (o.eventType != "showItemListB")
            {
                if (o.eventType == "refreshItems")
                {
                    if (iSel != o.fData.iSel && iSel != o.fData.eSel)
                    {
                        iSel = null;
                        eSel = null;
                    }
                }
                else
                {
                    if (o.eventType == "clearState")
                    {
                        iSel = null;
                        eSel = null;
                    }
                    else
                    {
                        iSel = o.fData.iSel;
                        eSel = o.fData.eSel;

                        if (iSel == null && eSel != null)
                        {
                            iSel = eSel;
                            eSel = null;
                        }
                        else if (iSel == null && eSel == null)
                        {
                            iSel = null;
                            eSel = null;
                        }
                    }
                }
            }

            if (isEquip)
            {
                if (iSel != null)
                {
                    iSel = game.world.myAvatar.getEquippedItemBySlot(iSel.sES);
                }
                if (eSel != null)
                {
                    eSel = game.world.myAvatar.getEquippedItemBySlot(eSel.sES);
                }
            }

            fDraw();
        }

        private function showStats():void
        {
            var _local_4:int;
            var _local_12:Boolean;
            var _local_13:Array;
            var _local_14:MovieClip;
            var _local_15:String;
            var _local_16:*;
            var _local_17:int;
            var _local_18:*;
            var _local_19:String;
            var _local_20:MovieClip;
            var _local_21:MovieClip;
            var _local_22:MovieClip;
            var _local_23:MovieClip;
            var _local_24:MovieClip;

            var stats:Object;
            var statsB:Object;
            var statMC:MovieClip;
            var proxyItem:Object;
            while (mcStats.numChildren > 1)
            {
                mcStats.removeChildAt(1);
            }
            mcStats.sproto.x = 0;
            mcStats.sproto.y = (tDesc.textHeight + 8);
            var compare:* = (!(eSel == null));
            var i:int;
            var c:int = 0;
            var _local_6:int;
            var vB:int;
            var s:* = "";
            var statClass:Class = (mcStats.sproto.constructor as Class);
			
            if (((!(iSel == null)) && ((((!(iEnh == null)) || (!(eEnh == null))) && ((eSel == null) || (eSel.sES == iSel.sES))) || ((compare) && (eSel.sES == iSel.sES)))))
            {
                if (((compare) && (!(iEnh == null))))
                {
                    stats = game.statsController.getStatsA(eSel, iSel.sES);
                    statsB = game.statsController.getStatsA(iSel, iSel.sES);
                }
                else
                {
                    proxyItem = game.copyObj(iSel);
                    if (compare)
                    {
                        proxyItem.EnhPatternID = eSel.PatternID;
                        proxyItem.EnhLvl = eSel.iLvl;
                        proxyItem.EnhRty = eSel.iRty;
                        compare = false;
                    }
                    stats = game.statsController.getStatsA(proxyItem, iSel.sES);
                }
				
                i = 0;
                while (i < game.statsController.orderedStats.length)
                {
                    s = game.statsController.orderedStats[i];
                    vB = 0;
                    if ((((compare) && (!(statsB[("$" + s)] == null))) && (stats[("$" + s)] == null)))
                    {
                        stats[("$" + s)] = 0;
                    }
                    if (stats[("$" + s)] != null)
                    {
                        statMC = new (statClass)();
                        _local_6 = stats[("$" + s)];
                        statMC.tSta.text = game.statsController.getFullStatName(s).toUpperCase();
                        statMC.tOldval.visible = false;
                        if (compare)
                        {
                            if (statsB[("$" + s)] != null)
                            {
                                vB = statsB[("$" + s)];
                            }
                            statMC.tOldval.text = (("(" + vB) + ")");
                            statMC.tOldval.visible = true;
                            if (_local_6 > vB)
                            {
                                statMC.tVal.htmlText = (("<font color='#33FF66'>" + _local_6) + "</font>");
                            }
                            else
                            {
                                if (_local_6 == vB)
                                {
                                    statMC.tVal.htmlText = (("<font color='#FFFFFF'>" + _local_6) + "</font>");
                                }
                                else
                                {
                                    statMC.tVal.htmlText = (("<font color='#FF6633'>" + _local_6) + "</font>");
                                }
                            }
                        }
                        else
                        {
                            statMC.tVal.htmlText = (('<font color="0xFFFFFF">' + _local_6) + "</font>");
                        }
                        statMC.tOldval.x = ((statMC.tVal.x + statMC.tVal.textWidth) + 3);
                        statMC.x = (mcStats.sproto.x + ((c % 3) * 100));
                        statMC.y = (mcStats.sproto.y + (Math.floor((c / 3)) * 16));
                        statMC.hit.alpha = 0;
                        statMC.addEventListener(MouseEvent.MOUSE_OVER, onTTFieldMouseOver, false, 0, true);
                        statMC.addEventListener(MouseEvent.MOUSE_OUT, onTTFieldMouseOut, false, 0, true);
                        statMC.name = ("t" + s);
                        mcStats.addChild(statMC);
                        c++;
                    }
                    i++;
                }
                mcStats.visible = true;
            }
            else
            {
                mcStats.visible = false;
            }

            if (mcContainer && getChildByName("mcContainer")) removeChild(getChildByName("mcContainer"));
            if (mcRuneContainer && getChildByName("mcRuneContainer")) removeChild(getChildByName("mcRuneContainer"));

            if (iSel != null)
            {
                if (iSel.hasOwnProperty("effects"))
                {
                    _local_12 = false;
                    switch (iSel.sES)
                    {
                        case "he":
                        case "ba":
                        case "Weapon":
                        case "pe":
                        case "co":
                        case "mi":
                            _local_12 = true;
                            break;
                    }
                    if (!_local_12)
                    {
                        return;
                    }
                    boostsObj = {};
                    mcContainer = new BoostContainer();
                    iEnh = null;
                    if (iSel.PatternID != null)
                    {
                        iEnh = game.world.enhPatternTree[iSel.PatternID];
                    }
                    if (iSel.EnhPatternID != null)
                    {
                        iEnh = game.world.enhPatternTree[iSel.EnhPatternID];
                    }

                    addChild(mcContainer);
                    mcContainer.name = "mcContainer";
                    mcContainer.x = 2;
                    mcContainer.y = 155;

                    while (mcContainer.numChildren > 0)
                    {
                        mcContainer.removeChildAt(0);
                    }
                    _local_13 = iSel.effects;
                    _local_14 = new DamageBoost();
                    if (!boostsObj["dmgBoost"])
                    {
                        boostsObj["dmgBoost"] = "";
                    }

                    for each (_local_16 in _local_13)
                    {
                        _local_15 = Math.abs(Math.round(((Number(_local_16.Value) - 1) * 100))).toString();
                        switch (_local_16.Effect.toLowerCase())
                        {
                            case "dmgall":
                                boostsObj["dmgBoost"] = (boostsObj["dmgBoost"] + (("Damage All +" + _local_15) + "%\n"));
                                break;
                            case "dmgtaken":
                                boostsObj["dmgBoost"] = (boostsObj["dmgBoost"] + (("Damage Taken +" + _local_15) + "%\n"));
                                break;
                            case "exp":
                                boostsObj["xpBoost"] = (("Experience +" + _local_15) + "%");
                                break;
                            case "copper":
                                boostsObj["goldBoost"] = (("Copper +" + _local_15) + "%");
                                break;
                            case "silver":
                                boostsObj["goldBoost"] = (("Silver +" + _local_15) + "%");
                                break;
                            case "gold":
                                boostsObj["goldBoost"] = (("Gold +" + _local_15) + "%");
                                break;
                            case "rep":
                                boostsObj["repBoost"] = (("Reputation +" + _local_15) + "%");
                                break;
                            case "cp":
                                boostsObj["classBoost"] = (("Class Points +" + _local_15) + "%");
                                break;
                        }
                    }
                    _local_17 = 30;
                    for (_local_18 in boostsObj)
                    {
                        switch (_local_18)
                        {
                            case "dmgBoost":
                                if (boostsObj[_local_18] == "") break;
                                mcContainer.addChild(_local_14);
                                _local_14.width = _local_17;
                                _local_14.height = _local_17;
                                _local_14.name = "dmgBoost";
                                _local_14.addEventListener(MouseEvent.MOUSE_OVER, onBoostGet, false, 0, true);
                                _local_14.addEventListener(MouseEvent.MOUSE_OUT, onBoostOut, false, 0, true);
                                break;
                            case "classBoost":
                                _local_20 = new ClassBoost();
                                mcContainer.addChild(_local_20);
                                _local_20.width = _local_17;
                                _local_20.height = _local_17;
                                _local_20.name = "classBoost";
                                _local_20.addEventListener(MouseEvent.MOUSE_OVER, onBoostGet, false, 0, true);
                                _local_20.addEventListener(MouseEvent.MOUSE_OUT, onBoostOut, false, 0, true);
                                break;
                            case "goldBoost":
                                _local_21 = new GoldBoost();
                                mcContainer.addChild(_local_21);
                                _local_21.width = _local_17;
                                _local_21.height = _local_17;
                                _local_21.name = "goldBoost";
                                _local_21.addEventListener(MouseEvent.MOUSE_OVER, onBoostGet, false, 0, true);
                                _local_21.addEventListener(MouseEvent.MOUSE_OUT, onBoostOut, false, 0, true);
                                break;
                            case "repBoost":
                                _local_22 = new RepBoost();
                                mcContainer.addChild(_local_22);
                                _local_22.width = _local_17;
                                _local_22.height = _local_17;
                                _local_22.name = "repBoost";
                                _local_22.addEventListener(MouseEvent.MOUSE_OVER, onBoostGet, false, 0, true);
                                _local_22.addEventListener(MouseEvent.MOUSE_OUT, onBoostOut, false, 0, true);
                                break;
                            case "xpBoost":
                                _local_23 = new XpBoost();
                                mcContainer.addChild(_local_23);
                                _local_23.width = _local_17;
                                _local_23.height = _local_17;
                                _local_23.name = "xpBoost";
                                _local_23.addEventListener(MouseEvent.MOUSE_OVER, onBoostGet, false, 0, true);
                                _local_23.addEventListener(MouseEvent.MOUSE_OUT, onBoostOut, false, 0, true);
                                break;
                        }
                    }
                    _local_4 = 0;
                    while (_local_4 < mcContainer.numChildren)
                    {
                        _local_24 = (mcContainer.getChildAt(_local_4) as MovieClip);
                        _local_24.x = ((_local_4 * _local_24.width) + 2);
                        _local_4++;
                    }
                }

                if (iSel.hasOwnProperty("iRune") && iSel.iRune > 0)
                {
                    mcRuneContainer = new MovieClip();
                    mcRuneContainer.name = "mcRuneContainer";
                    mcRuneContainer.x = 2;
                    mcRuneContainer.y = iSel.hasOwnProperty("effects") ? 120 : 155;
                    addChild(mcRuneContainer);

                    for (var rune:int = 0; rune < iSel.iRune; rune++)
                    {
                        var runeSlot:ItemRuneSlot = new ItemRuneSlot();
                        runeSlot.x = (runeSlot.width + 5) * mcRuneContainer.numChildren;

                        if (iSel.hasOwnProperty("runes"))
                        {
                            var runeObj:Object = iSel.runes[rune];

                            if (runeObj != null)
                            {
                                try {
                                    var AssetClass:Class = game.world.getClass(runeObj.Icon);
                                    var icon:MovieClip = new AssetClass();
                                    icon.scaleX = icon.scaleY = 0.4;
                                    icon.x = runeSlot.width / 2 - icon.width / 2;
                                    icon.y = runeSlot.height / 2 - icon.height / 2;
                                    runeSlot.data = runeObj;
                                    runeSlot.addChild(icon);
                                    runeSlot.slot.visible = false;
                                    runeSlot.addEventListener(MouseEvent.MOUSE_OVER, onRuneSlotMouseOver, false, 0, true);
                                    runeSlot.addEventListener(MouseEvent.MOUSE_OUT, onRuneSlotMouseOut, false, 0, true);
                                } catch(e:Error) {
                                    trace("Error loading rune asset: " + e.message);
                                }
                            }
                        }

                        mcRuneContainer.addChild(runeSlot);
                    }
                }

            }
        }

        private function onRuneSlotMouseOver(event:MouseEvent):void
        {
            game.ui.ToolTip.openWith({"str": event.currentTarget.data.Name + "\n" + event.currentTarget.data.Description});
        }

        private function onRuneSlotMouseOut(_arg_1:MouseEvent):void
        {
            game.ui.ToolTip.close();
        }

        private function onBoostGet(_arg_1:MouseEvent):void
        {
            var _local_2:String = _arg_1.currentTarget.name;
            game.ui.ToolTip.openWith({"str":boostsObj[_local_2]});
        }

        private function onBoostOut(_arg_1:MouseEvent):void
        {
            game.ui.ToolTip.close();
        }

        private function onTTFieldMouseOver(_arg_1:MouseEvent):void
        {
            var _local_2:String = _arg_1.currentTarget.name;
            var _local_3:* = "";
            switch (_local_2)
            {
                case "tAP":
                    _local_3 = "Attack Power increases the effectiveness of your physical damage attacks.";
                    break;
                case "tSP":
                    _local_3 = "Magic Power increases the effectiveness of your magical damage attacks.";
                    break;
                case "tDmg":
                    _local_3 = "This is the damage you would expect to see on a normal melee hit, before any other modifiers.";
                    break;
                case "tHP":
                    _local_3 = "Your total Hit Points.  When these reach zero, you will need to wait a short time before being able to continue playing.";
                    break;
                case "tHitTF":
                    _local_3 = "Hit chance determines how likely you are to hit a target, before any other modifiers.";
                    break;
                case "tHasteTF":
                    _local_3 = "Haste reduces the cooldown on all of your attacks and spells, including Auto Attack, by a certain percentage (hard capped at 50%).";
                    break;
                case "tCritTF":
                    _local_3 = "Critical Strike chance increases the likelihood of dealing additional damage on a any attack.";
                    break;
                case "tDodgeTF":
                    _local_3 = "Evasion chance allows you to completely avoid incoming damage.";
                    break;
                case "tSTR":
                case "sl1":
                    _local_3 = "Strength increases Attack Power, which boosts physical damage. It also improves Critical Strike chance for melee classes.";
                    break;
                case "tINT":
                case "sl2":
                    _local_3 = "Intellect increases Magic Power, which boosts magical damage. It also improve Critical Strike chance for caster classes.";
                    break;
                case "tEND":
                case "sl3":
                    _local_3 = "Endurance directly contributes to your total Hit Points.  While very useful for all classes, some abilities work best with very high or very low total HP.";
                    break;
                case "tDEX":
                case "sl4":
                    _local_3 = "Dexterity is valuable to melee classes. It increases Haste, Hit chance, and Evasion chance. It increases only Evasion chance for caster classes.";
                    break;
                case "tWIS":
                case "sl5":
                    _local_3 = "Wisdom is valuable to caster classes. It increases Hit chance, Crit chance, and Evasion chance. It improves only Evasion chance for melee classes.";
                    break;
                case "tLCK":
                case "sl6":
                    _local_3 = "Luck increases your Critical Strike modifier value directly, and may have effects outside of combat.";
                    break;
            }
            game.ui.ToolTip.openWith({"str":_local_3});
        }

        private function onTTFieldMouseOut(_arg_1:MouseEvent):void
        {
            game.ui.ToolTip.close();
        }

        public function onRepBarMouseOver(event:MouseEvent):* {
            MovieClip(event.currentTarget).strRep.visible = true;
        }

        public function onRepBarMouseOut(event:MouseEvent):* {
            MovieClip(event.currentTarget).strRep.visible = false;
        }

    }
}//package 

