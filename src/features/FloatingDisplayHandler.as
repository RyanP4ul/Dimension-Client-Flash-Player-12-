package features {
import com.greensock.TweenLite;
import com.greensock.easing.Back;
import com.greensock.easing.Elastic;
import com.greensock.easing.Power0;
import com.greensock.easing.Power2;
import com.greensock.events.TweenEvent;

import flash.display.MovieClip;
import flash.filters.GlowFilter;
import flash.text.TextField;
import flash.text.TextFormat;

public class FloatingDisplayHandler extends MovieClip
{
    private var pool:Vector.<TextField> = new Vector.<TextField>();
    private var active:Vector.<TextField> = new Vector.<TextField>();

    public function showText(value:String, type:String, xPos:Number, yPos:Number):void
    {
        var tf:TextField = getFromPool();
        var fmt:TextFormat = new TextFormat("Space Mono", 22, 0xFFFFFF, true);
        var color:uint;
        var glow:GlowFilter;
        var prefix:String = "";
        var suffix:String = "";

        switch (type.toUpperCase())
        {
                // --- Combat ---
            case "DODGE":
            case "MISS":
                fmt.color = 0xAAAAAA;
                tf.text = "MISS";
                glow = new GlowFilter(0x000000, 1, 4, 4, 1);
                break;
            case "CRIT":
                fmt.color = 0xFF0000;
                fmt.size = 28;
                tf.text = value + "!";
                glow = new GlowFilter(0xFF6600, 1, 8, 8, 1);
                break;
            case "HIT":
                fmt.color = 0xFFFFFF;
                tf.text = int(value) > 0 ? value : String(Math.abs(Number(value)));
                glow = new GlowFilter(0x000000, 1, 4, 4, 1);
                break;
            case "HEAL":
                fmt.color = 0xFFFFFF;
                tf.text = "+" + value;
                glow = new GlowFilter(0xA6FF4D, 1, 4, 4, 1);
                break;
            case "COPPER":
                fmt.color = 0xCC6600;
                tf.text = "+" + value + " Copper";
                glow = new GlowFilter(0x663300, 1, 5, 5, 1);
                break;
            case "SILVER":
                fmt.color = 0xCCCCCC;
                tf.text = "+" + value + " Silver";
                glow = new GlowFilter(0x999999, 1, 6, 6, 1);
                break;
            case "GOLD":
                fmt.color = 0xFFD700;
                tf.text = "+" + value + " Gold";
                glow = new GlowFilter(0xFFAA00, 1, 8, 8, 1);
                break;
            case "EXP":
                fmt.color = 0x00CCFF;
                tf.text = "+" + value + " EXP";
                glow = new GlowFilter(0x003366, 1, 6, 6, 1);
                break;
            case "BLEED":
                fmt.color = 0xFF4C4C;
                tf.text = value;
                glow = new GlowFilter(0x003366, 1, 6, 6, 1);
                break;
            case "TOXIC":
                fmt.color = 0xFF4C4C;
                tf.text = value;
                glow = new GlowFilter(0x66FF66, 1, 6, 6, 1);
                break;
            case "DOT":
                fmt.color = 0xFF4C4C;
                tf.text = value;
                glow = new GlowFilter(0x003366, 1, 6, 6, 1);
                break;
            default:
                fmt.color = 0xFFFFFF;
                tf.text = value;
                glow = new GlowFilter(0x000000, 1, 4, 4, 1);
                break;
        }

        tf.setTextFormat(fmt);
        tf.filters = [glow];
        tf.alpha = 1;
        tf.scaleX = tf.scaleY = 1;
        tf.x = xPos - tf.textWidth / 2 + (Math.random() * 10 - 5);
        tf.y = yPos - 20;

        addChild(tf);
        active.push(tf);

        var targetY:Number = tf.y - (type == "EXP" ? 30 : 50);
        var duration:Number = (type == "EXP" || type == "CRIT") ? 1.2 : 0.7;

        TweenLite.to(tf, duration, {
            y: targetY,
            alpha: 0,
            ease: Power2.easeOut,
            onComplete: recycleText,
            onCompleteParams: [tf]
        });

        if (type == "CRIT" || type == "GOLD")
        {
            TweenLite.from(tf, 0.4, {
                scaleX: 1.5,
                scaleY: 1.5,
                ease: Back.easeOut
            });
        }
    }

    private function getFromPool():TextField
    {
        if (pool.length > 0)
            return pool.pop();

        var tf:TextField = new TextField();
        tf.mouseEnabled = false;
        tf.selectable = false;
        tf.autoSize = "center";
        return tf;
    }

    private function recycleText(tf:TextField):void
    {
        if (contains(tf)) removeChild(tf);
        var idx:int = active.indexOf(tf);
        if (idx != -1) active.splice(idx, 1);

        tf.filters = [];
        tf.alpha = 1;
        tf.scaleX = tf.scaleY = 1;

        pool.push(tf);
    }
}
}
