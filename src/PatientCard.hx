package;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.Assets;


/**
 * ...
 * @author Rutger Regtop
 */
class PatientCard extends Sprite {

	public var imgID : String;
	public var doctor : Int;
	public var nurse : Int;
	public var management : Int;
	public var healthcare : Int;
	public var equipment : String;
	public var reward : String;


	public function new (imageName : String, doc : Int, nur : Int, mng : Int, hcw : Int, eqm : String, rew : String)
	{

		super();

		imgID = imageName;
		doctor = doc;
		nurse = nur;
		management = mng;
		healthcare = hcw;
		equipment = eqm;
		reward = rew;

		var cardData : BitmapData = Assets.getBitmapData(imgID);
		var card : Bitmap = new Bitmap( cardData );

		card.x = -card.width / 2;
		card.y = -card.height / 2;

		addChild(card); 

	}
	
}