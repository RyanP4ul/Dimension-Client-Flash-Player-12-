// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//Game_fla.mcPopup_328

package Game_fla {
import UI.LPF.Layout.LPFLayout;
import UI.LPF.Layout.LPFLayoutBank;
import UI.LPF.Layout.LPFLayoutChatItemPreview;
import UI.LPF.Layout.LPFLayoutHouseInvShop;
import UI.LPF.Layout.LPFLayoutInvShopEnh;
import UI.LPF.Layout.LPFLayoutLootTemporary;
import UI.LPF.Layout.LPFLayoutMergeShop;
import UI.LPF.Layout.LPFLayoutOutfit;
import UI.LPF.Layout.LPFLayoutPetPanel;
import UI.LPF.Layout.LPFLayoutTrade;
import UI.ToolTipMC;

import flash.display.*;
import flash.events.Event;

import game.controller.OutfitController;

import test.Outfit;

dynamic public class mcPopup_328 extends MovieClip {

    public var mcOutfit:Outfit;
    public var mcOpt:mcOption;
    public var mcBag:SimpleButton;
    public var mcCustomize:MovieClip;
    public var mcMap:MovieClip;
    public var mcPVPPanel:PVPPanelMC;
    public var mcHouseItemHandle:HouseItemHandleMC;
    public var reportMC:MovieClip;
    public var mcHouseOptions:MovieClip;
    public var mcBook:MovieClip;
    public var mcHouseMenu:HouseMenu;
    public var mcCustomizeArmor:MovieClip;
    public var mcGuild:MovieClip;
    public var mcBuySlots:MovieClip;
    public var mcNews:MovieClip;
    public var mcWheel:MovieClip;
    public var game:Game = Game.root;
    public var fData:Object;
    public var layout:LPFLayout;

    public function mcPopup_328() {
        addFrameScript(0, frame1, 1, frame2, 6, frame7, 14, frame15, 23, frame24, 29, frame30, 39, frame40, 48, frame49, 57, frame58, 64, frame65, 71, frame72, 78, frame79, 86, frame87, 94, frame95, 102, frame103, 111, frame112, 120, frame122, 128, frame129, 138, frame139, 148, frame149, 159, frame160, 168, frame169, 175, frame176, 180, frame181, 185, frame186, 190, frame191, 195, frame196, 200, InventoryOutfit, 205, TestOutfit, 210, Trade, 215, Panel, 220, Vendor, 225, Achievements);
    }

    override public function gotoAndStop(frame:Object, scene:String = null):void {
        ToolTipMC(game.ui.ToolTip).close();
        super.gotoAndStop(frame, scene);
    }

    public function fOpen(_arg_1:String, _arg_2:Object=null):void
    {
        if (currentLabel != _arg_1)
        {
            fClose();
            if (_arg_2 != null)
            {
                fData = _arg_2;
            }
            gotoAndStop(_arg_1);
            visible = true;
        }
    }

    public function fClose():*
    {
        var _local_1:MovieClip = MovieClip(this);
        if (_local_1.mcHouseMenu != null)
        {
            _local_1.mcHouseMenu.fClose();
        }

        for (var i:int = 0; i < numChildren; i++)
        {
            var child:DisplayObject = getChildAt(i);

            if (child is LPFLayout) LPFLayout(child).fClose();
        }

        if (getChildByName("mcRedeem") != null){
            MovieClip(getChildByName("mcRedeem")).fClose();
        }
    }

    public function onClose(_arg_1:Event=null):void
    {
        if (((!(currentLabel == "Init")) && (!(currentFrame == 1))))
        {
            fClose();
            MovieClip(Game.root).mixer.playSound("Click");
            if ((((game.world.isMyHouse()) && (!(game.world.mapLoadInProgress))) && (!(currentLabel == "House"))))
            {
                gotoAndPlay("House");
            }
            else
            {
                gotoAndPlay("Init");
            }
        }
    }

//    public function fOpen(_arg_1:String, fData:Object = null):void {
//        if (currentLabel != _arg_1) {
//            fClose();
//            if (fData != null) {
//                this.fData = fData;
//            }
//            this.gotoAndStop(_arg_1);
//            visible = true;
//        }
//    }
//
//    public function fClose():* {
//        if (mcHouseMenu != null) {
//            mcHouseMenu.fClose();
//        }
//
//        for (var i:int = 0; i < numChildren; i++)
//        {
//            var child:DisplayObject = getChildAt(i);
//
//            if (child is LPFLayout) LPFLayout(child).fClose();
//        }
//    }
//
//    public function onClose(_arg_1:Event = null):void {
//        if (((!(currentLabel == "Init")) && (!(currentFrame == 1)))) {
//            fClose();
//            game.mixer.playSound("Click");
//            if ((((game.world.isMyHouse()) && (!(game.world.mapLoadInProgress))) && (!(currentLabel == "House")))) {
//                gotoAndPlay("House");
//            } else {
//                gotoAndPlay("Init");
//            }
//        }
//    }

    public function loadMap(_arg_1:String):* {
        mcMap.removeChildAt(0);
        var assetClass:Class = game.params.domain.worldMapDomain.getDefinition("WorldMap") as Class;
        mcMap.addChildAt(new (assetClass), 0);
    }

    public function loadNews(_arg_1:String):* {
        mcNews.removeChildAt(0);
//        var _local_2:Loader = new Loader();
//        _local_2.load(new URLRequest((Game.serverFilePath + _arg_1)), new LoaderContext(false, ApplicationDomain.currentDomain));
//        mcNews.addChild(_local_2);
    }

    public function loadBook(_arg_1:String):* {
//        trace((Game.serverFilePath + _arg_1));
//        game.net.send("book", []);
//        mcBook.removeChildAt(0);
//        var _local_2:Loader = new Loader();
//        _local_2.load(new URLRequest((Game.serverFilePath + _arg_1)), new LoaderContext(false, ApplicationDomain.currentDomain));
//        mcBook.addChild(_local_2);
    }

    internal function frame1():void {
        game = Game.root;
        fData = {};
        visible = false;
        stop();
    }

    internal function frame2():void {
        fData = {};
        visible = false;
        if (game.mcO != null && game.contains(game.mcO)) {
            this.removeChild(game.mcO);
        }
        stop();
    }

    internal function frame7():void {
        layout = (addChild(new LPFLayoutInvShopEnh()) as LPFLayoutInvShopEnh);
        layout.name = "mcInventory";
        layout.fOpen({
            "fData": {
                "itemsInv": game.world.myAvatar.items,
                "objData": game.world.myAvatar.objData
            },
            "r": {
                "x": 325,
                "y": 0,
                "w": stage.stageWidth,
                "h": 600
            },
            "sMode": "inventory"
        });
        layout = null;
        stop();
    }

    internal function frame15():* {
        stop();
    }

    internal function frame24():* {
        layout = (addChild(new LPFLayoutInvShopEnh()) as LPFLayoutInvShopEnh);
        layout.name = "mcShop";
        layout.fOpen({
            "fData": {
                "itemsShop": game.world.shopinfo.items,
                "itemsInv": game.world.myAvatar.items,
                "objData": game.world.myAvatar.objData,
                "shopinfo": game.world.shopinfo
            },
            "r": {
                "x": 325,
                "y": 0,
                "w": stage.stageWidth,
                "h": stage.stageHeight
            },
            "sMode": "shopBuy"
        });
        layout = null;
        stop();
    }

    internal function frame30():* {
        layout = (addChild(new LPFLayoutMergeShop()) as LPFLayoutMergeShop);
        layout.name = "mcShop";
        layout.fOpen({
            "fData": {
                "itemsShop": game.world.shopinfo.items,
                "itemsInv": game.world.myAvatar.items,
                "objData": game.world.myAvatar.objData
            },
            "r": {
                "x": 175,
                "y": 0,
                "w": stage.stageWidth,
                "h": 750
            },
            "sMode": "shopBuy"
        });
        layout = null;
        stop();
    }

    internal function frame40():* {
        stop();
    }

    internal function frame49():* {
        layout = (addChild(new LPFLayoutBank()) as LPFLayoutBank);
        layout.name = "mcBank";
        layout.fOpen({
            "fData": {
                "itemsB": game.world.bankinfo.items,
                "itemsI": game.world.myAvatar.items,
                "objData": game.world.myAvatar.objData
            },
            "r": {
                "x": 175,
                "y": 0,
                "w": stage.stageWidth,
                "h": stage.stageHeight
            },
            "sMode": "bank"
        });
        layout = null;
        stop();
    }

    internal function frame58():* {
        loadMap(game.world.objInfo.sMap);
        stop();
    }

    internal function frame65():* {
        loadNews(game.world.objInfo.sNews);
        stop();
    }

    internal function frame72():* {
        loadBook(game.world.objInfo.sBook);
        stop();
    }

    internal function frame79():* {
//        game.mcO = ((game.mcO == null) ? (new mcOption() as MovieClip) : game.mcO);
//        this.addChild(game.mcO);
//        game.mcO.x = 585;
//        game.mcO.y = 90;
        stop();
    }

    internal function frame87():* {
        stop();
    }

    internal function frame95():* {
        stop();
    }

    internal function frame103():* {
        stop();
    }

    internal function frame112():* {
        stop();
    }

    internal function frame122():* {
        mcHouseItemHandle.visible = false;
        stop();
    }

    internal function frame129():* {
        stop();
    }

    internal function frame139():* {
        stop();
    }

    internal function frame149():* {
        stop();
    }

    internal function frame160():* {
        stop();
    }

    private function frame169():void {
        layout = (addChild(new LPFLayoutPetPanel()) as LPFLayoutPetPanel);
        layout.name = "mcPetPanel";
        layout.fOpen({
            "fData": {
                "itemsB": game.world.bankinfo.items,
                "itemsI": game.world.myAvatar.items,
                "objData": game.world.myAvatar.objData
            },
            "r": {
                "x": 185,
                "y": 133,
                "w": stage.stageWidth,
                "h": stage.stageHeight
            },
            "sMode": "pet"
        });
        layout = null;
        stop();
    }

    private function frame176():void {
        layout = (addChild(new LPFLayoutLootTemporary()) as LPFLayoutLootTemporary);
        layout.name = "mcLoot";
        layout.fOpen({
            "fData": {
                "itemsInv": game.world.dropMenu,
                "objData": game.world.myAvatar.objData,
                "sName": "Loot"
            },
            "r": {
                "x": 325,
                "y": 0,
                "w": stage.stageWidth,
                "h": stage.stageHeight
            },
            "sMode": "loot"
        });
        layout = null;
        stop();
    }

    private function frame181():void {
        layout = (addChild(new LPFLayoutHouseInvShop()) as LPFLayoutHouseInvShop);
        layout.name = "mcInventory";
        layout.fOpen({
            "fData": {
                "itemsInv": game.world.myAvatar.houseitems,
                "objData": game.world.myAvatar.objData
            },
            "r": {
                "x": 325,
                "y": 0,
                "w": stage.stageWidth,
                "h": stage.stageHeight
            },
            "sMode": "inventory"
        });
        layout = null;
        stop();
    }

    private function frame186():void {
        layout = (addChild(new LPFLayoutLootTemporary()) as LPFLayoutLootTemporary);
        layout.name = "mcTemporary";
        layout.fOpen({
            "fData": {
                "itemsInv": game.world.myAvatar.tempitems,
                "objData": game.world.myAvatar.objData,
                "sName": "Temporary"
            },
            "r": {
                "x": 325,
                "y": 0,
                "w": stage.stageWidth,
                "h": stage.stageHeight
            },
            "sMode": "temporary"
        });
        layout = null;
        stop();
    }

    private function frame191(): void {
        stop();
    }

    private function frame196(): void {
        layout = (addChild(new LPFLayoutChatItemPreview()) as LPFLayoutChatItemPreview);
        layout.name = "mcChatPreview";
        layout.fOpen({
            "fData": {
                "itemsInv": game.world.myAvatar.items,
                "objData": game.world.myAvatar.objData
            },
            "r": {
                "x": 0,
                "y": 0,
                "w": stage.stageWidth,
                "h": stage.stageHeight
            },
            "sMode": "preview"
        });
        layout = null;
        stop();
    }

    private function InventoryOutfit(): void {
        layout = (addChild(new LPFLayoutOutfit()) as LPFLayoutOutfit);
        layout.name = "mcOutfitInventory";
        layout.fOpen({
            "fData": {
                "itemsInv": OutfitController.Data,
                "objData": game.world.myAvatar.objData,
                "sName": String(game.world.myAvatar.objData.outfits[OutfitController.id].Name)
            },
            "r": {
                "x": 0,
                "y": 0,
                "w": stage.stageWidth,
                "h": stage.stageHeight
            },
            "sMode": "outfit"
        });
        layout = null;
        stop();
    }

    private function TestOutfit() : void {
        stop();
    }

    private function Trade() : void {
        layout = (addChild(new LPFLayoutTrade()) as LPFLayoutTrade);
        layout.name = "mcTrade";
        layout.fOpen({
            "fData": {
                "itemsInv": game.world.myAvatar.items,
                "itemsB": game.world.tradeController.tradeinfo.itemsA,
                "itemsC": game.world.tradeController.tradeinfo.itemsB,
                "objData": game.world.myAvatar.objData,
                "tradeId": game.world.tradeController.tradeId
            },
            "r": {
                "x": 0,
                "y": 0,
                "w": stage.stageWidth,
                "h": stage.stageHeight
            },
            "sMode": "trade"
        });
        layout = null;
        stop();
    }

    private function Panel() : void {
        stop();
    }

    private function Vendor() : void {
        layout = (addChild(new LPFLayoutInvShopEnh()) as LPFLayoutInvShopEnh);
        layout.name = "mcShop";
        layout.fOpen({
            "fData": {
                "itemsShop": game.world.shopinfo.items,
//                "itemsInv": game.world.myAvatar.items,
                "objData": game.world.myAvatar.objData,
                "shopinfo": game.world.shopinfo
            },
            "r": {
                "x": 325,
                "y": 0,
                "w": stage.stageWidth,
                "h": stage.stageHeight
            },
            "sMode": "vendor"
        });
        layout = null;
        stop();
    }

    private function Achievements() : void {
        stop();
    }

//    internal function frame7():void {
//        layout = (addChild(new LPFLayoutInvShopEnh()) as LPFLayoutInvShopEnh);
//        layout.name = "mcInventory";
//        layout.fOpen({
//            "fData": {
//                "itemsInv": game.world.myAvatar.items,
//                "objData": game.world.myAvatar.objData
//            },
//            "r": {
//                "x": 0,
//                "y": 0,
//                "w": stage.stageWidth,
//                "h": stage.stageHeight
//            },
//            "sMode": "inventory"
//        });
//        layout = null;
//        stop();
//    }

}
}//package Game_fla

