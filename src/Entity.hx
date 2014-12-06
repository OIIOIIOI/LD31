package ;

/**
 * ...
 * @author 01101101
 */
class Entity {
	
	public var x:Int;
	public var y:Int;
	
	var tID:Int;
	public var tileID(get, null):Int;
	
	public function new () {
		x = y = 0;
		tID = -1;
	}
	
	public function update () {
		
	}
	
	function get_tileID () :Int {
		return tID;
	}
	
}
