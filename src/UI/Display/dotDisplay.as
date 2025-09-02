package UI.Display {

import flash.display.MovieClip;

public dynamic class dotDisplay extends MovieClip {

    public var t:MovieClip;
    public var hpDisplay:int;
    public var randNum:Number = -1;
    public var recycler:Function;

    public function dotDisplay() {
        addFrameScript(
                0, frame1,
                2, frame3,
                18, frame19,
                19, frame20,
                41, frame42,
                42, frame43,
                61, frame62,
                62, frame63,
                83, frame84,
                84, frame85,
                110, frame111,
                111, frame112,
                132, frame133,
                133, frame134,
                162, frame163,
                163, frame164,
                184, frame185,
                185, frame186,
                211, frame212,
                212, frame213,
                233, frame234
        );
    }

    public function init():void {
        // Generate or reuse existing random number
        if (this.randNum < 0) {
            this.randNum = Math.random();
        }

        // Calculate which DOT animation to play
        var dotIndex:int = Math.floor(this.randNum * 10) + 1;
        if (dotIndex < 1 || dotIndex > 10) dotIndex = 1;
		
		trace("INIT > HP DISPLAY > " + hpDisplay);

        gotoAndPlay("dot" + dotIndex);
		
		setText();
    }

    public function setText():void {
		trace("setText > " + hpDisplay);
		t.ti.textColor = hpDisplay > 0 ? 0xEE9900 : 0x66FF00;
        t.ti.text = Math.abs(hpDisplay);
		trace("setText abs > " + t.ti.text + " > LABEL > " + currentLabel);
    }

    public function setData(data:*):void {
        t.ti.text = String(data);
    }

    internal function frame1():void {
        this.randNum = -1;
        stop();
    }

    internal function frame3():void {
        this.setText();
    }

    internal function frame19():void {
        if (recycler != null) recycler(this);
        stop();
    }

    internal function frame20():void {
        this.setText();
    }

    internal function frame42():void {
        if (recycler != null) recycler(this);
        stop();
    }

    internal function frame43():void {
        this.setText();
    }

    internal function frame62():void {
        if (recycler != null) recycler(this);
        stop();
    }

    internal function frame63():void {
        this.setText();
    }

    internal function frame84():void {
        if (recycler != null) recycler(this);
        stop();
    }

    internal function frame85():void {
        this.setText();
    }

    internal function frame111():void {
        if (recycler != null) recycler(this);
        stop();
    }

    internal function frame112():void {
        this.setText();
    }

    internal function frame133():void {
        if (recycler != null) recycler(this);
        stop();
    }

    internal function frame134():void {
        this.setText();
    }

    internal function frame163():void {
        if (recycler != null) recycler(this);
        stop();
    }

    internal function frame164():void {
        this.setText();
    }

    internal function frame185():void {
        if (recycler != null) recycler(this);
        stop();
    }

    internal function frame186():void {
        this.setText();
    }

    internal function frame212():void {
        if (recycler != null) recycler(this);
        stop();
    }

    internal function frame213():void {
        this.setText();
    }

    internal function frame234():void {
        if (recycler != null) recycler(this);
        stop();
    }
}
}
