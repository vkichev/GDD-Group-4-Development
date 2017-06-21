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
		textField.selectable = false;
		textField.defaultTextFormat = textFormat;
		textField.text = "Burnout!";
		textField.autoSize = TextFieldAutoSize.LEFT;
		textField.x = (stage.stageWidth - textField.width) / 2;
		textField.y = stage.stageHeight / 3;
		textField.border = true;
		addChild(textField);
		
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
	
	function onExitClick() 
	{
		Main.instance.loadScreen( ScreenType.Menu );
	}
	
}