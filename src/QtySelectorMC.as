// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//QtySelectorMC

package 
{
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.display.MovieClip;
    import flash.geom.Point;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;

    public class QtySelectorMC extends Sprite 
    {

        public var t1:TextField;
        public var t2:TextField;
        public var handle:MovieClip;
        public var bar:MovieClip;
        private var _min:int = 1;
        private var _max:int = 1;
        private var _val:int = 1;
        private var isMouseDown:Boolean = false;
        private var p:Point = new Point();
        private var n:Number = 0;
        private var w:int = 0;
        private var dx:int = 0;
        private var game:MovieClip;
        private var _parent:MovieClip;
        private var _obj:Object = null;

        public function QtySelectorMC(_arg_1:*, _arg_2:MovieClip, _arg_3:int, _arg_4:int, o:Object = null):void
        {
            game = _arg_2;
            _parent = _arg_1;
            _obj = o;
            _val = _obj != null && _obj.hasOwnProperty("name") ? o.val : this._min = _arg_3;
            _max = _arg_4;
            w = (bar.width - handle.width);
            t2.htmlText = (("<font color='#FFFFFF'>" + _max) + "</font>");
            addEventListener(Event.ENTER_FRAME, this.onEF, false, 0, true);
            handle.addEventListener(MouseEvent.MOUSE_DOWN, this.onDn, false, 0, true);
            _parent.addEventListener(MouseEvent.MOUSE_UP, this.onUp, false, 0, true);
            t1.addEventListener(KeyboardEvent.KEY_DOWN, this.onKey);
            t1.restrict = "0123456789";
            t1.maxChars = 3;
            handle.buttonMode = true;
            updateHandle();
            update();
        }

        private function update():void
        {
            if (this._val == this._max)
            {
                this.t1.htmlText = (("<font color='#FFFFFF'>" + this._val) + "</font>");
            }
            else
            {
                this.t1.htmlText = (("<font color='#999999'>" + this._val) + "</font>");
            }
        }

        private function updatePref():void
        {
            if (_obj == null) return;
            game.preference.data.cache[_obj.name].val = _val;
            game.preference.flush();
        }

        private function updateHandle():void
        {
            this.handle.x = Math.round((this.bar.x + (this.w * (this._val / this._max))));
        }

        private function onEF(_arg_1:Event):void
        {
            if (this.isMouseDown)
            {
                this.p.x = stage.mouseX;
                this.p.y = stage.mouseY;
                this.p = globalToLocal(this.p);
                this.p.x = (this.p.x - this.dx);
                this.handle.x = (this.n = Math.max(Math.min(this.p.x, (this.bar.x + this.w)), this.bar.x));
                this.n = (this.n - this.bar.x);
                this.n = (this.n / this.w);
                this._val = (Math.round((this.n * (this._max - 1))) + 1);
                this.update();
                updatePref();
            }
        }

        private function onDn(_arg_1:MouseEvent):void
        {
            this.isMouseDown = true;
            this.p.x = stage.mouseX;
            this.p.y = stage.mouseY;
            this.p = globalToLocal(this.p);
            this.dx = (this.p.x - this.handle.x);
        }

        private function onUp(_arg_1:MouseEvent):void
        {
            this.isMouseDown = false;
        }

        private function onKey(_arg_1:KeyboardEvent):void
        {
            if (((_arg_1.charCode == Keyboard.ENTER) || (_arg_1.charCode == Keyboard.ESCAPE)))
            {
                this.val;
                this.update();
                this.updateHandle();
                this.game.stage.focus = null;
                updatePref();
            }
        }

        public function killButtons():void
        {
            removeEventListener(Event.ENTER_FRAME, this.onEF);
            this.handle.removeEventListener(MouseEvent.MOUSE_UP, this.onDn);
            this._parent.removeEventListener(MouseEvent.MOUSE_UP, this.onUp);
        }

        public function fClose():void
        {
            this.killButtons();
            parent.removeChild(this);
        }

        public function get val():int
        {
            if (this._val != int(this.t1.text))
            {
                this._val = int(this.t1.text);
            }
            this._val = Math.max(Math.min(this._val, this._max), this._min);
            return (this._val);
        }

        public function set val(_arg_1:int):void
        {
            this._val = Math.max(Math.min(_arg_1, this._max), this._min);
        }


    }
}//package 

