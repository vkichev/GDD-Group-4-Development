package;

import openfl.Assets;
import openfl.Lib;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;

import openfl.events.Event;
import openfl.events.MouseEvent;

import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

import openfl.media.Sound;
import openfl.media.SoundTransform;

/**
 * A fairly crude button with state functionality and a callback for when clicked.
 *
 */
class Toggle extends Sprite 
{
	public var leftBitmapData:BitmapData;
	public var rightBitmapData:BitmapData;

	public var state:Bool = true; //false == left; true == right

	public var image:Bitmap;

	var callback:Void->Void;
	
	var clickSound : Sound;
	
	var universalScalingConstant = Lib.current.stage.stageHeight / 1080;

	public function new( left:BitmapData, right:BitmapData, label:String, callback:Void->Void )
	{
		super();
		
		clickSound = Assets.getSound("sounds/Menu button click.wav");
		
		leftBitmapData = left;
		rightBitmapData = right;
		
		image = new Bitmap( rightBitmapData );
		image.scaleX = image.scaleY = 1 * universalScalingConstant;
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
			tf.scaleX = tf.scaleY = 1 * universalScalingConstant;
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
			if (Main.muteFX == false)
			{
				clickSound.play(0, 1, new SoundTransform(2, 0));
			}
			//image = new Bitmap( rightBitmapData );
			//addChild( image );
		}
		if (state) 
		{
			image.bitmapData = leftBitmapData; trace("right->left");
			if (Main.muteFX == false)
			{
				clickSound.play(0, 1, new SoundTransform(2, 0));
			}
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
