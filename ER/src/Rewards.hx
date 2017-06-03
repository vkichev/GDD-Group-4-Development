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
		main.addStaffAllPlayers();
	}
	
	function specialReward1() 
	{
		trace("SpecialReward1");
	}
	
	function specialReward2() 
	{
		trace("SpecialReward2");

	}
	
	function specialReward3() 
	{
		
	}
		
	function specialReward4() 
	{
		main.doubleTurn = Std.int(Std.random(4)+1);
		trace("doubleTurn player " +main.doubleTurn);
	}
}