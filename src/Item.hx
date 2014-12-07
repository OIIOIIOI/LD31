package ;

/**
 * ...
 * @author 01101101
 */

class Item extends Entity {
	
	public var type:EItemType;
	
	public function new () {
		super();
		
		type = EItemType.T_LEVELUP;
		
		tID = 15;
	}
	
	public function open () {
		trace("TODO: change tID");
	}
	
}

enum EItemType {
	T_HEALTH;
	T_WEAPON;
	T_LEVELUP;
}