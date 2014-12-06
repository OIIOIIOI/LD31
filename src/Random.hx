package ;

/**
 * ...
 * @author 01101101
 */

class Random {
	
	var seed:Float;
	
	public function new (seed:Int) {
		this.seed = ((seed < 0) ? -seed : seed) + 109;
	}
	
	inline function int () :Int {
		return Std.int(this.seed = (this.seed * 16807.0) % 2147483647.0) & 0x3FFFFFFF;
	}
	
	public inline function random (n:Int) :Int {
		return this.int() % n;
	}
	
	public inline function rand () :Float {
		return (this.int() % 10001) / 10001.0;
	}
	
	public inline function sign () :Int {
		return this.random(2) * 2 - 1;
	}
	
	public inline function range (min:Float, max:Float, ?sign:Bool = false) {
		return (min + this.rand() * (max - min)) * (sign ? this.sign() : 1);
	}
	
	public inline function iRange(min:Int, max:Int, ?sign:Bool = false) {
		return (min + this.random(max - min + 1)) * (sign ? this.sign() : 1);
	}
	
}
