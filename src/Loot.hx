package ;

/**
 * ...
 * @author 01101101
 */

class Loot extends Entity {
	
	static var BASE_VALUE:Int = 10;
	
	public var value(default, null):Int;
	
	public function new (level:Int, luck:Int) {
		super();
		
		var r = Game.RND.random(10 - 2 * luck);//10, 8, 6
		// No loot
		if (r > 5) {
			value = 0;
			tID = 13;
		}
		// Loot S
		else if (r >= 3) {
			value = BASE_VALUE + 2 * luck;
			tID = 10;
		}
		// Loot M
		else if (r >= 1) {
			value = (BASE_VALUE + 2 * luck) * 2;
			tID = 11;
		}
		// Loot L
		else if (r == 0) {
			value = (BASE_VALUE + 2 * luck) * 4;
			tID = 12;
		}
		// Add small random amount
		if (value > 0) {
			value *= level + 1;
			value += Game.RND.random(BASE_VALUE) + 1;
		}
	}
	
	public function pickup () {
		value = 0;
		tID = 13;
	}
	
}
