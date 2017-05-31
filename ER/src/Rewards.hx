package;

/**
 * ...
 * @author vincent van de vegte
 */
class Rewards 
{
	var specialReward:String;
	
	public function new(rewards:String) 
	{
		standardReward();
		
		specialReward = rewards;
		switch (specialReward)
		{
			case 'NA':
				trace("noSpecialReward");
			case '1':
				specialReward1();
			case '2':
				specialReward2();
		}
	}
	
	function standardReward() 
	{
		trace("Reward");
	}
	
	function specialReward1() 
	{
		trace("SpecialReward1");
	}
	
	function specialReward2() 
	{
		trace("SpecialReward2");
	}
}