// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//Game_fla.game_1_cnt_6

package Game_fla
{
import com.greensock.TweenLite;

import fl.motion.Color;

import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import flash.utils.Dictionary;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.net.*;
    import flash.media.*;
    import flash.geom.*;
    import flash.system.*;
    import flash.utils.*;
    import flash.filters.*;
    import flash.external.*;
    import flash.ui.*;
    import adobe.utils.*;
    import flash.accessibility.*;
    import flash.errors.*;
    import flash.printing.*;
    import flash.profiler.*;
    import flash.sampler.*;
    import flash.xml.*;

import game.builder.MapBuilder;
import game.builder.MapWalkable;
import game.config.ConfigurationData;
import game.handler.DisplayHandler;

import popup.Stats.StatsListItem;
import popup.Stats.StatsSubItem;

import test.Characters;

public dynamic class game_1_cnt_6 extends MovieClip
    {

        public var mcTitle:MovieClip;
        public var chkUserName:chkBox_32;
        public var chkPassword:chkBox_32;
        public var chkAutoLogin:chkBox_32;
        public var ni:TextField;
        public var pi:TextField;
        public var ModalStack:MovieClip;
        public var warning:MovieClip;
        public var mcLogo:MovieClip;
        public var btnLogin:SimpleButton;

        public function game_1_cnt_6()
        {
            addFrameScript(0, Init, 9, Characters, 15, CreateCharacter, 21, Test);
        }

        private function Init(): void
        {
            Game.root.initLogin();
            try
            {
                mcLogo.txtTitle.htmlText = ('<font color="#FFB231">New Release:</font> ' + Game.root.params.sTitle);
            }
            catch(e:Error)
            {
                trace("no sTitle");
            }
            stop();
        }



        private function Characters(): void { stop(); }
        private function CreateCharacter(): void { stop(); }

        public var bg;

        private var padding:int = 8;
        private var gap:int = 4; // space between number and icon
        private var spacing:int = 8; // space between different currencies
        private var maxWidth:int = 300;

        private function Test(): void {
            setCurrency(5, 0, 0);
            stop();
        }

        public function setCurrency(copper:int = 0, silver:int = 0, gold:int = 0):void
        {
            // Remove old children except background
//            while (numChildren > 1) removeChildAt(1);

            var xPos:int = padding;
            if (gold > 0)  xPos = addPart(gold, new CurrencyIconGold(), xPos);
            if (silver > 0) xPos = addPart(silver, new CurrencyIconSilver(), xPos);
            if (copper > 0) xPos = addPart(copper, new CurrencyIconCopper(), xPos);

            // If all are zero, show "0" + copper icon
            if (gold == 0 && silver == 0 && copper == 0)
                xPos = addPart(0, new CurrencyIconCopper(), xPos);

            var totalW:int = xPos + padding;

            if (totalW > maxWidth)
            {
                var scale:Number = maxWidth / totalW;
                this.scaleX = scale;
                this.scaleY = scale;
                totalW = maxWidth;
            }
            else
            {
                this.scaleX = 1;
                this.scaleY = 1;
            }

            bg.width = totalW;
            bg.height = 35;
            bg.x = 0;
            bg.y = 0;
        }

        private function addPart(amount:int, icon:MovieClip, xPos:int):int
        {
            var tf:TextField = new TextField();
            tf.defaultTextFormat = new TextFormat("Calibri", 14, 0xFFFFFF);
            tf.autoSize = "left";
            tf.text = amount.toString();
            tf.selectable = false;
            addChild(tf);

            var expectedW:int = xPos + tf.textWidth + gap + icon.width;
            if (expectedW > maxWidth)
            {
                // Shrink text only (reduce font size until it fits)
                var size:int = 14;
                while (expectedW > maxWidth && size > 8)
                {
                    size--;
                    tf.setTextFormat(new TextFormat("Calibri", size, 0xFFFFFF));
                    expectedW = xPos + tf.textWidth + gap + icon.width;
                }
            }

            tf.x = xPos;
            tf.y = padding;

            icon.x = tf.x + tf.width + gap;
            icon.y = padding + 5;
            addChild(icon);

            return icon.x + icon.width + spacing; // new xPos for next currency
        }

//        private function drawBackground(w:int, h:int):void
//        {
//            bg.graphics.clear();
//            bg.graphics.beginFill(0x333333, 0.8);
//            bg.graphics.drawRoundRect(0, 0, w + padding, h, 8, 8);
//            bg.graphics.endFill();
//        }


    }
}//package Game_fla

