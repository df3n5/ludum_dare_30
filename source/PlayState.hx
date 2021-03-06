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
import flixel.util.FlxTimer;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;

enum Level {
    PortalL;
    GravityL;
    ReverseL;
    StrobeL;
    WallL;
    BossL;
    CreditsL;
}

class PlayState extends FlxState {
    var bulletSpeed:Float = 230.0;
    var tiledLevel:TiledLevel;
    public var player:Player;
    public var boss:Boss;
    public var portals:FlxGroup;
    public var gravitys:FlxGroup;
    public var letters:FlxGroup;
    public var deathWalls:FlxGroup;
    public var bosses:FlxGroup;
    public var enBullets:FlxGroup;
    public var bats:FlxGroup;
    var level:Level;
    public var exit: Portal;
    public var bullets:FlxGroup;
    public static var letterMGot = false;
    public static var letterAGot = false;
    public static var letterSGot = false;
    public static var letterTGot = false;
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
                player.gravity = new Gravity(0,0, GSouth);
                FlxG.sound.play("portal");
            case Level.ReverseL:
                loadTiledLevel("assets/tiled/reverse.tmx");
                player.reversed = true;
                FlxG.sound.play("portal");
            case Level.StrobeL:
                loadTiledLevel("assets/tiled/strobe.tmx");
                crazyStrobe = true;
                crazyStrobeTween = FlxTween.color(1.0, 0x999999, 0x000000, 0, 1, { type: FlxTween.PINGPONG});
                FlxG.sound.play("portal");
            case Level.WallL:
                loadTiledLevel("assets/tiled/wall.tmx");
                var deathWall:DeathWall = new DeathWall(0, 0);
                add(deathWall);
                deathWalls.add(deathWall);
                FlxG.sound.play("portal");
            case Level.BossL:
                loadTiledLevel("assets/tiled/boss_0.tmx");
                new FlxTimer(1.0, bossFire, 1);
                exit.kill();
                FlxG.sound.play("portal");
            case Level.CreditsL:
                //loadTiledLevel("assets/tiled/credits.tmx");
                tiledLevel = new TiledLevel("assets/tiled/credits.tmx");
                // Add tilemaps
                add(tiledLevel.foregroundTiles);
                add(tiledLevel.backgroundTiles);
                var credits = new FlxSprite("assets/images/credits.png");
                add(credits);
                tiledLevel.loadObjects(this);
                FlxG.sound.play("portal");
        }
    }

    public override function create():Void {
        portals = new FlxGroup();
        gravitys = new FlxGroup();
        bullets = new FlxGroup();
        letters = new FlxGroup();
        deathWalls = new FlxGroup();
        bosses = new FlxGroup();
        enBullets = new FlxGroup();
        bats = new FlxGroup();
        add(gravitys);
        add(portals);
        add(bullets);
        add(bosses);
        loadLevel(level);

        //FlxG.camera.color = 0xFF0000;
        //FlxG.camera.alpha = 0.5;

    }

    override public function update():Void {
        player.update();
        portals.update();
        bullets.update();
        enBullets.update();
        letters.update();
        bosses.update();
        deathWalls.update();
        bats.update();
        FlxG.collide(player, portals, playerPortalCollide);
        FlxG.overlap(bullets, gravitys, bulletGravityCollide);
        FlxG.overlap(bullets, bats, bulletBatCollide);
        FlxG.overlap(bullets, bosses, bulletBossCollide);
        FlxG.overlap(player, letters, playerLetterCollide);
        FlxG.collide(player, deathWalls);
        FlxG.overlap(enBullets, player, enBulletPlayerCollide);
        FlxG.overlap(player, bosses, playerBossCollide);
        tiledLevel.collideWithLevel(bosses, levelBossesCollide);
        tiledLevel.collideKillWithLevel(player, playerLevelCollide);
        tiledLevel.collideWithLevel(player);
        tiledLevel.collideWithLevel(bullets, levelBulletCollide);
        tiledLevel.collideWithLevel(bats);
        FlxG.collide(bats, player, batsPlayerCollide);
        if(FlxG.mouse.justPressed) {
            fireGun();
        }
        if(crazyStrobeTween != null) {
            FlxG.camera.color = crazyStrobeTween.color;
//            FlxG.camera.alpha = crazyStrobeTween.alpha;
        }

        if(FlxG.keys.anyPressed(["P"])) {
            FlxG.switchState(new PlayState(PortalL));
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
            case BossP:
                FlxG.switchState(new PlayState(BossL));
            case Exit:
                FlxG.switchState(new PlayState(CreditsL));
        }
    }

    function playerLevelCollide(obj0:FlxObject, obj1:FlxObject):Void {
        FlxG.switchState(new PlayState(this.level));
    }

    function bulletBossCollide(obj0:FlxObject, obj1:FlxObject):Void {
        //var boss:Boss = cast(obj1);
        if((obj0.y - obj1.y) < 0) { //Should be from behind
            boss.hit();
            if(boss.hits > 30) {
                boss.kill();
                exit.revive();
                FlxG.cameras.shake();
                FlxG.sound.play("boss_kill");
            } else {
                FlxG.sound.play("boss_hit");
            }
        }
        obj0.kill();
    }

    function enBulletPlayerCollide(obj0:FlxObject, obj1:FlxObject):Void {
        FlxG.switchState(new PlayState(this.level));
    }

    function bulletGravityCollide(obj0:FlxObject, obj1:FlxObject):Void {
        FlxG.sound.play("switch");
        obj0.kill();
        var gravity:Gravity = cast(obj1);
        //var GRAVITY_ACCEL = 900.8;
        //player.acceleration.x = player.acceleration.y = 0;
        player.gravity = gravity;
    }

    function bulletBatCollide(obj0:FlxObject, obj1:FlxObject):Void {
        FlxG.sound.play("kill_bat");
        obj0.kill();
        obj1.kill();
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
            case LT:
                letterTGot = true;
        }
        FlxG.switchState(new PlayState(PortalL));
    }


    function levelBulletCollide(obj0:FlxObject, obj1:FlxObject):Void {
        obj1.kill();
    }

    function levelBossesCollide(obj0:FlxObject, obj1:FlxObject):Void {
        var boss:Boss = cast(obj1);
        boss.hitWall();
    }

    function playerBossCollide(obj0:FlxObject, obj1:FlxObject):Void {
        FlxG.switchState(new PlayState(this.level));
    }

    function batsPlayerCollide(obj0:FlxObject, obj1:FlxObject):Void {
        FlxG.switchState(new PlayState(this.level));
    }

    function bossFire(timer:FlxTimer):Void {
        if(boss.alive) {
            bossFireGun();
            new FlxTimer(1.0, bossFire, 1);
        }
    }

    function bossFireGun():Void {
        var angle = Math.atan2(player.y - (boss.y+(boss.height/2)), player.x - (boss.x+(boss.width/2)));
        var bulletSpeed = 300.0;
        var bullet = new FlxSprite(boss.x + boss.width/2, boss.y + boss.height/2, "assets/images/bullet.png");
        bullet.velocity.x = Math.cos(angle)*bulletSpeed;
        bullet.velocity.y = Math.sin(angle)*bulletSpeed;
        enBullets.add(bullet);
        add(bullet);
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
