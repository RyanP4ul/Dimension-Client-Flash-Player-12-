package combat {
import com.greensock.TweenLite;

import flash.display.MovieClip;

public class Combat {

    public var game:Game = Game.root;

    public function Combat() {
    }

    public function createTelegraphCircle(radius:Number):MovieClip {
        var s:MovieClip = new MovieClip();
        s.graphics.beginFill(0xFF0000, 0.4);
        s.graphics.drawCircle(0, 0, radius);
        s.graphics.endFill();
        return s;
    }

    public function telegraphedAttack(x:Number, y:Number, delay:Number):void {
        var circle:MovieClip =createTelegraphCircle(40);
        circle.x = x;
        circle.y = y;
        circle.width = 50;
        circle.height = 50;
        circle.alpha = 0.1;
        game.world.addChild(circle);

        TweenLite.to(circle, 3.5, {
            alpha: 0.5,
            repeat: int(delay / 500) - 1,
            yoyo: true,
            onComplete: function():void {
                game.world.removeChild(circle);
            }
        });
    }

}
}
