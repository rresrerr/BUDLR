package
{
	import org.flixel.*; 
//	[SWF(width="480", height="400", backgroundColor="#000000")]
	[SWF(width="960", height="760", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]
	
	public class BUDLR extends FlxGame
	{
		public static var currLevelIndex:uint = 0;
		public static var player1Ready:Boolean = false;
		public static var player2Ready:Boolean = false;
		public static var player3Ready:Boolean = false;
		public static var player4Ready:Boolean = false;
		
		public static var player1PhoneNumber:String = "";
		public static var player2PhoneNumber:String = "";
		public static var player3PhoneNumber:String = "";
		public static var player4PhoneNumber:String = "";
		
		public function BUDLR()
		{
//			super(480,400,PlayState,1);
			super(480,400,PlayState,2);
		}
	}
}