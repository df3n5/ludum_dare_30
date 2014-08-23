package;
import flixel.FlxG;
import flixel.util.FlxPoint;
import flixel.FlxSprite;

class DeathWall extends FlxSprite {
    public function new(x, y) {
        super(x, y, "assets/images/wall.png");
        this.x -= this.width;
        this.velocity.x = 20;
        this.immovable = true;
    }
}
