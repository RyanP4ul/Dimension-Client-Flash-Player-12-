package test_characters {

import com.greensock.TweenLite;
import com.greensock.easing.Strong;

import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.Shape;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.utils.Timer;

public class Carousel extends MovieClip {

    private var game:Game = Game.root;

    private var slides:Array = [];
    private var dots:Array = [];
    private var currentIndex:int = 0;
    private var slideContainer:MovieClip;

    private var startX:Number;
    private var isDragging:Boolean = false;
    private var autoSlideTimer:Timer;

    private const SLIDE_WIDTH:int = 300;
    private const SLIDE_HEIGHT:int = 130;

    private var announcements:Array = [];
    private var textStatus:TextField;

    public function Carousel() {
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    private function onAddedToStage(e:Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

        textStatus = game.createTextField("Loading Announcements...", 14, 0xFFFFFF, false, TextFieldAutoSize.LEFT);
        textStatus.x = (SLIDE_WIDTH - textStatus.width) / 2;
        textStatus.y = (SLIDE_HEIGHT - textStatus.height) / 2;
        addChild(textStatus);

        game.requestAPI(URLRequestMethod.GET, "web/announcements", {}, onDataReceived, null);
    }

    private function onDataReceived(event:Event) : void
    {
        announcements = JSON.parse(event.target.data) as Array;

        if (announcements.length == 0)
        {
            textStatus.text = "No announcements to display.";
        }
        else
        {
            textStatus.visible = false;
            createSlides();
            createDots();
            addEventListeners();
            startAutoSlide();
        }

    }

    private function createSlides():void {
        slideContainer = new MovieClip();
        addChild(slideContainer);

        for (var i:int = 0; i < announcements.length; i++) {
            var slide:MovieClip = new MovieClip();
            slide.name = announcements[i].title;
            slide.graphics.beginFill(0);
            slide.graphics.drawRect(0, 0, SLIDE_WIDTH, SLIDE_HEIGHT);
            slide.graphics.endFill();
            slide.x = i * SLIDE_WIDTH;
            slide.buttonMode = true;

            var progressLoader:mcLoader = new mcLoader();
            progressLoader.name = "progressLoader";
            progressLoader.x = (SLIDE_WIDTH - progressLoader.width) / 2;
            progressLoader.y = (SLIDE_HEIGHT - progressLoader.height) / 2;
            progressLoader.mcPct.visible = false;
            slide.addChild(progressLoader);

            var loader:CustomLoader = new CustomLoader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
            loader.customParent = slide;
            loader.load(new URLRequest(Game.serverBaseURL + "/api/assets/web/announcements/" + announcements[i].image));

            slides.push(slide);
            slideContainer.addChild(slide);
        }

        var maskShape:Shape = new Shape();
        maskShape.graphics.beginFill(0x000000);
        maskShape.graphics.drawRect(0, 0, SLIDE_WIDTH, SLIDE_HEIGHT);
        maskShape.graphics.endFill();
        addChild(maskShape);
        slideContainer.mask = maskShape;
    }

    private function onImageLoaded(e:Event):void {
        trace("onImageLoaded > 1");
        var loader:CustomLoader = CustomLoader(e.target.loader);

        trace("onImageLoaded > " + (loader != null));
        trace("onImageLoaded > 2");

        if (loader.customParent.progressLoader)
        {
            loader.customParent.progressLoader.visible = false;
        }

        trace("onImageLoaded > 3");

        var image:DisplayObject = loader.content;
        trace("onImageLoaded > 4");
        image.width = loader.customParent.width;
        trace("onImageLoaded > 5");
        image.height = loader.customParent.height;
        trace("onImageLoaded > 6");
        loader.customParent.addChild(image);
        trace("onImageLoaded > 7");
    }

    private function createDots():void {
        var dotContainer:MovieClip = new MovieClip();
        addChild(dotContainer);
        dotContainer.y = SLIDE_HEIGHT + 20;

        for (var i:int = 0; i < slides.length; i++) {
            var dot:Shape = new Shape();
            dot.graphics.beginFill(0x999999);
            dot.graphics.drawCircle(0, 0, 6);
            dot.graphics.endFill();
            dot.x = i * 20;
            dot.name = String(i);
            dots.push(dot);
            dotContainer.addChild(dot);
        }

        updateDots();
        dotContainer.x = (SLIDE_WIDTH - dotContainer.width) / 2;
    }

    private function addEventListeners():void {
        slideContainer.addEventListener(MouseEvent.MOUSE_DOWN, onSlideContainerMouseDown);
        stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
    }

    private function onSlideContainerMouseDown(e:MouseEvent):void {
        startX = mouseX;
        isDragging = true;
        stage.addEventListener(MouseEvent.MOUSE_MOVE, onSlideContainerMouseMove);
        stopAutoSlide();
    }

    private function onSlideContainerMouseMove(e:MouseEvent):void {
        if (isDragging) {
            slideContainer.x += (mouseX - startX);
            startX = mouseX;
        }
    }

    private function onStageMouseUp(e:MouseEvent):void {
        if (isDragging) {
            isDragging = false;
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, onSlideContainerMouseMove);

            var newIndex:int = Math.round(-slideContainer.x / SLIDE_WIDTH);
            goToSlide(newIndex);
            startAutoSlide();
        }
    }

    private function goToSlide(index:int):void {
        if (index < 0) index = slides.length - 1;
        if (index >= slides.length) index = 0;

        currentIndex = index;
        var targetX:Number = -index * SLIDE_WIDTH;
        TweenLite.to(slideContainer, 0.6, {x: targetX, ease: Strong.easeOut});
        updateDots();
    }

    private function updateDots():void {
        for (var i:int = 0; i < dots.length; i++) {
            var dot:Shape = dots[i];
            dot.graphics.clear();
            dot.graphics.beginFill(i == currentIndex ? 0xFFFFFF : 0x999999);
            dot.graphics.drawCircle(0, 0, 6);
            dot.graphics.endFill();
        }
    }

    private function startAutoSlide():void {
        if (announcements.length <= 1) return;

        if (!autoSlideTimer) {
            autoSlideTimer = new Timer(5000); // 5 seconds
            autoSlideTimer.addEventListener(TimerEvent.TIMER, onAutoSlide);
        }
        autoSlideTimer.start();
    }

    private function stopAutoSlide():void {
        if (autoSlideTimer) autoSlideTimer.stop();
    }

    private function restartAutoSlide():void {
        stopAutoSlide();
        startAutoSlide();
    }

    private function onAutoSlide(e:TimerEvent):void {
        goToSlide(currentIndex + 1);
    }

}

}
