package
{
	import org.flixel.*; 
//	[SWF(width="480", height="400", backgroundColor="#000000")]
	[SWF(width="960", height="800", backgroundColor="#000000")]
	
	public class DisruptSF2012 extends FlxGame
	{
		public static var currLevelIndex:uint = 0;
		public static var player1Ready:Boolean = false;
		public static var player2Ready:Boolean = false;
		public static var player3Ready:Boolean = false;
		public static var player4Ready:Boolean = false;
		
		public function DisruptSF2012()
		{
//			super(480,400,PlayState,1);
			super(480,400,PlayState,2);
		}
	}
}