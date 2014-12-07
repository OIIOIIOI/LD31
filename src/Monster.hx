package ;

/**
 * ...
 * @author 01101101
 */

class Monster extends FightEntity {
	
	public function new (level:Int) {
		super();
		
		health = 1;
		dmg = 1;
		init = 0;
		
		var pts = level + 1;
		while (pts > 0) {
			var r = Game.RND.random(3);
			if (r == 0)			init++;
			else if (r == 1)	dmg++;
			else				health++;
			pts--;
		}
		
		anim = [14, 15];
		animFrameRate = animTick = 7;
		frame = 0;
	}
	
	override public function hit () {
		anim = [55, 56];
		frame = 0;
		animTick = animFrameRate;
		
		if (health > 0)	animCallback = resume;
		else			animCallback = die;
	}
	
	function resume () {
		anim = [14, 15];
		frame = 0;
		animTick = animFrameRate;
		
		animCallback = null;
	}
	
	override public function die ()  {
		super.die();
		
		animCallback = null;
		anim = [54];
		animFrameRate = animTick = 999;
		frame = 0;
	}
	
}
