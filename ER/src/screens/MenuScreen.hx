package screens;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.system.System;

/**
 * @author Alireza Doustdar
 * Menu Screen that has:
 * play
 * Option
 * Exit
 */
class MenuScreen extends Screen
{
	public function new()
	{
		super();
	}
	
	override public function onLoad():Void
	{
		var backgroundData: BitmapData = Assets.getBitmapData("img/menu_bg.png");
		var background: Bitmap = new Bitmap(backgroundData);
		background.width = stage.stageWidth;
		background.height = stage.stageHeight;
		addChildAt(background, 0);
		
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
			
		var exit:Button = new Button( 
			Assets.getBitmapData("img/Button.png"), 
			Assets.getBitmapData("img/Button_over.png"), 
			Assets.getBitmapData("img/Button_pressed.png"), 
			"Exit", 
			onExitClick );
			
		

		play.width = option.width = exit.width = 150;
		play.height = option.height = exit.height = 46;
		
		play.x = option.x = exit.x = (stage.stageWidth-play.width) / 2;
		play.y = stage.stageHeight / 2 - play.height;
		option.y = play.y + play.height + 10;
		exit.y = option.y + option.height + 10;
		
		addChild(play);
		addChild(option);
		addChild(exit);
		
	}
	
	private function onExitClick() 
	{
		System.exit(0);
	}
	
	private function onOptionClick() 
	{
		//Main.instance.loadScreen( ScreenType.OPTION );
	}

	private function onPlayClick()
	{
		Main.instance.loadScreen( ScreenType.Game );
	}

}