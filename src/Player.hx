package ;

/**
 * ...
 * @author 01101101
 */

class Player extends Entity {
	
	public var health(default, null):Int;
	public var dmg(default, null):Int;
	
	public function new () {
		super();
		
		tID = 7;
		
		health = 3;
		dmg = 1;
	}
	
}





