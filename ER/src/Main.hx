package;

import openfl.display.Sprite;
import openfl.Lib;
import sys.db.Sqlite;
import sys.db.Connection;
import sys.db.ResultSet;


/**
 * ...
 * @author Rutger Regtop
 */
class Main extends Sprite 
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

	
	
	public function new() 
	{
		super();
		
		//createStaff();
		readFromDataBase();
		

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
					addChild(stCard);
					//stCard.x = pos;
					//stCard.y = 100;
					//pos = pos + 33;
					staffDeck.push(stCard);
				}
			}
		}

		for (val in value)
		{
			var imgname : String = "img/Staff_" + "ALL" + "_" + val + ".png";
			stCard = new StaffCard("ALL", val, imgname);
			//sCard.x = pos2;
			//sCard.y = 300;
			addChild(stCard);
			//pos2 = pos2 + 33;
			staffDeck.push(stCard);
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

				trace("read " + patient.imgID);

				patientDeck.push(patient);

				trace("length " + patientDeck.length);

				addChild(patient);
				patient.x = pos + 40;
				pos = pos + 50;
				patient.y = 300;
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
				trace("read" + row.imgID);

				toolDeck.push(tool);

				trace("length " + toolDeck.length);

				addChild(tool);

				tool.x = pos2 + 30;
				pos2 = pos2 + 60;
				tool.y = 70;

			}

			if ( e == 6)
			{
				patientdat.close();
			}
		}

	}

}
