package    {
		
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	import org.flixel.*;
	
	public class Level_Main extends Level{
	
		// Points
		private var pointsText:FlxText;

		// Timer
		public var startTime:Number;
		public var endTime:Number;
		private var timerText:FlxText;
		private var controlUpdateTimer:Number;
		
		// Debug
		private var player1ControlText:FlxText;
		private var player2ControlText:FlxText;
		
		// Round End
		private var roundEnd:Boolean;
		private var roundEndContinueText:FlxText;
		private var roundEndPointsText:FlxText;
		
		// Consts
		public const MAX_TIME:uint = 10;
		public const CONTROL_UPDATE_TIME:uint = 1.0;
		public const TEXT_COLOR:uint = 0xFF555555;
		
		public function Level_Main( group:FlxGroup ) {
			
			levelSizeX = 320;
			levelSizeY = 240;

			// Create player
			player = new Player(FlxG.height*1/4,FlxG.height/2);
			PlayState.groupPlayer.add(player);

			// Create enemy
			enemy = new Enemy(FlxG.height*3/4,FlxG.height/2);
			PlayState.groupPlayer.add(enemy);
			
			// Timer
			startTime = 1.0;
			endTime = 3.0;
			timer = MAX_TIME;
			timerText = new FlxText(0, 0, FlxG.width, "0:00");
			timerText.setFormat(null,16,TEXT_COLOR,"left");
			timerText.scrollFactor.x = timerText.scrollFactor.y = 0;
			PlayState.groupBackground.add(timerText);
			
			// Points
			pointsText = new FlxText(0, 0, FlxG.width, "0");
			pointsText.setFormat(null,8,TEXT_COLOR,"center");
			pointsText.scrollFactor.x = pointsText.scrollFactor.y = 0;
			PlayState.groupBackground.add(pointsText);
			
			// Debug
			player1ControlText = new FlxText(0, FlxG.height/2, FlxG.width, "");
			player1ControlText.setFormat(null,8,TEXT_COLOR,"left");
			player1ControlText.scrollFactor.x = player1ControlText.scrollFactor.y = 0;
			PlayState.groupBackground.add(player1ControlText);

			player2ControlText = new FlxText(0, FlxG.height/2, FlxG.width, "");
			player2ControlText.setFormat(null,8,TEXT_COLOR,"right");
			player2ControlText.scrollFactor.x = player2ControlText.scrollFactor.y = 0;
			PlayState.groupBackground.add(player2ControlText);
			
			// Round end
			roundEnd = false;
			buildRoundEnd();
			
			// Load Data
			controlUpdateTimer = CONTROL_UPDATE_TIME;
			
			super();
		}
			
		public function buildRoundEnd():void {
			roundEndContinueText = new FlxText(0, FlxG.height - 16, FlxG.width, "PRESS ANY KEY TO CONTINUE");
			roundEndContinueText.setFormat(null,8,TEXT_COLOR,"center");
			roundEndContinueText.scrollFactor.x = roundEndContinueText.scrollFactor.y = 0;	
			roundEndContinueText.visible = false;
			PlayState.groupForeground.add(roundEndContinueText);
			
			roundEndPointsText = new FlxText(0, FlxG.height - 48, FlxG.width, "0");
			roundEndPointsText.setFormat(null,16,TEXT_COLOR,"center");
			roundEndPointsText.scrollFactor.x = roundEndContinueText.scrollFactor.y = 0;	
			roundEndPointsText.visible = false;
			PlayState.groupForeground.add(roundEndPointsText);
		}
		
		private function updateSQLData():void {
			
			var myLoader:URLLoader = new URLLoader();
			myLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
			myLoader.load(new URLRequest("http://travis.aristomatic.com/games/Distrupt/get-controls.php"));
			myLoader.addEventListener(Event.COMPLETE, onDataLoad);
			
			function onDataLoad(event:Event):void {
				var loader:URLLoader = URLLoader(event.target);

				for(var i:uint=0; i < loader.data.count; i++) {
					if( loader.data["player"+i] == 1 ) {
						player1ControlText.text = loader.data["control"+i];
					} else {
						player2ControlText.text = loader.data["control"+i];			
					}

				}
			}
			
		}
		
		private function updateControls():void
		{
			if( controlUpdateTimer <= 0 )
			{
				controlUpdateTimer = CONTROL_UPDATE_TIME;
				updateSQLData();				
			}
			else
			{
				controlUpdateTimer -= FlxG.elapsed;
			}
		}
		
		private function updateTimer():void
		{
			// Timer
			var minutes:uint = timer/60;
			var seconds:uint = timer - minutes*60;
			if( startTime <= 0 )
			{
				timer -= FlxG.elapsed;
			}
			else
			{
				startTime -= FlxG.elapsed;
			}
			
			// Check round end
			if( timer <= 0 )
			{
				showEndPrompt();
				if( endTime <= 0 )
				{
					checkAnyKey();					
				}
				else
				{
					endTime -= FlxG.elapsed;
				}
				return;
			}
			
			// Update timer text
			if( seconds < 10 )
				timerText.text = "" + minutes + ":0" + seconds;
			else
				timerText.text = "" + minutes + ":" + seconds;
		}
		
		override public function update():void
		{	
			// Timer
			updateTimer();
			
			// Controls
			updateControls();

			// Update points text
			pointsText.text = "" + points + " (" + PlayState._currLevel.multiplier + "x)";
			roundEndPointsText.text = "" + points;
			
			super.update();
		}
		
		private function showEndPrompt():void 
		{
			PlayState._currLevel.player.roundOver = true;
			roundEndPointsText.visible = true;
		}
		
		private function checkAnyKey():void 
		{
			roundEndContinueText.visible = true;
			if (FlxG.keys.any())
			{
				roundEnd = true;
			}		
		}
		
		override public function nextLevel():Boolean
		{
			if( roundEnd )
			{
				return true;
			}
			return false;
		}
	}
}
