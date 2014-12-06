package ;

/**
 * ...
 * @author 01101101
 */

class AnimRoom extends AnimEntity {
	
	public function new () {
		super();
		
		anim = [0, 1];
		animFrameRate = animTick = 5;
		frame = 0;
	}
	
}