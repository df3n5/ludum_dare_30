import flixel.FlxG;
import flixel.util.FlxPoint;
import flixel.FlxSprite;

class Player extends FlxSprite {
    public var gun:FlxSprite;

    public function new(x, y) {
        super(x, y, "assets/images/player.png");
        this.x -= this.width/2;
        this.y -= this.height/2;
        this.gun = new FlxSprite(x, y, "assets/images/gun.png");
    }

    override public function update():Void {
        super.update();
        gun.x = x;
        gun.y = y;
        drag.x = drag.y = 200.0;
        var speed : Float = 180;
        var moving : Bool = false;
        velocity.x = velocity.y = 0;
        if(FlxG.keys.anyPressed(["S"])) {
            velocity.y = speed;
            moving = true;
        } else if(FlxG.keys.anyPressed(["W"])) {
            velocity.y = -speed;
            moving = true;
        }
        if(FlxG.keys.anyPressed(["A"])) {
            velocity.x = -speed;
            moving = true;
        } else if(FlxG.keys.anyPressed(["D"])) {
            velocity.x = speed;
            moving = true;
        }

        var angle = Math.atan2(FlxG.mouse.y - (y+(height/2)), FlxG.mouse.x - (x+(width/2)));
        var degrees = angle * 180/Math.PI;
        gun.angle = degrees;
    }
}
