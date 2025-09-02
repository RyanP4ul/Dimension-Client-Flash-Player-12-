package {

import flash.display.MovieClip;
import flash.display.SimpleButton;

public dynamic class GenderMC extends MovieClip {

    public var btnFemale:SimpleButton;
    public var btnMale:SimpleButton;

    public function GenderMC() {
        addFrameScript(0, this.frame1, 5, this.frame6, 12, this.frame13, 13, this.frame14, 19, this.frame20, 27, this.frame28);
    }

    private function frame1():void {
        this.btnFemale.visible = true;
        this.btnMale.visible = false;
    }

    private function frame6():void {
        this.btnFemale.visible = false;
    }

    private function frame13():void {
        gotoAndStop("Female");
    }

    private function frame14():void {
        this.btnMale.visible = true;
    }

    private function frame20():void {
        this.btnMale.visible = false;
    }

    private function frame28():void {
        gotoAndStop("Male");
    }


}
}//package 

