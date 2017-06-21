package screens;

import lime.ui.Mouse;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.events.Event;
import openfl.display.Sprite;
import openfl.Lib;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.text.TextFieldAutoSize;
import sys.db.Sqlite;
import sys.db.Connection;
import sys.db.ResultSet;

import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.media.SoundTransform;

#if android
import hxcpp.StaticSqlite;
#end

/**
 * Simple screen in the application.
 * Shows a text, a button and a moving element.
 *
 */
class GameScreen extends Screen
{
	var buttonClick : Sound;
	var gameWin : Sound;
	var outOfCards : Sound;
	var playCard : Sound;
	var assignTool : Sound;
	var timerStart : Sound;
	var timerHalf : Sound;
	var timerOut : Sound;
	var startRound : Sound;
	var gameWelcome : Sound;
	
	var halfPlayed : Bool;
	
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
	public var boughtTool:Array<ToolCard> = [];

	public var patientsField : Array<PatientCard> = [];
	
	var currentTurn : Int = 1;
	var lastTurn : Int;
	public var doubleTurn:Int = 0; //0 is the normal value.
	
	var _rect:Sprite;
	var allPromptButtons:Array<TextField>;
	var patientCard:PatientCard;
	var card:Dynamic;
	var staffValue:Int;
	var allTextField:openfl.text.TextField;
	
	var timerBar:Timer;
	var maxTime:Int = 15000;		//should be 15000
	var currentTime:Int = 15000;	//should be 15000
	var lastUpdate:Int;
	
	public var solved : Int = 0;
	var solvedTextField : TextField = new TextField();
	var exitButton:Button;
	var continueButton:Button;
	var winTextField : TextField;
 	
	var roundsPassed : Int = 0;
	
	var assignRect : Bitmap;
	var toolRect : Bitmap;
	var closeButton : Sprite;
	
	var turnI:Bitmap;
	var turnD:openfl.display.Bitmap;
	
	//Multiply by this for magic
	var universalScalingConstant = Lib.current.stage.stageHeight / 1080;
	
	var toolButton : Button;
	var thiscard : PatientCard;
	
	public function new()
	{
		super();
	}

	override public function onLoad():Void
	{
		var bg:Bitmap = new Bitmap(Assets.getBitmapData("img/Shit backgroundi.png"));
		bg.width = Lib.current.stage.stageWidth;
		bg.height = Lib.current.stage.stageHeight;
		addChild(bg);
		createQuitButton();
		
		soundtrack = Assets.getSound("sounds/InGame.wav");
		buttonClick = Assets.getSound("sounds/Menu button click.wav");
		startRound = Assets.getSound("sounds/StartRound.wav");
		gameWin = Assets.getSound("sounds/GameWin.wav");
		outOfCards = Assets.getSound("sounds/OutOfCards.wav");
		playCard = Assets.getSound("sounds/PlayCard.wav");
		assignTool = Assets.getSound("sounds/AssignTool.wav");
		timerStart = Assets.getSound("sounds/TimerStart.wav");
		timerHalf = Assets.getSound("sounds/TimerHalf.wav");
		timerOut = Assets.getSound("sounds/TimeOut.wav");
		gameWelcome = Assets.getSound("sounds/GameWelcome.wav");
		soundTransform = new SoundTransform(0.8, 0);
		
		if (Main.muteFX == false)
		{
			gameWelcome.play(0, 1, soundTransform);
		}
		
		if (Main.muteST == false)
		{
			channel = soundtrack.play(5, 100, soundTransform);
		}
		
		createTurnIndicator();
		
		createStaff();
		readFromDataBase();
		
		shuffleDeck(patientDeck);
		shuffleDeck(staffDeck);
		
		createHand();
		initPatients();
		displayPatients();
		displayTools();
		this.addEventListener(Event.ENTER_FRAME, canPlayerPlay);
		
		createTimer();
		
		solvedCounter();
	}
	
	function toolPrompt()
	{
		removeChild(toolButton);
		#if android
		lastUpdate = 999999;
		#else
		lastUpdate = null;
		#end
		removeEventListener( Event.ENTER_FRAME, update );
		
		toolRect = new Bitmap( Assets.getBitmapData("img/menu_tools.png") );
		toolRect.scaleX = 1.3 * universalScalingConstant;
		toolRect.scaleY = 1 * universalScalingConstant;
		
		toolRect.x = Lib.current.stage.stageWidth / 2 - toolRect.width / 2;
		toolRect.y = Lib.current.stage.stageHeight / 2 - toolRect.height / 2;
		
		addChild(toolRect);
		
		for (card in toolDeck)
		{
			card.y = Lib.current.stage.stageHeight / 2 - card.height / 2;
			addChild(card);
		}
		
		closeButton = new Button( 
			Assets.getBitmapData("img/Button.png"), 
			Assets.getBitmapData("img/Button_over.png"), 
			Assets.getBitmapData("img/Button_pressed.png"), 
			"Close", 
			onCloseClick );
		
		closeButton.x = (Lib.current.stage.stageWidth - closeButton.width) / 2;
		closeButton.y = 2 * Lib.current.stage.stageHeight / 3;
		addChild( closeButton );
	}
	
	function onCloseClick()
	{
		trace("close tools");
		for (card in toolDeck)
		{
			card.y = -300;
		}
		removeChild(toolRect);
		removeChild(closeButton);
		addChild(toolButton);
		
		lastUpdate = Lib.getTimer();
		addEventListener( Event.ENTER_FRAME, update );
	}
	
	function checkEndCondition()
	{
		//trace(patientsField.length);
		if (solved == 6)
		{
			if (Main.muteFX == false)
			{
				gameWin.play(0, 1, soundTransform);
			}
			
			trace("you win"); //Go to win screen
			setupWinScreen();
		}
		if (patientsField.length == 6)
		{
			if ( channel != null)
			{
				channel.stop();
			}
			trace("you lose"); //Go to losing screen
			Main.instance.loadScreen( ScreenType.Lose );
		}
	}
	
	function setupWinScreen()
	{
		this.removeEventListener(Event.ENTER_FRAME, update); //stop the timer
		
		_rect = new Sprite();
		_rect.graphics.beginFill(0xFFFFFF);
		_rect.graphics.drawRect(0,0,400,300);
		_rect.graphics.endFill();
		
		_rect.x = 200;
		_rect.y = 100;
		
		addChild(_rect);
		
		var textFormat:TextFormat = new TextFormat("Verdana", 24, 0xbbbbbb, true);
		textFormat.align = TextFormatAlign.LEFT;
		
		winTextField = new TextField();
		winTextField.defaultTextFormat = textFormat;
		winTextField.autoSize = TextFieldAutoSize.LEFT;
		winTextField.text = "You Won!";
		winTextField.x = _rect.width / 2 ;
		winTextField.y = _rect.y + 20;
		addChild(winTextField);
		
		continueButton = new Button( 
			Assets.getBitmapData("img/Button.png"), 
			Assets.getBitmapData("img/Button_over.png"), 
			Assets.getBitmapData("img/Button_pressed.png"), 
			"Continue Playing", 
			onContinueClicked );
		
		continueButton.x = continueButton.width;
		continueButton.y = _rect.height - continueButton.height;
		addChild( continueButton );
		
		exitButton = new Button( 
			Assets.getBitmapData("img/Button.png"), 
			Assets.getBitmapData("img/Button_over.png"), 
			Assets.getBitmapData("img/Button_pressed.png"), 
			"Exit", 
			onQuitClick );
		
		exitButton.x = (Lib.current.stage.stageWidth-exitButton.width) / 2;
		exitButton.y = Lib.current.stage.stageHeight / 3;
		addChild( exitButton );
	}
	
	function onContinueClicked() 
	{
		trace("continue");
		removeChild(_rect);
		removeChild(winTextField);
		removeChild(continueButton);
		removeChild(exitButton);
		
		initPatients();
		displayPatients();
		
		addEventListener(Event.ENTER_FRAME, update);
	}
	
	function solvedCounter()
	{
		var solvedTextFormat : TextFormat = new TextFormat("_sans", 15, 0xFFFFFF, true);
		solvedTextField.defaultTextFormat = solvedTextFormat;
		solvedTextField.width = 140;
		solvedTextField.height = 30;
		solvedTextField.x = 30;
		solvedTextField.y = 30;
		solvedTextField.selectable = false;
		solvedTextField.text = "patients solved: " + solved;
		addChild(solvedTextField);
	}
	
	private function createTimer() 
	{
		// create and position the progres bar. (Width, Height, 
		timerBar = new Timer( Math.floor(2*Lib.current.stage.stageWidth/3), 15 * universalScalingConstant, 4 * universalScalingConstant );
		timerBar.x = Lib.current.stage.stageWidth / 2 - Lib.current.stage.stageWidth / 3;
		timerBar.y = Lib.current.stage.stageHeight / 4.5;
		addChild( timerBar );
		
		// set the 'lastUpdate' for the first time
		lastUpdate = Lib.getTimer();
		addEventListener( Event.ENTER_FRAME, update );
		
		// Remembers the player who is supposed to be playing)
		lastTurn = currentTurn;
	}
	
	/**
	 * Event handler for the Event.ENTER_FRAME event
	 * 
	 * 
	 * @param event 	The Event instance
	 */
	function update( event:Event )
	{
		// calculate time passed since last update in milliseconds
		var now:Int = Lib.getTimer();
		var msPassed:Int = now - lastUpdate;
		lastUpdate = now;
		
		// subtract time passed from the currentTime variable
		currentTime -= msPassed;
		
		checkEndCondition();
		
		checkForNoCards();
		
		if (currentTime == maxTime)
		{
			if (Main.muteFX == false)
			{
				timerStart.play(0, 1, soundTransform);
				
			}
		}
		
		if (halfPlayed == false)
		{
			if (currentTime >= 7490 && currentTime <= 7510)
			{
				halfPlayed = true;
				if (Main.muteFX == false)
				{
					timerHalf.play(0, 1, soundTransform);
					
				}
			}
		}
		
		// if currentTime is less than or equal to zero the time is up. Reset the timer
		if( currentTime <= 0 )
		{	
			halfPlayed = false;
			
			if (Main.muteFX == false)
			{
				timerOut.play(0, 1, soundTransform);
				
			}
			
			// Resets the time
			currentTime = maxTime + currentTime;
			
			for (player in players)
			{
				if (player.selected.length == 1)
				{
					var staffCard : StaffCard = player.selected[0];
					
					//deselect the card
					player.selected.remove(staffCard);
					staffCard.scaleX = staffCard.scaleY = 1;
				}
			}
			
			if ( thiscard != null)
			{
				if ( thiscard.x != thiscard.originalX && thiscard.y != thiscard.originalY)
				{
					thiscard.x = thiscard.originalX;
					thiscard.y = thiscard.originalY;
				}
			}
			goNextTurn();	
			
		}
		
		//If a player ends his turn, resets timer.
		if (lastTurn != currentTurn)
		{
			currentTime = maxTime;
			lastTurn = currentTurn;
		}
		
		
		// calculate the percentage (between 0 and 1) to update the bar
		timerBar.setValue( currentTime / maxTime );
	}
	
	function checkForNoCards()
	{
		for (player in players)
		{
			if (currentTurn == player.id && player.cardsInHand.length < 1)
			{
				currentTime = 0;
			}
		}
	}
	
	function canPlayerPlay(e:Event)
	{
		for (player in players)
		{
			if (currentTurn == player.id)
			{
				player.turn = true;
				displayTurnIndicator(player.id);
			}
			else
			{
				player.turn = false;
			}
		}
		
		solvedTextField.text = "patients solved: " + solved;
	}
	
	function createTurnIndicator() 
	{
		var turnIndicator:BitmapData = Assets.getBitmapData( "img/Indicator_Turn.png" );
		turnI = new Bitmap( turnIndicator );
		turnI.scaleX = turnI.scaleY = 0.1 * universalScalingConstant;
		
		var turnDouble:BitmapData = Assets.getBitmapData("img/Indicator_Double.png");
		turnD = new Bitmap( turnDouble );
		turnD.scaleX = turnD.scaleY = 0.1 * universalScalingConstant;
	}
	
	function displayTurnIndicator(id:Int)
	{
		removeChild(turnI);
		removeChild(turnD);
		
		if (id == 1)
		{
			turnI.x = Lib.current.stage.stageWidth / 2;
			turnI.y = Lib.current.stage.stageHeight / 4 * 3;
			turnI.rotation = 0;
		}
		if (id == 2)
		{
			turnI.x = Lib.current.stage.stageWidth / 6 * 5;
			turnI.y = Lib.current.stage.stageHeight / 2;
			turnI.rotation = 270;
		}
		if (id == 3)
		{
			turnI.x = Lib.current.stage.stageWidth / 2;
			turnI.y = Lib.current.stage.stageHeight / 4;
			turnI.rotation = 180;
		}
		if (id == 4)
		{
			turnI.x = Lib.current.stage.stageWidth / 6;
			turnI.y = Lib.current.stage.stageHeight / 2;
			turnI.rotation = 90;
		}
		
		addChild(turnI);
		
		if (id == doubleTurn)
		{
			turnD.x = turnI.x;
			turnD.y = turnI.y;
			turnD.rotation = turnI.rotation;
			
			addChild(turnD);
		}
	}
	
	function displayALLPrompt()
	{
		assignRect = new Bitmap(  Assets.getBitmapData( "img/menu_staff.png" ) );
		assignRect.scaleX = 1.3 * universalScalingConstant;
		assignRect.scaleY = 1 * universalScalingConstant;
		
		assignRect.x = Lib.current.stage.stageWidth / 2 - assignRect.width / 2;
		assignRect.y = Lib.current.stage.stageHeight / 2 - assignRect.height / 2;
		
		addChild(assignRect);
		
		var promptTextFormat:TextFormat = new TextFormat("Verdana", 48, 0x3b5572, true);
		var buttonTextFormat:TextFormat = new TextFormat("Verdana", 32, 0x3b5572, true);
		promptTextFormat.align = TextFormatAlign.CENTER;
		buttonTextFormat.align = TextFormatAlign.CENTER;
		
		allTextField = new TextField();
		allTextField.defaultTextFormat = promptTextFormat;
		allTextField.autoSize = TextFieldAutoSize.CENTER;
		allTextField.text = "Who do you assign this to?";
		allTextField.x = Lib.current.stage.stageWidth / 2 - allTextField.width/2 ;
		allTextField.y = assignRect.y + assignRect.height/12;
		addChild(allTextField);
		
		allPromptButtons = new Array<TextField>();
		
		var iToString : String = "";
		
		for (i in 0...4)
		{
			switch (i) {
				case 0: iToString = "Doctor";
				case 1: iToString = "Nurse";
				case 2: iToString = "Management";
				case 3: iToString = "CNA";
			}
			
			var promptButton : TextField = new TextField();
			
			promptButton.defaultTextFormat = buttonTextFormat;
			promptButton.autoSize = TextFieldAutoSize.CENTER;
			promptButton.text = iToString;
			promptButton.x = Lib.current.stage.stageWidth/2 - promptButton.width/2;
			promptButton.y = allTextField.y + allTextField.height * 1.4 + 50 * i;
			promptButton.scaleX = promptButton.scaleY = 1 * universalScalingConstant;
			
			promptButton.addEventListener(MouseEvent.CLICK, promptButtonClicked);
			
			allPromptButtons.push(promptButton);
			addChild(promptButton);
		}
	}
	
	function promptButtonClicked(e:MouseEvent)
	{
		var clickedButtonIndex:Int = allPromptButtons.indexOf(cast e.currentTarget);
		trace(clickedButtonIndex);
		trace(staffValue);
		
		switch(clickedButtonIndex){
			case 0: card.assignStaffCard("D", staffValue);
			case 1: card.assignStaffCard("N", staffValue); 
			case 2: card.assignStaffCard("M", staffValue); 
			case 3: card.assignStaffCard("H", staffValue);
		}
		removeALLPrompt();
		
		if (Std.string(Type.typeof(thiscard)) == "PatientCard")
		{
			thiscard.x = thiscard.originalX;
			thiscard.y = thiscard.originalY;
		}
		thiscard = null;
		goNextTurn();
	}
	
	function removeALLPrompt()
	{
		//remove the if statement? It seems redundant.
		if (_rect != null || assignRect != null)
		{
			for (textField in allPromptButtons)
			{
				removeChild(textField);
			}
			//removeChild(_rect);
			removeChild(assignRect);
			//removeChild(toolRect);
			removeChild(allTextField);
		}
		//goNextTurn();
	}
	
	private function patientClicked(e:Event):Void
	{
		for (player in players)
		{
			if (player.turn)
			{
				card = cast (e.currentTarget);
				thiscard = card;
				
				if (boughtTool.length == 1 && boughtTool[0].type == card.equipment)
				{
					if (Main.muteFX == false)
					{
						assignTool.play(0, 1, soundTransform);
						
					}
					card.equipmentBought = true;
					card.assignStaffCard("Tool", 0);
					boughtTool[0].restoreDefaults();
					boughtTool.pop();
					trace("eqm bought");
				}
				
				var staffCard : StaffCard;
				
				if (player.selected.length == 1)
				{
					if (Main.muteFX == false)
					{
						playCard.play(0, 1, soundTransform);
						
					}
					staffCard = player.selected.pop();
					player.removeCard(staffCard);
					var type : String = staffCard.type;
					staffValue = staffCard.num;
					
					card.assignStaffCard(type, staffValue);
					if (type == "ALL") 
					{
						displayALLPrompt();
						thiscard.x = assignRect.x + assignRect.width / 4;
						thiscard.y = assignRect.y + assignRect.height / 1.8;
						addChild(card);
						
					}
					else goNextTurn();
				} 
			}
		}
	}
	
	private function toolClicked(e:Event):Void
	{
		for (player in players)
		{
			if (player.turn)
			{
				card = cast (e.currentTarget);
				
				var staffCard : StaffCard;
				
				if (player.selected.length == 1)
				{
					staffCard = player.selected.pop();
					player.removeCard(staffCard);
					var type : String = staffCard.type;
					staffValue = staffCard.num;
					
					card.assignStaffCard(type, staffValue);
					if (type == "ALL") displayALLPrompt();
					else goNextTurn();
					
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
			card.x = Lib.current.stage.stageWidth / 2 + posX;
			card.y = -300;
			posX += card.width + 10;
		}
		
		toolButton = new Button( 
			Assets.getBitmapData("img/Button_tools.png"),
			Assets.getBitmapData("img/Button_tools.png"), 
			Assets.getBitmapData("img/Button_tools.png"), 
			"", 
			toolPrompt );
			
			toolButton.scaleX = toolButton.scaleY = 0.4;
			
		toolButton.x = (Lib.current.stage.stageWidth - toolButton.width) / 2;
		toolButton.y = Lib.current.stage.stageHeight / 3 - toolButton.height/2;
		addChild( toolButton );
	}
	
	function initPatients()
	{
		
		for (i in 0...4)//4
		{
			var card = patientDeck.pop();
			patientsField.push(card);
		}
		
	}
	
	function displayPatients()
	{
		var posX : Float = -patientsField.length * patientsField[0].width / 2;
		
		for (card in patientsField)
		{
			card.addEventListener(MouseEvent.CLICK, patientClicked);
			addChild(card);
			card.x = Lib.current.stage.stageWidth/2 + posX;
			card.y = Lib.current.stage.stageHeight / 2;
			card.originalX = card.x;
			card.originalY = card.y;
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
			#if android
			var patientdat = Sqlite.open(Main.DB_PATH);
			#else
			var patientdat = Sqlite.open("db/patientdata.db");
			#end
			var resultset = patientdat.request("SELECT * FROM patients WHERE rowid = " + i + ";");
			
			for (row in resultset)
			{
				var patient : PatientCard = new PatientCard(row.imgID, row.doctor, row.nurse, row.management, row.healthcare, row.equipment, row.reward, this);
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
			#if android
			var patientdat = Sqlite.open(Main.DB_PATH);
			#else
			var patientdat = Sqlite.open("db/patientdata.db");
			#end
			var resultset = patientdat.request("SELECT * FROM tools WHERE rowid = " + e + ";");
			
			for (row in resultset)
			{
				var tool : ToolCard = new ToolCard(row.imgID, row.doctor, row.nurse, row.management, row.healthcare, row.type, this);
				toolDeck.push(tool);
			}
			
			if ( e == 6)
			{
				patientdat.close();
			}
		}
		
	}

	function onQuitClick()
	{
		if ( channel != null)
		{
			channel.stop();
		}
		
		Main.instance.loadScreen( ScreenType.Menu );
	}
	
	/**
	 * The player with 
	 */
	function goNextTurn():Void 
	{
		if (doubleTurn == currentTurn)
		{
			doubleTurn = 0;
			currentTime = maxTime;
		}
		else
		{
			removeALLPrompt();
			currentTurn += 1;
			if (currentTurn == 5)
			{
				if (Main.muteFX == false)
				{
					startRound.play(0, 1, soundTransform);
				}
				
				roundsPassed++;
				trace("rounds passed = " + roundsPassed);
				currentTurn = 1;
			}
			
			if (roundsPassed == 2)
			{
				var card = patientDeck.pop();
				patientsField.push(card);
				displayPatients();
				
				roundsPassed = 0;
			}
		}
	}
	
	function createQuitButton():Void 
	{
		var toMenu:Button = new Button
		( 
			Assets.getBitmapData("img/Button.png"), 
			Assets.getBitmapData("img/Button_over.png"), 
			Assets.getBitmapData("img/Button_pressed.png"), 
			"quit", 
			onQuitClick 
		);
		toMenu.x = stage.stageWidth - (toMenu.width * 1.5);
		toMenu.y = stage.stageHeight - toMenu.height;
		toMenu.scaleX = toMenu.scaleY = 1 * universalScalingConstant;
		addChild( toMenu );
	}
	
	public function addCardAllPlayers()
	{
		var card : StaffCard;
		for (player in players)
		{
			var card = staffDeck.pop();
			player.addCard(card);
		}
	}
	

	public function addCardLeastPlayer()
	{
		var cards:Int = 0;
		var amount:Int = 0;
		var lowest:Int = 9;
		var n:Int = 9;
		
		//counting the amout of copies of the emptiest hand.
		for (player in players)
		{
			cards = player.cardsInHand.length;
			if (lowest == cards)
			{
				amount += 1;
			}
			
			if (lowest > cards)
			{
				lowest = cards;
				amount = 1;
			}
		}		
		
		if (amount > 1)
		{
			var tempPlayers:Array<Player> = new Array<Player>();
			for (player in players)
			{
				if (lowest == player.cardsInHand.length)
				{
					tempPlayers.push(player);
				}
			}
			
			while(n >= amount)
			{
				n = Std.int(Std.random(amount));
			}
			var card = staffDeck.pop();
			tempPlayers[n].addCard(card);
		}
		
		if (amount == 1)
		{
			for (player in players)
			{
				if (lowest == player.cardsInHand.length)
				{
					var card = staffDeck.pop();
					player.addCard(card);
				}
			}	
		}
	}
	
	/**
	 * Gives a staff 5 card to a random player.
	 */
	public function addStaff5RandomPlayer()
	{
		
		var n:Int = 4;
		while(n >= 4)
		{
			n = Std.int(Std.random(4));
		}
		var imgname : String = "img/Staff_" + 'ALL' + "_" + 5 + ".png";
		stCard = new StaffCard("ALL", 5, imgname);
		players[n].addCard(stCard);
	}
	
	
	override public function onDestroy()
	{
		
		if (channel != null)
		{
			channel.stop();
			channel = null;
		}
		removeEventListener(Event.ENTER_FRAME, update);
	}


}