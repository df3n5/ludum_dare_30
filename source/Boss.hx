package;
import flixel.FlxG;
import flixel.util.FlxPoint;
import flixel.FlxSprite;
import flixel.tweens.misc.ColorTween;
import flixel.tweens.FlxTween;

class Boss extends FlxSprite {
    var tween:ColorTween;
    var speed:Float = 100;
    public var hits:Int;

    public function new(x, y) {
        super(x, y, "assets/images/boss.png");
//        this.immovable = true;
        velocity.y = speed;
        hits = 0;
    }

    public function hit() {
        if(tween != null) {
            tween.cancel();
        }
        tween = FlxTween.color(this, 1.0, 0xff0000, 0xffffff, 1, 1, { type: FlxTween.ONESHOT});
        hits++;
    }

    public function hitWall() {
        trace("hitWall");
    }

    override public function update():Void {
        super.update();
        trace("y " + y);
        if(y > 200) {
            velocity.y = -speed;
        }
        if(y < 35) {
            velocity.y = speed;
        }
    }
}
