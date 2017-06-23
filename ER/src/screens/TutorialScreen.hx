package screens;

import openfl.display.Sprite;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.Lib;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.media.Sound;
import openfl.media.SoundTransform;
import openfl.media.SoundChannel;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

/**
 * The tutorial screen. Explains some basic functions to the players & states additional rules.
 * @author Rutger Regtop
 */
class TutorialScreen extends Screen 
{
	var hand1 : Array<Bitmap> = [];
	var hand2 : Array<Bitmap> = [];
	var hand4 : Array<Bitmap> = [];
	var patients : Array<Bitmap> = [];
	
	var next:Button;
	
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
	
	var doctor : Int;
	var nurse : Int;
	var management : Int;
	var healthcare : Int;
	
	var textField : TextField;
	var tap : Bitmap;
	var nextClicked : Int = 0;
	var timer : Int = 0;
	var ind : Int = 0;
	var hCareY : Float;
	var docY : Float;
	var card3:Bitmap;
	var pCard3 : Bitmap;
	var docCard : Sprite = new Sprite();
	var pCard : Sprite = new Sprite();
	var clicked : Array<Sprite> = [];
	var docSpheres : Array<Sprite> = [];
	var patSpheres : Array<Sprite> = [];
	var done : Bool = false;
	
	var selectCard : Sound;
	var playCard : Sound;
	var bg : Bitmap;
	var turnIndicator : Bitmap;
	
	var universalScalingConstant = Lib.current.stage.stageHeight / 1080;
	
	var spheres : Array<Sprite> = [];
	
	public function new() 
	{
		super();
		
	}
	
	// Loads sounds and calls functions that control the entire class
	override public function onLoad()
	{
		
		soundtrack = Assets.getSound("sounds/InGame.wav");
		selectCard = Assets.getSound("sounds/SelectCard.wav");
		playCard = Assets.getSound("sounds/PlayCard.wav");
		soundTransform = new SoundTransform(0.25, 0);
		
		if (Main.muteST == false)
		{
			channel = soundtrack.play(0, 100, new SoundTransform(0.5, 0));
		}
		
		background();
		createHand();
		createOHands();
		createPatients();
		textBar();
	}
	
	// loads the background, the "Next" button which makes explanation and on-screen activity change
	// also loads the hand indicator used to explain things visually
	function background()
	{
		bg = new Bitmap(Assets.getBitmapData("img/tut.png"));
		bg.width = Lib.current.stage.stageWidth;
		bg.height = Lib.current.stage.stageHeight;
		addChild(bg);
		
		next = new Button( 
			Assets.getBitmapData("img/Button.png"), 
			Assets.getBitmapData("img/Button_over.png"), 
			Assets.getBitmapData("img/Button_pressed.png"), 
			"Next", 
			onNextClick );
		
		next.x = Lib.current.stage.stageWidth - next.width * 1.1;
		next.y = Lib.current.stage.stageHeight - next.height * 2.3;
		addChild(next);
		
		tap = new Bitmap(Assets.getBitmapData("img/tap.png"));
		tap.scaleX = tap.scaleY = 0.5;
		tap.x = tap.y = -90;
	}
	
	// creates the textfield which is displayed at the bottom of the field, will contain all the explanatory text
	function textBar()
	{
		var textFormat:TextFormat = new TextFormat("Verdana", 24, 0xFFFFFF, true);
		textFormat.align = TextFormatAlign.CENTER;
		
		textField = new TextField();
		textField.defaultTextFormat = textFormat;
		textField.autoSize = TextFieldAutoSize.CENTER;
		textField.text = "Welcome to the tutorial! First of all, let me explain everything that you're seeing right now!";
		textField.height = 50;
		textField.width = Lib.current.stage.stageWidth / 1.2;
		textField.wordWrap = true;
		textField.selectable = false;
		textField.x = 10;
		textField.y = next.y - next.height / 3;
		addChild(textField);
	}
	
	// for a specific part of the tutorial, checks if the doctor card has been selected
	// removes specific staff value spheres
	function assignPatient(e:MouseEvent)
	{
		if (clicked.length == 1)
		{
			if (Main.muteFX == false)
			{
				playCard.play(0, 1, soundTransform);
			}
			removeChild(docCard);
			for ( i in 0...3)
			{	
				trace("removed");
				var removed = docSpheres.pop();
				removeChild(removed);
				
				
			}
			clicked.pop();
			done = true;
		}
	}
	
	// at a certain point in the tutorial, allows you to select the doctor 3 card
	function cardAssign(e:MouseEvent)
	{
		
		if ( clicked.length == 0)
		{
			if (Main.muteFX == false)
			{
				selectCard.play(0, 1, soundTransform);
			}
			docCard.scaleX = docCard.scaleY = 1.1;
			clicked.push(docCard);
		}
	}
	
	// determines what the indicator hand is doing/moving to and from
	function indicator(e:Event)
	{
		timer++;
		trace(timer);
		if (ind == 0)
		{
			tap.x += 2.5 * Lib.current.stage.stageWidth / 1920;
			if ( tap.x >= (hand1[3].x + hand1[3].width))
			{
				tap.x = hand1[0].x;
			}
		}
		
		if (ind == 1)
		{
			tap.x += 2.5 * Lib.current.stage.stageWidth / 1920;
			if (tap.x >= (patients[3].x + patients[3].width))
			{
				tap.x = patients[0].x;
			}
		}
		
		if (ind == 2)
		{
			tap.y += 0.3 * Lib.current.stage.stageHeight / 1080;
			if (tap.y >= hCareY)
			{
				tap.y = docY;
			}
		}
		
		if (ind == 3)
		{
			tap.y -= 2 * Lib.current.stage.stageHeight / 1080;
			tap.x += .5 * Lib.current.stage.stageWidth / 1920;
			if (tap.x >= Lib.current.stage.stageWidth / 3 && tap.y <= Lib.current.stage.stageHeight / 3.3)
			{
				tap.x = docCard.x + docCard.width / 2;
				tap.y = docCard.y + docCard.height / 2;
			}
		}
	}
	
	// creates the 4 staff cards of the player in the tutorial
	// makes one a sprite for interaction purposes
	function createHand()
	{	
		var card1:Bitmap = new Bitmap(Assets.getBitmapData("img/Staff_N_4.png"));
		card1.scaleX = card1.scaleY = Lib.current.stage.stageHeight / 750;
		hand1.push(card1);
		
		var card2:Bitmap = new Bitmap(Assets.getBitmapData("img/Staff_ALL_2.png"));
		card2.scaleX = card2.scaleY = Lib.current.stage.stageHeight / 750;
		hand1.push(card2);
		
		card3 = new Bitmap(Assets.getBitmapData("img/Staff_D_3.png"));
		card3.scaleX = card3.scaleY = Lib.current.stage.stageHeight / 750;
		hand1.push(card3);
		docCard.addChild(card3);
		
		var card4:Bitmap = new Bitmap(Assets.getBitmapData("img/Staff_H_3.png"));
		card4.scaleX = card4.scaleY = Lib.current.stage.stageHeight / 750;
		hand1.push(card4);
		
		turnIndicator = new Bitmap(Assets.getBitmapData("img/Indicator_Turn.png"));
		turnIndicator.scaleX = turnIndicator.scaleY = 0.1;
		addChild(turnIndicator);
		
		
		posHand();
	}
	
	//determines the positions for the player's hand
	function posHand()
	{
		var posX : Float = -hand1.length * hand1[0].width / 2;
		var firstPosX = Lib.current.stage.stageWidth / 2 - 40;
		var firstPosY = Lib.current.stage.stageHeight - hand1[0].height * 2.20;
		
		turnIndicator.x = Lib.current.stage.stageWidth / 2 - turnIndicator.width / 2;
		turnIndicator.y = firstPosY - 55;
		
		for (card in hand1)
		{
			if ( card != hand1[2])
			{	
				addChild(card);
				card.x = firstPosX + posX;
				card.y = firstPosY;
				posX += card.width + 20;
			}
			if ( card == hand1[2] )
			{
				addChild(docCard);
				docCard.x = firstPosX + posX;
				docCard.y = firstPosY;
				posX += docCard.width + 20;
			}
		}
	}
	
	// creates the staff cards for the other 2 dummy players visible, purely decorative
	function createOHands()
	{	
		var card1:Bitmap = new Bitmap(Assets.getBitmapData("img/Staff_M_1.png"));
		card1.scaleX = card1.scaleY = Lib.current.stage.stageHeight / 750;
		hand2.push(card1);
		
		var card2:Bitmap = new Bitmap(Assets.getBitmapData("img/Staff_H_4.png"));
		card2.scaleX = card2.scaleY = Lib.current.stage.stageHeight / 750;
		hand2.push(card2);
		
		var card_3:Bitmap = new Bitmap(Assets.getBitmapData("img/Staff_M_2.png"));
		card_3.scaleX = card_3.scaleY = Lib.current.stage.stageHeight / 750;
		hand2.push(card_3);
		
		var card4:Bitmap = new Bitmap(Assets.getBitmapData("img/Staff_D_2.png"));
		card4.scaleX = card4.scaleY = Lib.current.stage.stageHeight / 750;
		hand2.push(card4);
		
		var card5:Bitmap = new Bitmap(Assets.getBitmapData("img/Staff_N_2.png"));
		card5.scaleX = card5.scaleY = Lib.current.stage.stageHeight / 750;
		hand4.push(card5);
		
		var card6:Bitmap = new Bitmap(Assets.getBitmapData("img/Staff_ALL_1.png"));
		card6.scaleX = card6.scaleY = Lib.current.stage.stageHeight / 750;
		hand4.push(card6);
		
		var card7:Bitmap = new Bitmap(Assets.getBitmapData("img/Staff_D_1.png"));
		card7.scaleX = card7.scaleY = Lib.current.stage.stageHeight / 750;
		hand4.push(card7);
		
		var card8:Bitmap = new Bitmap(Assets.getBitmapData("img/Staff_H_4.png"));
		card8.scaleX = card8.scaleY = Lib.current.stage.stageHeight / 750;
		hand4.push(card8);
		
		posOHands();
	}
	
	// positions the cards of the other 2 dummy players on the right spot on the background
	function posOHands()
	{
		var yPos : Float = -hand2.length * hand2[0].height / 2;
		var firstPosX = Lib.current.stage.stageWidth - hand2[0].width * 1.7;
		var firstPosY = Lib.current.stage.stageHeight/2 - 20;
		
		for (card in hand2)
		{
			addChild(card);
			card.rotation = -90;
			card.x = firstPosX;
			card.y = firstPosY + yPos;
			yPos += card.height - 20;
			
		}
		
		yPos = -hand4.length * hand4[0].height / 2;
		firstPosX = hand4[0].width * 1.7;
		firstPosY = Lib.current.stage.stageHeight/3;
		
		for (card in hand4)
		{
			addChild(card);
			card.rotation = 90; 
			card.x = firstPosX;
			card.y = firstPosY + yPos;
			yPos += card.height - 20;
		}
	}
	
	// creates the 4 patient cards, makes 1 a sprite for interaction purposes
	function createPatients()
	{
		var card1:Bitmap = new Bitmap(Assets.getBitmapData("img/Patient_7.png"));
		card1.scaleX = card1.scaleY = Lib.current.stage.stageHeight / 700;
		patients.push(card1);
		
		var card2:Bitmap = new Bitmap(Assets.getBitmapData("img/Patient_12.png"));
		card2.scaleX = card2.scaleY = Lib.current.stage.stageHeight / 700;
		patients.push(card2);
		
		pCard3 = new Bitmap(Assets.getBitmapData("img/Patient_8.png"));
		pCard3.scaleX = pCard3.scaleY = Lib.current.stage.stageHeight / 700;
		pCard.addChild(pCard3);
		patients.push(pCard3);
		patSpheres.push(pCard);
		
		var card4:Bitmap = new Bitmap(Assets.getBitmapData("img/Patient_5.png"));
		card4.scaleX = card4.scaleY = Lib.current.stage.stageHeight / 700;
		patients.push(card4);
		
		posPatients();
		createSpheres();
	}
	
	// positions the patient cards where they should be displayed on the background
	function posPatients()
	{
		var posX : Float = -patients.length * patients[0].width / 2;
		var yPos: Float = Lib.current.stage.stageHeight / 10;
		
		for (card in patients)
		{
			if (card != patients[2])
			{
				addChild(card);
				card.x = Lib.current.stage.stageWidth/2 + posX;
				card.y = yPos;
				posX += card.width + 10;
			}
			
			if ( card == patients[2])
			{
				addChild(pCard);
				pCard.x = Lib.current.stage.stageWidth/2 + posX;
				pCard.y = yPos;
				posX += pCard.width + 10;
			}
		}
	}
	
	// creates and positions the value spheres for each patientcard
	// makes sure the sprite among the patient cards gets specific amount of spheres, with the relevant one a noticeable colour
	function createSpheres()
	{
		for (card in patSpheres)
		{
			doctor = 3;
			nurse = 2;
			management = 4;
			healthcare = 1;
			
			dSprite = new Sprite();
			for (i in 0...5)
			{
				dSprite.graphics.beginFill(0xFFFFFF);
				dSprite.graphics.drawCircle((card.x + card.width/4.25) + card.width/16 * i, card.y + card.height/1.6 + 4, 4);
				dSprite.graphics.endFill();
				spheres.push(dSprite);
			}
			addChild(dSprite);
			
			if (firstTime) posY = dSprite.y + dSprite.height; firstTime = false;
			
			nSprite = new Sprite();
			for (i in 0...5)
			{
				nSprite.graphics.beginFill(0xFFFFFF);
				nSprite.graphics.drawCircle((card.x + card.width/4.25) + card.width/16 * i, posY + card.height + 14, 4);
				nSprite.graphics.endFill();
				spheres.push(nSprite);
			}
			addChild(nSprite);
			
			mSprite = new Sprite();
			for (i in 0...5)
			{
				mSprite.graphics.beginFill(0xFFFFFF);
				mSprite.graphics.drawCircle((card.x + card.width/4.25) + card.width/16 * i, posY + card.height*1.14, 4);
				mSprite.graphics.endFill();
				spheres.push(mSprite);
			}
			addChild(mSprite);
			
			hSprite = new Sprite();
			for (i in 0...5)
			{
				hSprite.graphics.beginFill(0xFFFFFF);
				hSprite.graphics.drawCircle((card.x + card.width/4.25) + card.width/16 * i, posY + card.height*1.15 + 10,4);
				hSprite.graphics.endFill();
				spheres.push(hSprite);
			}
			addChild(hSprite);
			
			//the inner part of the circles
			dSpriteInner = new Sprite();
			for (i in 0...5)
			{
				dSpriteInner.graphics.beginFill(0x181818);
				dSpriteInner.graphics.drawCircle((card.x + card.width/4.25) + card.width/16 * i, card.y + card.height/1.6 + 4, 3);
				dSpriteInner.graphics.endFill();
				spheres.push(dSpriteInner);
			}
			addChild(dSpriteInner);
			
			if (firstTime) posY = dSpriteInner.y + dSpriteInner.height; firstTime = false;
			
			nSpriteInner = new Sprite();
			for (i in 0...5)
			{
				nSpriteInner.graphics.beginFill(0x181818);
				nSpriteInner.graphics.drawCircle((card.x + card.width/4.25) + card.width/16 * i, posY + card.height + 14, 3);
				nSpriteInner.graphics.endFill();
				spheres.push(nSpriteInner);
			}
			addChild(nSpriteInner);
			
			mSpriteInner = new Sprite();
			for (i in 0...5)
			{
				mSpriteInner.graphics.beginFill(0x181818);
				mSpriteInner.graphics.drawCircle((card.x + card.width/4.25) + card.width/16 * i, posY + card.height*1.14, 3);
				mSpriteInner.graphics.endFill();
				spheres.push(mSpriteInner);
			}
			addChild(mSpriteInner);
			
			hSpriteInner = new Sprite();
			for (i in 0...5)
			{
				hSpriteInner.graphics.beginFill(0x181818);
				hSpriteInner.graphics.drawCircle((card.x + card.width/4.25) + card.width/16 * i, posY + card.height*1.15 + 10, 3);
				hSpriteInner.graphics.endFill();
				spheres.push(hSpriteInner);
			}
			addChild(hSpriteInner);
			
			//adds white circles
			doctorSprite = new Sprite();
			for (i in 0...doctor)
			{
				doctorSprite.graphics.beginFill(0x00FF00);
				doctorSprite.graphics.drawCircle((card.x + card.width/4.25) + card.width/16 * i, card.y + card.height/1.6 + 4, 4);
				doctorSprite.graphics.endFill();
				docSpheres.push(doctorSprite);
				spheres.push(doctorSprite);
				docY = card.y + card.height/1.6 + 4;
			}
			addChild(doctorSprite);
			
			if (firstTime) posY = doctorSprite.y + doctorSprite.height; firstTime = false;
			
			nurseSprite = new Sprite();
			for (i in 0...nurse)
			{
				nurseSprite.graphics.beginFill(0xFFFFFF);
				nurseSprite.graphics.drawCircle((card.x + card.width/4.25) + card.width/16 * i, posY + card.height + 14, 4);
				nurseSprite.graphics.endFill();
				spheres.push(nurseSprite);
			}
			addChild(nurseSprite);
			
			managementSprite = new Sprite();
			for (i in 0...management)
			{
				managementSprite.graphics.beginFill(0xFFFFFF);
				managementSprite.graphics.drawCircle((card.x + card.width/4.25) + card.width/16 * i, posY + card.height*1.14, 4);
				managementSprite.graphics.endFill();
				spheres.push(managementSprite);
			}
			addChild(managementSprite);
			
			healthcareSprite = new Sprite();
			for (i in 0...healthcare)
			{
				healthcareSprite.graphics.beginFill(0xFFFFFF);
				healthcareSprite.graphics.drawCircle((card.x + card.width/4.25) + card.width/16 * i, posY + card.height*1.15 + 10, 4);
				healthcareSprite.graphics.endFill();
				spheres.push(healthcareSprite);
				hCareY = posY + card.height*1.15 + 10;
			}
			addChild(healthcareSprite);
		}
		
		for (card in patients)
		{
			if ( card != patients[2])
			{
				doctor = Std.random(5) + 1;
				nurse = Std.random(5) + 1;
				management = Std.random(5) + 1;
				healthcare = Std.random(5) + 1;
				
				
				dSprite = new Sprite();
				for (i in 0...5)
				{
					dSprite.graphics.beginFill(0xFFFFFF);
					dSprite.graphics.drawCircle((card.x + card.width/4.25) + card.width/16 * i, card.y + card.height/1.6 + 4, 4);
					dSprite.graphics.endFill();
					spheres.push(dSprite);
				}
				addChild(dSprite);
				
				if (firstTime) posY = dSprite.y + dSprite.height; firstTime = false;
				
				nSprite = new Sprite();
				for (i in 0...5)
				{
					nSprite.graphics.beginFill(0xFFFFFF);
					nSprite.graphics.drawCircle((card.x + card.width/4.25) + card.width/16 * i, posY + card.height + 14, 4);
					nSprite.graphics.endFill();
					spheres.push(nSprite);
				}
				addChild(nSprite);
				
				mSprite = new Sprite();
				for (i in 0...5)
				{
					mSprite.graphics.beginFill(0xFFFFFF);
					mSprite.graphics.drawCircle((card.x + card.width/4.25) + card.width/16 * i, posY + card.height*1.14, 4);
					mSprite.graphics.endFill();
					spheres.push(mSprite);
				}
				addChild(mSprite);
				
				hSprite = new Sprite();
				for (i in 0...5)
				{
					hSprite.graphics.beginFill(0xFFFFFF);
					hSprite.graphics.drawCircle((card.x + card.width/4.25) + card.width/16 * i,  posY + card.height*1.15 + 10, 4);
					hSprite.graphics.endFill();
					spheres.push(hSprite);
				}
				addChild(hSprite);
				
				//the inner part of the circles
				dSpriteInner = new Sprite();
				for (i in 0...5)
				{
					dSpriteInner.graphics.beginFill(0x181818);
					dSpriteInner.graphics.drawCircle((card.x + card.width/4.25) + card.width/16 * i, card.y + card.height/1.6 + 4, 3);
					dSpriteInner.graphics.endFill();
					spheres.push(dSpriteInner);
				}
				addChild(dSpriteInner);
				
				if (firstTime) posY = dSpriteInner.y + dSpriteInner.height; firstTime = false;
				
				nSpriteInner = new Sprite();
				for (i in 0...5)
				{
					nSpriteInner.graphics.beginFill(0x181818);
					nSpriteInner.graphics.drawCircle((card.x + card.width/4.25) + card.width/16 * i, posY + card.height + 14, 3);
					nSpriteInner.graphics.endFill();
					spheres.push(nSpriteInner);
				}
				addChild(nSpriteInner);
				
				mSpriteInner = new Sprite();
				for (i in 0...5)
				{
					mSpriteInner.graphics.beginFill(0x181818);
					mSpriteInner.graphics.drawCircle((card.x + card.width/4.25) + card.width/16 * i,  posY + card.height*1.14, 3);
					mSpriteInner.graphics.endFill();
					spheres.push(mSpriteInner);
				}
				addChild(mSpriteInner);
				
				hSpriteInner = new Sprite();
				for (i in 0...5)
				{
					hSpriteInner.graphics.beginFill(0x181818);
					hSpriteInner.graphics.drawCircle((card.x + card.width/4.25) + card.width/16 * i,  posY + card.height*1.15 + 10, 3);
					hSpriteInner.graphics.endFill();
					spheres.push(hSpriteInner);
				}
				addChild(hSpriteInner);
				
				//adds white circles
				doctorSprite = new Sprite();
				for (i in 0...doctor)
				{
					doctorSprite.graphics.beginFill(0xFFFFFF);
					doctorSprite.graphics.drawCircle((card.x + card.width/4.25) + card.width/16 * i, card.y + card.height/1.6 + 4, 4);
					doctorSprite.graphics.endFill();
					spheres.push(doctorSprite);
				}
				addChild(doctorSprite);
				
				if (firstTime) posY = doctorSprite.y + doctorSprite.height; firstTime = false;
				
				nurseSprite = new Sprite();
				for (i in 0...nurse)
				{
					nurseSprite.graphics.beginFill(0xFFFFFF);
					nurseSprite.graphics.drawCircle((card.x + card.width/4.25) + card.width/16 * i, posY + card.height + 14, 4);
					nurseSprite.graphics.endFill();
					spheres.push(nurseSprite);
				}
				addChild(nurseSprite);
				
				managementSprite = new Sprite();
				for (i in 0...management)
				{
					managementSprite.graphics.beginFill(0xFFFFFF);
					managementSprite.graphics.drawCircle((card.x + card.width/4.25) + card.width/16 * i, posY + card.height*1.14, 4);
					managementSprite.graphics.endFill();
					spheres.push(managementSprite);
				}
				addChild(managementSprite);
				
				healthcareSprite = new Sprite();
				for (i in 0...healthcare)
				{
					healthcareSprite.graphics.beginFill(0xFFFFFF);
					healthcareSprite.graphics.drawCircle((card.x + card.width/4.25) + card.width/16 * i,  posY + card.height*1.15 + 10, 4);
					healthcareSprite.graphics.endFill();
					spheres.push(healthcareSprite);
				}
				addChild(healthcareSprite);
				
				firstTime = true;
			}
		}
	}
	
	// switches to a new text explanation and hand indicator movement every time you click next
	// slight delay added to counter something being triggered multiple times
	// eventually removes all assets to only display some rules and give the ability to return to main menu
	function onNextClick()
	{
		if (nextClicked == 0)
		{
			addChild(tap);
			textField.text = "This is your hand, it contains personnel cards, which you will use to cure patients.\n Each personnel card has a value displayed on the corners.\n The green lightbulb means it's your turn. ";
			tap.x = hand1[0].x;
			tap.y = hand1[0].y + hand1[0].height / 1.15;
			addEventListener(Event.ENTER_FRAME, indicator);
			nextClicked = 1;
			
		}
		
		if (nextClicked == 1 && timer >= 30)
		{
			ind = 1;
			timer = 0;
			textField.text = "These are the patients. Every patient has a different task and need of personnel.";
			tap.x = patients[0].x;
			tap.y = patients[0].y + patients[0].height;
			nextClicked = 2;
		}
		
		if (nextClicked == 2 && timer >= 30)
		{
			ind = 2;
			timer = 0;
			textField.text = "Every patient has green dots next to a letter, this shows how many of a certain personnel are needed to complete this task. The letter signifies the type of personnel card.\n" + "D = Doctor, N = Nurse, M = Management, C = CNA.";
			tap.x = pCard.x + pCard.width / 2;
			tap.y = docY;
			nextClicked = 3;
		}
		
		if (nextClicked == 3 && timer >= 30)
		{
			ind = 3;
			timer = 0;
			textField.text = "Your hand contains a Nurse 4, Staff 2, Doctor 3, and CNA 3.\nTry clicking the Doctor card and assigning it to patient Grace by clicking her card.";
			tap.x = docCard.x + docCard.width / 2;
			tap.y = docCard.y + docCard.height / 2;
			docCard.addEventListener(MouseEvent.CLICK, cardAssign);
			pCard.addEventListener(MouseEvent.CLICK, assignPatient);
			nextClicked = 4;
		}
		
		if (nextClicked == 4 && done)
		{
			ind = -1;
			timer = 0;
			tap.x = tap.y = -100;
			textField.text = "Good job! You see that Grace had 3 doctor dots, and you just gave her all 3.\n After assigning a personnel card, the turn goes to the next player.";
			nextClicked = 5;
		}
		
		if ( nextClicked == 5 && timer >= 30)
		{
			timer = 0;
			textField.text = "You need to reduce all the personnel needs of a patient down to zero and to supply a special tool if required.\n This cures the patient and gives everyone a reward, plus a possible special reward.";
			nextClicked = 6;
		}
		
		if ( nextClicked == 6 && timer >= 30)
		{
			timer = 0;
			textField.text = "You need to cure 6 patients to win the game. You lose the game if you get 6 uncured patients on the table."; 
			nextClicked = 7;
		}
		
		if (nextClicked == 7 && timer >= 30)
		{
			removeChild(bg);
			removeChild(tap);
			removeChild(next);
			removeChild(pCard);
			removeChild(turnIndicator);
			for (card in hand1)
			{
				removeChild(card);
			}
			for (card in hand2)
			{
				removeChild(card);
			}
			for (card in hand4)
			{
				removeChild(card);
			}
			for (card in patients)
			{
				removeChild(card);
			}
			for (sphere in spheres)
			{
				removeChild(sphere);
			}
			timer = 0;
			textField.y = 50;
			textField.x = Lib.current.stage.stageWidth / 2 - textField.width / 2;
			var textFormat:TextFormat = new TextFormat("Verdana", 32, 0xFFFFFF, true);
			textField.defaultTextFormat = textFormat;
			textField.text = "Other rules are:\n\n\n 1. You can view and buy the special tool cards at any time by clicking the Tool button.\n\n" +
			"2. You only get new personnel cards if you have cured a patient.\n\n 3. If you run out of personnel cards, your turn will be skipped.\n\n" +
			"4. If everyone has run out of personnel cards, you lose the game.\n\n";
			
			var menu : Button = new Button(
				Assets.getBitmapData("img/Button.png"), 
				Assets.getBitmapData("img/Button_over.png"), 
				Assets.getBitmapData("img/Button_pressed.png"), 
				"Menu", 
				onMenuClick );
			
			menu.x = Lib.current.stage.stageWidth / 2 - menu.width / 2;
			menu.y = Lib.current.stage.stageHeight - menu.height * 2;
			addChild(menu);
		}
	}
	
	// redirects you back to the menu on clicking the menu button
	function onMenuClick()
	{
		if (channel != null)
		{
			channel.stop();
		}
		Main.instance.loadScreen(ScreenType.Menu);
	}
	
	// Removes the channel if the class gets 'destroyed'.
	override public function onDestroy()
	{
		if (channel != null)
		{
			channel.stop();
			channel = null;
		}
	}
}