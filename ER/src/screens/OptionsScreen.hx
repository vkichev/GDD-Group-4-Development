package screens;

import openfl.Assets;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormatAlign;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.media.SoundTransform;

/**
 * ...
 * @author ...
 */
class OptionsScreen extends Screen
{
	var musicToggle:Toggle;
	var soundToggle:Toggle;
	var soundFX : Sound;

	public function new() 
	{
		super();
	}
	
	override public function onLoad():Void
	{
		createBackButton();
		
		soundtrack = Assets.getSound("sounds/Menuscreen.wav");
		soundTransform = new SoundTransform(1.0, 0);
		soundFX = Assets.getSound("sounds/Menu button click.wav");
		
		if (Main.muteST == false)
		{
			channel = soundtrack.play(0, 100, soundTransform);
		}
		
		musicToggle = new Toggle( 
			Assets.getBitmapData("img/Toggle_left.png"), 
			Assets.getBitmapData("img/Toggle_right.png"), 
			"Music", 
			music );
		addChild(musicToggle);
		
		soundToggle = new Toggle( 
			Assets.getBitmapData("img/Toggle_left.png"), 
			Assets.getBitmapData("img/Toggle_right.png"), 
			"Sounds", 
			sounds );
		addChild(soundToggle);
		
		musicToggle.x = soundToggle.x = (stage.stageWidth - musicToggle.width) / 2;
		musicToggle.y = stage.stageHeight / 2 - musicToggle.height;
		soundToggle.y = musicToggle.y + soundToggle.height + 10;
		
		
	}
	
	function createBackButton() 
	{
		var toMenu:Button = new Button
		( 
			Assets.getBitmapData("img/Button.png"), 
			Assets.getBitmapData("img/Button_over.png"), 
			Assets.getBitmapData("img/Button_pressed.png"), 
			"back", 
			onBackClick 
		);
		toMenu.x = stage.stageWidth - (toMenu.width * 1.5);
		toMenu.y = stage.stageHeight - toMenu.height;
		addChild(toMenu);
	}
	
	function onBackClick()
	{
		if (Main.muteFX == false)
		{
			soundFX.play(0, 1, soundTransform);
		}
		
		if (channel != null)
		{
			channel.stop();
		}
		
		Main.instance.loadScreen( ScreenType.Menu );
	}
	
	private function music()
	{
		if (musicToggle.state == false)
		{
			if (Main.muteFX == false)
			{
				soundFX.play(0, 1, soundTransform);
			}
			
			trace("music off");
			Main.muteST = true;
			channel.stop();
		}
		if (musicToggle.state == true)
		{
			if (Main.muteFX == false)
			{
				soundFX.play(0, 1, soundTransform);
			}
			
			trace("music on");
			Main.muteST = false;
			channel = soundtrack.play(0, 100, soundTransform);
			
		}
	}
	
	private function sounds()
	{
		if (soundToggle.state == false)
		{
			if (Main.muteFX == false)
			{
				soundFX.play(0, 1, soundTransform);
			}
			
			trace("sounds off");
			Main.muteFX = true;
		}
		if (soundToggle.state == true)
		{
			
			if (Main.muteFX == true)
			{
				soundFX.play(0, 1, soundTransform);
			}
			trace("sounds on");
			Main.muteFX = false;
		}
	}
	override public function onDestroy()
	{
		if (channel != null)
		{
			channel.stop();
			channel = null;
		}
	}
	
}
