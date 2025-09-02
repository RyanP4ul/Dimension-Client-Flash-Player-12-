package network.data {
public class User extends Object {

    private var id:int;
    private var name:String;
    private var pId:int;

    public function User(id:int, name:String) {
        this.id = id;
        this.name = name;
    }

    public function getId(): int { return id; }

    public function getName(): String { return name; }

    public function getPlayerId() : int { return (this.pId); }

    public function setPlayerId(id:int): void { pId = id; }

}

}
