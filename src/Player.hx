package ;

/**
 * ...
 * @author 01101101
 */

class Player extends FightEntity {
	
	public function new () {
		super();
		
		health = 3;
		dmg = 1;
		init = 1;
		
		anim = [9, 53];
		animFrameRate = animTick = 10;
		frame = 0;
	}
	
	override public function hit () {
		anim = [57, 58];
		frame = 0;
		animTick = animFrameRate;
		
		if (health > 0) {
			SoundMan.play(SoundMan.SND_HIT);
			animCallback = resume;
		}
		else {
			SoundMan.play(SoundMan.SND_DEATH_PLAYER);
			animCallback = die;
		}
	}
	
	function resume () {
		anim = [9, 53];
		frame = 0;
		animTick = animFrameRate;
		
		animCallback = null;
	}
	
	override public function die ()  {
		super.die();
		
		animCallback = null;
		anim = [59];
		animFrameRate = animTick = 999;
		frame = 0;
	}
	
}





