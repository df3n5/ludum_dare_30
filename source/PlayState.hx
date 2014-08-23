package; 

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.FlxObject;
import flixel.text.FlxText;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.tweens.misc.ColorTween;
import flixel.tweens.FlxTween;

enum Level {
    PortalL;
    GravityL;
    ReverseL;
    StrobeL;
    WallL;
}

class PlayState extends FlxState {
    var bulletSpeed:Float = 230.0;
    var tiledLevel:TiledLevel;
    public var player:Player;
    public var portals:FlxGroup;
    public var gravitys:FlxGroup;
    public var letters:FlxGroup;
    var level:Level;
    public var bullets:FlxGroup;
    public static var letterMGot = false;
    public static var letterAGot = false;
    public static var letterSGot = false;
    var crazyStrobe:Bool;
    var crazyStrobeTween:ColorTween;

    public function new(level:Level):Void {
        super();
        this.level = level;
        crazyStrobe = false;
    }

    function loadTiledLevel(path:String) {
        tiledLevel = new TiledLevel(path);
        // Add tilemaps
        add(tiledLevel.foregroundTiles);
        add(tiledLevel.backgroundTiles);
        tiledLevel.loadObjects(this);
    }

    function loadLevel(level:Level) {
        switch(level) {
            case Level.PortalL:
                loadTiledLevel("assets/tiled/portal.tmx");
            case Level.GravityL:
                loadTiledLevel("assets/tiled/gravity.tmx");
            case Level.ReverseL:
                loadTiledLevel("assets/tiled/reverse.tmx");
                player.reversed = true;
            case Level.StrobeL:
                loadTiledLevel("assets/tiled/strobe.tmx");
                crazyStrobe = true;
                crazyStrobeTween = FlxTween.color(1.0, 0xff0ff0, 0x000000, 0, 1, { type: FlxTween.PINGPONG});
            case Level.WallL:
                throw "No Level defined";
        }
    }

    public override function create():Void {
        portals = new FlxGroup();
        gravitys = new FlxGroup();
        bullets = new FlxGroup();
        letters = new FlxGroup();
        add(gravitys);
        add(portals);
        add(bullets);
        loadLevel(level);
        //FlxG.camera.color = 0xFF0000;
        //FlxG.camera.alpha = 0.5;
    }

    override public function update():Void {
        player.update();
        portals.update();
        bullets.update();
        letters.update();
        FlxG.collide(player, portals, playerPortalCollide);
        FlxG.overlap(bullets, gravitys, bulletGravityCollide);
        FlxG.overlap(player, letters, playerLetterCollide);
        tiledLevel.collideKillWithLevel(player, playerLevelCollide);
        tiledLevel.collideWithLevel(player);
        tiledLevel.collideWithLevel(bullets, levelBulletCollide);
        if(FlxG.mouse.justPressed) {
            fireGun();
        }
        if(crazyStrobeTween != null) {
            FlxG.camera.color = crazyStrobeTween.color;
//            FlxG.camera.alpha = crazyStrobeTween.alpha;
        }
    }


    function fireGun():Void {
        var radians = player.gun.angle * Math.PI/180.0;
        var bullet = new FlxSprite(player.x + player.width/4, player.y + player.height/4, "assets/images/bullet.png");
        bullet.velocity.x = Math.cos(radians)*bulletSpeed;
        bullet.velocity.y = Math.sin(radians)*bulletSpeed;
        bullets.add(bullet);
        add(bullet);
    }

    function playerPortalCollide(player:FlxObject, portal:FlxObject):Void {
        var portal:Portal = cast(portal);
        //var portal:FlxObject = portal;
        //cast(portal, Portal);
        switch(portal.type) {
            case Gravity:
                FlxG.switchState(new PlayState(GravityL));
            case Reverse:
                FlxG.switchState(new PlayState(ReverseL));
            case Strobe:
                FlxG.switchState(new PlayState(StrobeL));
            case Wall:
                FlxG.switchState(new PlayState(WallL));
        }
    }

    function playerLevelCollide(obj0:FlxObject, obj1:FlxObject):Void {
        FlxG.switchState(new PlayState(this.level));
    }

    function bulletGravityCollide(obj0:FlxObject, obj1:FlxObject):Void {
        obj0.kill();
        var gravity:Gravity = cast(obj1);
        //var GRAVITY_ACCEL = 900.8;
        //player.acceleration.x = player.acceleration.y = 0;
        player.gravity = gravity;
    }


    function playerLetterCollide(obj0:FlxObject, obj1:FlxObject):Void {
        var letter:Letter = cast(obj1);
        switch(letter.type) {
            case LM:
                letterMGot = true;
            case LA:
                letterAGot = true;
            case LS:
                letterSGot = true;
        }
        FlxG.switchState(new PlayState(PortalL));
    }


    function levelBulletCollide(obj0:FlxObject, obj1:FlxObject):Void {
        obj1.kill();
    }

    private function pixelPerfectProcess(obj0:FlxObject, obj1:FlxObject):Bool {
        var sprite0:FlxSprite = cast(obj0, FlxSprite);
        var sprite1:FlxSprite = cast(obj1, FlxSprite);
        if(FlxG.pixelPerfectOverlap(sprite0, sprite1)) {
            return true;
        }
        return false;
    }
}
