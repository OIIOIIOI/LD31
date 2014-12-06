package ;

import openfl.Assets;
import openfl.display.BitmapData;

/**
 * ...
 * @author 01101101
 */

class Tilesheet {
	
	static public var TILE_SIZE:Int = 25;
	
	static var data:BitmapData;
	static var tiles:Array<Tile>;
	
	static public function init () {
		data = Assets.getBitmapData("img/tiles.png");
		
		tiles = [];
		tiles.push({x:0, y:0, w:TILE_SIZE, h:TILE_SIZE});	// EMPTY discovered
		tiles.push({x:25, y:0, w:TILE_SIZE, h:TILE_SIZE});	// LOOT discovered
		tiles.push({x:50, y:0, w:TILE_SIZE, h:TILE_SIZE});	// BATTLE discovered
		tiles.push({x:0, y:25, w:TILE_SIZE, h:TILE_SIZE});	// EMPTY visible
		tiles.push({x:25, y:25, w:TILE_SIZE, h:TILE_SIZE});	// LOOT visible
		tiles.push({x:50, y:25, w:TILE_SIZE, h:TILE_SIZE});	// BATTLE visible
		tiles.push({x:75, y:25, w:TILE_SIZE, h:TILE_SIZE});	// Invisible room
		tiles.push({x:75, y:0, w:TILE_SIZE, h:TILE_SIZE});	// Player
	}
	
	static public function draw (c:BitmapData, id:Int, x:Int, y:Int) {
		if (id < 0 || id >= tiles.length)	return false;
		
		Game.TAR.x = tiles[id].x;
		Game.TAR.y = tiles[id].y;
		Game.TAR.width = tiles[id].w;
		Game.TAR.height = tiles[id].h;
		
		Game.TAP.x = x;
		Game.TAP.y = y;
		
		c.copyPixels(data, Game.TAR, Game.TAP);
		
		return true;
	}
	
}

typedef Tile = { x:Int, y:Int, w:Int, h:Int }
