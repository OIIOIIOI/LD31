package ;

import Game;
import openfl.display.BitmapData;
import Room;

/**
 * ...
 * @author 01101101
 */

class WorldMap {
	
	public var rooms(default, null):Array<Room>;
	
	public function new () {
		// Final array
		rooms = [];
		// Temp array
		var tmp:Array<Room>;
		
		// Manually set the first room
		rooms.push(new Room(ERoomType.T_LOOT));
		// Tier 1
		tmp = [];
		tmp.push(new Room(ERoomType.T_ITEM));
		tmp.push(new Room(ERoomType.T_ITEM));
		tmp.push(new Room(ERoomType.T_LOOT));
		tmp.push(new Room(ERoomType.T_LOOT));
		tmp.push(new Room(ERoomType.T_LOOT));
		shuffleAndConcat(tmp);
		// Tier 2
		tmp = [];
		tmp.push(new Room(ERoomType.T_MONSTER));
		tmp.push(new Room(ERoomType.T_ITEM));
		tmp.push(new Room(ERoomType.T_ITEM));
		tmp.push(new Room(ERoomType.T_LOOT));
		tmp.push(new Room(ERoomType.T_LOOT));
		tmp.push(new Room(ERoomType.T_LOOT));
		shuffleAndConcat(tmp);
		// Tier 3
		tmp = [];
		tmp.push(new Room(ERoomType.T_MONSTER));
		tmp.push(new Room(ERoomType.T_MONSTER));
		tmp.push(new Room(ERoomType.T_ITEM));
		tmp.push(new Room(ERoomType.T_ITEM));
		tmp.push(new Room(ERoomType.T_LOOT));
		tmp.push(new Room(ERoomType.T_LOOT));
		shuffleAndConcat(tmp);
		// Tier 4
		tmp = [];
		tmp.push(new Room(ERoomType.T_MONSTER));
		tmp.push(new Room(ERoomType.T_MONSTER));
		tmp.push(new Room(ERoomType.T_ITEM));
		tmp.push(new Room(ERoomType.T_LOOT));
		tmp.push(new Room(ERoomType.T_LOOT));
		tmp.push(new Room(ERoomType.T_LOOT));
		shuffleAndConcat(tmp);
		// Tier 5
		tmp = [];
		tmp.push(new Room(ERoomType.T_MONSTER));
		tmp.push(new Room(ERoomType.T_MONSTER));
		tmp.push(new Room(ERoomType.T_MONSTER));
		tmp.push(new Room(ERoomType.T_ITEM));
		tmp.push(new Room(ERoomType.T_LOOT));
		tmp.push(new Room(ERoomType.T_LOOT));
		shuffleAndConcat(tmp);
		// Tier 6
		tmp = [];
		tmp.push(new Room(ERoomType.T_MONSTER));
		tmp.push(new Room(ERoomType.T_MONSTER));
		tmp.push(new Room(ERoomType.T_MONSTER));
		tmp.push(new Room(ERoomType.T_ITEM));
		tmp.push(new Room(ERoomType.T_LOOT));
		shuffleAndConcat(tmp);
		// Manually set the last room
		rooms.push(new Room(ERoomType.T_MONSTER));
	}
	
	function shuffleAndConcat (a:Array<Room>) {
		while (a.length > 0) {
			var r = a.splice(Game.RND.random(a.length), 1)[0];
			rooms.push(r);
		}
	}
	
}
















