package; 

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.FlxObject;
import flixel.text.FlxText;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;

enum Level {
    Portal;
}

class PlayState extends FlxState {
    var tiledLevel:TiledLevel;
    public var player:Player;
    public var portals:FlxGroup;

    public function new(levelNo:Int, glitched:Bool, died:Bool):Void {
        super();
    }

    function loadTiledLevel(path:String) {
        tiledLevel = new TiledLevel(path);
        // Add tilemaps
        add(tiledLevel.foregroundTiles);
        tiledLevel.loadObjects(this);
    }

    function loadLevel(level:Level) {
        switch(level) {
            case Level.Portal:
                loadTiledLevel("assets/tiled/portal.tmx");
        }
    }

    public override function create():Void {
        portals = new FlxGroup();
        loadLevel(Level.Portal);
    }

    override public function update():Void {
        player.update();
        portals.update();
    }
}
