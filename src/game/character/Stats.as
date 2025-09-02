package game.character {

import UI.ToolTipMC;

import fl.motion.Color;

import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;

import popup.Stats.StatsListItem;
import popup.Stats.StatsSubItem;

public class Stats extends MovieClip {

    private var game:Game = Game.root;
    private var uoTree:Object = game.copyObj(game.world.uoTree[game.net.myUserName.toLowerCase()]);

    public var tName:TextField;
    public var tCat:TextField;
    public var tCore:TextField;
    public var tItemEffects:TextField;
    public var tCombat2:TextField;
    public var tCombat1:TextField;
    public var tMod:TextField;
    public var tStats:TextField;
    public var tPoints:TextField;

    public var btnClose:SimpleButton;
    public var btnSave:SimpleButton;
    public var btnUndo:SimpleButton;

    public var skills:MovieClip;
	
    public var _STR:MovieClip;
    public var _INT:MovieClip;
    public var _DEX:MovieClip;
    public var _END:MovieClip;
    public var _WIS:MovieClip;
    public var _LCK:MovieClip;

    private var tStatVals:Array = ["STR", "INT", "DEX", "END", "WIS", "LCK"];
    private var tStatFormats:Array = [];
    private var tFormats:Array = [];
    private var tValues:Array = ["$cai", "$cao", "$cpi", "$cpo", "$cmi", "$cmo", "$chi", "$cho", "$cdi", "$cdo", "$cmc"];
    private var tCombatFormats1:Array = [];
    private var tCombatFormats2:Array = [];
    private var tItemEffectsFormats:Array = [];
    private var tCombat1Vals:Array = ["$ap", "$sp", "$thi", "$tha"];
    private var tCombat2Vals:Array = ["$tcr", "$scm", "$tdo"];
    private var tItemEffectsVals:Array = ["$idb", "$ieb", "$icb", "$isb", "$igb", "$icpb", "$irb"];

    private var allocated:Object;
    private var uoLeaf:Object;
    private var uoData:Object;
    private var stp:Object;
    private var stg:Object;

    private var lists:MovieClip = new MovieClip();
    private var selectedItem:StatsListItem;

    private var data:Array = [
        {
            header: "Strength",
            sub: [
                {
                    name: "Attack Power",
                    stat: "$ap"
                },
                {
                    name: "Critical Chance",
                    stat: "$tcr"
                }
            ]
        },
        {
            header: "Intellect",
            sub: [
                {
                    name: "Magic Resistance",
                    stat: "$cmi"
                },
                {
                    name: "Magic Boosts",
                    stat: "$cmo"
                },
                {
                    name: "Spell Power",
                    stat: "$tcr"
                },
                {
                    name: "Haste",
                    stat: "$tha"
                }
            ]
        },
        {
            header: "Dexterity",
            sub: [
                {
                    name: "Accuracy",
                    stat: "$thi"
                },
                {
                    name: "Haste",
                    stat: "$tha"
                },
                {
                    name: "Critical Chance",
                    stat: "$tcr"
                },
                {
                    name: "Evasion",
                    stat: "$do"
                }
            ]
        },
        {
            header: "Endurance",
            sub: [
                {
                    name: "Increase Max Health",
                    stat: "none"
                }
            ]
        },
        {
            header: "Wisdom",
            sub: [
                {
                    name: "Critical Chance",
                    stat: "$tcr"
                },
                {
                    name: "Accuracy",
                    stat: "$thi"
                },
                {
                    name: "Evasion",
                    stat: "$tcr"
                }
            ]
        },
        {
            header: "Lucky",
            sub: [
                {
                    name: "Attack power",
                    stat: "$ap"
                },
                {
                    name: "Spell Power",
                    stat: "$sp"
                },
                {
                    name: "Critical Chance",
                    stat: "$tcr"
                },
                {
                    name: "Accuracy",
                    stat: "$thi"
                },
                {
                    name: "Haste",
                    stat: "$tha"
                },
                {
                    name: "Evasion",
                    stat: "$tdo"
                },
                {
                    name: "Critical Multiplier",
                    stat: "$scm"
                }
            ]
        }
    ];

    public function Stats()
    {
        uoLeaf = game.world.myLeaf();
        uoData = game.world.myAvatar.objData;
        stp = {};
        stg = {};
        addEventListener(Event.ADDED_TO_STAGE, onStage, false, 0, true);
        btnClose.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        btnSave.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        btnUndo.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        tName.mouseEnabled = false;

        lists = new MovieClip();
        lists.x = 19.35;
        lists.y = 117.9;
        addChild(lists);

        skills = new MovieClip();
        skills.x = 555;
        skills.y = 95;
        addChild(skills);

//        initSkills();
    }

    public function cleanup():void
    {
        if (parent != null)
        {
            parent.removeChild(this);
            game.stage.focus = null;
        }
    }

    public function onStage(e:Event):void
    {
        trace("Started Stats Panel");
        initLists();
        updateBase();
        update();
        this.removeEventListener(Event.ADDED_TO_STAGE, onStage);
    }

//    private function getStatValue(classCategory:String, stat:String) : Number {
//        if (classCategory.length < 1 || stat.length < 1) return;
//
//        if (classCategory == "S1" && )
//        {
//
//        }
//
//        return 0;
//    }

    private function initLists() : void {
        game.onRemoveChildren(lists);

        var yOffSet:int = 0;
        var category:String = game.world.myAvatar.objData.sClassCat;
        var hpTgt:int = game.statsController.getBaseHPByLevel(int(uoTree.intLevel));
        var tDps:Number = (hpTgt / 20.0) * 0.7;
        var sp1Pc:Number = (2.25 * tDps) / (100 / game.statsController.intAPtoDPS) / 2;

        for each (var sta:Object in data)
        {
            var item:StatsListItem = new StatsListItem();
            item.tName.text = sta.header;
            item.iValue = 0;
            item.name = "_" + game.statsController.statMap[sta.header];
            item.y = yOffSet;

            if (sta.header == "Strength")
            {
                item.isHide = false;
                item.subLists.visible = true;
                item.select.visible = true;
                item.select.alpha = 1;
                selectedItem = item;
            }
            else
            {
                item.isHide = true;
            }

            for (var i:int = 0; i < sta.sub.length; i++)
            {
                var subItem:StatsSubItem = new StatsSubItem();
                subItem.tStatName.text = sta.sub[i].name;
                subItem.stat = sta.sub[i].stat;

                if (sta.header == "Strength")
                {
                    if (subItem.stat == "$ap")
                    {
                        subItem.tValue.text = "+" + Math.round((category == "S1" ? Math.round(int(uoTree.sta.$STR) * 1.4) : int(uoTree.sta.$STR) * 2) / 100) + "%";
                    }
                    else if (["M1", "M2", "M3", "M4", "S1"].indexOf(category) > -1 && subItem.stat == "$tcr")
                    {
                        subItem.tValue.text = "+" + ((uoTree.sta.$STR / sp1Pc / 100) * (category == "M4" ? 0.7 : 0.4)) + "%";
                    }
                    else
                    {
                        continue; // SKIP THIS SHIT!
                    }
                }
                else
                {
                    subItem.tValue.text = "0";
                }

                subItem.x = 15.4;
                subItem.y = (i * subItem.height) + 3;
                item.subLists.addChild(subItem);
            }

            yOffSet += (item.isHide ? item.height - item.subLists.height : item.height) + 10;

            item.buttonMode = true;
            item.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
            item.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
            item.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);

            item.bIncrease.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
            item.bIncrease.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
            item.bIncrease.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);

            item.bDecrease.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
            item.bDecrease.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
            item.bDecrease.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);

            lists.addChild(item);
        }
    }

    private function buildStu():void
    {
        var slot:String;
        var gearStat:String;
        var innate:Object = game.statsController.getCategoryStats(uoData.sClassCat, uoLeaf.intLevel);
        var s:String = "";
        var i:int;
        i = 0;

        while (i < game.statsController.stats.length)
        {
            s = game.statsController.stats[i];
            stg[("^" + s)] = 0;
            stp[("_" + s)] = uoTree.sta["$" + s];// Math.floor(innate[s]);
            i++;
        }

/*
        for (slot in uoTree.tempSta)
        {
            if (slot != "innate")
            {
                for (gearStat in uoTree.tempSta[slot])
                {
                    if (stg[("^" + gearStat)] == null)
                    {
                        stg[("^" + gearStat)] = 0;
                    }
                    stg[("^" + gearStat)] = (stg[("^" + gearStat)] + int(uoTree.tempSta[slot][gearStat]));
                }
            }
        } */
    }

    private function determineColor(typ:String, val:Number):*
    {
        if (!allocated[typ])
        {
            allocated[typ] = val;
            return (0xCCCCCC);
        }
        var diff:Number = (game.statFixValues(typ, val)[0] - 1);
        var cmp:Number = (game.statFixValues(typ, allocated[typ])[0] - 1);
        if (typ == "$cmc")
        {
            diff = (diff * -1);
            cmp = (cmp * -1);
        }
        if (diff < cmp)
        {
            return (0x666666);
        }
        if (diff > cmp)
        {
            return (0xCC9900);
        }
        return (0xCCCCCC);
    }

    private function determineStatColor(typ:String, val:Number):*
    {
        var diff:Number = (stp[("_" + typ)] + stg[("^" + typ)]);
        var cmp:Number = val;
        if (diff > cmp)
        {
            return (0x666666);
        }
        if (diff < cmp)
        {
            return (0xCC9900);
        }
        return (0xCCCCCC);
    }

    private function allocateBaseValues():void
    {
        var mStat:*;
        var stu:*;
        trace("ALLOCATING NEW BASE VALUES", "\t", (!(game.baseClassStats)));
        trace("uoData > " + JSON.stringify(uoData));
        if (!allocated)
        {
            allocated = {};
        }
        if (game.baseClassStats)
        {
            for (stu in game.baseClassStats)
            {
                allocated[stu] = game.baseClassStats[stu];
            }
            allocated["intHPMax"] = getMaxHealth();
            game.baseClassStats = null;
            return;
        }
        trace("Not a class base");

        for each (mStat in tValues)
        {
            allocated[mStat] = uoTree.sta[mStat];
        }
        for each (mStat in tCombat1Vals)
        {
            allocated[mStat] = uoTree.sta[mStat];
        }
        for each (mStat in tCombat2Vals)
        {
            allocated[mStat] = uoTree.sta[mStat];
        }
		for each (mStat in tItemEffectsVals)
        {
            allocated[mStat] = uoTree.sta[mStat];
        }
        allocated["intHPMax"] = getMaxHealth();
    }

    public function updateBase():void
    {
        tName.text = uoData.strClassName;
        tCat.text = game.statsController.getCatDefinition(uoData.sClassCat);
        allocateBaseValues();
    }

    public function getMaxHealth() : int {
        return game.statsController.getBaseHPByLevel(uoLeaf.intLevel) + uoTree.sta.$END * game.statsController.intHPperEND;
    }

    public function update():void
    {
        var len:int;
        var mStat:*;
        var prop:*;
        var haste_val:Array;
        var val:*;
        var _format:TextFormat;

        buildStu();

        var vals:Object = uoTree.sta;
        var lRng:int = Math.floor((100 - game.world.myAvatar.getEquippedItemBySlot("Weapon").iRng));
        var uRng:int = (100 + game.world.myAvatar.getEquippedItemBySlot("Weapon").iRng);
        var patterns:Object = getEnhances();
		var statTotals:Object = {"DEX": 0,"STR": 0, "LCK": 0,"INT": 0, "WIS": 0, "END": 0  };
		
		tPoints.text  = int(vals.$pts);
        tCore.text = ((((((((((((((((lRng + "% - ") + uRng) + "%\n") + patterns["Weapon"][0]) + patterns["Weapon"][1]) + ((patterns["Weapon"][2] != "") ? (", " + patterns["Weapon"][2]) : "")) + "\n") + patterns["ar"][0]) + patterns["ar"][1]) + "\n") + patterns["ba"][0]) + patterns["ba"][1]) + "\n") + patterns["he"][0]) + patterns["he"][1]) + "\n");

        var ctr:int = 0;
        tStats.text = "";

        for (var key:String in game.statsController.ratiosBySlot) {
            if (!uoTree.tempSta.hasOwnProperty(key)) continue;

            var slotStats:Object = uoTree.tempSta[key];

            for (var stat:String in slotStats) {
                if (statTotals.hasOwnProperty(stat)) {
                    statTotals[stat] += slotStats[stat];
                }
            }
        }

        for each (var cStat0:String in tStatVals) {
            var eqpStat:int = statTotals[cStat0];

            if (lists.numChildren > 0)
            {
                var item:StatsListItem = lists.getChildByName("_" + cStat0) as StatsListItem;
                item.oValue = int (stp["_" + cStat0] + stg["^" + cStat0]);
                item.tValue.text = item.oValue;
            }


            tStats.text += stp["_" + cStat0] + stg["^" + cStat0] + " (" + eqpStat + ")\n";
            tStatFormats[ctr] = [
                tStats.text.lastIndexOf("(") + 1,
                tStats.text.lastIndexOf(")"),
                determineStatColor(cStat0, vals["$" + cStat0])
            ];
            ctr++;
        }

        tCombat1.text = "";
        ctr = 0;
        for each (var cStat1:String in tCombat1Vals)
        {
            var finalStr:String = "";

            if (cStat1 == "$ap" || cStat1 == "$sp")
            {
                finalStr = String(vals[cStat1]);
            }
            if (cStat1 == "$thi")
            {
                finalStr = (game.coeffToPct(Number(((1 - game.statsController.baseMiss) + vals["$thi"]))) + "%");
            }
            if (cStat1 == "$tha")
            {
                haste_val = game.statFixValues("$tha", vals["$tha"]);
                finalStr = ((((haste_val.length == 2) ? haste_val[1] : "") + haste_val[0]) + "%");
            }
            len = tCombat1.length;
            tCombat1.text = (tCombat1.text + (finalStr + "\n"));
            tCombatFormats1[ctr] = [len, tCombat1.length, determineColor(cStat1, vals[cStat1])];
            ctr++;
        }
        tCombat2.text = "";
        ctr = 0;
        for each (var cStat2:String in tCombat2Vals)
        {
			trace(vals[cStat2] + " = " +  Math.ceil(vals[cStat2]) + " = " + game.coeffToPct(vals[cStat2]));
            len = tCombat2.length;
            tCombat2.text = (tCombat2.text + (game.coeffToPct(vals[cStat2]) + "%\n"));
            tCombatFormats2[ctr] = [len, tCombat2.length, determineColor(cStat2, vals[cStat2])];
            ctr++;
        }
        len = tCombat2.length;
        trace("END => " + vals.$END);
        tCombat2.text = (tCombat2.text + getMaxHealth());
        tCombatFormats2[ctr] = [len, tCombat2.length, determineColor("intHPMax", getMaxHealth())];

		tItemEffects.text = "";
		ctr = 0;

		for each (var cStat3:String in tItemEffectsVals)
        {
            len = tItemEffects.length;
            tItemEffects.text = (tItemEffects.text + (game.coeffToPct(vals[cStat3]) + "%\n"));
            tItemEffectsFormats[ctr] = [len, tItemEffects.length, determineColor(cStat3, vals[cStat3])];
            ctr++;
        }

        tMod.text = "";
        ctr = 0;
        for each (mStat in tValues)
        {
            val = game.statFixValues(mStat, vals[mStat]);
            len = tMod.length;
            tMod.text = (tMod.text + (((val.length == 2) ? (val[1] + val[0]) : val[0]) + "%\n"));
            tFormats[ctr] = [len, tMod.length, determineColor(mStat, vals[mStat])];
            ctr++;
        }

        for each (prop in tStatFormats)
        {
            _format = tStats.getTextFormat(prop[0], prop[1]);
            _format.color = prop[2];
            tStats.setTextFormat(_format, prop[0], prop[1]);
        }
        for each (prop in tFormats)
        {
            _format = tMod.getTextFormat(prop[0], prop[1]);
            _format.color = prop[2];
            tMod.setTextFormat(_format, prop[0], prop[1]);
        }
        for each (prop in tCombatFormats1)
        {
            _format = tCombat1.getTextFormat(prop[0], prop[1]);
            _format.color = prop[2];
            tCombat1.setTextFormat(_format, prop[0], prop[1]);
        }
        for each (prop in tCombatFormats2)
        {
            _format = tCombat2.getTextFormat(prop[0], prop[1]);
            _format.color = prop[2];
            tCombat2.setTextFormat(_format, prop[0], prop[1]);
        }
    }

    private function getProc(wep:Object):String
    {
        var procID:String = "";
        if (wep.ProcID)
        {
            switch (wep.ProcID)
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
                    procID = "None";
            }
        }
        return (procID);
    }

    private function initSkills() : void {
        var refs:Array = ["aa", "a1", "a2", "a3", "a4", "p1", "p2", "p3"];

        for each (var ref:String in refs) {
            var item:mcSkillListItem = new mcSkillListItem();

            var skill:Object = game.world.getActionByRef(ref);

            if (skill == null) continue;

            skill.sArg1 = "";
            skill.sArg2 = "";

            switch (skill.typ) {
                case "p":
                case "ph":
                case "aa":
                    item.tSub.text = "Physical";
                    break;
                case "m":
                    item.tSub.text = "Magical";
                    break;
                case "ma":
                    item.tSub.text = "True Damage";
                    break;
                case "mp":
                case "pm":
                    item.tSub.text = "Hybried";
                    break;
                case "passive":
                    item.tSub.htmlText = "<font color='#0033AA'>Passive Ability</font>";
                    break;
            }

            item.tName.text = skill.nam;
            item.actIcon.width = 42;
            item.actIcon.height = 39;
            item.icon2 = null;
            item.actObj = skill;
            game.updateIcons([item.actIcon], skill.icon.split(","), null);
            item.y = (item.height + 10) * skills.numChildren;

            item.addEventListener(MouseEvent.MOUSE_OVER, game.actIconOver, false, 0, true);
            item.addEventListener(MouseEvent.MOUSE_OUT, game.actIconOut, false, 0, true);

            skills.addChild(item);
        }
    }

    private function getEnh(typ:String):Array
    {
        var enh:*;
        var template:Array = ["None", ""];
        var item:Object = game.world.myAvatar.getEquippedItemBySlot(typ);
        if (typ == "Weapon")
        {
            template.push(getProc(item));
        }
        if (!item)
        {
            return (template);
        }
        if (item.PatternID != null)
        {
            enh = game.world.enhPatternTree[item.PatternID];
        }
        if (item.EnhPatternID != null)
        {
            enh = game.world.enhPatternTree[item.EnhPatternID];
        }
        if (!enh)
        {
            return (template);
        }
        template[0] = enh.sName;
        template[1] = ((item.EnhRty > 1) ? (" +" + String((item.EnhRty - 1))) : "");
        return (template);
    }

    private function getEnhances():Object
    {
        var enhance:*;
        var enhances:Object = {
            "Weapon":[],
            "ar":[],
            "ba":[],
            "he":[]
        };
        game.world.initPatternTree();
        for (enhance in enhances)
        {
            enhances[enhance] = getEnh(enhance);
        }
        return (enhances);
    }

//    private function isChange() : Boolean
//    {
//        return Strength.iValue == 0 && Intellect.iValue == 0 && Dexterity.iValue == 0 && Endurance.iValue == 0 && Wisdom.iValue == 0 && Luck.iValue == 0 && Charisma.iValue == 0 && Resilience.iValue == 0 && Aura.iValue == 0;
//    }

    private function onMouseOver(event:MouseEvent) : void {
        event.stopImmediatePropagation();

        switch (event.currentTarget.name) {
            case "bIncrease":
            case "bDecrease":
                var color:Color = new Color();
                color.brightness = 0.3;
                SimpleButton(event.currentTarget).transform.colorTransform = color;
                break;
            default:
                if (selectedItem != null && event.currentTarget.name == selectedItem.name) return;

                MovieClip(event.currentTarget).select.visible = true;
                MovieClip(event.currentTarget).select.alpha = 0.5;
                break;
        }
    }

    private function onMouseOut(event:MouseEvent) : void {
        event.stopImmediatePropagation();

        switch (event.currentTarget.name) {
            case "bIncrease":
            case "bDecrease":
                var color:Color = new Color();
                color.brightness = 0;
                SimpleButton(event.currentTarget).transform.colorTransform = color;
                break;
            default:
                if (selectedItem != null && event.currentTarget.name == selectedItem.name) return;

                MovieClip(event.currentTarget).select.visible = false;
                MovieClip(event.currentTarget).select.alpha = 0;
                break;
        }
    }

    private function onClick(event:MouseEvent) : void {
        event.stopImmediatePropagation();

        game.mixer.playSound("Click");

        var points:int = int(tPoints.text);
        var parent:StatsListItem;
        var statName:String;
        var child:StatsListItem;
        var i:int = 0;

        switch (event.currentTarget.name)
        {
            case "bIncrease":
                if (points < 1)
                {
                    game.Modal("You don't have points!", null, {}, "red,medium", "mono");
                    return;
                }

                points -= 1;

                parent = event.currentTarget.parent as StatsListItem;

                parent.iValue += 1;
                parent.tValue.text = int(parent.oValue) + parent.iValue;
                parent.tValue.textColor = parent.iValue > 0 ? 0x66FF00 : 0xCCCCCC;

                statName = "$" + parent.name.substring(1);

                uoTree.sta[statName] = int(uoTree.sta[statName]) + 1;
                game.statsController.applyCoreStatRatings(uoTree.sta, int(uoTree.intLevel));
                update();

                tPoints.htmlText = points;
                break;
            case "bDecrease":
                parent = event.currentTarget.parent as StatsListItem;

                if (parent.iValue < 1) return;

                points += 1;

                parent.iValue -= 1;
                parent.tValue.text = int(parent.oValue) + parent.iValue;
                parent.tValue.textColor = parent.iValue > 0 ? 0x66FF00 : 0xCCCCCC;

                statName = "$" + parent.name.substring(1);

                uoTree.sta[statName] = int(uoTree.sta[statName]) - 1;
                game.statsController.applyCoreStatRatings(uoTree.sta, int(uoTree.intLevel));
                update();

                tPoints.htmlText = points;
                break;
            case "btnClose":
                cleanup();
                break;
            case "btnSave":
                var dataChanges:Object = {};
                var hasAnyValue:Boolean = false;

                for (i = 0; i < lists.numChildren; i++)
                {
                    child = lists.getChildAt(i) as StatsListItem;

                    if (child == null || child.iValue < 1) continue;

                    dataChanges[String(child.name).substring(1)] = child.iValue;

                    hasAnyValue = true;
                }

                if (!hasAnyValue)
                {
                    game.Modal("No stat changes", null, {}, "red,medium", "mono");
                    return;
                }

                trace(JSON.stringify(dataChanges));

				uoTree.sta.$pts = int(points);
                game.world.uoTree[game.net.myUserName.toLowerCase()] = uoTree;
                game.net.send("statsUpdate", [JSON.stringify(dataChanges)]);
                break;
            case "btnUndo":
                uoTree = game.copyObj(game.world.uoTree[game.net.myUserName.toLowerCase()]);
                update();

                for (i = 0; i < lists.numChildren; i++)
                {
                    child = lists.getChildAt(i) as StatsListItem;

                    if (child == null) continue;

                    child.tValue.textColor = 0xCCCCCC;
                }
                break;
            default:
                var clickedItem:StatsListItem = event.currentTarget as StatsListItem;

                if (selectedItem == clickedItem) {
                    clickedItem.isHide = true;
                    clickedItem.subLists.visible = false;
                    clickedItem.select.visible = false;
                    clickedItem.select.alpha = 0;
                    selectedItem = null;
                } else {
                    if (selectedItem != null) {
                        selectedItem.isHide = true;
                        selectedItem.subLists.visible = false;
                        selectedItem.select.visible = false;
                        selectedItem.select.alpha = 0;
                    }

                    clickedItem.isHide = false;
                    clickedItem.subLists.visible = true;
                    clickedItem.select.visible = true;
                    clickedItem.select.alpha = 1;
                    selectedItem = clickedItem;
                }

                var yOffSet:int = 0;

                for (i = 0; i < lists.numChildren; i++)
                {
                    child = lists.getChildAt(i) as StatsListItem;

                    if (child == null) continue;

                    child.y = yOffSet;
                    yOffSet += (child.isHide ? child.height - child.subLists.height : child.height) + 10;
                }
                break;
        }
    }

}

}
