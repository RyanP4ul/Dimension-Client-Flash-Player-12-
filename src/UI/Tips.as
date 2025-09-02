package UI {
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.text.TextField;
import flash.utils.Timer;

public class Tips extends MovieClip {

    public var tTips:TextField;

    private var timer:Timer = new Timer(10000, 0);
    private var currentIndex:int = 0;
    private var tips:Array = ["Never give you password to ANYONE. AQW staff will never ask for it.", "Never share your password or your account with anyone.", "Sharing accounts is against the rules and might get you banned!", "Strength improves your chance of a critical strike for melee classes.", "Learn about Enhancing your weapons by clicking the ENHANCEMENT button in Battleon!", "Keep your enhancements up to date!", "Remember to rest in between battles!", "Intellect increases Magic Power and boosts magical damage and crit for caster classes.", "Wisdom only increases evasion for melee classes.", "Make sure yo read your tool tips for each skill you unlock!", "Mayonnaise should never be heated. It might make you ill!", "We were all noobs once. Help out new players!", "Members get access to special Member-only areas, classes and items!", "Don't stare at the sun.", "If someone is misbehaving, click on their character portrait to report them!", "Go easy on the carbs unless you move a lot.", '"A lot" is two words, not one.', "Sneevils LOVE boxes!", "You can store items you got with Gold for FREE in the bank!", "Try having breakfast for dinner. You can thank me later.", "Clown pants are not heroic.", "Lost? You can always /join faroff", "Trying to catch up with a friend? Type /goto <player name>", "You can hide the chat panel by clicking on the arrow on your interface.", "If someone is being rude you can IGNORE them by clicking on their character portrait.", "To Reply to a private message, just type /r and hit ENTER!", "Gain experience, copper, silver, gold and rep by completing quests.", "You can buy more space in your backpack from inventory!", "You can use potions or food in battle if you equip it!", "Spotted a game bug? Report it on the official AQW forums!", "Staff will NEVER offer you free items, copper, silver, gold, or membership over Social Media", "Always read the News to find out what's coming next!", "Game Moderators, Developers and Staff always have a gold name above their head.", "Do not share your account information with ANYONE, no matter what they promise you.", "Never give your email password to anyone!", "Don't give up now, you're just about to win!", "Never leave home without an extra HP potion!"];

    public function Tips() {
        currentIndex = randomNumber();
        tTips.text = tips[currentIndex];

        timer.start();
        timer.addEventListener(TimerEvent.TIMER, onTimer);
    }

    public function randomNumber():int {
        return Math.floor(Math.random() * tips.length);
    }

    public function onTimer(event:TimerEvent):void {
        if (this == null) {
            timer.removeEventListener(TimerEvent.TIMER, onTimer);
            timer.stop();
            timer = null;
        }

        currentIndex = randomNumber();
        tTips.text = tips[currentIndex];
    }

}
}
