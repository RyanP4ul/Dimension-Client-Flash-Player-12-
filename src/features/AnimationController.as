package features {

import flash.display.MovieClip;
import flash.events.Event;
import flash.display.Stage;
import flash.utils.Dictionary;
import flash.events.EventDispatcher;

public class AnimationController extends EventDispatcher
{
    public static const ANIMATION_END:String = "animationEnd";

    private var animations:Array = [];
    private var speeds:Array = [];
    private var playing:Array = [];
    private var labelData:Array = [];
    private var names:Array = [];
    private var globalSpeed:Number = 1.0;
    private var stage:Stage;
    private var _fps:Number;

    public function AnimationController(stageRef:Stage, fps:Number = 24)
    {
        this.stage = stageRef;
        this._fps = fps;

        addEventListener(Event.ENTER_FRAME, onUpdate);
    }

    /**
     * Adds a MovieClip animation to the controller.
     * @param mc MovieClip instance
     * @param name Unique name for this animation
     * @param speed Animation speed multiplier
     */
    public function addClip(mc:MovieClip, name:String, speed:Number = 1.0):void
    {
        // Prevent duplicate by name
        if (names.indexOf(name) != -1)
            return;

        animations.push(mc);
        speeds.push(speed);
        playing.push(true);
        labelData.push({ currentLabel: null, endFrame: 0, loop: true });
        names.push(name);
    }

    /**
     * Removes a MovieClip animation manually.
     */
    public function removeClipByName(name:String):void
    {
        var index:int = names.indexOf(name);
        if (index != -1)
        {
            animations.splice(index, 1);
            speeds.splice(index, 1);
            playing.splice(index, 1);
            labelData.splice(index, 1);
            names.splice(index, 1);
        }
    }

    public function gotoAndPlay(name:String, frame:Object, loop:Boolean = true):void
    {
        var index:int = names.indexOf(name);
        if (index == -1) return;

        var mc:MovieClip = animations[index];
        mc.gotoAndStop(frame);
        playing[index] = true;
        labelData[index].loop = loop;

        if (frame is String)
        {
            var labelName:String = String(frame);
            labelData[index].currentLabel = labelName;

            var labels:Array = mc.currentLabels;
            for (var i:int = 0; i < labels.length; i++)
            {
                var label:Object = labels[i];
                if (label.name == labelName)
                {
                    var next:Object = (i + 1 < labels.length) ? labels[i + 1] : null;
                    labelData[index].endFrame = next ? next.frame - 1 : mc.totalFrames;
                    break;
                }
            }
        }
        else
        {
            labelData[index].currentLabel = null;
            labelData[index].endFrame = 0;
        }
    }

    public function pause(name:String):void
    {
        var index:int = names.indexOf(name);
        if (index != -1) playing[index] = false;
    }

    public function resume(name:String):void
    {
        var index:int = names.indexOf(name);
        if (index != -1) playing[index] = true;
    }

    public function setSpeed(name:String, speed:Number):void
    {
        var index:int = names.indexOf(name);
        if (index != -1) speeds[index] = speed;
    }

    public function setGlobalSpeed(value:Number):void
    {
        globalSpeed = value;
    }

    public function getGlobalSpeed():Number
    {
        return globalSpeed;
    }

    private function onUpdate(e:Event):void
    {
        var i:int = 0;
        while (i < animations.length)
        {
            var mc:MovieClip = animations[i];
            if (!mc || !playing[i])
            {
                i++;
                continue;
            }

            var speed:Number = speeds[i] * globalSpeed;
            var nextFrame:Number = mc.currentFrame + speed;
            var data:Object = labelData[i];

            // Handle label-based end
            if (data.currentLabel && data.endFrame > 0)
            {
                if (nextFrame >= data.endFrame)
                {
                    if (data.loop)
                    {
                        nextFrame = mc.currentFrameLabel ? mc.currentFrame : 1;
                    }
                    else
                    {
                        nextFrame = data.endFrame;
                        playing[i] = false;

                        dispatchEvent(new AnimationEvent(ANIMATION_END, mc, data.currentLabel));

                        // Auto remove finished animation
                        removeAt(i);
                        continue;
                    }
                }
            }
            else
            {
                // General looping
                if (nextFrame > mc.totalFrames)
                {
                    if (data.loop)
                    {
                        nextFrame = 1;
                    }
                    else
                    {
                        nextFrame = mc.totalFrames;
                        playing[i] = false;
                        dispatchEvent(new AnimationEvent(ANIMATION_END, mc, null));

                        // Auto remove finished animation
                        removeAt(i);
                        continue;
                    }
                }
            }

            mc.gotoAndStop(int(nextFrame));
            i++;
        }
    }

    private function removeAt(index:int):void
    {
        animations.splice(index, 1);
        speeds.splice(index, 1);
        playing.splice(index, 1);
        labelData.splice(index, 1);
        names.splice(index, 1);
    }

    public function dispose():void
    {
//        if (stage)
//            stage.removeEventListener(Event.ENTER_FRAME, onUpdate);

        animations = [];
        speeds = [];
        playing = [];
        labelData = [];
        names = [];
    }
}

}
