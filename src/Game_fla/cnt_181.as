// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//Game_fla.cnt_181

package Game_fla
{
    import flash.display.MovieClip;
    import flash.net.sendToURL;
    import flash.net.URLRequest;
    import flash.net.navigateToURL;
    import flash.events.MouseEvent;
    import flash.display.Loader;
    import flash.events.Event;
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

    public dynamic class cnt_181 extends MovieClip 
    {

        public var mcContent:MovieClip;
        public var mcTomb:MovieClip;
        public var rootClass:Game;
        public var arrTips:Array;
        public var arrAds:Array;
        public var iAdIndex:int;

        public function cnt_181()
        {
            addFrameScript(0, frame1, 4, frame5, 19, frame20, 56, frame57);
        }

        public function clickGo(_arg_1:MouseEvent):*
        {
            var _local_2:String = ("http://tracking.battleon.com/click.asp?game=AW&campaign=DEATHAQW_" + arrAds[iAdIndex].sType.toUpperCase());
            sendToURL(new URLRequest(_local_2));
            navigateToURL(new URLRequest(arrAds[iAdIndex].sTarget), "_blank");
        }

        public function onCheckBoxClick(_arg_1:Event):void
        {
            if (rootClass.world.myAvatar.isUpgraded())
            {
                rootClass.preference.data.bDeathAd = (!(mcContent.mcButtons.chkAds.bitChecked));
                rootClass.preference.flush();
            }
        }

        internal function frame1():*
        {
            rootClass = Game.root;
            arrTips = ["Never give you password to ANYONE. AQW staff will never ask for it.", "Never share your password or your account with anyone.", "Sharing accounts is against the rules and might get you banned!", "Strength improves your chance of a critical strike for melee classes.", "Learn about Enhancing your weapons by clicking the ENHANCEMENT button in Battleon!", "Keep your enhancements up to date!", "Remember to rest in between battles!", "Intellect increases Magic Power and boosts magical damage and crit for caster classes.", "Wisdom only increases evasion for melee classes.", "Make sure yo read your tool tips for each skill you unlock!", "Mayonnaise should never be heated. It might make you ill!", "We were all noobs once. Help out new players!", "Members get access to special Member-only areas, classes and items!", "Don't stare at the sun.", "If someone is misbehaving, click on their character portrait to report them!", "Go easy on the carbs unless you move a lot.", '"A lot" is two words, not one.', "Sneevils LOVE boxes!", "You can get more item storage from the BANK! Visit Valencia in Battleontown!", "You can store items you got with AdventureCoins for FREE in the bank!", "Try having breakfast for dinner. You can thank me later.", "Clown pants are not heroic.", "Remember to link your AQW account to your MASTER ACCOUNT for additional safety!", "Lost? You can always /join BattleOn", "Trying to catch up with a friend? Type /goto <player name>", "You can hide the chat panel by clicking on the arrow on your interface.", "If someone is being rude you can IGNORE them by clicking on their character portrait.", "To Reply to a private message, just type /r and hit ENTER!", "Gain experience, gold and rep by completing quests.", "You can buy more space in your backpack from Valencia in Battleontown!", "You can use potions or food in battle if you equip it!", "Spotted a game bug? Report it on the official AQW forums!", "Staff will NEVER offer you free items, gold, ACs, or membership over Twitter or Facebook.", "Looking for things to do? Check your Book of Lore or the Adventure Button in Battleon!", "Always read the AQW Design Notes to find out what's coming next!", "Check out HEROMART.COM for lots of cool AQW shirts, games and more!", "Buying stuff at HEROMART.COM will earn you special in-game items!", "Game Moderators, Developers and Staff always have a gold name above their head.", "Give us your feedback on this week's release on the forum, Twitter and Facebook!", "Do not share your account information with ANYONE, no matter what they promise you.", "Confirm your email to unlock chat and gain Power Gem! Refer a friend to get Friend Gems and unlock Twilly's shop!", "Never give your email password to anyone!", "Cysero's left sock might be in your backpack right now!", "Don't give up now, you're just about to win!", "YOU are the only Hero who can save Lore. You must return to battle!", "Never leave home without an extra HP potion!"];
            arrAds = [{
                "sURL":"DeathAds/DragonHero.swf",
                "sTarget":"https://www.aq.com/order-now/direct/",
                "sType":"dragonhero"
            }, {
                "sURL":"DeathAds/DeathAd-MemberUpgrade.jpg",
                "sTarget":"https://www.aq.com/order-now/direct/",
                "sType":"member"
            }, {
                "sURL":"DeathAds/250w-aextras.jpg",
                "sTarget":"http://www.aq.com/aeXtras/offers/",
                "sType":"aeextra"
            }, {
                "sURL":"DeathAds/ED_320x250-Death.jpg",
                "sTarget":"http://epicduel.artix.com",
                "sType":"epicduel"
            }, {
                "sURL":"DeathAds/ED_Death_320x250.jpg",
                "sTarget":"http://epicduel.artix.com/",
                "sType":"Epic Duel"
            }, {
                "sURL":"DeathAds/DragonFable-Death-Ad-01.jpg",
                "sTarget":"http://www.Dragonfable.com/",
                "sType":"Dragon Fable"
            }, {
                "sURL":"DeathAds/DragonFable-Death-Ad-04.jpg",
                "sTarget":"http://www.Dragonfable.com/",
                "sType":"Dragon Fable"
            }, {
                "sURL":"DeathAds/AQDragons-Death-Ad.jpg",
                "sTarget":"http://www.aqdragons.com/",
                "sType":"Dragons"
            }, {
                "sURL":"DeathAds/Velocity-Death-Ad.jpg",
                "sTarget":"http://www.artix.com/designnotes/Post/30052/VelocityAE",
                "sType":"Velocity"
            }, {
                "sURL":"DeathAds/UndeadAssault-Death-Ad.jpg",
                "sTarget":"http://undeadassault.com/",
                "sType":"Undead Assault"
            }, {
                "sURL":"DeathAds/BattleGems-Death-Ad.jpg",
                "sTarget":"http://battlegems.artix.com/",
                "sType":"Battle Gems"
            }];
            iAdIndex = 0;
            mcContent.mcAd.addEventListener(MouseEvent.CLICK, clickGo);
            mcContent.mcAd.buttonMode = true;
            if (rootClass.preference.data.bDeathAd == null)
            {
                rootClass.preference.data.bDeathAd = true;
            }
            mcContent.mcButtons.chkAds.chkBtn.addEventListener(MouseEvent.CLICK, onCheckBoxClick, false, 0, true);
            stop();
        }

        internal function frame5():*
        {
            this.visible = true;
            mcContent.txtTip.htmlText = ("<b>Death's Note:</b> " + arrTips[Math.floor((Math.random() * arrTips.length))]);
        }

        internal function frame20():*
        {
            stop();
        }

        internal function frame57():*
        {
            stop();
        }


    }
}//package Game_fla

