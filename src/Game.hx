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
	static public var RND:Random = new Random(Std.random(900000) + 100000);
	
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
	var foundMap:Bool;
	
	var actions:Map<Int, Void->Void>;
	
	var screen:GUI;
	
	var timer:Int;
	var timedAction:Dynamic;
	
	public function new () {
		super();
		
		KeyboardMan.init();
		Tilesheet.init();
		SoundMan.init();
		
		canvasData = new BitmapData(192, 144, false, 0xFF808080);
		
		canvas = new Bitmap(canvasData);
		canvas.scaleX = canvas.scaleY = SCALE;
		addChild(canvas);
		
		screen = new GUI();
		screen.x = 144;
		screen.y = 144;
		addChild(screen);
		
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
		
		foundMap = false;
		
		timer = 0;
		
		actions = new Map();
		
		activeRoom = -1;
		goToNextRoom();
		
		addEventListener(Event.ENTER_FRAME, update);
	}
	
	function placeRoom (r:Room, i:Int) {
		//r.y = Math.floor(i / 8) * Tilesheet.TILE_SIZE;
		//r.x = i % 8 * Tilesheet.TILE_SIZE;
		//
		var s = "0,0;1,0;2,0;3,0;4,0;5,0;6,0;7,0;7,1;7,2;7,3;7,4;7,5;6,5;5,5;4,5;3,5;2,5;1,5;0,5;0,4;0,3;0,2;0,1;1,1;2,1;3,1;4,1;5,1;6,1;6,2;6,3;6,4;5,4;4,4;3,4;2,4;1,4;1,3;1,2";
		var a = s.split(";");
		a = a[i].split(",");
		r.x = Std.parseInt(a[0]) * Tilesheet.TILE_SIZE;
		r.y = Std.parseInt(a[1]) * Tilesheet.TILE_SIZE;
	}
	
	function resetActions () {
		actions.set(Keyboard.RIGHT, null);
		actions.set(Keyboard.LEFT, null);
		actions.set(Keyboard.SPACE, null);
	}
	
	function setDefaultActions () {
		actions.set(Keyboard.RIGHT, null);
		actions.set(Keyboard.LEFT, null);
		actions.set(Keyboard.SPACE, goToNextRoom);
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
			default:
				e = new Door();
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
		resetActions();
		var r:Room = map.rooms[activeRoom];
		var e:Entity = r.content;
		if (r.type == ERoomType.T_LOOT && e != null) {
			if (cast(e, Loot).value > 0) {
				screen.displayLoot(cast(e, Loot).tier, cast(e, Loot).value);
				actions.set(Keyboard.SPACE, pickUpLoot.bind(cast(e, Loot)));
			}
			else {
				screen.displayEmpty();
				setDefaultActions();
			}
		}
		else if (r.type == ERoomType.T_MONSTER && e != null) {
			//trace("A " + cast(e, Monster).health + "H/" + cast(e, Monster).dmg + "D/" + cast(e, Monster).init + "I monster attacks! Press SPACE to fight");
			screen.displayFight();
			actions.set(Keyboard.SPACE, fight.bind(cast(e, Monster)));
		}
		else if (r.type == ERoomType.T_ITEM && e != null) {
			chooseItems();
			actions.set(Keyboard.LEFT, selectItem.bind(-1));
			actions.set(Keyboard.RIGHT, selectItem.bind(1));
			actions.set(Keyboard.SPACE, grabItem);
		}
		else if (r.type == ERoomType.T_START) {
			screen.displayStart();
			setDefaultActions();
		}
		else if (r.type == ERoomType.T_END) {
			screen.displayEnd();
			//setDefaultActions();
		}
	}
	
	function pickUpLoot (e:Loot) {
		switch (e.tier) {
			default:	SoundMan.play(SoundMan.SND_LOOT_S);
			case 1:		SoundMan.play(SoundMan.SND_LOOT_M);
			case 2:		SoundMan.play(SoundMan.SND_LOOT_L);
		}
		totalLoot += e.value;
		e.pickup();
		screen.displayEmpty();
		setDefaultActions();
	}
	
	function chooseItems () {
		// Random
		var a:Array<EItemType> = [];
		a.push(EItemType.T_HEALTH);
		a.push(EItemType.T_WEAPON);
		a.push(EItemType.T_INITIATIVE);
		if (!foundMap)	a.push(EItemType.T_MAP);
		// Pick 2
		while (availableItems.length < 2) {
			availableItems.push(a.splice(Game.RND.random(a.length), 1)[0]);
		}
		// Always available
		availableItems.push(EItemType.T_LEVELUP);
		// Reset selection
		selectedItem = 0;
		// Update display
		screen.displayItem(availableItems[selectedItem], selectedItem == 0, selectedItem == availableItems.length - 1);
	}
	
	function selectItem (dir:Int) {
		selectedItem = Std.int(Math.min(Math.max(selectedItem + dir, 0), availableItems.length - 1));
		// Update display
		screen.displayItem(availableItems[selectedItem], selectedItem == 0, selectedItem == availableItems.length - 1);
	}
	
	function grabItem () {
		var item = availableItems[selectedItem];
		// Clear items
		while (availableItems.length > 0)	availableItems.pop();
		resetActions();
		// Update entity
		var e:Item = cast(map.rooms[activeRoom].content, Item);
		e.open();
		// Apply effect
		switch (item) {
			case EItemType.T_HEALTH:
				player.health++;
				screen.displayEmpty();
				setDefaultActions();
			case EItemType.T_WEAPON:
				player.dmg++;
				screen.displayEmpty();
				setDefaultActions();
			case EItemType.T_INITIATIVE:
				player.init++;
				screen.displayEmpty();
				setDefaultActions();
			case EItemType.T_MAP:
				for (i in (activeRoom + 1)...map.rooms.length) {
					map.rooms[i].updateTID(true);
				}
				foundMap = true;
				screen.displayEmpty();
				setDefaultActions();
			case EItemType.T_LEVELUP:
				levelUp();
		}
		SoundMan.play(SoundMan.SND_ITEM);
	}
	
	function fight (e:Monster) {
		// Hide SPACE
		screen.displayFight(false);
		//
		var st = 30;
		// Player initiative
		if (player.init > e.init) {
			//trace("You strike first! " + player.health + "H/" + player.dmg + "D/" + player.init + "I");
			timedAction = fightRound.bind(player, e);
			timer = st;
			//fightRound(player, e);
		}
		// Monster initiative
		else if (player.init < e.init) {
			//trace("The monster strikes first! " + e.health + "H/" + e.dmg + "D/" + e.init + "I");
			timedAction = fightRound.bind(e, player);
			timer = st;
			//fightRound(e, player);
		}
		// Random initiative
		else {
			if (RND.random(3) == 0) {
				//trace("The monster strikes first! " + e.health + "H/" + e.dmg + "D/" + e.init + "I");
				timedAction = fightRound.bind(e, player);
				timer = st;
				//fightRound(e, player);
			}
			else {
				//trace("You strike first! " + player.health + "H/" + player.dmg + "D/" + player.init + "I");
				timedAction = fightRound.bind(player, e);
				timer = st;
				//fightRound(player, e);
			}
		}
	}
	
	function fightRound (att:FightEntity, def:FightEntity) {
		if (att == player)	att.x = map.rooms[activeRoom].x + 2;
		else				att.x = map.rooms[activeRoom].x - 2;
		def.x = map.rooms[activeRoom].x;
		//
		def.health -= att.dmg;
		def.hit();
		// If def died
		if (def.health <= 0) {
			def.health = 0;
			//def.die();
			// Check who it was
			if (def == player) {
				timedAction = gameOver;
				timer = 30;
				//gameOver();
			}
			else {
				timedAction = fightWon;
				timer = 30;
				//fightWon();
			}
		}
		else {
			// Change roles and fight next round
			timedAction = fightRound.bind(def, att);
			timer = 30;
			//fightRound(def, att);
		}
	}
	
	function fightWon () {
		map.rooms[activeRoom].content.x = map.rooms[activeRoom].x;
		player.x  = map.rooms[activeRoom].x;
		//
		screen.displayWinFight();
		setDefaultActions();
	}
	
	function levelUp () {
		level++;
		//trace("New level: " + level);
		KeyboardMan.INST.cancelJustPressed(Keyboard.SPACE);
		goToNextRoom();
		/*for (i in 0...activeRoom) {
			map.rooms[i].lock();
			if (map.rooms[i].content != null) {
				entities.remove(map.rooms[i].content);
				map.rooms[i].content = null;
			}
		}*/
	}
	
	function gameOver () {
		map.rooms[activeRoom].content.x = map.rooms[activeRoom].x;
		player.x  = map.rooms[activeRoom].x;
		//
		screen.displayGameOver();
		resetActions();
	}
	
	function update (e:Event) {
		// Timed action
		if (timer > 0) {
			timer--;
			if (timer == 0)	timedAction();
		}
		// Player input
		else {
			if (KeyboardMan.INST.getState(Keyboard.SPACE).justPressed && actions.get(Keyboard.SPACE) != null)	actions.get(Keyboard.SPACE)();
			if (KeyboardMan.INST.getState(Keyboard.LEFT).justPressed && actions.get(Keyboard.LEFT) != null)		actions.get(Keyboard.LEFT)();
			if (KeyboardMan.INST.getState(Keyboard.RIGHT).justPressed && actions.get(Keyboard.RIGHT) != null)	actions.get(Keyboard.RIGHT)();
		}
		// Update entities
		for (e in entities) {
			e.update();
		}
		// Render
		render();
		screen.displayStats(player.health, player.dmg, player.init, totalLoot);
		screen.update();
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










