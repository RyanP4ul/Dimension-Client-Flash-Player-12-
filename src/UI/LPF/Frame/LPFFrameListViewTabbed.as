// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//LPFFrameListViewTabbed

package UI.LPF.Frame
{
import UI.LPF.Element.LPFElementListItem;
import UI.LPF.Element.LPFElementListItemItem;
import UI.LPF.Element.LPFElementListViewTab;
import UI.LPF.Element.LPFElementScrollBar;

import flash.text.TextField;
    import flash.display.MovieClip;
    import flash.display.DisplayObject;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    import flash.display.Graphics;
    import flash.text.*;

    public class LPFFrameListViewTabbed extends LPFFrame
    {

        public var tMsg:TextField;
        public var listMask:MovieClip;
        public var bgTabs:MovieClip;
        public var bgList:MovieClip;
        public var tabs:MovieClip;
        public var iList:MovieClip;
        public var scr:LPFElementScrollBar;
        private var listA:Array = [];
        private var aSel:Array = [];
        private var iSel:Object;
        private var tSel:Object;
        private var tabStates:Array = [];
        private var filterMap:Object = {};
        private var itemEventType:String;
        private var tabEventType:String;
        private var sortOrder:Array = [];
        private var filter:String = "";
        private var allowDesel:Boolean = false;
        private var onDemand:Boolean = false;
        private var openBlank:Boolean = false;
        private var refreshTabs:Boolean = false;
        private var bLimited:Boolean = false;
        private var itemList:Array;
        private var sSortType:String;

        public function LPFFrameListViewTabbed():void
        {
            x = 0;
            y = 0;
            fData = {};
        }

        override public function fOpen(_arg_1:Object):void
        {
            fData = _arg_1.fData;
            itemList = fData.list;
            positionBy(_arg_1.r);
            drawBG();
            if (("tabStates" in _arg_1))
            {
                tabStates = _arg_1.tabStates;
            }
            if (("filterMap" in _arg_1))
            {
                filterMap = _arg_1.filterMap;
            }
            if (("sortOrder" in _arg_1))
            {
                sortOrder = _arg_1.sortOrder;
            }
            if (("eventTypes" in _arg_1))
            {
                eventTypes = _arg_1.eventTypes;
            }
            if (("filter" in _arg_1))
            {
                filter = _arg_1.filter;
            }
            if (("itemEventType" in _arg_1))
            {
                itemEventType = _arg_1.itemEventType;
            }
            if (("tabEventType" in _arg_1))
            {
                tabEventType = _arg_1.tabEventType;
            }
            if (("sName" in _arg_1))
            {
                sName = _arg_1.sName;
            }
            if (("allowDesel" in _arg_1))
            {
                allowDesel = _arg_1.allowDesel;
            }
            if (("openBlank" in _arg_1))
            {
                openBlank = _arg_1.openBlank;
            }
            if (("onDemand" in _arg_1))
            {
                onDemand = _arg_1.onDemand;
            }
            if (("refreshTabs" in _arg_1))
            {
                refreshTabs = _arg_1.refreshTabs;
            }
            if (("bLimited" in fData))
            {
                bLimited = _arg_1.fData.bLimited;
            }
            if ("sTypeSort" in fData)
            {
                sSortType = _arg_1.fData.sTypeSort;
            }
            if (!openBlank)
            {
                if (iSel == null)
                {
                    tSel = getTabByFilter("*");
                }
                else
                {
                    tSel = getTabByFilter(iSel.sType);
                }
            }
            initTabs();
            fDraw();
            getLayout().registerForEvents(this, eventTypes);
        }

        private function fRefresh(_arg_1:Object):void
        {
            if (("tabStates" in _arg_1))
            {
                tabStates = _arg_1.tabStates;
            }
            if (("filterMap" in _arg_1))
            {
                filterMap = _arg_1.filterMap;
            }
            if (("sortOrder" in _arg_1))
            {
                sortOrder = _arg_1.sortOrder;
            }
            if (("eventTypes" in _arg_1))
            {
                eventTypes = _arg_1.eventTypes;
            }
            if (("filter" in _arg_1))
            {
                filter = _arg_1.filter;
            }
            if (("itemEventType" in _arg_1))
            {
                itemEventType = _arg_1.itemEventType;
            }
            if (("tabEventType" in _arg_1))
            {
                tabEventType = _arg_1.tabEventType;
            }
            if (("sName" in _arg_1))
            {
                sName = _arg_1.sName;
            }
            iSel = null;
            tSel = getTabByFilter("*");
            if (fData.list != null)
            {
                itemList = fData.list;
            }
            initTabs();
            fDraw();
        }

        private function initTabs():void
        {
            trace("initTabs > 0");
            var mc:MovieClip;
            var iconClass:Object;
            var icon:DisplayObject;
            var fs:String;
            var i:int;
            var j:int;
            var o:Object = {};
            var a:Array = [];
            var s:String = "";
            trace("initTabs > 1");
            while (tabs.numChildren > 0)
            {
                tabs.removeChildAt(0);
            }
            trace("initTabs > 2");
            bgTabs.graphics.clear();
            trace("initTabs > 3");
            j = 0;
            while (j < tabStates.length)
            {
                if (onDemand)
                {
                    tabStates[j].state = 0;
                }
                else
                {
                    tabStates[j].state = -1;
                    for each (o in itemList) // fData.list
                    {
                        for (fs in filterMap)
                        {
                            if (((filterMap[fs].indexOf(o.sType) > -1) || ((o.sType == "Enhancement") && (o.sES == fs))))
                            {
                                if (tabStates[j].filter == fs)
                                {
                                    tabStates[j].state = 0;
                                }
                            }
                        }
                    }
                }
                j++;
            }
            trace("initTabs > 4");
            a = [];
            i = 0;
            while (i < tabStates.length)
            {
                o = tabStates[i];
                trace("initTabs > 4 > " + JSON.stringify(o));
                trace("initTabs > 4.1");
                mc = (tabs.addChild(new LPFElementListViewTab()) as MovieClip);
                trace("initTabs > 4.2");
                iconClass = getLayout().game.world.getClass(o.icon);
                trace("initTabs > 4.3");
                icon = mc.icon.addChild(new (iconClass)());
                trace("initTabs > 4.4");
                icon.scaleX = (icon.scaleY = (16 / icon.height));
                icon.x = (icon.x - (icon.width / 2));
                icon.y = 2;
                mc.icon.mouseEnabled = false;
                mc.icon.mouseChildren = false;
                mc.o = o;
                o.mc = mc;
                mc.bg2.visible = false;
                if (o == tSel)
                {
                    o.state = 1;
                }
                if (o.state == -1)
                {
                    mc.icon.alpha = 0.3;
                    mc.bg3.visible = true;
                    mc.bg2.visible = false;
                    mc.bg.visible = false;
                    mc.mouseEnabled = false;
                    mc.mouseChildren = false;
                }
                else
                {
                    mc.bg3.visible = false;
                    mc.buttonMode = true;
                    if (o.state == 1)
                    {
                        mc.bg.visible = false;
                        mc.bg2.visible = true;
                    }
                    mc.addEventListener(MouseEvent.MOUSE_DOWN, tabClick, false, 0, true);
                }
                mc.x = (int(((mc.width + 3) * i)) + 1);
                a.push(mc.getBounds(this.bgTabs));
                i++;
            }
            trace("initTabs > 5");
            drawTabBG();
            trace("initTabs > 6");
        }

        private function fDraw(_arg_1:Boolean=true):void
        {
            var _local_8:String;
            var _local_10:LPFElementListItemItem;
            var _local_12:DisplayObject;
            var _local_13:DisplayObject;
            listA = [];
            var _local_2:Array = [];
            var _local_3:Array = [];
            var _local_4:Array = [];
            var _local_5:Array = [];
            var _local_6:int;
            var _local_7:int;
            var _local_9:Object = {};

            sSortType = getLayout().game.preference.data.sSortType != null ? getLayout().game.preference.data.sSortType : "Default";

            while (iList.numChildren > 0)
            {
                LPFElementListItem(iList.getChildAt(0)).fClose();
            }

            if (_arg_1)
            {
                iList.y = (bgTabs.height - 1);
            }

            if (tSel == null)
            {
                setMessage("No Tab Selected");
                scr.fOpen({
                    "subject":iList,
                    "subjectMask":listMask,
                    "reset":_arg_1
                });
                return;
            }

            setMessage(itemList.length > 0 ? "" : "No items");

            if (tSel.filter != "*")
            {
                for each (_local_9 in itemList)
                {
                    if (filterMap[tSel.filter].indexOf(_local_9.sType) > -1)
                    {
                        _local_5.push(_local_9);
                    }
                }
            }
            else
            {
                _local_5 = itemList;
            }

            if (((onDemand) && (_local_5.length == 0)))
            {
                setMessage("No items of this type");
                scr.fOpen({
                    "subject":iList,
                    "subjectMask":listMask,
                    "reset":_arg_1
                });
                return;
            }

            _local_6 = 0;
            while (_local_6 < sortOrder.length)
            {
                _local_2 = [];
                for each (_local_9 in _local_5)
                {
                    if (_local_9.sType == sortOrder[_local_6])
                    {
                        _local_2.push(_local_9);
                    }
                }
                if (_local_2.length > 0)
                {
                    _local_2.sortOn(["sName", "iLvl"], [undefined, (Array.DESCENDING | Array.NUMERIC)]);
                    listA = listA.concat(_local_2);
                }
                _local_6++;
            }

            _local_2 = [];
            for each (_local_9 in _local_5)
            {
                if (listA.indexOf(_local_9) == -1)
                {
                    _local_2.push(_local_9);
                }
            }

            if (_local_2.length > 0)
            {
                _local_2.sortOn(["sType", "sName"]);
                listA = listA.concat(_local_2);
            }

            if (sSortType != "Default")
            {
                if (sSortType == "Recent")
                {
                    listA.sortOn("dPurchase", Array.NUMERIC | Array.DESCENDING);
                }
                else
                {
                    listA.sort(function (a:Object, b:Object):int {
                        return customSort(a, b, sSortType);
                    });
                }
            }

            var _local_11:Object = {};
            _local_11.eventType = itemEventType;
            _local_11.allowDesel = allowDesel;
            _local_11.bLimited = ((bLimited) && (getLayout().sMode == "shopBuy"));
            _local_6 = 0;
            while (_local_6 < listA.length)
            {
                _local_11.fData = listA[_local_6];
                _local_10 = new LPFElementListItemItem();
                _local_12 = iList.addChild(_local_10);
                _local_10.subscribeTo(this);
                _local_10.fOpen(_local_11);
                if (_local_10.fData == iSel)
                {
                    _local_10.select();
                }
                if (_local_6 > 0)
                {
                    _local_13 = iList.getChildAt((_local_6 - 1));
                    _local_12.y = (_local_13.y + _local_13.height);
                }
                _local_6++;
            }

            scr.fOpen({
                "subject":iList,
                "subjectMask":listMask,
                "reset":_arg_1
            });
        }

        private function customSort(a:Object, b:Object, sortType:String):int {
            switch (sortType) {
                case "Favorite":return a.bFav > b.bFav ? -1 : a.bFav < b.bFav ? 1 : 0;
                case "Level":return a.iLvl > b.iLvl ? -1 : a.iLvl < b.iLvl ? 1 : 0;
                case "Rarity":return a.iRty > b.iRty ? -1 : a.iRty < b.iRty ? 1 : 0;
                case "Name":return a.sName.localeCompare(b.sName);
                default:return 0;
            }
        }

        private function getTabByFilter(_arg_1:String):Object
        {
            var _local_2:Object;
            var _local_3:int = 0;
            while (_local_3 < tabStates.length)
            {
                _local_2 = tabStates[_local_3];
                if (_local_2.filter == _arg_1)
                {
                    return (_local_2);
                }
                _local_3++;
            }
            if (((tabStates.length > 0) && (!(_arg_1 == "none"))))
            {
                return (tabStates[0]);
            }
            return null;
        }

        private function tabClick(o:MouseEvent):void
        {
            var _local_3:Object;
            var _local_2:Object = MovieClip(o.currentTarget).o;
            if (tSel != null)
            {
                tSel.mc.bg.visible = true;
                tSel.mc.bg2.visible = false;
                tSel.state = 0;
            }
            tSel = _local_2;
            tSel.mc.bg.visible = false;
            tSel.mc.bg2.visible = true;
            tSel.state = 1;
            drawTabBG();
            if (onDemand)
            {
                _local_3 = {
                    "fData":{"types":filterMap[tSel.filter]},
                    "eventType":tabEventType,
                    "fCaller":sName
                };
                while (iList.numChildren > 0)
                {
                    LPFElementListItem(iList.getChildAt(0)).fClose();
                }
                iList.y = (bgTabs.height - 1);
                update(_local_3);
            }
            else
            {
                fDraw();
            }
        }

        private function drawTabBG():void
        {
            if (tSel != null)
            {
                bgTabs.bg.x = tSel.mc.x;
                bgTabs.bg.visible = true;
            }
            else
            {
                bgTabs.bg.visible = false;
            }
        }

//        private function drawTabBG():void
//        {
//            var _local_1:Rectangle;
//            var _local_2:Rectangle;
//            var _local_5:MovieClip;
//            var _local_3:Graphics = bgTabs.graphics;
//            var _local_4:int = (bgTabs.bg.height - 1);
////            _local_3.clear();
////            _local_3.lineStyle(0, 0x666666, 1);
////            _local_3.moveTo(0, _local_4);
//            if (tSel != null)
//            {
//                _local_5 = tSel.mc;
////                if (_local_5.x > 1)
////                {
////                    _local_3.lineTo(tSel.mc.x, _local_4);
////                }
////                _local_3.moveTo((tSel.mc.x + tSel.mc.width), _local_4);
////                _local_3.lineTo(bgList.width, _local_4);
////                tSel.mc.x--;
//                bgTabs.bg.x = tSel.mc.x;
//                bgTabs.bg.visible = true;
//            }
//            else
//            {
////                _local_3.lineTo(bgList.width, _local_4);
//                bgTabs.bg.visible = false;
//            }
//        }

        private function setMessage(_arg_1:String):void
        {
            if (((!(_arg_1 == null)) && (_arg_1.length > 0)))
            {
                tMsg.text = _arg_1;
                tMsg.visible = true;
            }
            else
            {
                tMsg.text = "";
                tMsg.visible = false;
            }
        }

        override public function update(_arg_1:Object):void
        {
            if (_arg_1.eventType == itemEventType)
            {
                iSel = _arg_1.fData;
            }
            if (_arg_1.eventType == tabEventType)
            {
                iSel = null;
            }
            getLayout().update(_arg_1);
        }

        override public function notify(_arg_1:Object):void
        {
            if (_arg_1.eventType == "sModeSet")
            {
                fData = _arg_1.fData;
                fRefresh(_arg_1);
            }
            if (_arg_1.eventType == "refreshItems")
            {
                if (fData.isBank)
                {
                    itemList = getLayout().game.world.bankinfo.items;
                }
                if (itemList.indexOf(iSel) == -1)
                {
                    iSel = null;
                }
                fDraw(false);
                if (refreshTabs)
                {
                    initTabs();
                }
            }
            if (_arg_1.eventType == "refreshTestShop")
            {
                itemList = getLayout().game.world.filtered_list;
                iSel = null;
                tSel = getTabByFilter("*");
                initTabs();
                fDraw(true);
            }
            if (_arg_1.eventType == "refreshInv")
            {
                itemList = getLayout().game.world.filtered_list;
                fDraw(true);
            }
            if (_arg_1.eventType == "refreshOption")
            {
                sSortType = _arg_1.fData.sTypeSort;
                getLayout().game.preference.data.sSortType = sSortType;
                getLayout().game.preference.flush();
                fDraw(true);
            }
            if (_arg_1.eventType == "refreshBank")
            {
                if (fData.isBank)
                {
                    itemList = getLayout().game.world.bankinfo.items;
                }
                fDraw((!(fData.isBank == null)));
            }
            if (_arg_1.eventType == "listItemASel")
            {
                fRefresh(_arg_1);

                if (filter != "")
                {
                    shadeListByTypeFilter(_arg_1.fData);
                }
            }
            if (((_arg_1.eventType == tabEventType) && (!(_arg_1.fData == null))))
            {
                if (("loadPending" in _arg_1.fData))
                {
                    if (("msg" in _arg_1.fData))
                    {
                        setMessage(_arg_1.fData.msg);
                    }
                }
            }
        }

        private function shadeListByTypeFilter(_arg_1:Object):void
        {
            var _local_2:MovieClip;
            var _local_3:Object;
            var _local_4:int;
            if (_arg_1.eSel != null)
            {
                _local_3 = _arg_1.eSel;
            }
            if (_arg_1.iSel != null)
            {
                _local_3 = _arg_1.iSel;
            }
            if (_local_3 != null)
            {
                _local_4 = 0;
                while (_local_4 < iList.numChildren)
                {
                    _local_2 = (iList.getChildAt(_local_4) as MovieClip);
                    if (((_local_2.fData[filter] == _local_3[filter]) && (!(_local_2.fData.sType == _local_3.sType))))
                    {
                        _local_2.alpha = 1;
                        _local_2.mouseEnabled = true;
                        _local_2.mouseChildren = true;
                    }
                    else
                    {
                        _local_2.alpha = 0.3;
                        _local_2.mouseEnabled = false;
                        _local_2.mouseChildren = false;
                    }
                    _local_4++;
                }
            }
        }

        public function getListItemByiSel():MovieClip
        {
            var _local_2:MovieClip;
            var _local_1:int;
            _local_1 = 0;
            while (_local_1 < iList.numChildren)
            {
                _local_2 = MovieClip(iList.getChildAt(_local_1));
                if (_local_2.fData == iSel)
                {
                    return (_local_2);
                }
                _local_1++;
            }
            return null;
        }

        private function drawBG():void
        {
            bgList.width = w;
            bgList.height = ((h - listMask.y) + 3);
            bgList.y = listMask.y;
            listMask.width = w;
            listMask.height = ((h - listMask.y) - 0);
//            scr.height = 220;
            scr.b.height = ((listMask.height - (2 * scr.a2.height)) + 1);
            scr.hit.height = scr.b.height;
            scr.hit.alpha = 0;
            scr.a2.y = ((scr.b.y + scr.b.height) + scr.a2.height);
            scr.x = (w + 2);
            tMsg.x = Math.round(((bgList.width / 2) - (tMsg.width / 2)));
            tMsg.y = Math.round((bgList.y + ((bgList.height / 2) - (tMsg.height / 2))));
        }


    }
}//package 

