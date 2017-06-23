package screens;

import openfl.Assets;
import openfl.Lib;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormatAlign;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.media.SoundTransform;


import openfl.display.Sprite;

/**
 * A screen that shows a player that they lost.
 * Contains text and a button that points to menu.
 * @author Group 4
 */
class LoseScreen extends Screen
{
	var soundFX : Sound;

	public function new() 
	{
		super();
	}
	
	/**
	 * Creates the 'Burnout' text and a exit Button.
	 */
	override public function onLoad():Void
	{
		var textFormat : TextFormat = new TextFormat("_sans", 48, 0x000000, true);
		textFormat.align = TextFormatAlign.LEFT;
		var textField : TextField = new TextField();
		textField.selectable = false;
		textField.defaultTextFormat = textFormat;
		textField.text = "Burnout!";
		textField.autoSize = TextFieldAutoSize.LEFT;
		textField.x = (stage.stageWidth - textField.width) / 2;
		textField.y = stage.stageHeight / 3;
		textField.border = true;
		addChild(textField);
		
		soundtrack = Assets.getSound("sounds/GameLose.wav");
		
		if (Main.muteST == false)
		{
			channel = soundtrack.play(0, 100, new SoundTransform(0.5, 0));
		}
		
		var exit:Button = new Button( 
			Assets.getBitmapData("img/Button.png"), 
			Assets.getBitmapData("img/Button_over.png"), 
			Assets.getBitmapData("img/Button_pressed.png"), 
			"Exit", 
			onExitClick );
		
		exit.x = (stage.stageWidth-exit.width) / 2;
		exit.y = 2*stage.stageHeight / 3;
		addChild( exit );
	}
	
	/**
	 * Returns the game to the mainscreen.
	 */
	function onExitClick() 
	{
		if (channel != null)
		{
			channel.stop();
		}
		Main.instance.loadScreen( ScreenType.Menu );
	}
	
	/**
	 * Destroys the 'channel' when switching screens.
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