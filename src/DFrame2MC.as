// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//DFrame2MC

package 
{
    import flash.display.MovieClip;
    import flash.display.DisplayObject;
    import flash.filters.GlowFilter;
    import flash.events.MouseEvent;
    import flash.text.*;

import game.controller.QuestController;

public class DFrame2MC extends MovieClip
    {

        private var game:Game = Game.root;

        public var cnt:MovieClip;
        internal var world:MovieClip;
        public var fData:Object = null;
        private var hasRemaining:Boolean = false;
        private var invItem:Object = null;
        internal var isOpen:Boolean = false;
        internal var iniFrameT:int = 0;
        internal var iniFrameC:int = 0;
        internal var durFrameT:int = 35;
        internal var durFrameC:int = 0;
        internal var mc:MovieClip;
        internal var rarityCA:Array = [0x666666, 0xFFFFFF, 0x66FF00, 2663679, 0xFF00FF, 0xFFCC00, 0xFF0000];
        public var fWidth:int = 250;
        public var fHeight:int = 86;
        public var fX:int = 0;
        public var fY:int = 0;

        public function DFrame2MC(_arg_1:Object):void
        {
            addFrameScript(3, frame4, 11, frame12);
            fData = _arg_1;
        }

        public function init():*
        {
            var AssetClass:Class;
            var mcIcon:DisplayObject;
            mc = MovieClip(this);
            mc.cnt.strName.autoSize = "left";
            mc.cnt.strName.text = fData.sName;

            invItem = game.world.myAvatar.getItemByID(fData.ItemID);

            if (fData.iStk > 1) mc.cnt.strName.text = (mc.cnt.strName.text + (" x" + fData.iQty));

            if (invItem != null && fData.iQty + invItem.iQty > fData.iStk)
            {
                hasRemaining = true;
            }

            mc.cnt.bg.width = Math.max(((mc.cnt.strName.x + int(mc.cnt.strName.textWidth)) + 15), 250);
            mc.cnt.ybtn.bg.width = Math.round((mc.cnt.bg.width / 2));
            mc.cnt.nbtn.bg.width = Math.round((mc.cnt.bg.width - mc.cnt.ybtn.bg.width));
            mc.cnt.nbtn.x = mc.cnt.ybtn.width;
            mc.cnt.ybtn.ti.x = (((mc.cnt.ybtn.bg.width / 2) - (mc.cnt.ybtn.ti.textWidth / 2)) + 4);
            mc.cnt.nbtn.ti.x = (((mc.cnt.nbtn.bg.width / 2) - (mc.cnt.nbtn.ti.textWidth / 2)) - 4);
            mc.cnt.ybtn.ti.mouseEnabled = false;
            mc.cnt.nbtn.ti.mouseEnabled = false;
            mc.cnt.strType.text = game.getDisplaysType(fData);
            var mcFilter:* = mc.cnt.bg.filters;
            game.onRemoveChildren(mc.cnt.icon);
            var sIcon:String = "";
            if (fData.sType.toLowerCase() == "enhancement")
            {
                sIcon = game.getIconBySlot(fData.sES);
            }
            else
            {
                if (((fData.sType.toLowerCase() == "serveruse") || (fData.sType.toLowerCase() == "clientuse")))
                {
                    if (((("sFile" in fData) && (fData.sFile.length > 0)) && (!(game.world.getClass(fData.sFile) == null))))
                    {
                        sIcon = fData.sFile;
                    }
                    else
                    {
                        sIcon = fData.sIcon;
                    }
                }
                else
                {
                    if ((((fData.sIcon == null) || (fData.sIcon == "")) || (fData.sIcon == "none")))
                    {
                        if (fData.sLink.toLowerCase() != "none")
                        {
                            sIcon = "iidesign";
                        }
                        else
                        {
                            sIcon = "iibag";
                        }
                    }
                    else
                    {
                        sIcon = fData.sIcon;
                    }
                }
            }

            try
            {
                AssetClass = (game.world.getClass(sIcon) as Class);
                mcIcon = mc.cnt.icon.addChild(new (AssetClass)());
            }
            catch(e:Error)
            {
                AssetClass = (game.world.getClass("iibag") as Class);
                mcIcon = mc.cnt.icon.addChild(new (AssetClass)());
            }

            mcIcon.scaleX = (mcIcon.scaleY = 0.5);
            mcFilter = new GlowFilter(game.world.rarity[fData.iRty] != null ? game.world.rarity[fData.iRty].Color : 0xFFFFFF, 1, 8, 8, 2, 1, false, false);
            mc.cnt.icon.filters = [mcFilter];
            mc.cnt.ybtn.buttonMode = true;
            mc.cnt.nbtn.buttonMode = true;
            mc.cnt.ybtn.addEventListener(MouseEvent.CLICK, yClick, false, 0, true);
            mc.cnt.ybtn.addEventListener(MouseEvent.MOUSE_OVER, yMouseOver, false, 0, true);
            mc.cnt.ybtn.addEventListener(MouseEvent.MOUSE_OUT, yMouseOut, false, 0, true);
            mc.cnt.nbtn.addEventListener(MouseEvent.CLICK, nClick, false, 0, true);
            mc.cnt.nbtn.addEventListener(MouseEvent.MOUSE_OVER, nMouseOver, false, 0, true);
            mc.cnt.nbtn.addEventListener(MouseEvent.MOUSE_OUT, nMouseOut, false, 0, true);

            if (game.preference.data.bDrops)
            {
                if (game.preference.data.bDropClaimAll)
                {
                    autoClaim();
                }
                else if (!game.preference.data.bDropClaimAll && game.preference.data.bDropClaimExistedItem)
                {
                    autoClaim("existedItem");
                }
                else if (!game.preference.data.bDropClaimAll && game.preference.data.bDropReqQuest)
                {
                    autoClaim("reqQuest");
                }
            }
        }

        private function autoClaim(_type:String = "all") : void
        {
//            for (var i:int = 0; i < game.ui.dropStack.numChildren; i++)
//            {
//                var child:DFrame2MC = DFrame2MC(game.ui.dropStack.getChildAt(i));
//
//                if (!child || child.cnt.strName.text.length < 1 || (_type == "existedItem" && game.world.myAvatar.get)) continue;
//
//                child.cnt.ybtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
//            }

            if (_type == "all"
                    || _type == "existedItem" && game.world.myAvatar.getItemByID(fData.ItemID) != null
                    || _type == "reqQuest" && checkQuestRequirements()
            )
            {
                cnt.ybtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                
//                if (game.ui.dropStack.numChildren > 1)
//                {
//                    for (var i:int = 0; i < game.ui.dropStack.numChildren; i++)
//                    {
//                        var child:DFrame2MC = DFrame2MC(game.ui.dropStack.getChildAt(i));
//
//                        if (!child || child.cnt.strName.text.length < 1 || (_type == "existedItem" && game.world.myAvatar.get)) continue;
//
//                        child.cnt.ybtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
//                    }
//                }
//                else
//                {
//                    cnt.ybtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
//                }
            }
        }

        private function checkQuestRequirements() : Boolean
        {
            var trackerData:Object = QuestController.AcceptData;

            for (var questId:String in trackerData)
            {
                if (trackerData[questId] == null || trackerData[questId].length < 1) continue;

                for each (var key:int in trackerData[questId].Requirements)
                {
                    var rItemId:int = trackerData[questId].Requirements[key].ItemID;

                    if (rItemId == fData.ItemID)
                    {
                        return true;
                    }
                }
            }

            return false;
        }

        private function yClick(event:MouseEvent) : void
        {
            if (!game.world.coolDown("getDrop")) return;

            var _local_3:Object;
            var _local_4:*;
            var _local_5:*;
            var _local_2:Boolean = true;

            for each (_local_3 in game.world.myAvatar.items)
            {
                if (((_local_3.ItemID == fData.ItemID) && (_local_3.iQty < _local_3.iStk)))
                {
                    _local_2 = false;
                }
            }

            if (((_local_2) && (game.world.myAvatar.items.length < game.world.myAvatar.objData.iBagSlots)))
            {
                _local_2 = false;
            }

            var dropItem:Object = game.world.getDropItem(fData.ItemID);

            if (dropItem == null) return;

            if (invItem != null && invItem.iQty + dropItem.iQty >= fData.iStk)
            {
                game.MsgBox.notify("The quantity has reached the maximum limit.")
            }
            else if (((game.isHouseItem(fData)) && (game.world.myAvatar.houseitems.length >= game.world.myAvatar.objData.iHouseSlots)))
            {
                game.MsgBox.notify("House Inventory Full!");
            }
            else if (_local_2)
            {
                game.MsgBox.notify("Item Inventory Full!");
            }
            else
            {
                _local_4 = MovieClip(event.currentTarget);
                _local_5 = MovieClip(_local_4.parent.parent);
                setCT(_local_4.bg, 3385873);
                _local_5.cnt.ybtn.mouseEnabled = false;
                _local_5.cnt.ybtn.mouseChildren = false;
                refreshItemLootDrop();
                game.net.send("getDrop", [fData.ItemID + ":" + dropItem.iQty]);
            }
        }

        private function nClick(_arg_1:MouseEvent):*
        {
            var _local_2:* = MovieClip(_arg_1.currentTarget);
            var _local_3:* = MovieClip(_local_2.parent.parent);
            setCT(_local_2.bg, 0xFF0000);
            _local_3.mouseChildren = false;
            refreshItemLootDrop();
            game.net.send("denyDrop", [fData.ItemID]);
            killButtons();
            _local_3.gotoAndPlay("out");
        }

        private function refreshItemLootDrop() : void
        {
            if (hasRemaining)
            {
                var itemDrop:Object = game.world.getDropItem(fData.ItemID);

                if (itemDrop != null)
                {
                    itemDrop.iQty = Math.abs(fData.iQty - invItem.iQty);
                }
            }
            else
            {
                game.world.removeItemDrop(fData.ItemID);
            }

            if (game.ui.mcPopup.currentLabel == "Loot")
            {
                var lootTemporary:MovieClip = MovieClip(game.ui.mcPopup.getChildByName("mcLoot"));
                lootTemporary.itemsInv = game.world.dropMenu;
                lootTemporary.update({"eventType": "refreshItems"});
            }

            game.cleanDropStack();
            game.RefreshLootCount();
        }

        private function yMouseOver(_arg_1:MouseEvent):*
        {
            var _local_2:* = MovieClip(_arg_1.currentTarget);
            setCT(_local_2.bg, 0x222222);
        }

        private function yMouseOut(_arg_1:MouseEvent):*
        {
            var _local_2:* = MovieClip(_arg_1.currentTarget);
            setCT(_local_2.bg, 0);
        }

        private function nMouseOver(_arg_1:MouseEvent):*
        {
            var _local_2:* = MovieClip(_arg_1.currentTarget);
            setCT(_local_2.bg, 0x222222);
        }

        private function nMouseOut(_arg_1:MouseEvent):*
        {
            var _local_2:* = MovieClip(_arg_1.currentTarget);
            setCT(_local_2.bg, 0);
        }

        private function killButtons():void
        {
            mc.cnt.ybtn.removeEventListener(MouseEvent.CLICK, yClick);
            mc.cnt.ybtn.removeEventListener(MouseEvent.MOUSE_OVER, yMouseOver);
            mc.cnt.ybtn.removeEventListener(MouseEvent.MOUSE_OUT, yMouseOut);
            mc.cnt.nbtn.removeEventListener(MouseEvent.CLICK, nClick);
            mc.cnt.nbtn.removeEventListener(MouseEvent.MOUSE_OVER, nMouseOver);
            mc.cnt.nbtn.removeEventListener(MouseEvent.MOUSE_OUT, nMouseOut);
        }

        public function fClose():void
        {
            killButtons();
            MovieClip(this).parent.removeChild(this);
        }

        private function setCT(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = _arg_1.transform.colorTransform;
            _local_3.color = _arg_2;
            _arg_1.transform.colorTransform = _local_3;
        }

        internal function frame4():*
        {
            stop();
        }

        internal function frame12():*
        {
            fClose();
        }


    }
}//package 

