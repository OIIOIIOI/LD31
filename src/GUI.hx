package ;

import Game;
import Item;
import openfl.display.Bitmap;
import openfl.display.BitmapData;

/**
 * ...
 * @author 01101101
 */

class GUI extends Bitmap {
	
	public function new () {
		super();
		
		scaleX = scaleY = 2;
		
		bitmapData = new BitmapData(144, 36, false, 0xFF000033);
	}
	
	public function clear () {
		bitmapData.fillRect(bitmapData.rect, 0xFF006633);
	}
	
	public function displayItem (t:EItemType, isFirst:Bool, isLast:Bool) {
		clear();
		// BG
		Tilesheet.draw(bitmapData, 19);
		// Desc
		var tID = switch (t) {
			case EItemType.T_HEALTH:		23;
			case EItemType.T_WEAPON:		24;
			case EItemType.T_MAP:			25;
			case EItemType.T_LEVELUP:		26;
			case EItemType.T_INITIATIVE:	27;
		}
		Tilesheet.draw(bitmapData, tID, 38, 3);
		// Image
		Tilesheet.draw(bitmapData, 36, 3, 3);
		// Arrows
		if (isFirst)		tID = 21;
		else if (isLast)	tID = 22;
		else				tID = 20;
		Tilesheet.draw(bitmapData, tID, 1, 23);
		// Space
		Tilesheet.draw(bitmapData, 28, 38, 22);
		// Action
		Tilesheet.draw(bitmapData, 30, 71, 24);
	}
	
	public function displayEmpty (stat:Int, value:Int) {
		clear();
		// BG
		Tilesheet.draw(bitmapData, 19);
		// Desc
		Tilesheet.draw(bitmapData, 32, 38, 3);
		// Space
		Tilesheet.draw(bitmapData, 28, 38, 22);
		// Action
		Tilesheet.draw(bitmapData, 29, 71, 24);
		// Stat
		if (stat == 0)		Tilesheet.draw(bitmapData, 37, 11, 13);
		else if (stat == 1)	Tilesheet.draw(bitmapData, 39, 11, 13);
		else if (stat == 2)	Tilesheet.draw(bitmapData, 38, 11, 13);
		else				Tilesheet.draw(bitmapData, 40, 11, 13);
		// Arrows
		Tilesheet.draw(bitmapData, 20, 1, 23);
		// Number
		displayNumber(value, 18, 2);
	}
	
	public function displayLoot (tier:Int, coins:Int) {
		clear();
		// BG
		Tilesheet.draw(bitmapData, 19);
		// Desc
		var tID = switch (tier) {
			case 1:		34;
			case 2:		35;
			default:	33;
		}
		Tilesheet.draw(bitmapData, tID, 38, 3);
		// Space
		Tilesheet.draw(bitmapData, 28, 38, 22);
		// Action
		Tilesheet.draw(bitmapData, 31, 71, 24);
	}
	
	function displayNumber (n:Int, xx:Int, yy:Int, center:Bool = true) {
		var s = Std.string(n);
		var a = s.split("");
		// Calculate width
		var w = 5 * a.length;
		if (center)	xx -= Std.int(w / 2);
		xx--;
		// Draw
		for (i in a) {
			Tilesheet.draw(bitmapData, 41 + Std.parseInt(i), xx, yy);
			xx += 5;
		}
		
	}
	
}










