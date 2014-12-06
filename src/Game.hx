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
	var playerLocked:Bool;
	var allowedActions:Array<UInt>;
	var monstersLeft:Int;
	var chestsLeft:Int;
	
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
		map.rooms[activeRoom].discover();
		//level.rooms[activeRoom + 1].show();
		
		for (r in map.rooms)	entities.push(r);
		
		player = new Player();
		player.x = map.rooms[activeRoom].x;
		player.y = map.rooms[activeRoom].y;
		entities.push(player);
		
		level = 0;
		levelUpAllowed = false;
		
		monstersLeft = chestsLeft = 0;
		allowedActions = [];
		playerLocked = false;
		
		addEventListener(Event.ENTER_FRAME, update);
	}
	
	function update (e:Event) {
		// Player movement
		var hasMoved = false;
		if (!playerLocked) {
			if (KeyboardMan.INST.getState(Keyboard.RIGHT).justPressed) {
				if (!isInLastRoom() && map.rooms[activeRoom + 1].x > map.rooms[activeRoom].x) {
					hasMoved = true;
					goToNextRoom();
				}
				else if (!isInFirstRoom() && map.rooms[activeRoom - 1].x > map.rooms[activeRoom].x) {
					hasMoved = true;
					goToPreviousRoom();
				}
			}
			else if (KeyboardMan.INST.getState(Keyboard.LEFT).justPressed) {
				if (!isInLastRoom() && map.rooms[activeRoom + 1].x < map.rooms[activeRoom].x) {
					hasMoved = true;
					goToNextRoom();
				}
				else if (!isInFirstRoom() && map.rooms[activeRoom - 1].x < map.rooms[activeRoom].x) {
					hasMoved = true;
					goToPreviousRoom();
				}
			}
			else if (KeyboardMan.INST.getState(Keyboard.UP).justPressed) {
				if (!isInLastRoom() && map.rooms[activeRoom + 1].y < map.rooms[activeRoom].y) {
					hasMoved = true;
					goToNextRoom();
				}
				else if (!isInFirstRoom() && map.rooms[activeRoom - 1].y < map.rooms[activeRoom].y) {
					hasMoved = true;
					goToPreviousRoom();
				}
			}
			else if (KeyboardMan.INST.getState(Keyboard.DOWN).justPressed) {
				if (!isInLastRoom() && map.rooms[activeRoom + 1].y > map.rooms[activeRoom].y) {
					hasMoved = true;
					goToNextRoom();
				}
				else if (!isInFirstRoom() && map.rooms[activeRoom - 1].y > map.rooms[activeRoom].y) {
					hasMoved = true;
					goToPreviousRoom();
				}
			}
			if (KeyboardMan.INST.getState(Keyboard.SPACE).justPressed) {
				levelUp();
			}
		}
		// Special actions
		for (a in allowedActions) {
			if (KeyboardMan.INST.getState(a).justPressed) {
				executeAction(a);
				break;
			}
		}
		// Player action
		if (hasMoved) {
			// Move player
			player.x = map.rooms[activeRoom].x;
			player.y = map.rooms[activeRoom].y;
			// Room action(s)
			while (allowedActions.length > 0)	allowedActions.pop();
			switch (map.rooms[activeRoom].type) {
				case ERoomType.BATTLE:
					trace("[F]ight or [R]un?");
					playerLocked = true;
					allowedActions.push(Keyboard.F);
					allowedActions.push(Keyboard.R);
				case ERoomType.CHEST:
					trace("[L]oot or [R]un?");
					playerLocked = true;
					allowedActions.push(Keyboard.L);
					allowedActions.push(Keyboard.R);
				default:
			}
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
	
	function executeAction (a:UInt) {
		trace("Action " + a);
		
		if (a == Keyboard.F) {
			trace("Fight is over, you won");
			monstersLeft--;
			map.rooms[activeRoom].clear();
		}
		else if (a == Keyboard.L) {
			trace("You found good stuff");
			chestsLeft--;
			map.rooms[activeRoom].clear();
		}
		
		playerLocked = false;
		while (allowedActions.length > 0)	allowedActions.pop();
	}
	
	function levelUp () {
		if (!levelUpAllowed)	return;
		if (monstersLeft + chestsLeft != 0) {
			trace(monstersLeft + " monsters left to kill");
			trace(chestsLeft + " chests left to loot");
			return;
		}
		level++;
		levelUpAllowed = false;
		trace("now level " + level);
	}
	
	function isInFirstRoom () :Bool {
		return activeRoom == 0;
	}
	
	function isInLastRoom () :Bool {
		return activeRoom == map.rooms.length - 1;
	}
	
	function goToNextRoom () {
		if (isInLastRoom())	return;
		// Change room
		activeRoom++;
		// Discover the room if new
		if (!map.rooms[activeRoom].discovered) {
			levelUpAllowed = true;
			map.rooms[activeRoom].discover();
			// Count
			if (map.rooms[activeRoom].type == ERoomType.BATTLE) {
				monstersLeft++;
			} else if (map.rooms[activeRoom].type == ERoomType.CHEST) {
				chestsLeft++;
			}
		}
		// Show next room if existing and not visible already
		// DEACTIVATED FOR BETTER GAMEPLAY?
		//if (level.rooms.length > activeRoom + 1 && !level.rooms[activeRoom + 1].visible)
			//level.rooms[activeRoom + 1].show();
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








