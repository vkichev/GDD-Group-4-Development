package;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFormat;
import screens.GameScreen;

class ToolCard extends Sprite {
	
	var gamescreen : GameScreen;
	public var imgID : String;
	public var doctor : Int;
	public var nurse : Int;
	public var management : Int;
	public var healthcare : Int;
	public var type : String;
	var orDoc : Int;
	var orNur : Int;
	var orMng : Int;
	var orHcw : Int;
	var orType : String;
	
	public var doctorTextField : TextField;
	public var nurseTextField : TextField;
	public var managementTextField : TextField;
	public var healthcareTextField : TextField;
	
	var card : Bitmap;

	public function new (imageName : String, doc : Int, nur : Int, mng : Int, hcw : Int, typ : String, gs : GameScreen)
	{
		super();
		
		gamescreen = gs;
		imgID = imageName;
		doctor = doc;
		nurse = nur;
		management = mng;
		healthcare = hcw;
		type = typ;
		
		orDoc = doctor;
		orNur = nurse;
		orMng = management;
		orHcw = healthcare;
		orType = type;
		
		var cardData : BitmapData = Assets.getBitmapData( imgID );
		card = new Bitmap( cardData );
		
		//temp tool size
		card.height = 100;
		card.width = 60;
		//temp tool size
		
		
		card.x = -card.width / 2;
		card.y = -card.height / 2;
		
		addChild(card); 
		createStaffFields(card); 
		
		addEventListener(Event.ENTER_FRAME, update);
		
	}
	
	function update(e:Event)
	{
		if (doctor <= 0 && nurse <= 0 && management <= 0 && healthcare <= 0)
		{
			if ( gamescreen.boughtTool.indexOf(this) == -1 )
			{
				gamescreen.boughtTool.push(this);
				trace("solved Tool");
				trace("tool length " + gamescreen.boughtTool.length);
			}
			
		}
	}
	
	public function restoreDefaults()
	{
		doctor = orDoc;
		nurse = orNur;
		management = orMng;
		healthcare = orHcw;
		type = orType;
		removeChild(doctorTextField);
		removeChild(nurseTextField);
		removeChild(managementTextField);
		removeChild(healthcareTextField);
		createStaffFields(card);
	}
	
	public function assignStaffCard(type:String, value:Int)
	{
		switch (type) {
			case "D": doctor -= value; doctorTextField.text = doctor + "";
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
		doctorTextField.x = card.x + 10;
		doctorTextField.y = card.y + 20;
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