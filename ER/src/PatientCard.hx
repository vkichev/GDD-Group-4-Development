package;

import openfl.events.Event;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.Assets;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.text.TextFieldAutoSize;
import screens.*;
import openfl.Lib;

import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.media.SoundTransform;

/**
 * This class is the PatientCards, which get its information from the database once it gets loaded in the GameScreen class.
 * This class remembers which image/patient was assigned to it. It keeps track of the rewards once it has been completed. 
 * This class tests if the patientcard it represents has been completed, and calls for Rewards if it has been.
 * This class remembers the current and needed values for the 4 Staff stats, and puts it on the cards.
 * @author Group 5
 */
class PatientCard extends Sprite {

	public var imgID : String;
	public var doctor : Int;
	public var nurse : Int;
	public var management : Int;
	public var healthcare : Int;
	public var equipment : String;
	public var reward : String;
	public var equipmentBought:Bool = false;
	
	public var gamescreen : GameScreen;
	
	public var assignedCards : Array<StaffCard> = [];
	
	var taskStart : Sound;
	var soundTransform : SoundTransform;
	var firstAssign : Bool = true;
	
	var card:Bitmap;
	
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
	
	//Multiply by this for magic
	var universalScalingConstant = Lib.current.stage.stageHeight / 1080;
	var universalScalingConstantX = Lib.current.stage.stageWidth / 1920;
	
	var toolText : TextField;
	
	public var originalX : Float;
	public var originalY : Float;

	/**
	 * Imports the parameters from it was assigned in the gamescreen class. Creates a Patientcard with this information	
	 * @param	imageName	Patient name
	 * @param	doc			'Docter' value needed to solve
	 * @param	nur			'Nurse' value needed to solve
	 * @param	mng			'Manage'r value needed to solve
	 * @param	hcw			'Healthcare Worker' value needed to solve this card
	 * @param	eqm			Equipment needed to solve
	 * @param	rew			Reward the player will get
	 * @param	gs			link to the GameScreen class. 
	 */
	public function new (imageName : String, doc : Int, nur : Int, mng : Int, hcw : Int, eqm : String, rew : String, gs : GameScreen)
	{
		super();
		
		taskStart = Assets.getSound("sounds/TaskStart.wav");
		soundTransform = new SoundTransform(0.5, 0);
		
		imgID = imageName;
		doctor = doc;
		nurse = nur;
		management = mng;
		healthcare = hcw;
		equipment = eqm;
		reward = rew;
		gamescreen = gs;
		
		if (equipment == " ") equipmentBought = true;
		
		var cardData : BitmapData = Assets.getBitmapData(imgID);
		card = new Bitmap( cardData );
		
		card.scaleY = 1.5 * universalScalingConstant;	
		card.scaleX = 1.5 * universalScalingConstantX;
		
		card.x = -card.width / 2;
		card.y = -card.height / 2;
		
		addChild(card);
		createStaffFields();
		
		this.addEventListener(Event.ENTER_FRAME, update);
		
		toolTxt();
	}
	
	/**
	 * Tests if the nececary tool for this PatientCard is already obtained and shows it by making the text green.
	 * If the player cleared all conditions to solve this PatientCard, the patientcard gets removed and rewards get called use the reward of this patientcard.
	 * @param	e		frame update event
	 */
	function update(e:Event)
	{
		if (equipmentBought == true)
		{
			var textFormat:TextFormat = new TextFormat("Verdana", 10, 0x119b1a, true);
			toolText.defaultTextFormat = textFormat;
		}
		
		if (doctor <= 0 && nurse <= 0 && management <= 0 && healthcare <= 0 && equipmentBought == true)
		{
			//Rewards the player for completing a card.
			new Rewards(reward, gamescreen);
			
			trace("solved");
			gamescreen.solved += 1;
			gamescreen.removeChild(this);
			gamescreen.patientsField.remove(this);
			removeChild(this);
			removeEventListener(Event.ENTER_FRAME, update);
			
		}
	}
	
	/**
	 * Sets the tooltext variables on the PatientCard
	 */
	function toolTxt()
	{
		var textFormat:TextFormat = new TextFormat("Verdana", 10, 0xf92525, true);
		textFormat.align = TextFormatAlign.CENTER;
		
		toolText = new TextField();
		toolText.defaultTextFormat = textFormat;
		toolText.autoSize = TextFieldAutoSize.CENTER;
		toolText.text = "";
		toolText.height = 50;
		toolText.width = 50;
		toolText.selectable = false;
		toolText.wordWrap = true;
		toolText.x = card.x + card.width - card.width / 2;
		toolText.y = card.y + card.height / 1.45;
		addChild(toolText);
		
		toolName();
	}
	
	/**
	 * Adds the text to the tooltext, based on the tool requirements.
	 */
	function toolName()
	{
		switch(equipment) {
			case "A": toolText.text = "OR Prepa- ration";
			case "B": toolText.text = "Chemo- therapy";
			case "C": toolText.text = "EEG";
			case "D": toolText.text = "CT scan";
			case "E": toolText.text = "X-ray";
		}
	}
	
	/**
	 * Sets the staff stat value, and makes a sound if you do so.
	 * @param	type		The type of Staffcard that is being asigned.
	 * @param	value		The Value of said StaffCard.
	 */
	public function assignStaffCard(type:String, value:Int)
	{
		
		if (firstAssign)
		{
			if (Main.muteFX == false)
			{
				taskStart.play(0, 1, soundTransform);
			}
		}
		
		switch (type) {
			case "D": doctor = doctor - value; createStaffFields();
			case "N": nurse -= value; createStaffFields();
			case "H": healthcare -= value; createStaffFields();
			case "M": management -= value; createStaffFields();
			case "Tool": management -= value; createStaffFields();
		}
		
		firstAssign = false;
	}
	
	/**
	 * 'Draws' circles, which represent the staff stat value, on the PatientCard.
	 * There are two layers of staff stats, the still needed staff stats as full cicles on top, and the hollow staff stats on the bottom.
	 */
	function createStaffFields()
	{		
		//outer line of the 'empty circle'
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
		
		//the inner part of the 'empty circles'
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
		
		//adds white 'full circles'
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
