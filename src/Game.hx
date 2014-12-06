package ;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.Lib;
import openfl.ui.Keyboard;
import Room;

/**
 * ...
 * @author 01101101
 */

class Game extends Sprite {
	
	static public var TAP:Point = new Point();
	static public var TAR:Rectangle = new Rectangle();
	static public var SCALE:Int = 3;
	static public var RND:Random = new Random(123454);
	
	var canvasData:BitmapData;
	var canvas:Bitmap;
	
	var entities:Array<Entity>;
	
	var level:Level;
	var rooms:Array<Room>;
	
	public function new () {
		super();
		
		KeyboardMan.init();
		Tilesheet.init();
		
		canvasData = new BitmapData(200, 200, false, 0xFF808080);
		
		canvas = new Bitmap(canvasData);
		canvas.scaleX = canvas.scaleY = SCALE;
		addChild(canvas);
		
		entities = [];
		
		setupRooms();
		
		level = new Level();
		var p = level.getNextRoom();
		//var b = new Bitmap(level.data);
		//b.scaleX = b.scaleY = 16;
		//addChild(b);
		
		var r = rooms.shift();
		r.x = p.x * Tilesheet.TILE_SIZE;
		r.y = p.y * Tilesheet.TILE_SIZE;
		entities.push(r);
		
		addEventListener(Event.ENTER_FRAME, update);
	}
	
	function setupRooms () {
		rooms = new Array();
		var tmp = new Array();
		for (i in 0...23)	tmp.push(new Room(ERoomType.EMPTY));
		for (i in 0...16)	tmp.push(new Room(ERoomType.BATTLE));
		for (i in 0...21)	tmp.push(new Room(ERoomType.LOOT));
		// Always start with an empty room
		rooms.push(new Room(ERoomType.EMPTY));
		// Shuffle the rest
		while (tmp.length > 0) {
			rooms.push(tmp.splice(RND.random(tmp.length), 1)[0]);
		}
		// Always end with a battle room
		rooms.push(new Room(ERoomType.BATTLE));
		//trace(rooms.length);
	}
	
	function update (e:Event) {
		// Player input
		if (KeyboardMan.INST.getState(Keyboard.SPACE).justPressed && rooms.length > 0) {
			var p = level.getNextRoom();
			var r = rooms.shift();
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








