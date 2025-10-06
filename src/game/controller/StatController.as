package game.controller {
public class StatController {

    private var game:Game;

    public var intLevelCap:int;
    public var PCstBase:int;
    public var PCstRatio:Number;
    public var PCstGoal:int;
    public var GstBase:int;
    public var GstRatio:Number;
    public var GstGoal:int;
    public var PChpBase1:int;
    public var PChpBase100:int;
    public var PChpGoal1:int;
    public var PChpGoal100:int;
    public var PChpDelta:int;
    public var intHPperEND:int;
    public var intAPtoDPS:int;
    public var intSPtoDPS:int;
    public var bigNumberBase:int;
    public var resistRating:Number;
    public var modRating:Number;
    public var baseDodge:Number;
    public var baseBlock:Number;
    public var baseParry:Number;
    public var baseCrit:Number;
    public var baseHit:Number;
    public var baseHaste:Number;
    public var baseMiss:Number;
    public var baseResist:Number;
    public var baseCritValue:Number;
    public var baseBlockValue:Number;
    public var baseResistValue:Number;
    public var baseEventValue:Number;
    public var PCDPSMod:Number = 0.85;
    public var curveExponent:Number = 0.66;
    public var statsExponent:Number = 1.33;

    public var intBagSpaceCap:Number;
    public var intBagSpacePrice:Number;
    public var intBankSpaceCap:Number;
    public var intBankSpacePrice:Number;
    public var intHouseSpaceCap:Number;
    public var intHouseSpacePrice:Number;

    public var intCopperToSilver:Number;
    public var intSilverToGold:Number;
	public var intMaxReputationRank:Number;

    public var stats:Array = ["STR", "END", "DEX", "INT", "WIS", "LCK"];
    public var orderedStats:Array = ["STR", "INT", "DEX", "WIS", "END", "LCK"];
    public var statMap:Object = {
        "Strength": "STR",
        "Endurance": "END",
        "Dexterity": "DEX",
        "Intellect": "INT",
        "Wisdom": "WIS",
        "Lucky": "LCK"
    };
    public var ratiosBySlot:Object = {"he": 0.25, "ar": 0.25, "ba": 0.2, "Weapon": 0.33};
    public var I0pct:Number = 0.8;
    public var I2pct:Number = 1.25;

    public function StatController(game:Game)
    {
        this.game = game;
    }

    public var classCatMap:Object = {
        M1: {ratios: [0.27, 0.3, 0.22, 0.05, 0.1, 0.06]},
        M2: {ratios: [0.2, 0.22, 0.33, 0.05, 0.1, 0.1]},
        M3: {ratios: [0.24, 0.2, 0.2, 0.24, 0.07, 0.05]},
        M4: {ratios: [0.3, 0.18, 0.3, 0.02, 0.06, 0.14]},
        C1: {ratios: [0.06, 0.2, 0.11, 0.33, 0.15, 0.15]},
        C2: {ratios: [0.08, 0.27, 0.1, 0.3, 0.1, 0.15]},
        C3: {ratios: [0.06, 0.23, 0.05, 0.28, 0.28, 0.1]},
        S1: {ratios: [0.22, 0.18, 0.21, 0.08, 0.08, 0.23]}
    };

    public function applyCoreStatRatings(o:Object, level:int):void {
        var _local_3:int = 1;
        var _local_4:* = 100;
        var _local_5:Object = game.world.myAvatar.getEquippedItemBySlot("Weapon");
        if (_local_5 != null) {
            if (_local_5.EnhLvl != null) {
                _local_3 = _local_5.EnhLvl;
            }
            if (_local_5.EnhDPS != null) {
                _local_4 = Number(_local_5.EnhDPS);
            }
            if (_local_4 == 0) {
                _local_4 = 100;
            }
        }
        _local_4 = _local_4 / 100;
        var staName:* = "";
        var sp1Pc:Number = -1;
        var val:int = -1;
        var category:String = game.world.myAvatar.objData.sClassCat;
        var hpTgt:int = getBaseHPByLevel(level);
        var _local_15:int = 20;
        var tDps:* = (hpTgt / 20.0) * 0.7;
        var _local_17:Number = (2.25 * tDps) / (100 / intAPtoDPS) / 2;

        resetTableValues(o);

        var i:int = 0;
        while (i < stats.length) {
            staName = stats[i];
            val = o["$" + staName];
            switch (staName) {
                case "STR":
                    sp1Pc = _local_17;
                    if (category == "S1") {
                        o.$ap = o.$ap + Math.round(val * 1.4);
                    } else {
                        o.$ap = o.$ap + val * 2;
                    }
                    if (category == "M1" || category == "M2" || category == "M3" || category == "M4" || category == "S1") {
                        o.$tcr = o.$tcr + ((val / sp1Pc / 100) * (category == "M4" ? 0.7 : 0.4));
                    }
                    break;
                case "INT":
                    sp1Pc = _local_17;
                    o.$cmi = o.$cmi - (val / sp1Pc) / 100;
                    if (category.substr(0, 1) == "C" || category == "M3") {
                        o.$cmo = o.$cmo + (val / sp1Pc) / 100;
                    }
                    if (category == "S1") {
                        o.$sp = o.$sp + Math.round(val * 1.4);
                    } else {
                        o.$sp = o.$sp + val * 2;
                    }
                    if (((category == "C1") || (category == "C2")) || (category == "C3") || category == "M3" || category == "S1") {
                        if (category == "C2") {
                            o.$tha = o.$tha + ((val / sp1Pc) / 100) * 0.5;
                        } else {
                            o.$tha = o.$tha + ((val / sp1Pc) / 100) * 0.3;
                        }
                    }
                    break;
                case "DEX":
                    sp1Pc = _local_17;
                    if (((category == "M1") || (category == "M2")) || (category == "M3") || category == "M4" || category == "S1") {
                        if (category.substr(0, 1) != "C") {
                            o.$thi = o.$thi + ((val / sp1Pc) / 100) * 0.2;
                        }
                        if (category == "M2" || category == "M4") {
                            o.$tha = o.$tha + ((val / sp1Pc) / 100) * 0.5;
                        } else {
                            o.$tha = o.$tha + ((val / sp1Pc) / 100) * 0.3;
                        }
                    }
                    if (category != "M2" && !category != "M3") {
                        o.$tdo = o.$tdo + ((val / sp1Pc) / 100) * 0.3;
                    } else {
                        o.$tdo = o.$tdo + ((val / sp1Pc) / 100) * 0.5;
                    }
                    break;
                case "WIS":
                    sp1Pc = _local_17;
                    if ((category == "C1") || (category == "C2") || category == "C3" || category == "S1") {
                        if (category == "C1") {
                            o.$tcr = o.$tcr + ((val / sp1Pc) / 100) * 0.7;
                        } else {
                            o.$tcr = o.$tcr + ((val / sp1Pc) / 100) * 0.4;
                        }
                        o.$thi = o.$thi + ((val / sp1Pc) / 100) * 0.2;
                    }
                    o.$tdo = o.$tdo + ((val / sp1Pc) / 100) * 0.3;
                    break;
                case "LCK":
                    sp1Pc = _local_17;
                    o.$sem = o.$sem + ((val / sp1Pc) / 100) * 2;
                    if (category == "S1") {
                        o.$ap = o.$ap + Math.round(val * 1);
                        o.$sp = o.$sp + Math.round(val * 1);
                        o.$tcr = o.$tcr + ((val / sp1Pc) / 100) * 0.3;
                        o.$thi = o.$thi + ((val / sp1Pc) / 100) * 0.1;
                        o.$tha =o.$tha + ((val / sp1Pc) / 100) * 0.3;
                        o.$tdo = o.$tdo + ((val / sp1Pc) / 100) * 0.25;
                        o.$scm = o.$scm + ((val / sp1Pc) / 100) * 2.5;
                    } else {
                        if ((category == "M1") || (category == "M2") || category == "M3" || category == "M4") {
                            o.$ap = o.$ap + Math.round(val * 0.7);
                        }
                        if ((category == "C1") || (category == "C2") || category == "C3" || category == "M3") {
                            o.$sp = o.$sp + Math.round(val * 0.7);
                        }
                        o.$tcr = o.$tcr + ((val / sp1Pc) / 100) * 0.2;
                        o.$thi = o.$thi + ((val / sp1Pc) / 100) * 0.1;
                        o.$tha = o.$tha + ((val / sp1Pc) / 100) * 0.1;
                        o.$tdo = o.$tdo + ((val / sp1Pc) / 100) * 0.1;
                        o.$scm = o.$scm + ((val / sp1Pc) / 100) * 5;
                    }
                    break;
            }
            i++;
        }

        o.wDPS = Math.round((getBaseHPByLevel(_local_3) / _local_15) * _local_4 * PCDPSMod) + Math.round(o.$ap / intAPtoDPS);
        o.mDPS = Math.round((getBaseHPByLevel(_local_3) / _local_15) * _local_4 * PCDPSMod) + Math.round(o.$sp / intSPtoDPS);

        trace("applyCoreStatRatings > " + JSON.stringify(o));
    }

    public function resetTableValues(o:Object):void {
        o.$ap = 0;
        o.$sp = 0;
        o.$tbl = baseBlock;
        o.$tpa = baseParry;
        o.$tdo = baseDodge;
        o.$tcr = baseCrit;
        o.$thi = baseHit;
        o.$tha = baseHaste;
        o.$tre = baseResist;
        o.$cpo = 1;
        o.$cpi = 1;
        o.$cao = 1;
        o.$cai = 1;
        o.$cmo = 1;
        o.$cmi = 1;
        o.$cdo = 1;
        o.$cdi = 1;
        o.$cho = 1;
        o.$chi = 1;
        o.$cmc = 1;
        o.$scm = baseCritValue;
        o.$sbm = baseBlockValue;
        o.$srm = baseResistValue;
        o.$sem = baseEventValue;
        o.$shb = 0;
        o.$smb = 0;
    }

    public function getCategoryStats(_arg_1:String, _arg_2:int):Object {
        var _local_3:* = getInnateStats(_arg_2);
        var _local_4:* = classCatMap[_arg_1].ratios;
        var _local_5:* = {};
        var _local_6:* = "";
        var _local_7:int;
        while (_local_7 < stats.length) {
            _local_6 = stats[_local_7];
            _local_5[_local_6] = Math.round(_local_4[_local_7] * _local_3);
            _local_7++;
        }
        return _local_5;
    }

    internal function getIBudget(_arg_1:int, _arg_2:int):int {
        if (_arg_1 < 1) {
            _arg_1 = 1;
        }
        if (_arg_1 > intLevelCap) {
            _arg_1 = intLevelCap;
        }
        if (_arg_2 < 1) {
            _arg_2 = 1;
        }
        _arg_1 = Math.round((_arg_1 + _arg_2) - 1);
        return Math.round(GstBase + Math.pow((_arg_1 - 1) / (intLevelCap - 1), statsExponent) * (GstGoal - GstBase));
    }

    public function getInnateStats(_arg_1:int):int {
        if (_arg_1 < 1) {
            _arg_1 = 1;
        }
        if (_arg_1 > intLevelCap) {
            _arg_1 = intLevelCap;
        }
        return Math.round(PCstBase + Math.pow((_arg_1 - 1) / (intLevelCap - 1), statsExponent) * (PCstGoal - PCstBase));
    }

    public function getBaseHPByLevel(_arg_1:*):* {
        if (_arg_1 < 1) {
            _arg_1 = 1;
        }
        if (_arg_1 > intLevelCap) {
            _arg_1 = intLevelCap;
        }
        return Math.round(PChpBase1 + Math.pow((_arg_1 - 1) / (intLevelCap - 1), curveExponent) * PChpDelta);
    }

    private function showRatings():void {
        var _local_6:*;
        var _local_7:*;
        var _local_8:*;
        var _local_9:*;
        var _local_10:*;
        var _local_11:*;
        var _local_12:*;
        var _local_13:*;
        var _local_14:*;
        var _local_15:*;
        var _local_16:*;
        var _local_1:* = game.world.myAvatar.dataLeaf;
        var _local_2:* = "";
        var _local_3:* = 1;
        var _local_4:* = 0;
        var _local_5:* = 0;
        _local_3 = 1;
        while (_local_3 <= 35) {
            if (_local_3 == 0) {
                _local_3 = 1;
            }
            _local_6 = getInnateStats(_local_3);
            _local_7 = getIBudget(_local_3, 1);
            _local_8 = -1;
            _local_9 = -1;
            _local_10 = -1;
            _local_11 = -1;
            _local_12 = _local_1.sCat;
            _local_13 = game.copyObj(_local_1.sta);
            resetTableValues(_local_13);
            _local_14 = getBaseHPByLevel(_local_3);
            _local_15 = (_local_14 / 20) * 0.7;
            _local_16 = (2.25 * _local_15) / (100 / intAPtoDPS) / 2;
            trace("Level " + _local_3);
            _local_4 = 0;
            while (_local_4 < stats.length) {
                _local_2 = stats[_local_4];
                _local_11 = _local_13[("$" + _local_2)];
                switch (_local_2) {
                    case "STR":
                        _local_8 = _local_16;
                        _local_13.$ap = _local_13.$ap + _local_11 * 2;
                        _local_13.$tcr = _local_13.$tcr + ((_local_11 / _local_8) / 100) * 0.4;
                        trace((((((((("  " + game.spaceBy(_local_14, 5)) + "  |  ") + game.spaceBy(_local_11, 4)) + "  |  ") + game.spaceNumBy(_local_8, 4)) + "  |  ") + game.spaceNumBy(_local_6, 6)) + "  |  ") + game.spaceNumBy(_local_7, 6) + "  |  " + game.spaceNumBy(_local_13.$tcr, 6));
                        break;
                }
                _local_4++;
            }
            trace("");
            _local_3 = _local_3 + 1;
        }
    }

    public function getStatsA(_arg_1:Object, _arg_2:String):Object {
        var _local_6:Object;
        var _local_3:int = _arg_1.sType.toLowerCase() == "enhancement" ? _arg_1.iLvl : _arg_1.EnhLvl;
        var _local_4:int = _arg_1.sType.toLowerCase() == "enhancement" ? _arg_1.iRty : _arg_1.EnhRty;
        var _local_5:int = Math.round(getIBudget(_local_3, _local_4) * ratiosBySlot[_arg_2]);
        var _local_7:* = -1;
        var _local_8:* = ["iEND", "iSTR", "iINT", "iDEX", "iWIS", "iLCK"];
        var _local_9:* = 0;
        var _local_10:* = "";
        var _local_11:* = {};
        var _local_12:* = 0;
        var _local_13:int;
        var _local_14:Object = {};

        if (_arg_1.PatternID != null) {
            _local_6 = game.world.enhPatternTree[_arg_1.PatternID];
        }

        if (_arg_1.EnhPatternID != null) {
            _local_6 = game.world.enhPatternTree[_arg_1.EnhPatternID];
        }

        if (_local_6 != null) {
            _local_13 = 0;
            while (_local_13 < stats.length) {
                _local_10 = "i" + stats[_local_13];
                if (_local_6[_local_10] != null) {
                    _local_11[_local_10] = Math.round((_local_5 * _local_6[_local_10]) / 100);
                    _local_12 = _local_12 + _local_11[_local_10];
                }
                _local_13++;
            }

            _local_9 = 0;
            while (_local_12 < _local_5) {
                _local_10 = _local_8[_local_9];
                if (_local_11[_local_10] != null) {
                    _local_11[_local_10]++;
                    _local_12++;
                }
                if (++_local_9 > _local_8.length - 1) {
                    _local_9 = 0;
                }
            }

            _local_13 = 0;
            while (_local_13 < stats.length) {
                _local_7 = _local_11[("i" + stats[_local_13])];
                if (!(_local_7 == null) && !(_local_7 == "0")) {
                    _local_14[("$" + stats[_local_13])] = _local_7;
                }
                _local_13++;
            }

        }

        return _local_14;
    }

    public function getFullStatName(rarity:String):String {
        var str:String = "";
        rarity = rarity.toLowerCase();

        if (rarity.indexOf("str") > -1) {
            str = "Strength"; // Strength
        }
        if (rarity.indexOf("int") > -1) {
            str = "Intellect"; // Intellect
        }
        if (rarity.indexOf("dex") > -1) {
            str = "Dexterity"; // Dexterity
        }
        if (rarity.indexOf("wis") > -1) {
            str = "Wisdom"; // Wisdom
        }
        if (rarity.indexOf("end") > -1) {
            str = "Endurance"; // Endurance
        }
        if (rarity.indexOf("lck") > -1) {
            str = "Luck"; // Luck
        }
        if (rarity.indexOf("tha") > -1) {
            str = "Haste";
        }
        if (rarity.indexOf("thi") > -1) {
            str = "Hit";
        }
        if (rarity.indexOf("tcr") > -1) {
            str = "Critcal Hit";
        }
        if (rarity.indexOf("tcm") > -1) {
            str = "Crit Value";
        }
        if (rarity.indexOf("tdo") > -1) {
            str = "Evasion";
        }
        return str;
    }

    public function getItemInfoString(_arg_1:Object):String {
        var _local_3:int;
        var _local_4:*;
        var _local_5:int;
        var _local_6:*;
        var _local_7:*;
        var _local_8:*;
        var _local_9:*;
        var _local_10:*;
        var _local_11:*;
        var _local_12:*;
        var _local_13:*;
        var _local_14:*;
        var _local_15:*;
        var _local_2:* = (("<font size='14'><b>" + _arg_1.sName) + "</b></font><br>");
        if (((!(game.validateArmor(_arg_1))) && (_arg_1.iClass > 0))) {
            _local_2 = (_local_2 + "<font size='11' color='#CC0000'>");
            _local_3 = game.getRankFromPoints(_arg_1.iReqCP);
            _local_4 = (_arg_1.iReqCP - game.arrRanks[(_local_3 - 1)]);
            if (_local_4 > 0) {
                _local_2 = (_local_2 + (((((("Requires " + _local_4) + " Class Points on ") + _arg_1.sClass) + ", Rank ") + _local_3) + "."));
            } else {
                _local_2 = (_local_2 + (((("Requires " + _arg_1.sClass) + ", Rank ") + _local_3) + "."));
            }
            _local_2 = (_local_2 + "</font><br>");
        }
        if (((_arg_1.FactionID > 1) && (game.world.myAvatar.getRep(_arg_1.FactionID) < _arg_1.iReqRep))) {
            _local_2 = (_local_2 + "<font size='11' color='#CC0000'>");
            _local_5 = game.getRankFromPoints(_arg_1.iReqRep);
            _local_6 = (_arg_1.iReqRep - game.arrRanks[(_local_3 - 1)]);
            if (_local_6 > 0) {
                _local_2 = (_local_2 + (((((("Requires " + _local_6) + " Reputation on ") + _arg_1.sFaction) + ", Rank ") + _local_5) + "."));
            } else {
                _local_2 = (_local_2 + (((("Requires " + _arg_1.sFaction) + ", Rank ") + _local_5) + "."));
            }
            _local_2 = (_local_2 + "</font><br>");
        }
//        if (((_arg_1.iQSindex >= 0) && (world.getQuestValue(_arg_1.iQSindex) < int(_arg_1.iQSvalue)))) {
//            _local_2 = (_local_2 + (("<font size='11' color='#CC0000'>Requires completion of quest \"" + _arg_1.sQuest) + '".</font><br>'));
//        }
        _local_2 = (_local_2 + ("<font color='#009900'><b>" + game.getDisplaysType(_arg_1)));
        if (((!(_arg_1.sES == "None")) && (!(_arg_1.sES == "co")))) {
            if (_arg_1.EnhID > 0) {
                _local_2 = (_local_2 + (", Lvl " + _arg_1.EnhLvl));
                if (_arg_1.sES == "Weapon") {
                    _local_7 = getBaseHPByLevel(_arg_1.EnhLvl);
                    _local_8 = 20;
                    _local_9 = 1;
                    _local_10 = (_arg_1.iRng / 100);
                    _local_11 = 2;
                    _local_12 = Math.round(((_local_7 / _local_8) * _local_9));
                    _local_13 = Math.round((_local_12 * _local_11));
                    _local_14 = Math.floor((_local_13 - (_local_13 * _local_10)));
                    _local_15 = Math.ceil((_local_13 + (_local_13 * _local_10)));
                    _local_2 = (_local_2 + ((((("<br>" + _local_14) + " - ") + _local_15) + " ") + _arg_1.sElmt));
                }
            } else {
                _local_2 = (_local_2 + " Design");
            }
        }
        return (_local_2 + (("</b></font><br>" + _arg_1.sDesc) + "<br>"));
    }

    public function updateCoreValues(o:Object):void {
        if (o.intLevelCap != null) {
            intLevelCap = o.intLevelCap;
        }
        if (o.PCstBase != null) {
            PCstBase = o.PCstBase;
        }
        if (o.PCstRatio != null) {
            PCstRatio = o.PCstRatio;
        }
        if (o.PCstGoal != null) {
            PCstGoal = o.PCstGoal;
        }
        if (o.GstBase != null) {
            GstBase = o.GstBase;
        }
        if (o.GstRatio != null) {
            GstRatio = o.GstRatio;
        }
        if (o.GstGoal != null) {
            GstGoal = o.GstGoal;
        }
        if (o.PChpBase1 != null) {
            PChpBase1 = o.PChpBase1;
        }
        if (o.PChpBase100 != null) {
            PChpBase100 = o.PChpBase100;
        }
        if (o.PChpGoal1 != null) {
            PChpGoal1 = o.PChpGoal1;
        }
        if (o.PChpGoal100 != null) {
            PChpGoal100 = o.PChpGoal100;
        }
        if (o.PChpDelta != null) {
            PChpDelta = o.PChpDelta;
        }
        if (o.intHPperEND != null) {
            intHPperEND = o.intHPperEND;
        }
        if (o.intAPtoDPS != null) {
            intAPtoDPS = o.intAPtoDPS;
        }
        if (o.intSPtoDPS != null) {
            intSPtoDPS = o.intSPtoDPS;
        }
        if (o.bigNumberBase != null) {
            bigNumberBase = o.bigNumberBase;
        }
        if (o.resistRating != null) {
            resistRating = o.resistRating;
        }
        if (o.modRating != null) {
            modRating = o.modRating;
        }
        if (o.baseDodge != null) {
            baseDodge = o.baseDodge;
        }
        if (o.baseBlock != null) {
            baseBlock = o.baseBlock;
        }
        if (o.baseParry != null) {
            baseParry = o.baseParry;
        }
        if (o.baseCrit != null) {
            baseCrit = o.baseCrit;
        }
        if (o.baseHit != null) {
            baseHit = o.baseHit;
        }
        if (o.baseHaste != null) {
            baseHaste = o.baseHaste;
        }
        if (o.baseMiss != null) {
            baseMiss = o.baseMiss;
        }
        if (o.baseResist != null) {
            baseResist = o.baseResist;
        }
        if (o.baseCritValue != null) {
            baseCritValue = o.baseCritValue;
        }
        if (o.baseBlockValue != null) {
            baseBlockValue = o.baseBlockValue;
        }
        if (o.baseResistValue != null) {
            baseResistValue = o.baseResistValue;
        }
        if (o.baseEventValue != null) {
            baseEventValue = o.baseEventValue;
        }
        if (o.PCDPSMod != null) {
            PCDPSMod = o.PCDPSMod;
        }
        if (o.curveExponent != null) {
            curveExponent = o.curveExponent;
        }
        if (o.statsExponent != null) {
            statsExponent = o.statsExponent;
        }
        if (o.intBagSpaceCap != null) {
            intBagSpaceCap = o.intBagSpaceCap;
        }
        if (o.intBagSpacePrice != null) {
            intBagSpacePrice = o.intBagSpacePrice;
        }
        if (o.intBankSpaceCap != null) {
            intBankSpaceCap = o.intBankSpaceCap;
        }
        if (o.intBankSpacePrice != null) {
            intBankSpacePrice = o.intBankSpacePrice;
        }
        if (o.intHouseSpaceCap != null) {
            intHouseSpaceCap = o.intHouseSpaceCap;
        }
        if (o.intHouseSpacePrice != null) {
            intHouseSpacePrice = o.intHouseSpacePrice;
        }

        if (o.intCopperToSilver != null) {
            intCopperToSilver = o.intCopperToSilver;
        }
        if (o.intSilverToGold != null) {
            intSilverToGold = o.intSilverToGold;
        }
		
		if (o.intMaxReputationRank != null) {
            intMaxReputationRank = o.intMaxReputationRank;
        }
    }

    public function getCatDefinition(cat:String):String
    {
        switch (cat)
        {
            case "M1":
                return ("Tank Melee");
            case "M2":
                return ("Dodge Melee");
            case "M3":
                return ("Full Hybrid");
            case "M4":
                return ("Power Melee");
            case "C1":
                return ("Offensive Caster");
            case "C2":
                return ("Defensive Caster");
            case "C3":
                return ("Power Caster");
            case "S1":
                return ("Luck Hybrid");
            default:
                return ("Adventurer");
        };
    }

}

}