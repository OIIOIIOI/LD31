package ;

/**
 * ...
 * @author 01101101
 */

class Monster extends Entity {
	
	public var beaten(default, null):Bool;
	
	public function new () {
		super();
		
		tID = 7;
	}
	
	public function kill () {
		beaten = true;
		tID = 8;
	}
	
}
