package ;

/**
 * ...
 * @author 01101101
 */

class FightEntity extends Entity {
	
	public var health:Int;
	public var dmg:Int;
	public var init:Int;
	
	public function new () {
		super();
		
		health = dmg = init = 1;
	}
	
	public function die () { }
	
}
