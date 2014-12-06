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
	var map:WorldMap;
	var player:Player;
	
	var level:Int;
	var levelUpAllowed:Bool;
	
	var activeRoom:Int;
	var lastRoom:Room;
	
	var monstersLeft:Int;
	var coins:Int;
	
	var actions:Map<Int, Void->Void>;
	
	public function new () {
		super();
		
		KeyboardMan.init();
		Tilesheet.init();
		
		canvasData = new BitmapData(200, 200, false, 0xFF808080);
		
		canvas = new Bitmap(canvasData);
		canvas.scaleX = canvas.scaleY = SCALE;
		addChild(canvas);
		
		entities = [];
		
		map = new WorldMap();
		
		activeRoom = 0;
		lastRoom = null;
		map.rooms[activeRoom].discover();
		
		// Add the rooms
		for (r in map.rooms) {
			entities.push(r);
		}
		
		player = new Player();
		player.x = map.rooms[activeRoom].x;
		player.y = map.rooms[activeRoom].y;
		entities.push(player);
		
		level = 0;
		levelUpAllowed = false;
		
		monstersLeft = coins = 0;
		
		actions = new Map();
		resetActions();
		
		showMessage();
		
		addEventListener(Event.ENTER_FRAME, update);
	}
	
	function resetActions () {
		actions.set(Keyboard.UP, null);
		actions.set(Keyboard.DOWN, null);
		actions.set(Keyboard.LEFT, null);
		actions.set(Keyboard.RIGHT, null);
		actions.set(Keyboard.SPACE, null);
	}
	
	function showMessage () {
		//trace("Press SPACE when ready");
		actions.set(Keyboard.SPACE, startGame);
	}
	
	function startGame () {
		//trace("START");
		setMovementActions();
	}
	
	function setMovementActions () {
		resetActions();
		actions.set(Keyboard.UP, move.bind(Keyboard.UP));
		actions.set(Keyboard.DOWN, move.bind(Keyboard.DOWN));
		actions.set(Keyboard.LEFT, move.bind(Keyboard.LEFT));
		actions.set(Keyboard.RIGHT, move.bind(Keyboard.RIGHT));
	}
	
	function move (dir:UInt) {
		var hasMoved = false;
		
		if (dir == Keyboard.UP) {
			if (!isInLastRoom() && map.rooms[activeRoom + 1].y < map.rooms[activeRoom].y) {
				hasMoved = true;
				goToNextRoom();
			}
			else if (!isInFirstRoom() && map.rooms[activeRoom - 1].y < map.rooms[activeRoom].y) {
				hasMoved = true;
				goToPreviousRoom();
			}
		}
		else if (dir == Keyboard.DOWN) {
			if (!isInLastRoom() && map.rooms[activeRoom + 1].y > map.rooms[activeRoom].y) {
				hasMoved = true;
				goToNextRoom();
			}
			else if (!isInFirstRoom() && map.rooms[activeRoom - 1].y > map.rooms[activeRoom].y) {
				hasMoved = true;
				goToPreviousRoom();
			}
		}
		else if (dir == Keyboard.RIGHT) {
			if (!isInLastRoom() && map.rooms[activeRoom + 1].x > map.rooms[activeRoom].x) {
				hasMoved = true;
				goToNextRoom();
			}
			else if (!isInFirstRoom() && map.rooms[activeRoom - 1].x > map.rooms[activeRoom].x) {
				hasMoved = true;
				goToPreviousRoom();
			}
		}
		else if (dir == Keyboard.LEFT) {
			if (!isInLastRoom() && map.rooms[activeRoom + 1].x < map.rooms[activeRoom].x) {
				hasMoved = true;
				goToNextRoom();
			}
			else if (!isInFirstRoom() && map.rooms[activeRoom - 1].x < map.rooms[activeRoom].x) {
				hasMoved = true;
				goToPreviousRoom();
			}
		}
		
		if (hasMoved)	movePlayer();
	}
	
	function movePlayer () {
		var r:Room = map.rooms[activeRoom];
		// Move player
		player.x = r.x;
		player.y = r.y;
		// Discover the room if new
		if (r.state == ERoomState.HIDDEN) {
			r.discover();
			if (r.content != null) {
				r.content.x = r.x;
				r.content.y = r.y;
				entities.push(r.content);
				entities.remove(player);
				entities.push(player);
			}
		}
		/*if (!map.rooms[activeRoom].discovered) {
			//levelUpAllowed = true;
			map.rooms[activeRoom].discover();
			//
			switch (map.rooms[activeRoom].type) {
				case ERoomType.BATTLE:	monstersLeft++;
				case ERoomType.ITEM:
					if () {
						trace("Press UP to grab the item");
						resetActions();
						actions.set(Keyboard.UP, grabItem);
					}
				case ERoomType.COINS:
					if () {
						trace("Press UP to grab the coins");
						resetActions();
						actions.set(Keyboard.UP, grabItem);
					}
			}
		} else if () {
			
		}*/
		// Room action(s)
		/*switch (map.rooms[activeRoom].type) {
			case ERoomType.BATTLE:
				trace("Press UP to fight or DOWN to flee");
				actions.set(Keyboard.UP, fight);
				actions.set(Keyboard.DOWN, flee);
			default:
		}*/
	}
	
	function fight () {
		trace("You won");
		//monstersLeft--;
		//map.rooms[activeRoom].clear();
		setMovementActions();
	}
	
	function flee () {
		trace("You escaped");
		setMovementActions();
	}
	
	function grabCoins () {
		trace("Coins added");
		setMovementActions();
	}
	
	function grabItem () {
		trace("Item added");
		//map.rooms[activeRoom].clear();
		setMovementActions();
	}
	
	function update (e:Event) {
		//
		if (KeyboardMan.INST.getState(Keyboard.SPACE).justPressed && actions.get(Keyboard.SPACE) != null) {
			actions.get(Keyboard.SPACE)();
		}
		if (KeyboardMan.INST.getState(Keyboard.UP).justPressed && actions.get(Keyboard.UP) != null) {
			actions.get(Keyboard.UP)();
		}
		if (KeyboardMan.INST.getState(Keyboard.DOWN).justPressed && actions.get(Keyboard.DOWN) != null) {
			actions.get(Keyboard.DOWN)();
		}
		if (KeyboardMan.INST.getState(Keyboard.LEFT).justPressed && actions.get(Keyboard.LEFT) != null) {
			actions.get(Keyboard.LEFT)();
		}
		if (KeyboardMan.INST.getState(Keyboard.RIGHT).justPressed && actions.get(Keyboard.RIGHT) != null) {
			actions.get(Keyboard.RIGHT)();
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
	
	/*function levelUp () {
		if (!levelUpAllowed)	return;
		if (monstersLeft + chestsLeft != 0) {
			trace(monstersLeft + " monsters left to kill");
			trace(chestsLeft + " chests left to loot");
			return;
		}
		level++;
		levelUpAllowed = false;
		trace("Now level " + level);
		//
		activeRoom = furthestRoom;
		goToNextRoom();
		movePlayer();
		//
		while (activeRoom > 0) {
			var r = map.rooms.shift();
			r.deactivate();
			//entities.remove(r);
			activeRoom--;
		}
		furthestRoom = activeRoom;
	}*/
	
	function isInFirstRoom () :Bool { return activeRoom == 0; }
	function isInLastRoom () :Bool { return activeRoom == map.rooms.length - 1; }
	
	function goToNextRoom () {
		if (isInLastRoom())	return;
		// Change room
		activeRoom++;
		//if (activeRoom > furthestRoom)	furthestRoom = activeRoom;
	}
	
	function goToPreviousRoom () {
		if (isInFirstRoom())	return;
		// Change room
		activeRoom--;
	}
	
	function render () {
		canvasData.fillRect(canvasData.rect, 0xFF000000);
		for (e in entities) {
			Tilesheet.draw(canvasData, e.tileID, e.x, e.y);
		}
	}
	
}

typedef IntPoint = {x:Int, y:Int}








