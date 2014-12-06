package ;

import Game;
import openfl.display.BitmapData;

/**
 * ...
 * @author 01101101
 */

class Level {
	
	public var data(default, null):BitmapData;
	
	var x:Int;
	var y:Int;
	var dx:Int;
	var dy:Int;
	var movingH:Bool;
	
	public function new () {
		data = new BitmapData(8, 8, false, 0xFFFFFFFF);
		data.setPixel(3, 4, 0x000000);
		data.setPixel(4, 4, 0x000000);
		
		x = -1;
		y = 0;
		dx = 1;
		dy = 1;
		movingH = true;
	}
	
	public function getNextRoom () :IntPoint {
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














