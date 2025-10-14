// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//Chat

package UI
{
import Emojis.emojiDefaultAngry;
import Emojis.emojiDefaultBleh;
import Emojis.emojiDefaultBlush;
import Emojis.emojiDefaultCry;
import Emojis.emojiDefaultFlyKiss;
import Emojis.emojiDefaultKiss;
import Emojis.emojiDefaultLaugh;
import Emojis.emojiDefaultROFL;
import Emojis.emojiDefaultSad;
import Emojis.emojiDefaultSmile;
import Emojis.emojiDefaultWink;

import flash.display.MovieClip;
    import flash.net.SharedObject;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import flash.events.MouseEvent;
    import flash.events.KeyboardEvent;
    import flash.events.Event;
    import flash.filters.BevelFilter;
    import flash.geom.Point;
    import flash.geom.ColorTransform;
    import flash.events.TextEvent;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFieldType;
    import flash.display.DisplayObject;
    import flash.text.TextField;
    import flash.geom.Rectangle;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;
    import flash.display.DisplayObjectContainer;

import utils.SwfToImageConverter;

public class Chat
    {

        public var game:Game;
        public var newTextLine:*;
        public var emojis:Array = [];
        public var emoji:*;
        public var iChat:int = 0;
        internal var pmMode:* = 0;
        private var chatArray:Array = [];
        internal var cmdHistory:Array = [];
        internal var mcHistory:MovieClip;
        private var t1Arr:* = [];
        private var t2Arr:* = [];
        private var silentMute:* = 0;
        private var profanityF:int = 0;
        private var lineLimit:int = 100;
        public var pmSourceA:* = [];
        public var pmI:int = 0;
        public var pmNm:String = "";
        public var ignoreList:SharedObject = SharedObject.getLocal("ignoreList");
        public var muteData:SharedObject = SharedObject.getLocal("muteData");
        public var mute:* = {
            "ts":0,
            "cd":0,
            "timer":new Timer(0, 1)
        };
        public var myMsgs:* = [];
        public var myMsgsI:int = 0;
        public var chn:* = {};
        public var emailWarning:String = "WARNING: Never give your email or password to anyone else. Moderators have gold names. If a player does not have a gold name they are NOT a moderator or staff member.";
        public var legalChars:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789~!@#$%^&*_+-=:\"?,./;'\\|<>() ";
        public var legalCharsStrict:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        public var markChars:* = "~!@#$%^&*()_+-=:\"<>?,.;'\\";
        public var strictComparisonChars:* = "~!@#$%^&*()_+-=:\"<>?,.;'\\ÇüéâäåçêëèïîìÄÅæÆôöòûùÿ֣¥áíóúñ?£ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝß";
        public var strictComparisonCharsB:* = "~!#%^&()_+-=:\"<>?,.;'\\ÇüéâäåçêëèïîìÄÅæÆôöòûùÿ֣¥áíóúñ?£ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝß";
        public var illegalStrings:* = ["&#", "www", "http", "ftp", ".com", ".c0m", ".net", ".org", ".de", ".ru", ".sg", ".ph", ".tk", "dotcom", "freegold", "freecoins", "freeadventurecoins", "freelevels", "freeitems", "freeupgrades", "gmail", "yahoo", "hotmail", "aol", "formfacil", "email", "password"];
        public var modWhisperCheckList:Array = ["trade", "free", "acs", "member", "pass", "login", "user", "imamod", "iamamod", "i'mamod", "account"];
        public var regExpA:RegExp = /(a{2,})/gi;
        public var regExpE:RegExp = /(e{2,})/gi;
        public var regExpI:RegExp = /(i{2,})/gi;
        public var regExpO:RegExp = /(o{2,})/gi;
        public var regExpU:RegExp = /(u{2,})/gi;
        public var regExpSPACE:RegExp = /(\s{2,})/gi;
        public var regExpLinking1:RegExp = /<\s*P\b.*?>(.*?)<\s*\/P\s*>/gi;
        public var regExpLinking2:RegExp = /<\s*FONT\b.*?>(.*?)<\s*\/FONT\s*>/gi;
        public var regExpLinking3:RegExp = /<\s*A HREF="(.*?)" TARGET="">(.*?)<\s*\/A\s*>/gi;

        internal var regExpMod:RegExp = /(\(|<)mod(era(t|d)or)?(>|\))/gi;
        public var regExpURL:RegExp = new RegExp("\\bhttp://[-A-Za-z0-9+&@#/%?=~_|!:,.;]*[-A-Za-z0-9+&@#/%=~_|]", "i");
        public var unsendable:* = ["@"];
        private var whichField:* = 0;
        private var msgFields:* = ["t1:", "t2:say,zone,trade,moderator"];
        private var drawnA:Array = [];
        private var tfHeight:int = 150;
        private var t1Shorty:int = -140;
        private var t1Tally:int = -378;
        private var tfdH:int = Math.abs((t1Tally - t1Shorty));
        public var panelIndex:int = 0;
        private var msgID:int = 0;
        internal var xmlCannedOptions:XML = <CannedChat>
	<l1 display="Emotes">
		<l2 id="emote" display="Dance" text="dance"/>
		<l2 id="emote" display="Dance2" text="dance2"/>
		<l2 id="emote" display="Laugh" text="laugh"/>
		<l2 id="emote" display="Cry" text="cry"/>
		<l2 id="emote" display="Cheer" text="cheer"/>
		<l2 id="emote" display="Point" text="point"/>
		<l2 id="emote" display="Use" text="use"/>
		<l2 id="emote" display="Feign" text="feign"/>
		<l2 id="emote" display="Sleep" text="sleep"/>
		<l2 id="emote" display="Jump" text="jump"/>
		<l2 id="emote" display="Punt" text="punt"/>
		<l2 id="emote" display="Wave" text="wave"/>
		<l2 id="emote" display="Bow" text="bow"/>
		<l2 id="emote" display="Salute" text="Salute"/>
		<l2 id="emote" display="Backflip" text="backflip"/>
		<l2 id="emote" display="Swordplay" text="swordplay"/>
		<l2 id="emote" display="Unsheath" text="unsheath"/>
		<l2 id="emote" display="Facepalm" text="facepalm"/>
		<l2 id="emote" display="Air Guitar" text="airguitar"/>
		<l2 id="emote" display="Stern" text="stern"/>
	</l1>
	<l1 display="Member Emotes">
		<l2 id="emote" display="Powerup" text="powerup"/>
		<l2 id="emote" display="Kneel" text="kneel"/>
		<l2 id="emote" display="Jumpcheer" text="jumpcheer"/>
		<l2 id="emote" display="Salute2" text="salute2"/>
		<l2 id="emote" display="Cry2" text="cry2"/>
		<l2 id="emote" display="Spar" text="spar"/>
		<l2 id="emote" display="Stepdance" text="stepdance"/>
		<l2 id="emote" display="Headbang" text="headbang"/>
		<l2 id="emote" display="Dazed" text="dazed"/>
		<l2 id="emote" display="DanceWeapon" text="danceweapon"/>
	</l1>
	<l1 display="Greetings">
		<l2 id="ba" display="Hello!" text="Hello!"/>
		<l2 id="bb" display="Hi!" text="Hi!"/>
		<l2 id="bc" display="Well met!" text="Well met!"/>
		<l2 id="bd" display="Welcome!" text="Welcome!"/>
		<l2 id="be" display="Welcome back!" text="Welcome back!"/>
		<l2 id="bf" display="How are you today?" text="How are you today?"/>
	</l1>
	<l1 display="Farewells">
		<l2 id="ca" display="Bye!" text="Bye!"/>
		<l2 id="cb" display="See you later." text="See you later."/>
		<l2 id="cc" display="AFK" text="I'm going AFK"/>
		<l2 id="cd" display="I have to go now." text="I have to go now."/>
		<l2 id="ce" display="Logging out now" text="Logging out now."/>
		<l2 id="cf" display="brb" text="brb"/>
		<l2 id="cg" display="Farewell" text="Farewell"/>
	</l1>
	<l1 display="Questions">
		<l2 id="da" display="Can I add you">
			<l3 id="ea" display="to my Friends list" text="Can I add you to my Friends list?"/>
			<l3 id="eb" display="to my Party" text="Can I add you to my Party?"/>
		</l2>
		<l2 id="db" display="Do you want to battle together?" text="Do you want to battle together?"/>
	    <l2 id="dc" display="Is that a Member only...">
			<l3 id="fa" display="Helm" text=" Is that a Member only helm?"/>
			<l3 id="fb" display="Cape" text=" Is that a Member only cape?"/>
			<l3 id="fc" display="Armor" text=" Is that a Member only armor?"/>
			<l3 id="fd" display="Weapon" text=" Is that a Member only weapon?"/>
		</l2>
		<l2 id="dd" display="Where are you?" text="Where are you?"/>
		<l2 id="de" display="Are you sure?" text="Are you sure?"/>
		<l2 id="df" display="Can I help you?" text="Can I help you?"/>
		<l2 id="dg" display="What is your alignment?" text="What is your alignment?"/>
		<l2 id="dh" display="Where did you get that ...">
			<l3 id="ga" display="Helm" text="Where did you get that helm?"/>
			<l3 id="gb" display="Cape" text="Where did you get that cape?"/>
			<l3 id="gc" display="Armor" text="Where did you get that armor?"/>
			<l3 id="gd" display="Weapon" text="Where did you get that weapon?"/>
			<l3 id="ge" display="Pet" text="Where did you get that pet?"/>
			<l3 id="ge" display="Class" text="Where did you get that class?"/>
		</l2>
		<l2 id="di" display="Are you a...">
			<l3 id="ha" display="Guardian" text="Are you a Guardian?"/>
			<l3 id="hb" display="DragonLord" text="Are you a DragonLord?"/>
			<l3 id="hc" display="StarCaptain" text="Are you a StarCaptain?"/>
		</l2>
		<l2 id="dj" display="Do you play...">
			<l3 id="ia" display="AdventureQuest" text="Do you play AdventureQuest?"/>
			<l3 id="ib" display="DragonFable" text="Do you play DragonFable?"/>
			<l3 id="ic" display="MechQuest" text="Do you play MechQuest?"/>
		</l2>
		<l2 id="dl" display="What are you doing?" text="What are you doing?"/>
	</l1>
	<l1 display="Answers">
		<l2 id="ja" display="thanks/welcome">
			<l3 id="ka" display="Thanks!" text="Thanks!"/>
			<l3 id="kb" display="Thank you!" text="Thank you!"/>
			<l3 id="kc" display="Thanks for helping me." text="Thanks for helping me."/>
			<l3 id="kd" display="I owe you one." text="I owe you one.."/>
			<l3 id="ke" display="No problem!" text="No problem!"/>
			<l3 id="kf" display="You're welcome!" text="You're welcome!"/>
		</l2>
		<l2 id="jn" display="I am doing/trying to..">
			<l3 id="ma" display="Quest" text="I am doing a quest."/>
			<l3 id="mb" display="Farming" text="I am farming."/>
			<l3 id="mc" display="New" text="I am playing the new release."/>
			<l3 id="md" display="Level up." text="I am trying to level up."/>
			<l3 id="me" display="Rank up." text="I am trying to rank up."/>
		</l2>
		<l2 id="jb" display="I'm fine, thanks." text="I'm fine, thanks."/>	
		<l2 id="jc" display="Could be better." text="Could be better."/>
		<l2 id="jd" display="I don't think so." text="I don't think so."/>
		<l2 id="je" display="I don't know." text="I don't know."/>
		<l2 id="jf" display="Indeed." text="Indeed."/>
		<l2 id="jg" display="Pleased to meet you." text="Pleased to meet you."/>
		<l2 id="jh" display="Good." text="I am Good."/>
		<l2 id="ji" display="Evil." text="I am Evil."/>
		<l2 id="jj" display="Me too!" text="Me too!"/>
		<l2 id="jk" display="I got it...">
			<l3 id="la" display="as a drop." text="I got it as a drop."/>
			<l3 id="lb" display="from a shop." text="I got it from a shop."/>
		</l2>
		<l2 id="jl" display="Check the Wiki..." text="You can check the Wiki for the location."/>
		<l2 id="jm" display="Your Book of Lore will know that" text="Your Book of Lore will know that."/>
		<l2 id="jo" display="I can only use Canned Chat." text="I can only use Canned Chat."/>
	</l1>
	<l1 display="Meeting up">
		<l2 id="na" display="Follow me!" text="Follow me!"/>
		<l2 id="nb" display="Over here!" text="Over here!"/>
		<l2 id="nc" display="Goto me." text="Goto me."/>
		<l2 id="nd" display="I'll follow you." text="I'll follow you."/>
		<l2 id="ne" display="Maybe some other time." text="Maybe some other time."/>
		<l2 id="nf" display="Ok, let's go." text="Ok, let's go."/>
		<l2 id="ng" display="Come back here." text="Come back here."/>
		<l2 id="nh" display="I need to finish this first." text="I need to finish this first."/>
		<l2 id="ni" display="Seriously?" text="Seriously?"/>
		<l2 id="nj" display="*I'm going to...">
			<l3 id="oa" display="Artix" text="I'm going to the Artix Server."/>
			<l3 id="ob" display="Galanoth" text="I'm going to the Galanoth Server."/>	
			<l3 id="oh" display="Sir Ver" text="I'm going to Sir Ver."/>
			<l3 id="oi" display="Twig" text="I'm going to the Twig server."/>
			<l3 id="oj" display="Twilly" text="I'm going to the Twilly server."/>
			<l3 id="ok" display="Yorumi" text="I'm going to the Yorumi server."/>
			<l3 id="oj" display="TestingServer" text="I'm going to the TestingServer server."/>
			<l3 id="ok" display="TestingServer2" text="I'm going to the TestingServer2 server."/>
		</l2>
		<l2 id="nk" display="Sorry, I'm busy." text="Sorry, I'm busy."/>
	</l1>
	<l1 display="In Battle">
		<l2 id="pa" display="Can you..">
			<l3 id="qa" display="help with battle" text="Can you help me with this battle?"/>
			<l3 id="qb" display="help with Boss" text="Can you help me with the Boss?"/>
		</l2>
		<l2 id="pb" display="Planning...">
			<l3 id="ra" display="Let's attack now!" text="Let's attack now!"/>
			<l3 id="rb" display="I'll attack first." text="I'll attack first."/>
			<l3 id="rc" display="You go first." text="You go first."/>
			<l3 id="rd" display="I need to rest." text="I need to rest."/>
		</l2>
		<l2 id="pc" display="During the battle">
			<l3 id="sa" display="Heal, please!" text="Heal, please!"/>
			<l3 id="sb" display="MEDIC!" text="MEDIC!"/>
			<l3 id="sc" display="Help!" text="Help!"/>
			<l3 id="sd" display="I'm out of Mana." text="I'm out of Mana."/>
			<l3 id="se" display="Use your special attacks!" text="Use your special attacks!"/>
			<l3 id="sf" display="This monster is strong!" text="This monster is strong!"/>
			<l3 id="sg" display="Slay that monster!" text="Slay that monster!"/>
			<l3 id="sh" display="This is hard." text="This hard."/>
			<l3 id="si" display="This is easy." text="This easy."/>
			<l3 id="sj" display="Run away!" text="Run away!"/>
		</l2>
		<l2 id="pd" display="After battle">
			<l3 id="ta" display="Yes! I got the drop!" text="Yes! I got the drop!"/>
			<l3 id="tb" display="We did it!" text="We did it!"/>
			<l3 id="tc" display="You fight well." text="You fight well."/>
			<l3 id="td" display="Nooo! I died!" text="Nooo! I died!"/>
			<l3 id="tf" display="Let's try again!" text="Let's try again!"/>
		</l2>
	</l1>
	<l1 display="Exclamations">
		<l2 id="ua" display="Battle on!" text="Battle on!"/>
		<l2 id="uc" display="OMG!" text="OMG!"/>
		<l2 id="ud" display="lol" text="lol"/>
		<l2 id="uf" display="Woot!" text="Woot!"/>
		<l2 id="ug" display="Wow!" text="Wow"/>
		<l2 id="uh" display="High Five!" text="High Five!"/>
		<l2 id="ui" display="Congrats!" text="Congrats!"/>
		<l2 id="uj" display="Level up!" text="Level up!"/>
		<l2 id="uk" display="Rank up!" text="Rank up!"/>
		<l2 id="ul" display="LONG UN-LIVE THE SHADOWSCYTHE!!" text="LONG UN-LIVE THE SHADOWSCYTHE!!"/>
		<l2 id="um" display="Long live King Alteon the Good!!" text="Long live King Alteon the Good!!"/>
		<l2 id="un" display="This rocks!" text="This rocks!"/>
		<l2 id="uo" display="This is awesome!" text="This is awesome!"/>
		<l2 id="up" display="This is fun." text="This is fun."/>
		<l2 id="uq" display="That is really cool." text="That is really cool."/>
		<l2 id="ur" display="Cheer up!" text="Cheer up!"/>
		<l2 id="ut" display="Great!" text="Great!"/>
		<l2 id="uu" display="HaHa" text="HaHa"/>
	</l1>
	<l1 display="Stop">
		<l2 id="va" display="following me" text="Please stop following me."/>
		<l2 id="vb" display="doing that" text="Please stop doing that."/>
		<l2 id="vc" display="PMing me" text="Please stop PMing me."/>
	</l1>
	<l1 display="Smilies">
		<l2 id="wa" display=":)" text=":)"/>
		<l2 id="wb" display=":(" text=":("/>
		<l2 id="wc" display=":/" text=":/"/>
		<l2 id="wd" display=":|" text=":|"/>
		<l2 id="we" display=":O" text=":O"/>
		<l2 id="wf" display="D:" text="D:"/>
	</l1>
	<l1 id="x" display="Yes." text="Yes."/>
	<l1 id="y" display="No." text="No."/>
	<l1 id="z" display="OK." text="OK."/>
</CannedChat>;

        private var profanityA:Array = ["@$$", "&&##", "anal", "arse", "ass", "a55", "a5s", "as5", "a$$", "a$s", "as$", "a5$", "a$5", "a*s", "*ss", "a**", "as*", "assclown", "assface", "asshole", "asswipe", "bastard", "beating the meat", "beef curtains", "beef flaps", "betch", "biatch", "bich", "bish", "b1ch", "b!ch", "blch", "b|ch", "bitch", "b1tch", "b!tch", "bltch", "b|tch", "bizzach", "blowjob", "boobies", "boobs", "b00bs", "buggery", "bullshit", "buttsex", "carpet muncher", "carpet munchers", "carpetlicker", "carpetlickers", "ch1nk", "chink", "chode", "clit", "cocaine", "cock", "cocks", "c0ck", "co*k", "c*ck", "cocksucker", "condom", "cracka", "cum", "cunt", "cunts", "c*nt", "cu*t", "*unt", "cun*", "damn", "d1ck", "dick", "di*k", "d*ck", "d**k", "d|ck", "dildo", "d1ldo", "dumbass", "dumb4ss", "dyke", "ejaculate", "f*ck", "feck", "f@g", "fag", "f4ggot", "f4gg0t", "faggot", "fap", "f4p", "fapping", "f4pping", "fatass", "fack", "feck", "felcher", "foreskin", "fhuck", "fking", "fuk", "fck", "fuc", "fu*k", "fuck", "fuuck", "fuuk", "fcuk", "fvck", "fvk", "fvvck", "fvvk", "fock", "fux0r", "fucken", "fucker", "fucking", "fudgepacker", "ganja", "gook", "h0r", "h*re", "hentai", "heroin", "h0mo", "h0m0", "homo", "horny", "injun", "jack off", "jerk off", "jackass", "j1sm", "jism", "j1zz", "jizz", "kawk", "kike", "klootzak", "knulle", "kraut", "kuk", "kunt", "kuksuger", "kurac", "kurwa", "kusi", "kyrpa", "l3+ch", "lesbo", "lez", "marijuana", "masturbate", "masturbation", "meat puppet", "merd", "milf", "molester", "m0lester", "m0l3ster", "m0l3st3r", "motherfucker", "muie", "mulkku", "nads", "nazi", "n1gga", "nigga", "nigger", "nutsack", "orospu", "orgasm", "orgy", "p0rn", "paska", "penis", "phuck", "pierdol", "pillu", "pimmel", "pimp", "piss", "poontsee", "porn", "p0rno", "p0rn0", "porno", "pr0n", "preteen", "pron", "prostitute", "pussy", "pussie", "pu$$y", "puta", "puto", "queef", "r4pe", "rape", "r4ped", "raped", "rapist", "retard", "rimjob", "schaffer", "schiess", "schlampe", "screw", "scrotum", "secks", "s3x", "sex", "s*x", "se*", "sharmuta", "sharmute", "shipal", "shit", "sh1t", "sh!t", "shlt", "sh|t", "shiz", "sh1z", "sh!z", "shlz", "sh|z", "shiit", "shi!t", "sh!it", "shilt", "shlit", "sh||t", "shi|t", "sh|it", "shiiz", "shi t", "shyt", "sh*t", "s*it", "s**t", "s***", "shlong", "skank", "skurwysyn", "slut", "sl*t", "s**t", "smartass", "smut", "spierdalaj", "splooge", "threesome", "tit", "tits", "titties", "twat", "vagina", "wank", "weed", "wetback", "whack off", "wh0re", "whore", "whoring", "wichser", "yolasite", "zabourah", "yolas1te", "y0lasite", "y0las1te", "webly", "w33bly", "web1y", "w33b1y", "anus", "4nus", "rectum", "r3ctum", "foda", "fodao", "phoda", "phodao", "Azzhole", "A$$hole", "AsshoIe", "Azzhole", "Asswipe", "Btch", "B!tch", "BItch", "BItch", "D!ck", "Dlck", "D!ldo", "Dumbass", "Dyke", "Fgt", "Faggot", "Fagget", "Fegget", "Feggit", "Feget", "Fggot", "Fggt", "Fhaggot", "F4g", "Fken", "Fkking", "fu/ck", "H#mo", "Nigga", "N|gger", "Niga", "Ngga", "Pen1s", "Rape", "Rhape", "Raep", "Buceta", "Xoxota", "Cachorra", "Cagada", "puta", "Foda-se", "Macaco", "Negrinho", "Merda", "Porra", "Merdimbuca", "Mijada", "Mijão", "Ninfeta", "Sapatao", "Cagada", "Cerote", "Chichis", "Cojer", "Cojido", "Culera", "Culero", "Culona", "Joto", "Mamahuevo", "Maricon", "Mierda", "Nachas", "Nalgas", "Nalgona", "Pendeja", "Pendejo", "Perra", "Pito", "Puta", "Puto", "Putas", "Retardado", "Tetas", "Verga", "Vergisima"];
        private var profanityB:Array = [];
        private var profanityC:Array = ["bitch", "b1tch", "b!tch", "bltch", "b|tch", "damn", "dick", "fag", "fuk", "fvk", "fvck", "fuck", "pussy", "shit", "sh1t", "sh!t", "shlt", "sh|t"];
        private var mcCannedChat:MovieClip;
        public var t:Timer = new Timer(500, 1);
        public var windowTimer:Timer = new Timer(60000, 1);

        public function Chat(game:Game)
        {
            this.game = game;

//            chn.world = {
//                col: "00FFFF",
//                str: "world",
//                typ: "world",
//                tag: "World",
//                rid: 0,
//                act: 1
//            }
//
//            chn.administrator = {
//                col: "FF0000",
//                str: "administrator",
//                typ: "administrator",
//                tag: "Admin",
//                rid: 0,
//                act: 1
//            }

            chn.cur = {};
            chn.lastPublic = {};
            chn.xt = "zm";

//            trace("Chat class instantiated.");
//            if (channels.length > 0)
//            {
//                for each (var chatChannel:ChatChannel in channels)
//                {
//                    trace("CHANNEL => " + chatChannel.Name);
////                    chn[chatChannel.Name] = {
////                        col: chatChannel.Color,
////                        str: chatChannel.Name,
////                        typ: chatChannel.Type,
////                        tag: chatChannel.Name,
////                        rid: chatChannel.Rid,
////                        act: chatChannel.Act
////                    };
//                }
//            }
//            else
//            {
//                trace("No channels found, requesting...");
//            }

//            chn.zone = {};
//            chn.trade = {};
//            chn.moderator = {};
//            chn.warning = {};
//            chn.server = {};
//            chn.event = {};
//            chn.whisper = {};
//            chn.party = {};
//            chn.guild = {};
//            chn.wheel = {};
//            chn.zone.col = "9CCAFD";
//            chn.trade.col = "D2FD94";
//            chn.moderator.col = "FFCC33";
//            chn.warning.col = "FF0000";
//            chn.server.col = "00FFFF";
//            chn.event.col = "00FF00";
//            chn.whisper.col = "FF00FF";
//            chn.party.col = "00CCFF";
//            chn.guild.col = "99FF00";
//            chn.wheel.col = "FFCC33";
//            chn.zone.str = "zone";
//            chn.trade.str = "trade";
//            chn.moderator.str = "moderator";
//            chn.warning.str = "warning";
//            chn.server.str = "server";
//            chn.event.str = "event";
//            chn.whisper.str = "whisper";
//            chn.party.str = "party";
//            chn.guild.str = "guild";
//            chn.wheel.str = "wheel";
//            chn.zone.typ = "message";
//            chn.trade.typ = "message";
//            chn.moderator.typ = "whisper";
//            chn.warning.typ = "server";
//            chn.server.typ = "server";
//            chn.event.typ = "event";
//            chn.whisper.typ = "whisper";
//            chn.party.typ = "message";
//            chn.guild.typ = "message";
//            chn.wheel.typ = "whisper";
//            chn.zone.tag = "";
//            chn.trade.tag = "";
//            chn.moderator.tag = "Moderator";
//            chn.warning.tag = "";
//            chn.server.tag = "";
//            chn.whisper.tag = "Whisper";
//            chn.event.tag = "";
//            chn.party.tag = "Party";
//            chn.guild.tag = "Guild";
//            chn.wheel.tag = "Wheel";
//            chn.zone.rid = 0;
//            chn.trade.rid = 0;
//            chn.moderator.rid = 0;
//            chn.warning.rid = 0;
//            chn.server.rid = 0;
//            chn.event.rid = 0;
//            chn.whisper.rid = 0;
//            chn.party.rid = 32123;
//            chn.guild.rid = 0;
//            chn.wheel.rid = 0;
//            chn.zone.act = 1;
//            chn.trade.act = 0;
//            chn.moderator.act = 1;
//            chn.warning.act = 1;
//            chn.server.act = 1;
//            chn.event.act = 1;
//            chn.whisper.act = 1;
//            chn.party.act = 0;
//            chn.guild.act = 0;
//            chn.wheel.act = 1;

            chn.cur = chn.zone;
            chn.lastPublic = chn.cur;

            if (ignoreList.data.users == undefined)
            {
                ignoreList.data.users = [];
            }
        }

        private function initProfanity():void
        {
            var _local_4:String;
            var _local_1:Array = ["butt", "pron", "rape", "tits", "shi t", "shi t"];
            var _local_2:Array = ["as5", "a5s", "a$$", "a5$", "a$5", "as$", "fck", "fkc", "fvk", "fuck", "fvck", "fukk", "fvkk", "sh!t", "sh|t", "sh1t", "shiz"];
            var _local_3:int;
            while (_local_3 < profanityA.length)
            {
                _local_4 = game.stripWhiteStrict(profanityA[_local_3]);
                if (((_local_1.indexOf(_local_4) == -1) && ((_local_4.length > 4) || (_local_2.indexOf(_local_4) > -1))))
                {
                    profanityB.push(_local_4);
                }
                else
                {
                    if (profanityA[_local_3].indexOf("*") > -1)
                    {
                        profanityB.push(profanityA[_local_3]);
                    }
                }
                _local_3++;
            }
        }

        public function init() : void
        {
            chatArray = [];
            t1Arr = [];
            drawnA = [];
            msgID = 0;
            panelIndex = 0;
            tfHeight = 150;
            t1Shorty = -140;
            t1Tally = -378;

            tfdH = Math.abs((t1Tally - t1Shorty));
            initProfanity();
            if (muteData.data != null)
            {
                mute.ts = muteData.data.ts;
                mute.cd = muteData.data.cd;
            }
            mute.timer.addEventListener(TimerEvent.TIMER, unmuteMe, false, 0, true);
            if (mcCannedChat == null)
            {
                mcCannedChat = initCannedChat(xmlCannedOptions.children());
            }
            game.ui.mcInterface.tt.mouseEnabled = false;
            game.ui.mcInterface.textLine.ti.htmlText = "";
            game.ui.mcInterface.textLine.ti.autoSize = "left";
            game.ui.mcInterface.textLine.visible = false;
            game.ui.mcInterface.bMinMax.buttonMode = true;
            game.ui.mcInterface.bMinMax.a2.visible = false;
            game.ui.mcInterface.bShortTall.buttonMode = true;
            game.ui.mcInterface.bHistory.buttonMode = true;
            game.ui.mcInterface.bShortTall.a2.visible = false;
            game.ui.mcInterface.te.text = "";
            game.ui.mcInterface.te.visible = false;
            game.ui.mcInterface.tt.text = "";
            game.ui.mcInterface.tt.visible = false;
            game.ui.mcInterface.te.maxChars = 150;
            game.ui.mcInterface.bCannedChat.removeEventListener(MouseEvent.CLICK, onCannedChatClick);
            game.ui.mcInterface.bsend.removeEventListener(MouseEvent.CLICK, chat_btnSend);
            game.ui.mcInterface.tebg.removeEventListener(MouseEvent.CLICK, chat_tebgClick);
            game.ui.mcInterface.bMinMax.removeEventListener(MouseEvent.CLICK, bMinMaxClick);
            game.ui.mcInterface.bMinMax.removeEventListener(MouseEvent.MOUSE_OVER, bMinMaxMouseOver);
            game.ui.mcInterface.bMinMax.removeEventListener(MouseEvent.MOUSE_OUT, bMinMaxMouseOut);
            game.ui.mcInterface.bShortTall.removeEventListener(MouseEvent.CLICK, bShortTallClick);
            game.ui.mcInterface.bShortTall.removeEventListener(MouseEvent.MOUSE_OVER, bShortTallMouseOver);
            game.ui.mcInterface.bShortTall.removeEventListener(MouseEvent.MOUSE_OUT, bShortTallMouseOut);
            game.ui.mcInterface.bHistory.removeEventListener(MouseEvent.CLICK, onHistoryClick);

            game.stage.removeEventListener(KeyboardEvent.KEY_DOWN, game.key_StageLogin);
            game.stage.removeEventListener(KeyboardEvent.KEY_DOWN, game.key_StageGame);
            game.ui.mcInterface.te.removeEventListener(KeyboardEvent.KEY_DOWN, game.key_ChatEntry);
            game.ui.mcInterface.te.removeEventListener(Event.CHANGE, checkMsgType);
            game.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheelEvent);
            mcCannedChat.removeEventListener(MouseEvent.MOUSE_OVER, onCannedChatOver);
            mcCannedChat.removeEventListener(MouseEvent.MOUSE_OUT, onCannedChatOut);
            t.removeEventListener(TimerEvent.TIMER, closeCannedChatTimer);
            windowTimer.removeEventListener(TimerEvent.TIMER, timedWindowHide);
            game.ui.mcInterface.bCannedChat.addEventListener(MouseEvent.CLICK, onCannedChatClick);
            game.ui.mcInterface.bsend.addEventListener(MouseEvent.CLICK, chat_btnSend);
            game.ui.mcInterface.tebg.addEventListener(MouseEvent.CLICK, chat_tebgClick);
            game.ui.mcInterface.bMinMax.addEventListener(MouseEvent.CLICK, bMinMaxClick);
            game.ui.mcInterface.bMinMax.addEventListener(MouseEvent.MOUSE_OVER, bMinMaxMouseOver);
            game.ui.mcInterface.bMinMax.addEventListener(MouseEvent.MOUSE_OUT, bMinMaxMouseOut);
            game.ui.mcInterface.bShortTall.addEventListener(MouseEvent.CLICK, bShortTallClick);
            game.ui.mcInterface.bShortTall.addEventListener(MouseEvent.MOUSE_OVER, bShortTallMouseOver);
            game.ui.mcInterface.bShortTall.addEventListener(MouseEvent.MOUSE_OUT, bShortTallMouseOut);
            game.ui.mcInterface.bHistory.addEventListener(MouseEvent.CLICK, onHistoryClick);
            game.stage.addEventListener(KeyboardEvent.KEY_DOWN, game.key_StageGame);
            game.ui.mcInterface.te.addEventListener(KeyboardEvent.KEY_DOWN, game.key_ChatEntry);
            game.ui.mcInterface.te.addEventListener(Event.CHANGE, checkMsgType);
            game.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheelEvent);
            game.ui.mouseEnabled = false;
            game.ui.mcInterface.mouseEnabled = false;
            game.ui.mcInterface.t1.mouseEnabled = false;
            game.ui.mcInterface.addChild(mcCannedChat);
            mcCannedChat.addEventListener(MouseEvent.MOUSE_OVER, onCannedChatOver);
            mcCannedChat.addEventListener(MouseEvent.MOUSE_OUT, onCannedChatOut);
            mcCannedChat.y = (-(mcCannedChat.numChildren) * 23);
            mcCannedChat.visible = false;
            t.addEventListener(TimerEvent.TIMER, closeCannedChatTimer);
            windowTimer.addEventListener(TimerEvent.TIMER, timedWindowHide);
        }

        public function onHistoryClick(event:MouseEvent):void
        {
            if (cmdHistory.length < 1)
            {
                game.chatF.pushMsg("warning", "No History!", "SERVER", "", 0);
                return;
            }
            mcHistory.visible = !mcHistory.visible;
        }

        private function rebuildHistory():void
        {
            if (cmdHistory.length < 1) return;
            if (mcHistory != null && game.ui.mcInterface.getChildByName("mcHistory")) game.ui.mcInterface.removeChild(game.ui.mcInterface.getChildByName("mcHistory"));
            mcHistory = initHistory();
            game.ui.mcInterface.addChild(mcHistory);
            mcHistory.name = "mcHistory";
            mcHistory.x = 87.3;
            mcHistory.y = (-(mcHistory.numChildren) * 23);
            mcHistory.visible = false;
        }

        private function initHistory():MovieClip
        {
            var mcCmd:*;
            var mc:MovieClip;
            var mcCmdHist:MovieClip = new MovieClip();
            var maxWidth:Number = 0;
            var i:int = 0;
            while (i < cmdHistory.length)
            {
                mcCmd = new CannedOption();
                mcCmd.y = (i * 23);
                mcCmd.addEventListener(MouseEvent.ROLL_OVER, onCmdRollOver, false, 0, true);
                mcCmd.addEventListener(MouseEvent.ROLL_OUT, onCmdRollOut, false, 0, true);
                mcCmd.txtChat.text = cmdHistory[i];
                if (mcCmd.txtChat.textWidth > maxWidth)
                {
                    maxWidth = mcCmd.txtChat.textWidth;
                }
                mcCmd.mcMore.visible = false;
                mcCmd.strMsg = cmdHistory[i];
                mcCmdHist.addChild(mcCmd);
                mcCmd.addEventListener(MouseEvent.CLICK, onCmdMouseClick, false, 0, true);
                i++;
            }

            var mcIndex:int = 0;
            while (mcIndex < mcCmdHist.numChildren)
            {
                mc = MovieClip(mcCmdHist.getChildAt(mcIndex));
                mc.txtChat.width = (maxWidth + 6);
                mc.bg.width = (maxWidth + 20);
                mcIndex++;
            }
            var bevel:BevelFilter = new BevelFilter(1, 45, 0, 1, 0, 1, 0, 0, 1, 3);
            mcCmdHist.filters = [bevel];
            return (mcCmdHist);
        }

        private function onCmdRollOver(e:MouseEvent) : void
        {
            var btn:* = MovieClip(e.currentTarget);
            btn.bg.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 25, 25, 25, 0);
        }

        private function onCmdRollOut(e:MouseEvent) : void
        {
            var btn:* = MovieClip(e.currentTarget);
            btn.bg.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0);
        }

        private function onCmdMouseClick(e:MouseEvent):*
        {
            var btn:MovieClip = MovieClip(e.currentTarget);
            game.ui.mcInterface.te.text = btn.strMsg;
            mcHistory.visible = false;
            game.stage.focus = null;
        }

        private function timedWindowHide(_arg_1:Event):void
        {
            game.ui.mcInterface.t1.visible = false;
        }

        private function bMinMaxMouseOver(_arg_1:MouseEvent) : void
        {
            if (!game.ui.mcInterface.t1.visible)
            {
                game.ui.ToolTip.openWith({"str":"Show the chat pane"});
            }
            else
            {
                game.ui.ToolTip.openWith({"str":"Hide the chat pane"});
            }
        }

        private function bMinMaxMouseOut(_arg_1:MouseEvent) : void
        {
            game.closeToolTip();
        }

        private function bMinMaxClick(_arg_1:MouseEvent):void
        {
            toggleChatPane();
        }

        public function toggleChatPane(_arg_1:Boolean=true) : void
        {
            var _local_2:MovieClip = game.ui.mcInterface.bMinMax;
            trace(("toggleChatPane, visible: " + game.ui.mcInterface.t1.visible));
            if (!game.ui.mcInterface.t1.visible)
            {
                game.ui.mcInterface.t1.visible = true;
                _local_2.a1.visible = true;
                _local_2.a2.visible = false;
                if (_arg_1)
                {
                    game.ui.ToolTip.openWith({"str":"Hide the chat pane"});
                }
            }
            else
            {
                game.ui.mcInterface.t1.visible = false;
                _local_2.a1.visible = false;
                _local_2.a2.visible = true;
                if (_arg_1)
                {
                    game.ui.ToolTip.openWith({"str":"Show the chat pane"});
                }
            }
        }

        private function bShortTallMouseOver(_arg_1:MouseEvent) : void
        {
            if (game.ui.mcInterface.t1.y == t1Shorty)
            {
                game.ui.ToolTip.openWith({"str":"Set the chat pane to full height"});
            }
            else
            {
                game.ui.ToolTip.openWith({"str":"Return the chat pane to normal height"});
            }
        }

        private function bShortTallMouseOut(_arg_1:MouseEvent):*
        {
            var _local_2:MovieClip = (_arg_1.currentTarget as MovieClip);
            game.closeToolTip();
        }

        public function bShortTallClick(event:MouseEvent):void
        {
            var bShortTall:MovieClip = game.ui.mcInterface.bShortTall;

            if (game.ui.mcInterface.t1.y == t1Tally)
            {
                game.ui.mcInterface.t1.y = t1Shorty;
                tfHeight = (tfHeight - tfdH);
                bShortTall.a1.visible = true;
                bShortTall.a2.visible = false;
                game.ui.ToolTip.openWith({"str":"Set the chat pane to full height"});
            }
            else
            {
                game.ui.mcInterface.t1.y = t1Tally;
                tfHeight = (tfHeight + tfdH);
                bShortTall.a1.visible = false;
                bShortTall.a2.visible = true;
                game.ui.ToolTip.openWith({"str":"Return the chat pane to normal height"});
            }

            writeText(panelIndex, "");
        }

        private function onCannedChatClick(_arg_1:MouseEvent):void
        {
            mcCannedChat.visible = (!(mcCannedChat.visible));
        }

        public function closeCannedChat():void
        {
            mcCannedChat.visible = false;
        }

        private function initCannedChat(_arg_1:XMLList):MovieClip
        {
            var _local_7:XML;
            var _local_8:*;
            var _local_9:String;
            var _local_10:MovieClip;
            var _local_2:MovieClip = new MovieClip();
            var _local_3:Number = 0;
            var _local_4:int = 0;
            while (_local_4 < _arg_1.length())
            {
                _local_7 = _arg_1[_local_4];
                _local_8 = new CannedOption();
                _local_8.y = (_local_4 * 23);
                _local_8.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
                _local_8.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
                _local_8.txtChat.htmlText = _local_7.attribute("display").toString();
                _local_8.txtChat.mouseEnabled = false;
                if (_local_8.txtChat.textWidth > _local_3)
                {
                    _local_3 = _local_8.txtChat.textWidth;
                }
                _local_8.strMsg = _local_7.attribute("text").toString();
                _local_8.id = _local_7.attribute("id").toString();
                _local_2.addChild(_local_8);
                if (_local_7.children().length() > 0)
                {
                    _local_8.mcMoreOptions = initCannedChat(_local_7.children());
                    _local_8.addChild(_local_8.mcMoreOptions);
                    _local_8.mcMoreOptions.visible = false;
                    _local_9 = _local_8.txtChat.text;
                    if (((_local_9 == "During the battle") || (_local_9 == "*I'm going to...")))
                    {
                        _local_8.mcMoreOptions.y = (_local_8.mcMoreOptions.y - 100);
                        trace(("Adjust y? " + _local_8.mcMoreOptions.y));
                    }
                }
                else
                {
                    _local_8.mcMore.visible = false;
                    _local_8.addEventListener(MouseEvent.CLICK, onMouseClick);
                }
                _local_4++;
            }
            var _local_5:int;
            while (_local_5 < _local_2.numChildren)
            {
                _local_10 = MovieClip(_local_2.getChildAt(_local_5));
                _local_10.txtChat.width = (_local_3 + 6);
                _local_10.bg.width = (_local_3 + 20);
                _local_10.mcMore.x = (_local_10.bg.width - 10);
                if (_local_10.mcMoreOptions != null)
                {
                    _local_10.mcMoreOptions.x = _local_10.bg.width;
                }
                _local_5++;
            }
            var _local_6:BevelFilter = new BevelFilter(1, 45, 0, 1, 0, 1, 0, 0, 1, 3);
            _local_2.filters = [_local_6];
            return (_local_2);
        }

        private function onRollOver(_arg_1:MouseEvent):*
        {
            var _local_3:*;
            var _local_4:Point;
            var _local_5:Point;
            var _local_2:* = MovieClip(_arg_1.currentTarget);
            _local_2.bg.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 25, 25, 25, 0);
            if (_arg_1.currentTarget.mcMoreOptions != null)
            {
                _arg_1.currentTarget.mcMoreOptions.visible = true;
                _local_3 = _arg_1.currentTarget;
                _local_4 = new Point(_local_3.x, ((_local_3.y + _local_3.mcMoreOptions.y) + (_local_3.mcMoreOptions.numChildren * 23)));
                _local_5 = mcCannedChat.localToGlobal(_local_4);
                if (_local_5.y > 500)
                {
                    _local_3.mcMoreOptions.y = (_local_3.mcMoreOptions.y - (_local_5.y - 500));
                }
            }
        }

        private function onRollOut(_arg_1:MouseEvent):*
        {
            var _local_2:* = MovieClip(_arg_1.currentTarget);
            _local_2.bg.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0);
            if (_arg_1.currentTarget.mcMoreOptions != null)
            {
                _arg_1.currentTarget.mcMoreOptions.visible = false;
            }
        }

        private function onMouseClick(_arg_1:MouseEvent):*
        {
            var _local_2:* = MovieClip(_arg_1.currentTarget);
            if (_local_2.id == "emote")
            {
                submitMsg(("/" + _local_2.strMsg), "emote", game.net.myUserName);
            }
            else
            {
                game.net.send("cc", [_local_2.id]);
            }
            closeCannedChat();
        }

        private function onCannedChatOver(_arg_1:MouseEvent):*
        {
            if (t != null)
            {
                t.reset();
            }
        }

        private function onCannedChatOut(_arg_1:MouseEvent):*
        {
            t.start();
        }

        private function closeCannedChatTimer(_arg_1:TimerEvent):*
        {
            closeCannedChat();
        }

        public function getCCText(_arg_1:String):String
        {
            var _local_2:XML = getCCOption(_arg_1, xmlCannedOptions.children());
            if (_local_2 != null)
            {
                return (_local_2.attribute("text").toString());
            }
            return ("");
        }

        private function getCCOption(_arg_1:String, _arg_2:XMLList):XML
        {
            var _local_4:XML;
            var _local_5:XML;
            var _local_3:int;
            while (_local_3 < _arg_2.length())
            {
                _local_4 = _arg_2[_local_3];
                if (_local_4.children().length() == 0)
                {
                    if (_local_4.attribute("id").toString() == _arg_1)
                    {
                        return (_local_4);
                    }
                }
                else
                {
                    _local_5 = getCCOption(_arg_1, _local_4.children());
                    if (_local_5 != null)
                    {
                        return (_local_5);
                    }
                }
                _local_3++;
            }
            return (null);
        }

        private function chat_btnSend(_arg_1:MouseEvent) : void
        {
            var text:String = game.ui.mcInterface.te.htmlText;
            text = text.replace(regExpLinking1, "$1");
            text = text.replace(regExpLinking2, "$1");
            text = text.replace(regExpLinking3, '<A HREF="$1">$2</A>');
            game.mixer.playSound("Click");
            submitMsg(text, chn.cur.typ, pmNm);
            game.stage.focus = null;
        }

        private function chat_tebgClick(_arg_1:MouseEvent):*
        {
            if (game.stage.focus != game.ui.mcInterface.te)
            {
                openMsgEntry();
            }
        }

        private function chat_linkHandler(_arg_1:TextEvent):*
        {
            var _local_2:String;
            var _local_3:String;
            _local_2 = String(_arg_1.text.split(",")[0]);
            switch (_local_2)
            {
                case "openPMsg":
                    pmMode = 1;
                    _local_3 = String(_arg_1.text.split(",")[1]);
                    openPMsg(_local_3);
                    return;
            }
        }

        internal function onMouseWheelEvent(_arg_1:MouseEvent):void
        {
            var _local_2:*;
            if (game.ui.mcInterface.t1.hitTestPoint(_arg_1.stageX, _arg_1.stageY))
            {
                _local_2 = t1Arr.length;
                if (_arg_1.delta > 0)
                {
                    if (panelIndex > 0)
                    {
                        panelIndex--;
                    }
                }
                else
                {
                    if (panelIndex < (t1Arr.length - 1))
                    {
                        panelIndex++;
                    }
                }
                writeText(panelIndex, "");
            }
        }

        internal function resetAreaChannels():*
        {
            chn.zone.act = 0;
            chn.trade.act = 0;
        }

        public function popBubble(name:String, message:String, test:AvatarMC = null, kill:Number = 3000): void
        {
            var avt:AvatarMC = null;
            var target:String = name.split(":")[0];

            name = name.substr(2);

            switch (target)
            {
                case "u":
                    avt = game.world.getMCByUserName(name);
                    break;
            }

            if (test != null && avt == null)
            {
                avt = test;
            }

            if (avt != null)
            {
                avt.bubble.ti.autoSize = TextFieldAutoSize.CENTER;
                avt.bubble.ti.wordWrap = true;
                avt.bubble.ti.htmlText = message;
                avt.bubble.bg.width = int((avt.bubble.ti.textWidth + 12));
                avt.bubble.bg.height = int((avt.bubble.ti.textHeight + 8));
                avt.bubble.y = ((avt.pname.y - avt.bubble.bg.height) - 4);
                avt.bubble.bg.x = (0 - (avt.bubble.bg.width / 2));
                avt.bubble.arrow.y = ((avt.bubble.bg.y + avt.bubble.bg.height) - 2);
                avt.bubble.visible = true;
                avt.bubble.alpha = 100;
                if (avt.kv == null)
                {
                    avt.kv = new Killvis();
                    avt.kv.kill(avt.bubble, kill);
                }
                else
                {
                    avt.kv.resetkill();
                }
            }

        }

//        internal function popBubble(_arg_1:*, _arg_2:*, _arg_3:*):*
//        {
//            var _local_6:int;
//            var _local_7:int;
//            var _local_8:*;
//            var _local_9:*;
//            var _local_10:Array;
//            var _local_11:Rectangle;
//            var _local_12:Rectangle;
//            var _local_4:* = null;
//            var _local_5:* = _arg_1.split(":")[0];
//            _arg_1 = _arg_1.substr(2);
//            switch (_local_5)
//            {
//                case "u":
//                    _local_4 = game.world.getMCByUserName(_arg_1);
//                    break;
//            }
//            if (_local_4 != null)
//            {
//                _local_6 = 0;
//                _local_7 = 0;
//                _local_8 = 0;
//
//                while (_local_6 < _local_4.bubble.numChildren)
//                {
//                    _local_7 = 0;
//                    while (_local_7 < emojis.length)
//                    {
//                        try
//                        {
//                            _local_4.bubble.removeChild(emojis[_local_7]);
//                            emojis.splice(_local_7, 1);
//                        }
//                        catch(e:Error)
//                        {
//                        }
//                        _local_7++;
//                    }
//                    _local_6++;
//                }
//
//                _local_4.bubble.ti.autoSize = TextFieldAutoSize.CENTER;
//                _local_4.bubble.ti.wordWrap = true;
//                _local_4.bubble.ti.htmlText = _arg_2;
//
//                _local_9 = -1;
//                _local_10 = _local_4.bubble.ti.text.match(/\(hpy\)|\(sad\)|\(ble\)|\(bls\)|\(cry\)|\(agy\)|\(wnk\)|\(lgh\)|\(lol\)|\(kis\)|\(flk\)/gi);
//                _local_6 = 0;
//
//                while (_local_6 < _local_10.length)
//                {
//                    emoji = null;
//                    _local_4.bubble.ti.htmlText = _local_4.bubble.ti.htmlText.replace(_local_10[_local_6], "<font color='#FFFFFF'>.  ||  .</font>");
//                    _local_9 = _local_4.bubble.ti.text.indexOf("  ||  ", (_local_9 + 1));
//                    _local_11 = _local_4.bubble.ti.getCharBoundaries(_local_9);
//                    _local_12 = _local_4.bubble.ti.getCharBoundaries((_local_9 + 7));
//                    switch (_local_10[_local_6])
//                    {
//                        case "(hpy)":
//                            emoji = new emojiDefaultSmile();
//                            break;
//                        case "(sad)":
//                            emoji = new emojiDefaultSad();
//                            break;
//                        case "(ble)":
//                            emoji = new emojiDefaultBleh();
//                            break;
//                        case "(bls)":
//                            emoji = new emojiDefaultBlush();
//                            break;
//                        case "(cry)":
//                            emoji = new emojiDefaultCry();
//                            break;
//                        case "(agy)":
//                            emoji = new emojiDefaultAngry();
//                            break;
//                        case "(wnk)":
//                            emoji = new emojiDefaultWink();
//                            break;
//                        case "(lgh)":
//                            emoji = new emojiDefaultLaugh();
//                            break;
//                        case "(lol)":
//                            emoji = new emojiDefaultROFL();
//                            break;
//                        case "(kis)":
//                            emoji = new emojiDefaultKiss();
//                            break;
//                        case "(flk)":
//                            emoji = new emojiDefaultFlyKiss();
//                            break;
//                    }
//
//                    emoji.x = (_local_4.bubble.ti.x + _local_11.x);
//                    emoji.y = (_local_4.bubble.ti.y + _local_11.y);
//                    emoji.width = 21;
//                    emoji.height = 15;
//                    _local_4.bubble.addChild(emoji);
//                    emojis.push(emoji);
//                    _local_6++;
//                }
//
//                _local_4.bubble.bg.width = int((_local_4.bubble.ti.textWidth + 12));
//                _local_4.bubble.bg.height = int((_local_4.bubble.ti.textHeight + 8));
//                _local_4.bubble.y = ((_local_4.pname.y - _local_4.bubble.bg.height) - 4);
//                _local_4.bubble.bg.x = (0 - (_local_4.bubble.bg.width / 2));
//                _local_4.bubble.arrow.y = ((_local_4.bubble.bg.y + _local_4.bubble.bg.height) - 2);
//                _local_4.bubble.visible = true;
//                _local_4.bubble.alpha = 100;
//                if (_local_4.kv == null)
//                {
//                    _local_4.kv = new Killvis();
//                    _local_4.kv.kill(_local_4.bubble, 3000);
//                }
//                else
//                {
//                    _local_4.kv.resetkill();
//                }
//            }
//        }

        private function getRoomType(_arg_1:*):*
        {
            if (_arg_1.indexOf("trade") > -1)
            {
                return ("trade");
            }
            if (_arg_1.indexOf("party") > -1)
            {
                return ("party");
            }
            return ("zone");
        }

        public function formatMsgEntry(_arg_1:*):*
        {
            trace("formatMsgEntry");
            trace("formatMsgEntry > " + JSON.stringify(chn));

            game.ui.mcInterface.te.setSelection(0, 0);
            if (chn.cur != chn.whisper)
            {
                if (chn.cur == chn.zone)
                {
                    game.ui.mcInterface.tt.text = "";
                    game.ui.mcInterface.tt.visible = false;
                }
                else
                {
                    game.ui.mcInterface.tt.text = (chn.cur.tag + ": ");
                    game.ui.mcInterface.tt.visible = true;
                }
            }
            else
            {
                if (((typeof(_arg_1) == "undefined") || (_arg_1 == "")))
                {
                    game.ui.mcInterface.tt.text = "";
                    game.ui.mcInterface.tt.visible = false;
                }
                else
                {
                    pmNm = _arg_1;
                    game.ui.mcInterface.tt.text = (("To " + _arg_1) + ": ");
                    game.ui.mcInterface.tt.visible = true;
                }
            }
        }

        public function updateMsgEntry():*
        {
            game.ui.mcInterface.te.x = ((game.ui.mcInterface.tt.x + game.ui.mcInterface.tt.textWidth) + ((game.ui.mcInterface.tt.text.length) ? 1 : 0));
            game.ui.mcInterface.te.width = ((game.ui.mcInterface.bsend.x - game.ui.mcInterface.te.x) - 3);
            game.ui.mcInterface.te.textColor = "0xFFFFFF";
            game.ui.mcInterface.tt.textColor = "0xFFFFFF";
        }

        private function checkMsgType(_arg_1:Event):*
        {
            var _local_4:*;
            var _local_5:*;
            var _local_6:*;
            var _local_7:*;
            var _local_2:* = game.ui.mcInterface.te.text;
            var _local_3:* = _local_2.split(" ");
            if (_local_3.length > 1)
            {
                _local_4 = _local_3[0];
                _local_5 = "";
                if (_local_4.charAt(0) == "/")
                {
                    switch (_local_4.substr(1))
                    {
                        case "1":
                        case "s":
                        case "say":
                            if (chn.zone.act)
                            {
                                chn.cur = chn.zone;
                                chn.lastPublic = chn.zone;
                                game.ui.mcInterface.te.text = game.ui.mcInterface.te.text.substr((_local_4.substr(1).length + 2));
                            }
                            formatMsgEntry("");
                            updateMsgEntry();
                            break;
                        case "2":
                            if (chn.trade.act)
                            {
                                chn.cur = chn.trade;
                                chn.lastPublic = chn.trade;
                                game.ui.mcInterface.te.text = game.ui.mcInterface.te.text.substr(3);
                            }
                            formatMsgEntry("");
                            updateMsgEntry();
                            break;
                        case "p":
                            if (chn.party.act)
                            {
                                chn.cur = chn.party;
                                chn.lastPublic = chn.party;
                                game.ui.mcInterface.te.text = game.ui.mcInterface.te.text.substr(3);
                            }
                            formatMsgEntry("");
                            updateMsgEntry();
                            break;
                        case "r":
                            if (pmSourceA.length)
                            {
                                pmMode = 1;
                                chn.cur = chn.whisper;
                                game.ui.mcInterface.te.text = game.ui.mcInterface.te.text.substr(3);
                                formatMsgEntry(pmSourceA[0]);
                                updateMsgEntry();
                            }
                            break;
                        case "tell":
                        case "w":
                            if (_local_3.length > 2)
                            {
                                pmMode = 1;
                                chn.cur = chn.whisper;
                                game.ui.mcInterface.te.text = game.ui.mcInterface.te.text.substr(((_local_3[0].length + _local_3[1].length) + 1));
                                formatMsgEntry(_local_3[1]);
                                updateMsgEntry();
                            }
                            break;
                        case "c":
                            pmMode = 2;
                            chn.cur = chn.whisper;
                            game.ui.mcInterface.te.text = game.ui.mcInterface.te.text.substr(((_local_3[0].length + _local_3[1].length) + 1));
                            formatMsgEntry(pmSourceA[0]);
                            updateMsgEntry();
                            break;
                        case "g":
                            if (chn.guild.act)
                            {
                                chn.cur = chn.guild;
                                chn.lastPublic = chn.guild;
                                game.ui.mcInterface.te.text = game.ui.mcInterface.te.text.substr(3);
                            }
                            formatMsgEntry("");
                            updateMsgEntry();
                            break;
                        case "world":
                            if (chn.world.act)
                            {
                                chn.cur = chn.world;
                                chn.lastPublic = chn.world;
                                game.ui.mcInterface.te.text = game.ui.mcInterface.te.text.substr(7);
                            }
                            formatMsgEntry("");
                            updateMsgEntry();
                            break;
                    }
                }
                if (_local_4.charAt(0) == ">")
                {
                    if (pmSourceA.length)
                    {
                        pmMode = 1;
                        chn.cur = chn.whisper;
                        game.ui.mcInterface.te.text = game.ui.mcInterface.te.text.substr(2);
                        formatMsgEntry(pmSourceA[0]);
                        updateMsgEntry();
                    }
                }
                _local_6 = [];
                if (((_local_2.indexOf(" > ") > 1) && ((_local_2.indexOf("<") == -1) || (_local_2.indexOf(" > ") < _local_2.indexOf("<")))))
                {
                    _local_7 = _local_2.split(">");
                    while (_local_7[0].charAt((_local_7[0].length - 1)) == " ")
                    {
                        _local_7[0] = _local_7[0].substr(0, (_local_7[0].length - 1));
                    }
                    pmMode = 1;
                    chn.cur = chn.whisper;
                    game.ui.mcInterface.te.text = _local_7[1];
                    formatMsgEntry(_local_7[0]);
                    updateMsgEntry();
                }
            }
        }

        public function openMsgEntry() : void
        {
            pmI = 0;
            myMsgsI = 0;
            game.ui.mcInterface.tebg.addEventListener(MouseEvent.CLICK, chat_tebgClick);
            game.ui.mcInterface.te.visible = true;
            game.ui.mcInterface.te.type = TextFieldType.INPUT;
            game.stage.focus = null;
            game.stage.focus = game.ui.mcInterface.te;
            formatMsgEntry(pmNm);
            updateMsgEntry();
        }

        public function openPMsg(_arg_1:*) : void
        {
            pmNm = _arg_1;
            chn.cur = chn.whisper;
            openMsgEntry();
        }

        public function closeMsgEntry() : void
        {
            game.ui.mcInterface.tebg.addEventListener(MouseEvent.CLICK, chat_tebgClick);
            game.ui.mcInterface.te.text = "";
            game.ui.mcInterface.tt.text = "";
            game.ui.mcInterface.te.visible = false;
            game.ui.mcInterface.tt.visible = false;
            if (pmMode != 2)
            {
                chn.cur = chn.lastPublic;
            }
            game.ui.mcInterface.te.type = TextFieldType.DYNAMIC;
            game.stage.focus = null;
        }

        public function cleanStr(_arg_1:String, _arg_2:Boolean=true, _arg_3:Boolean=false, _arg_4:Boolean=false):*
        {
            _arg_1 = _arg_1.split("&#").join("");
            if (!_arg_4)
            {
                _arg_1 = _arg_1.split("#038:").join("");
            }
            else
            {
                _arg_1 = _arg_1.split("#038:#").join("");
            }
//            if (_arg_3)
//            {
//                _arg_1 = removeHTML(_arg_1);
//            }
            if (_arg_1.indexOf("%") > -1)
            {
                _arg_1 = _arg_1.split("%").join("#037:");
            }
            if (((_arg_2) && (_arg_1.indexOf("#037:") > -1)))
            {
                _arg_1 = _arg_1.split("#037:").join("%");
            }
//            if (_arg_1.indexOf("&") > -1)
//            {
//                _arg_1 = _arg_1.split("&").join("#038:");
//            }
//            if (((_arg_2) && (_arg_1.indexOf("#038:") > -1)))
//            {
//                _arg_1 = _arg_1.split("#038:").join("&");
//            }
//            if (_arg_1.indexOf("<") > -1)
//            {
//                _arg_1 = _arg_1.split("<").join("#060:");
//            }
//            if (((_arg_2) && (_arg_1.indexOf("#060:") > -1)))
//            {
//                _arg_1 = _arg_1.split("#060:").join("&lt;");
//            }
//            if (_arg_1.indexOf(">") > -1)
//            {
//                _arg_1 = _arg_1.split(">").join("#062:");
//            }
//            if (((_arg_2) && (_arg_1.indexOf("#062:") > -1)))
//            {
//                _arg_1 = _arg_1.split("#062:").join("&gt;");
//            }
//            if (_arg_2)
//            {
//                _arg_1 = removeHTML(_arg_1);
//            }
            return (_arg_1);
        }

        public function cleanChars(_arg_1:String):String
        {
            _arg_1 = _arg_1.replace(regExpMod, "");
            var _local_2:int;
            while (_local_2 < _arg_1.length)
            {
                if (legalChars.indexOf(_arg_1.charAt(_local_2)) < 0)
                {
                    _arg_1 = _arg_1.replace(_arg_1.charAt(_local_2), "?");
                }
                _local_2++;
            }
            return (_arg_1);
        }

        public function strContains(_arg_1:String, _arg_2:Array):Boolean
        {
            var _local_3:int;
            while (_local_3 < _arg_2.length)
            {
                if (_arg_1.indexOf(_arg_2[_local_3]) > -1)
                {
                    return (true);
                }
                _local_3++;
            }
            return (false);
        }

        public function submitMsg(msg:String, typ:*, unm:*, isMulti:Boolean=false):*
        {
            var tuo:* = undefined;
            var uName:String;
            var rmId:int;
            var tuoNm:String;
            var parta:* = undefined;
            var partb:String;
            var i:int;
            var multiO:Object;
            var strPassword:* = undefined;
            var uoData:* = undefined;
            var modal:MovieClip;
            var modalO:* = undefined;
            var strA:String;
            var ei:int;
            var xtArr:* = undefined;
            var cmd:* = undefined;
            var params:* = undefined;
            var paramStr:* = undefined;
            var s:* = undefined;
            var bAch:* = undefined;
            var uVars:* = undefined;
            var avt:* = undefined;
            var guildName:String;
            var strMap:String;
            var m:uint;
            var emStr:* = undefined;
            var index:int;
            var myAvatar:Avatar;
            var profanityResult:Object;
            var iDiff:Number;
            var iHrs:int;
            var iMins:int;
            msg = cleanChars(msg);
            var msgOK:Boolean = true;
            var warningModal:Boolean = true;
            var strEmail:String;
            if (Game.loginInfo.strPassword != null)
            {
                strPassword = Game.loginInfo.strPassword.toLowerCase();
                if (msg.toLowerCase().indexOf(strPassword) > -1)
                {
                    msgOK = false;
                }
            }
            if (((!(game.world == null)) && (!(game.world.myAvatar == null))))
            {
                if (((game.world.myAvatar.items == null) || (game.world.myAvatar.items.length < 1)))
                {
                    msgOK = false;
                    warningModal = false;
                    pushMsg("warning", "Character is still being loaded, please wait a moment.", "SERVER", "", 0);
                }
                if (game.world.myAvatar.objData != null)
                {
                    uoData = game.world.myAvatar.objData;
                    if (uoData.strEmail != null)
                    {
                        strEmail = uoData.strEmail.toLowerCase();
                    }
                    if (((!(strEmail == null)) && (strEmail.length > 5)))
                    {
                        if (msg.toLowerCase().indexOf(strEmail) > -1)
                        {
                            msgOK = false;
                        }
                    }
                }
            }
            if (((!(msgOK)) && (warningModal)))
            {
                modal = new ModalMC();
                modalO = {};
                modalO.strBody = "Never give your password or email to anyone. Please note that AQWorlds staff will never ask for your password or email. We do not need that information to look up your account.";
                modalO.callback = null;
                modalO.btns = "mono";
                game.ui.ModalStack.addChild(modal);
                modal.init(modalO);
                strA = "";
                ei = 0;
                if (strEmail != null)
                {
                    if (msg.indexOf(strEmail) > -1)
                    {
                        ei = 0;
                        while (ei < strEmail.length)
                        {
                            strA = (strA + ((ei == 0) ? strEmail.charAt(0) : "*"));
                            ei = (ei + 1);
                        }
                        msg = msg.split(strEmail).join(strA);
                    }
                }
                ei = 0;
                strA = "";
                if (msg.indexOf(strPassword) > -1)
                {
                    ei = 0;
                    while (ei < strPassword.length)
                    {
                        strA = (strA + ((ei == 0) ? strPassword.charAt(0) : "*"));
                        ei = (ei + 1);
                    }
                    msg = msg.split(strPassword).join(strA);
                }
                pushMsg("warning", msg, "SERVER", "", 0);
                closeMsgEntry();
                return;
            }
            i = 0;
            var str:* = game.stripWhite(msg);
            if (str.length)
            {
                myMsgs.push(msg);
                xtArr = [];
                cmd = "";
                if (msg.substr(0, 1) == "/")
                {
                    params = msg.substr(1).split(" ");
                    paramStr = params[0].toLowerCase();
                    switch (paramStr)
                    {
                        case "multi":
                            msg = ("/" + msg.substr(7));
                            submitMsg(msg, typ, unm, true);
                            return;
                        case "reload":
                            cmd = null;
                            if (game.world.myAvatar.isStaff())
                            {
                                game.world.reloadCurrentMap();
                            }
                            break;
                        case "cell":
                            cmd = null;
                            if (game.world.myAvatar.objData.intAccessLevel >= 40)
                            {
                                if (params.length > 1)
                                {
                                    parta = params[1];
                                }
                                else
                                {
                                    parta = "none";
                                }
                                if (params.length > 2)
                                {
                                    partb = params[2];
                                }
                                else
                                {
                                    partb = "none";
                                }
                                if (parta != "none")
                                {
                                    game.world.moveToCell(parta, partb);
                                }
                            }
                            break;
                        case "shop":
                            cmd = null;
                            if (game.world.myAvatar.objData.intAccessLevel >= 40)
                            {
                                if (params.length > 1)
                                {
                                    parta = int(params[1]);
                                }
                                else
                                {
                                    parta = 1;
                                }
                                game.world.sendLoadShopRequest(parta);
                            }
                            break;
                        case "sound":
                            cmd = null;
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                if (params[1] == "off")
                                {
                                    game.mixer.bSoundOn = false;
                                }
                                else
                                {
                                    if (params[1] == "on")
                                    {
                                        game.mixer.bSoundOn = true;
                                    }
                                }
                            }
                            break;
                        case "ignore":
                            cmd = null;
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                tuoNm = params.slice(1).join(" ");
                                if (tuoNm.toLowerCase() != game.net.myUserName)
                                {
                                    cmd = "cmd";
                                    ignore(tuoNm);
                                    msg = ("You are now ignoring user " + tuoNm);
                                    pushMsg("server", msg, "SERVER", "", 0);
                                }
                                else
                                {
                                    msg = "You cannot ignore yourself!";
                                    pushMsg("warning", msg, "SERVER", "", 0);
                                }
                            }
                            break;
                        case "unignore":
                            cmd = null;
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                tuoNm = params.slice(1).join(" ");
                                cmd = "cmd";
                                unignore(tuoNm);
                                msg = (("User " + tuoNm) + " is no longer being ignored");
                                pushMsg("server", msg, "SERVER", "", 0);
                            }
                            break;
                        case "ignoreclear":
                            cmd = null;
                            ignoreList.data.users = [];
                            pushMsg("warning", "Ignore List Cleared!", "SERVER", "", 0);
                            game.net.send("cmd", ["ignoreList", "$clearAll"]);
                            break;
                        case "report":
                        case "reportlang":
                            cmd = null;
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                tuoNm = params.slice(1).join(" ");
                                game.ui.mcPopup.fOpen("Report", {"unm":tuoNm});
                            }
                            break;
                        case "reporthack":
                            cmd = null;
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                parta = params.split(":")[0];
                                partb = params.split(":")[1];
                                tuoNm = parta.slice(1).join(" ");
                                cmd = "cmd";
                                xtArr.push("reporthack");
                                xtArr.push(tuoNm);
                                xtArr.push(partb);
                            }
                            break;
                        case "modon":
                        case "modoff":
                            cmd = "cmd";
                            xtArr.push(params[0]);
                            break;
                        case "getinfo":
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                tuoNm = params.slice(1).join(" ");
                                cmd = "cmd";
                                xtArr.push(params[0]);
                                xtArr.push(tuoNm);
                            }
                            break;
                        case "size":
                            cmd = "cmd";
                            xtArr.push(params[0]);
                        case "getroomname":
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                cmd = "cmd";
                                xtArr.push(params[0]);
                                xtArr.push(params[1]);
                            }
                            break;
                        case "event":
                            if (params.length > 2)
                            {
                                cmd = "cmd";
                                xtArr.push(params[0]);
                                xtArr.push(params[1]);
                                xtArr.push(params.slice(2).join(" "));
                            }
                            break;
                        case "tfer":
                            if (((((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)) && (!(typeof(params[2]) == "undefined"))) && (params[2].length > 0)))
                            {
                                cmd = "cmd";
                                xtArr.push(params[0]);
                                xtArr.push(params[1]);
                                xtArr.push(params[2]);
                            }
                            break;
                        case "guild":
                            game.world.showGuildList();
                            break;
                        case "guildInvite":
                        case "gi":
                            cmd = null;
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                tuoNm = params.slice(1).join(" ");
                                game.world.guildInvite(tuoNm);
                            }
                            break;
                        case "guildremove":
                        case "gr":
                            cmd = null;
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                tuoNm = params.slice(1).join(" ");
                                avt = game.world.getAvatarByUserName(tuoNm);
                                if (((game.world.myAvatar.objData.guildRank >= 2) || (avt.isMyAvatar)))
                                {
                                    modal = new ModalMC();
                                    modalO = {};
                                    modalO.strBody = (("Do you want to remove " + tuoNm) + " from the guild?");
                                    modalO.callback = game.world.guildRemove;
                                    modalO.params = {"userName":tuoNm};
                                    modalO.btns = "dual";
                                    game.ui.ModalStack.addChild(modal);
                                    modal.init(modalO);
                                }
                            }
                            break;
                        case "guildPromote":
                        case "gp":
                            cmd = null;
                            if (game.world.myAvatar.objData.guildRank >= 2)
                            {
                                if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                                {
                                    tuoNm = params.slice(1).join(" ");
                                    game.world.guildPromote(tuoNm);
                                }
                            }
                            break;
                        case "guildDemote":
                        case "gd":
                            cmd = null;
                            if (game.world.myAvatar.objData.guildRank >= 2)
                            {
                                if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                                {
                                    tuoNm = params.slice(1).join(" ");
                                    game.world.guildDemote(tuoNm);
                                }
                            }
                            break;
                        case "motd":
                            if (msg.length == 5)
                            {
                                if (game.world.myAvatar.objData.guild != null)
                                {
                                    if (((!(game.world.myAvatar.objData.guild.MOTD == null)) && (!(String(game.world.myAvatar.objData.guild.MOTD) == "undefined"))))
                                    {
                                        pushMsg("guild", ("Message of the day: " + String(game.world.myAvatar.objData.guild.MOTD)), "SERVER", "", 0);
                                    }
                                    else
                                    {
                                        pushMsg("guild", "No Message of the day has been set.", "SERVER", "", 0);
                                    }
                                }
                            }
                            else
                            {
                                game.world.setGuildMOTD(msg.substr(5));
                            }
                            break;
                        case "gc":
                        case "guildcreate":
                            if (game.world.myAvatar.isUpgraded())
                            {
                                if (params[1].length > 0)
                                {
                                    guildName = params[1];
                                    i = 2;
                                    while (i < params.length)
                                    {
                                        guildName = ((guildName + " ") + params[i]);
                                        i = (i + 1);
                                    }
                                    if (guildName.length <= 25)
                                    {
                                        modal = new ModalMC();
                                        modalO = {};
                                        modalO.strBody = (("Do you want to create the guild " + guildName) + "?");
                                        modalO.callback = game.world.createGuild;
                                        modalO.params = {"guildName":guildName};
                                        modalO.btns = "dual";
                                        game.ui.ModalStack.addChild(modal);
                                        modal.init(modalO);
                                    }
                                    else
                                    {
                                        game.chatF.pushMsg("server", "Guild names must be 25 characters or less.", "SERVER", "", 0);
                                    }
                                }
                                else
                                {
                                    game.chatF.pushMsg("server", "Please specify a name for your guild.", "SERVER", "", 0);
                                }
                            }
                            else
                            {
                                game.chatF.pushMsg("server", "Only members may create guilds.", "SERVER", "", 0);
                            }
                            break;
                        case "renameGuild":
                        case "rg":
                            if (game.world.myAvatar.objData.guildRank == 3)
                            {
                                if (game.world.myAvatar.objData.intCoins >= 1000)
                                {
                                    if (params[1].length > 0)
                                    {
                                        guildName = params[1];
                                        i = 2;
                                        while (i < params.length)
                                        {
                                            guildName = ((String(guildName) + " ") + String(params[i]));
                                            i = (i + 1);
                                        }
                                        if (guildName.length <= 25)
                                        {
                                            modal = new ModalMC();
                                            modalO = {};
                                            modalO.strBody = (("Do you want to rename the guild to " + guildName) + "? This will cost 1000 ACs.");
                                            modalO.callback = game.world.renameGuild;
                                            modalO.params = {"guildName":guildName};
                                            modalO.btns = "dual";
                                            game.ui.ModalStack.addChild(modal);
                                            modal.init(modalO);
                                        }
                                        else
                                        {
                                            game.chatF.pushMsg("server", "Guild names must be 25 characters or less.", "SERVER", "", 0);
                                        }
                                    }
                                    else
                                    {
                                        game.chatF.pushMsg("server", "Please specify a name for your guild.", "SERVER", "", 0);
                                    }
                                }
                                else
                                {
                                    game.chatF.pushMsg("server", "You do not have enough ACs.", "SERVER", "", 0);
                                }
                            }
                            break;
                        case "addquest":
                        case "removequest":
                        case "forcestart":
                        case "forcestop":
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                try
                                {
                                    game.net.send("dynamic", [paramStr, params[1], params[2]]);
                                }
                                catch(e)
                                {
                                    game.net.send("dynamic", [paramStr, params[1]]);
                                }
                            }
                            break;
                        case "guildreset":
                            game.net.send("guild", ["guildreset"]);
                            break;
                        case "yuki":
                            rmId = chn.cur.rid;
                            cmd = "message";
                            msg = cleanStr(msg, false, true);
                            xtArr.push(msg.substring((msg.indexOf("//yuki ") + 6), msg.length));
                            xtArr.push(chn.cur.str);
                            xtArr.push("yuki");
                            break;
                        case "ginv":
                            cmd = null;
                            s = String(params[1]);
                            i = 2;
                            while (i < params.length)
                            {
                                s = ((s + " ") + String(params[i]));
                                i = (i + 1);
                            }
                            game.net.send("guild", ["gInv", s]);
                            break;
                        case "invite":
                        case "pi":
                            cmd = null;
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                tuoNm = params.slice(1).join(" ");
                                if (((game.world.partyMembers.length < 4) || (!(game.world.isPartyMember(tuoNm)))))
                                {
                                    game.world.partyInvite(tuoNm);
                                }
                            }
                            break;
                        case "ps":
                            cmd = null;
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                tuoNm = params.slice(1).join(" ");
                                game.world.partySummon(tuoNm);
                            }
                            break;
                        case "pk":
                            cmd = null;
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                tuoNm = params.slice(1).join(" ");
                                game.world.partyKick(tuoNm);
                            }
                            break;
                        case "duel":
                            cmd = null;
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                tuoNm = params.slice(1).join(" ");
                                game.world.sendDuelInvite(tuoNm);
                            }
                            break;
                        case "friends":
                            cmd = null;
                            game.togglePanel("friends");
                            break;
                        case "friend":
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                tuoNm = params.slice(1).join(" ");
                                if (tuoNm.toLowerCase() != game.net.myUserName)
                                {
                                    game.world.requestFriend(tuoNm);
                                }
                            }
                            break;
                        case "modban":
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                cmd = "cmd";
                                tuoNm = params.slice(1).join(" ");
                                xtArr.push(params[0]);
                                xtArr.push(tuoNm);
                                xtArr.push(24);
                            }
                            break;
                        case "join":
                            if (((((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)) && (!(game.world.uoTree[game.net.myUserName].intState == 0))) && (game.world.coolDown("tfer"))))
                            {
                                game.world.returnInfo = null;
                                cmd = "cmd";
                                uName = game.net.myUserName;
                                strMap = params[1];
                                if (params.length > 2)
                                {
                                    m = 2;
                                    while (m < params.length)
                                    {
                                        strMap = ((strMap + " ") + params[m]);
                                        m++;
                                    }
                                }
                                xtArr.push("tfer");
                                xtArr.push(game.net.myUserName);
                                xtArr.push(strMap);
                            }
                            break;
                        case "roomid":
                            cmd = "cmd";
                            xtArr.push("roomID");
                            xtArr.push(game.net.myUserName);
                            xtArr.push(params[1]);
                            break;
                        case "house":
                            cmd = null;
                            if (params[1] == null)
                            {
                                tuoNm = game.net.myUserName;
                            }
                            else
                            {
                                tuoNm = params.slice(1).join(" ");
                            }
                            game.world.gotoHouse(tuoNm);
                            break;
                        case "kick":
                        case "ipkick":
                        case "ipunmute":
                        case "unmute":
                        case "freeze":
                        case "unfreeze":
                        case "watch":
                        case "unwatch":
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                cmd = "cmd";
                                tuoNm = params.slice(1).join(" ");
                                xtArr.push(params[0]);
                                xtArr.push(tuoNm);
                            }
                            break;
                        case "mute":
                        case "ban":
                        case "ipmute":
                            if ((((game.world.myAvatar.isStaff()) && (!(typeof(params[1]) == "undefined"))) && (params[1].length > 0)))
                            {
                                cmd = "cmd";
                                tuoNm = params.slice(2).join(" ");
                                xtArr.push(params[0]);
                                xtArr.push(params[1]);
                                xtArr.push(tuoNm);
                            }
                            break;
                        case "goto":
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                cmd = null;
                                game.world._SafeStr_1(params.slice(1).join(" "));
                            }
                            break;
                        case "pull":
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                cmd = null;
                                game.world.pull(params.slice(1).join(" "));
                            }
                            break;
                        case "clear":
                        case "bonus":
                        case "boost":
                            if (params.length > 1)
                            {
                                cmd = "cmd";
                                i = 0;
                                while (i < params.length)
                                {
                                    xtArr.push(params[i]);
                                    i = (i + 1);
                                }
                            }
                            break;
                        case "frostreset":
                            cmd = "cmd";
                            xtArr.push("frostreset");
                            break;
                        case "queue":
                            cmd = "cmd";
                            xtArr.push(params[0]);
                            break;
                        case "killmap":
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                cmd = "cmd";
                                xtArr.push(params[0]);
                                xtArr.push(params[1]);
                            }
                            break;
                        case "item":
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                cmd = "cmd";
                                xtArr.push(params[0]);
                                xtArr.push(params[1]);
                                xtArr.push(params[2]);
                            }
                            break;
                        case "combat":
                            cmd = "cmd";
                            xtArr.push(params[0]);
                            xtArr.push(params[1]);
                            break;
                        case "addrep":
                        case "addxp":
                        case "addv":
                        case "hp":
                        case "level":
                        case "getevents":
                        case "getevent":
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                cmd = "cmd";
                                xtArr.push(params[0]);
                                xtArr.push(params[1]);
                            }
                            break;
                        case "datadump":
                        case "monitor":
                        case "resetevents":
                        case "resetlogins":
                        case "resetgrove":
                        case "resettimes":
                        case "getlogins":
                        case "gettimes":
                        case "clock":
                        case "whitelist":
                            cmd = "cmd";
                            i = 0;
                            while (i < params.length)
                            {
                                xtArr.push(params[i]);
                                i = (i + 1);
                            }
                            break;
                        case "getbreakdown":
                            cmd = "cmd";
                            xtArr.push(params[0]);
                            break;
                        case "adminyell":
                        case "iay":
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                cmd = "cmd";
                                xtArr.push(params[0]);
                                msg = params.slice(1).join(" ");
                                msg = cleanStr(msg, false, true);
                                xtArr.push(msg);
                            }
                            break;
                        case "iteratortest":
                            cmd = "cmd";
                            xtArr.push(params[0]);
                            break;
                        case "mod":
                            cmd = "cmd";
                            xtArr.push(params[0]);
                            break;
                        case "pmoff":
                            cmd = "cmd";
                            xtArr.push(params[0]);
                            xtArr.push(msg.substr(7));
                            break;
                        case "pmon":
                        case "partyon":
                        case "partyoff":
                        case "chaton":
                        case "chatoff":
                        case "friendon":
                        case "friendoff":
                        case "waron":
                        case "waroff":
                        case "kickall":
                        case "restart":
                        case "restartnow":
                        case "shutdown":
                        case "shutdownnow":
                        case "empty":
                            cmd = "cmd";
                            xtArr.push(params[0]);
                            break;
                        case "roll":
                            cmd = "util";
                            xtArr.push(params[0]);
                            break;
                        case "geta":
                            if (((game.world.myAvatar.isStaff()) && (params.length == 3)))
                            {
                                pushMsg("warning", ((((("geta " + params[1]) + ",") + params[2]) + ": ") + game.world.getAchievement(params[1], params[2])), "SERVER", "", 0);
                            }
                            break;
                        case "seta":
                            if (((game.world.myAvatar.isStaff()) && (params.length == 4)))
                            {
                                game.world.setAchievement(params[1], params[2], params[3]);
                            }
                            break;
                        case "queststring":
                            if (game.world.myAvatar.isStaff())
                            {
                                game.world.loadQuestStringData();
                                cmd = "cmd";
                                i = 0;
                                while (i < params.length)
                                {
                                    xtArr.push(params[i]);
                                    i = (i + 1);
                                }
                            }
                            break;
                        case "e":
                        case "me":
                        case "em":
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                emStr = params.slice(1).join(" ");
                                emStr = cleanStr(emStr, false, true);
                                rmId = chn.cur.rid;
                                cmd = "em";
                                xtArr.push(emStr);
                                xtArr.push(chn.event.str);
                            }
                            break;
                        case "who":
                            cmd = "cmd";
                            xtArr.push(params[0]);
                            if (((!(typeof(params[1]) == "undefined")) && (params[1].length > 0)))
                            {
                                xtArr.push(params[1]);
                            }
                            break;
                        case "afk":
                            cmd = null;
                            game.world.afkToggle();
                            break;
                        case "rest":
                            game.world.rest();
                            break;
                        case "repairavatars":
                            cmd = null;
                            game.world.repairAvatars();
                            break;
                        case "samba":
                            bAch = game.world.getAchievement("ia0", 11);
                            if (!bAch)
                            {
                                pushMsg("warning", "You must learn this dance from Samba in Bloodtusk Ravine.", "SERVER", "", 0);
                                break;
                            }
                            if (!game.world.myAvatar.isUpgraded())
                            {
                                pushMsg("warning", "Requires membership to use this emote.", "SERVER", "", 0);
                                break;
                            }
                        case "danceweapon":
                            if (!game.world.myAvatar.isUpgraded())
                            {
                                pushMsg("warning", "Requires membership to use this emote.", "SERVER", "", 0);
                                break;
                            }
                        case "useweapon":
                            if (!game.world.myAvatar.isUpgraded())
                            {
                                pushMsg("warning", "Requires membership to use this emote.", "SERVER", "", 0);
                                break;
                            }
                        case "powerup":
                        case "kneel":
                        case "jumpcheer":
                        case "salute2":
                        case "cry2":
                        case "spar":
                        case "stepdance":
                        case "headbang":
                        case "dazed":
                            if (!game.world.myAvatar.isUpgraded())
                            {
                                pushMsg("warning", "Requires membership to use this emote.", "SERVER", "", 0);
                                break;
                            }
                        case "dance":
                        case "laugh":
                        case "lol":
                        case "point":
                        case "use":
                        case "fart":
                        case "backflip":
                        case "sleep":
                        case "jump":
                        case "punt":
                        case "dance2":
                        case "swordplay":
                        case "feign":
                        case "wave":
                        case "bow":
                        case "cry":
                        case "unsheath":
                        case "cheer":
                        case "stern":
                        case "salute":
                        case "airguitar":
                        case "facepalm":
						case "mining":
                            uVars = {};
                            cmd = (uVars.typ = "emotea");
                            uVars.strEmote = paramStr;
                            if (uVars.strEmote == "lol")
                            {
                                uVars.strEmote = "laugh";
                            }
                            uVars.strChar = params[1];
                            break;
                        case "updatecharacterimage":
                            SwfToImageConverter.updateCharacterImage();
                            break;
                        case "updatemapimages":
                            SwfToImageConverter.convertMapsToImages();
                            break;
                        default:
                            if (((unm == "iterator") || (game.world.myAvatar.isStaff())))
                            {
                                cmd = "cmd";
                                index = 0;
                                while (index < params.length)
                                {
                                    xtArr.push(params[index]);
                                    index = (index + 1);
                                }
                            }
                    }
                    if (cmdHistory.indexOf(msg) == -1)
                    {
                        cmdHistory.push(msg);
                        if (cmdHistory.length > 10)
                        {
                            cmdHistory.shift();
                        }
                        rebuildHistory();
                    }
                }
                else
                {
                    if (typ != "whisper")
                    {
                        rmId = chn.cur.rid;
                        cmd = "message";
                        msg = cleanStr(msg, false, true);
                        xtArr.push(msg);
                        xtArr.push(chn.cur.str);
                    }
                    else
                    {
                        rmId = 1;
                        cmd = "whisper";
                        msg = cleanStr(msg, false, true);
                        xtArr.push(msg);
                        xtArr.push(unm);
                    }
                }
                if (cmd == "emotea")
                {
                    game.world.myAvatar.pMC.mcChar.gotoAndPlay(game.strToProperCase(uVars.strEmote));
                    game.net.send(cmd, [uVars.strEmote]);
                }
                else
                {
                    if (((cmd == "mod") || (cmd == "cmd")))
                    {
                        if (xtArr.length)
                        {
                            game.net.send(cmd, xtArr);
                        }
                    }
                    else
                    {
                        if (cmd != "simple" || cmd != null || xtArr.length < 1)
                        {
                            game.world.afkPostpone();
                            myAvatar = game.world.myAvatar;
                            profanityResult = {};
                            profanityResult = profanityCheck(cleanStr(msg));
                            if (iChat == 0)
                            {
                                pushMsg("warning", "This server only allows canned chat.", "SERVER", "", 0);
                            }
                            else if (((((iChat == 1) && (!(game.world.myAvatar.hasUpgraded()))) && (!(game.world.myAvatar.isVerified()))) && (!(game.world.myAvatar.isStaff()))))
                            {
                                pushMsg("warning", "Chat is a members-only feature at this time.", "SERVER", "", 0);
                            }
                            else if (myAvatar.objData.bPermaMute == 1)
                            {
                                pushMsg("warning", "You are mute! Chat privileges have been permanently revoked.", "SERVER", "", 0);
                            }
                            else if (((!(myAvatar.objData.dMutedTill == null)) && (myAvatar.objData.dMutedTill.getTime() > game.date_server.getTime())))
                            {
                                iDiff = ((myAvatar.objData.dMutedTill.getTime() - game.date_server.getTime()) / 1000);
                                iHrs = int((iDiff / (60 * 60)));
                                iMins = int(((iDiff - ((iHrs * 60) * 60)) / 60));
                                pushMsg("warning", (((("You are mute! Chat privileges have been revoked for next " + iHrs) + " h ") + iMins) + " m!"), "SERVER", "", 0);
                            }
                            else if (amIMute())
                            {
                                pushMsg("warning", "You are mute! Chat privileges have been temporarily revoked.", "SERVER", "", 0);
                            }
                            else if (profanityResult.code == 1)
                            {
                                pushMsg("warning", (("Do not use inappropriate language such as '" + profanityResult.term) + "'."), "SERVER", "", 0);
                                game.world.selfMute(2);
                            }
                            else if (profanityResult.code == 2)
                            {
                                pushMsg("warning", (("Please do not use inappropriate language such as '" + profanityResult.term) + "'."), "SERVER", "", 0);
                            }
                            else if (isUnsendable(msg))
                            {
                                pushMsg("warning", "Please do not send messages that may contain private information, such as an email address.", "SERVER", "", 0);
                            }
                            else if (xtArr[0].length > 0)
                            {
                                game.net.send(cmd, xtArr);
                            }

                        }
                    }
                }
            }
            closeMsgEntry();
        }

        private function checkFieldsVPos(): void
        {
            game.ui.mcInterface.t1.resetVPos = 0;
            if (panelIndex == (t1Arr.length - 1))
            {
                game.ui.mcInterface.t1.resetVPos = 1;
            }
        }

        private function setFieldsVPos():*
        {
            if (game.ui.mcInterface.t1.resetVPos)
            {
                panelIndex = this.t1Arr.length - 1;
            }
            panelIndex = Math.min(panelIndex, (t1Arr.length - 1));
        }

        private function html2Fields(_arg_1:*, _arg_2:*, _arg_3:*, _arg_4:*):void {
            switch (_arg_2) {
                case "=":
                default:
                    t1Arr = [{
                        "s": _arg_1,
                        "id": _arg_4
                    }];
                    break;
                case "+=":
                    if (t1Arr == null) {
                        t1Arr = [];
                    }
                    t1Arr.push({
                        "s": _arg_1,
                        "id": _arg_4
                    });
                    break;
            }
        }

//        private function html2Fields(_arg_1:*, _arg_2:*, _arg_3:*, _arg_4:*):*
//        {
//            switch (_arg_2)
//            {
//                case "=":
//                default:
//                    t1Arr = [{
//                        "s":_arg_1,
//                        "id":_arg_4
//                    }];
//                    return;
//                case "+=":
//                    t1Arr.push({
//                        "s":_arg_1,
//                        "id":_arg_4
//                    });
//                    break;
//            }
//        }

        public function checkItem(_arg_1:MovieClip):void
        {
            var _local_2:*;
            var _local_3:int;
            var _local_4:Array;
            var _local_5:Rectangle;
            var _local_6:Rectangle;
            try
            {
                _local_2 = -1;
                _local_3 = 0;
                _local_4 = newTextLine.ti.text.match(/\(hpy\)|\(sad\)|\(ble\)|\(bls\)|\(cry\)|\(agy\)|\(wnk\)|\(lgh\)|\(lol\)|\(kis\)|\(flk\)/gi);
                _local_3 = 0;
                while (_local_3 < _local_4.length)
                {
                    emoji = null;
                    newTextLine.ti.htmlText = newTextLine.ti.htmlText.replace(_local_4[_local_3], ".';");
                    _local_2 = newTextLine.ti.text.indexOf(".';", (_local_2 + 1));
                    _local_5 = newTextLine.ti.getCharBoundaries(_local_2);
                    _local_6 = newTextLine.ti.getCharBoundaries((_local_2 + 7));
                    switch (_local_4[_local_3])
                    {
                        case "(hpy)":
                            emoji = new emojiDefaultSmile();
                            break;
                        case "(sad)":
                            emoji = new emojiDefaultSad();
                            break;
                        case "(ble)":
                            emoji = new emojiDefaultBleh();
                            break;
                        case "(bls)":
                            emoji = new emojiDefaultBlush();
                            break;
                        case "(cry)":
                            emoji = new emojiDefaultCry();
                            break;
                        case "(agy)":
                            emoji = new emojiDefaultAngry();
                            break;
                        case "(wnk)":
                            emoji = new emojiDefaultWink();
                            break;
                        case "(lgh)":
                            emoji = new emojiDefaultLaugh();
                            break;
                        case "(lol)":
                            emoji = new emojiDefaultROFL();
                            break;
                        case "(kis)":
                            emoji = new emojiDefaultKiss();
                            break;
                        case "(flk)":
                            emoji = new emojiDefaultFlyKiss();
                            break;
                    }
                    emoji.x = (newTextLine.ti.x + _local_5.x);
                    emoji.y = (newTextLine.ti.y + _local_5.y);
                    emoji.width = 21;
                    emoji.height = 15;
                    _arg_1.addChild(emoji);
                    _local_3++;
                }
            }
            catch(e)
            {
            }
        }

        public function writeText(_arg_1:int, _arg_2:String):void
        {
            var _local_2:DisplayObject;
            var _local_3:MovieClip;
            var _local_6:int;
            var _local_4:* = true;
            var _local_5:Array = [];
            var _local_7:int;
            var _local_8:int;
            _local_7 = (t1Arr.length - 1);
            while (_local_7 > -1)
            {
                if (((_local_7 <= _arg_1) && (_local_4)))
                {
                    _local_8 = t1Arr[_local_7].id;
                    game.ui.mcInterface.textLine.ti.htmlText = t1Arr[_local_7].s;
                    formatWithoutTextLinks(game.ui.mcInterface.textLine.ti);
                    _local_6 = checkPos(game.ui.mcInterface.textLine, _local_7, _local_8, _arg_1);
                    if (_local_6 <= 0)
                    {
                        _local_4 = false;
                    }
                    else
                    {
                        _local_5.push(_local_8);
                        if (drawnA.indexOf(_local_8) > -1)
                        {
                            _local_2 = getBitmapByIndex(_local_8, game.ui.mcInterface.t1);
                        }
                        else
                        {
                            _local_2 = buildTextLinks(game.ui.mcInterface.textLine.ti, t1Arr[_local_7].s, game.ui.mcInterface.t1, drawnA, _local_8);
                        }
                        _local_2.y = _local_6;
                        MovieClip(_local_2).mouseEnabled = false;
                        checkItem(MovieClip(_local_2));
                    }
                }
                _local_7--;
            }
            _local_7 = 0;
            while (_local_7 < drawnA.length)
            {
                if (_local_5.indexOf(drawnA[_local_7]) < 0)
                {
                    _local_2 = getBitmapByIndex(drawnA[_local_7], game.ui.mcInterface.t1);
                    if (_local_2 != null)
                    {
                        game.ui.mcInterface.t1.removeChild(_local_2);
                        drawnA.splice(_local_7, 1);
                        _local_7--;
                    }
                }
                _local_7++;
            }
        }

        private function formatWithoutTextLinks(_arg_1:TextField):void
        {
            var _local_7:String;
            var _local_8:String;
            var _local_9:String;
            var _local_10:String;
            var _local_11:Array;
            var _local_12:String;
            var _local_13:String;
            var _local_14:int;
            var _local_15:String;
            var _local_16:String;
            var _local_2:* = "$({";
            var _local_3:* = "})$";
            var _local_4:* = '<font color="#';
            var _local_5:* = '">';
            var _local_6:* = "</font>";
            while (((_arg_1.htmlText.indexOf(_local_2) > -1) && (_arg_1.htmlText.indexOf(_local_3) > -1)))
            {
                _local_7 = _arg_1.htmlText;
                _local_8 = _local_7.substr(0, _local_7.indexOf(_local_2));
                _local_9 = _local_7.substr((_local_7.indexOf(_local_3) + _local_3.length));
                _local_10 = _local_7.substr((_local_7.indexOf(_local_2) + _local_2.length));
                _local_11 = _local_10.substr(0, _local_10.indexOf(_local_3)).split(",");
                _local_12 = _local_11[0];
                _local_13 = _local_11[1];
                _local_14 = _arg_1.text.indexOf(_local_2);
                switch (_local_12)
                {
                    case "url":
                        _local_16 = _local_13;
                        _local_15 = ((((((_local_4 + "FFFF99") + _local_5) + "<u>") + _local_16) + "</u>") + _local_6);
                        break;
                    case "user":
                        _local_16 = _local_13;
                        _local_15 = ((((_local_4 + "FFFFFF") + _local_5) + _local_16) + _local_6);
                        break;
                    case "item":
                    case "quest":
                        _local_16 = (("[" + _local_13) + "]");
                        _local_15 = ((((_local_4 + "00CCFF") + _local_5) + _local_16) + _local_6);
                        break;
                }
                _arg_1.htmlText = ((_local_8 + _local_15) + _local_9);
            }
        }

        private function buildTextLinks(_arg_1:TextField, _arg_2:String, _arg_3:MovieClip, _arg_4:Array, _arg_5:int):DisplayObject
        {
            var _local_13:String;
            var _local_14:String;
            var _local_15:String;
            var _local_16:String;
            var _local_17:Array;
            var _local_18:String;
            var _local_19:String;
            var _local_20:int;
            var _local_21:String;
            var _local_22:String;
            var _local_23:Object;
            var _local_24:*;
            var _local_25:*;
            var _local_26:int;
            var _local_27:int;
            var _local_28:int;
            var _local_29:*;
            var _local_30:Rectangle;
            var _local_31:Rectangle;
            var _local_32:MovieClip;
            var _local_33:*;
            var _local_34:String;
            var _local_6:MovieClip = new MovieClip();
            _local_6.name = ("b" + _arg_5);
            var _local_7:* = "$({";
            var _local_8:* = "})$";
            var _local_9:* = '<font color="#';
            var _local_10:* = '">';
            var _local_11:* = "</font>";
            _arg_1.htmlText = _arg_2;
            while (((_arg_1.htmlText.indexOf(_local_7) > -1) && (_arg_1.htmlText.indexOf(_local_8) > -1)))
            {
                _local_13 = _arg_1.htmlText;
                _local_14 = _local_13.substr(0, _local_13.indexOf(_local_7));
                _local_15 = _local_13.substr((_local_13.indexOf(_local_8) + _local_8.length));
                _local_16 = _local_13.substr((_local_13.indexOf(_local_7) + _local_7.length));
                _local_17 = _local_16.substr(0, _local_16.indexOf(_local_8)).split(",");
                _local_18 = _local_17[0];
                _local_19 = _local_17[1];

                trace("BUILD TEXT LINKS => 1 " + _local_17);
                trace("BUILD TEXT LINKS => 2 " + JSON.stringify(_local_17));

                _local_19 = _local_19.split("&amp;").join("&");
                _local_20 = _arg_1.text.indexOf(_local_7);
                _local_23 = {};
                switch (_local_18)
                {
                    case "url":
                        _local_22 = _local_19;
                        _local_21 = ((((((_local_9 + "FFFF99") + _local_10) + "<u>") + _local_22) + "</u>") + _local_11);
                        _local_23.callback = urlClick;
                        break;
                    case "user":
                        _local_22 = _local_19;
                        _local_21 = ((((_local_9 + "FFFFFF") + _local_10) + _local_22) + _local_11);
                        _local_23.callback = pmClick;
                        break;
                    case "item":
                        var c:String = String(game.world.rarity[String(_local_17[2].split(":")[2])].Color).replace("0x", "");
                        _local_22 = "&lt;" + _local_19 + "&gt;";
                        _local_21 = ((((_local_9 + c) + _local_10) + _local_22) + _local_11);
                        _local_22 = "<" + _local_19 + ">";
                        _local_22 = _local_22.replace(/&apos;/g, "'");
                        _local_19 = _local_17[2];
                        _local_23.callback = linkClick;
                        break;
                    case "quest":
                        _local_23.sName = _local_17[1];
                        _local_23.QuestID = _local_17[2];
                        _local_23.iLvl = _local_17[3];
                        _local_23.unm = _local_17[4];
                        _local_22 = (("[" + _local_19) + "]");
                        _local_21 = ((((_local_9 + "00CCFF") + _local_10) + _local_22) + _local_11);
                        //_local_23.callback = game.world.doCTAClick;
                        break;
                }
                _arg_1.htmlText = ((_local_14 + _local_21) + _local_15);
                _local_24 = _local_20;
                _local_25 = ((_local_20 + _local_22.length) - 1);
                _local_26 = _arg_1.getLineIndexOfChar(_local_24);
                _local_27 = _arg_1.getLineIndexOfChar(_local_25);
                _local_28 = _local_26;
                while (_local_28 <= _local_27)
                {
                    if (_local_28 == _local_26)
                    {
                        _local_29 = _arg_1.getCharBoundaries(_local_24);
                    }
                    else
                    {
                        _local_29 = _arg_1.getCharBoundaries(_arg_1.getLineOffset(_local_28));
                    }
                    if (_local_28 == _local_27)
                    {
                        _local_30 = _arg_1.getCharBoundaries(_local_25);
                    }
                    else
                    {
                        _local_30 = _arg_1.getCharBoundaries((_arg_1.getLineOffset((_local_28 + 1)) - 1));
                    }
                    _local_31 = new Rectangle(_local_29.x, _local_29.y, ((_local_30.x - _local_29.x) + _local_30.width), ((_local_30.y - _local_29.y) + _local_30.height));
                    _local_32 = new MovieClip();
                    _local_32.graphics.beginFill(52479);
                    _local_32.graphics.drawRect(0, 0, _local_31.width, _local_31.height);
                    _local_32.graphics.endFill();
                    _local_33 = _local_6.addChild(_local_32);
                    _local_33.alpha = 0;
                    _local_33.x = (_arg_1.x + _local_29.x);
                    _local_33.y = (_arg_1.y + _local_29.y);
                    for (_local_34 in _local_23)
                    {
                        if (_local_34 != "callback")
                        {
                            _local_33[_local_34] = _local_23[_local_34];
                        }
                    }
                    _local_33.str = _local_19;
                    _local_33.buttonMode = true;
                    _local_33.addEventListener(MouseEvent.CLICK, _local_23.callback, false, 0, true);
                    _local_28++;
                }
            }
            var _local_12:* = new uiTextLine();
            _local_12.ti.htmlText = game.ui.mcInterface.textLine.ti.htmlText;
            _local_12.ti.autoSize = "left";
            _local_12.ti.multiline = true;
            MovieClip(_local_12).mouseEnabled = false;
            MovieClip(_local_12).mouseChildren = false;
            _local_12.name = "bmp";
            if (_local_6.numChildren > 0)
            {
                _local_6.swapChildren(_local_6.getChildAt(0), _local_6.addChildAt(_local_12, 0));
            }
            else
            {
                _local_6.addChild(_local_12);
            }
            _arg_4.push(_arg_5);
            newTextLine = _local_12;
            return (_arg_3.addChild(_local_6));
        }

        private function checkPos(_arg_1:MovieClip, _arg_2:int, _arg_3:int, _arg_4:int):int
        {
            var _local_5:DisplayObject = getBitmapByIndex((_arg_3 + 1), game.ui.mcInterface.t1);
            if (((!(_local_5 == null)) && (_arg_2 < _arg_4)))
            {
                return ((_local_5.y - _arg_1.height) + 2);
            }
            return (Math.round((tfHeight - _arg_1.height)));
        }

        private function pmClick(_arg_1:MouseEvent):void
        {
            var _local_2:*;
            if (_arg_1.shiftKey)
            {
                _local_2 = (_arg_1.currentTarget as MovieClip);
                openPMsg(_local_2.str);
            }
            else
            {
                game.world.onWalkClick();
            }
        }

        private function urlClick(event:MouseEvent):void
        {
            var _local_2:* = (event.currentTarget as MovieClip);
            navigateToURL(new URLRequest(_local_2.str), "_blank");
        }

        private function linkClick(event:MouseEvent):void
        {
            var mc:MovieClip = event.currentTarget as MovieClip;
            var itemId:int = mc.str.split(":")[1];
            if (game.world.linkTree[itemId] != null)
            {
                if (game.ui.mcPopup.currentLabel == "ItemPreview")
                {
                    game.ui.mcPopup.fClose();
                }

                game.mixer.playSound("Click");
                game.world.selectPreview = game.world.linkTree[itemId];
                game.ui.mcPopup.fOpen("ItemPreview");
				
				trace(JSON.stringify(game.world.linkTree[itemId]));
            }
        }

        private function getBitmapByIndex(_arg_1:int, _arg_2:DisplayObjectContainer):DisplayObject
        {
            var _local_3:DisplayObject;
            var _local_4:int;
            while (_local_4 < _arg_2.numChildren)
            {
                if (int(_arg_2.getChildAt(_local_4).name.substr(1)) == _arg_1)
                {
                    return (_arg_2.getChildAt(_local_4));
                }
                _local_4++;
            }
            return (null);
        }

        public function pushMsg(_arg_1:*, _arg_2:*, _arg_3:*, _arg_4:*, _arg_5:*, _arg_6:int=0):*
        {
            var _local_10:int;
            var _local_11:*;
            var _local_14:*;
            var _local_15:*;
            var _local_16:*;
            var _local_17:*;
            var _local_18:*;
            var _local_19:*;
            var _local_20:*;
            var _local_21:*;
            var _local_22:*;
            var _local_23:*;
            var _local_24:*;
            var _local_25:*;
            var _local_26:*;
            var _local_27:String;
            trace(((("msg> " + _arg_2) + " ?> ") + _arg_3));
            var _local_7:Boolean;
            if (((!(ignoreList.data.users == null)) && (ignoreList.data.users.indexOf(_arg_3) > -1)))
            {
                return;
            }
            if (_arg_3 != "SERVER")
            {
                _local_10 = 0;
                _local_11 = game.stripWhite(_arg_2.toLowerCase());
                _local_16 = profanityCheck(_arg_2.toLowerCase());
                if (((!(_arg_3.toLowerCase() == game.net.myUserName)) && (_arg_6 == 0)))
                {
                    if (((strContains(_local_11, illegalStrings)) || (strContains(_local_11, unsendable))))
                    {
                        _local_10 = 1;
                    }
                    _local_11 = game.stripWhiteStrict(_arg_2.toLowerCase());
                    if (strContains(_local_11, ["email", "password"]))
                    {
                        _local_10 = 1;
                    }
                    if (((_local_16.code == 1) || (_local_16.code == 2)))
                    {
                        _local_10 = 1;
                    }
                    if (((_arg_1 == "whisper") && (modWhisperCheck(_arg_2) > 0)))
                    {
                        _local_7 = true;
                    }
                    if (_local_10)
                    {
                        return;
                    }
                }
                if (_local_16.code == 3)
                {
                    _arg_2 = game.maskStringBetween(_arg_2, _local_16.indeces);
                }
            }
            var _local_8:* = "$({";
            var _local_9:* = "})$";

            if (isChannel(_arg_1))
            {
                if (_arg_1 == "zone" || _arg_1 == "world" || _arg_1 == "moderator" || _arg_1 == "administrator")
                {
                    popBubble("u:" + game.strToProperCase(_arg_3), _arg_2);
                }

                checkFieldsVPos();
                chatArray.push([_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, msgID]);
                msgID++;
                if (chatArray.length > lineLimit)
                {
                    chatArray.splice(0, (chatArray.length - lineLimit));
                }
                html2Fields("", "=", "server", 0);
                t1Arr = [];
                _local_14 = 0;
                while (_local_14 < chatArray.length)
                {
                    _local_15 = chatArray[_local_14][0];
                    _local_16 = chatArray[_local_14][1];
                    _local_17 = chatArray[_local_14][2];
                    _local_18 = chatArray[_local_14][3];
                    _local_19 = chatArray[_local_14][4];
                    _local_20 = int(chatArray[_local_14][5]);
                    _local_21 = '<font color=\"#';
                    _local_22 = '\">';
                    _local_23 = "</font>";
                    _local_24 = ((chn[_local_15].tag == "") ? "" : (("[" + chn[_local_15].tag) + "] "));
                    _local_25 = _local_17;

                    if (_local_16.indexOf("loadItem") > 0)
                    {
                        _local_16 = _local_16.replace(regExpLinking2, "$1");
                        _local_16 = _local_16.replace(/<\s*A HREF="(.*?)">&lt;(.*?)&gt;<\s*\/A\s*>/ig, "$({item,$2,$1})$");
                    }

                    _local_16 = _local_16.replace(regExpURL, "$({url,$&})$");

                    if (((!(_local_17 == null)) && (!(_local_17 == "SERVER"))))
                    {
                        _local_26 = ((((_local_8 + "user,") + _local_25) + _local_9) + ": ");
                    }
                    if (_local_17 == "SERVER")
                    {
                        _local_26 = "";
                    }

                    if (_local_15 != "whisper")
                    {
                        if (_local_15 != "event")
                        {
                            _local_16 = _local_16.split("#037:").join("%");
                            html2Fields((((((((_local_21 + chn[_local_15].col) + _local_22) + _local_24) + _local_26) + _local_16) + _local_23) + "<br>"), "+=", _local_15, _local_20);
                        }
                        else
                        {
                            html2Fields((((((((((((((((_local_21 + "CCCCCC") + _local_22) + "*") + _local_21) + "FFFFFF") + _local_22) + _local_25) + _local_23) + _local_21) + "CCCCCC") + _local_22) + " ") + _local_16) + _local_23) + "*<br>"), "+=", _local_15, _local_20);
                        }
                    }
                    else
                    {
                        if (((_local_17 == game.net.myUserName) || (isMyModHandle(_local_17))))
                        {
                            if (_local_19 == 0)
                            {
                                html2Fields(((((((('<font color="#' + game.modColor(chn[_local_15].col, "666666", "-")) + '">') + "To ") + _local_18) + ": ") + _local_16) + "</font><br>"), "+=", _local_15, _local_20);
                            }
                            else
                            {
                                html2Fields(((((('<font color="#' + chn[_local_15].col) + '">From ') + _local_26) + _local_16) + "</font><br>"), "+=", _local_15, _local_20);
                            }
                        }
                        else
                        {
                            html2Fields(((((('<font color="#' + chn[_local_15].col) + '">From ') + _local_26) + _local_16) + "</font><br>"), "+=", _local_15, _local_20);
                        }
                    }
                    _local_14++;
                }
                setFieldsVPos();
                writeText(panelIndex, _arg_1);
            }

            if (_local_7)
            {
                pushMsg("warning", (("<font color='#FFFFFF'>" + _arg_3) + "</font> IS NOT A MODERATOR.  DO NOT GIVE ACCOUNT INFORMATION TO OTHER PLAYERS."), "SERVER", "", 0);
                _local_27 = (("<font color='#FF0000'>WARNING</font><br/><font color='#FFFFFF'>" + _arg_3.toUpperCase()) + "</font><font color='#FFFFFF'> IS NOT A MODERATOR.<br/>Do not give account information to other players.<font>");
                _local_27 = (_local_27 + "<br/><a href='event:link::http://aq.com/safety.asp'><font color='#66CCFF'><u>Click here</u></font></a> to learn more.");
                game.ui.ToolTip.openWith({
                    "str":_local_27,
                    "lowerright":true,
                    "invert":true,
                    "closein":10000
                });
            }
        }

        public function profanityCheck(_arg_1:String):Object
        {
            var _local_2:String;
            var _local_3:int;
            var _local_4:Object = {
                "code":0,
                "term":"",
                "index":-1,
                "indeces":[]
            };
            _local_2 = ((" " + removeHTML(cleanStr(_arg_1.toLowerCase()))) + " ");
            _local_2 = game.stripMarks(_local_2);
            _local_2 = game.stripDuplicateVowels(_local_2);
            _local_3 = 0;
            while (_local_3 < profanityA.length)
            {
                if (profanityA[_local_3] == "weebly")
                {
                    trace("weebly found");
                }
                _local_4.index = _local_2.indexOf(((" " + profanityA[_local_3]) + " "));
                if (_local_4.index > -1)
                {
                    _local_4.term = profanityA[_local_3];
                    _local_4.code = 1;
                    return (_local_4);
                }
                _local_3++;
            }
            _local_2 = game.stripDuplicateVowels(removeHTML(cleanStr(_arg_1.toLowerCase())));
            _local_2 = game.stripWhiteStrict(_local_2);
            _local_3 = 0;
            while (_local_3 < profanityB.length)
            {
                _local_4.index = _local_2.indexOf(profanityB[_local_3]);
                if (_local_4.index > -1)
                {
                    _local_4.term = profanityB[_local_3];
                    _local_4.code = 2;
                    return (_local_4);
                }
                _local_3++;
            }
            _local_2 = game.stripDuplicateVowels(removeHTML(cleanStr(_arg_1.toLowerCase())));
            _local_2 = game.stripWhiteStrictB(_local_2);
            _local_3 = 0;
            while (_local_3 < profanityB.length)
            {
                _local_4.index = _local_2.indexOf(profanityB[_local_3]);
                if (_local_4.index > -1)
                {
                    _local_4.term = profanityB[_local_3];
                    _local_4.code = 2;
                    return (_local_4);
                }
                _local_3++;
            }
            var _local_5:Array = [];
            var _local_6:* = "";
            var _local_7:int;
            while (_local_7 < _arg_1.length)
            {
                if (legalCharsStrict.indexOf(_arg_1.charAt(_local_7)) > -1)
                {
                    if (((_local_6.length == 0) || (!(_arg_1.charAt(_local_7) == _local_6.charAt((_local_6.length - 1))))))
                    {
                        _local_6 = (_local_6 + _arg_1.charAt(_local_7));
                        _local_5.push(_local_7);
                    }
                }
                _local_7++;
            }
            _local_3 = 0;
            while (_local_3 < profanityC.length)
            {
                _local_4.index = _local_6.indexOf(profanityC[_local_3]);
                if (_local_4.index > -1)
                {
                    _local_4.code = 3;
                    _local_4.indeces.push(_local_5[_local_4.index]);
                    _local_4.indeces.push(((_local_5[_local_4.index] + profanityC[_local_3].length) - 1));
                }
                _local_3++;
            }
            return (_local_4);
        }

        public function modWhisperCheck(_arg_1:String):int
        {
            var _local_3:String;
            var _local_2:String = game.stripWhiteStrict(removeHTML(_arg_1.toLowerCase()));
            for each (_local_3 in modWhisperCheckList)
            {
                if (_local_2.indexOf(_local_3) > -1)
                {
                    return (1);
                }
            }
            return (0);
        }

        private function removeHTML(_arg_1:String):String
        {
            var _local_5:int;
            var _local_6:String;
            var _local_2:String = _arg_1.toLowerCase();
            var _local_3:String = ("" + _arg_1);
            var _local_4:Array = ["&nbsp;", "<br>"];
            for each (_local_6 in _local_4)
            {
                while (_local_2.indexOf(_local_6) > -1)
                {
                    _local_5 = _local_2.indexOf(_local_6);
                    _local_2 = ((_local_2.substr(0, _local_5) + " ") + _local_2.substr((_local_5 + _local_6.length), _local_2.length));
                    _local_3 = ((_local_3.substr(0, _local_5) + " ") + _local_3.substr((_local_5 + _local_6.length), _local_3.length));
                }
            }
            return (_local_3);
        }

        public function isUnsendable(_arg_1:String):Boolean
        {
            var _local_2:* = 0;
            while (_local_2 < unsendable.length)
            {
                if (_arg_1.toLowerCase().indexOf(unsendable[_local_2]) > -1)
                {
                    return (true);
                }
                _local_2++;
            }
            return (false);
        }

        public function isIgnored(_arg_1:String):Boolean
        {
            return (ignoreList.data.users.indexOf(_arg_1.toLowerCase()) >= 0);
        }

        public function ignore(strName:String):void
        {
            var mc:* = undefined;
            if (ignoreList.data.users.indexOf(strName.toLowerCase()) == -1)
            {
                ignoreList.data.users.push(strName.toLowerCase());
                try
                {
                    ignoreList.flush();
                }
                catch(e:Error)
                {
                    trace(e.message);
                }
                mc = game.world.getAvatarByUserName(strName.toLowerCase());
                if (mc != null)
                {
                    mc.pMC.ignore.visible = true;
                }
                game.net.send("cmd", ["ignoreList", ignoreList.data.users]);
            }
            try
            {
                if (game.ui.mcOFrame.fData.typ == "userListIgnore")
                {
                    game.ui.mcOFrame.update();
                }
            }
            catch(e:Error)
            {
            }
        }

        public function unignore(strName:String):void
        {
            var uind:* = ignoreList.data.users.indexOf(strName.toLowerCase());
            while (uind > -1)
            {
                ignoreList.data.users.splice(uind, 1);
                uind = ignoreList.data.users.indexOf(strName.toLowerCase());
            }
            try
            {
                ignoreList.flush();
            }
            catch(e:Error)
            {
                trace(e.message);
            }
            var mc:* = game.world.getAvatarByUserName(strName.toLowerCase());
            if (mc != null)
            {
                mc.pMC.ignore.visible = false;
            }
            game.net.send("cmd", ["ignoreList", ignoreList.data.users]);
            try
            {
                if (game.ui.mcOFrame.fData.typ == "userListIgnore")
                {
                    game.ui.mcOFrame.update();
                }
            }
            catch(e:Error)
            {
            }
        }

        public function muteMe(dur:int):void
        {
            var date:Date = new Date();
            mute.ts = Number(date.getTime());
            mute.cd = dur;
            mute.timer.delay = dur;
            mute.timer.start();
            muteData.data.ts = mute.ts;
            muteData.data.cd = mute.cd;
            try
            {
                muteData.flush();
            }
            catch(e:Error)
            {
                trace(e.message);
            }
            pushMsg("warning", "You have been muted! Chat privileges are temporarily revoked.", "SERVER", "", 0);
        }

        public function unmuteMe(_arg_1:Event=null):void
        {
            mute.ts = 0;
            mute.cd = 0;
            muteData.clear();
            mute.timer.reset();
            pushMsg("server", "You have been unmuted.  Chat privileges are restored.", "SERVER", "", 0);
        }

        public function amIMute():Boolean
        {
            var _local_2:Date;
            var _local_3:Number;
            var _local_1:Boolean;
            if (mute.ts > 0)
            {
                _local_2 = new Date();
                _local_3 = _local_2.getTime();
                if ((_local_3 - mute.ts) >= mute.cd)
                {
                    mute.ts = 0;
                    mute.cd = 0;
                }
                else
                {
                    _local_1 = true;
                }
            }
            return (_local_1);
        }

        public function isChannel(_arg_1:String):Boolean
        {
            var _local_2:*;
            for (_local_2 in chn)
            {
                if (_local_2.toLowerCase() == _arg_1.toLowerCase())
                {
                    return (true);
                }
            }
            return (false);
        }

        private function isMyModHandle(_arg_1:String):Boolean
        {
            if (((_arg_1.split("-")[0] == "Moderator") && (int((_arg_1.split("-")[1] == game.world.modID)))))
            {
                return (true);
            }
            return (false);
        }


    }
}//package 

// _SafeStr_1 = "goto" (String#3066)


