package screens;

import openfl.display.Sprite;

import openfl.events.Event;

import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.media.SoundTransform;

/**
 * The base class for all screens.
 * The onLoad and onDestroy can be implemented in the derived classes.
 */
class Screen extends Sprite
{
	var soundtrack : Sound;
	public var channel : SoundChannel;
	var soundTransform : SoundTransform;
	
	public function new()
	{
		super();
	}

	public function onLoad():Void
	{
	}
	public function onDestroy():Void
	{
	}
}