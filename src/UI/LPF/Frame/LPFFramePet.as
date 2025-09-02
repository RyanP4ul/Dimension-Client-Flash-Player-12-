package UI.LPF.Frame {
import flash.display.MovieClip;
import flash.events.MouseEvent;
import flash.text.TextField;

public class LPFFramePet extends LPFFrame  {

    private var game:Game = Game.root;
    private var tStatVals:Array = ["$STR", "$INT", "$DEX", "$END", "$WIS", "$LCK"];
    private var tCombat1Vals:Array = ["$ap", "$sp", "$thi", "$tha"];
    private var tCombat2Vals:Array = ["$tcr", "$scm", "$fc", "$fmr", "$tdo"];
    private var tValues:Array = ["$cai", "$cao", "$cpi", "$cpo", "$cmi", "$cmo", "$chi", "$cho", "$cdi", "$cdo", "$cmc"];

    public var mcXPBar:MovieClip;

    public var tStats:TextField;
    public var tCombat1:TextField;
    public var tCombat2:TextField;
    public var tMod:TextField;

    override public function fOpen(o:Object):void
    {
        positionBy(o.r);

        if (("fData" in o)) fData = o.fData;
        if (("eventTypes" in o)) eventTypes = o.eventTypes;

        fDraw();
        getLayout().registerForEvents(this, eventTypes);
    }

    override public function fClose():void
    {
        getLayout().unregisterFrame(this);

        if (parent != null)
        {
            parent.removeChild(this);

            mcXPBar.removeEventListener(MouseEvent.MOUSE_OVER, xpBarMouseOver);
            mcXPBar.removeEventListener(MouseEvent.MOUSE_OUT, xpBarMouseOut);
        }
    }

    protected function fDraw():void
    {
        if (game.world.myAvatar.objData.pet == null) return;

        initStats();
        initExp();
    }

    override public function notify(o:Object):void
    {
        if ("fData" in o)
        {
            fData = o.fData;
        }
        if ("r" in o)
        {
            positionBy(o.r);
        }
        if ("updatePetExp" in o)
        {
            updateXPBar();
        }
        fDraw();
    }

    private function initStats() : void
    {
        var s:String = "";
        var fs:String = "";
        var arr:Array = [];
        var sta:Object = game.world.myAvatar.objData.pet.sta;

        if (sta == null) return;

        tStats.text = "";
        for each (s in tStatVals) tStats.appendText(sta[s] + "\n");

        tCombat1.text = "";
        for each (s in tCombat1Vals)
        {
            if (s == "$ap" || s == "$sp")
                fs = String(sta[s]);

            if (s == "$thi")
                fs = game.coeffToPct(Number(1 - game.statsController.baseMiss) + sta[s]) + "%";

            if (s == "$tha")
            {
                arr = game.statFixValues(s, sta[s]);
                fs = (arr.length == 2 ? arr[1] : "") + arr[0] + "%";
            }

            tCombat1.appendText(fs + "\n");
        }

        tCombat2.text = "";
        for each (s in tCombat2Vals) tCombat2.appendText(game.coeffToPct(sta[s]) + "%\n");
        tCombat2.appendText(game.world.myAvatar.objData.pet.data.intHPMax)

        tMod.text = "";
        for each (s in tValues)
        {
            arr = game.statFixValues(s, sta[s]);
            tMod.appendText((arr.length == 2 ? arr[1] + arr[0] : arr[0]) + "%\n");
        }
    }

    private function initExp() : void
    {
        mcXPBar.mcXP.scaleX = 0;
        mcXPBar.strXP.visible = false;
        mcXPBar.addEventListener(MouseEvent.MOUSE_OVER, xpBarMouseOver);
        mcXPBar.addEventListener(MouseEvent.MOUSE_OUT, xpBarMouseOut);
        updateXPBar();
    }

    private function updateXPBar() : void
    {
        var data:Object = game.world.myAvatar.objData.pet.data;

        trace("PET DATA => " + JSON.stringify(data));

        var xp:int = data.XP;
        var xpToLevel:int = data.XPToLevel;
        var percent:int = xp / xpToLevel * 100;

        if (percent >= 100) percent = 100;

        mcXPBar.mcXP.scaleX = (xp / xpToLevel);
        mcXPBar.strXP.text = "Level " + data.Level + " : " + xp + " / " + xpToLevel + " (" + percent + ")%";
    }

    private function xpBarMouseOver(event:MouseEvent) : void
    {
        MovieClip(event.currentTarget).strXP.visible = true;
    }

    private function xpBarMouseOut(event:MouseEvent) : void
    {
        MovieClip(event.currentTarget).strXP.visible = false;
    }

}

}
