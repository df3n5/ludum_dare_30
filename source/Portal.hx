package;

import flixel.FlxG;
import flixel.util.FlxPoint;
import flixel.FlxSprite;
import flixel.tweens.misc.ColorTween;
import flixel.tweens.FlxTween;

enum PortalType {
    Gravity;
    Reverse;
    Strobe;
    Wall;
    BossP;
}

class Portal extends FlxSprite {
    var tween:ColorTween;
    public var type:PortalType;

    public function new(x, y, type:PortalType) {
        super(x, y);
        loadGraphic("assets/images/portal_anim.png", true, 32, 32);
        animation.add("pulse", [0], 1, false);
        animation.play("pulse");
        //FlxTween.tween(this, { x:600, y:800 }, 2, { type:FlxTween.PINGPONG, ease:FlxEase.quadInOut, complete:changeColor, startDelay:1, loopDelay:2 });
        //tween = FlxTween.color(this, 1.0, 0xff0000, 0x000000, 1, 1, { type: FlxTween.ONESHOT, startDelay: 4.0});
        switch(type) {
            case Gravity:
                tween = FlxTween.color(this, 1.0, 0xff0000, 0x000000, 1, 1, { type: FlxTween.PINGPONG});
            case Reverse:
                tween = FlxTween.color(this, 1.0, 0x0000ff, 0x000000, 1, 1, { type: FlxTween.PINGPONG});
            case Strobe:
                tween = FlxTween.color(this, 1.0, 0x09ff00, 0x000000, 1, 1, { type: FlxTween.PINGPONG});
            case Wall:
                tween = FlxTween.color(this, 1.0, 0xff0ff0, 0x000000, 1, 1, { type: FlxTween.PINGPONG});
            case BossP:
                tween = FlxTween.color(this, 1.0, 0xedf600, 0xff0000, 1, 1, { type: FlxTween.PINGPONG});
        }
        this.type = type;
        //tween.loopDelay = 2.0;
    }

    override public function update():Void {
        super.update();
        this.alpha = tween.alpha;
    }
}
