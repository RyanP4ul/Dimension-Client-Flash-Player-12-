// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//LPFFrameItemPreview

package UI.LPF.Frame
{

    import UI.ModalMC;

    import assets.ib2;

    import element.Dark;

    import element.Earth;

    import element.Fire;
    import element.Ice;
    import element.Light;
    import element.Lightning;
    import element.Nature;
    import element.Wind;

import flash.text.TextField;
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.system.ApplicationDomain;
    import flash.system.LoaderContext;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.display.Loader;
    import flash.net.URLRequest;
    import flash.filters.GlowFilter;
    import flash.geom.Rectangle;
    import flash.text.*;
import flash.utils.getDefinitionByName;

import utils.SwfToImageConverter;

public class LPFFrameItemPreview extends LPFFrame
    {

        public var tInfo:TextField;
        public var mcPreview:MovieClip;
        public var mcUpgrade:MovieClip;
        public var btnDelete:SimpleButton;
        public var btnChatShow:SimpleButton;
        public var btnFav:SimpleButton;
        public var btnMGender:SimpleButton;
        public var btnFGender:SimpleButton;
        public var btnConvertToImage:SimpleButton;


        public var iSel:Object;
        private var previewArgs:Object = {};
        public var game:Game;
        public var curItem:Object;

        private var sLinkArmor:String = "";
        private var sLinkCape:String = "";
        private var sLinkHelm:String = "";
        private var sLinkPet:String = "";
        private var sLinkWeapon:String = "";
        private var sLinkHouse:String = "";

        private var pLoaderD:ApplicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
        private var pLoaderC:LoaderContext = new LoaderContext(false, pLoaderD);
        private var loaderStack:Array = [];
        private var killStack:Array = [];
        private var Gender:String;
        private var _skills:MovieClip;
        private var isPet:Boolean = false;
		private var isEquip:Boolean = false;
        private var equipments:Array = ["Weapon", "co", "ar", "he", "ba", "pe"];
        private var mcElement:MovieClip;
        internal var preventSpam:Boolean;

        public function LPFFrameItemPreview():void
        {
            pLoaderC.checkPolicyFile = false;
            pLoaderC.allowCodeImport = true;

            btnConvertToImage.visible = false;
            btnFGender.visible = false;
            btnMGender.visible = false;
            mcUpgrade.visible = false;

            btnConvertToImage.addEventListener(MouseEvent.CLICK, onBtnConvertToImageClick, false, 0, true);
            btnConvertToImage.addEventListener(MouseEvent.MOUSE_OVER, onConvertToImageTTOver, false, 0, true);
            btnConvertToImage.addEventListener(MouseEvent.MOUSE_OUT, onConvertToImageTTOut, false, 0, true);

            btnDelete.addEventListener(MouseEvent.CLICK, onBtnDeleteClick, false, 0, true);
            btnDelete.addEventListener(MouseEvent.MOUSE_OVER, onDeleteTTOver, false, 0, true);
            btnDelete.addEventListener(MouseEvent.MOUSE_OUT, onDeleteTTOut, false, 0, true);
            btnChatShow.addEventListener(MouseEvent.CLICK, onBtnChatShowClick, false, 0, true);
            btnChatShow.addEventListener(MouseEvent.MOUSE_OVER, onChatShowTTOver, false, 0, true);
            btnChatShow.addEventListener(MouseEvent.MOUSE_OUT, onChatShowTTOut, false, 0, true);
            btnFav.addEventListener(MouseEvent.CLICK, onBtnFavoriteClick, false, 0, true);
            btnFav.addEventListener(MouseEvent.MOUSE_OVER, onFavoriteTTOver, false, 0, true);
            btnFav.addEventListener(MouseEvent.MOUSE_OUT, onFavoriteTTOut, false, 0, true);
            mcUpgrade.addEventListener(MouseEvent.MOUSE_OVER, onUpgradeTTOver, false, 0, true);
            mcUpgrade.addEventListener(MouseEvent.MOUSE_OUT, onUpgradeTTOut, false, 0, true);

            btnMGender.addEventListener(MouseEvent.CLICK, onBtnGender, false, 0, true);
            btnMGender.addEventListener(MouseEvent.MOUSE_OVER, onGenderTTOver, false, 0, true);
            btnMGender.addEventListener(MouseEvent.MOUSE_OUT, onGenderTTOut, false, 0, true);
            btnFGender.addEventListener(MouseEvent.CLICK, onBtnGender, false, 0, true);
            btnFGender.addEventListener(MouseEvent.MOUSE_OVER, onGenderTTOver, false, 0, true);
            btnFGender.addEventListener(MouseEvent.MOUSE_OUT, onGenderTTOut, false, 0, true);

            addEventListener(Event.ENTER_FRAME, onEF, false, 0, true);
        }

        override public function fOpen(_arg_1:Object):void
        {
            game = Game.root;
            positionBy(_arg_1.r);
            if (("eventTypes" in _arg_1))
            {
                eventTypes = _arg_1.eventTypes;
            }
            if ("isPet" in _arg_1)
            {
                isPet = _arg_1.isPet;
            }
            if (("isEquip" in _arg_1))
            {
                isEquip = _arg_1.isEquip;
            }

            fDraw();
            getLayout().registerForEvents(this, eventTypes);
        }

        override public function fClose():void
        {
            btnConvertToImage.removeEventListener(MouseEvent.CLICK, onBtnConvertToImageClick);
            btnConvertToImage.removeEventListener(MouseEvent.MOUSE_OVER, onConvertToImageTTOver);
            btnConvertToImage.removeEventListener(MouseEvent.MOUSE_OUT, onConvertToImageTTOut);

            btnDelete.removeEventListener(MouseEvent.CLICK, onBtnDeleteClick);
            btnDelete.removeEventListener(MouseEvent.MOUSE_OVER, onDeleteTTOver);
            btnDelete.removeEventListener(MouseEvent.MOUSE_OUT, onDeleteTTOut);

            btnChatShow.removeEventListener(MouseEvent.CLICK, onBtnChatShowClick);
            btnChatShow.removeEventListener(MouseEvent.MOUSE_OVER, onChatShowTTOver);
            btnChatShow.removeEventListener(MouseEvent.MOUSE_OUT, onChatShowTTOut);

            btnFav.removeEventListener(MouseEvent.CLICK, onBtnFavoriteClick);
            btnFav.removeEventListener(MouseEvent.MOUSE_OVER, onFavoriteTTOver);
            btnFav.removeEventListener(MouseEvent.MOUSE_OUT, onFavoriteTTOut);

            mcUpgrade.removeEventListener(MouseEvent.MOUSE_OVER, onUpgradeTTOver);
            mcUpgrade.removeEventListener(MouseEvent.MOUSE_OUT, onUpgradeTTOut);

            btnMGender.removeEventListener(MouseEvent.CLICK, onBtnGender);
            btnMGender.removeEventListener(MouseEvent.MOUSE_OVER, onGenderTTOver);
            btnMGender.removeEventListener(MouseEvent.MOUSE_OUT, onGenderTTOut);
            btnFGender.removeEventListener(MouseEvent.CLICK, onBtnGender);
            btnFGender.removeEventListener(MouseEvent.MOUSE_OVER, onGenderTTOver);
            btnFGender.removeEventListener(MouseEvent.MOUSE_OUT, onGenderTTOut);

            getLayout().unregisterFrame(this);

            if (parent != null)
            {
                parent.removeChild(this);
            }
        }

        protected function fDraw():void
        {
            btnFav.visible = false;
            btnDelete.visible = false;
            btnConvertToImage.visible = game.world.myAvatar.isStaff();

            var _local_4:Object = iSel;

            if (!isPet)
            {
                _local_4 = iSel;
            }
            else
            {
                _local_4 = game.world.myAvatar.getEquippedItemBySlot("pe");
                iSel = game.world.myAvatar.getEquippedItemBySlot("pe");
            }



            if (_local_4 != null)
            {
                if (mcElement)
                {
                    removeChild(mcElement);
                    mcElement = null;
                }

                if (_local_4.hasOwnProperty("sElmt"))
                {
                    mcElement = game.world.getElement(_local_4.sElmt);

                    if (mcElement != null)
                    {
                        mcElement.width = 30;
                        mcElement.height = 30;
                        mcElement.name = "Element";
                        addChild(mcElement);
                    }

                }

                if (_local_4.hasOwnProperty("skills"))
                {
                    if (_skills == null)
                    {
                        _skills = new MovieClip();
                        addChild(_skills);
                    }
                    else
                    {
                        game.onRemoveChildren(_skills);
                    }

                    for each (var skill:Object in _local_4.skills)
                    {
                        skill.sArg1 = "";
                        skill.sArg2 = "";

                        var icon:ib2 = new ib2();
                        icon.width = 43;
                        icon.height = 39;
                        icon.tQty.visible = false;
                        icon.icon2 = null;
                        icon.actObj = skill;
                        icon.isItemSkill = true;
                        icon.x = 45 * _skills.numChildren;
                        game.updateIcons([icon], skill.icon.split(','), null);
                        icon.addEventListener(MouseEvent.MOUSE_OVER, game.actIconOver, false, 0, true);
                        icon.addEventListener(MouseEvent.MOUSE_OUT, game.actIconOut, false, 0, true);
                        icon.mouseChildren = false;

                        _skills.addChild(icon);
                    }
                }
                else if (_skills != null)
                {
                    removeChild(_skills);
                    _skills = null;
                }

                btnDelete.visible = true;
                tInfo.htmlText = getLayout().sMode.toLowerCase() != "pet" ? game.getItemInfoStringB(_local_4) : "";
                tInfo.y = int((((btnDelete.y + btnDelete.height) - tInfo.textHeight) - 3));
                mcUpgrade.visible = false;

                if (equipments.indexOf(_local_4.sES) > -1 && getLayout().sMode.toLowerCase().indexOf("shop") <= -1)
                {
                    btnFav.visible = true;
                }

                if (!isPet)
                {
                    if (_local_4.bUpg == 1)
                    {
                        mcUpgrade.visible = true;
                    }
                    if (_local_4.bGold == 1 || _local_4.bSilver == 1)
                    {
                        mcUpgrade.visible = false;
                    }
                }

                if (_local_4.sType != "Enhancement")
                {
                    switch (_local_4.sES)
                    {
                        case "ar":
                        case "co":
                            if (game.world.myAvatar.objData.strGender == "M")
                            {
                                btnFGender.visible = false;
                                btnMGender.visible = true;
                            }
                            else
                            {
                                btnFGender.visible = true;
                                btnMGender.visible = false;
                            }
                            break;
                        default:
                            btnFGender.visible = false;
                            btnMGender.visible = false;
                    }
                }

                loadPreview(_local_4);
            }
            else
            {
                tInfo.htmlText = "Please select an item to preview.";
                game.onRemoveChildren(mcPreview);
                clearPreview();
            }

            btnFav.visible = game.ui.mcPopup.currentLabel == "Inventory";
            btnDelete.visible = game.ui.mcPopup.currentLabel == "Inventory";

            Gender = game.world.myAvatar.objData.strGender;
        }

        override public function notify(o:Object):void
        {
            iSel = null;

            if (o.fData.eSel != null)
            {
                iSel = o.fData.eSel;
            }

            if (o.fData.iSel != null)
            {
                iSel = o.fData.iSel;
            }

            if (o.fData.rSel != null)
            {
                iSel = o.fData.rSel;
            }

            if (isPet) iSel = game.world.myAvatar.getEquippedItemBySlot("pe");
            if (isEquip && iSel != null)
            {
                if (equipments.indexOf(iSel.sES) != -1)
                {
                    iSel = game.world.myAvatar.getEquippedItemBySlot(iSel.sES);
                }
                else
                {
                    update({ "eventType": "hideEquipped" });
                }
            }
			
            fDraw();
        }

        public function onBtnDeleteClick(_arg_1:Event):void
        {
            var _local_2:*;
            var _local_3:*;
            var _local_4:int;
            game.mixer.playSound("Click");
            if (iSel.bEquip == 1)
            {
                game.MsgBox.notify("Item is currently equipped!");
            }
            else
            {
                _local_2 = new ModalMC();
                _local_3 = {};
                _local_3.params = {};
                if ((((!(iSel.bGold == null)) && (iSel.bGold == 1)) && ((iSel.iQty > 0) || (iSel.sES == "ar"))))
                {
                    _local_3.strBody = "<font color='#FF0000'><b>Gold items can not be deleted!</b></font>\n\nYou may sell the item if you really want, but there is no limit on AC item storage!";
                    _local_3.btns = "mono";
                }
                else
                {
                    if (iSel.sES == "ar")
                    {
                        _local_3.strBody = (("Are you sure you want to delete '" + iSel.sName) + "' and the rank associated with it?");
                    }
                    else
                    {
                        _local_3.strBody = (("Are you sure you want to delete '" + iSel.sName) + "'?");
                    }
                    _local_3.callback = deleteRequest;
                    _local_4 = ((iSel.iQty != null) ? iSel.iQty : 1);
                    if (iSel.sES == "ar")
                    {
                        _local_4 = 1;
                    }
                    if (_local_4 > 1)
                    {
                        _local_3.qtySel = {
                            "min":1,
                            "max":_local_4
                        };
                    }
                }
                _local_3.glow = "white,medium";
                _local_3.greedy = true;
                game.ui.ModalStack.addChild(_local_2);
                _local_2.init(_local_3);
            }
        }

        private function onBtnConvertToImageClick(event:Event) : void {
            game.mixer.playSound("Click");

            SwfToImageConverter.convertItemToImage(iSel.ItemID, iSel.sName, iSel.sES, mcPreview);
        }

        public function onBtnChatShowClick(event:Event): void
        {
            var modal:ModalMC = new ModalMC();
            var modalO:Object = {};
            modalO.strBody = "Do you want to show the item '" + iSel.sName + "' in chat?";
            modalO.greedy = true;
            modalO.params = {};
            modalO.callback = function (o:Object):void
            {
                if (o.accept)
                {
                    var name:String = String(iSel.sName).replace(game.chatF.regExpLinking2, "$1");
                    game.ui.mcInterface.te.htmlText = game.ui.mcInterface.te.htmlText + " <a href='loadItem:" + iSel.CharItemID + ":" + iSel.iRty +"'>&lt;" + name + "&gt;</a> ";
                    game.ui.mcInterface.te.htmlText = game.ui.mcInterface.te.htmlText.replace(game.chatF.regExpSPACE, " ");
                    game.chatF.openMsgEntry();
                }
            };
            modalO.glow = "white,medium";
            game.ui.ModalStack.addChild(modal);
            modal.init(modalO);
            game.mixer.playSound("Click");
        }

        public function onBtnFavoriteClick(_arg_1:Event):void
        {
            game.mixer.playSound("Click");
            game.net.send("favItem", [iSel.CharItemID, iSel.ItemID]);
        }

        public function deleteRequest(_arg_1:Object):void
        {
            if (_arg_1.accept)
            {
                trace(("iqty: " + _arg_1.iQty));
                if (_arg_1.iQty != null)
                {
                    game.world.sendRemoveItemRequest(iSel, _arg_1.iQty);
                }
                else
                {
                    game.world.sendRemoveItemRequest(iSel);
                }
            }
        }

        protected function loadPreview(o:Object):void
        {
            if (o.sType.toLowerCase() == "enhancement")
            {
                clearPreview();
                loadEnhancement(o);
            }
            else if (o.sType.toLowerCase() == "rune")
            {
                loadBag(o);
            }
            else
            {
                if (curItem != o)
                {
                    curItem = o;
                    switch (o.sES)
                    {
                        case "Weapon":
                            loadWeapon(o.sFile, o.sLink);
                            break;
                        case "he":
                            loadHelm(o.sFile, o.sLink);
                            break;
                        case "ba":
                            loadCape(o.sFile, o.sLink);
                            break;
                        case "pe":
                            loadPet(o.sFile, o.sLink);
                            break;
                        case "ar":
                        case "co":
                            loadArmor(o.sFile, o.sLink);
                            break;
                        case "ho":
                            loadHouse(o.sFile);
                            break;
                        case "hi":
                            loadHouseItem(o.sFile, o.sLink);
                            break;
                        default:
                            if (o.sType.toLowerCase() == "item" && String(o.sLink).toLowerCase() != "none")
                            {
                                loadBag(o);
                            }
                            else
                            {
                                if (o.sES == "am")
                                {
                                    loadBag(o, true);
                                }
                                else
                                {
                                    if (((o.sType.toLowerCase() == "serveruse") || (o.sType.toLowerCase() == "clientuse")))
                                    {
                                        loadBag(o);
                                    }
                                    else
                                    {
                                        clearPreview();
                                    }
                                }
                            }
                    }
                }
            }
        }

        public function clearPreview():void
        {
            var _local_3:int;
            clearLoaderStack();
            var _local_1:Boolean = true;
            var _local_2:int;
            while (_local_2 < mcPreview.numChildren)
            {
                _local_1 = true;
                if (("fClose" in MovieClip(mcPreview.getChildAt(_local_2))))
                {
                    game.recursiveStop(MovieClip(mcPreview.getChildAt(_local_2)));
                    _local_3 = 0;
                    while (_local_3 < killStack.length)
                    {
                        if (killStack[_local_3].mc == mcPreview.getChildAt(_local_2))
                        {
                            _local_1 = false;
                        }
                        _local_3++;
                    }
                    if (_local_1)
                    {
                        killStack.push({
                            "c":0,
                            "mc":mcPreview.getChildAt(_local_2)
                        });
                    }
                }
                else
                {
                    mcPreview.removeChildAt(_local_2);
                    _local_2--;
                }
                _local_2++;
            }
            curItem = null;
        }

        private function loadEnhancement(item:*):void
        {
            var mc:MovieClip;
            var AssetClass:Class;
            clearPreview();
            try
            {
                AssetClass = (game.world.getClass("iidesign") as Class);
                mc = new (AssetClass)();
            }
            catch(err:Error)
            {
                trace(err);
            }
            mc.scaleX = (mc.scaleY = 3);
            mcPreview.addChild(mc);
            addGlow(mc);
        }

        private function loadBag(_arg_1:*, _arg_2:Boolean=false):void
        {
            var _local_3:MovieClip;
            clearPreview();
            var _local_4:Class = (game.world.getClass("iibag") as Class);
            if (((_arg_2) || ((((_arg_1 == null) || (!("sFile" in _arg_1))) || (String(_arg_1.sFile).length < 1)) || (game.world.getClass(_arg_1.sFile) == null))))
            {
                _local_4 = (game.world.getClass(_arg_1.sIcon) as Class);
            }
            else
            {
                if (((((!(_arg_1 == null)) && ("sFile" in _arg_1)) && (String(_arg_1.sFile).length > 0)) && (!(game.world.getClass(_arg_1.sFile) == null))))
                {
                    _local_4 = (game.world.getClass(_arg_1.sFile) as Class);
                }
            }
            try
            {
                _local_3 = new (_local_4)();
                _local_3.scaleX = (_local_3.scaleY = 3);
                mcPreview.addChild(_local_3);
                addGlow(_local_3);
            }
            catch(e:Error)
            {
            }
        }

        private function loadWeapon(fileName:String, link:String):void
        {
            sLinkWeapon = link;
            game.onLoadMaster(this.onLoadWeaponComplete, this.pLoaderC, fileName);
        }

        private function loadCape(fileName:String, link:String):void
        {
            sLinkCape = link;
            game.onLoadMaster(this.onLoadCapeComplete, this.pLoaderC, fileName);
        }

        private function loadHelm(fileName:String, link:String):void
        {
            sLinkHelm = link;
            game.onLoadMaster(this.onLoadHelmComplete, this.pLoaderC, fileName);
        }

        private function loadPet(fileName:String, link:String):void
        {
            this.sLinkPet = link;
            game.onLoadMaster(this.onLoadPetComplete, this.pLoaderC, fileName);
        }

        public function loadHouse(fileName:String):void
        {
            trace("LOAD HOUSE!");
            try
            {
//                game.onLoadMaster(this.onLoadHouseComplete, this.pLoaderC, this.curItem.sFile.substr(0, -4) + "_preview.swf");
                game.onLoadMaster(this.onLoadHouseComplete, this.pLoaderC, fileName.substr(0, -4) + "_preview.swf");
            }
            catch (e:Error)
            {
                trace("loadHouse " + e);
            }
        }

        private function onLoadHouseComplete(_arg_1:Event):void
        {
            var AssetClass:Class;
            var mc:MovieClip;
            this.clearPreview();
            trace("onLoadHouseComplete > " + JSON.stringify(curItem));
            try
            {
                AssetClass = this.pLoaderD.getDefinition(this.curItem.sFile.substr(0, -4).substr((this.curItem.sFile.lastIndexOf("/") + 1)).split("-").join("_") + "_preview") as Class;
                mc = new AssetClass;
                mc.x = 150;
                mc.y = 200;
                this.mcPreview.addChild(mc);
                this.addGlow(mc);
            }
            catch (e:Error)
            {
                trace("onLoadHouseComplete " + e);
            }
        }

        private function loadArmor(fileName:String, link:String):void
        {
            this.sLinkArmor = link;
            game.onLoadMaster(this.onLoadArmorComplete, this.pLoaderC, "classes/" + this.Gender + "/" + fileName);
        }

        private function onLoadWeaponComplete(event:Event):void
        {
            var mc:MovieClip;
            var AssetClass:Class;
            clearPreview();

            try
            {
                AssetClass = this.pLoaderD.getDefinition(this.sLinkWeapon) as Class;
                mc = new AssetClass;
            }
            catch (err:Error)
            {
                mc = event.target.content;
            }

            mc.scaleY = 0.3;
            mc.scaleX = 0.3;
            mcPreview.addChild(mc);
            addGlow(mc);
        }

        private function onLoadCapeComplete(_arg_1:Event):void
        {
            var AssetClass:Class;
            var mc:MovieClip;
            clearPreview();
            try
            {
                AssetClass = this.pLoaderD.getDefinition(this.sLinkCape) as Class;
                mc = new AssetClass;
                mc.scaleY = 0.5;
                mc.scaleX = 0.5;
                this.mcPreview.addChild(mc);
                this.addGlow(mc);
            }
            catch (e:Error)
            {
                trace("onLoadCapeComplete " + e);
            }
        }

        private function onLoadHelmComplete(event:Event):void
        {
            var AssetClass:Class;
            var mc:MovieClip;
            clearPreview();
            try
            {
                AssetClass = this.pLoaderD.getDefinition(this.sLinkHelm) as Class;
                mc = new AssetClass;
                mc.scaleY = 0.8;
                mc.scaleX = 0.8;
                mcPreview.addChild(mc);
                addGlow(mc);
            }
            catch (e:Error)
            {
                trace("onLoadHelmComplete " + e);
            }
        }

        private function onLoadArmorComplete(_arg_1:Event):void
        {
            this.clearPreview();
            var _loc_2:* = AvatarMC(this.mcPreview.addChild(new AvatarMC()));
            _loc_2.visible = false;
            _loc_2.strGender = this.Gender;
            if (((btnMGender.visible) || (btnFGender.visible)))
            {
                _loc_2.strGender = ((btnMGender.visible) ? "M" : "F");
            }
            _loc_2.pAV = game.world.myAvatar;
            _loc_2.world = MovieClip(Game.root).world;
            _loc_2.hideHPBar();
            _loc_2.name = "previewMCB";
            this.addGlow(_loc_2.mcChar, false);
            _loc_2.loadArmorPiecesFromDomain(this.sLinkArmor, this.pLoaderD);
            _loc_2.visible = true;
            preventSpam = false;
        }

        private function onLoadPetComplete(_arg_1:Event):void
        {
            var AssetClass:Class;
            var mc:MovieClip;
            clearPreview();
            try
            {
                AssetClass = pLoaderD.getDefinition(this.sLinkPet) as Class;
                mc = new AssetClass;
                mc.scaleY = 2;
                mc.scaleX = 2;
                mcPreview.addChild(mc);
                addGlow(mc);
            }
            catch (e:Error)
            {
                trace("onLoadHelmComplete " + e);
            }
        }

        protected function onBtnGender(_arg_1:MouseEvent):void
        {
            trace("onBtnGender");
            if (preventSpam || !iSel)
            {
                trace("preventSpam");
                return;
            }

            clearPreview();

            var _local_2:String = ((_arg_1.currentTarget.name == "btnMGender") ? "F" : "M");
            btnMGender.visible = (_local_2 == "M");
            btnFGender.visible = (_local_2 == "F");
            sLinkArmor = iSel.sLink;

            game.onLoadMaster(this.onLoadArmorComplete, this.pLoaderC, "classes/" + _local_2 + "/" + iSel.sFile);

            preventSpam = true;
        }

        private function addGlow(_arg_1:MovieClip, _arg_2:Boolean=true):void
        {
            var _local_3:* = new GlowFilter(0xFFFFFF, 1, 8, 8, 2, 1, false, false);
            _arg_1.filters = [_local_3];
            if (_arg_2)
            {
                repositionPreview(_arg_1);
            }
        }

        public function repositionPreview(_arg_1:MovieClip):void
        {
            var _local_2:Rectangle = _arg_1.getBounds(this);
            if (_local_2.height > 175)
            {
                _arg_1.scaleX = (_arg_1.scaleX * (175 / _local_2.height));
                _arg_1.scaleY = (_arg_1.scaleY * (175 / _local_2.height));
            }
            _arg_1.x = (_arg_1.x - int(((_arg_1.getBounds(this).x + (_arg_1.getBounds(this).width / 2)) - (this.width / 2))));
            _arg_1.y = int((_arg_1.y - _arg_1.getBounds(this).y));
        }

        public function loadHouseItem(_arg_1:*, _arg_2:*):void
        {
            clearPreview();
            var _local_3:* = new Loader();
            previewArgs.sLink = _arg_2;
            _local_3.load(new URLRequest((Game.serverBaseURL + _arg_1)), pLoaderC);
            _local_3.contentLoaderInfo.addEventListener(Event.COMPLETE, onloadHouseItemComplete, false, 0, true);
            addToLoaderStack(_local_3);
        }

        private function onloadHouseItemComplete(_arg_1:Event):void
        {
            removeFromLoaderStack(_arg_1.target);
            var _local_2:Class = (pLoaderD.getDefinition(previewArgs.sLink) as Class);
            var _local_3:* = new (_local_2)();
            mcPreview.addChild(_local_3);
            addGlow(_local_3);
        }

        public function onDeleteTTOver(_arg_1:MouseEvent):void
        {
            game.ui.ToolTip.openWith({"str":"Delete item"});
        }

        public function onDeleteTTOut(_arg_1:MouseEvent):void
        {
            game.ui.ToolTip.close();
        }

        public function onConvertToImageTTOver(_arg_1:MouseEvent):void
        {
            game.ui.ToolTip.openWith({"str":"Convert swf to image"});
        }

        public function onConvertToImageTTOut(_arg_1:MouseEvent):void
        {
            game.ui.ToolTip.close();
        }

        public function onChatShowTTOver(_arg_1:MouseEvent):void
        {
            game.ui.ToolTip.openWith({"str":"Show Item"});
        }

        public function onChatShowTTOut(_arg_1:MouseEvent):void
        {
            game.ui.ToolTip.close();
        }

        public function onFavoriteTTOver(_arg_1:MouseEvent):void
        {
            game.ui.ToolTip.openWith({"str":"Favorite item"});
        }

        public function onFavoriteTTOut(_arg_1:MouseEvent):void
        {
            game.ui.ToolTip.close();
        }

        public function onUpgradeTTOver(_arg_1:MouseEvent):void
        {
            game.ui.ToolTip.openWith({"str":"This item is exclusive to upgraded members."});
        }

        public function onUpgradeTTOut(_arg_1:MouseEvent):void
        {
            game.ui.ToolTip.close();
        }

        protected function onGenderTTOver(_arg_1:MouseEvent):void
        {
            game.ui.ToolTip.openWith({"str":"Switch Gender"});
        }

        protected function onGenderTTOut(_arg_1:MouseEvent):void
        {
            game.ui.ToolTip.close();
        }

        private function addToLoaderStack(_arg_1:Loader):void
        {
            clearLoaderStack();
            loaderStack.push(_arg_1);
        }

        private function removeFromLoaderStack(_arg_1:Object):void
        {
            var _local_2:Loader;
            for each (_local_2 in loaderStack)
            {
                if (_local_2.contentLoaderInfo == _arg_1)
                {
                    loaderStack.splice(loaderStack.indexOf(_local_2), 1);
                }
            }
        }

        private function clearLoaderStack():void
        {
            var _local_1:Loader;
            while (loaderStack.length > 0)
            {
                _local_1 = loaderStack.shift();
                try
                {
                    _local_1.removeEventListener(Event.INIT, onLoadWeaponComplete);
                    _local_1.removeEventListener(Event.INIT, onLoadArmorComplete);
                    _local_1.removeEventListener(Event.COMPLETE, onLoadCapeComplete);
                    _local_1.removeEventListener(Event.COMPLETE, onLoadHelmComplete);
                    _local_1.removeEventListener(Event.COMPLETE, onLoadPetComplete);
                    _local_1.removeEventListener(Event.COMPLETE, onLoadHouseComplete);
                    _local_1.removeEventListener(Event.COMPLETE, onloadHouseItemComplete);
                    _local_1.close();
                }
                catch(e:Error)
                {
                }
            }
        }

        public function onEF(_arg_1:Event):void
        {
            var _local_2:int;
            while (_local_2 < killStack.length)
            {
                if (killStack[_local_2].c++ > 2)
                {
                    mcPreview.removeChild(killStack[_local_2].mc);
                    killStack.splice(_local_2, 1);
                    _local_2--;
                }
                _local_2++;
            }
        }


    }
}//package 

