package ;

/**
 * ...
 * @author 01101101
 */

class Room extends Entity {
	
	public var type(default, null):ERoomType;
	public var visible:Bool;
	public var discovered:Bool;
	
	public function new (t:ERoomType) {
		super();
		
		type = t;
		visible = discovered = false;
		
		tID = 6;
	}
	
	public function show () {
		visible = true;
		
		tID = switch (type) {
			case EMPTY:		3;
			case LOOT:		4;
			case BATTLE:	5;
		}
	}
	
	public function discover () {
		if (!visible)	show();
		discovered = true;
		tID -= 3;
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