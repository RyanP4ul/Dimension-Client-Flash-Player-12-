package game.character {
import UI.ToolTipMC;

import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.MouseEvent;
import flash.text.TextField;

public class StatsPanel extends MovieClip {

    private var game:Game = Game.root;
    private var o:Object;
    private var toolTipMC:ToolTipMC = game.ui.ToolTip;

    public var tPoints:TextField;

    public var Strength:MovieClip;
    public var Intellect:MovieClip;
    public var Dexterity:MovieClip;
    public var Endurance:MovieClip;
    public var Wisdom:MovieClip;
    public var Luck:MovieClip;
    public var Charisma:MovieClip;
    public var Resilience:MovieClip;
    public var Aura:MovieClip;

    public var bClose:SimpleButton;
    public var bSave:SimpleButton;
    public var bUndo:SimpleButton;

    public function StatsPanel()
    {
        o = game.world.uoTree[game.net.myUserName.toLowerCase()];

        tPoints.text = o.sta.$pts;

        trace("UO TREE => " + JSON.stringify(game.world.uoTree[game.net.myUserName.toLowerCase()]));
        trace("UO DATA => " + JSON.stringify(game.world.myAvatar.objData));

        SetFields("Strength", o.tempSta.ba.STR + o.tempSta.ar.STR + o.tempSta.Weapon.STR + o.tempSta.he.STR + o.tempSta.innate.STR + o.sta.$STR, "Strength grants Attack Power to all classes, and additionally extra Critical Chance to melee classes.");
        SetFields("Intellect", o.tempSta.ba.INT + o.tempSta.ar.INT + o.tempSta.Weapon.INT + o.tempSta.he.INT + o.tempSta.innate.INT + o.sta.$INT, "Intellect provides Spell Power and Magical Resistance to all classes, and additionally extra Damage and Cooldown Reduction for caster classes.");
        SetFields("Dexterity", o.tempSta.ba.DEX + o.tempSta.ar.DEX + o.tempSta.Weapon.DEX + o.tempSta.he.DEX + o.tempSta.innate.DEX + o.sta.$DEX, "Dexterity grants extra Hit Chance and Dodge Chance to melee classes.");
        SetFields("Endurance", o.tempSta.ba.END + o.tempSta.ar.END + o.tempSta.Weapon.END + o.tempSta.he.END + o.tempSta.innate.END + o.sta.$END, "Endurance increases the Max Health of all classes.");
        SetFields("Wisdom", o.tempSta.ba.WIS + o.tempSta.ar.WIS + o.tempSta.Weapon.WIS + o.tempSta.he.WIS + o.tempSta.innate.WIS + o.sta.$WIS, "Wisdom provides Dodge Chance to all classes, and additionally extra Hit Chance and Critical Chance to caster classes. ");
        SetFields("Luck", o.tempSta.ba.LCK + o.tempSta.ar.LCK + o.tempSta.Weapon.LCK + o.tempSta.he.LCK + o.tempSta.innate.LCK + o.sta.$LCK, "Luck increases Critical Chance and Critical Damage, and additionally provides small improvements to all classes’ favored stats. ");
//        SetFields("Charisma", o.sta.$CHA, "Charisma reduces prices at shops, increase drop rate and increase the reward.");
//        SetFields("Resilience", o.sta.$RES, "Resilience reduces critical hit from all sources and increases resistance debuffs, and reduces damage from environmental hazards like fire, cold, and poison.");
//        SetFields("Aura", o.sta.$AUR, "Aura boosts buffs for allies and reduces debuffs on enemies.");

        bSave.visible = false;
        bUndo.visible = false;

        bClose.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        bSave.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        bUndo.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
    }

    private function SetFields(name:String, value:String, desc:String) : void
    {
        this[name].tName.text = name;
        this[name].tValue.text = value;
        this[name].iValue = 0;
        this[name].oValue = value;
        this[name].sDesc = desc;
        this[name].bIncrease.addEventListener(MouseEvent.CLICK, onStatChangeClick, false, 0, true);
        this[name].bDecrease.addEventListener(MouseEvent.CLICK, onStatChangeClick, false, 0, true);
        this[name].removeEventListener(MouseEvent.MOUSE_OVER, onOver);
        this[name].removeEventListener(MouseEvent.MOUSE_OUT, onOut);
        this[name].addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 0, true);
        this[name].addEventListener(MouseEvent.MOUSE_OUT, onOut, false, 0, true);
    }

    private function isChange() : Boolean
    {
        return Strength.iValue == 0 && Intellect.iValue == 0 && Dexterity.iValue == 0 && Endurance.iValue == 0 && Wisdom.iValue == 0 && Luck.iValue == 0 && Charisma.iValue == 0 && Resilience.iValue == 0 && Aura.iValue == 0;
    }

    private function onStatChangeClick(event:MouseEvent) : void
    {
        game.mixer.playSound("Click");

        var points:int = int(tPoints.text);
        var parentName:String = event.currentTarget.parent.name;

        switch (event.currentTarget.name)
        {
            case "bIncrease":
                if (points < 1)
                {
                    game.Modal("You don't have points!", null, {}, "red,medium", "mono");
                    return;
                }

                points -= 1;

                this[parentName].iValue += 1;
                this[parentName].tValue.text = int(this[parentName].oValue) + this[parentName].iValue;
                break;
            case "bDecrease":
                if (this[parentName].iValue < 1) return;

                points += 1;

                this[parentName].iValue -= 1;
                this[parentName].tValue.text = int(this[parentName].oValue) + this[parentName].iValue;
                break;
        }

        if (isChange())
        {
            bSave.visible = false;
            bUndo.visible = false;
        }
        else
        {
            bSave.visible = true;
            bUndo.visible = true;
        }

        tPoints.htmlText = points;
    }

    private function onClick(event:MouseEvent) : void
    {
        game.mixer.playSound("Click");

        switch (event.currentTarget.name)
        {
            case "bClose":
                MovieClip(parent).onClose();
                break;
            case "bSave":
                game.Modal("Success update stats!", null, {}, "green,medium", "mono");
                game.net.send("stats", [Strength.iValue, Intellect.iValue, Dexterity.iValue, Endurance.iValue, Wisdom.iValue, Luck.iValue, Charisma.iValue, Resilience.iValue, Aura.iValue]);
                bSave.visible = false;
                bUndo.visible = false;
                break;
            case "bUndo":
                tPoints.text = o.sta.$pts;
                Strength.tValue.text = o.tempSta.innate.STR + o.sta.$STR;
                Intellect.tValue.text = o.tempSta.innate.INT + o.sta.$INT;
                Dexterity.tValue.text = o.tempSta.innate.DEX + o.sta.$DEX;
                Endurance.tValue.text = o.tempSta.innate.END + o.sta.$END;
                Wisdom.tValue.text = o.tempSta.innate.WIS + o.sta.$WIS;
                Luck.tValue.text = o.tempSta.innate.LCK + o.sta.$LCK;
                Charisma.tValue.text = o.sta.$CHA;
                Resilience.tValue.text = o.sta.$RES;
                Aura.tValue.text = o.sta.$AUR;

                Strength.iValue = 0;
                Intellect.iValue = 0;
                Dexterity.iValue = 0;
                Endurance.iValue = 0;
                Wisdom.iValue = 0;
                Luck.iValue = 0;
                Charisma.iValue = 0;
                Resilience.iValue = 0;
                Aura.iValue = 0;

                bSave.visible = false;
                bUndo.visible = false;
                break;
        }
    }

    private function onOver(event:MouseEvent) : void
    {
        try
        {
            toolTipMC.openWith({ "str" : MovieClip(event.currentTarget).sDesc });
        }
        catch(e:Error)
        {
        }
    }

    private function onOut(event:MouseEvent) : void
    {
        try
        {
            toolTipMC.close();
        }
        catch(e:Error)
        {
        }
    }

}

}
