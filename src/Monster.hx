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
		
		tID = 14;
	}
	
	override public function die ()  {
		super.die();
		
		tID = 15;
	}
	
}
