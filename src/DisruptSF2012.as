package
{
	import org.flixel.*; 
	[SWF(width="640", height="480", backgroundColor="#000000")] 
	
	public class DisruptSF2012 extends FlxGame
	{
		public static var currLevelIndex:uint = 0;
		
		public function DisruptSF2012()
		{
			super(320,240,PlayState,2);
		}
	}
}