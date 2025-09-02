// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//BankController

package 
{
    import flash.display.MovieClip;

    public class BankController 
    {

        private var bankModified:Boolean = true;
        private var game:Game = Game.root;
        private var bankItems:Object;
        private var bankArr:Array = [];
        private var searchArr:Array = [];
        private var lastSearch:String = "";
        private var requestedTypes:Object = {};
        public var Count:int = 0;

        public function BankController()
        {
            bankItems = {};
        }

        public function addItemsToBank(_arg_1:Array):void
        {
            var _local_2:Object;
            for each (_local_2 in _arg_1)
            {
                if (bankItems[int(_local_2.ItemID)] == null)
                {
                    bankModified = true;
                    bankItems[int(_local_2.ItemID)] = _local_2;
                }
            }
        }

        public function addItem(_arg_1:Object):void
        {
            bankItems[_arg_1.ItemID] = _arg_1;
        }

        public function isItemInBank(_arg_1:int):Boolean
        {
            return (!(bankItems[_arg_1] == null));
        }

        public function get items():Array
        {
            return ((lastSearch == "") ? BankArray : SearchArray);
        }

        public function get BankArray():Array
        {
            var _local_1:Object;
            if (bankModified)
            {
                bankArr = [];
                for each (_local_1 in bankItems)
                {
                    bankArr.push(_local_1);
                }
                bankModified = false;
            }
            return (bankArr);
        }

        public function addRequestedTypes(_arg_1:Array):void
        {
            var _local_2:uint = 0;
            while (_local_2 < _arg_1.length)
            {
                requestedTypes[String(_arg_1[_local_2])] = true;
                _local_2++;
            }
        }

        public function hasRequested(_arg_1:Array):Boolean
        {
            var _local_2:uint = 0;
            while (_local_2 < _arg_1.length)
            {
                if (requestedTypes[_arg_1[_local_2]] == null)
                {
                    return (false);
                }
                _local_2++;
            }
            return (true);
        }

        public function bankToInv(_arg_1:int):Object
        {
            if (bankItems[_arg_1] == null) return null;

            var _local_2:Object = bankItems[_arg_1];
            delete bankItems[_arg_1];
            bankModified = true;
            if (_local_2.bGold == 0)
            {
                Count--;
            }
            var _local_3:String = lastSearch;
            resetSearch();
            search(_local_3);
            return (_local_2);
        }

        public function getBankItem(_arg_1:int):Object
        {
            return (bankItems[_arg_1]);
        }

        public function resetSearch():void
        {
            lastSearch = "";
        }

        public function get SearchArray():Array
        {
            return (searchArr);
        }

        public function search(_arg_1:String):void
        {
            var _local_2:Object;
            if (lastSearch == _arg_1)
            {
                return;
            }
            searchArr = [];
            lastSearch = _arg_1;
            for each (_local_2 in bankItems)
            {
                if (_local_2.sName.toLowerCase().indexOf(_arg_1) > -1)
                {
                    searchArr.push(_local_2);
                }
            }
            MovieClip(game.ui.mcPopup.getChildByName("mcBank")).update({"eventType":"refreshBank"});
        }


    }
}//package 

