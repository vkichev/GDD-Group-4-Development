package ;

import openfl.Assets;
import screens.*;
import openfl.display.Sprite;
import openfl.Lib;
import openfl.events.MouseEvent;
import openfl.events.Event;


/**
 * ...
 * @author Archbishop of Banterberry
 */
class Player extends Sprite
{
	public var id:Int = 0;
	var turnPassed:Bool;
	public var cardsInHand:Array<StaffCard> = [];
	var assignedCard:PatientCard;
	
	public var selected : Array<StaffCard> = [];
	
	public var turn : Bool; 
	
	public function new(i:Int) 
	{
		super();
		id = i;
	}
	
	public function removeCard(card:StaffCard)
	{
		cardsInHand.remove(card);
		selected.remove(card);
		removeChild(card);
	}
	
	public function addCard(card:StaffCard)
	{
		cardsInHand.push(card);
		displayCards();
		
		this.addEventListener(MouseEvent.CLICK, playCard);
		this.addEventListener(MouseEvent.RIGHT_CLICK, deselect);
	}
	
	function deselect(e:Event)
	{
		var card : StaffCard = cast (e.target);
		card.scaleX = card.scaleY = 1;
		selected.remove(card);
		trace(selected.length);
	}
	
	function playCard(e:Event)
	{
		if ( turn == true)
		{
			var card : StaffCard = cast (e.target);
			
			if (selected.length < 1)
			{
				selected.push(card);
				card.scaleX = card.scaleY = 1.2;
				trace(selected.length);
			}
		}	
	}
	
	public function displayCards()
	{
		var posX : Float = -cardsInHand.length * cardsInHand[0].width / 2;
		var posY : Float = -cardsInHand.length * cardsInHand[0].height / 2;
		
		var firstPosId1x = Lib.current.stage.stageWidth / 2;
		var firstPosId1y = Lib.current.stage.stageHeight - cardsInHand[0].height / 1.5;
		
		var firstPosId2x = Lib.current.stage.stageWidth - cardsInHand[0].width / 1.5;
		var firstPosId2y = Lib.current.stage.stageHeight/2;
		
		var firstPosId3y = cardsInHand[0].height / 1.5;
		
		var firstPosId4x = cardsInHand[0].width / 1.5;
		
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
				card.x = firstPosId4x;
				card.y = firstPosId2y + posY;
				posY += card.height + 10;
			}
		}
	}
}