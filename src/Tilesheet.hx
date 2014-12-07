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
		tiles.push({x:0, y:0, w:TILE_SIZE, h:TILE_SIZE});	// Hidden loot room		0
		tiles.push({x:24, y:0, w:TILE_SIZE, h:TILE_SIZE});	// Visible loot room	1
		tiles.push({x:48, y:0, w:TILE_SIZE, h:TILE_SIZE});	// Locked loot room		2
		
		tiles.push({x:0, y:24, w:TILE_SIZE, h:TILE_SIZE});	// Hidden item room		3
		tiles.push({x:24, y:24, w:TILE_SIZE, h:TILE_SIZE});	// Visible item room	4
		tiles.push({x:48, y:24, w:TILE_SIZE, h:TILE_SIZE});	// Locked item room		5
		
		tiles.push({x:0, y:48, w:TILE_SIZE, h:TILE_SIZE});	// Hidden monster room	6
		tiles.push({x:24, y:48, w:TILE_SIZE, h:TILE_SIZE});	// Visible monster room	7
		tiles.push({x:48, y:48, w:TILE_SIZE, h:TILE_SIZE});	// Locked monster room	8
		
		tiles.push({x:72, y:0, w:TILE_SIZE, h:TILE_SIZE});	// Player				9
		
		tiles.push({x:96, y:0, w:TILE_SIZE, h:TILE_SIZE});	// Loot S				10
		tiles.push({x:96, y:24, w:TILE_SIZE, h:TILE_SIZE});	// Loot M				11
		tiles.push({x:96, y:48, w:TILE_SIZE, h:TILE_SIZE});	// Loot L				12
		tiles.push({x:96, y:72, w:TILE_SIZE, h:TILE_SIZE});	// No loot				13
		
		tiles.push({x:120, y:0, w:TILE_SIZE, h:TILE_SIZE});	// Monster				14
		tiles.push({x:120, y:24, w:TILE_SIZE, h:TILE_SIZE});// Monster dead			15
		
		tiles.push({x:144, y:0, w:TILE_SIZE, h:TILE_SIZE});	// Item					16
		tiles.push({x:144, y:24, w:TILE_SIZE, h:TILE_SIZE});// Item opened			17
		
		tiles.push({x:0, y:72, w:TILE_SIZE, h:TILE_SIZE});	// Hidden room			18
		
		tiles.push({x:0, y:96, w:144, h:36});	// Item select BG					19
		tiles.push({x:0, y:132, w:34, h:9});	// Arrows ON/ON						20
		tiles.push({x:0, y:141, w:34, h:9});	// Arrows OFF/ON					21
		tiles.push({x:0, y:150, w:34, h:9});	// Arrows ON/OFF					22
		
		tiles.push({x:34, y:132, w:97, h:18});	// Item desc health					23
		tiles.push({x:34, y:150, w:97, h:18});	// Item desc dmg					24
		tiles.push({x:34, y:168, w:97, h:18});	// Item desc map					25
		tiles.push({x:34, y:186, w:97, h:18});	// Item desc level up				26
		tiles.push({x:34, y:204, w:97, h:18});	// Item desc initiative				27
	}
	
	static public function draw (c:BitmapData, id:Int, x:Int = 0, y:Int = 0) {
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
