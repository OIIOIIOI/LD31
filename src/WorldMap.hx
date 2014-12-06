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
		// Final array
		rooms = new Array();
		
		// Content list
		var contents:Array<Entity> = [];
		for (i in 0...8)	contents.push(new Treasure());
		for (i in 0...8)	contents.push(new Heart());
		for (i in 0...8)	contents.push(new Sword());
		for (i in 0...8)	contents.push(new Monster());
		
		// Create the rooms
		var tmp = new Array();
		for (i in 0...(data.width * data.height)) {
			var r = new Room();
			if (contents.length > 0)	r.content = contents.pop();
			tmp.push(r);
		}
		
		// Shuffle the rooms
		while (tmp.length > 0) {
			var r = tmp.splice(Game.RND.random(tmp.length), 1)[0];
			var p = nextPosition();
			r.x = p.x * Tilesheet.TILE_SIZE;
			r.y = p.y * Tilesheet.TILE_SIZE;
			rooms.push(r);
		}
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
















