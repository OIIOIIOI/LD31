package ;

/**
 * ...
 * @author 01101101
 */

class Room extends Entity {
	
	public var state(default, null):ERoomState;
	public var content:Entity;
	
	public function new () {
		super();
		
		state = ERoomState.HIDDEN;
		updateTID();
	}
	
	public function discover () {
		state = ERoomState.VISIBLE;
		updateTID();
	}
	
	public function lock () {
		state = ERoomState.LOCKED;
		updateTID();
	}
	
	public function updateTID () {
		switch (state) {
			case ERoomState.HIDDEN:
				tID = 0;
			case ERoomState.VISIBLE:
				tID = 1;
			case ERoomState.LOCKED:
				var r = Std.random(3);
				if (r == 0)			tID = 2;
				else if (r == 1)	tID = 9;
				else				tID = 10;
		}
	}
	
}

enum ERoomState {
	HIDDEN;
	VISIBLE;
	LOCKED;
}