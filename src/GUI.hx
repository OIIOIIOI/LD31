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
		
		bitmapData = new BitmapData(144, 72, false, 0xFF000033);
	}
	
	public function clear (top:Bool = true, bottom:Bool = false) {
		Game.TAR.x = 0;
		Game.TAR.width = 144;
		Game.TAR.height = 36;
		if (top) {
			Game.TAR.y = 0;
			bitmapData.fillRect(Game.TAR, 0xFF006633);
		}
		if (bottom) {
			Game.TAR.y = 36;
			bitmapData.fillRect(Game.TAR, 0xFF006633);
		}
	}
	
	public function displayItem (t:EItemType, isFirst:Bool, isLast:Bool) {
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
	
	public function displayFight () {
		clear();
		Tilesheet.draw(bitmapData, 19);// BG
		Tilesheet.draw(bitmapData, 51, 38-35, 3);// Desc
		Tilesheet.draw(bitmapData, 28, 38-35, 22);// Space
		Tilesheet.draw(bitmapData, 52, 71-35, 24);// Action
	}
	
	public function displayEmpty () {
		clear();
		Tilesheet.draw(bitmapData, 19);// BG
		Tilesheet.draw(bitmapData, 32, 38-35, 3);// Desc
		Tilesheet.draw(bitmapData, 28, 38-35, 22);// Space
		Tilesheet.draw(bitmapData, 29, 71-35, 24);// Action
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
		Tilesheet.draw(bitmapData, tID, 38-35, 3);
		// Space
		Tilesheet.draw(bitmapData, 28, 38-35, 22);
		// Action
		Tilesheet.draw(bitmapData, 31, 71-35, 24);
		// Number
		displayNumber(coins, 62-35, 11, false);
	}
	
	public function displayStats (health:Int, dmg:Int, init:Int, loot:Int) {
		clear(false, true);
		// BG
		Tilesheet.draw(bitmapData, 60, 0, 36);
		// Number
		displayNumber(health, 47, 41);
		displayNumber(dmg, 47, 57);
		displayNumber(loot, 101, 41, false, true);
		displayNumber(init, 101, 57, false, true);
	}
	
	public function displayStart () {
		clear();
		Tilesheet.draw(bitmapData, 19);// BG
		Tilesheet.draw(bitmapData, 61, 38, 3);// Desc
		Tilesheet.draw(bitmapData, 28, 38, 22);// Space
		Tilesheet.draw(bitmapData, 64, 71, 24);// Action
	}
	
	public function displayEnd () {
		clear();
		Tilesheet.draw(bitmapData, 19);// BG
		Tilesheet.draw(bitmapData, 62, 38, 3);// Desc
		Tilesheet.draw(bitmapData, 28, 38, 22);// Space
		Tilesheet.draw(bitmapData, 65, 71, 24);// Action
	}
	
	public function displayWinFight () {
		clear();
		Tilesheet.draw(bitmapData, 19);// BG
		Tilesheet.draw(bitmapData, 66, 38-35, 3);// Desc
		Tilesheet.draw(bitmapData, 28, 38-35, 22);// Space
		Tilesheet.draw(bitmapData, 29, 71-35, 24);// Action
	}
	
	public function displayGameOver () {
		clear();
		Tilesheet.draw(bitmapData, 19);// BG
		Tilesheet.draw(bitmapData, 63, 38, 3);// Desc
		Tilesheet.draw(bitmapData, 28, 38, 22);// Space
		Tilesheet.draw(bitmapData, 65, 71, 24);// Action
	}
	
	function displayNumber (n:Int, xx:Int, yy:Int, center:Bool = true, right:Bool = false) {
		var s = Std.string(n);
		var a = s.split("");
		// Calculate width
		var w = 5 * a.length;
		if (center)		xx -= Std.int(w / 2);
		else if (right)	xx -= w;
		xx--;
		// Draw
		for (i in a) {
			Tilesheet.draw(bitmapData, 41 + Std.parseInt(i), xx, yy);
			xx += 5;
		}
		
	}
	
}










