package ;

import Item;
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
	var luck:Int;
	var totalLoot:Int;
	
	var availableItems:Array<EItemType>;
	var selectedItem:Int;
	
	var activeRoom:Int;
	
	var actions:Map<Int, Void->Void>;
	
	public function new () {
		super();
		
		KeyboardMan.init();
		Tilesheet.init();
		
		canvasData = new BitmapData(300, 200, false, 0xFF808080);
		
		canvas = new Bitmap(canvasData);
		canvas.scaleX = canvas.scaleY = SCALE;
		addChild(canvas);
		
		entities = [];
		
		map = new WorldMap();
		
		// Add the rooms
		var i:Int = 0;
		for (r in map.rooms) {
			placeRoom(r, i);
			entities.push(r);
			i++;
		}
		
		player = new Player();
		player.x = map.rooms[activeRoom].x;
		player.y = map.rooms[activeRoom].y;
		entities.push(player);
		
		level = 0;
		luck = 0;
		totalLoot = 0;
		
		availableItems = [];
		selectedItem = 0;
		
		activeRoom = -1;
		goToNextRoom();
		
		actions = new Map();
		trace("Press SPACE to leave the room");
		actions.set(Keyboard.SPACE, goToNextRoom);
		
		addEventListener(Event.ENTER_FRAME, update);
	}
	
	function placeRoom (r:Room, i:Int) {
		r.y = Math.floor(i / 8) * Tilesheet.TILE_SIZE;
		r.x = i % 8 * Tilesheet.TILE_SIZE;
	}
	
	function resetActions () {
		actions.set(Keyboard.RIGHT, null);
		actions.set(Keyboard.LEFT, null);
		actions.set(Keyboard.SPACE, null);
	}
	
	function goToNextRoom () {
		if (isInLastRoom())	return;
		
		activeRoom++;
		var r:Room = map.rooms[activeRoom];
		r.discover();
		
		// Move player
		player.x = r.x;
		player.y = r.y;
		
		// Display room content
		var e:Entity;
		switch (r.type) {
			case ERoomType.T_LOOT:
				e = new Loot(level, luck);
			case ERoomType.T_ITEM:
				e = new Item();
			case ERoomType.T_MONSTER:
				e = new Monster(level);
		}
		e.x = r.x;
		e.y = r.y;
		r.content = e;
		entities.push(e);
		// Player on top
		entities.remove(player);
		entities.push(player);
		
		// Update GUI
		updateGUI();
	}
	
	function updateGUI () {
		var r:Room = map.rooms[activeRoom];
		var e:Entity = r.content;
		if (r.type == ERoomType.T_LOOT && e != null && cast(e, Loot).value > 0) {
			trace("Press SPACE to pick-up " + cast(e, Loot).value + " gold");
			actions.set(Keyboard.SPACE, pickUpLoot.bind(cast(e, Loot)));
		}
		else if (r.type == ERoomType.T_MONSTER && e != null) {
			trace("A " + cast(e, Monster).health + "H/" + cast(e, Monster).dmg + "D/" + cast(e, Monster).init + "I monster attacks! Press SPACE to fight");
			actions.set(Keyboard.SPACE, fight.bind(cast(e, Monster)));
		}
		else if (r.type == ERoomType.T_ITEM && e != null) {
			trace("Select an item with the ARROWS and press SPACE to grab it");
			availableItems.push(EItemType.T_HEALTH);
			availableItems.push(EItemType.T_WEAPON);
			availableItems.push(EItemType.T_LEVELUP);
			selectedItem = 0;
			trace("Selected: " + availableItems[selectedItem]);
			actions.set(Keyboard.LEFT, selectItem.bind(-1));
			actions.set(Keyboard.RIGHT, selectItem.bind(1));
			actions.set(Keyboard.SPACE, grabItem);
		}
	}
	
	function pickUpLoot (e:Loot) {
		totalLoot += e.value;
		e.pickup();
		trace("Total loot: " + totalLoot);
		trace("Press SPACE to leave the room");
		actions.set(Keyboard.SPACE, goToNextRoom);
	}
	
	function selectItem (dir:Int) {
		selectedItem = Std.int(Math.min(Math.max(selectedItem + dir, 0), availableItems.length - 1));
		trace("Selected: " + availableItems[selectedItem]);
	}
	
	function grabItem () {
		trace("You picked " + availableItems[selectedItem]);
		// Update entity
		var e:Item = cast(map.rooms[activeRoom].content, Item);
		e.open();
		// Apply effect
		switch (availableItems[selectedItem]) {
			case EItemType.T_LEVELUP:
				level++;
				trace("New level: " + level);
			case EItemType.T_HEALTH:
				player.health++;
				trace("New health: " + player.health);
			case EItemType.T_WEAPON:
				player.dmg++;
				trace("New dmg: " + player.dmg);
		}
		// Clear items
		while (availableItems.length > 0)	availableItems.pop();
		// Default action
		trace("Press SPACE to leave the room");
		resetActions();
		actions.set(Keyboard.SPACE, goToNextRoom);
	}
	
	function fight (e:Monster) {
		// Player initiative
		if (player.init > e.init) {
			trace("You strike first! " + player.health + "H/" + player.dmg + "D/" + player.init + "I");
			fightRound(player, e);
		}
		// Monster initiative
		else if (player.init < e.init) {
			trace("The monster strikes first! " + e.health + "H/" + e.dmg + "D/" + e.init + "I");
			fightRound(e, player);
		}
		// Random initiative
		else {
			if (RND.random(3) == 0) {
				trace("The monster strikes first! " + e.health + "H/" + e.dmg + "D/" + e.init + "I");
				fightRound(e, player);
			}
			else {
				trace("You strike first! " + player.health + "H/" + player.dmg + "D/" + player.init + "I");
				fightRound(player, e);
			}
		}
	}
	
	function fightRound (att:FightEntity, def:FightEntity) {
		def.health -= att.dmg;
		// If def died
		if (def.health <= 0) {
			def.health = 0;
			def.die();
			// Check who it was
			if (def == player)	gameOver();
			else				fightWon();
		}
		else {
			if (def == player)	trace("Your health: " + def.health);
			else				trace("Monster health: " + def.health);
			// Change roles and fight next round
			fightRound(def, att);
		}
	}
	
	function fightWon () {
		trace("You won!");
		trace("Press SPACE to leave the room");
		actions.set(Keyboard.SPACE, goToNextRoom);
	}
	
	function gameOver () {
		trace("GAME OVER");
		resetActions();
	}
	
	function update (e:Event) {
		// Player input
		if (KeyboardMan.INST.getState(Keyboard.SPACE).justPressed && actions.get(Keyboard.SPACE) != null)	actions.get(Keyboard.SPACE)();
		if (KeyboardMan.INST.getState(Keyboard.LEFT).justPressed && actions.get(Keyboard.LEFT) != null)	actions.get(Keyboard.LEFT)();
		if (KeyboardMan.INST.getState(Keyboard.RIGHT).justPressed && actions.get(Keyboard.RIGHT) != null)	actions.get(Keyboard.RIGHT)();
		// Update entities
		for (e in entities) {
			e.update();
		}
		// Render
		render();
		// Update controls
		KeyboardMan.INST.update();
	}
	
	function isInLastRoom () :Bool { return activeRoom == map.rooms.length - 1; }
	
	function render () {
		canvasData.fillRect(canvasData.rect, 0xFF808080);
		for (e in entities) {
			Tilesheet.draw(canvasData, e.tileID, e.x, e.y);
		}
	}
	
}

typedef IntPoint = {x:Int, y:Int}










