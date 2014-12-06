package ;

import flash.errors.Error;
import flash.events.KeyboardEvent;
import flash.Lib;
import flash.ui.Keyboard;

/**
 * ...
 * @author 01101101
 */

class KeyboardMan {
	
	public static var INST:KeyboardMan;
	
	var keys:Map<Int, KeyState>;
	
	public static function init () {
		if (INST != null)	throw new Error("KeyboardMan already instanciated");
		INST = new KeyboardMan();
	}
	
	public function new () {
		registerKeys();
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
	}
	
	function registerKeys () {
		if (keys != null)	return;
		keys = new Map<Int, KeyState>();
		keys.set(Keyboard.UP,		{ isDown:false, justPressed:false, justReleased:false } );
		keys.set(Keyboard.RIGHT,	{ isDown:false, justPressed:false, justReleased:false } );
		keys.set(Keyboard.DOWN,		{ isDown:false, justPressed:false, justReleased:false } );
		keys.set(Keyboard.LEFT,		{ isDown:false, justPressed:false, justReleased:false } );
		keys.set(Keyboard.SPACE,	{ isDown:false, justPressed:false, justReleased:false } );
		keys.set(Keyboard.ENTER,	{ isDown:false, justPressed:false, justReleased:false } );
	}
	
	function keyDownHandler (e:KeyboardEvent) {
		if (keys.exists(e.keyCode)) {
			var ks = keys.get(e.keyCode);
			if (!ks.isDown)	ks.justPressed = true;
			ks.isDown = true;
			keys.set(e.keyCode, ks);
		}
	}
	
	function keyUpHandler (e:KeyboardEvent) {
		if (keys.exists(e.keyCode)) {
			var ks = keys.get(e.keyCode);
			if (ks.isDown)	ks.justReleased = true;
			ks.isDown = false;
			keys.set(e.keyCode, ks);
		}
	}
	
	public function update () {
		var ks:KeyState;
		for (k in keys.keys()) {
			ks = keys.get(k);
			if (ks.justPressed)		ks.justPressed = false;
			if (ks.justReleased)	ks.justReleased = false;
			keys.set(k, ks);
		}
	}
	
	public function getState (k:Int) :KeyState {
		if (!keys.exists(k))	return null;
		return keys.get(k);
	}
	
	public function resetState (?k:Int) {
		if (k != null && keys.exists(k)) {
			keys.set(k, { isDown:false, justPressed:false, justReleased:false } );
		} else if (k == null) {
			for (k in keys.keys()) {
				keys.set(k, { isDown:false, justPressed:false, justReleased:false } );
			}
		}
	}
	
	public function cancelJustPressed (k:Int) {
		if (!keys.exists(k))	return;
		var ks = keys.get(k);
		ks.justPressed = false;
		keys.set(k, ks);
	}
	
}

typedef KeyState = {
	isDown:Bool,
	justPressed:Bool,
	justReleased:Bool
}
