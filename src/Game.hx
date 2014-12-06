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
	var hasExplored:Bool;
	var levelUpAllowed(get, null):Bool;
	
	var activeRoom:Int;
	var lastRoom:Int;
	
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
		lastRoom = 0;
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
		hasExplored = false;
		
		monstersLeft = coins = 0;
		
		actions = new Map();
		
		showMessage(EMessage.Start);
		
		addEventListener(Event.ENTER_FRAME, update);
	}
	
	function resetActions () {
		actions.set(Keyboard.UP, null);
		actions.set(Keyboard.DOWN, null);
		actions.set(Keyboard.LEFT, null);
		actions.set(Keyboard.RIGHT, null);
		actions.set(Keyboard.SPACE, null);
		actions.set(Keyboard.ENTER, levelUp);
	}
	
	function showMessage (m:EMessage) {
		resetActions();
		switch (m) {
			case EMessage.Start:
				trace("Press SPACE when ready");
				actions.set(Keyboard.SPACE, startGame);
			case EMessage.GrabItem:
				trace("Press SPACE to pickup the item");
				actions.set(Keyboard.SPACE, grabItem);
			case EMessage.FightOrFlee:
				trace("Press SPACE to fight, any valid ARROW key to flee");
				setMovementActions();
				actions.set(Keyboard.SPACE, fight);
		}
	}
	
	function startGame () {
		trace("move with ARROW keys");
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
		
		if (hasMoved) {
			movePlayer();
		}
	}
	
	function goToNextRoom () {
		if (isInLastRoom())	return;
		// Change room
		activeRoom++;
	}
	
	function goToPreviousRoom () {
		if (isInFirstRoom())	return;
		// Change room
		activeRoom--;
	}
	
	function movePlayer () {
		var r:Room = map.rooms[activeRoom];
		// Move player
		player.x = r.x;
		player.y = r.y;
		// Discover the room if new
		if (r.state == ERoomState.HIDDEN) {
			r.discover();
			lastRoom = activeRoom;
			hasExplored = true;
			// Display room content if needed
			if (r.content != null) {
				r.content.x = r.x;
				r.content.y = r.y;
				entities.push(r.content);
				// Player on top
				entities.remove(player);
				entities.push(player);
			}
		}
		// React to content
		if (r.content != null) {
			if (Std.is(r.content, Treasure) || Std.is(r.content, Heart) || Std.is(r.content, Sword)) {
				showMessage(EMessage.GrabItem);
			} else if (Std.is(r.content, Monster)) {
				showMessage(EMessage.FightOrFlee);
			}
		}
	}
	
	function fight () {
		trace("You won");
		cast(map.rooms[activeRoom].content, Monster).kill();
		setMovementActions();
	}
	
	function grabItem () {
		trace("Item added");
		entities.remove(map.rooms[activeRoom].content);
		map.rooms[activeRoom].content = null;
		setMovementActions();
	}
	
	function update (e:Event) {
		//
		if (KeyboardMan.INST.getState(Keyboard.SPACE).justPressed && actions.get(Keyboard.SPACE) != null) {
			actions.get(Keyboard.SPACE)();
		}
		if (KeyboardMan.INST.getState(Keyboard.ENTER).justPressed && actions.get(Keyboard.ENTER) != null) {
			actions.get(Keyboard.ENTER)();
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
	
	function levelUp () {
		if (!levelUpAllowed) {
			trace("Unavailable for now");
			return;
		}
		level++;
		trace("Now level " + level);
		//
		activeRoom = lastRoom;
		goToNextRoom();
		movePlayer();
		//
		while (activeRoom > 0) {
			var r = map.rooms.shift();
			if (r.content != null) {
				entities.remove(r.content);
				r.content = null;
			}
			r.lock();
			activeRoom--;
		}
		lastRoom = activeRoom;
		hasExplored = false;
	}
	
	function isInFirstRoom () :Bool { return activeRoom == 0; }
	function isInLastRoom () :Bool { return activeRoom == map.rooms.length - 1; }
	
	function render () {
		canvasData.fillRect(canvasData.rect, 0xFF000000);
		for (e in entities) {
			Tilesheet.draw(canvasData, e.tileID, e.x, e.y);
		}
	}
	
	function get_levelUpAllowed () :Bool {
		var liveItems = 0;
		for (e in entities) {
			if (Std.is(e, Monster) && !cast(e, Monster).beaten)	liveItems++;
			else if (Std.is(e, Heart) || Std.is(e, Sword) || Std.is(e, Treasure))	liveItems++;
		}
		return (hasExplored && liveItems == 0);
	}
	
}

typedef IntPoint = {x:Int, y:Int}


enum EMessage {
	Start;
	GrabItem;
	FightOrFlee;
}





