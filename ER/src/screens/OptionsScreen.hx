package screens;

import openfl.Assets;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormatAlign;

/**
 * ...
 * @author ...
 */
class OptionsScreen extends Screen
{
	var musicToggle:Toggle;
	var soundToggle:Toggle;

	public function new() 
	{
		super();
	}
	
	override public function onLoad():Void
	{
		createBackButton();
		
		
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
		Main.instance.loadScreen( ScreenType.Menu );
	}
	
	private function music()
	{
		if (musicToggle.state == false)
		{
			trace("music off");
		}
		if (musicToggle.state == true)
		{
			trace("music on");
		}
	}
	
	private function sounds()
	{
		if (soundToggle.state == false)
		{
			trace("sounds off");
		}
		if (soundToggle.state == true)
		{
			trace("sounds on");
		}
	}
	
}
