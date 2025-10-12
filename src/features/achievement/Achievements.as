package features.achievement {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.text.TextField;
import flash.ui.Mouse;
import flash.utils.Dictionary;

import game.quest.TestLoader;

import test_characters.CustomLoader;

public class Achievements extends MovieClip {

    private var game:Game = Game.root;
    private var lists:MovieClip = new MovieClip();
    private var achievements:Array = [];
    private var currentListItem:AchievementListItem;
    private var cache:Dictionary = new Dictionary();

    public var tStatus:TextField;
    public var preview:MovieClip;
    public var listMask:MovieClip;
    public var btnClose:SimpleButton;
    public var listScr:MovieClip;
    public var listScrLoader:TestLoader;

    public function Achievements() {
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    private function onAddedToStage(event:Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

        tStatus.text = "Loading...";

        game.requestAPI(URLRequestMethod.POST, "game/achievements", {
            charId: game.world.myAvatar.objData.CharID
        }, onAchievementComplete, onAchievementError);

        preview.visible = false;
        preview.btnShop.visible = false;
        preview.intShop = -1;

        lists.visible = false;
        lists.mask = listMask;

        btnClose.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
    }

    private function onAchievementComplete(event:Event) : void {
        achievements = JSON.parse(event.target.data) as Array;
        

        if (achievements.length < 1)
        {
            tStatus.text = "No achievements found.";
            return;
        }

        lists.visible = true;
        tStatus.visible = false;

        refreshListsPos();
        initLists();
    }

    private function onAchievementError(event:Event) : void {
        tStatus.text = "Error loading achievements!";
    }

    private function refreshListsPos() : void {
        lists.x = preview.visible ? 330 : 130;
        lists.y = 149.25;
        addChild(lists);
    }

    private function initLists() : void {
        game.onRemoveChildren(lists);

        var perLine:Number = preview.visible ? 4 : 5;

        for each (var achievement:Object in achievements) {
            try {
                var item:AchievementListItem = new AchievementListItem();

                item.name = achievement.title + "-" + lists.numChildren;
                item.tTitle.text = achievement.Name;
                item.tDesc = achievement.Description;
                item.intShop = achievement.hasOwnProperty("ShopID") ? achievement.ShopID: -1;

                if (lists.numChildren % perLine == 0) {
                    item.x = 0;
                    item.y = Math.floor(lists.numChildren / perLine) * (item.height + 5);
                } else {
                    item.x = (lists.numChildren % perLine) * (item.width + 15);
                    item.y = Math.floor(lists.numChildren / perLine) * (item.height + 5);
                }

                item.tTitle.mouseWheelEnabled = false;
                item.tTitle.mouseEnabled = false;
                item.buttonMode = true;

                item.addEventListener(MouseEvent.CLICK, onItemClick, false, 0, true);

                var cloneImage:DisplayObject = cache[item.name];

                if (cloneImage == null)
                {
                    item.tTitle.visible = false;
                    item.progressLoader.visible = true;

                    var loader:CustomLoader = new CustomLoader();
                    loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
                    loader.customParent = item;
                    loader.load(new URLRequest(Game.serverBaseURL + "api/assets/game/achievements/" + achievement.Image));
                }
                else
                {
                    item.progressLoader.visible = false;
                    displayImage(cloneImage, item);
                }

                lists.addChild(item);
            } catch (e:Error) {
                trace(e.message);
                continue;
            }
        }

        if (lists.numChildren > 0)
        {
            listScrLoader = new TestLoader(listMask, lists, listScr);
            listScrLoader.open();
            listScr.visible = true;
        }
        else
        {
            listScrLoader = null;
            listScr.visible = false;
        }
    }

    private function onImageLoaded(e:Event):void {
        var loader:CustomLoader = CustomLoader(e.target.loader);

        var progressLoader:mcLoader = loader.customParent.getChildByName("progressLoader") as mcLoader;
        if (progressLoader) loader.customParent.removeChild(progressLoader);

        loader.customParent.tTitle.visible = true;

        var image:DisplayObject = loader.content;
        cache[loader.customParent.name] = game.cloneAsBitmap(image);
        displayImage(image, loader.customParent);
    }

    private function displayImage(image:DisplayObject, customParent:MovieClip) : void {
        image.x = 36;
        image.y = 6.8;
        image.width = 100;
        image.height = 100;
        customParent.addChild(image);
    }

    private function onItemClick(event:MouseEvent) : void {
        var target:AchievementListItem = AchievementListItem(event.currentTarget);

        target.removeEventListener(MouseEvent.CLICK, onItemClick);

        if (currentListItem && currentListItem.name == target.name)
        {
            preview.visible = !preview.visible;
            currentListItem = null;
        }
        else
        {
            var bm:Bitmap = cache[target.name];
            if (bm) {
                var cloneImage:Bitmap = new Bitmap(bm.bitmapData);
                cloneImage.smoothing = true;
                cloneImage.width = 100;
                cloneImage.height = 100;
                cloneImage.x = 65;
                cloneImage.y = 12;
                cloneImage.name = target.name;
                preview.addChild(cloneImage);
            }

            currentListItem = target;

            if (target.intShop > 0) {
                preview.intShop = target.intShop;
                preview.btnShop.visible = true;
                preview.removeEventListener(MouseEvent.CLICK, onClick);
                preview.btnShop.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
            } else {
                preview.btnShop.visible = false;
            }

            preview.tTitle.text = target.tTitle.text;
            preview.tDesc.text = target.tDesc;
            preview.visible = true;
        }

        refreshListsPos();
        initLists();
    }

    private function onClick(event:MouseEvent) : void {
        btnClose.removeEventListener(MouseEvent.CLICK, onClick);

        switch (event.currentTarget.name)
        {
            case "btnShop":
                game.world.sendLoadShopRequest(event.currentTarget.intShop);
                break;
            case "btnClose":
                var m:MovieClip = MovieClip(parent);
                m.removeChild(this);
                m.onClose();
                break;
        }
    }

}

}
