// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//fl.controls.ColorPicker

package fl.controls
{
    import fl.core.UIComponent;
    import fl.managers.IFocusManagerComponent;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.geom.ColorTransform;
    import fl.managers.IFocusManager;
    import fl.core.InvalidationType;
    import flash.text.TextFieldType;
    import flash.display.Graphics;
    import flash.events.MouseEvent;
    import fl.events.ColorPickerEvent;
    import flash.ui.Keyboard;
    import flash.events.KeyboardEvent;
    import flash.events.FocusEvent;
    import flash.events.Event;
    import flash.text.TextFormat;
    import flash.geom.Point;

    public class ColorPicker extends UIComponent implements IFocusManagerComponent 
    {

        public static var defaultColors:Array;
        private static var defaultStyles:Object = {
            "upSkin":"ColorPicker.ColorPicker_upSkin",
            "disabledSkin":"ColorPicker.ColorPicker_disabledSkin",
            "overSkin":"ColorPicker.ColorPicker_overSkin",
            "downSkin":"ColorPicker.ColorPicker_downSkin",
            "colorWell":"ColorPicker.ColorPicker_colorWell",
            "swatchSkin":"ColorPicker.ColorPicker_swatchSkin",
            "swatchSelectedSkin":"ColorPicker.ColorPicker_swatchSelectedSkin",
            "swatchWidth":10,
            "swatchHeight":10,
            "columnCount":18,
            "swatchPadding":1,
            "textFieldSkin":"ColorPicker.ColorPicker_textFieldSkin",
            "textFieldWidth":null,
            "textFieldHeight":null,
            "textPadding":3,
            "background":"ColorPicker.ColorPicker_backgroundSkin",
            "backgroundPadding":5,
            "textFormat":null,
            "focusRectSkin":null,
            "focusRectPadding":null,
            "embedFonts":false
        };
        protected static const POPUP_BUTTON_STYLES:Object = {
            "disabledSkin":"disabledSkin",
            "downSkin":"downSkin",
            "overSkin":"overSkin",
            "upSkin":"upSkin"
        };
        protected static const SWATCH_STYLES:Object = {
            "disabledSkin":"swatchSkin",
            "downSkin":"swatchSkin",
            "overSkin":"swatchSkin",
            "upSkin":"swatchSkin"
        };

        protected var paletteBG:DisplayObject;
        protected var customColors:Array;
        protected var palette:Sprite;
        protected var swatchButton:BaseButton;
        protected var selectedSwatch:Sprite;
        protected var textFieldBG:DisplayObject;
        protected var colorWell:DisplayObject;
        protected var colorHash:Object;
        protected var swatchSelectedSkin:DisplayObject;
        protected var currRowIndex:int;
        protected var currColIndex:int;
        protected var swatchMap:Array;
        protected var _selectedColor:uint;
        public var textField:TextField;
        protected var swatches:Sprite;

        protected var rollOverColor:int = -1;
        protected var _editable:Boolean = true;
        protected var _showTextField:Boolean = true;
        protected var isOpen:Boolean = false;
        protected var doOpen:Boolean = false;


        public static function getStyleDefinition():Object
        {
            return (defaultStyles);
        }


        public function set imeMode(_arg_1:String):void
        {
            _imeMode = _arg_1;
        }

        protected function drawSwatchHighlight():void
        {
            var _local_1:Object;
            var _local_2:Number;
            cleanUpSelected();
            _local_1 = getStyleValue("swatchSelectedSkin");
            _local_2 = (getStyleValue("swatchPadding") as Number);
            if (_local_1 != null)
            {
                swatchSelectedSkin = getDisplayObjectInstance(_local_1);
                swatchSelectedSkin.x = 0;
                swatchSelectedSkin.y = 0;
                swatchSelectedSkin.width = ((getStyleValue("swatchWidth") as Number) + 2);
                swatchSelectedSkin.height = ((getStyleValue("swatchHeight") as Number) + 2);
            };
        }

        protected function setColorWellColor(_arg_1:ColorTransform):void
        {
            if (!colorWell)
            {
                return;
            };
            colorWell.transform.colorTransform = _arg_1;
        }

        override protected function isOurFocus(_arg_1:DisplayObject):Boolean
        {
            return ((_arg_1 == textField) || (super.isOurFocus(_arg_1)));
        }

        public function open():void
        {
            var _local_1:IFocusManager;
            if (!_enabled)
            {
                return;
            };
            doOpen = true;
            _local_1 = focusManager;
            if (_local_1)
            {
                _local_1.defaultButtonEnabled = false;
            };
            invalidate(InvalidationType.STATE);
        }

        protected function setTextEditable():void
        {
            if (!showTextField)
            {
                return;
            };
            textField.type = ((editable) ? TextFieldType.INPUT : TextFieldType.DYNAMIC);
            textField.selectable = editable;
        }

        protected function createSwatch(_arg_1:uint):Sprite
        {
            var _local_2:Sprite;
            var _local_3:BaseButton;
            var _local_4:Number;
            var _local_5:Number;
            var _local_6:Number;
            var _local_7:Graphics;
            _local_2 = new Sprite();
            _local_3 = new BaseButton();
            _local_3.focusEnabled = false;
            _local_4 = (getStyleValue("swatchWidth") as Number);
            _local_5 = (getStyleValue("swatchHeight") as Number);
            _local_3.setSize(_local_4, _local_5);
            _local_3.transform.colorTransform = new ColorTransform(0, 0, 0, 1, (_arg_1 >> 16), ((_arg_1 >> 8) & 0xFF), (_arg_1 & 0xFF), 0);
            copyStylesToChild(_local_3, SWATCH_STYLES);
            _local_3.mouseEnabled = false;
            _local_3.drawNow();
            _local_3.name = "color";
            _local_2.addChild(_local_3);
            _local_6 = (getStyleValue("swatchPadding") as Number);
            _local_7 = _local_2.graphics;
            _local_7.beginFill(0);
            _local_7.drawRect(-(_local_6), -(_local_6), (_local_4 + (_local_6 * 2)), (_local_5 + (_local_6 * 2)));
            _local_7.endFill();
            _local_2.addEventListener(MouseEvent.CLICK, onSwatchClick, false, 0, true);
            _local_2.addEventListener(MouseEvent.MOUSE_OVER, onSwatchOver, false, 0, true);
            _local_2.addEventListener(MouseEvent.MOUSE_OUT, onSwatchOut, false, 0, true);
            return (_local_2);
        }

        protected function onSwatchOut(_arg_1:MouseEvent):void
        {
            var _local_2:ColorTransform;
            _local_2 = _arg_1.target.transform.colorTransform;
            dispatchEvent(new ColorPickerEvent(ColorPickerEvent.ITEM_ROLL_OUT, _local_2.color));
        }

        override protected function keyDownHandler(_arg_1:KeyboardEvent):void
        {
            var _local_2:ColorTransform;
            var _local_3:Sprite;
            switch (_arg_1.keyCode)
            {
                case Keyboard.SHIFT:
                case Keyboard.CONTROL:
                    return;
            };
            if (_arg_1.ctrlKey)
            {
                switch (_arg_1.keyCode)
                {
                    case Keyboard.DOWN:
                        open();
                        return;
                    case Keyboard.UP:
                        close();
                        return;
                };
                return;
            };
            if (!isOpen)
            {
                switch (_arg_1.keyCode)
                {
                    case Keyboard.UP:
                    case Keyboard.DOWN:
                    case Keyboard.LEFT:
                    case Keyboard.RIGHT:
                    case Keyboard.SPACE:
                        open();
                        return;
                };
            };
            textField.maxChars = (((_arg_1.keyCode == "#".charCodeAt(0)) || (textField.text.indexOf("#") > -1)) ? 7 : 6);
            switch (_arg_1.keyCode)
            {
                case Keyboard.TAB:
                    _local_3 = findSwatch(_selectedColor);
                    setSwatchHighlight(_local_3);
                    return;
                case Keyboard.HOME:
                    currColIndex = (currRowIndex = 0);
                    break;
                case Keyboard.END:
                    currColIndex = (swatchMap[(swatchMap.length - 1)].length - 1);
                    currRowIndex = (swatchMap.length - 1);
                    break;
                case Keyboard.PAGE_DOWN:
                    currRowIndex = (swatchMap.length - 1);
                    break;
                case Keyboard.PAGE_UP:
                    currRowIndex = 0;
                    break;
                case Keyboard.ESCAPE:
                    if (isOpen)
                    {
                        selectedColor = _selectedColor;
                    };
                    close();
                    return;
                case Keyboard.ENTER:
                    return;
                case Keyboard.UP:
                    currRowIndex = Math.max(-1, (currRowIndex - 1));
                    if (currRowIndex == -1)
                    {
                        currRowIndex = (swatchMap.length - 1);
                    };
                    break;
                case Keyboard.DOWN:
                    currRowIndex = Math.min(swatchMap.length, (currRowIndex + 1));
                    if (currRowIndex == swatchMap.length)
                    {
                        currRowIndex = 0;
                    };
                    break;
                case Keyboard.RIGHT:
                    currColIndex = Math.min(swatchMap[currRowIndex].length, (currColIndex + 1));
                    if (currColIndex == swatchMap[currRowIndex].length)
                    {
                        currColIndex = 0;
                        currRowIndex = Math.min(swatchMap.length, (currRowIndex + 1));
                        if (currRowIndex == swatchMap.length)
                        {
                            currRowIndex = 0;
                        };
                    };
                    break;
                case Keyboard.LEFT:
                    currColIndex = Math.max(-1, (currColIndex - 1));
                    if (currColIndex == -1)
                    {
                        currColIndex = (swatchMap[currRowIndex].length - 1);
                        currRowIndex = Math.max(-1, (currRowIndex - 1));
                        if (currRowIndex == -1)
                        {
                            currRowIndex = (swatchMap.length - 1);
                        };
                    };
                    break;
                default:
                    return;
            };
            _local_2 = swatchMap[currRowIndex][currColIndex].getChildByName("color").transform.colorTransform;
            rollOverColor = _local_2.color;
            setColorWellColor(_local_2);
            setSwatchHighlight(swatchMap[currRowIndex][currColIndex]);
            setColorText(_local_2.color);
        }

        public function get editable():Boolean
        {
            return (_editable);
        }

        override protected function focusInHandler(_arg_1:FocusEvent):void
        {
            super.focusInHandler(_arg_1);
            setIMEMode(true);
        }

        protected function onStageClick(_arg_1:MouseEvent):void
        {
            if (((!(contains((_arg_1.target as DisplayObject)))) && (!(palette.contains((_arg_1.target as DisplayObject))))))
            {
                selectedColor = _selectedColor;
                close();
            };
        }

        protected function onSwatchOver(_arg_1:MouseEvent):void
        {
            var _local_2:BaseButton;
            var _local_3:ColorTransform;
            _local_2 = (_arg_1.target.getChildByName("color") as BaseButton);
            _local_3 = _local_2.transform.colorTransform;
            setColorWellColor(_local_3);
            setSwatchHighlight((_arg_1.target as Sprite));
            setColorText(_local_3.color);
            dispatchEvent(new ColorPickerEvent(ColorPickerEvent.ITEM_ROLL_OVER, _local_3.color));
        }

        override public function set enabled(_arg_1:Boolean):void
        {
            super.enabled = _arg_1;
            if (!_arg_1)
            {
                close();
            };
            swatchButton.enabled = _arg_1;
        }

        override protected function keyUpHandler(_arg_1:KeyboardEvent):void
        {
            var _local_2:uint;
            var _local_3:ColorTransform;
            var _local_4:String;
            var _local_5:Sprite;
            if (!isOpen)
            {
                return;
            };
            _local_3 = new ColorTransform();
            if (((editable) && (showTextField)))
            {
                _local_4 = textField.text;
                if (_local_4.indexOf("#") > -1)
                {
                    _local_4 = _local_4.replace(/^\s+|\s+$/g, "");
                    _local_4 = _local_4.replace(/#/g, "");
                };
                _local_2 = parseInt(_local_4, 16);
                _local_5 = findSwatch(_local_2);
                setSwatchHighlight(_local_5);
                _local_3.color = _local_2;
                setColorWellColor(_local_3);
            }
            else
            {
                _local_2 = rollOverColor;
                _local_3.color = _local_2;
            };
            if (_arg_1.keyCode != Keyboard.ENTER)
            {
                return;
            };
            dispatchEvent(new ColorPickerEvent(ColorPickerEvent.ENTER, _local_2));
            _selectedColor = rollOverColor;
            setColorText(_local_3.color);
            rollOverColor = _local_3.color;
            dispatchEvent(new ColorPickerEvent(ColorPickerEvent.CHANGE, selectedColor));
            close();
        }

        protected function drawBG():void
        {
            var _local_1:Object;
            var _local_2:Number;
            _local_1 = getStyleValue("background");
            if (_local_1 != null)
            {
                paletteBG = (getDisplayObjectInstance(_local_1) as Sprite);
            };
            if (paletteBG == null)
            {
                return;
            };
            _local_2 = Number(getStyleValue("backgroundPadding"));
            paletteBG.width = (Math.max(((showTextField) ? textFieldBG.width : 0), swatches.width) + (_local_2 * 2));
            paletteBG.height = ((swatches.y + swatches.height) + _local_2);
            palette.addChildAt(paletteBG, 0);
        }

        protected function positionTextField():void
        {
            var _local_1:Number;
            var _local_2:Number;
            if (!showTextField)
            {
                return;
            };
            _local_1 = (getStyleValue("backgroundPadding") as Number);
            _local_2 = (getStyleValue("textPadding") as Number);
            textFieldBG.x = (paletteBG.x + _local_1);
            textFieldBG.y = (paletteBG.y + _local_1);
            textField.x = (textFieldBG.x + _local_2);
            textField.y = (textFieldBG.y + _local_2);
        }

        protected function setEmbedFonts():void
        {
            var _local_1:Object;
            _local_1 = getStyleValue("embedFonts");
            if (_local_1 != null)
            {
                textField.embedFonts = _local_1;
            };
        }

        public function set showTextField(_arg_1:Boolean):void
        {
            invalidate(InvalidationType.STYLES);
            _showTextField = _arg_1;
        }

        protected function addStageListener(_arg_1:Event=null):void
        {
            stage.addEventListener(MouseEvent.MOUSE_DOWN, onStageClick, false, 0, true);
        }

        protected function drawPalette():void
        {
            if (isOpen)
            {
                stage.removeChild(palette);
            };
            palette = new Sprite();
            drawTextField();
            drawSwatches();
            drawBG();
        }

        protected function showPalette():void
        {
            var _local_1:Sprite;
            if (isOpen)
            {
                positionPalette();
                return;
            };
            addEventListener(Event.ENTER_FRAME, addCloseListener, false, 0, true);
            stage.addChild(palette);
            isOpen = true;
            positionPalette();
            dispatchEvent(new Event(Event.OPEN));
            stage.focus = textField;
            _local_1 = selectedSwatch;
            if (_local_1 == null)
            {
                _local_1 = findSwatch(_selectedColor);
            };
            setSwatchHighlight(_local_1);
        }

        public function set editable(_arg_1:Boolean):void
        {
            _editable = _arg_1;
            invalidate(InvalidationType.STATE);
        }

        public function set colors(_arg_1:Array):void
        {
            customColors = _arg_1;
            invalidate(InvalidationType.DATA);
        }

        protected function drawTextField():void
        {
            var _local_1:Number;
            var _local_2:Number;
            var _local_3:Object;
            var _local_4:TextFormat;
            var _local_5:TextFormat;
            if (!showTextField)
            {
                return;
            };
            _local_1 = (getStyleValue("backgroundPadding") as Number);
            _local_2 = (getStyleValue("textPadding") as Number);
            textFieldBG = getDisplayObjectInstance(getStyleValue("textFieldSkin"));
            if (textFieldBG != null)
            {
                palette.addChild(textFieldBG);
                textFieldBG.x = (textFieldBG.y = _local_1);
            };
            _local_3 = UIComponent.getStyleDefinition();
            _local_4 = ((enabled) ? (_local_3.defaultTextFormat as TextFormat) : (_local_3.defaultDisabledTextFormat as TextFormat));
            textField.setTextFormat(_local_4);
            _local_5 = (getStyleValue("textFormat") as TextFormat);
            if (_local_5 != null)
            {
                textField.setTextFormat(_local_5);
            }
            else
            {
                _local_5 = _local_4;
            };
            textField.defaultTextFormat = _local_5;
            setEmbedFonts();
            textField.restrict = "A-Fa-f0-9#";
            textField.maxChars = 6;
            palette.addChild(textField);
            textField.text = " #888888 ";
            textField.height = (textField.textHeight + 3);
            textField.width = (textField.textWidth + 3);
            textField.text = "";
            textField.x = (textField.y = (_local_1 + _local_2));
            textFieldBG.width = (textField.width + (_local_2 * 2));
            textFieldBG.height = (textField.height + (_local_2 * 2));
            setTextEditable();
        }

        protected function setColorText(_arg_1:uint):void
        {
            if (textField == null)
            {
                return;
            };
            textField.text = ("#" + colorToString(_arg_1));
        }

        protected function colorToString(_arg_1:uint):String
        {
            var _local_2:String;
            _local_2 = _arg_1.toString(16);
            while (_local_2.length < 6)
            {
                _local_2 = ("0" + _local_2);
            };
            return (_local_2);
        }

        public function get imeMode():String
        {
            return (_imeMode);
        }

        public function set selectedColor(_arg_1:uint):void
        {
            var _local_2:ColorTransform;
            if (!_enabled)
            {
                return;
            };
            _selectedColor = _arg_1;
            rollOverColor = -1;
            currColIndex = (currRowIndex = 0);
            _local_2 = new ColorTransform();
            _local_2.color = _arg_1;
            setColorWellColor(_local_2);
            invalidate(InvalidationType.DATA);
        }

        override protected function focusOutHandler(_arg_1:FocusEvent):void
        {
            if (_arg_1.relatedObject == textField)
            {
                setFocus();
                return;
            };
            if (isOpen)
            {
                close();
            };
            super.focusOutHandler(_arg_1);
            setIMEMode(false);
        }

        protected function onPopupButtonClick(_arg_1:MouseEvent):void
        {
            if (isOpen)
            {
                close();
            }
            else
            {
                open();
            };
        }

        protected function positionPalette():void
        {
            var _local_1:Point;
            var _local_2:Number;
            _local_1 = swatchButton.localToGlobal(new Point(0, 0));
            _local_2 = (getStyleValue("backgroundPadding") as Number);
            if ((_local_1.x + palette.width) > stage.stageWidth)
            {
                palette.x = ((_local_1.x - palette.width) << 0);
            }
            else
            {
                palette.x = (((_local_1.x + swatchButton.width) + _local_2) << 0);
            };
            palette.y = (Math.max(0, Math.min(_local_1.y, (stage.stageHeight - palette.height))) << 0);
        }

        public function get hexValue():String
        {
            if (colorWell == null)
            {
                return (colorToString(0));
            };
            return (colorToString(colorWell.transform.colorTransform.color));
        }

        override public function get enabled():Boolean
        {
            return (super.enabled);
        }

        protected function setSwatchHighlight(_arg_1:Sprite):void
        {
            var _local_2:Number;
            var _local_3:*;
            if (_arg_1 == null)
            {
                if (palette.contains(swatchSelectedSkin))
                {
                    palette.removeChild(swatchSelectedSkin);
                };
                return;
            };
            if (((!(palette.contains(swatchSelectedSkin))) && (colors.length > 0)))
            {
                palette.addChild(swatchSelectedSkin);
            }
            else
            {
                if (!colors.length)
                {
                    return;
                };
            };
            _local_2 = (getStyleValue("swatchPadding") as Number);
            palette.setChildIndex(swatchSelectedSkin, (palette.numChildren - 1));
            swatchSelectedSkin.x = ((swatches.x + _arg_1.x) - 1);
            swatchSelectedSkin.y = ((swatches.y + _arg_1.y) - 1);
            _local_3 = _arg_1.getChildByName("color").transform.colorTransform.color;
            currColIndex = colorHash[_local_3].col;
            currRowIndex = colorHash[_local_3].row;
        }

        protected function onSwatchClick(_arg_1:MouseEvent):void
        {
            var _local_2:ColorTransform;
            _local_2 = _arg_1.target.getChildByName("color").transform.colorTransform;
            _selectedColor = _local_2.color;
            dispatchEvent(new ColorPickerEvent(ColorPickerEvent.CHANGE, selectedColor));
            close();
        }

        override protected function draw():void
        {
            if (isInvalid(InvalidationType.STYLES, InvalidationType.DATA))
            {
                setStyles();
                drawPalette();
                setEmbedFonts();
                invalidate(InvalidationType.DATA, false);
                invalidate(InvalidationType.STYLES, false);
            };
            if (isInvalid(InvalidationType.DATA))
            {
                drawSwatchHighlight();
                setColorDisplay();
            };
            if (isInvalid(InvalidationType.STATE))
            {
                setTextEditable();
                if (doOpen)
                {
                    doOpen = false;
                    showPalette();
                };
                colorWell.visible = enabled;
            };
            if (isInvalid(InvalidationType.SIZE, InvalidationType.STYLES))
            {
                swatchButton.setSize(width, height);
                swatchButton.drawNow();
                colorWell.width = width;
                colorWell.height = height;
            };
            super.draw();
        }

        protected function drawSwatches():void
        {
            var _local_1:Number;
            var _local_2:Number;
            var _local_3:uint;
            var _local_4:uint;
            var _local_5:Number;
            var _local_6:Number;
            var _local_7:uint;
            var _local_8:int;
            var _local_9:uint;
            var _local_10:Sprite;
            _local_1 = (getStyleValue("backgroundPadding") as Number);
            _local_2 = ((showTextField) ? ((textFieldBG.y + textFieldBG.height) + _local_1) : _local_1);
            swatches = new Sprite();
            palette.addChild(swatches);
            swatches.x = _local_1;
            swatches.y = _local_2;
            _local_3 = (getStyleValue("columnCount") as uint);
            _local_4 = (getStyleValue("swatchPadding") as uint);
            _local_5 = (getStyleValue("swatchWidth") as Number);
            _local_6 = (getStyleValue("swatchHeight") as Number);
            colorHash = {};
            swatchMap = [];
            _local_7 = Math.min(0x0400, colors.length);
            _local_8 = -1;
            _local_9 = 0;
            while (_local_9 < _local_7)
            {
                _local_10 = createSwatch(colors[_local_9]);
                _local_10.x = ((_local_5 + _local_4) * (_local_9 % _local_3));
                if (_local_10.x == 0)
                {
                    swatchMap.push([_local_10]);
                    _local_8++;
                }
                else
                {
                    swatchMap[_local_8].push(_local_10);
                };
                colorHash[colors[_local_9]] = {
                    "swatch":_local_10,
                    "row":_local_8,
                    "col":(swatchMap[_local_8].length - 1)
                };
                _local_10.y = (Math.floor((_local_9 / _local_3)) * (_local_6 + _local_4));
                swatches.addChild(_local_10);
                _local_9++;
            };
        }

        override protected function configUI():void
        {
            var _local_1:uint;
            super.configUI();
            tabChildren = false;
            if (ColorPicker.defaultColors == null)
            {
                ColorPicker.defaultColors = [];
                _local_1 = 0;
                while (_local_1 < 216)
                {
                    ColorPicker.defaultColors.push(((((((((_local_1 / 6) % 3) << 0) + (((_local_1 / 108) << 0) * 3)) * 51) << 16) | (((_local_1 % 6) * 51) << 8)) | ((((_local_1 / 18) << 0) % 6) * 51)));
                    _local_1++;
                };
            };
            colorHash = {};
            swatchMap = [];
            textField = new TextField();
            textField.tabEnabled = false;
            swatchButton = new BaseButton();
            swatchButton.focusEnabled = false;
            swatchButton.useHandCursor = false;
            swatchButton.autoRepeat = false;
            swatchButton.setSize(25, 25);
            swatchButton.addEventListener(MouseEvent.CLICK, onPopupButtonClick, false, 0, true);
            addChild(swatchButton);
            palette = new Sprite();
            palette.tabChildren = false;
            palette.cacheAsBitmap = true;
        }

        public function get showTextField():Boolean
        {
            return (_showTextField);
        }

        public function get colors():Array
        {
            return ((customColors != null) ? customColors : ColorPicker.defaultColors);
        }

        protected function findSwatch(_arg_1:uint):Sprite
        {
            var _local_2:Object;
            if (!swatchMap.length)
            {
                return (null);
            };
            _local_2 = colorHash[_arg_1];
            if (_local_2 != null)
            {
                return (_local_2.swatch);
            };
            return (null);
        }

        protected function setColorDisplay():void
        {
            var _local_1:ColorTransform;
            var _local_2:Sprite;
            if (!swatchMap.length)
            {
                return;
            };
            _local_1 = new ColorTransform(0, 0, 0, 1, (_selectedColor >> 16), ((_selectedColor >> 8) & 0xFF), (_selectedColor & 0xFF), 0);
            setColorWellColor(_local_1);
            setColorText(_selectedColor);
            _local_2 = findSwatch(_selectedColor);
            setSwatchHighlight(_local_2);
            if (((swatchMap.length) && (colorHash[_selectedColor] == undefined)))
            {
                cleanUpSelected();
            };
        }

        protected function cleanUpSelected():void
        {
            if (((swatchSelectedSkin) && (palette.contains(swatchSelectedSkin))))
            {
                palette.removeChild(swatchSelectedSkin);
            };
        }

        public function get selectedColor():uint
        {
            if (colorWell == null)
            {
                return (0);
            };
            return (colorWell.transform.colorTransform.color);
        }

        private function addCloseListener(_arg_1:Event):*
        {
            removeEventListener(Event.ENTER_FRAME, addCloseListener);
            if (!isOpen)
            {
                return;
            };
            addStageListener();
        }

        protected function removeStageListener(_arg_1:Event=null):void
        {
            stage.removeEventListener(MouseEvent.MOUSE_DOWN, onStageClick, false);
        }

        protected function setStyles():void
        {
            var _local_1:DisplayObject;
            var _local_2:Object;
            _local_1 = colorWell;
            _local_2 = getStyleValue("colorWell");
            if (_local_2 != null)
            {
                colorWell = (getDisplayObjectInstance(_local_2) as DisplayObject);
            };
            addChildAt(colorWell, getChildIndex(swatchButton));
            copyStylesToChild(swatchButton, POPUP_BUTTON_STYLES);
            swatchButton.drawNow();
            if ((((!(_local_1 == null)) && (contains(_local_1))) && (!(_local_1 == colorWell))))
            {
                removeChild(_local_1);
            };
        }

        public function close():void
        {
            var _local_1:IFocusManager;
            if (isOpen)
            {
                stage.removeChild(palette);
                isOpen = false;
                dispatchEvent(new Event(Event.CLOSE));
            };
            _local_1 = focusManager;
            if (_local_1)
            {
                _local_1.defaultButtonEnabled = true;
            };
            removeStageListener();
            cleanUpSelected();
        }


    }
}//package fl.controls

