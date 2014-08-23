package; 

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.FlxObject;
import flixel.text.FlxText;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;

class PlayState extends FlxState {
    var tiledLevel:TiledLevel;

    public function new(levelNo:Int, glitched:Bool, died:Bool):Void {
        super();
    }

    public override function create():Void {
        tiledLevel = new TiledLevel("assets/tiled/portal.tmx");
        tiledLevel.loadObjects(this);
        // Add tilemaps
        add(tiledLevel.foregroundTiles);
    }

    override public function update():Void {
    }
}
