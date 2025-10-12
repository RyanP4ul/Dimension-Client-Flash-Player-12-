// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//cMenuMC

package
{
import flash.display.MovieClip;
import flash.geom.ColorTransform;
import flash.events.MouseEvent;
import flash.net.navigateToURL;
import flash.net.URLRequest;
import flash.text.*;

import game.Examine;

public class cMenuMC extends MovieClip
{

    public var cnt:MovieClip;
    internal var world:MovieClip;
    internal var fData:Object = null;
    internal var isOpen:Boolean = false;
    internal var fMode:String;
    internal var mc:MovieClip;
    internal var rootClass:Game = Game.root;
    internal var iHi:Number = -1;
    internal var iSel:Number = -1;
    internal var iCT:ColorTransform;

    public function cMenuMC()
    {
        addFrameScript(0, frame1, 4, frame5, 9, frame10);
        mc = MovieClip(this);
        mc.cnt.iproto.visible = false;
        mc.addEventListener(MouseEvent.MOUSE_OVER, mouseOn);
        mc.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
        fData = {};
        fData.params = {};
        fData.user = ["Char Page", "Is Staff?", "Whisper", "Add Friend", "Go To", "Invite", "Delete Friend", "Ignore", "Trade", "Shops", "Examine", "Close"];
        fData.party = ["Char Page", "Whisper", "Add Friend", "Go To", "Remove", "Summon", "Promote", "Delete Friend", "Ignore", "Examine", "Close"];
        fData.self = ["Char Page", "Reputation", "Leave Party", "Shop", "Examine", "Close"];
        fData.pvpqueue = ["Leave Queue", "Close"];
        fData.offline = ["Delete Friend", "Examine", "Close"];
        fData.ignored = ["Unignore", "Close"];
        fData.mons = ["Examine", "Close"];
        fData.npcs = ["Close"];
        fData.cl = [];
        fData.clc = [];
    }

    public function fOpenWith(_arg_1:*, _arg_2:*):*
    {
        var _local_7:*;
        var _local_8:*;
        var _local_9:*;
        isOpen = true;
        fMode = _arg_1.toLowerCase();
        fData.params = _arg_2;
        mc.cnt.mHi.visible = false;
        iCT = mc.cnt.mHi.transform.colorTransform;
        iCT.color = 13434675;
        mc.cnt.mHi.transform.colorTransform = iCT;
        var _local_3:int;
        _local_3 = 0;
        while (_local_3 < 9)
        {
            _local_7 = mc.cnt.getChildByName(("i" + _local_3));
            if (_local_7 != null)
            {
                _local_7.removeEventListener(MouseEvent.CLICK, itemClick);
                _local_7.removeEventListener(MouseEvent.MOUSE_OVER, itemMouseOver);
                mc.cnt.removeChild(_local_7);
            }
            _local_3++;
        }
        var _local_4:* = 0;
        delete fData.cl;
        delete fData.clc;
        var _local_5:* = fData.params.strUsername.toLowerCase();
        var _local_6:* = rootClass.world.uoTree[_local_5];
        fData.cl = rootClass.copyObj(fData[fMode]);
        fData.clc = [];
        _local_3 = 0;
        while (_local_3 < fData.cl.length)
        {
            if (((fData.cl[_local_3] == "Add Friend") && (rootClass.world.myAvatar.isFriend(fData.params.ID))))
            {
                fData.cl.splice(_local_3, 1);
                _local_3--;
            }
            if (((fData.cl[_local_3] == "Delete Friend") && (!(rootClass.world.myAvatar.isFriend(fData.params.ID)))))
            {
                fData.cl.splice(_local_3, 1);
                _local_3--;
            }
            _local_3++;
        }
        _local_3 = 0;
        while (_local_3 < fData.cl.length)
        {
            if (_local_5 == rootClass.net.myUserName)
            {
            }
            if (((fData.cl[_local_3] == "Ignore") && (rootClass.chatF.isIgnored(_local_5))))
            {
                fData.cl[_local_3] = "Unignore";
            }
            _local_8 = mc.cnt.addChild(new cProto());
            _local_8.name = ("i" + _local_3);
            _local_8.y = (mc.cnt.iproto.y + (_local_3 * 14));
            iCT = _local_8.transform.colorTransform;
            _local_9 = true;
            switch (fData.cl[_local_3].toLowerCase())
            {
                case "add friend":
                    if ((((!(rootClass.world.getAvatarByUserName(_local_5) == null)) && (!(rootClass.world.getAvatarByUserName(_local_5).objData == null))) && ((rootClass.world.getAvatarByUserName(_local_5).isStaff()) && (!(rootClass.world.myAvatar.isStaff())))))
                    {
                        _local_9 = false;
                    }
                    break;
                case "go to":
                    if (!((rootClass.world.isPartyMember(_local_5)) || (rootClass.world.myAvatar.isFriend(fData.params.ID))))
                    {
                        _local_9 = false;
                    }
                    break;
                case "ignore":
                case "unignore":
                    if (_local_5 == rootClass.net.myUserName)
                    {
                        _local_9 = false;
                    }
                    break;
                case "invite":
                    if ((((((((_local_5 == rootClass.net.myUserName) || (_local_6 == null)) || (((!(rootClass.world.getAvatarByUserName(_local_5) == null)) && (!(rootClass.world.getAvatarByUserName(_local_5).objData == null))) && ((rootClass.world.getAvatarByUserName(_local_5).isStaff()) && (!(rootClass.world.myAvatar.isStaff()))))) || (rootClass.world.partyMembers.length > 4)) || (rootClass.world.isPartyMember(fData.params.strUsername))) || ((rootClass.world.bPvP) && (!(_local_6.pvpTeam == rootClass.world.myAvatar.dataLeaf.pvpTeam)))) || ((rootClass.world.partyMembers.length > 0) && (!(rootClass.world.partyOwner.toLowerCase() == rootClass.net.myUserName)))))
                    {
                        _local_9 = false;
                    }
                    break;
                case "leave party":
                    if (rootClass.world.partyMembers.length == 0)
                    {
                        _local_9 = false;
                    }
                    break;
                case "remove":
                    if (rootClass.world.partyOwner.toLowerCase() != rootClass.net.myUserName)
                    {
                        fData.cl[_local_3] = "Leave Party";
                    }
                    break;
                case "private: on":
                case "private: off":
                case "promote":
                    if (rootClass.world.partyOwner != rootClass.world.myAvatar.objData.strUsername)
                    {
                        _local_9 = false;
                    }
                    break;
                case "inspect":
                    if (((_local_6 == null) || (!(_local_6.strFrame == rootClass.world.strFrame))))
                    {
                        _local_9 = false;
                    }
                    break;
            }
            if (_local_9)
            {
                iCT.color = 0x999999;
                _local_8.addEventListener(MouseEvent.CLICK, itemClick, false, 0, true);
                _local_8.buttonMode = true;
            }
            else
            {
                iCT.color = 0x666666;
            }
            _local_8.addEventListener(MouseEvent.MOUSE_OVER, itemMouseOver, false, 0, true);
            fData.clc.push(iCT.color);
            _local_8.ti.text = fData.cl[_local_3];
            if (_local_8.ti.textWidth > _local_4)
            {
                _local_4 = _local_8.ti.textWidth;
            }
            _local_8.transform.colorTransform = iCT;
            _local_8.ti.width = (_local_8.ti.textWidth + 5);
            _local_8.hit.width = ((_local_8.ti.x + _local_8.ti.textWidth) + 2);
            _local_3++;
        }
        mc.cnt.bg.height = (mc.cnt.getChildByName(String(("i" + (fData.cl.length - 1)))).y + 26);
        mc.cnt.bg.width = (_local_4 + 20);
        mc.x = (MovieClip(parent).mouseX - 5);
        mc.y = (MovieClip(parent).mouseY - 5);
        if ((mc.x + mc.cnt.bg.width) > 960)
        {
            mc.x = (MovieClip(parent).mouseX - mc.cnt.bg.width);
        }
        if ((mc.y + mc.cnt.bg.height) > 500)
        {
            mc.y = (500 - mc.cnt.bg.height);
        }
        mc.gotoAndPlay("in");
    }

    public function fClose():*
    {
        isOpen = false;
        if (mc.currentFrame != 1)
        {
            if (mc.currentFrame == 10)
            {
                mc.gotoAndPlay("out");
            }
            else
            {
                mc.gotoAndStop("hold");
            }
        }
    }

    private function itemMouseOver(_arg_1:MouseEvent):*
    {
        var _local_4:*;
        var _local_2:* = MovieClip(_arg_1.currentTarget);
        iHi = int(_local_2.name.substr(1));
        var _local_3:int;
        _local_3 = 0;
        while (_local_3 < fData.cl.length)
        {
            _local_4 = mc.cnt.getChildByName(("i" + _local_3));
            iCT = _local_4.transform.colorTransform;
            if (_local_3 == iHi)
            {
                if (_local_2.hasEventListener(MouseEvent.CLICK))
                {
                    iCT.color = 0xFFFFFF;
                    cnt.mHi.visible = true;
                    cnt.mHi.y = (_local_4.y + 3);
                }
                else
                {
                    cnt.mHi.visible = false;
                }
            }
            else
            {
                iCT.color = fData.clc[_local_3];
            }
            _local_4.transform.colorTransform = iCT;
            _local_3++;
        }
    }

    private function itemClick(_arg_1:MouseEvent):*
    {
        var _local_3:String;
        var _local_5:String;
        var _local_6:int;
        var _local_2:* = MovieClip(_arg_1.currentTarget);
        iSel = int(_local_2.name.substr(1));
        iCT = mc.cnt.mHi.transform.colorTransform;
        iCT.color = 16763955;
        mc.cnt.mHi.transform.colorTransform = iCT;
        fClose();
        _local_3 = fData.cl[iSel];
        var _local_4:String = fData.params.strUsername;
        switch (_local_3.toLowerCase())
        {
            case "char page":
                rootClass.mixer.playSound("Click");
                if (rootClass.params.strSourceID == "BBGames")
                {
                    navigateToURL(new URLRequest(("http://www.aq.com/embed/bbgames/character.asp?id=" + _local_4)), "_blank");
                }
                else
                {
                    navigateToURL(new URLRequest(("http://www.aq.com/character.asp?id=" + _local_4)), "_blank");
                }
                return;
            case "is staff?":
                rootClass.world.isModerator(_local_4);
                return;
            case "reputation":
                rootClass.mixer.playSound("Click");
                rootClass.togglePanel("reputation");
                return;
            case "whisper":
                rootClass.chatF.openPMsg(_local_4);
                return;
            case "ignore":
                rootClass.chatF.ignore(_local_4);
                rootClass.chatF.pushMsg("server", (("You are now ignoring user " + _local_4) + "."), "SERVER", "", 0);
                return;
            case "unignore":
                rootClass.chatF.unignore(_local_4);
                rootClass.chatF.pushMsg("server", (("User " + _local_4) + " is no longer being ignored."), "SERVER", "", 0);
                return;
            case "report":
                rootClass.ui.mcPopup.fOpen("Report", {"unm":_local_4});
                return;
            case "close":
                if (((fMode == "user") || (fMode == "party")))
                {
                    rootClass.world.cancelTarget();
                }
                return;
            case "add friend":
                if (rootClass.world.myAvatar.friends.length >= 100)
                {
                    rootClass.chatF.pushMsg("server", "You are too popular! (40 friends max)", "SERVER", "", 0);
                }
                else
                {
                    rootClass.world.requestFriend(_local_4);
                }
                return;
            case "delete friend":
                rootClass.world.deleteFriend(fData.params.ID, _local_4);
                return;
            case "go to":
                rootClass.world._SafeStr_1(_local_4);
                return;
            case "invite":
                rootClass.world.partyInvite(_local_4);
                return;
            case "remove":
                rootClass.world.partyKick(_local_4);
                return;
            case "leave party":
                rootClass.world.partyLeave();
                return;
            case "private: on":
            case "private: off":
                _local_5 = _local_3.toLowerCase().split(": ")[0];
                _local_6 = ((_local_3.toLowerCase().split(": ")[1] == "on") ? 1 : 0);
                rootClass.world.partyUpdate(_local_5, String(_local_6));
                return;
            case "promote":
                rootClass.world.partyPromote(_local_4);
                return;
            case "summon":
                rootClass.world.partySummon(_local_4);
                return;
            case "leave queue":
                rootClass.world.requestPVPQueue("none");
                return;
            case "trade":
                rootClass.world.tradeController.sendTradeInvite(_local_4);
                break;
            case "examine":
                trace("TEST");
                var o:Object;

                if (fMode == "self" || fMode == "user")
                {
                    trace("EXAMINE SELF OR USEr");
                    o = rootClass.world.uoTree[_local_4.toLowerCase()];
                    rootClass.mcExamine = new Examine("character", o);
                }
                else if (fMode == "mons")
                {
                    trace("EXAMINE MOSNTER");
                    o = rootClass.world.monTree[fData.params.ID];
                    rootClass.mcExamine = new Examine("monster", o);
                }

                trace("DISPLAY EXAMINE");

                if (rootClass.ui.getChildByName("mcExamine") || rootClass.mcExamine == null) return;
                rootClass.mcExamine.name = "mcExamine";
                rootClass.mcExamine.x = 900;
                rootClass.mcExamine.y = 90;
                rootClass.ui.addChild(rootClass.mcExamine);
                break;
			case "shops":
				rootClass.net.send("loadVendor", [_local_4]);
				break;
        }
    }

    private function mouseOn(_arg_1:MouseEvent):*
    {
        MovieClip(_arg_1.currentTarget).cnt.gotoAndStop("hold");
    }

    private function mouseOut(_arg_1:MouseEvent):*
    {
        MovieClip(_arg_1.currentTarget).cnt.gotoAndPlay("out");
    }

    internal function frame1():*
    {
        visible = false;
        stop();
    }

    internal function frame5():*
    {
        visible = true;
    }

    internal function frame10():*
    {
        stop();
    }


}
}//package 

// _SafeStr_1 = "goto" (String#3066)


