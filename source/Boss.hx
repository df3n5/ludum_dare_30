package;
import flixel.FlxG;
import flixel.util.FlxPoint;
import flixel.FlxSprite;
import flixel.tweens.misc.ColorTween;
import flixel.tweens.FlxTween;

class Boss extends FlxSprite {
    var tween:ColorTween;

    public function new(x, y) {
        super(x, y, "assets/images/boss.png");
        this.immovable = true;
    }

    public function hit() {
        if(tween != null) {
            tween.cancel();
        }
        tween = FlxTween.color(this, 1.0, 0xff0000, 0xffffff, 1, 1, { type: FlxTween.ONESHOT});
    }

    override public function update():Void {
        super.update();
    }
}
