package screens;

import openfl.Assets;
import openfl.Lib;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormatAlign;


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
		var textFormat : TextFormat = new TextFormat("_sans", 48, 0x000000, true);
		textFormat.align = TextFormatAlign.LEFT;
		var textField : TextField = new TextField();
		textField.defaultTextFormat = textFormat;
		textField.text = "Burnout!";
		textField.autoSize = TextFieldAutoSize.LEFT;
		textField.x = (stage.stageWidth - textField.width) / 2;
		textField.y = stage.stageHeight / 3;
		addChild(textField);
		
		var toGame:Button = new Button( 
			Assets.getBitmapData("img/Button.png"), 
			Assets.getBitmapData("img/Button_over.png"), 
			Assets.getBitmapData("img/Button_pressed.png"), 
			"Exit", 
			onExitClick );
		
		toGame.x = (stage.stageWidth-toGame.width) / 2;
		toGame.y = 2*stage.stageHeight / 3;
		addChild( toGame );
	}
	
	function onExitClick() 
	{
		Main.instance.loadScreen( ScreenType.Menu );
	}
	
}