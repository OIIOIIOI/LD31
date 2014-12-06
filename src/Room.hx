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
			case ERoomType.COINS:		3;
			case ERoomType.CHEST:		4;
			case ERoomType.BATTLE:	5;
		}
	}
	
	public function discover () {
		if (!visible)	show();
		discovered = true;
		tID -= 3;
	}
	
	public function clear () {
		type = ERoomType.COINS;
		tID = 0;
	}
	
	public function deactivate () {
		tID = 8;
	}
	
	public function toString () {
		return Std.string(type);
	}
	
}

enum ERoomType {
	COINS;
	BATTLE;
	CHEST;
}