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
	
	public function updateTID (force:Bool = false) {
		switch (state) {
			case ERoomState.S_HIDDEN:	tID = 0;
			case ERoomState.S_VISIBLE:	tID = 1;
		}
		if (state != S_HIDDEN) {
			switch (type) {
				case ERoomType.T_ITEM:		tID = 4;
				case ERoomType.T_MONSTER:	tID = 7;
				case ERoomType.T_START:		tID = 2;
				case ERoomType.T_END:		tID = 5;
				default:
			}
		}
		else if (force) {
			switch (type) {
				case ERoomType.T_ITEM:		tID = 3;
				case ERoomType.T_MONSTER:	tID = 6;
				case ERoomType.T_END:		tID = 18;
				default:
			}
		}
	}
	
}

enum ERoomState {
	S_HIDDEN;
	S_VISIBLE;
}

enum ERoomType {
	T_MONSTER;
	T_ITEM;
	T_LOOT;
	T_START;
	T_END;
}





