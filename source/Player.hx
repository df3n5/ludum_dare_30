package;
import flixel.FlxG;
import flixel.util.FlxPoint;
import flixel.FlxSprite;

class Player extends FlxSprite {
    public var gun:FlxSprite;
    public var gravity:Gravity;
    public var reversed:Bool;

    public function new(x, y) {
        super(x, y, "assets/images/player.png");
        scale.set(0.3, 0.3);
        updateHitbox();

        this.x -= this.width/2;
        this.y -= this.height/2;

        //this.offset.x += this.width*0.25;
        //this.width *=0.25;

        this.gun = new FlxSprite(this.x, this.y, "assets/images/gun.png");
        this.gun.scale.set(0.3, 0.3);
        this.gun.updateHitbox();

        this.gravity = null;
        reversed = false;
    }

    override public function update():Void {
        super.update();
        gun.x = x;
        gun.y = y;
        //drag.x = drag.y = 200.0;
        var speed : Float = 85;
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
        //var GRAVITY_CHANGE = 150.0;
        var GRAVITY_CHANGE = 75.0;
        if(gravity != null) {
            switch(gravity.type) {
                case GSouth:
                    velocity.y += GRAVITY_CHANGE;
                case GEast:
                    velocity.x += GRAVITY_CHANGE;
                case GWest:
                    velocity.x -= GRAVITY_CHANGE;
            }
        }
        if(reversed) {
            /*
            velocity.x *= 0.5;
            velocity.y *= 0.5;
            */
            velocity.x = - velocity.x;
            velocity.y = - velocity.y;
        }

        var angle = Math.atan2(FlxG.mouse.y - (y+(height/2)), FlxG.mouse.x - (x+(width/2)));
        if(reversed) {
            angle += Math.PI;
        }
        var degrees = angle * 180/Math.PI;
        gun.angle = degrees;
    }
}
