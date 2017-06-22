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
		if (Main.muteST == false)
		{
			channel = soundtrack.play(0, 100, new SoundTransform(0.35, 0));
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
		
		musicToggle.state = Main.mToggle;// supposedly sets the state right
		soundToggle.state = Main.sToggle;
		if (musicToggle.state == false)
		{
			musicToggle.image.bitmapData = musicToggle.leftBitmapData;
		}
		else
		{
			musicToggle.image.bitmapData = musicToggle.rightBitmapData;
		}
		
		if (soundToggle.state == false)
		{
			soundToggle.image.bitmapData = soundToggle.leftBitmapData;
		}
		else
		{
			soundToggle.image.bitmapData = soundToggle.rightBitmapData;
		}
		
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
		toMenu.x = Lib.current.stage.stageWidth /2 - toMenu.width / 2;
		toMenu.y = stage.stageHeight - toMenu.height * 2;
		addChild(toMenu);
	}
	
	function onBackClick()
	{
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
			trace("music off");
			Main.muteST = true;
			Main.mToggle = false;
			channel.stop();
		}
		if (musicToggle.state == true)
		{
			trace("music on");
			Main.muteST = false;
			Main.mToggle = true;
			channel = soundtrack.play(0, 100, new SoundTransform(0.35, 0));
			
		}
	}
	
	private function sounds()
	{
		if (soundToggle.state == false)
		{
			trace("sounds off");
			Main.muteFX = true;
			Main.sToggle = false;
		}
		if (soundToggle.state == true)
		{
			trace("sounds on");
			Main.muteFX = false;
			Main.sToggle = true;
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
