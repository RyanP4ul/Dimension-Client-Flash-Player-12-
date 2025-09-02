// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//worldMap

package 
{
    import flash.display.MovieClip;
    import flash.utils.getQualifiedClassName;
    import flash.text.*;

    public class worldMap extends MovieClip 
    {

        public var rootClass:*;
        private var worldObject:Object;
        private var areaObject:Object;
        private var nodeObject:Object;
        private var cutsceneObject:Object;

        public function worldMap(_arg_1:Object)
        {
            var _local_2:String;
            var _local_3:String;
            var _local_5:*;
            var _local_6:String;
            var _local_7:String;
            var _local_8:String;
            var _local_9:String;
            var _local_10:Array;
            var _local_11:Number;
            var _local_12:String;
            var _local_13:*;
            var _local_14:*;
            var _local_15:*;
            var _local_16:*;
            var _local_17:*;
            var _local_18:*;
            var _local_19:*;
            var _local_20:Object;
            var _local_21:String;
            var _local_22:*;
            var _local_23:*;
            var _local_24:*;
            var _local_25:*;
            var _local_26:*;
            var _local_27:Array;
            var _local_28:String;
            var _local_29:String;
            var _local_30:*;
            super();
            this.worldObject = _arg_1;
            this.worldObject.areas = new Array();
            this.areaObject = new Object();
            this.nodeObject = new Object();
            this.cutsceneObject = new Object();
            var _local_4:* = "m";
            for (_local_5 in this.worldObject)
            {
                if (getQualifiedClassName(this.worldObject[_local_5]) == "Object")
                {
                    _local_3 = (_local_4 + this.worldObject[_local_5].regionID);
                    this.worldObject.areas.push(_local_3);
                    this.areaObject[_local_3] = new Object();
                    this.areaObject[_local_3] = this.worldObject[_local_5];
                    this.areaObject[_local_3].mapTitle = _local_5;
                    this.areaObject[_local_3].nodes = new Array();
                    for (_local_16 in this.worldObject[_local_5])
                    {
                        if (((getQualifiedClassName(this.worldObject[_local_5][_local_16]) == "Array") && (!(_local_16 == "nodes"))))
                        {
                            _local_17 = 0;
                            while (_local_17 < this.worldObject[_local_5][_local_16].length)
                            {
                                _local_2 = (String(this.worldObject[_local_5][_local_16][_local_17].mapName).toLowerCase() + this.worldObject[_local_5].regionID);
                                this.nodeObject[_local_2] = new Object();
                                this.nodeObject[_local_2] = this.worldObject[_local_5][_local_16][_local_17];
                                this.nodeObject[_local_2].area = String(_local_3);
                                this.areaObject[_local_3].nodes.push(_local_2);
                                this.nodeObject[_local_2].cuts = new Array();
                                for (_local_18 in this.worldObject[_local_5][_local_16][_local_17])
                                {
                                    if (((getQualifiedClassName(this.worldObject[_local_5][_local_16][_local_17][_local_18]) == "Array") && (!(_local_18 == "cuts"))))
                                    {
                                        _local_19 = 0;
                                        while (_local_19 < this.worldObject[_local_5][_local_16][_local_17][_local_18].length)
                                        {
                                            _local_20 = this.worldObject[_local_5][_local_16][_local_17][_local_18][_local_19];
                                            if (_local_20.qsIndex == this.nodeObject[_local_2].qsValue)
                                            {
                                                _local_21 = ((_local_2 + "c") + String(_local_19));
                                                this.cutsceneObject[_local_21] = new Object();
                                                this.cutsceneObject[_local_21].node = _local_2;
                                                this.cutsceneObject[_local_21] = _local_20;
                                                this.nodeObject[_local_2].cuts.push(_local_21);
                                            };
                                            _local_19++;
                                        };
                                    };
                                };
                                _local_17++;
                            };
                        };
                    };
                };
            };
            _local_6 = ",";
            _local_7 = ":";
            for (_local_13 in this.worldObject)
            {
                for (_local_22 in this.worldObject[_local_13])
                {
                    if (_local_22 == "description")
                    {
                        _local_8 = String(this.worldObject[_local_13][_local_22]);
                        _local_10 = _local_8.split(_local_6);
                        _local_23 = 0;
                        while (_local_23 < _local_10.length)
                        {
                            _local_9 = _local_10[_local_23];
                            _local_11 = _local_9.indexOf(_local_7);
                            if (_local_11 > -1)
                            {
                                _local_12 = _local_9.slice(0, _local_11);
                                this.worldObject[_local_13][_local_12] = _local_9.slice((_local_11 + 1), _local_9.length);
                            }
                            else
                            {
                                if (_local_9 != "")
                                {
                                    this.worldObject[_local_13][_local_9] = "";
                                };
                            };
                            _local_23++;
                        };
                        _local_10 = null;
                    };
                };
            };
            for (_local_14 in this.areaObject)
            {
                for (_local_24 in this.areaObject[_local_14])
                {
                    if (_local_24 == "strExtra")
                    {
                        _local_8 = String(this.areaObject[_local_14][_local_24]);
                        _local_10 = _local_8.split(_local_6);
                        _local_25 = 0;
                        while (_local_25 < _local_10.length)
                        {
                            _local_9 = _local_10[_local_25];
                            _local_11 = _local_9.indexOf(_local_7);
                            if (_local_11 > -1)
                            {
                                _local_12 = _local_9.slice(0, _local_11);
                                this.areaObject[_local_14][_local_12] = _local_9.slice((_local_11 + 1), _local_9.length);
                            }
                            else
                            {
                                if (_local_9 != "")
                                {
                                    this.areaObject[_local_14][_local_9] = "";
                                };
                            };
                            _local_25++;
                        };
                        _local_10 = null;
                    };
                };
            };
            for (_local_15 in this.nodeObject)
            {
                for (_local_26 in this.nodeObject[_local_15])
                {
                    switch (_local_26)
                    {
                        case "minLevel":
                        case "maxLevel":
                        case "qsValue":
                        case "questMin":
                        case "questMax":
                            this.nodeObject[_local_15][_local_26] = Number(this.nodeObject[_local_15][_local_26]);
                            break;
                        case "bUpgrade":
                            if (typeof(this.nodeObject[_local_15][_local_26]) == "string")
                            {
                                if (((this.nodeObject[_local_15][_local_26] == "False") || (this.nodeObject[_local_15][_local_26] == "false")))
                                {
                                    this.nodeObject[_local_15][_local_26] = false;
                                }
                                else
                                {
                                    this.nodeObject[_local_15][_local_26] = true;
                                };
                            };
                            break;
                        case "strExtra":
                            _local_8 = String(this.nodeObject[_local_15][_local_26]);
                            _local_27 = null;
                            _local_27 = _local_8.split(_local_6);
                            _local_30 = 0;
                            while (_local_30 < _local_27.length)
                            {
                                _local_28 = _local_27[_local_30];
                                _local_11 = _local_28.indexOf(_local_7);
                                if (_local_11 > -1)
                                {
                                    _local_29 = _local_28.slice(0, _local_11);
                                    this.nodeObject[_local_15][_local_29] = _local_28.slice((_local_11 + 1), _local_28.length);
                                }
                                else
                                {
                                    if (_local_28 != "")
                                    {
                                        this.nodeObject[_local_15][_local_28] = "";
                                    };
                                };
                                _local_30++;
                            };
                            break;
                    };
                };
            };
        }

        internal function get World():Object
        {
            return (this.worldObject);
        }

        internal function get Areas():Object
        {
            return (this.areaObject);
        }

        internal function get Nodes():Object
        {
            return (this.nodeObject);
        }

        internal function get Cutscenes():Object
        {
            return (this.cutsceneObject);
        }

        internal function specificArea(_arg_1:String):Object
        {
            if (this.areaObject[_arg_1] != null)
            {
                return (this.areaObject[_arg_1]);
            };
            return (null);
        }

        internal function getAreaNameByTitle(_arg_1:String):String
        {
            var _local_2:*;
            for (_local_2 in this.areaObject)
            {
                if (this.areaObject[_local_2].mapTitle != undefined)
                {
                    if (this.areaObject[_local_2].mapTitle == _arg_1)
                    {
                        return (_local_2);
                    };
                };
            };
            return (null);
        }

        internal function getAreaByTitle(_arg_1:String):Object
        {
            var _local_2:*;
            for (_local_2 in this.areaObject)
            {
                if (this.areaObject[_local_2].mapTitle != undefined)
                {
                    if (this.areaObject[_local_2].mapTitle == _arg_1)
                    {
                        return (this.areaObject[_local_2]);
                    };
                };
            };
            return (null);
        }

        internal function getAreaByLink(_arg_1:String):Object
        {
            var _local_2:*;
            for (_local_2 in this.areaObject)
            {
                if (this.areaObject[_local_2].strLink != undefined)
                {
                    if (this.areaObject[_local_2].strLink == _arg_1)
                    {
                        return (this.areaObject[_local_2]);
                    };
                };
            };
            return (null);
        }

        internal function specificNode(_arg_1:String):Object
        {
            if (this.nodeObject[_arg_1] != null)
            {
                return (this.nodeObject[_arg_1]);
            };
            return (null);
        }

        internal function specificCutscene(_arg_1:String):Object
        {
            if (this.cutsceneObject[_arg_1] != null)
            {
                return (this.cutsceneObject[_arg_1]);
            };
            return (null);
        }


    }
}//package 

