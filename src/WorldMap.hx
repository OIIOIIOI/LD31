package ;

import Game;
import openfl.display.BitmapData;
import Room;

/**
 * ...
 * @author 01101101
 */

class WorldMap {
	
	public var data(default, null):BitmapData;
	
	var x:Int;
	var y:Int;
	var dx:Int;
	var dy:Int;
	var movingH:Bool;
	
	public var rooms(default, null):Array<Room>;
	
	public function new () {
		data = new BitmapData(8, 8, false, 0xFFFFFFFF);
		
		x = -1;
		y = 0;
		dx = 1;
		dy = 1;
		movingH = true;
		
		setupRooms();
	}
	
	function setupRooms () {
		rooms = new Array();
		var tmp = new Array();
		for (i in 0...21)	tmp.push(new Room(ERoomType.COINS));
		for (i in 0...17)	tmp.push(new Room(ERoomType.BATTLE));
		for (i in 0...24)	tmp.push(new Room(ERoomType.CHEST));
		// Always start with an empty room
		var r = new Room(ERoomType.COINS);
		var p = nextPosition();
		r.x = p.x * Tilesheet.TILE_SIZE;
		r.y = p.y * Tilesheet.TILE_SIZE;
		rooms.push(r);
		// Shuffle the rest
		while (tmp.length > 0) {
			r = tmp.splice(Game.RND.random(tmp.length), 1)[0];
			p = nextPosition();
			r.x = p.x * Tilesheet.TILE_SIZE;
			r.y = p.y * Tilesheet.TILE_SIZE;
			rooms.push(r);
		}
		// Always end with a battle room
		r = new Room(ERoomType.BATTLE);
		p = nextPosition();
		r.x = p.x * Tilesheet.TILE_SIZE;
		r.y = p.y * Tilesheet.TILE_SIZE;
		rooms.push(r);
		//trace(rooms.length);
	}
	
	public function nextPosition () :IntPoint {
		if (movingH)	x += dx;
		else			y += dy;
		// Check collision with borders or interface areas
		if (data.getPixel(x, y) != 0xFFFFFF) {
			if (movingH) {
				x -= dx;
				dx = -dx;
			} else {
				y -= dy;
				dy = -dy;
			}
			movingH = !movingH;
			//
			if (movingH)	x += dx;
			else			y += dy;
		}
		data.setPixel(x, y, 0);
		return {x:x, y:y};
	}
	
}
















