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
	
	public function displayEmpty () {
		clear();
		// BG
		Tilesheet.draw(bitmapData, 19);
		// Desc
		/*var tID = switch (t) {
			case EItemType.T_HEALTH:		23;
			case EItemType.T_WEAPON:		24;
			case EItemType.T_MAP:			25;
		}*/
		Tilesheet.draw(bitmapData, 32, 38, 3);
		// Space
		Tilesheet.draw(bitmapData, 28, 38, 22);
		// Action
		Tilesheet.draw(bitmapData, 29, 71, 24);
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
	
}










