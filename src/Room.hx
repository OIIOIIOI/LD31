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
		tID = switch (state) {
			case ERoomState.HIDDEN:		0;
			case ERoomState.VISIBLE:	1;
			case ERoomState.LOCKED:		2;
		}
	}
	
}

enum ERoomState {
	HIDDEN;
	VISIBLE;
	LOCKED;
}