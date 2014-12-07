package ;

/**
 * ...
 * @author 01101101
 */

class Item extends Entity {
	
	public function new () {
		super();
		
		tID = 16;
	}
	
	public function open () {
		tID = 17;
	}
	
}

enum EItemType {
	T_HEALTH;
	T_WEAPON;
	T_LEVELUP;
	T_INITIATIVE;
	T_MAP;
}