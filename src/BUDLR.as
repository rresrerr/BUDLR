package
{
	import flash.display.StageDisplayState;
	import flash.events.Event;
	
	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	import org.flixel.FlxGame;

//	[SWF(width="480", height="400", backgroundColor="#000000")]
	[SWF(width="1920", height="1080", backgroundColor="#000000")]
//	[Frame(factoryClass="Preloader")]
	
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
			super(640,360,PlayState,3);
			
			FlxG.stage.displayState = StageDisplayState.FULL_SCREEN;
			FlxG.stage.addEventListener(Event.RESIZE, window_resized);
			window_resized();
		}
		
		private function window_resized(e:Event = null):void {
			
			// 2. Change the size of the Flixel game window
			//    We already changed the size of the Flash window, so now we need to update Flixel.
			//    Just update the FlxG dimensions to match the new stage dimensions from step 1
			FlxG.width = FlxG.stage.stageWidth / FlxCamera.defaultZoom;
			FlxG.height = FlxG.stage.stageHeight / FlxCamera.defaultZoom;
			
			// 3. Change the size of the Flixel camera
			//    Lastly, update the Flixel camera to match the new dimensions from the previous step
			//    This is so that the camera can see all of the freshly resized dimensions
//			FlxG.resetCameras(new FlxCamera(0, 0, FlxG.width, FlxG.height));
		}
	}
}