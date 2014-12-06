package ;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.Lib;
import openfl.ui.Keyboard;

/**
 * ...
 * @author 01101101
 */

class Game extends Sprite {
	
	static public var TAP:Point = new Point();
	static public var TAR:Rectangle = new Rectangle();
	static public var SCALE:Int = 3;
	
	var canvasData:BitmapData;
	var canvas:Bitmap;
	
	var entities:Array<Entity>;
	
	var level:Level;
	
	public function new () {
		super();
		
		KeyboardMan.init();
		Tilesheet.init();
		
		canvasData = new BitmapData(200, 200, false, 0xFF808080);
		
		canvas = new Bitmap(canvasData);
		canvas.scaleX = canvas.scaleY = SCALE;
		addChild(canvas);
		
		entities = [];
		
		level = new Level();
		var p = level.getNextRoom();
		//var b = new Bitmap(level.data);
		//b.scaleX = b.scaleY = 16;
		//addChild(b);
		
		var r = new Room();
		r.x = p.x * Tilesheet.TILE_SIZE;
		r.y = p.y * Tilesheet.TILE_SIZE;
		entities.push(r);
		
		addEventListener(Event.ENTER_FRAME, update);
	}
	
	function update (e:Event) {
		// Player input
		if (KeyboardMan.INST.getState(Keyboard.SPACE).justPressed) {
			var p = level.getNextRoom();
			var r = new Room();
			r.x = p.x * Tilesheet.TILE_SIZE;
			r.y = p.y * Tilesheet.TILE_SIZE;
			entities.push(r);
		}
		// Update entities
		for (e in entities) {
			e.update();
		}
		// Render
		render();
		// Update controls
		KeyboardMan.INST.update();
	}
	
	function render () {
		canvasData.fillRect(canvasData.rect, 0xFF808080);
		for (e in entities) {
			Tilesheet.draw(canvasData, e.tileID, e.x, e.y);
		}
	}
	
}

typedef IntPoint = {x:Int, y:Int}








