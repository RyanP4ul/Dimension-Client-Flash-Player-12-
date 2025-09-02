// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//PVPPanelMC

package 
{
import Game_fla.mcPopup_328;

import flash.display.MovieClip;
    import flash.display.SimpleButton;
import flash.events.Event;
import flash.events.MouseEvent;

    public class PVPPanelMC extends MovieClip 
    {

        public var btnClose:SimpleButton;
        public var cnt:MovieClip;
        private var game:MovieClip = Game.root;
        private var mcPopup:mcPopup_328 = game.ui.mcPopup;
        private var nextMode:String;
        private var itemSel:MovieClip;
        private var pending:Boolean = false;

        public function PVPPanelMC():void
        {
            addFrameScript(0, frame1, 4, frame5, 11, frame12, 24, frame25, 29, frame30, 36, frame37, 49, frame50);
            btnClose.addEventListener(MouseEvent.MOUSE_DOWN, btnCloseClick, false, 0, true);
        }

        public function openWith(fData:Object):void
        {
            nextMode = fData.typ;

            trace("openWidth > " + nextMode);

            if (isValidMode(nextMode))
            {
                if (this.currentLabel != "init" && this.currentLabel.indexOf("-out") < 0)
                {
                    this.gotoAndPlay((this.currentLabel + "-out"));
                }
                else
                {
                    this.gotoAndPlay(nextMode);
                }
            }
        }

        public function fClose():void
        {
            killCurrentListeners();
        }

        private function playNextMode():void
        {
            killCurrentListeners();
            this.gotoAndPlay(nextMode);
        }

        private function isValidMode(mode:String):Boolean
        {
            var isValid:Boolean;
            var i:int = 0;
            while (((i < this.currentLabels.length) && (!(isValid))))
            {
                if (this.currentLabels[i].name == mode)
                {
                    isValid = true;
                }
                i++;
            }
            return (isValid);
        }

        private function update():void
        {
            if (currentLabel == "maps")
            {
                trace("UPDATE > CURRENT LABEL > MAPS");
                updateMaps();
            }
            if (currentLabel == "results")
            {
                trace("UPDATE > CURRENT LABEL > RESULTS");
                updateResults();
            }
        }

        private function updateMaps():void
        {
            var _local_1:Object;
            var _local_2:MovieClip;
            _local_1 = {};
            while (cnt.iList.numChildren > 1)
            {
                cnt.iList.removeChildAt(1);
            }

            trace("UM > 2");
            var _local_3:int;
            var _local_4:int = 0;
            while (_local_4 < game.world.PVPMaps.length)
            {
                _local_1 = game.world.PVPMaps[_local_4];
                if (!_local_1.hidden)
                {
            trace("UM > 3");
                    _local_2 = cnt.iList.addChild(new pvpProto());
                    _local_2.t1.ti.text = _local_1.nam;
                    _local_2.t2.ti.text = _local_1.desc;
                    _local_2.icon.gotoAndStop(_local_1.icon);
                    _local_2.y = (_local_3 * 55);
            trace("UM > 4");
                    _local_2.iSel = false;
                    _local_2.iHi = false;
                    _local_2.label = _local_1.label;
                    _local_2.warzone = _local_1.warzone;
                    _local_2.hit.alpha = 0;
                    _local_2.hit.buttonMode = true;
                    _local_2.hit.addEventListener(MouseEvent.CLICK, onMapItemClick, false, 0, true);
                    _local_2.hit.addEventListener(MouseEvent.MOUSE_OVER, onMapItemOver, false, 0, true);
                    _local_2.hit.addEventListener(MouseEvent.MOUSE_OUT, onMapItemOut, false, 0, true);
            trace("UM > 5");
                    _local_3++;
                }
                _local_4++;
            }
            trace("UM > 6");
            cnt.iList.iproto.visible = false;
            cnt.body.bJoin.addEventListener(MouseEvent.MOUSE_DOWN, btnJoinClick, false, 0, true);
            cnt.body.bExit.addEventListener(MouseEvent.MOUSE_DOWN, btnExitClick, false, 0, true);
            trace("UM > 7");
            cnt.body.bJoin.visible = false;
            cnt.body.bExit.visible = false;
            cnt.body.msg.visible = false;
            cnt.body.gotoAndPlay("init");
            trace("UM > 8");
        }

        private function updateResults():void
        {
            var _local_1:Object = game.world.PVPResults;
            var _local_2:int = _local_1.team;
            if (_local_2 == game.world.myAvatar.dataLeaf.pvpTeam)
            {
                cnt.outlineV.visible = true;
                cnt.outlineL.visible = false;
            }
            else
            {
                cnt.outlineV.visible = false;
                cnt.outlineL.visible = true;
            }
            if (game.world.PVPFactions.length == 0)
            {
                cnt.ti.text = (("Team " + ["A", "B"][_local_2]) + " won!");
            }
            else
            {
                cnt.ti.text = (("The " + game.world.PVPFactions[_local_2].sName) + " team won!");
            }
            cnt.btnBack.addEventListener(MouseEvent.CLICK, btnBackClick, false, 0, true);
        }

        private function onMapItemClick(_arg_1:MouseEvent):void
        {
            var _local_3:MovieClip;
            var _local_2:MovieClip = (_arg_1.currentTarget.parent as MovieClip);
            _local_2.iHi = false;
            if (!_local_2.iSel)
            {
                itemSel = _local_2;
                _local_2.iSel = true;
                _local_2.gotoAndPlay("in2");
            }
            var _local_4:int = 1;
            while (_local_4 < cnt.iList.numChildren)
            {
                _local_3 = (cnt.iList.getChildAt(_local_4) as MovieClip);
                if (_local_3 != _local_2)
                {
                    if (_local_3.iSel)
                    {
                        _local_3.gotoAndPlay("out2");
                    }
                    if (_local_3.iHi)
                    {
                        _local_3.gotoAndPlay("out1");
                    }
                    _local_3.iSel = false;
                    _local_3.iHi = false;
                }
                _local_4++;
            }
            cnt.body.gotoAndStop(_local_2.label);
        }

        private function onMapItemOver(_arg_1:MouseEvent):void
        {
            var _local_3:MovieClip;
            var _local_2:MovieClip = (_arg_1.currentTarget.parent as MovieClip);
            if (((!(_local_2.iHi)) && (!(_local_2.iSel))))
            {
                _local_2.iHi = true;
                _local_2.gotoAndPlay("in1");
            }
            var _local_4:int = 1;
            while (_local_4 < cnt.iList.numChildren)
            {
                _local_3 = (cnt.iList.getChildAt(_local_4) as MovieClip);
                if (_local_3 != _local_2)
                {
                    if (((_local_3.iHi) && (!(_local_3.iSel))))
                    {
                        _local_3.gotoAndPlay("out1");
                    }
                    _local_3.iHi = false;
                }
                _local_4++;
            }
        }

        private function onMapItemOut(_arg_1:MouseEvent):void
        {
            var _local_2:MovieClip = (_arg_1.currentTarget.parent as MovieClip);
            if (((_local_2.iHi) && (!(_local_2.iSel))))
            {
                _local_2.iHi = false;
                _local_2.gotoAndPlay("out1");
            }
        }

        public function updateBody():void
        {
            var _local_1:MovieClip = cnt.body;
            if (pending)
            {
                pending = false;
            }
            if (itemSel.warzone != game.world.PVPQueue.warzone)
            {
                _local_1.bJoin.visible = true;
                _local_1.msg.visible = false;
                _local_1.bExit.visible = false;
            }
            else
            {
                _local_1.bJoin.visible = false;
                _local_1.msg.visible = true;
                _local_1.bExit.visible = true;
            }
        }

        private function killCurrentListeners():void
        {
            if (this.currentLabel == "maps")
            {
                cnt.body.bJoin.removeEventListener(MouseEvent.MOUSE_DOWN, btnJoinClick);
                cnt.body.bExit.removeEventListener(MouseEvent.MOUSE_DOWN, btnExitClick);
            }
            if (this.currentLabel == "results")
            {
                cnt.btnBack.removeEventListener(MouseEvent.CLICK, btnBackClick);
            }
            btnClose.removeEventListener(MouseEvent.MOUSE_DOWN, btnCloseClick);
        }

        private function btnCloseClick(_arg_1:MouseEvent=null):void
        {
            mcPopup.onClose();
        }

        private function btnJoinClick(_arg_1:MouseEvent):void
        {
            if (!pending)
            {
                pending = true;
                game.world.requestPVPQueue(itemSel.warzone);
            }
        }

        private function btnExitClick(_arg_1:MouseEvent):void
        {
            if (!pending)
            {
                pending = true;
                game.world.requestPVPQueue("none");
            }
        }

        private function btnBackClick(_arg_1:MouseEvent):void
        {
            game.world.gotoTown("Battleon", "Enter", "Spawn");
            mcPopup.onClose();
        }

        internal function frame1() : void
        {
            trace("FRAME 1 > " + JSON.stringify(MovieClip(parent).fData));
            openWith(MovieClip(parent).fData);
        }

        internal function frame5() : void
        {
            trace("FRAME 5");
            this.addEventListener(Event.ENTER_FRAME, onReadyToUpdate);
//            update();
        }

        private function onReadyToUpdate(e:Event):void {
            if (cnt && cnt.iList && cnt.body) {
                this.removeEventListener(Event.ENTER_FRAME, onReadyToUpdate);
                update();
            }
        }

        internal function frame12():*
        {
            stop();
        }

        internal function frame25():*
        {
            playNextMode();
        }

        internal function frame30():*
        {
            update();
        }

        internal function frame37():*
        {
            stop();
        }

        internal function frame50():*
        {
            playNextMode();
        }


    }
}//package 

