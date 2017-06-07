package;
import openfl.display.Sprite;
import screens.GameScreen;

/**
 * ...
 * @author vincent van de vegte
 */
class Rewards extends Sprite
{
	var sR:String;
	public var main:GameScreen;
	
	public function new(rewards:String, gs:GameScreen) 
	{
		super();
		main = gs;
		standardReward();
		
		sR = rewards;
		switch (sR)
		{
			case 'ALL +1':
				standardReward();
				trace("SP reward 1");
			case 'LEAST +1':
				specialReward2();
			case 'RANDOM s5':
				specialReward3();
			case 'RANDOM *2':
				specialReward4();
		}
	}
	

	
	function standardReward() 
	{
		main.addCardAllPlayers();
	}
	
	function specialReward2() 
	{
		main.addCardLeastPlayer();
		
	}
	
	function specialReward3() 
	{
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