package ;
import openfl.Assets;
import openfl.media.Sound;
import openfl.media.SoundTransform;

/**
 * ...
 * @author 01101101
 */
class SoundMan {
	
	public static var VOLUME:SoundTransform = new SoundTransform(0.1);
	public static var SND_LOOT_S:Sound;
	public static var SND_LOOT_M:Sound;
	public static var SND_LOOT_L:Sound;
	public static var SND_HIT:Sound;
	public static var SND_DEATH_PLAYER:Sound;
	public static var SND_DEATH_MONSTER:Sound;
	public static var SND_ITEM:Sound;
	
	public static function init () {
		SND_LOOT_S = Assets.getSound("snd/coin0.wav");
		SND_LOOT_M = Assets.getSound("snd/coin1.wav");
		SND_LOOT_L = Assets.getSound("snd/coin2.wav");
		SND_HIT = Assets.getSound("snd/hurt2.wav");
		SND_DEATH_PLAYER = Assets.getSound("snd/death2.wav");
		SND_DEATH_MONSTER = Assets.getSound("snd/death.wav");
		SND_ITEM = Assets.getSound("snd/item2.wav");
	}
	
	public static function play (s:Sound) {
		s.play(0, 0, VOLUME);
	}
	
}