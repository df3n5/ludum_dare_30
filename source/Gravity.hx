package;

import flixel.FlxG;
import flixel.util.FlxPoint;
import flixel.FlxSprite;
import flixel.tweens.misc.ColorTween;
import flixel.tweens.FlxTween;

enum GravityType {
    GEast;
    GSouth;
}

class Gravity extends FlxSprite {
    public var type:GravityType;
    public function new(x, y, type:GravityType) {
        super(x, y);
        this.type = type;
        switch(type) {
            case GEast:
                loadGraphic("assets/images/cross_east.png");
            case GSouth:
                loadGraphic("assets/images/cross_south.png");
        }
    }
}
