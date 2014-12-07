package ;

/**
 * ...
 * @author 01101101
 */

class FightEntity extends AnimEntity {
	
	public var health:Int;
	public var dmg:Int;
	public var init:Int;
	
	public function new () {
		super();
		
		health = dmg = init = 1;
	}
	
	public function hit () { }
	public function die () { }
	
}
