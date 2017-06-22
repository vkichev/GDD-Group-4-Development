package;
import openfl.display.Sprite;
import openfl.events.SampleDataEvent;
import screens.GameScreen;

import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.media.SoundTransform;
import openfl.Assets;

/**
 * The class that handles all rewards. Gets called from the PatientCard class, once a patientcard is cleared. 
 * @author vincent van de vegte
 */
class Rewards extends Sprite
{
	var getCard : Sound;
	var taskReward : Sound;
	var soundTransform : SoundTransform;
	
	var sR:String;
	public var main:GameScreen;
	
	/**
	 * The new function will always give a standard reward (ALL +1) and will then test for a special reward with a case switcher.
	 * @param	rewards The type of specialreward
	 * @param	gs allowes changing things in the gamescreen clase through the patientcard class.
	 */
	public function new(rewards:String, gs:GameScreen) 
	{
		getCard = Assets.getSound("sounds/GetCard.wav");
		taskReward = Assets.getSound("sounds/TaskReward.wav");
		soundTransform = new SoundTransform(1, 0);
			
		super();
		main = gs;
		standardReward();
		
		sR = rewards;
		switch (sR)
		{
			case 'ALL +1':
				specialReward1();
				trace("SP reward 1");
			case 'LEAST +1':
				specialReward2();
			case 'RANDOM s5':
				specialReward3();
			case 'RANDOM *2':
				specialReward4();
		}
	}
	

	/**
	 * The standartreward function and the specialrewards function will call their reward function in gamescreen and a sound function.
	 */
	function standardReward() 
	{
		if (Main.muteFX == false)
		{
			getCard.play(0, 1, soundTransform);
		}
		
		main.addCardAllPlayers();
	}
	
	function specialReward1() 
	{
		if (Main.muteFX == false)
		{
			taskReward.play(0, 1, soundTransform);
		}
		
		main.addCardAllPlayers();
	}
	
	function specialReward2() 
	{
		if (Main.muteFX == false)
		{
			taskReward.play(0, 1, soundTransform);
		}
		
		main.addCardLeastPlayer();
		
	}
	
	function specialReward3() 
	{
		if (Main.muteFX == false)
		{
			taskReward.play(0, 1, soundTransform);
		}
		
		main.addStaff5RandomPlayer();
	}
	
	function specialReward4() 
	{
		var n:Int = 4;
		
		while(n >= 4)
		{
			n = Std.int(Std.random(4));
		}
		
		main.doubleTurn = n;
		trace("doubleTurn player " +main.doubleTurn);
	}
}