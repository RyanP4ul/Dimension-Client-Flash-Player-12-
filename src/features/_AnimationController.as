package features {
import flash.display.MovieClip;
import flash.events.Event;
import flash.display.Sprite;

/**
 * AnimationController
 * --------------------
 * Handles multiple MovieClip animations and allows global or per-animation speed control.
 * Example:
 *  controller.add(myAnim, 2.0);  // play 2x faster
 *  controller.add(monsterAnim, 0.5); // play 50% slower
 *  controller.globalSpeed = 1.5; // make ALL animations 1.5x faster
 */
public class _AnimationController extends Sprite
{
    private var animations:Vector.<MovieClip> = new Vector.<MovieClip>();
    private var speeds:Vector.<Number> = new Vector.<Number>();
    private var playing:Vector.<Boolean> = new Vector.<Boolean>();

    public var globalSpeed:Number = 1.0; // affects all animations

    public function _AnimationController()
    {
        addEventListener(Event.ENTER_FRAME, onUpdate);
    }

    /** Adds an animation to the controller. */
    public function add(clip:MovieClip, speedMultiplier:Number = 1.0, autoPlay:Boolean = true):void
    {
        if (!clip) return;
        if (animations.indexOf(clip) == -1)
        {
            animations.push(clip);
            speeds.push(speedMultiplier);
            playing.push(autoPlay);
        }
    }

    /** Removes a controlled animation. */
    public function remove(clip:MovieClip):void
    {
        var index:int = animations.indexOf(clip);
        if (index != -1)
        {
            animations.splice(index, 1);
            speeds.splice(index, 1);
            playing.splice(index, 1);
        }
    }

    /** Main update loop. */
    private function onUpdate(e:Event):void
    {
        for (var i:int = 0; i < animations.length; i++)
        {
            var clip:MovieClip = animations[i];
            if (!clip || !playing[i]) continue;

            var speed:Number = speeds[i] * globalSpeed;
            var nextFrame:Number = clip.currentFrame + speed;

            // Wrap around if looping, or clamp if reaching end
            if (nextFrame >= clip.totalFrames)
            {
                nextFrame = 1; // loop to start
            }

            clip.gotoAndStop(int(nextFrame));
        }
    }

    /** Plays a clip from its current frame. */
    public function play(clip:MovieClip):void
    {
        var index:int = animations.indexOf(clip);
        if (index != -1)
            playing[index] = true;
    }

    /** Stops a clip at its current frame. */
    public function stop(clip:MovieClip):void
    {
        var index:int = animations.indexOf(clip);
        if (index != -1)
            playing[index] = false;
    }

    /** Acts like gotoAndPlay() */
    public function gotoAndPlay(clip:MovieClip, frame:String):void
    {
        clip.gotoAndStop(frame); // jump first
        var index:int = animations.indexOf(clip);
        if (index != -1)
            playing[index] = true;
    }

    /** Acts like gotoAndStop() */
    public function gotoAndStop(clip:MovieClip, frame:int):void
    {
        clip.gotoAndStop(frame);
        var index:int = animations.indexOf(clip);
        if (index != -1)
            playing[index] = false;
    }

    /** Change playback speed for one animation. */
    public function setSpeed(clip:MovieClip, speedMultiplier:Number):void
    {
        var index:int = animations.indexOf(clip);
        if (index != -1)
            speeds[index] = speedMultiplier;
    }

    /** Clears all animations. */
    public function clear():void
    {
        animations.length = 0;
        speeds.length = 0;
        playing.length = 0;
    }
}

}
