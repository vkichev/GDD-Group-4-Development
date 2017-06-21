package;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.Assets;
import openfl.Lib;

/**
 * ...
 * @author Rutger Regtop
 */
class StaffCard extends Sprite
{

	public var type : String;
	public var num : Int;

	var imageName : String;

	public function new(subType : String, value : Int, imgName : String) 
	{
		super();
		
		type = subType;
		num = value;
		imageName = imgName;
		
		var cardData : BitmapData = Assets.getBitmapData( imageName );
		var card : Bitmap = new Bitmap( cardData );
		
		card.x = -card.width / 2;
		card.y = -card.height / 2;
		
		card.scaleX = card.scaleY = 1.1 * Lib.current.stage.stageHeight / 1080;
		
		addChild(card);
	}
	
}