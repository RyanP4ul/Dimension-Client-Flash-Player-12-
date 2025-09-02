package game.preference {
import flash.net.SharedObject;

public class SettingPreference implements IPreference {

    private const preferenceName:String = "CharsPreference";

    public static var settings:SharedObject;

    public function SettingPreference() {
    }

    public static function change(name:String, bEnabled:Boolean): void
    {
        switch (name)
        {
            case "":

                settings.flush();
                break;
        }
    }

    public function save():void {
        settings.flush();
    }

    public function clear():void {
        settings.data.users = null;
        delete settings.data.users;
        settings.flush();
    }
}
}
