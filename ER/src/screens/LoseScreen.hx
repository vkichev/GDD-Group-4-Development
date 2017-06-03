package screens;

import openfl.Assets;
import openfl.Lib;

import openfl.display.Sprite;

/**
 * ...
 * @author ...
 */
class LoseScreen extends Screen
{

	public function new() 
	{
		super();
	}
	
	override public function onLoad():Void
	{
		var toGame:Button = new Button( 
			Assets.getBitmapData("img/Button.png"), 
			Assets.getBitmapData("img/Button_over.png"), 
			Assets.getBitmapData("img/Button_pressed.png"), 
			"Exit", 
			onExitClick );
		
		toGame.x = (stage.stageWidth-toGame.width) / 2;
		toGame.y = stage.stageHeight / 3;
		addChild( toGame );
	}
	
	function onExitClick() 
	{
		Main.instance.loadScreen( ScreenType.Menu );
	}
	
}