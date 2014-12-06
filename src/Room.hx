package ;

/**
 * ...
 * @author 01101101
 */

class Room extends Entity {
	
	public var type(default, null):ERoomType;
	
	public function new (t:ERoomType) {
		super();
		
		type = t;
		tID = switch (type) {
			case EMPTY:		0;
			case LOOT:		1;
			case BATTLE:	2;
		}
	}
	
	public function toString () {
		return Std.string(type);
	}
	
}

enum ERoomType {
	EMPTY;
	BATTLE;
	LOOT;
}