package test {
import com.adobe.serialization.json.JSON;

import flash.external.ExternalInterface;

public class TestPicture {

    public static function Init(str:String) : void {
        ExternalInterface.call("saveImage", com.adobe.serialization.json.JSON.encode(str));
    }

}
}
