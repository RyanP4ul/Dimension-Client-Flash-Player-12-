// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//outfitbutton

package test
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.text.TextField;

    public dynamic class outfitbutton extends MovieClip 
    {

        public var btnMain:SimpleButton;
        public var txtName:TextField;
        public var btnEdit:SimpleButton;
        public var btnDelete:SimpleButton;

        public function outfitbutton()
        {
            this.__setTab_btnMain_OutfitButton_Layer1_0();
            this.__setTab_btnDelete_OutfitButton_Layer1_0();
            this.__setTab_btnEdit_OutfitButton_Layer1_0();
        }

        internal function __setTab_btnMain_OutfitButton_Layer1_0():*
        {
            this.btnMain.tabIndex = 3;
        }

        internal function __setTab_btnDelete_OutfitButton_Layer1_0():*
        {
            this.btnDelete.tabIndex = 3;
        }

        internal function __setTab_btnEdit_OutfitButton_Layer1_0():*
        {
            this.btnEdit.tabIndex = 3;
        }


    }
}//package 

