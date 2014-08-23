package;

import openfl.Assets;
import haxe.io.Path;
import haxe.xml.Parser;
import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.util.FlxPoint;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectGroup;
import flixel.addons.editors.tiled.TiledTileSet;

class TiledLevel extends TiledMap {
	// For each "Tile Layer" in the map, you must define a "tileset" property which contains the name of a tile sheet image 
	// used to draw tiles in that layer (without file extension). The image file must be located in the directory specified bellow.
	private inline static var c_PATH_LEVEL_TILESHEETS = "assets/tiled/";
	
	// Array of tilemaps used for collision
	public var foregroundTiles:FlxGroup;
	public var backgroundTiles:FlxGroup;
	public var collidableTileLayers:Array<FlxTilemap>;
	public var collidableKillTileLayers:Array<FlxTilemap>;
	
	public function new(tiledLevel:Dynamic) {
		super(tiledLevel);
		
		foregroundTiles = new FlxGroup();
		backgroundTiles = new FlxGroup();
		
		FlxG.camera.setBounds(0, 0, fullWidth, fullHeight, true);
		
		// Load Tile Maps
		for(tileLayer in layers) {
			var tileSheetName:String = tileLayer.properties.get("tileset");
			
			if(tileSheetName == null) {
				throw "'tileset' property not defined for the '" + tileLayer.name + "' layer. Please add the property to the layer.";
            }
				
			var tileSet:TiledTileSet = null;
			for(ts in tilesets) {
				if(ts.name == tileSheetName) {
					tileSet = ts;
					break;
				}
			}
			
			if (tileSet == null) {
				throw "Tileset '" + tileSheetName + " not found. Did you mispell the 'tilesheet' property in " + tileLayer.name + "' layer?";
            }
				
			var imagePath 		= new Path(tileSet.imageSource);
			var processedPath 	= c_PATH_LEVEL_TILESHEETS + imagePath.file + "." + imagePath.ext;
			
			var tilemap:FlxTilemap = new FlxTilemap();
			tilemap.widthInTiles = width;
			tilemap.heightInTiles = height;
			tilemap.loadMap(tileLayer.tileArray, processedPath, tileSet.tileWidth, tileSet.tileHeight, 0, 1, 1, 1);
			
			if (tileLayer.properties.contains("collide")) {
				if (collidableTileLayers == null) {
					collidableTileLayers = new Array<FlxTilemap>();
                }
				
				foregroundTiles.add(tilemap);
				collidableTileLayers.push(tilemap);
            } else if (tileLayer.properties.contains("collidekill")) {
				if (collidableKillTileLayers == null) {
					collidableKillTileLayers = new Array<FlxTilemap>();
                }
				
				foregroundTiles.add(tilemap);
				collidableKillTileLayers.push(tilemap);
			} else {
				backgroundTiles.add(tilemap);
			}
		}
	}
	
	public function loadObjects(state:PlayState) {
		for(group in objectGroups) {
			for(o in group.objects) {
				loadObject(o, group, state);
			}
		}
	}
	
	private function loadObject(o:TiledObject, g:TiledObjectGroup, state:PlayState) {
		var x:Int = o.x;
		var y:Int = o.y;
		
		// objects in tiled are aligned bottom-left (top-left in flixel)
		if (o.gid != -1) {
			y -= g.map.getGidOwner(o.gid).tileHeight;
        }
		switch (o.type.toLowerCase()) {
            default:
                return;
			case "player":
                var player:Player = new Player(x, y);
                //var player:Player = new Player(100, 100);
                state.add(player);
                state.player = player;
                state.add(player.gun);
            case "gravity":
                if(!PlayState.letterMGot) {
                    var portal:Portal = new Portal(x, y, Gravity);
                    state.add(portal);
                    state.portals.add(portal);
                }
            case "reverse":
                if(!PlayState.letterAGot) {
                    var portal:Portal = new Portal(x, y, Reverse);
                    state.add(portal);
                    state.portals.add(portal);
                }
            case "strobe":
                if(!PlayState.letterSGot) {
                    var portal:Portal = new Portal(x, y, Strobe);
                    state.add(portal);
                    state.portals.add(portal);
                }
            case "wall":
                var portal:Portal = new Portal(x, y, Wall);
                state.add(portal);
                state.portals.add(portal);
            case "letter_m":
                var letter:Letter = new Letter(x, y, LM);
                state.add(letter);
                state.letters.add(letter);
            case "letter_a":
                var letter:Letter = new Letter(x, y, LA);
                state.add(letter);
                state.letters.add(letter);
            case "letter_s":
                var letter:Letter = new Letter(x, y, LS);
                state.add(letter);
                state.letters.add(letter);
            case "east":
                var gravity:Gravity = new Gravity(x, y, GEast);
                state.add(gravity);
                state.gravitys.add(gravity);
            case "south":
                var gravity:Gravity = new Gravity(x, y, GSouth);
                state.add(gravity);
                state.gravitys.add(gravity);
                /*
                var bunker:FlxSprite = new FlxSprite(x, y, "assets/images/bunker.png");
                bunker.immovable = true;
                bunker.health = 1.0;
                state.bunkers.add(bunker);
                state.add(bunker);
                state.spawnPoints.add(new SpawnPoint(bunker, new FlxPoint(bunker.x+100, bunker.y+100)));
                */
		}
	}

	public function collideKillWithLevel(obj:FlxBasic, ?notifyCallback:FlxObject->FlxObject->Void, ?processCallback:FlxObject->FlxObject->Bool):Bool {
		if (collidableKillTileLayers != null) {
			for (map in collidableKillTileLayers) {
				// IMPORTANT: Always collide the map with objects, not the other way around. 
				//			  This prevents odd collision errors (collision separation code off by 1 px).
				return FlxG.overlap(map, obj, notifyCallback, processCallback != null ? processCallback : FlxObject.separate);
			}
		}
		return false;
	}
	
	public function collideWithLevel(obj:FlxBasic, ?notifyCallback:FlxObject->FlxObject->Void, ?processCallback:FlxObject->FlxObject->Bool):Bool {
		if (collidableTileLayers != null) {
			for (map in collidableTileLayers) {
				// IMPORTANT: Always collide the map with objects, not the other way around. 
				//			  This prevents odd collision errors (collision separation code off by 1 px).
				return FlxG.overlap(map, obj, notifyCallback, processCallback != null ? processCallback : FlxObject.separate);
			}
		}
		return false;
	}
}
