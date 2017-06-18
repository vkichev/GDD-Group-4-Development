package;

import openfl.Assets;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;

import openfl.events.Event;
import openfl.events.MouseEvent;

import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

/**
 * A fairly crude button with state functionality and a callback for when clicked.
 *
 */
class Toggle extends Sprite 
{
	var leftBitmapData:BitmapData;
	var rightBitmapData:BitmapData;

	public var state:Bool = false; //false == left; true == right

	var image:Bitmap;

	var callback:Void->Void;

	public function new( left:BitmapData, right:BitmapData, label:String, callback:Void->Void )
	{
		super();
		
		leftBitmapData = left;
		rightBitmapData = right;
		
		image = new Bitmap( leftBitmapData );
		addChild( image );
		
		if( label.length > 0 )
		{
			var tfmt:TextFormat = new TextFormat( Assets.getFont("fonts/Retro Computer_DEMO.ttf").fontName, 22, 0xFFFFFF, true, false, false, null, null, TextFormatAlign.CENTER );
			var tf:TextField = new TextField();
			tf.defaultTextFormat = tfmt;
			tf.embedFonts = true;
			tf.autoSize = TextFieldAutoSize.CENTER;
			tf.mouseEnabled = false;
			tf.selectable = false;
			tf.text = label;
			tf.x = (image.width - tf.width) / 2;
			tf.y = ((image.height - tf.height) / 2) - 3;
			addChild( tf );
		}
		
		this.callback = callback;
		
		addEventListener( Event.ADDED_TO_STAGE, init );
	}

	function init( e:Event)
	{
		removeEventListener( Event.ADDED_TO_STAGE, init );
		addEventListener( MouseEvent.CLICK, onClick );
		addEventListener( MouseEvent.MOUSE_UP, onDown );
	}

	function onDown( e:MouseEvent ):Void
	{
		if (!state)
		{
			image.bitmapData = rightBitmapData; trace("left->right");
			//image = new Bitmap( rightBitmapData );
			//addChild( image );
		}
		if (state) 
		{
			image.bitmapData = leftBitmapData; trace("right->left");
			//image = new Bitmap( leftBitmapData );
			//addChild( image );
		}
		state = !state;
	}

	function onClick( e:MouseEvent ):Void
	{
		callback();
	}
}
