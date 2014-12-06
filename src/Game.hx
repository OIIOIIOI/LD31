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
	static public var RND:Random = new Random(123455);
	
	var canvasData:BitmapData;
	var canvas:Bitmap;
	
	var entities:Array<Entity>;
	var level:Level;
	var player:Player;
	
	var activeRoom:Int;
	
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
		
		activeRoom = 0;
		level.rooms[activeRoom].discover();
		level.rooms[activeRoom + 1].show();
		
		for (r in level.rooms)	entities.push(r);
		
		player = new Player();
		player.x = level.rooms[activeRoom].x;
		player.y = level.rooms[activeRoom].y;
		entities.push(player);
		
		addEventListener(Event.ENTER_FRAME, update);
	}
	
	function update (e:Event) {
		// Player input
		if (KeyboardMan.INST.getState(Keyboard.RIGHT).justPressed) {
			if (!isInLastRoom() && level.rooms[activeRoom + 1].x > level.rooms[activeRoom].x)		goToNextRoom();
			else if (!isInFirstRoom() && level.rooms[activeRoom - 1].x > level.rooms[activeRoom].x)	goToPreviousRoom();
		}
		else if (KeyboardMan.INST.getState(Keyboard.LEFT).justPressed) {
			if (!isInLastRoom() && level.rooms[activeRoom + 1].x < level.rooms[activeRoom].x)		goToNextRoom();
			else if (!isInFirstRoom() && level.rooms[activeRoom - 1].x < level.rooms[activeRoom].x)	goToPreviousRoom();
		}
		else if (KeyboardMan.INST.getState(Keyboard.UP).justPressed) {
			if (!isInLastRoom() && level.rooms[activeRoom + 1].y < level.rooms[activeRoom].y)		goToNextRoom();
			else if (!isInFirstRoom() && level.rooms[activeRoom - 1].y < level.rooms[activeRoom].y)	goToPreviousRoom();
		}
		else if (KeyboardMan.INST.getState(Keyboard.DOWN).justPressed) {
			if (!isInLastRoom() && level.rooms[activeRoom + 1].y > level.rooms[activeRoom].y)		goToNextRoom();
			else if (!isInFirstRoom() && level.rooms[activeRoom - 1].y > level.rooms[activeRoom].y)	goToPreviousRoom();
		}
		// Move player
		player.x = level.rooms[activeRoom].x;
		player.y = level.rooms[activeRoom].y;
		// Update entities
		for (e in entities) {
			e.update();
		}
		// Render
		render();
		// Update controls
		KeyboardMan.INST.update();
	}
	
	function isInFirstRoom () :Bool {
		return activeRoom == 0;
	}
	
	function isInLastRoom () :Bool {
		return activeRoom == level.rooms.length - 1;
	}
	
	function goToNextRoom () {
		if (isInLastRoom())	return;
		// Change room
		activeRoom++;
		// Discover the room if new
		if (!level.rooms[activeRoom].discovered)
			level.rooms[activeRoom].discover();
		// Show next room if existing and not visible already
		if (level.rooms.length > activeRoom + 1 && !level.rooms[activeRoom + 1].visible)
			level.rooms[activeRoom + 1].show();
	}
	
	function goToPreviousRoom () {
		if (isInFirstRoom())	return;
		// Change room
		activeRoom--;
	}
	
	function render () {
		canvasData.fillRect(canvasData.rect, 0xFF808080);
		for (e in entities) {
			Tilesheet.draw(canvasData, e.tileID, e.x, e.y);
		}
	}
	
}

typedef IntPoint = {x:Int, y:Int}








