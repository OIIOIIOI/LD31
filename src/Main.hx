package ;

import flash.Lib;

/**
 * ...
 * @author 01101101
 */

class Main {
	
	public static function main () {
		// static entry point
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Game());
	}
}
