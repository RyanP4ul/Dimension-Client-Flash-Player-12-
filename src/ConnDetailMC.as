// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//ConnDetailMC

package 
{
    import flash.display.MovieClip;
    import flash.text.TextField;
    import flash.display.SimpleButton;
    import flash.utils.Timer;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;
    import flash.events.Event;

import game.config.ConfigurationData;

public class ConnDetailMC extends MovieClip
    {

        private var game:Game = Game.root;
        private var tips:Array = ["Never give you password to ANYONE. AQW staff will never ask for it.", "Never share your password or your account with anyone.", "Sharing accounts is against the rules and might get you banned!", "Strength improves your chance of a critical strike for melee classes.", "Learn about Enhancing your weapons by clicking the ENHANCEMENT button in Battleon!", "Keep your enhancements up to date!", "Remember to rest in between battles!", "Intellect increases Magic Power and boosts magical damage and crit for caster classes.", "Wisdom only increases evasion for melee classes.", "Make sure yo read your tool tips for each skill you unlock!", "Mayonnaise should never be heated. It might make you ill!", "We were all noobs once. Help out new players!", "Members get access to special Member-only areas, classes and items!", "Don't stare at the sun.", "If someone is misbehaving, click on their character portrait to report them!", "Go easy on the carbs unless you move a lot.", '"A lot" is two words, not one.', "Sneevils LOVE boxes!", "You can store items you got with Gold for FREE in the bank!", "Try having breakfast for dinner. You can thank me later.", "Clown pants are not heroic.", "Lost? You can always /join faroff", "Trying to catch up with a friend? Type /goto <player name>", "You can hide the chat panel by clicking on the arrow on your interface.", "If someone is being rude you can IGNORE them by clicking on their character portrait.", "To Reply to a private message, just type /r and hit ENTER!", "Gain experience, copper, silver, gold and rep by completing quests.", "You can buy more space in your backpack from inventory!", "You can use potions or food in battle if you equip it!", "Spotted a game bug? Report it on the official AQW forums!", "Staff will NEVER offer you free items, copper, silver, gold, or membership over Social Media", "Always read the News to find out what's coming next!", "Game Moderators, Developers and Staff always have a gold name above their head.", "Do not share your account information with ANYONE, no matter what they promise you.", "Never give your email password to anyone!", "Don't give up now, you're just about to win!", "Never leave home without an extra HP potion!"];
        private var timerConnDetail:Timer = new Timer(10000, 1);
        private var tipTimer:Timer = new Timer(15000, 0);
        private var minutes:int;
        private var countDownTimer:Timer;
        private var firstJoin:Boolean = false;
        private var currentIndex:int = 0;

        public var bg:MovieClip;
        public var mcPct:TextField;
        public var txtBack:TextField;
        public var txtTips:TextField;
        public var mcTitle:MovieClip;
        public var txtDetail:TextField;
        public var btnBack:SimpleButton;

        public function ConnDetailMC()
        {
            txtBack.mouseEnabled = false;
            mcPct.visible = false;

            setTips();

            btnBack.addEventListener(MouseEvent.CLICK, onBackClick, false, 0, true);

            timerConnDetail.removeEventListener(TimerEvent.TIMER, showBackButton);
            timerConnDetail.addEventListener(TimerEvent.TIMER, showBackButton, false, 0, true);
            tipTimer.removeEventListener(TimerEvent.TIMER, onTipsTimer);
            tipTimer.addEventListener(TimerEvent.TIMER, onTipsTimer, false, 0, true);
            tipTimer.start();
        }

        public function setTips() : void
        {
            currentIndex = randomNumber;
            txtTips.htmlText = "<font color='#FFCC00'>Tips:</font> " + tips[currentIndex];
            txtTips.y = bg.y + (bg.height - txtTips.textHeight) / 2;
        }

        public function get randomNumber():int {
            return Math.floor(Math.random() * tips.length);
        }

        private function onBackClick(_arg_1:MouseEvent=null) : void
        {
            if (firstJoin)
            {
                game.connectTo(ConfigurationData.SERVER_IP_ADDRESS, ConfigurationData.SERVER_PORT);
                game.chatF.iChat = 2;
            }
            else
            {
                game.logout();
                hideConn();
            }
        }

        public function showConn(msg:String, isFirstJoin:Boolean=false, param3:Boolean = false):void
        {
            btnBack.visible = false;
            txtBack.visible = false;
            txtBack.text = "Cancel";
            txtDetail.text = msg;
            firstJoin = isFirstJoin;

            if (stage == null)
            {
                game.addChild(this);
            }
            if (!timerConnDetail.running && !param3)
            {
                timerConnDetail.reset();
                timerConnDetail.start();
            }
        }

        public function showDisconnect(msg:String):void
        {
            btnBack.visible = true;
            txtBack.visible = true;
            txtBack.text = "Back";
            txtDetail.text = msg;
            mcPct.visible = false;

            if (stage == null) game.addChild(this);
            if (timerConnDetail.running) timerConnDetail.stop();
        }

        private function onTipsTimer(event:TimerEvent) : void
        {
            setTips();
        }

        public function showBackButton(event:TimerEvent=null):void
        {
            btnBack.visible = true;
            txtBack.visible = true;
        }

        public function showError(msg:String):void
        {
            if (stage == null) game.addChild(this);
            txtDetail.htmlText = msg;
            txtBack.text = firstJoin ? "Try Again" : "Back";
            showBackButton();
        }

        public function hideConn():void
        {
            if (stage != null) game.removeChild(this);
        }

        public function showCountDown(m:int):void
        {
            countDownTimer = new Timer(60000, 1);
            minutes = m;
            this.addEventListener(Event.REMOVED_FROM_STAGE, onRemove, false, 0, true);
            countDownTimer.addEventListener(TimerEvent.TIMER, onCountdown, false, 0, true);
            countDownTimer.start();
        }

        private function onRemove(event:Event):void
        {
            countDownTimer.removeEventListener(TimerEvent.TIMER, onCountdown);
        }

        private function onCountdown(event:TimerEvent):void
        {
            minutes--;
            countDownTimer.stop();
            if (minutes > 0)
            {
                countDownTimer.reset();
                countDownTimer.start();
            }
            else
            {
                countDownTimer.removeEventListener(TimerEvent.TIMER, onCountdown);
            }
        }


    }
}//package 

