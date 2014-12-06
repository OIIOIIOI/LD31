package ;

import openfl.Assets;
import openfl.display.BitmapData;

/**
 * ...
 * @author 01101101
 */

class Tilesheet {
	
	static public var TILE_SIZE:Int = 24;
	
	static var data:BitmapData;
	static var tiles:Array<Tile>;
	
	static public function init () {
		data = Assets.getBitmapData("img/tiles.png");
		
		tiles = [];
		tiles.push({x:0, y:0, w:TILE_SIZE, h:TILE_SIZE});	// Hidden room
		tiles.push({x:24, y:0, w:TILE_SIZE, h:TILE_SIZE});	// Visible room
		tiles.push({x:48, y:0, w:TILE_SIZE, h:TILE_SIZE});	// Locked room
		tiles.push({x:48, y:24, w:TILE_SIZE, h:TILE_SIZE});	// Player
		tiles.push({x:72, y:0, w:TILE_SIZE, h:TILE_SIZE});	// Treasure
		tiles.push({x:96, y:0, w:TILE_SIZE, h:TILE_SIZE});	// Heart
		tiles.push({x:120, y:0, w:TILE_SIZE, h:TILE_SIZE});	// Sword
		tiles.push({x:72, y:24, w:TILE_SIZE, h:TILE_SIZE});	// Monster
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
