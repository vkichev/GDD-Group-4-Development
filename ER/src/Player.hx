package ;

import openfl.Assets;
import screens.*;
import openfl.display.Sprite;
import openfl.Lib;


/**
 * ...
 * @author Archbishop of Banterberry
 */
class Player extends Sprite
{
	var id:Int = 0;
	var turnPassed:Bool;
	var cardsInHand:Array<StaffCard> = [];
	var selectedCard:StaffCard;
	var assignedCard:PatientCard;
	
	public function new(i:Int) 
	{
		super();
		id = i;
	}
	
	public function addCard(card:StaffCard)
	{
		cardsInHand.push(card);
		displayCards();
	}
	
	public function displayCards()
	{
		var posX : Float = -cardsInHand.length * cardsInHand[0].width / 2;
		var posY : Float = -cardsInHand.length * cardsInHand[0].height / 2;
		var firstPosId1x = 400;
		var firstPosId1y = Lib.current.stage.stageHeight - cardsInHand[0].height / 2;
		
		var firstPosId2x = Lib.current.stage.stageWidth - cardsInHand[0].width;
		var firstPosId2y = 200;
		
		var firstPosId3y = 0;
		if (id == 1)
		{
			for (card in cardsInHand)
			{
				addChild(card);
				card.x = firstPosId1x + posX;
				card.y = firstPosId1y;
				posX += card.width + 10;
			}
		}
		if (id == 2)
		{
			for (card in cardsInHand)
			{
				addChild(card);
				card.rotation = -90; 
				card.x = firstPosId2x;
				card.y = firstPosId2y + posY;
				posY += card.height + 10;
			}
		}
		if (id == 3)
		{
			for (card in cardsInHand)
			{
				addChild(card);
				card.rotation = 180;
				card.x = firstPosId1x + posX;
				card.y = firstPosId3y;
				posX += card.width + 10;
			}
		}
		if (id == 4)
		{
			for (card in cardsInHand)
			{
				addChild(card);
				card.rotation = 90; 
				card.x = 0;
				card.y = firstPosId2y + posY;
				posY += card.height + 10;
			}
		}
	}
}