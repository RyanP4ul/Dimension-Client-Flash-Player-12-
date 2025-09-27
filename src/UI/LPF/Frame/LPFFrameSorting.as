package UI.LPF.Frame {
import flash.display.MovieClip;

import game.select.Selector;

public class LPFFrameSorting extends LPFFrame {

    public var sorting:Selector;

    override public function fOpen(o:Object):void
    {
        positionBy(o.r);

        if (("fData" in o)) fData = o.fData;
        if (("eventTypes" in o)) eventTypes = o.eventTypes;

        fDraw();
        getLayout().registerForEvents(this, eventTypes);
    }

    override public function fClose():void
    {
        getLayout().unregisterFrame(this);

        if (sorting != null && sorting.isOpen)
        {
            sorting.closeOption();
        }

        if (parent != null)
        {
            parent.removeChild(this);
        }
    }

    protected function fDraw():void
    {
        if (sorting != null && fData != null && fData.items != null)
        {
            sorting.data = fData.items;
            sorting.currentOption = getLayout().game.preference.data.sSortType != null ? getLayout().game.preference.data.sSortType : "Default";
            sorting.init();
            update({ "eventTypes": "refreshInv" });
        }
    }

    override public function notify(o:Object):void
    {
        if (("fData" in o))
        {
            fData = o.fData;
        }
        if (("r" in o))
        {
            positionBy(o.r);
        }
        fDraw();
    }

}
}
