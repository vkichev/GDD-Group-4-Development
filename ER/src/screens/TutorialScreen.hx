package screens;

import openfl.display.Sprite;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.Lib;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

/**
 * ...
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
	
	
	public function new() 
	{
		super();
		
	}
	
	override public function onLoad()
	{
		background();
		createHand();
		createOHands();
		createPatients();
		textBar();
		trace(docSpheres.length);
	}
	
	function background()
	{
		var bg:Bitmap = new Bitmap(Assets.getBitmapData("img/tut.png"));
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
		//textField.border = true;
		//textField.borderColor = 0xFFFFFF;
		textField.x = 10;
		textField.y = next.y + next.height / 5;
		addChild(textField);
	}
	
	function assignPatient(e:MouseEvent)
	{
		if (clicked.length == 1)
		{
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
	
	function cardAssign(e:MouseEvent)
	{
		docCard.scaleX = docCard.scaleY = 1.1;
		if ( clicked.length == 0)
		{
			clicked.push(docCard);
		}
	}
	
	function indicator(e:Event)
	{
		timer++;
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
	
	function createHand()
	{	
		var card1:Bitmap = new Bitmap(Assets.getBitmapData("img/Staff_N_4.png"));
		card1.scaleX = card1.scaleY = .13 * Lib.current.stage.stageHeight / 1080;
		hand1.push(card1);
		
		var card2:Bitmap = new Bitmap(Assets.getBitmapData("img/Staff_ALL_2.png"));
		card2.scaleX = card2.scaleY = .13 * Lib.current.stage.stageHeight / 1080;
		hand1.push(card2);
		
		card3 = new Bitmap(Assets.getBitmapData("img/Staff_D_3.png"));
		card3.scaleX = card3.scaleY = .13 * Lib.current.stage.stageHeight / 1080;
		hand1.push(card3);
		docCard.addChild(card3);
		
		var card4:Bitmap = new Bitmap(Assets.getBitmapData("img/Staff_H_3.png"));
		card4.scaleX = card4.scaleY = .13 * Lib.current.stage.stageHeight / 1080;
		hand1.push(card4);
		
		posHand();
	}
	
	function posHand()
	{
		var posX : Float = -hand1.length * hand1[0].width / 2;
		var firstPosX = Lib.current.stage.stageWidth / 2 - 40;
		var firstPosY = Lib.current.stage.stageHeight - hand1[0].height * 2.05;
		
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
	
	function createOHands()
	{	
		var card1:Bitmap = new Bitmap(Assets.getBitmapData("img/Staff_M_1.png"));
		card1.scaleX = card1.scaleY = .13 * Lib.current.stage.stageHeight / 1080;
		hand2.push(card1);
		
		var card2:Bitmap = new Bitmap(Assets.getBitmapData("img/Staff_H_4.png"));
		card2.scaleX = card2.scaleY = .13 * Lib.current.stage.stageHeight / 1080;
		hand2.push(card2);
		
		var card_3:Bitmap = new Bitmap(Assets.getBitmapData("img/Staff_M_2.png"));
		card_3.scaleX = card_3.scaleY = .13 * Lib.current.stage.stageHeight / 1080;
		hand2.push(card_3);
		
		var card4:Bitmap = new Bitmap(Assets.getBitmapData("img/Staff_D_2.png"));
		card4.scaleX = card4.scaleY = .13 * Lib.current.stage.stageHeight / 1080;
		hand2.push(card4);
		
		var card5:Bitmap = new Bitmap(Assets.getBitmapData("img/Staff_N_2.png"));
		card5.scaleX = card5.scaleY = .13 * Lib.current.stage.stageHeight / 1080;
		hand4.push(card5);
		
		var card6:Bitmap = new Bitmap(Assets.getBitmapData("img/Staff_ALL_1.png"));
		card6.scaleX = card6.scaleY = .13 * Lib.current.stage.stageHeight / 1080;
		hand4.push(card6);
		
		var card7:Bitmap = new Bitmap(Assets.getBitmapData("img/Staff_D_1.png"));
		card7.scaleX = card7.scaleY = .13 * Lib.current.stage.stageHeight / 1080;
		hand4.push(card7);
		
		var card8:Bitmap = new Bitmap(Assets.getBitmapData("img/Staff_H_4.png"));
		card8.scaleX = card8.scaleY = .13 * Lib.current.stage.stageHeight / 1080;
		hand4.push(card8);
		
		posOHands();
	}
	
	function posOHands()
	{
		var Ypos : Float = -hand2.length * hand2[0].height / 2;
		var firstPosX = Lib.current.stage.stageWidth - hand2[0].width * 1.5;
		var firstPosY = Lib.current.stage.stageHeight/2 - 20;
		
		for (card in hand2)
		{
			addChild(card);
			card.rotation = -90;
			card.x = firstPosX;
			card.y = firstPosY + Ypos;
			Ypos += card.height - 20;
			
		}
		
		Ypos = -hand4.length * hand4[0].height / 2;
		firstPosX = hand4[0].width * 1.5;
		firstPosY = Lib.current.stage.stageHeight/3;
		
		for (card in hand4)
		{
			addChild(card);
			card.rotation = 90; 
			card.x = firstPosX;
			card.y = firstPosY + Ypos;
			Ypos += card.height - 20;
		}
	}
	
	function createPatients()
	{
		var card1:Bitmap = new Bitmap(Assets.getBitmapData("img/Patient_7.png"));
		card1.scaleX = card1.scaleY = .21 * Lib.current.stage.stageHeight / 1080;
		patients.push(card1);
		
		var card2:Bitmap = new Bitmap(Assets.getBitmapData("img/Patient_12.png"));
		card2.scaleX = card2.scaleY = .21 * Lib.current.stage.stageHeight / 1080;
		patients.push(card2);
		
		pCard3 = new Bitmap(Assets.getBitmapData("img/Patient_8.png"));
		pCard3.scaleX = pCard3.scaleY = .21 * Lib.current.stage.stageHeight / 1080;
		pCard.addChild(pCard3);
		patients.push(pCard3);
		patSpheres.push(pCard);
		
		var card4:Bitmap = new Bitmap(Assets.getBitmapData("img/Patient_5.png"));
		card4.scaleX = card4.scaleY = .21 * Lib.current.stage.stageHeight / 1080;
		patients.push(card4);
		
		posPatients();
		createSpheres();
	}
	
	function posPatients()
	{
		var posX : Float = -patients.length * patients[0].width / 2;
		var Ypos: Float = Lib.current.stage.stageHeight / 10;
		
		for (card in patients)
		{
			if (card != patients[2])
			{
				addChild(card);
				card.x = Lib.current.stage.stageWidth/2 + posX;
				card.y = Ypos;
				posX += card.width + 10;
			}
			
			if ( card == patients[2])
			{
				addChild(pCard);
				pCard.x = Lib.current.stage.stageWidth/2 + posX;
				pCard.y = Ypos;
				posX += pCard.width + 10;
			}
		}
	}
	
	function createSpheres()
	{
		for (card in patSpheres)
		{
			doctor = 3;
			nurse = Std.random(5) + 1;
			management = Std.random(5) + 1;
			healthcare = Std.random(5) + 1;
			
			dSprite = new Sprite();
			for (i in 0...5)
			{
				dSprite.graphics.beginFill(0xFFFFFF);
				dSprite.graphics.drawCircle((card.x + card.width/4.25) + card.width/18 * i, card.y + 2*card.height/3 - 9, 4);
				dSprite.graphics.endFill();
			}
			addChild(dSprite);
			
			if (firstTime) posY = dSprite.y + dSprite.height; firstTime = false;
			
			nSprite = new Sprite();
			for (i in 0...5)
			{
				nSprite.graphics.beginFill(0xFFFFFF);
				nSprite.graphics.drawCircle((card.x + card.width/4.25) + card.width/18 * i, posY + card.height - 13, 4);
				nSprite.graphics.endFill();
			}
			addChild(nSprite);
			
			mSprite = new Sprite();
			for (i in 0...5)
			{
				mSprite.graphics.beginFill(0xFFFFFF);
				mSprite.graphics.drawCircle((card.x + card.width/4.25) + card.width/18 * i, posY + card.height + 1, 4);
				mSprite.graphics.endFill();
			}
			addChild(mSprite);
			
			hSprite = new Sprite();
			for (i in 0...5)
			{
				hSprite.graphics.beginFill(0xFFFFFF);
				hSprite.graphics.drawCircle((card.x + card.width/4.25) + card.width/18 * i, posY + card.height + 15, 4);
				hSprite.graphics.endFill();
			}
			addChild(hSprite);
			
			//the inner part of the circles
			dSpriteInner = new Sprite();
			for (i in 0...5)
			{
				dSpriteInner.graphics.beginFill(0x181818);
				dSpriteInner.graphics.drawCircle((card.x + card.width/4.25) + card.width/18 * i, card.y + 2*card.height/3 - 9, 3);
				dSpriteInner.graphics.endFill();
			}
			addChild(dSpriteInner);
			
			if (firstTime) posY = dSpriteInner.y + dSpriteInner.height; firstTime = false;
			
			nSpriteInner = new Sprite();
			for (i in 0...5)
			{
				nSpriteInner.graphics.beginFill(0x181818);
				nSpriteInner.graphics.drawCircle((card.x + card.width/4.25) + card.width/18 * i, posY + card.height - 13, 3);
				nSpriteInner.graphics.endFill();
			}
			addChild(nSpriteInner);
			
			mSpriteInner = new Sprite();
			for (i in 0...5)
			{
				mSpriteInner.graphics.beginFill(0x181818);
				mSpriteInner.graphics.drawCircle((card.x + card.width/4.25) + card.width/18 * i, posY + card.height + 1, 3);
				mSpriteInner.graphics.endFill();
			}
			addChild(mSpriteInner);
			
			hSpriteInner = new Sprite();
			for (i in 0...5)
			{
				hSpriteInner.graphics.beginFill(0x181818);
				hSpriteInner.graphics.drawCircle((card.x + card.width/4.25) + card.width/18 * i, posY + card.height + 15, 3);
				hSpriteInner.graphics.endFill();
			}
			addChild(hSpriteInner);
			
			//adds white circles
			doctorSprite = new Sprite();
			for (i in 0...doctor)
			{
				doctorSprite.graphics.beginFill(0x00FF00);
				doctorSprite.graphics.drawCircle((card.x + card.width/4.25) + card.width/18 * i, card.y + 2*card.height/3 - 9, 4);
				doctorSprite.graphics.endFill();
				docSpheres.push(doctorSprite);
				docY = card.y + 2 * card.height / 3 - 9;
			}
			addChild(doctorSprite);
			
			if (firstTime) posY = doctorSprite.y + doctorSprite.height; firstTime = false;
			
			nurseSprite = new Sprite();
			for (i in 0...nurse)
			{
				nurseSprite.graphics.beginFill(0x00FF00);
				nurseSprite.graphics.drawCircle((card.x + card.width/4.25) + card.width/18 * i, posY + card.height - 13, 4);
				nurseSprite.graphics.endFill();
			}
			addChild(nurseSprite);
			
			managementSprite = new Sprite();
			for (i in 0...management)
			{
				managementSprite.graphics.beginFill(0x00FF00);
				managementSprite.graphics.drawCircle((card.x + card.width/4.25) + card.width/18 * i, posY + card.height + 1, 4);
				managementSprite.graphics.endFill();
			}
			addChild(managementSprite);
			
			healthcareSprite = new Sprite();
			for (i in 0...healthcare)
			{
				healthcareSprite.graphics.beginFill(0x00FF00);
				healthcareSprite.graphics.drawCircle((card.x + card.width/4.25) + card.width/18 * i, posY + card.height + 15, 4);
				healthcareSprite.graphics.endFill();
				hCareY = posY + card.height;
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
					dSprite.graphics.drawCircle((card.x + card.width/4.25) + card.width/18 * i, card.y + 2*card.height/3 - 9, 4);
					dSprite.graphics.endFill();
				}
				addChild(dSprite);
				
				if (firstTime) posY = dSprite.y + dSprite.height; firstTime = false;
				
				nSprite = new Sprite();
				for (i in 0...5)
				{
					nSprite.graphics.beginFill(0xFFFFFF);
					nSprite.graphics.drawCircle((card.x + card.width/4.25) + card.width/18 * i, posY + card.height - 13, 4);
					nSprite.graphics.endFill();
				}
				addChild(nSprite);
				
				mSprite = new Sprite();
				for (i in 0...5)
				{
					mSprite.graphics.beginFill(0xFFFFFF);
					mSprite.graphics.drawCircle((card.x + card.width/4.25) + card.width/18 * i, posY + card.height + 1, 4);
					mSprite.graphics.endFill();
				}
				addChild(mSprite);
				
				hSprite = new Sprite();
				for (i in 0...5)
				{
					hSprite.graphics.beginFill(0xFFFFFF);
					hSprite.graphics.drawCircle((card.x + card.width/4.25) + card.width/18 * i, posY + card.height + 15, 4);
					hSprite.graphics.endFill();
				}
				addChild(hSprite);
				
				//the inner part of the circles
				dSpriteInner = new Sprite();
				for (i in 0...5)
				{
					dSpriteInner.graphics.beginFill(0x181818);
					dSpriteInner.graphics.drawCircle((card.x + card.width/4.25) + card.width/18 * i, card.y + 2*card.height/3 - 9, 3);
					dSpriteInner.graphics.endFill();
				}
				addChild(dSpriteInner);
				
				if (firstTime) posY = dSpriteInner.y + dSpriteInner.height; firstTime = false;
				
				nSpriteInner = new Sprite();
				for (i in 0...5)
				{
					nSpriteInner.graphics.beginFill(0x181818);
					nSpriteInner.graphics.drawCircle((card.x + card.width/4.25) + card.width/18 * i, posY + card.height - 13, 3);
					nSpriteInner.graphics.endFill();
				}
				addChild(nSpriteInner);
				
				mSpriteInner = new Sprite();
				for (i in 0...5)
				{
					mSpriteInner.graphics.beginFill(0x181818);
					mSpriteInner.graphics.drawCircle((card.x + card.width/4.25) + card.width/18 * i, posY + card.height + 1, 3);
					mSpriteInner.graphics.endFill();
				}
				addChild(mSpriteInner);
				
				hSpriteInner = new Sprite();
				for (i in 0...5)
				{
					hSpriteInner.graphics.beginFill(0x181818);
					hSpriteInner.graphics.drawCircle((card.x + card.width/4.25) + card.width/18 * i, posY + card.height + 15, 3);
					hSpriteInner.graphics.endFill();
				}
				addChild(hSpriteInner);
				
				//adds white circles
				doctorSprite = new Sprite();
				for (i in 0...doctor)
				{
					doctorSprite.graphics.beginFill(0x00FF00);
					doctorSprite.graphics.drawCircle((card.x + card.width/4.25) + card.width/18 * i, card.y + 2*card.height/3 - 9, 4);
					doctorSprite.graphics.endFill();
				}
				addChild(doctorSprite);
				
				if (firstTime) posY = doctorSprite.y + doctorSprite.height; firstTime = false;
				
				nurseSprite = new Sprite();
				for (i in 0...nurse)
				{
					nurseSprite.graphics.beginFill(0x00FF00);
					nurseSprite.graphics.drawCircle((card.x + card.width/4.25) + card.width/18 * i, posY + card.height - 13, 4);
					nurseSprite.graphics.endFill();
				}
				addChild(nurseSprite);
				
				managementSprite = new Sprite();
				for (i in 0...management)
				{
					managementSprite.graphics.beginFill(0x00FF00);
					managementSprite.graphics.drawCircle((card.x + card.width/4.25) + card.width/18 * i, posY + card.height + 1, 4);
					managementSprite.graphics.endFill();
				}
				addChild(managementSprite);
				
				healthcareSprite = new Sprite();
				for (i in 0...healthcare)
				{
					healthcareSprite.graphics.beginFill(0x00FF00);
					healthcareSprite.graphics.drawCircle((card.x + card.width/4.25) + card.width/18 * i, posY + card.height + 15, 4);
					healthcareSprite.graphics.endFill();
				}
				addChild(healthcareSprite);
				
				firstTime = true;
			}
		}
	}
	
	function onNextClick()
	{
		if (nextClicked == 0)
		{
			addChild(tap);
			textField.text = "This is your hand, it contains staff cards, which you will use to cure patients.";
			tap.x = hand1[0].x;
			tap.y = hand1[0].y + hand1[0].height;
			addEventListener(Event.ENTER_FRAME, indicator);
			nextClicked = 1;
			
		}
		
		if (nextClicked == 1 && timer >= 60)
		{
			ind = 1;
			timer = 0;
			textField.text = "These are the patients. Every patient has a different task and need for staff.";
			tap.x = patients[0].x;
			tap.y = patients[0].y + patients[0].height;
			nextClicked = 2;
		}
		
		if (nextClicked == 2 && timer >= 60)
		{
			ind = 2;
			timer = 0;
			textField.text = "Every patient has green dots next to a letter, this shows how many of a certain staff are needed to complete this task. The letter signifies the type of staff card.\n" + "D = Doctor, N = Nurse, M = Management, C = CNA.";
			tap.x = pCard.x + pCard.width / 2;
			tap.y = docY;
			nextClicked = 3;
		}
		
		if (nextClicked == 3 && timer >= 60)
		{
			ind = 3;
			timer = 0;
			textField.text = "Your hand contains a Nurse 4, Staff 2, Doctor 3, and CNA 3.\nTry clicking the Doctor card and assigning it to patient Grace by clicking her card.";
			tap.x = docCard.x + docCard.width / 2;
			tap.y = docCard.y + docCard.height / 2;
			docCard.addEventListener(MouseEvent.CLICK, cardAssign);
			pCard.addEventListener(MouseEvent.CLICK, assignPatient);
			nextClicked = 3;
		}
		
		if (nextClicked == 4 && done)
		{
			ind = 4;
			timer = 0;
			textField.text = "";
			
		}
		
	}
}