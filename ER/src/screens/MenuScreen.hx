package screens;

import openfl.Assets;
import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.system.System;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.media.SoundTransform;

/**
 * @author Alireza Doustdar
 * Menu Screen that has:
 * Play
 * Option
 * Exit
 */
class MenuScreen extends Screen
{
	var soundFX : Sound;
	
	var universalScalingConstant = Lib.current.stage.stageHeight / 1080;
	
	public function new()
	{
		super();
	}
	
	/**
	 * creates the menuscreen background. Loads 3 Button(s) with their text and images.
	 */
	override public function onLoad():Void
	{
		var backgroundData: BitmapData = Assets.getBitmapData("img/menu_bg.png");
		var background: Bitmap = new Bitmap(backgroundData);
		background.width = stage.stageWidth;
		background.height = stage.stageHeight;
		addChildAt(background, 0);
		
		soundtrack = Assets.getSound("sounds/Menuscreen.wav");
		
		if (Main.muteST == false)
		{
			channel = soundtrack.play(0, 100, new SoundTransform (0.35, 0));
		}
		
		
		var play:Button = new Button( 
			Assets.getBitmapData("img/Button.png"), 
			Assets.getBitmapData("img/Button_over.png"), 
			Assets.getBitmapData("img/Button_pressed.png"), 
			"Play", 
			onPlayClick );
			
		var option:Button = new Button( 
			Assets.getBitmapData("img/Button.png"), 
			Assets.getBitmapData("img/Button_over.png"), 
			Assets.getBitmapData("img/Button_pressed.png"), 
			"Options", 
			onOptionClick );
			
		var tutorial:Button = new Button( 
			Assets.getBitmapData("img/Button.png"), 
			Assets.getBitmapData("img/Button_over.png"), 
			Assets.getBitmapData("img/Button_pressed.png"), 
			"Tutorial", 
			onTutorialClick );
			
		var exit:Button = new Button( 
			Assets.getBitmapData("img/Button.png"), 
			Assets.getBitmapData("img/Button_over.png"), 
			Assets.getBitmapData("img/Button_pressed.png"), 
			"Exit", 
			onExitClick );
			
		
		play.width = option.width = exit.width = tutorial.width = 150;
		play.height = option.height = exit.height = tutorial.height = 46;
		
		play.x = option.x = tutorial.x = exit.x = (stage.stageWidth-play.width) / 2;
		play.y = stage.stageHeight / 2 - play.height * 2;
		option.y = play.y + play.height + 10;
		tutorial.y = option.y + option.height + 10;
		exit.y = tutorial.y + tutorial.height + 10;
		
		addChild(play);
		addChild(option);
		addChild(tutorial);
		addChild(exit);
	}
	
	/**
	 * Closes the game.
	 */
	private function onExitClick() 
	{
		System.exit(0);
	}
	
	/**
	 * Switches the screen to the TutorialScreen.
	 */
	function onTutorialClick()
	{
		Main.instance.loadScreen(ScreenType.Tut);
	}
	
	/**
	 * Switches the screen to the OptionScreen.
	 */
	private function onOptionClick() 
	{
		if (channel != null)
		{
			channel.stop();
		}
		
		Main.instance.loadScreen( ScreenType.Options );
	}

	/**
	 * Switches the screen to the GameScreen.
	 */
	private function onPlayClick()
	{	
		if (channel != null)
		{
			channel.stop();
		}
		
		Main.instance.loadScreen( ScreenType.Game );
	}
	
	/**
	 * Closes the channel if active.
	 */
	override public function onDestroy()
	{
		if (channel != null)
		{
			channel.stop();
			channel = null;
		}
	}

}