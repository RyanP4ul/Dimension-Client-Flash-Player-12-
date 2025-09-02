package network.data {

public class Room extends Object {

    private var userCount:int = 0;
    private var userList:Array;

    public function Room() {
        userList = [];
        userCount = 0;
    }

    public function addUser(user:User, id:int) : void
    {
        userList[id] = user;
        userCount++;
    }

    public function removeUser(id:int) : void
    {
        userCount--;
        delete this.userList[id];
    }
    public function getUserList(): Array
    {
        return this.userList;
    }

    public function getUser(param1:*) : User
    {
        var _loc_3:String;
        var _loc_4:User;
        var _loc_2:User;

        if (typeof(param1) == "number")
        {
            _loc_2 = userList[param1];
        }
        else if (typeof(param1) == "string")
        {
            for (_loc_3 in userList)
            {
                _loc_4 = userList[_loc_3];
                if (_loc_4.getName() == param1)
                {
                    _loc_2 = _loc_4;
                    break;
                }
            }
        }
        return _loc_2;
    }

}
}
