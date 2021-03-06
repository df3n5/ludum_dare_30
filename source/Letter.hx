package;

import flixel.FlxG;
import flixel.util.FlxPoint;
import flixel.FlxSprite;
import flixel.tweens.misc.ColorTween;
import flixel.tweens.FlxTween;

enum LetterType {
    LM;
    LA;
    LS;
    LT;
}

class Letter extends FlxSprite {
    public var type:LetterType;
    public function new(x, y, type:LetterType) {
        super(x, y);
        this.type = type;
        switch(type) {
            case LM:
                loadGraphic("assets/images/letter_m.png");
            case LA:
                loadGraphic("assets/images/letter_a.png");
            case LS:
                loadGraphic("assets/images/letter_s.png");
            case LT:
                loadGraphic("assets/images/letter_t.png");
        }
    }
}
