package;

import openfl.events.Event;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.Assets;
import openfl.text.TextField;
import openfl.text.TextFormat;
import screens.*;


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
	public var gamescreen : GameScreen;
	
	public var assignedCards : Array<StaffCard> = [];
	
	public var doctorTextField : TextField;
	public var nurseTextField : TextField;
	public var managementTextField : TextField;
	public var healthcareTextField : TextField;

	public function new (imageName : String, doc : Int, nur : Int, mng : Int, hcw : Int, eqm : String, rew : String, gs : GameScreen)
	{
		super();
		
		imgID = imageName;
		doctor = doc;
		nurse = nur;
		management = mng;
		healthcare = hcw;
		equipment = eqm;
		reward = rew;
		gamescreen = gs;
		
		var cardData : BitmapData = Assets.getBitmapData(imgID);
		var card : Bitmap = new Bitmap( cardData );
		
		card.x = -card.width / 2;
		card.y = -card.height / 2;
		
		addChild(card);
		createStaffFields(card);
		
		this.addEventListener(Event.ENTER_FRAME, update);
	}
	
	function update(e:Event)
	{
		if (doctor <= 0 && nurse <= 0 && management <= 0 && healthcare <= 0)
		{
			trace("solved");
			gamescreen.solved += 1;
			gamescreen.removeChild(this);
			removeChild(this);
			removeEventListener(Event.ENTER_FRAME, update);
			
		}
	}
	
	public function assignStaffCard(type:String, value:Int)
	{
		switch (type) {
			case "D": doctor = doctor - value; doctorTextField.text = doctor + "";
			case "N": nurse -= value; nurseTextField.text = nurse + "";
			case "H": healthcare -= value; healthcareTextField.text = healthcare + "";
			case "M": management -= value; managementTextField.text = management + "";
		}
	}
	
	function createStaffFields(card : Bitmap)
	{
		var staffTextFormat : TextFormat = new TextFormat("_sans", 12, 0xFF0000, true);
		doctorTextField = new TextField();
		doctorTextField.defaultTextFormat = staffTextFormat;
		doctorTextField.width = 10;
		doctorTextField.height = 15;
		doctorTextField.x = card.x + 30;
		doctorTextField.y = card.y + 11;
		doctorTextField.text = doctor + "";
		addChild(doctorTextField);
		
		nurseTextField = new TextField();
		nurseTextField.defaultTextFormat = staffTextFormat;
		nurseTextField.width = 10;
		nurseTextField.height = 15;
		nurseTextField.x = doctorTextField.x;
		nurseTextField.y = doctorTextField.y + 12;
		nurseTextField.text = nurse + "";
		addChild(nurseTextField);
		
		managementTextField = new TextField();
		managementTextField.defaultTextFormat = staffTextFormat;
		managementTextField.width = 10;
		managementTextField.height = 15;
		managementTextField.x = doctorTextField.x;
		managementTextField.y = nurseTextField.y + 12;
		managementTextField.text = management + "";
		addChild(managementTextField);
		
		healthcareTextField = new TextField();
		healthcareTextField.defaultTextFormat = staffTextFormat;
		healthcareTextField.width = 10;
		healthcareTextField.height = 15;
		healthcareTextField.x = doctorTextField.x;
		healthcareTextField.y = managementTextField.y + 12;
		healthcareTextField.text = healthcare + "";
		addChild(healthcareTextField);
	}
	
}
