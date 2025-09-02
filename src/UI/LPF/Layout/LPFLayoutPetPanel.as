// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//LPFLayoutPetPanel

package UI.LPF.Layout
{
import UI.LPF.Panel.LPFPanelPetPanel;

import flash.display.MovieClip;
    import flash.display.*;
    import flash.text.*;

    public class LPFLayoutPetPanel extends LPFLayout 
    {

        public var iSel:Object;
        public var bSel:Object;
        public var itemsI:Array;
        public var itemsB:Array;
        public var bankPanel:MovieClip;
        public var game:Game = Game.root;

        public function LPFLayoutPetPanel():void
        {
            x = 0;
            y = 0;
            panels = [];
            fData = {};
        }

        override public function fOpen(_arg_1:Object):void
        {
            var _local_2:Object;
            var _local_3:Object;
            var _local_4:MovieClip;
            fData = _arg_1.fData;
            sMode = _arg_1.sMode;

            if (("itemsI" in fData))
            {
                itemsI = fData.itemsI;
            }
            if (("itemsB" in fData))
            {
                itemsB = fData.itemsB;
            }

            _local_2 = _arg_1.r;

            x = _local_2.x;
            y = _local_2.y;
            w = _local_2.w;
            h = _local_2.h;
            _local_3 = {};
            _local_3.panel = new LPFPanelPetPanel();
            _local_3.fData = {
                "itemsI":itemsI,
                "itemsB":itemsB,
                "avatar":game.world.myAvatar,
                "objData":fData.objData
            };
            _local_3.r = {
                "x":30,
                "y":0,
                "w":900,
                "h":400
            };
            _local_3.isOpen = true;
            bankPanel = addPanel(_local_3);
            game.dropStackBoost();
        }

        override public function fClose():void
        {
            var _local_1:MovieClip;
            game.dropStackReset();
            while (panels.length > 0)
            {
                panels[0].mc.fClose();
                panels.shift();
            }
            if (parent != null)
            {
                _local_1 = MovieClip(parent);
                _local_1.removeChild(this);
                _local_1.onClose();
            }
        }

        override protected function handleUpdate(_arg_1:Object):Object
        {
            var _local_2:Object;
            var _local_3:Boolean;
            var _local_6:Object;
            trace(("LayoutINVENH.handleUpdate > " + _arg_1.eventType));
            var _local_4:Object = iSel;
            var _local_5:Object = bSel;
            if (_arg_1.eventType == "inventorySel")
            {
                iSel = _arg_1.fData;
                if (_local_4 == iSel)
                {
                    iSel = null;
                }
                _arg_1.fData = {"iSel":iSel};
            }
            if (_arg_1.eventType == "bankSel")
            {
                bSel = _arg_1.fData;
                if (_local_5 == bSel)
                {
                    bSel = null;
                }
                _arg_1.fData = {"bSel":bSel};
            }
            if (_arg_1.eventType == "categorySel")
            {
                bSel = null;
                if (game.world.bankHasRequested(_arg_1.fData.types))
                {
                    trace("  Drawing Bank locally");
                    _arg_1.eventType = "refreshBank";
                }
                else
                {
                    _arg_1.fData.loadPending = true;
                    _arg_1.fData.msg = "Loading...";
                    trace("  Sending Bank request");
                    game.world.sendLoadBankRequest(_arg_1.fData.types);
                }
            }
            if (_arg_1.eventType == "sendBankFromInvRequest")
            {
                trace("  Sending Inv->Bank request");
                game.world.feedPet(iSel);
                iSel = null;
            }
            if (_arg_1.eventType == "sendBankToInvRequest")
            {
                trace("  Sending Bank->Inv request");
                game.world.sendBankToInvRequest(bSel);
                bSel = null;
            }
            if (_arg_1.eventType == "sendBankSwapInvRequest")
            {
                trace("  Sending Inv<->Bank request");
                game.world.sendBankSwapInvRequest(bSel, iSel);
                iSel = null;
                bSel = null;
            }
            if (_arg_1.eventType == "buyBagSlots")
            {
                _local_3 = true;
                game.world.loadMovieFront(game.bagSpace, "Inline Asset");
                fClose();
            }
            updatePreviewButtons(_local_6);
            _local_4 = null;
            _local_5 = null;
            if (!_local_3)
            {
                return (_arg_1);
            }
            return (null);
        }

        private function updatePreviewButtons(_arg_1:Object=null, _arg_2:Object=null):void
        {
            var _local_3:Object = {};
            if (((!(_arg_1 == null)) && (!(_arg_2 == null))))
            {
                _local_3 = _arg_2;
            }
            else
            {
                _local_3.eventType = "previewButton1Update";
                _local_3.fData = {};
                _local_3.fData.sText = "";
                _local_3.sMode = "grey";
                _local_3.buttonNewEventType = "";
                if (((!(iSel == null)) && (bSel == null)))
                {
                    _local_3.fData.sText = "Feed";
                    _local_3.buttonNewEventType = "sendBankFromInvRequest";
                    _local_3.sMode = "red";
                }
                else
                {
                    if (((iSel == null) && (!(bSel == null))))
                    {
                        _local_3.fData.sText = "To Inventory >";
                        _local_3.buttonNewEventType = "sendBankToInvRequest";
                        _local_3.sMode = "red";
                    }
                    else
                    {
                        if (((!(iSel == null)) && (!(bSel == null))))
                        {
                            _local_3.fData.sText = "< Swap >";
                            _local_3.buttonNewEventType = "sendBankSwapInvRequest";
                            _local_3.sMode = "red";
                        }
                        else
                        {
                            _local_3.fData.sText = "";
                            _local_3.buttonNewEventType = "";
                        }
                    }
                }
            }
            notifyByEventType(_local_3);
        }

        public function getTabStates(_arg_1:Object=null, _arg_2:Array=null):Array
        {
            var _local_3:String;
            var _local_4:int;
            var _local_5:Object;
            var _local_6:Array = [{
                "sTag":"Show All",
                "icon":"icf3",
                "state":-1,
                "filter":"fdm",
                "mc":{}
            }, {
                "sTag":"Show Food Only",
                "icon":"icf1",
                "state":-1,
                "filter":"fd",
                "mc":{}
            }, {
                "sTag":"Show Drinks Only",
                "icon":"icf4",
                "state":-1,
                "filter":"dr",
                "mc":{}
            }, {
                "sTag":"Show Medicine Only",
                "icon":"ich1",
                "state":-1,
                "filter":"md",
                "mc":{}
            }];
            if (_arg_2 != null)
            {
                for each (_local_3 in _arg_2)
                {
                    _local_4 = 0;
                    while (_local_4 < _local_6.length)
                    {
                        if (_local_6[_local_4].filter == _local_3)
                        {
                            _local_6.splice(_local_4--, 1);
                        }
                        _local_4++;
                    }
                }
            }
            if (_arg_1 != null)
            {
                for each (_local_5 in _local_6)
                {
                    if (_local_5.filter == _arg_1.sES)
                    {
                        return ([_local_5]);
                    }
                }
                return ([_local_6[0]]);
            }
            return (_local_6);
        }


    }
}//package 

