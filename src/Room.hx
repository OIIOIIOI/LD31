package ;

/**
 * ...
 * @author 01101101
 */

class Room extends Entity {
	
	public var state(default, null):ERoomState;
	public var type(default, null):ERoomType;
	
	public var content:Entity;
	
	public function new (t:ERoomType) {
		super();
		
		type = t;
		
		state = ERoomState.S_HIDDEN;
		updateTID();
	}
	
	public function discover () {
		state = ERoomState.S_VISIBLE;
		updateTID();
	}
	
	public function lock () {
		state = ERoomState.S_LOCKED;
		updateTID();
	}
	
	public function updateTID (force:Bool = false) {
		switch (state) {
			case ERoomState.S_HIDDEN:	tID = 18;
			case ERoomState.S_VISIBLE:	tID = 1;
			case ERoomState.S_LOCKED:	tID = 2;
		}
		if (state != S_HIDDEN) {
			switch (type) {
				case ERoomType.T_LOOT:		tID += 0;
				case ERoomType.T_ITEM:		tID += 3;
				case ERoomType.T_MONSTER:	tID += 6;
			}
		}
		else if (force) {
			switch (type) {
				case ERoomType.T_LOOT:		tID = 0;
				case ERoomType.T_ITEM:		tID = 3;
				case ERoomType.T_MONSTER:	tID = 6;
			}
		}
	}
	
}

enum ERoomState {
	S_HIDDEN;
	S_VISIBLE;
	S_LOCKED;
}

enum ERoomType {
	T_MONSTER;
	T_ITEM;
	T_LOOT;
}





