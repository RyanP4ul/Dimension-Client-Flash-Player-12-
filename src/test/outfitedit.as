// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//outfitedit

package test
{
    import flash.display.MovieClip;
    import flash.text.TextField;
    import flash.display.SimpleButton;
    import flash.geom.ColorTransform;
    import flash.utils.getDefinitionByName;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.display.Shape;
    import fl.motion.Color;
    import flash.geom.Point;

    public class outfitedit extends MovieClip 
    {

        public var hair3:MovieClip;
        public var cat0:MovieClip;
        public var mcPencil:MovieClip;
        public var armor1:MovieClip;
        public var cat1:MovieClip;
        public var armor2:MovieClip;
        public var cat2:MovieClip;
        public var armor3:MovieClip;
        public var cat3:MovieClip;
        public var cat4:MovieClip;
        public var cat5:MovieClip;
        public var cat6:MovieClip;
        public var cat7:MovieClip;
        public var txtSearch:TextField;
        public var cat8:MovieClip;
        public var txtSetName:TextField;
        public var bg:MovieClip;
        public var btnCancel:SimpleButton;
        public var txtUpdate:TextField;
        public var bg2:MovieClip;
        public var scr:MovieClip;
        public var btnUpdate:SimpleButton;
        public var hair1:MovieClip;
        public var hair2:MovieClip;
        public var btnBack:SimpleButton;
        private var m:Outfit;
        private var game:Game;
        private var world:World;
        private var originalName:String;
        private var outfit:Object;
        private var outfitIndex:int;
        private var s_sES:Array = ["he", "ba", "ar", "co", "Weapon", "pe", "am", "mi"];
        internal var activeTab:int = 0;
        private var tabs:Array = ["all", "Weapon", "co", "ar", "he", "ba", "pe", "am", "mi"];
        private var itemList:MovieClip;
        private var mask_mc:MovieClip;
        private var mDown:Boolean = false;
        private var greyoutCT:ColorTransform = new ColorTransform(0, 0, 0, 1, 40, 40, 40, 0);

        public function outfitedit(main:Outfit, game:Game, _outfitIndex:int)
        {
            var item:*;
            var avt:*;
            super();
            this.m = main;
            this.game = game;
            this.world = game.world;

            if (_outfitIndex == -1)
            {
                avt = this.m.pAV;
                this.outfit = {
                    "name":"Set Name",
                    "colors":{
                        "hair":avt.objData.intColorHair,
                        "skin":avt.objData.intColorSkin,
                        "eye":avt.objData.intColorEye,
                        "base":avt.objData.intColorBase,
                        "trim":avt.objData.intColorTrim,
                        "accessory":avt.objData.intColorAccessory
                    }
                };
                for each (item in avt.items)
                {
                    if (item.bEquip)
                    {
                        this.outfit[item.sES] = item.ItemID;
                    }
                }
                this.originalName = "";
            }
            else
            {
                this.outfit = this.m.sets[_outfitIndex];
                this.originalName = this.outfit.name;
            }
            this.outfitIndex = _outfitIndex;
            this.initInterface();
        }

        public function btnItem():MovieClip
        {
            var AssetClass:Class = (getDefinitionByName("test.itementry") as Class);
            return (new (AssetClass)() as MovieClip);
        }

        public function handleEmpty(val:String):int
        {
            return ((val == "") ? -1 : parseInt(val));
        }

        public function onSetUpdate(e:MouseEvent):void
        {
            if (this.outfitIndex == -1)
            {
                if (this.m.sets.length >= this.m.slots)
                {
                    this.game.MsgBox.notify("You have no more free outfit slots!");
                    return;
                }
            }
//            if (!this.world.coolDown("addLoadout"))
//            {
//                this.m.slowDown();
//                return;
//            }
            var avt:* = this.m.pAV;
            this.outfit.name = this.txtSetName.text;
            if (this.outfitIndex != -1)
            {
                this.outfit.colors = {
                    "hair":this.world.myAvatar.objData.intColorHair,
                    "skin":this.world.myAvatar.objData.intColorSkin,
                    "eye":this.world.myAvatar.objData.intColorEye,
                    "base":this.world.myAvatar.objData.intColorBase,
                    "trim":this.world.myAvatar.objData.intColorTrim,
                    "accessory":this.world.myAvatar.objData.intColorAccessory
                };
            }
            else
            {
                this.outfit.colors = {
                    "hair":avt.objData.intColorHair,
                    "skin":avt.objData.intColorSkin,
                    "eye":avt.objData.intColorEye,
                    "base":avt.objData.intColorBase,
                    "trim":avt.objData.intColorTrim,
                    "accessory":avt.objData.intColorAccessory
                };
            }
            var saveObject:Object = this.game.copyObj(this.outfit);
            delete saveObject.name;
            this.game.net.send("addLoadout", [this.outfit.name, JSON.stringify(saveObject), this.originalName]);
        }

        public function onServerResponseUpdate():void
        {
            if (this.outfitIndex != -1)
            {
                m.sets[this.outfitIndex] = this.outfit;
            }
            else
            {
                m.sets.push(this.outfit);
            }
            this.onBack();
        }

        public function setIcon(mc:MovieClip, icon:String, tab:Boolean=false):void
        {
            var iconShapeMC:*;
            var aw:*;
            var ah:*;
            var bw:*;
            var bh:*;
            var AssetClass:Class = (this.world.getClass(icon) as Class);
            if (AssetClass != null)
            {
                iconShapeMC = mc.addChild(new (AssetClass)());
                if (tab)
                {
                    iconShapeMC.scaleX = (iconShapeMC.scaleY = (16 / iconShapeMC.height));
                    iconShapeMC.x = (iconShapeMC.x - (iconShapeMC.width / 2));
                    iconShapeMC.y = 2;
                    mc.mouseEnabled = false;
                    mc.mouseChildren = false;
                    return;
                }
                aw = 23;
                ah = 19;
                bw = iconShapeMC.width;
                bh = iconShapeMC.height;
                if (bw > bh)
                {
                    iconShapeMC.scaleX = (iconShapeMC.scaleY = (aw / bw));
                }
                else
                {
                    iconShapeMC.scaleX = (iconShapeMC.scaleY = (ah / bh));
                }
                iconShapeMC.x = -(iconShapeMC.width / 2);
                iconShapeMC.y = -(iconShapeMC.height / 2);
            }
        }

        public function tabFilter(item:*, index:int, array:Array):Boolean
        {
            if (this.activeTab == 0)
            {
                return (true);
            }
            if (item.sES == this.tabs[this.activeTab])
            {
                return (true);
            }
            return (false);
        }

        public function onTabClick(e:MouseEvent):void
        {
            this.activeTab = e.currentTarget.name.slice(3);
            this.buildMenu((this.m.pAV.items.filter(this.tabFilter) as Array).sortOn(["bEquip", "sType", "sName"], [Array.DESCENDING, Array.DESCENDING, null]));
            this.resetScroll();
        }

        public function initTabs():void
        {
            var index:*;
            var mc:*;
            var icon:String;
            for (index in this.tabs)
            {
                mc = getChildByName(("cat" + index));
                icon = "";
                switch (this.tabs[index])
                {
                    case "all":
                        icon = "iipack";
                        break;
                    case "he":
                        icon = "iihelm";
                        break;
                    case "ba":
                        icon = "iicape";
                        break;
                    case "ar":
                        icon = "iiclass";
                        break;
                    case "co":
                        icon = "iwarmor";
                        break;
                    case "Weapon":
                        icon = "iwsword";
                        break;
                    case "pe":
                        icon = "iipet";
                        break;
                    case "mi":
                        icon = "imr2";
                        break;
                    case "am":
                        icon = "iin1";
                        break;
                }
                this.setIcon(mc.icon, icon, true);
                mc.addEventListener(MouseEvent.CLICK, this.onTabClick, false, 0, true);
            }
        }

        public function initInterface():void
        {
            this.btnBack.addEventListener(MouseEvent.CLICK, this.onBack, false, 0, true);
            this.mcPencil.visible = (this.outfitIndex == -1);
            this.mcPencil.addEventListener(MouseEvent.CLICK, this.onPencil, false, 0, true);
            this.btnUpdate.addEventListener(MouseEvent.CLICK, this.onSetUpdate, false, 0, true);
            this.btnCancel.addEventListener(MouseEvent.CLICK, this.onBack, false, 0, true);
            this.txtSearch.addEventListener(MouseEvent.CLICK, this.onReset, false, 0, true);
            this.txtSearch.addEventListener(Event.CHANGE, this.onSearch, false, 0, true);
            this.txtSetName.addEventListener(MouseEvent.CLICK, this.onReset, false, 0, true);
            this.txtUpdate.mouseEnabled = false;
            this.txtUpdate.text = ((this.outfitIndex == -1) ? "Create Set" : "Update Set");
            var mask_shape:Shape = new Shape();
            mask_shape.graphics.beginFill(0);
            mask_shape.graphics.drawRect(this.bg.x, this.bg.y, this.bg.width, this.bg.height);
            mask_shape.graphics.endFill();
            addChild(mask_shape);
            this.itemList = new MovieClip();
            this.itemList.x = this.bg.x;
            this.itemList.y = this.bg.y;
            addChild(this.itemList);
            this.itemList.mask = mask_shape;
            this.itemList.addEventListener(MouseEvent.MOUSE_WHEEL, this.onScroll, false, 0, true);
            var c:Color = new Color();
            c.setTint(this.outfit.colors.hair, 1);
            this.hair1.transform.colorTransform = c;
            c.setTint(this.outfit.colors.skin, 1);
            this.hair2.transform.colorTransform = c;
            c.setTint(this.outfit.colors.eye, 1);
            this.hair3.transform.colorTransform = c;
            c.setTint(this.outfit.colors.base, 1);
            this.armor1.transform.colorTransform = c;
            c.setTint(this.outfit.colors.trim, 1);
            this.armor2.transform.colorTransform = c;
            c.setTint(this.outfit.colors.accessory, 1);
            this.armor3.transform.colorTransform = c;
            this.txtSetName.text = this.outfit.name;
            this.txtSetName.restrict = "A-Z a-z 0-9";
            this.txtSetName.maxChars = 30;
            this.buildMenu();
            this.initScroll();
            this.initTabs();
        }

        public function resetScroll():void
        {
            this.scr.h.y = 0;
            this.itemList.y = (this.bg.y + (this.scr.h.y * ((this.bg.height - this.itemList.height) / 176)));
        }

        public function onScroll(e:MouseEvent):void
        {
            if (this.itemList.height < this.bg.height)
            {
                return;
            }
            e.delta = (e.delta * 6);
            this.itemList.y = (this.itemList.y + e.delta);
            if (this.itemList.y >= this.bg.y)
            {
                this.itemList.y = this.bg.y;
            }
            if (this.itemList.y <= (this.bg.y + (this.bg.height - this.itemList.height)))
            {
                this.itemList.y = (this.bg.y + (this.bg.height - this.itemList.height));
            }
            this.scr.h.y = ((this.itemList.y - this.bg.y) / ((this.bg.height - this.itemList.height) / 176));
        }

        public function btnHold(e:MouseEvent):void
        {
            this.mDown = true;
            MovieClip(stage.getChildAt(0)).addEventListener(MouseEvent.MOUSE_UP, this.btnRelease, false, 0, true);
        }

        public function btnRelease(e:MouseEvent):void
        {
            this.mDown = false;
            MovieClip(stage.getChildAt(0)).removeEventListener(MouseEvent.MOUSE_UP, this.btnRelease);
        }

        public function onChange(e:Event):void
        {
            var point:Point;
            if (this.mDown)
            {
                if (this.itemList.height < this.bg.height)
                {
                    return;
                }
                point = new Point(MovieClip(stage.getChildAt(0)).mouseX, MovieClip(stage.getChildAt(0)).mouseY);
                this.scr.h.y = this.scr.globalToLocal(point).y;
                if (this.scr.h.y <= 0)
                {
                    this.scr.h.y = 0;
                }
                if (this.scr.h.y >= 176)
                {
                    this.scr.h.y = 176;
                }
                this.itemList.y = (this.bg.y + (this.scr.h.y * ((this.bg.height - this.itemList.height) / 176)));
            }
        }

        public function initScroll():void
        {
            this.scr.hit.alpha = 0;
            this.scr.hit.addEventListener(MouseEvent.MOUSE_DOWN, this.btnHold, false, 0, true);
            this.scr.addEventListener(Event.ENTER_FRAME, this.onChange, false, 0, true);
        }

        public function onBack(e:MouseEvent=null):void
        {
            var sES:*;
            parent.removeChild(this);
            this.m.interfaceOutfitSets.interfaceOutfitEdit = null;
            this.m.interfaceOutfitSets.drawMenu();
            this.m.interfaceOutfitSets.visible = true;
            this.m.pAV.items = game.copyObj(this.world.myAvatar.items);
            this.m.pAV.objData = game.copyObj(this.world.myAvatar.objData);
            var s_sES:Array = ["he", "ba", "ar", "co", "Weapon", "pe", "am", "mi"];
            for each (sES in s_sES)
            {
                if (this.m.pAV.objData.eqp[sES] != null)
                {
                    this.m.pAV.loadMovieAtES(sES, this.m.pAV.objData.eqp[sES].sFile, this.m.pAV.objData.eqp[sES].sLink);
                }
                else
                {
                    this.m.pAV.unloadMovieAtES(sES);
                }
            }
        }

        public function isEquipped(itemID:int):Boolean
        {
            var items:* = this.outfit.layout.split(",");
            if (items.indexOf(itemID) != -1)
            {
                return (true);
            }
            return (false);
        }

        private function getCatCT(sCat:String):ColorTransform
        {
            var redCT:ColorTransform = new ColorTransform(1, 1, 1, 1, 96, 0, 0, 0);
            var greenCT:ColorTransform = new ColorTransform(1, 1, 1, 1, 0, 96, 0, 0);
            var blueCT:ColorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 96, 0);
            var whiteCT:ColorTransform = new ColorTransform(1, 1, 1, 1, 64, 64, 64, 0);
            var orangeCT:ColorTransform = new ColorTransform(1, 1, 1, 1, 96, 36, 0, 0);
            var yellowCT:ColorTransform = new ColorTransform(1, 1, 1, 1, 96, 64, 24, 0);
            var purpleCT:ColorTransform = new ColorTransform(1, 1, 1, 1, 96, 0, 96, 0);
            var greyCT:ColorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0);
            var blackoutCT:ColorTransform = new ColorTransform(0, 0, 0, 1, 0, 0, 0, 0);
            var ct:ColorTransform = greyCT;
            if (sCat == "M1")
            {
                ct = redCT;
            }
            if (sCat == "M2")
            {
                ct = greenCT;
            }
            if (sCat == "M3")
            {
                ct = yellowCT;
            }
            if (sCat == "C1")
            {
                ct = blueCT;
            }
            if (sCat == "C2")
            {
                ct = whiteCT;
            }
            if (sCat == "C3")
            {
                ct = orangeCT;
            }
            if (sCat == "S1")
            {
                ct = purpleCT;
            }
            if (sCat == "none")
            {
                ct = greyCT;
            }
            return (ct);
        }

        public function buildMenu(array:Array=null):void
        {
            var item:*;
            var tgt:*;
            var nameText:String;
            var enh:Object;
            if (!array)
            {
                for each (item in this.m.pAV.items)
                {
                    if (item.ItemID == this.outfit[item.sES])
                    {
                        item.bEquip = 1;
                    }
                    else
                    {
                        item.bEquip = 0;
                    }
                }
                array = this.m.pAV.items.sortOn(["bEquip", "sType", "sName"], Array.DESCENDING);
            }
            while (this.itemList.numChildren > 0)
            {
                this.itemList.removeChildAt(0);
            }
            var ctr:int;
            var uoLeaf:* = this.world.myAvatar.dataLeaf;
//            if (this.world.enhPatternTree == null)
//            {
//                this.world.initPatternTree();
//            }
            for each (item in array)
            {
                if (!(((!(item.sES)) || (item.sES == "None")) || (item.sType == "Enhancement")))
                {
                    if (!((!(["Weapon", "he", "ar", "ba"].indexOf(item.sES) == -1)) && (item.EnhID == 0)))
                    {
                        if (!((item.iLvl > uoLeaf.intLevel) || ((!(item.EnhLvl == null)) && (item.EnhLvl > uoLeaf.intLevel))))
                        {
                            tgt = this.btnItem();
                            nameText = (("<font color='#FFFFFF'>" + item.sName) + "</font>");
                            if (item.bUpg == 1)
                            {
                                nameText = (("<font color='#FCC749'>" + item.sName) + "</font>");
                            }
                            if (((item.iLvl > uoLeaf.intLevel) || ((!(item.EnhLvl == null)) && (item.EnhLvl > uoLeaf.intLevel))))
                            {
                                nameText = (("<font color='#FF0000'>" + item.sName) + "</font>");
                            }
                            tgt.tName.text = "";
                            tgt.tName.htmlText = nameText;
                            tgt.iconAC.visible = item.bCoin;
                            tgt.wearBG.visible = false;
                            tgt.eqpBG.visible = item.bEquip;
                            tgt.selBG.visible = false;
                            this.setIcon(tgt.icon, item.sIcon);
                            if (["Weapon", "he", "ar", "ba"].indexOf(item.sES) > -1)
                            {
                                tgt.iconRing.visible = true;
                                tgt.iconRing.x = (tgt.iconRing.x + 3);
                                tgt.iconRing.y = 5;
                                tgt.iconRing.width = (tgt.iconRing.height = 19);
                                if (item.PatternID != null)
                                {
                                    enh = this.world.enhPatternTree[item.PatternID];
                                }
                                if (item.EnhPatternID != null)
                                {
                                    enh = this.world.enhPatternTree[item.EnhPatternID];
                                }
                                if (enh != null)
                                {
                                    if (enh.hasOwnProperty("COLOR"))
                                    {
                                        tgt.iconRing.bg.transform.colorTransform = enh.COLOR;
                                    }
                                    else
                                    {
                                        tgt.iconRing.bg.transform.colorTransform = this.getCatCT(enh.sDesc);
                                    }
                                }
                                if (((!(item.EnhLvl == null)) && (item.EnhLvl < 1)))
                                {
                                    tgt.icon.transform.colorTransform = this.greyoutCT;
                                }
                            }
                            else
                            {
                                tgt.iconRing.visible = false;
                            }
                            tgt.tLevel.text = "";
                            if (((!(item.EnhLvl == null)) && (item.EnhLvl > 0)))
                            {
                                tgt.tLevel.htmlText = (("<font color='#00CCFF'>" + item.EnhLvl) + "</font>");
                            }
                            else
                            {
                                if (((!(item.iLvl == null)) && (item.iLvl > 0)))
                                {
                                    tgt.tLevel.htmlText = (("<font color='#FFFFFF'>" + item.iLvl) + "</font>");
                                }
                                else
                                {
                                    tgt.tLevel.visible = false;
                                }
                            }
                            tgt.x = 0;
                            tgt.y = ((ctr > 0) ? (ctr * 30) : 0);
                            ctr++;
                            tgt.addEventListener(MouseEvent.CLICK, this.onItemClick, false, 0, true);
                            this.itemList.addChild(tgt);
                        }
                    }
                }
            }
        }

        public function getItem(tName:String):*
        {
            var item:*;
            for each (item in this.m.pAV.items)
            {
                if (item.sName == tName)
                {
                    return (item);
                }
            }
            return (null);
        }

        public function getItemByID(tID:int):*
        {
            var item:*;
            for each (item in this.m.pAV.items)
            {
                if (item.ItemID == tID)
                {
                    return (item);
                }
            }
            return (null);
        }

        public function getItemMC(tID:int):*
        {
            var item:*;
            if (tID == -1)
            {
                return (null);
            }
            var tName:String = "";
            for each (item in this.m.pAV.items)
            {
                if (item.ItemID == tID)
                {
                    tName = item.sName;
                    break;
                }
            }
            if (tName == "")
            {
                return (null);
            }
            var i:int;
            while (i < this.itemList.numChildren)
            {
                if ((this.itemList.getChildAt(i) as MovieClip).tName.text == tName)
                {
                    return (this.itemList.getChildAt(i));
                }
                i++;
            }
            return (null);
        }

        public function onItemClick(e:MouseEvent):void
        {
            var oldItem:*;
            var mc:MovieClip = (e.currentTarget as MovieClip);
            var item:* = this.getItem(mc.tName.text);
            if (((item.bUpg == 1) && (!(this.world.myAvatar.isUpgraded()))))
            {
                this.game.MsgBox.notify("You must be upgraded in order to use this item.");
                return;
            }
            var pAV:* = this.m.pAV;
            if (((!(this.outfit[item.sES])) || (!(this.outfit[item.sES] == item.ItemID))))
            {
                pAV.objData.eqp[item.sES] = item;
                oldItem = this.getItemMC(this.outfit[item.sES]);
                if (oldItem)
                {
                    oldItem.eqpBG.visible = false;
                }
                this.outfit[item.sES] = item.ItemID;
                this.m.pAV.equipItem(item.ItemID);
                pAV.loadMovieAtES(item.sES, item.sFile, item.sLink);
                mc.eqpBG.visible = true;
            }
            else
            {
                if (((!(item.sES == "ar")) && (!(item.sES == "Weapon"))))
                {
                    delete pAV.objData.eqp[item.sES];
                    delete this.outfit[item.sES];
                    this.m.pAV.unequipItem(item.ItemID);
                    pAV.unloadMovieAtES(item.sES);
                    mc.eqpBG.visible = false;
                }
            }
        }

        public function onReset(e:MouseEvent):void
        {
            var isSearch:* = (!(e.currentTarget.name.indexOf("txtSearch") == -1));
            if (((isSearch) && (this.txtSearch.text == "Search for an item")))
            {
                this.txtSearch.text = "";
            }
            if (((!(isSearch)) && (this.txtSetName.text == "Set Name")))
            {
                this.txtSetName.text = "";
                this.mcPencil.visible = false;
            }
        }

        public function onPencil(e:MouseEvent):void
        {
            stage.focus = this.txtSetName;
            this.txtSetName.text = "";
            this.mcPencil.visible = false;
        }

        public function nameSearch(item:*, index:int, array:Array):Boolean
        {
            if (item.sName.toLowerCase().indexOf(this.txtSearch.text.toLowerCase()) != -1)
            {
                return (true);
            }
            return (false);
        }

        public function onSearch(e:Event):void
        {
            this.buildMenu((this.m.pAV.items.filter(this.nameSearch) as Array).sortOn(["bEquip", "sType", "sName"], [Array.DESCENDING, Array.DESCENDING, null]));
        }


    }
}//package 

