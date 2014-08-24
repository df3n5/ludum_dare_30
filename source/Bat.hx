package;

import flixel.FlxG;
import flixel.util.FlxPoint;
import flixel.FlxSprite;
import flixel.tweens.misc.ColorTween;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class Bat extends FlxSprite {
    var player:Player;

    public function new(x, y, player:Player) {
        super(x, y, "assets/images/bat.png");
        this.player = player;
    }

    override public function update():Void {
        super.update();
        var angle = Math.atan2(player.y + (player.height/2) - (y+(height/2)), player.x + (player.width/2) - (x+(width/2)));
        var speed = 30.0;
        velocity.x = Math.cos(angle)*speed;
        velocity.y = Math.sin(angle)*speed;
    }
}
