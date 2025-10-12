package features {
import flash.events.Event;
import flash.display.MovieClip;

public class AnimationEvent extends Event
{
    public var clip:MovieClip;
    public var label:String;

    public function AnimationEvent(type:String, clip:MovieClip, label:String)
    {
        super(type);
        this.clip = clip;
        this.label = label;
    }

    override public function clone():Event
    {
        return new AnimationEvent(type, clip, label);
    }
}

}
