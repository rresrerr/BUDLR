package
{
	import org.flixel.*; 
	[SWF(width="480", height="400", backgroundColor="#000000")] 
	
	public class DisruptSF2012 extends FlxGame
	{
		public static var currLevelIndex:uint = 0;
		
		public function DisruptSF2012()
		{
			super(480,400,PlayState,1);
		}
	}
}