package;

import flixel.FlxG;
import flixel.util.FlxPoint;
import flixel.FlxSprite;
import flixel.tweens.misc.ColorTween;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class BatEmitter extends FlxSprite {
    var state :PlayState;
    var time:Float = 4.0;

    public function new(x, y, state:PlayState) {
        super(x, y, "assets/images/bat_emitter.png");
        this.state = state;
        new FlxTimer(time, spawnThing, 1);
    }

    function spawnThing(timer:FlxTimer):Void {
        var bat = new Bat(x+width/2, y+height/2, state.player);
        state.add(bat);
        state.bats.add(bat);
        new FlxTimer(time, spawnThing, 1);
    }
}
