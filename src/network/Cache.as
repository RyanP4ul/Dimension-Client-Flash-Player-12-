package network {
import flash.display.MovieClip;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;
import flash.utils.Dictionary;

public class Cache extends Object {

    public var equipments:Dictionary = new Dictionary();

    public var characters:Dictionary = new Dictionary();
    public var create:Dictionary = new Dictionary();
    public var hairs:Dictionary = new Dictionary();

    public var monsters:Dictionary = new Dictionary();
    public var maps:Dictionary = new Dictionary();

    public var monsterContext:LoaderContext = new LoaderContext(false, new ApplicationDomain((ApplicationDomain.currentDomain)));

    public function Cache()
    {
        monsterContext.checkPolicyFile = false;
        monsterContext.allowCodeImport = true;
    }

}
}
