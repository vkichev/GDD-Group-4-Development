package screens;

import openfl.Assets;
import openfl.events.Event;
import openfl.display.Sprite;
import openfl.Lib;
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

	public function new()
	{
		super();
	}

	override public function onLoad():Void
	{

		var toMenu:Button = new Button( 
			Assets.getBitmapData("img/Button.png"), 
			Assets.getBitmapData("img/Button_over.png"), 
			Assets.getBitmapData("img/Button_pressed.png"), 
			"quit", 
			onQuitClick );
		
		toMenu.x = (stage.stageWidth-toMenu.width) / 2;
		toMenu.y = stage.stageHeight / 3;
		addChild( toMenu );
		
		//
		
		createStaff();
		readFromDataBase();
		
		shuffleDeck(patientDeck);
		shuffleDeck(toolDeck);
		shuffleDeck(staffDeck);
		
		createHand();
		
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
				trace(staffDeck.length);
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

		//

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