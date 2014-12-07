package ;

/**
 * ...
 * @author 01101101
 */

class AnimEntity extends Entity {
	
	var anim:Array<Int>;
	var frame:Int;
	var animTick:Int;
	var animFrameRate:Int;
	var animCallback:Dynamic;
	
	public function new () {
		super();
		
		animCallback = null;
		anim = new Array();
		animFrameRate = animTick = 15;
		frame = -1;
	}
	
	override public function update ()  {
		super.update();
		
		// Update animation
		animTick--;
		if (animTick == 0) {
			frame++;
			if (frame >= anim.length) {
				frame = 0;
				if (animCallback != null)	animCallback();
			}
			animTick = animFrameRate;
		}
	}
	
	override function get_tileID () :Int {
		if (frame < 0 || frame >= anim.length)	return -1;
		return anim[frame];
	}
	
}
