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

/**
 * This class is the ToolCards, which get its information from the database once it gets loaded in the GameScreen class.
 * This class remembers which image/tool was assigned to it. 
 * This class remembers the current and needed values for the 4 Staffcard stats, and puts it on the cards. 
 * It will change a public variavle to show once it has been completed.
 * @author Group 4
 */
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
	
	var dSprite:Sprite;
	var nSprite:Sprite;
	var mSprite:Sprite;
	var hSprite:Sprite;
	
	var dSpriteInner:Sprite;
	var nSpriteInner:Sprite;
	var mSpriteInner:Sprite;
	var hSpriteInner:Sprite;
	
	var doctorSprite : Sprite;
	var nurseSprite : Sprite;
	var managementSprite : Sprite;
	var healthcareSprite : Sprite;
	var equipmentSprite : Sprite;
	
	var firstTime : Bool = true;
	var posY : Float = 0;
	
	var card : Bitmap;
	
	var universalScalingConstant = Lib.current.stage.stageHeight / 1080;
	
	public var originalX : Float;
	public var originalY : Float;

	/**
	 * Loads the variables from the GameScreen class, which gets it from the batabase.
	 * @param	imageName		Name of the inmage
	 * @param	doc				Doctor value	
	 * @param	nur				Nurse value
	 * @param	mng				Manager value
	 * @param	hcw				Healthcare value
	 * @param	typ				Type of tool (A,B,C,D,E)
	 * @param	gs				Link with the gamescreen class.
	 */
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
		
		card.scaleX = card.scaleY = 1.2 * Lib.current.stage.stageHeight / 1080;
		
		card.x = -card.width / 2;
		card.y = -card.height / 2;
		
		addChild(card); 
		createStaffFields(); 
		
		addEventListener(Event.ENTER_FRAME, update);
		
	}
	
	/**
	 * Marks a tool as solved once it's staff values are 0 or lower.
	 * @param	e	frameupdate
	 */
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
	
	/**
	 * Resets the staff values back to the needed values for this tool. 
	 */
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
	
	/**
	 * Updates the current values of the staff values needed, by subtracting the selected StaffCard value.
	 * @param	type
	 * @param	value
	 */
	public function assignStaffCard(type:String, value:Int)
	{
		switch (type) {
			case "D": doctor = doctor - value; createStaffFields();
			case "N": nurse -= value; createStaffFields();
			case "H": healthcare -= value; createStaffFields();
			case "M": management -= value; createStaffFields();
		}
	}
	
	/**
	 * Adds the 'dots' that show the amount of staff needed to the ToolCard.
	 */
	function createStaffFields()
	{
		//outer line of the empty circle
		dSprite = new Sprite();
		for (i in 0...5)
		{
			dSprite.graphics.beginFill(0xFFFFFF);
			dSprite.graphics.drawCircle((card.x + card.width/3.90) + card.width/18 * i, card.y + 2*card.height/3 - 4, 4 * universalScalingConstant);
			dSprite.graphics.endFill();
		}
		addChild(dSprite);
		
		if (firstTime) posY = dSprite.y + dSprite.height ; firstTime = false;
		
		nSprite = new Sprite();
		for (i in 0...5)
		{
			nSprite.graphics.beginFill(0xFFFFFF);
			nSprite.graphics.drawCircle((card.x + card.width/3.90) + card.width/18 * i, posY + card.height/5.2, 4 * universalScalingConstant);
			nSprite.graphics.endFill();
		}
		addChild(nSprite);
		
		mSprite = new Sprite();
		for (i in 0...5)
		{
			mSprite.graphics.beginFill(0xFFFFFF);
			mSprite.graphics.drawCircle((card.x + card.width/3.90) + card.width/18 * i, posY + card.height/4, 4 * universalScalingConstant);
			mSprite.graphics.endFill();
		}
		addChild(mSprite);
		
		hSprite = new Sprite();
		for (i in 0...5)
		{
			hSprite.graphics.beginFill(0xFFFFFF);
			hSprite.graphics.drawCircle((card.x + card.width/3.90) + card.width/18 * i, posY + card.height/3.2, 4 * universalScalingConstant);
			hSprite.graphics.endFill();
		}
		addChild(hSprite);
		
		//the inner part of the empty circles
		dSpriteInner = new Sprite();
		for (i in 0...5)
		{
			dSpriteInner.graphics.beginFill(0x181818);
			dSpriteInner.graphics.drawCircle((card.x + card.width/3.90) + card.width/18 * i, card.y + 2*card.height/3 - 4, 3 * universalScalingConstant);
			dSpriteInner.graphics.endFill();
		}
		addChild(dSpriteInner);
		
		if (firstTime) posY = dSpriteInner.y + dSpriteInner.height; firstTime = false;
		
		nSpriteInner = new Sprite();
		for (i in 0...5)
		{
			nSpriteInner.graphics.beginFill(0x181818);
			nSpriteInner.graphics.drawCircle((card.x + card.width/3.90) + card.width/18 * i, posY + card.height/5.2, 3 * universalScalingConstant);
			nSpriteInner.graphics.endFill();
		}
		addChild(nSpriteInner);
		
		mSpriteInner = new Sprite();
		for (i in 0...5)
		{
			mSpriteInner.graphics.beginFill(0x181818);
			mSpriteInner.graphics.drawCircle((card.x + card.width/3.90) + card.width/18 * i, posY + card.height/4, 3 * universalScalingConstant);
			mSpriteInner.graphics.endFill();
		}
		addChild(mSpriteInner);
		
		hSpriteInner = new Sprite();
		for (i in 0...5)
		{
			hSpriteInner.graphics.beginFill(0x181818);
			hSpriteInner.graphics.drawCircle((card.x + card.width/3.90) + card.width/18 * i, posY + card.height/3.2, 3 * universalScalingConstant);
			hSpriteInner.graphics.endFill();
		}
		addChild(hSpriteInner);
		
		//adds white full circles
		removeChild(doctorSprite);
		doctorSprite = new Sprite();
		for (i in 0...doctor)
		{
			doctorSprite.graphics.beginFill(0xFFFFFF);
			doctorSprite.graphics.drawCircle((card.x + card.width/3.90) + card.width/18 * i, card.y + 2*card.height/3 - 4, 4 * universalScalingConstant);
			doctorSprite.graphics.endFill();
		}
		addChild(doctorSprite);
		
		if (firstTime) posY = doctorSprite.y + doctorSprite.height; firstTime = false;
		
		removeChild(nurseSprite);
		nurseSprite = new Sprite();
		for (i in 0...nurse)
		{
			nurseSprite.graphics.beginFill(0xFFFFFF);
			nurseSprite.graphics.drawCircle((card.x + card.width/3.90) + card.width/18 * i, posY + card.height/5.2, 4 * universalScalingConstant);
			nurseSprite.graphics.endFill();
		}
		addChild(nurseSprite);
		
		removeChild(managementSprite);
		managementSprite = new Sprite();
		for (i in 0...management)
		{
			managementSprite.graphics.beginFill(0xFFFFFF);
			managementSprite.graphics.drawCircle((card.x + card.width/3.90) + card.width/18 * i, posY + card.height/4, 4 * universalScalingConstant);
			managementSprite.graphics.endFill();
		}
		addChild(managementSprite);
		
		removeChild(healthcareSprite);
		healthcareSprite = new Sprite();
		for (i in 0...healthcare)
		{
			healthcareSprite.graphics.beginFill(0xFFFFFF);
			healthcareSprite.graphics.drawCircle((card.x + card.width/3.90) + card.width/18 * i, posY + card.height/3.2, 4 * universalScalingConstant);
			healthcareSprite.graphics.endFill();
		}
		addChild(healthcareSprite);
	}

}