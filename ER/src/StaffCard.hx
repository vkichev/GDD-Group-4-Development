package;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.Assets;
import openfl.Lib;

/**
 * The StaffCard class. Store values for the type, name, and 'value' of the staffcard. 
 * @author Rutger Regtop
 */
class StaffCard extends Sprite
{

	public var type : String;
	public var num : Int;

	var imageName : String;

	/**
	 * Sets the settings for the StaffCard.
	 * @param	subType		StaffCard type. Divided in (D:Doctor, N:Nurse, M:Manager and H:Healtcare worker)
	 * @param	value		StaffCard Value from
	 * @param	imgName		StaffCard name of the image
	 */
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