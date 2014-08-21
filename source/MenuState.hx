package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.tweens.misc.ColorTween;
import flixel.tweens.FlxTween;

class MenuState extends FlxState {
    override public function create():Void {
        var title = new FlxSprite(0, 0, "assets/images/Startscreen.png");
        add(title);
        super.create();
    }

    override public function update():Void {
        super.update();
        if(FlxG.keys.justPressed.SPACE) {
            FlxG.switchState(new PlayState(0, true, true));
        }
    }
}

