package screens;

import openfl.Assets;
import openfl.events.Event;
import openfl.display.Sprite;
import openfl.Lib;
import openfl.events.MouseEvent;
//import src.*;
import sys.db.Sqlite;
import sys.db.Connection;
import sys.db.ResultSet;

/**
 * Simple screen in the application.
 * Shows a text, a button and a moving element.
 *
 */
class GameScreen extends Screen
{
	
	var patientDeck : Array<PatientCard> = [];
	var toolDeck : Array<ToolCard> = [];
	var staffDeck : Array<StaffCard> = [];

	var stCard : StaffCard;
	var pCard1 : PatientCard;

	var type : Array<String>;
	var value : Array<Int>;

	var pos : Int = 20;
	var pos2 : Int = 20;
	
	var players:Array<Player> = new Array<Player>();
	var cardsInHand:StaffCard;

	var patientsField : Array<PatientCard> = [];
	
	var currentTurn : Int = 1;
	
	public function new()
	{
		super();
	}

	override public function onLoad():Void
	{
		var toMenu:Button = new Button
		( 
			Assets.getBitmapData("img/Button.png"), 
			Assets.getBitmapData("img/Button_over.png"), 
			Assets.getBitmapData("img/Button_pressed.png"), 
			"quit", 
			onQuitClick 
		);
		
		toMenu.x = (stage.stageWidth-toMenu.width) / 2;
		toMenu.y = 100;
		addChild( toMenu );
		
		createStaff();
		readFromDataBase();
		
		shuffleDeck(patientDeck);
		shuffleDeck(staffDeck);
		
		createHand();
		displayPatients();
		displayTools();
		this.addEventListener(Event.ENTER_FRAME, canPlayerPlay);
		
	}
	
	function canPlayerPlay(e:Event)
	{
		for (player in players)
		{
			if (currentTurn == player.id)
			{
				player.turn = true;
			}
			else
			{
				player.turn = false;
			}
		}
	}
	
	private function patientClicked(e:Event):Void
	{
		trace("patient clicked");
		for (player in players)
		{
			if (player.turn)
			{
				var card : PatientCard = cast (e.target);
				player.turn = false;
				currentTurn += 1;
				trace( currentTurn );
				if (currentTurn == 5)
				{
					currentTurn = 1;
				}
				var staffCard : StaffCard;
				
				if (player.selected.length == 1)
				{
					staffCard = player.selected.pop();
					player.removeCard(staffCard);
					var type : String = staffCard.type;
					var value : Int = staffCard.num;
					
					card.assignStaffCard(type, value);
				} 
			}
		}
	}
	
	private function toolClicked(e:Event):Void
	{
		trace("tool clicked");
		for (player in players)
		{
			if (player.turn)
			{
				var card : ToolCard = cast (e.target);
				player.turn = false;
				currentTurn += 1;
				trace( currentTurn );
				if (currentTurn == 5)
				{
					currentTurn = 1;
				}
				var staffCard : StaffCard;
				
				if (player.selected.length == 1)
				{
					staffCard = player.selected.pop();
					player.removeCard(staffCard);
					var type : String = staffCard.type;
					var value : Int = staffCard.num;
					
					card.assignStaffCard(type, value);
				} 
			}
		}
	}

	function displayTools()
	{
		var posX : Float = -toolDeck.length * toolDeck[0].width / 2;
		for (card in toolDeck)
		{
			card.addEventListener(MouseEvent.CLICK, toolClicked);
			addChild(card);
			card.x = 400 + posX;
			card.y = 150;
			posX += card.width + 10;
		}
		
	}
	
	function displayPatients()
	{
		
		for (i in 0...4)
		{
			
			var card = patientDeck.pop();
			patientsField.push(card);
		}
		var posX : Float = -patientsField.length * patientsField[0].width / 2;
		for (card in patientsField)
		{
			card.addEventListener(MouseEvent.CLICK, patientClicked);
			addChild(card);
			card.x = 400 + posX;
			card.y = 300;
			posX += card.width + 10;
		}
	}
	
	function createHand()
	{
		var card : StaffCard;
		
		for (i in 1...5)
		{
			var player = new Player(i);
			players.push(player);
			
			for (i in 0...4)
			{
				var card = staffDeck.pop();
				player.addCard(card);
			}
			addChild(player);
		}
	}
	
	function createStaff()
	{
		type = ["N", "D", "H", "M", "ALL"];
		value = [1, 2, 3, 4, 5];
		for (i in 0...2)
		{
			for (tp in type)
			{
				for (val in value) 
				{
					var imgname : String = "img/Staff_" + tp + "_" + val + ".png";
					stCard = new StaffCard(tp, val, imgname);
					staffDeck.push(stCard);
				}
			}
		}
		
		for (val in value)
		{
			var imgname : String = "img/Staff_" + "ALL" + "_" + val + ".png";
			stCard = new StaffCard("ALL", val, imgname);
			staffDeck.push(stCard);
		}
	}
	
	function shuffleDeck(deck : Dynamic)
	{
		var n:Int = deck.length;
		
		for (i in 0...n )
		{
			var change:Int = i + Math.floor( Math.random() * (n - i) );
			var tempCard = deck[i];
			deck[i] = deck[change];
			deck[change] = tempCard;
		}
	}

	function readFromDataBase()
	{
		// patients
		
		for (i in 1...16 )
		{
			var patientdat = Sqlite.open("db/patientdata.db");
			var resultset = patientdat.request("SELECT * FROM patients WHERE rowid = " + i + ";");

			for (row in resultset)
			{
				var patient : PatientCard = new PatientCard(row.imgID, row.doctor, row.nurse, row.management, row.healthcare, row.equipment, row.reward);
				patientDeck.push(patient);
			}
			
			if ( i == 16)
			{
				patientdat.close();
			}
		}

		// tools 

		for ( e in 1...6 )
		{
			var patientdat = Sqlite.open( "db/patientdata.db");
			var resultset = patientdat.request("SELECT * FROM tools WHERE rowid = " + e + ";");

			for (row in resultset)
			{
				var tool : ToolCard = new ToolCard(row.imgID, row.doctor, row.nurse, row.management, row.healthcare);
				toolDeck.push(tool);
			}

			if ( e == 6)
			{
				patientdat.close();
			}
		}

	}

	private function onQuitClick()
	{
		Main.instance.loadScreen( ScreenType.Menu );
	}

	override public function onDestroy()
	{
		
	}

}