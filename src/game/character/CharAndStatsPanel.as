package game.character {

import flash.display.MovieClip;
import flash.text.TextField;

public class CharAndStatsPanel extends MovieClip {

    private var game:Game = Game.root;

    private var data:Object = {
        stats : ["STR", "INT", "DEX", "END", "WIS", "LCK", "CHA", "RES", "AUR"],
        combat1 : ["$ap", "$sp", "$thi", "$tha"],
        combat2 : ["$tcr", "$scm", "$fc", "$fmr", "$tdo"],
        mod : ["$cai", "$cao", "$cpi", "$cpo", "$cmi", "$cmo", "$chi", "$cho", "$cdi", "$cdo", "$cmc"],
        itemEffect : ["$idb", "$ieb", "$icb", "$isb", "$igb", "$icpb", "$irb"]
    }

    private var uoTree:Object;
    private var uoData:Object;

    public var tStats:TextField;
    public var tCombat1:TextField;
    public var tCombat2:TextField;
    public var tMod:TextField;
    public var tItemEffect:TextField;

    public function CharAndStatsPanel() {
//        uoTree = game.world.uoTree[game.net.myUserName.toLowerCase()];
//        uoData = game.world.myAvatar.objData;

        uoTree = {"intMPMax":205,"intLevel":102,"intHP":1792,"strUsername":"leght","uoName":"leght","passives":[],"intMP":205,"targets":{},"showCloak":true,"showHelm":true,"ty":0,"entType":"p","strPad":"Spawn","intSPMax":100,"intState":1,"afk":false,"entID":4,"tempSta":{"he":{"STR":1,"INT":1,"WIS":1,"END":1,"DEX":1},"ar":{"STR":1,"INT":1,"WIS":1,"END":1,"DEX":1},"Weapon":{"STR":1,"INT":1,"WIS":1,"END":1,"DEX":1},"ba":{"STR":1,"INT":1,"WIS":1,"END":1,"DEX":1},"innate":{"INT":8,"WIS":17,"DEX":55,"STR":33,"LCK":17,"END":37}},"intSP":100,"wDPS":17,"mDPS":10,"sta":{"$cho":1,"$ap":96,"$chi":1,"$edb":0,"$isb":0,"$cmc":1,"$CHA":0.1,"$tcr":0.10510374575895522,"$RES":0,"$cmi":0.959081376911667,"$WIS":4,"$AUR":0.014000000000000002,"$igb":0.5,"$sp":30,"$tha":0.11321356111366856,"$cmo":1,"$thi":0.7868267607794998,"$STR":9,"$idb":0.5,"$icpb":0,"$tdo":0.11010724089134402,"$icb":0,"$scm":2.5978082962508315,"$INT":7,"$LCK":0,"$fc":0.01,"$DEX":4,"$ieb":0,"$cpi":1,"$irb":0,"$cpo":1,"$cai":1,"$pts":0,"$fmr":4,"$cdo":1,"$cao":1.1,"$cdi":1,"$END":4},"intHPMax":1792,"tx":0,"strFrame":"Enter","auras":[]};
        uoData =  {"iCPToRank":0,"ia1":256,"ip0":0,"intHP":1792,"iBankSlots":5,"dUpgExp":"Thu Nov 30 00:00:00 GMT+0800 1899","strUsername":"leght","guild":{"ExpToLevel":1000,"Color":"0xFFFFFF","MOTD":"Hello World!","Level":1,"Name":"Staff Team","Members":[{"userName":"Leght","Server":"Online","ID":4,"Rank":1,"Level":102}],"MaxMembers":15},"iAge":18,"eqp":{"he":{"sLink":"LuckyGirlHair","ItemID":17,"sFile":"items/helms/LuckyGirlHair.swf"},"ar":{"sLink":"NotMod","ItemID":10,"sFile":"NotMod.swf"},"Weapon":{"sLink":"Unarmed","ItemID":1,"sFile":"items/maces/Unarmed.swf","sType":"Weapon"},"ba":{"sLink":"MiltCape7","ItemID":19,"sFile":"items/capes/MiltCape7.swf"},"co":{"sLink":"SchoolUniform","ItemID":16,"sFile":"SchoolUniform.swf"}},"strChatColor":"0xFFFFFF","intMP":205,"iq0":0,"iBoostC":0,"CharID":4,"strEmail":"leght@gmail.com","iDBCP":0,"strHomeTown":"faroff","aClassMRM":"Test","iHouseSlots":0,"iSTR":0,"intHits":1267,"iDEX":0,"iEND":0,"intExpToLevel":60950,"iINT":0,"strClassName":"NOT A MOD","iWIS":0,"iCP":325000,"iLCK":0,"strHairFilename":"hairs/M/MQElegant.swf","HairID":1,"intColorSkin":"15388042","UserID":4,"strHairName":"MQElegant","intLevel":102,"iCurCP":22500,"intDeathCount":0,"intMPMax":205,"intColorHair":"6180663","intColorEye":"91294","quests":[2,1,3],"strMapName":"faroff","intColorBase":"0","iUpgDays":0,"guildRank":1,"iUpg":0,"iRank":10,"intHPMax":1792,"intAccessLevel":60,"intKillCount":0,"intActivationFlag":5,"intSilver":147,"sClassStats":"Test","intSP":100,"iBoostXP":0,"intColorAccessory":"0","bitSuccess":"1","intColorTrim":"0","sHouseInfo":"","strGender":"F","iBoostCP":0,"intExp":0,"ip2":0,"iFounder":0,"intSPMax":100,"iBoostRep":0,"lastArea":"faroff|Enter|Spawn","intCopper":87,"iBagSlots":502,"bPermaMute":0,"sClassDesc":"Test","iBoostG":0,"ip1":0,"iDailyAdCap":6,"sCountry":"PH","intGold":207,"dCreated":"Thu Nov 30 00:00:00 GMT+0800 1899","sClassCat":"M2","iDailyAds":0,"ia0":0}

        var o:Object;
        var s:String = "";

        for each (o in data.stats) s += uoTree.sta["$" + o] + "\n";

        tStats.htmlText = s;

        s = "";
        for each (o in data.combat1) s += uoTree.sta[o];
        tCombat1.htmlText = s;

        s = "";

        for each (o in data.combat2)
        {
            trace(o);
            if (["$tcr", "$scm"].indexOf(o) > -1)
            {
                s += Number(uoTree.sta[o] * 100);
            }
            else
            {
                s += Number(uoTree.sta[o]);
            }
        }

        tCombat2.htmlText = s;
    }

}

}
