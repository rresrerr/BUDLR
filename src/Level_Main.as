package    {
		
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	import org.flixel.*;
	
	public class Level_Main extends Level{
	
		[Embed(source = '../data/background.png')] private var ImgBackground:Class;

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
		
		// HUD
		private var player1NumberText:FlxText;
		private var player2NumberText:FlxText;
		
		// Round End
		private var roundEnd:Boolean;
		private var roundEndContinueText:FlxText;
		private var roundEndText:FlxText;
		
		// Tiles
		public var tileMatrix:Array; 
		public const BOARD_TILE_WIDTH:uint = 11;
		public const BOARD_TILE_HEIGHT:uint = 9;
		
		// Consts
		public const MAX_TIME:uint = 60;
		public const CONTROL_UPDATE_TIME:int = 1.0;
		public const TEXT_COLOR:uint = 0xFFFFFFFF;
		
		public const DEBUG_CONTROLS:Boolean = false;
		
		public function Level_Main( group:FlxGroup ) {
			
			levelSizeX = 480;
			levelSizeY = 400;
			
			// HUD
			buildHUD();
			
			// Round end
			roundEnd = false;
			buildRoundEnd();
			
			// Load Data
			controlUpdateTimer = CONTROL_UPDATE_TIME;
			
			// Create tiles
			createTiles();
			
			// Create player 1
			player1 = new Player(FlxG.width*1/4,FlxG.height/2,tileMatrix);
			PlayState.groupPlayer.add(player1);
			player1.setTilePosition(0,0);
			
			// Create player 2
			player2 = new Player(FlxG.width*3/4,FlxG.height/2,tileMatrix);
			PlayState.groupPlayer.add(player2);
			player2.setTilePosition(BOARD_TILE_WIDTH-1,BOARD_TILE_HEIGHT-1);
			
			super();
		}
		
		private function createTiles():void {
			var startX:int = 64;
			var startY:int = 256;
			var offsetX:int = 32;
			var offsetY:int = -32;
			var type:int = 0;
			tileMatrix = new Array();
			
			var blockRow:Boolean = false;
			var blockColumn:Boolean = false;
			for( var x:int = 0; x < BOARD_TILE_WIDTH; x++ )
			{	
				var column:Array = new Array();
				for( var y:int = 0; y < BOARD_TILE_HEIGHT; y++ )
				{
					if( blockRow && blockColumn )
					{
						type = 1;
						blockRow = false;
					}
					else
					{
						type = 0;
						blockRow = true;
					}
					
					var tile:Tile = new Tile(type, startX + x*offsetX,  startY + y*offsetY, player1, player2);
					PlayState.groupTilemap.add(tile);
					column.push(tile);
				}
				
				if( blockColumn )
				{
					blockColumn = false;
				}
				else
				{
					blockColumn = true;
				}
				blockRow = false;
				
				tileMatrix.push(column);
			}
		}
		
		public function getTile( x:int, y:int ):FlxSprite {
			return tileMatrix[x][y];
		}
		
		private function buildHUD():void {
			
			var backgroundSprite:FlxSprite;
			backgroundSprite = new FlxSprite(0,0);
			backgroundSprite.loadGraphic(ImgBackground, true, true, levelSizeX, levelSizeY);	
			PlayState.groupBackground.add(backgroundSprite);
			
			player1NumberText = new FlxText(0, FlxG.height - 108, FlxG.width*1/2, "415-494-8532");
			player1NumberText.setFormat(null,16,TEXT_COLOR,"center");
			PlayState.groupForeground.add(player1NumberText);	
			
			player2NumberText = new FlxText(FlxG.width*1/2, FlxG.height - 108, FlxG.width*1/2, "415-494-8538");
			player2NumberText.setFormat(null,16,TEXT_COLOR,"center");
			PlayState.groupForeground.add(player2NumberText);	
			
			// Timer
			startTime = 1.0;
			endTime = 3.0;
			timer = MAX_TIME;
			timerText = new FlxText(0, FlxG.height - 48, FlxG.width, "0:00");
			timerText.setFormat(null,16,TEXT_COLOR,"center");
			timerText.scrollFactor.x = timerText.scrollFactor.y = 0;
			PlayState.groupBackground.add(timerText);
			
			// Points
			pointsText = new FlxText(0, 0, FlxG.width, "0");
			pointsText.setFormat(null,8,TEXT_COLOR,"center");
			pointsText.scrollFactor.x = pointsText.scrollFactor.y = 0;
			pointsText.alpha = 0;
			PlayState.groupBackground.add(pointsText);
			
			// Debug
			player1ControlText = new FlxText(0, FlxG.height - 64, FlxG.width*1/2, "");
			player1ControlText.setFormat(null,32,TEXT_COLOR,"center");
			player1ControlText.scrollFactor.x = player1ControlText.scrollFactor.y = 0;
			PlayState.groupBackground.add(player1ControlText);
			
			player2ControlText = new FlxText(FlxG.width*1/2, FlxG.height - 64, FlxG.width*1/2, "");
			player2ControlText.setFormat(null,32,TEXT_COLOR,"center");
			player2ControlText.scrollFactor.x = player2ControlText.scrollFactor.y = 0;
			PlayState.groupBackground.add(player2ControlText);
		}
			
		public function buildRoundEnd():void {
			roundEndContinueText = new FlxText(0, FlxG.height - 220, FlxG.width, "PRESS ANY KEY TO CONTINUE");
			roundEndContinueText.setFormat(null,16,TEXT_COLOR,"center");
			roundEndContinueText.scrollFactor.x = roundEndContinueText.scrollFactor.y = 0;	
			roundEndContinueText.visible = false;
			PlayState.groupForeground.add(roundEndContinueText);
			
			roundEndText = new FlxText(0, FlxG.height/2 - 64, FlxG.width, "ROUND OVER");
			roundEndText.setFormat(null,32,TEXT_COLOR,"center");
			roundEndText.scrollFactor.x = roundEndContinueText.scrollFactor.y = 0;	
			roundEndText.visible = false;
			PlayState.groupForeground.add(roundEndText);
		}
		
		private function updateSQLControls():void {
			
			var myLoader:URLLoader = new URLLoader();
			myLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
			myLoader.load(new URLRequest("http://travis.aristomatic.com/games/Distrupt/get-controls.php"));
			myLoader.addEventListener(Event.COMPLETE, onDataLoad);
			
			function onDataLoad(event:Event):void {
				var loader:URLLoader = URLLoader(event.target);

				for(var i:uint=0; i < loader.data.count; i++) {
					if( loader.data["player"+i] == 1 ) {
						player1ControlText.text = loader.data["control"+i];
						player1.processControl( loader.data["control"+i] );
					} else {
						player2ControlText.text = loader.data["control"+i];
						player2.processControl( loader.data["control"+i] );
					}
				}
			}
			
		}
		
		private function updateKeyboardControls():void {
			if(FlxG.keys.A)
				player1.processControl("Left");
			else if(FlxG.keys.D)
				player1.processControl("Right");
			else if(FlxG.keys.W)
				player1.processControl("Up");
			else if(FlxG.keys.S)	
				player1.processControl("Down");
			else if(FlxG.keys.E)
				player1.processControl("Bomb");
			
			if(FlxG.keys.LEFT)
				player2.processControl("Left");
			else if(FlxG.keys.RIGHT)
				player2.processControl("Right");
			else if(FlxG.keys.UP)
				player2.processControl("Up");
			else if(FlxG.keys.DOWN)	
				player2.processControl("Down");
			else if(FlxG.keys.M)
				player2.processControl("Bomb");
		}
		
		private function updateControls():void
		{
			if( controlUpdateTimer <= 0 )
			{
				player1.stop();
				player2.stop();
				
				controlUpdateTimer = CONTROL_UPDATE_TIME;
				if( !DEBUG_CONTROLS )
				{
					updateSQLControls();				
				}
				else
				{
					updateKeyboardControls();
				}
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
			
			super.update();
		}
		
		private function showEndPrompt():void 
		{
			PlayState._currLevel.player1.roundOver = true;
			PlayState._currLevel.player2.roundOver = true;
			roundEndText.visible = true;
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
