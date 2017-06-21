package;

import openfl.Assets;
import openfl.Lib;
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
	
	var doctorSprite : Sprite;
	var nurseSprite : Sprite;
	var managementSprite : Sprite;
	var healthcareSprite : Sprite;
	var equipmentSprite : Sprite;
	
	var firstTime : Bool = true;
	var posY : Float = 0;
	
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
		//card.height = 100;
		//card.width = 60;
		//temp tool size
		
		card.scaleX = card.scaleY = .1 * Lib.current.stage.stageHeight / 1080;
		
		card.x = -card.width / 2;
		card.y = -card.height / 2;
		
		addChild(card); 
		createStaffFields(); 
		
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
		createStaffFields();
	}
	
	public function assignStaffCard(type:String, value:Int)
	{
		switch (type) {
			case "D": doctor = doctor - value; createStaffFields();
			case "N": nurse -= value; createStaffFields();
			case "H": healthcare -= value; createStaffFields();
			case "M": management -= value; createStaffFields();
		}
	}
	
	function createStaffFields()
	{
		removeChild(doctorSprite);
		doctorSprite = new Sprite();
		for (i in 0...doctor)
		{
			doctorSprite.graphics.beginFill(0x00FF00);
			doctorSprite.graphics.drawCircle((card.x + card.width/4.25) + card.width/18 * i, card.y + 2*card.height/3 - 9, 4);
			doctorSprite.graphics.endFill();
		}
		addChild(doctorSprite);
		
		if (firstTime) posY = doctorSprite.y + doctorSprite.height; firstTime = false;
		
		removeChild(nurseSprite);
		nurseSprite = new Sprite();
		for (i in 0...nurse)
		{
			nurseSprite.graphics.beginFill(0x00FF00);
			nurseSprite.graphics.drawCircle((card.x + card.width/4.25) + card.width/18 * i, posY + card.height/6.5, 4);
			nurseSprite.graphics.endFill();
		}
		addChild(nurseSprite);
		
		removeChild(managementSprite);
		managementSprite = new Sprite();
		for (i in 0...management)
		{
			managementSprite.graphics.beginFill(0x00FF00);
			managementSprite.graphics.drawCircle((card.x + card.width/4.25) + card.width/18 * i, posY + card.height/4.75, 4);
			managementSprite.graphics.endFill();
		}
		addChild(managementSprite);
		
		removeChild(healthcareSprite);
		healthcareSprite = new Sprite();
		for (i in 0...healthcare)
		{
			healthcareSprite.graphics.beginFill(0x00FF00);
			healthcareSprite.graphics.drawCircle((card.x + card.width/4.25) + card.width/18 * i, posY + card.height/3.75, 4);
			healthcareSprite.graphics.endFill();
		}
		addChild(healthcareSprite);
		
		//var staffTextFormat : TextFormat = new TextFormat("_sans", 12, 0xFF0000, true);
		//doctorTextField = new TextField();
		//doctorTextField.defaultTextFormat = staffTextFormat;
		//doctorTextField.width = 10;
		//doctorTextField.height = 15;
		//doctorTextField.x = card.x + 10;
		//doctorTextField.y = card.y + 20;
		//doctorTextField.text = doctor + "";
		//addChild(doctorTextField);
		//
		//nurseTextField = new TextField();
		//nurseTextField.defaultTextFormat = staffTextFormat;
		//nurseTextField.width = 10;
		//nurseTextField.height = 15;
		//nurseTextField.x = doctorTextField.x;
		//nurseTextField.y = doctorTextField.y + 12;
		//nurseTextField.text = nurse + "";
		//addChild(nurseTextField);
		//
		//managementTextField = new TextField();
		//managementTextField.defaultTextFormat = staffTextFormat;
		//managementTextField.width = 10;
		//managementTextField.height = 15;
		//managementTextField.x = doctorTextField.x;
		//managementTextField.y = nurseTextField.y + 12;
		//managementTextField.text = management + "";
		//addChild(managementTextField);
		//
		//healthcareTextField = new TextField();
		//healthcareTextField.defaultTextFormat = staffTextFormat;
		//healthcareTextField.width = 10;
		//healthcareTextField.height = 15;
		//healthcareTextField.x = doctorTextField.x;
		//healthcareTextField.y = managementTextField.y + 12;
		//healthcareTextField.text = healthcare + "";
		//addChild(healthcareTextField);
	}

}