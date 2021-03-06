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
	
	var animArrows:Bool;
	var animTID:Int;
	var animTick:Int;
	var animDuration:Int;
	
	public function new () {
		super();
		
		scaleX = scaleY = 2;
		
		bitmapData = new BitmapData(144, 72, false, 0xFF090a11);
		
		animArrows = false;
	}
	
	public function clear (top:Bool = true, bottom:Bool = false) {
		Game.TAR.x = 0;
		Game.TAR.width = 144;
		Game.TAR.height = 36;
		if (top) {
			Game.TAR.y = 0;
			bitmapData.fillRect(Game.TAR, 0xFF090a11);
			animArrows = false;
		}
		if (bottom) {
			Game.TAR.y = 36;
			bitmapData.fillRect(Game.TAR, 0xFF090a11);
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
		tID = switch (t) {
			case EItemType.T_HEALTH:		70;
			case EItemType.T_WEAPON:		73;
			case EItemType.T_MAP:			72;
			case EItemType.T_LEVELUP:		71;
			case EItemType.T_INITIATIVE:	74;
		}
		Tilesheet.draw(bitmapData, tID, 3, 3);
		// Arrows
		if (isFirst)		tID = 21;
		else if (isLast)	tID = 22;
		else				tID = 20;
		Tilesheet.draw(bitmapData, tID, 1, 23);
		animArrows = true;
		animDuration = animTick = 10;
		animTID = tID;
		// Space
		Tilesheet.draw(bitmapData, 28, 38, 22);
		// Action
		Tilesheet.draw(bitmapData, 30, 71, 24);
	}
	
	public function displayFight (full:Bool = true) {
		clear();
		Tilesheet.draw(bitmapData, 19);// BG
		Tilesheet.draw(bitmapData, 51, 38, 3);// Desc
		if (full) {
			Tilesheet.draw(bitmapData, 28, 38, 22);// Space
			Tilesheet.draw(bitmapData, 52, 71, 24);// Action
		}
	}
	
	public function displayEmpty () {
		clear();
		Tilesheet.draw(bitmapData, 19);// BG
		Tilesheet.draw(bitmapData, 32, 38, 3);// Desc
		Tilesheet.draw(bitmapData, 28, 38, 22);// Space
		Tilesheet.draw(bitmapData, 29, 71, 24);// Action
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
		// Number
		displayNumber(coins, 62, 11, false);
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
		//Tilesheet.draw(bitmapData, 28, 38, 22);// Space
		//Tilesheet.draw(bitmapData, 65, 71, 24);// Action
	}
	
	public function displayWinFight () {
		clear();
		Tilesheet.draw(bitmapData, 19);// BG
		Tilesheet.draw(bitmapData, 66, 38, 3);// Desc
		Tilesheet.draw(bitmapData, 28, 38, 22);// Space
		Tilesheet.draw(bitmapData, 29, 71, 24);// Action
	}
	
	public function displayGameOver () {
		clear();
		Tilesheet.draw(bitmapData, 19);// BG
		Tilesheet.draw(bitmapData, 63, 38, 3);// Desc
		//Tilesheet.draw(bitmapData, 28, 38, 22);// Space
		//Tilesheet.draw(bitmapData, 65, 71, 24);// Action
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
	
	public function update () {
		if (animArrows) {
			if (animTick > 0) {
				animTick--;
				if (animTick == 0) {
					if (animTID == 20)		animTID = 67;
					else if (animTID == 21)	animTID = 68;
					else if (animTID == 22)	animTID = 69;
					else if (animTID == 67)	animTID = 20;
					else if (animTID == 68)	animTID = 21;
					else if (animTID == 69)	animTID = 22;
					//
					Tilesheet.draw(bitmapData, animTID, 1, 23);
					animTick = animDuration;
				}
			}
		}
	}
	
}










