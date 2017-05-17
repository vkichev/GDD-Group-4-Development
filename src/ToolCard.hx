package;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;

class ToolCard extends Sprite {
	
	public var imgID : String;
	public var doctor : Int;
	public var nurse : Int;
	public var management : Int;
	public var healthcare : Int;


	public function new (imageName : String, doc : Int, nur : Int, mng : Int, hcw : Int)
	{
		super();

		imgID = imageName;

		var cardData : BitmapData = Assets.getBitmapData( imgID );
		var card : Bitmap = new Bitmap( cardData );

		card.x = -card.width / 2;
		card.y = -card.height / 2;

		addChild(card); 

	}

}