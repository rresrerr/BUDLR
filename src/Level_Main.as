package    {
		
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	import org.flixel.*;
	
	public class Level_Main extends Level{
	
		[Embed(source = '../data/background.png')] private var ImgBackground:Class;
		[Embed(source = '../data/roundover.png')] private var ImgRoundEnd:Class;
		
		[Embed(source = '../data/player-blue-corner.png')] private var ImgBlueCorner:Class;
		[Embed(source = '../data/player-green-corner.png')] private var ImgGreenCorner:Class;
		[Embed(source = '../data/player-red-corner.png')] private var ImgRedCorner:Class;
		[Embed(source = '../data/player-yellow-corner.png')] private var ImgYellowCorner:Class;
		
		[Embed(source = '../data/Audio/song.mp3')] private var SndSong:Class;
		[Embed(source = '../data/Audio/intro.mp3')] private var SndIntro:Class;
		
		// Points
		private var pointsText:FlxText;

		// Timer
		public var startTime:Number = 1.0;
		public var endTime:Number = 5.0;
		private var timerText:FlxText;
		private var controlUpdateTimer:Number;
		private var player1ControlArray:Array; 
		private var player2ControlArray:Array; 
		private var player3ControlArray:Array; 
		private var player4ControlArray:Array; 
		
		// Debug
		private var player1ControlText:FlxText;
		private var player2ControlText:FlxText;
		private var player3ControlText:FlxText;
		private var player4ControlText:FlxText;
		
		// Round End
		private var roundEnd:Boolean;
		private var roundEndContinueText:FlxText;
		private var roundEndPlayerText:FlxText;
		private var roundEndForeground:FlxSprite;
		
		// Round Start
		private var roundStart:Boolean = false;
		private var roundStartContinueText:FlxText;
		private var roundStartPlayerText:FlxText;
		private var roundStartExampleText:FlxText;
		private var roundStartForeground:FlxSprite;

		// Tiles
		public var tileMatrix:Array; 
		public const BOARD_TILE_WIDTH:uint = 11;
		public const BOARD_TILE_HEIGHT:uint = 9;
		
		private var roundEndSound:Boolean = false;
		
		// Consts
		public const MAX_TIME:uint = 120;
		public const CONTROL_UPDATE_TIME:Number = 0.25;
		public const TEXT_COLOR:uint = 0xFFFFFFFF;
		public const CONTINUE_COLOR:uint = 0x00C0F8;
		
		public const DEBUG_CONTROLS:Boolean = false;
		
		public function Level_Main( group:FlxGroup ) {
			
			levelSizeX = 480;
			levelSizeY = 400;
			
			// HUD
			buildHUD();
			
			// Round start
			roundStart = true;
			FlxG.play(SndIntro,0.4);
			FlxG.playMusic(SndSong,0.6);
			
			buildRoundStart();
			
			// Round end
			roundEnd = false;
			buildRoundEnd();
			
			// Load Data
			controlUpdateTimer = CONTROL_UPDATE_TIME;
			
			// Create tiles
			createTiles();
			
			// Create control array
			player1ControlArray = new Array();
			player2ControlArray = new Array();
			player3ControlArray = new Array();
			player4ControlArray = new Array();
			
			var cornerSprite:FlxSprite;
			
			// Create player 1
			if( BUDLR.player1Ready )
			{
				player1 = new Player(1, FlxG.width*1/4,FlxG.height/2,tileMatrix,this);
				PlayState.groupPlayer.add(player1);
				player1.setTilePosition(0,0);
			
//				cornerSprite = new FlxSprite(0,FlxG.height - 118);
//				cornerSprite.loadGraphic(ImgBlueCorner, true, true, 196, 100);	
//				PlayState.groupBackground.add(cornerSprite);
			}
			
			// Create player 2
			if( BUDLR.player2Ready )
			{
				player2 = new Player(2, FlxG.width*3/4,FlxG.height/2,tileMatrix,this);
				PlayState.groupPlayer.add(player2);
				player2.player2SetFacing();
				player2.setTilePosition(BOARD_TILE_WIDTH-1,0);
				
//				cornerSprite = new FlxSprite(FlxG.width - 196,FlxG.height - 118);
//				cornerSprite.loadGraphic(ImgYellowCorner, true, true, 196, 100);	
//				PlayState.groupBackground.add(cornerSprite);
			}
			
			// Create player 3
			if( BUDLR.player3Ready )
			{
				player3 = new Player(3, FlxG.width*1/4,FlxG.height/2,tileMatrix,this);
				PlayState.groupPlayer.add(player3);
				player3.setTilePosition(0,BOARD_TILE_HEIGHT-1);
				
//				cornerSprite = new FlxSprite(0,19);
//				cornerSprite.loadGraphic(ImgRedCorner, true, true, 196, 100);	
//				PlayState.groupBackground.add(cornerSprite);
			}

			// Create player 4
			if( BUDLR.player4Ready )
			{
				player4 = new Player(4, FlxG.width*3/4,FlxG.height/2,tileMatrix,this);
				PlayState.groupPlayer.add(player4);
				player4.player2SetFacing();
				player4.setTilePosition(BOARD_TILE_WIDTH-1,BOARD_TILE_HEIGHT-1);
				
//				cornerSprite = new FlxSprite(FlxG.width - 196,19);
//				cornerSprite.loadGraphic(ImgGreenCorner, true, true, 196, 100);	
//				PlayState.groupBackground.add(cornerSprite);
			}
			
			super();
		}
		
		private function createTiles():void {
			var startX:int = 64;
			var startY:int = 308;
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
					if( blockColumn && blockRow )
					{
						type = 1;
						blockColumn = false;
					}
					else
					{
						type = 0;
						blockColumn = true;
					}
					
					var tile:Tile = new Tile(type, startX + x*offsetX,  startY + y*offsetY);
					
					if( type == 1 )
						PlayState.groupBackground.add(tile);
					else
						PlayState.groupTiles.add(tile);
					
					column.push(tile);
				}
				
				if( blockRow )
				{
					blockRow = false;
				}
				else
				{
					blockRow = true;
				}
				blockColumn = false;
				
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
			
			// Timer
			timer = MAX_TIME;
			timerText = new FlxText(0, 14, FlxG.width, "0:00");
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
			player1ControlText = new FlxText(0, FlxG.height - 22, FlxG.width*1/2, "");
			player1ControlText.setFormat(null,16,0x19b6d8,"left");
			player1ControlText.scrollFactor.x = player1ControlText.scrollFactor.y = 0;
			PlayState.groupBackground.add(player1ControlText);
			
			player2ControlText = new FlxText(FlxG.width*1/2, FlxG.height - 22, FlxG.width*1/2, "");
			player2ControlText.setFormat(null,16,0xff9a00,"right");
			player2ControlText.scrollFactor.x = player2ControlText.scrollFactor.y = 0;
			PlayState.groupBackground.add(player2ControlText);
			
			player3ControlText = new FlxText(0, -1, FlxG.width*1/2, "");
			player3ControlText.setFormat(null,16,0xcb3e4e,"left");
			player3ControlText.scrollFactor.x = player3ControlText.scrollFactor.y = 0;
			PlayState.groupBackground.add(player3ControlText);
			
			player4ControlText = new FlxText(FlxG.width*1/2, -1, FlxG.width*1/2, "");
			player4ControlText.setFormat(null,16,0x11d27a,"right");
			player4ControlText.scrollFactor.x = player4ControlText.scrollFactor.y = 0;
			PlayState.groupBackground.add(player4ControlText);
		}
		
		public function buildRoundStart():void {
			roundStartForeground = new FlxSprite(0,0);
			roundStartForeground.loadGraphic(ImgRoundEnd, true, true, levelSizeX, levelSizeY);
			roundStartForeground.scrollFactor.x = roundStartForeground.scrollFactor.y = 0;
			roundStartForeground.visible = true;
			PlayState.groupForeground.add(roundStartForeground);
			
			roundStartContinueText = new FlxText(0, FlxG.height - 160, FlxG.width, "PRESS ANY KEY TO START");
			roundStartContinueText.setFormat(null,16,CONTINUE_COLOR,"center");
			roundStartContinueText.scrollFactor.x = roundStartContinueText.scrollFactor.y = 0;	
			roundStartContinueText.visible = false;
			PlayState.groupForeground.add(roundStartContinueText);
			
			roundStartPlayerText = new FlxText(0, FlxG.height/2 - 72, FlxG.width, "B U D L R");
			roundStartPlayerText.setFormat(null,64,TEXT_COLOR,"center");
			roundStartPlayerText.scrollFactor.x = roundStartPlayerText.scrollFactor.y = 0;	
			roundStartPlayerText.visible = true;
			PlayState.groupForeground.add(roundStartPlayerText);

			roundStartExampleText = new FlxText(0, FlxG.height/2 + 10, FlxG.width, "EXAMPLE SMS: \"uubrrddll\"");
			roundStartExampleText.setFormat(null,16,TEXT_COLOR,"center");
			roundStartExampleText.scrollFactor.x = roundStartExampleText.scrollFactor.y = 0;	
			roundStartExampleText.visible = true;
			PlayState.groupForeground.add(roundStartExampleText);
		}
			
		public function buildRoundEnd():void {
			roundEndForeground = new FlxSprite(0,0);
			roundEndForeground.loadGraphic(ImgRoundEnd, true, true, levelSizeX, levelSizeY);
			roundEndForeground.scrollFactor.x = roundEndForeground.scrollFactor.y = 0;
			roundEndForeground.visible = false;
			PlayState.groupForeground.add(roundEndForeground);
			
			roundEndContinueText = new FlxText(0, FlxG.height - 160, FlxG.width, "PRESS ANY KEY TO CONTINUE");
			roundEndContinueText.setFormat(null,16,CONTINUE_COLOR,"center");
			roundEndContinueText.scrollFactor.x = roundEndContinueText.scrollFactor.y = 0;	
			roundEndContinueText.visible = false;
			PlayState.groupForeground.add(roundEndContinueText);
			
			roundEndPlayerText = new FlxText(0, FlxG.height/2 - 40, FlxG.width, "");
			roundEndPlayerText.setFormat(null,64,TEXT_COLOR,"center");
			roundEndPlayerText.scrollFactor.x = roundEndContinueText.scrollFactor.y = 0;	
			roundEndPlayerText.visible = false;
			PlayState.groupForeground.add(roundEndPlayerText);
		}
		
		private function updateSQLControls():void {
			
			var myLoader:URLLoader = new URLLoader();
			myLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
			myLoader.load(new URLRequest("http://travis.aristomatic.com/games/Distrupt/get-controls.php"));
			myLoader.addEventListener(Event.COMPLETE, onDataLoad);
			
			function onDataLoad(event:Event):void {
				var loader:URLLoader = URLLoader(event.target);

				var player1ControlString:String = "";
				var player2ControlString:String = "";
				var player3ControlString:String = "";
				var player4ControlString:String = "";
				for(var i:uint=0; i < loader.data.count; i++) {
					if( roundStart && timer > 0 )
					{
						if( loader.data["player"+i] == 1 && player1 && !player1.hit ) {
							player1ControlArray[player1ControlArray.length] = loader.data["control"+i];
							player1ControlString = player1ControlString + loader.data["control"+i].charAt(0).toUpperCase();
						} else if( loader.data["player"+i] == 2 && player2 && !player2.hit ) {
							player2ControlArray[player2ControlArray.length] = loader.data["control"+i];
							player2ControlString = player2ControlString + loader.data["control"+i].charAt(0).toUpperCase();
						} else if( loader.data["player"+i] == 3 && player3 && !player3.hit ) {
							player3ControlArray[player3ControlArray.length] = loader.data["control"+i];
							player3ControlString = player3ControlString + loader.data["control"+i].charAt(0).toUpperCase();
						} else if( loader.data["player"+i] == 4 && player4 && !player4.hit ) {
							player4ControlArray[player4ControlArray.length] = loader.data["control"+i];
							player4ControlString = player4ControlString + loader.data["control"+i].charAt(0).toUpperCase();
						}
					}
					else
					{
//						if( loader.data["player"+i] == 1 && loader.data["control"+i] == "Go" )
//							roundStart = true;
//						if( loader.data["player"+i] == 2 && loader.data["control"+i] == "Go" )
//							roundStart = true;
//						if( loader.data["player"+i] == 3 && loader.data["control"+i] == "Go" )
//							roundStart = true;
//						if( loader.data["player"+i] == 4 && loader.data["control"+i] == "Go" )
//							roundStart = true;
					}
				}
				
				if( player1ControlString != "" )
					player1ControlText.text = player1ControlString;
				if( player2ControlString != "" )
					player2ControlText.text = player2ControlString;
				if( player3ControlString != "" )
					player3ControlText.text = player3ControlString;
				if( player4ControlString != "" )
					player4ControlText.text = player4ControlString;
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
				if( player1 )
					player1.stop();
				
				if( player2 )
					player2.stop();
				
				if( player3 )
					player3.stop();
				
				if( player4 )
					player4.stop();
				
				controlUpdateTimer = CONTROL_UPDATE_TIME;
				if( !DEBUG_CONTROLS )
				{
					updateSQLControls();
					
					// Run control from array
					if( player1 && player1ControlArray.length > 0 )
					{
						player1.processControl( player1ControlArray[0] );
						player1ControlArray = player1ControlArray.shift(); 
					}
					
					if( player2 && player2ControlArray.length > 0 )
					{
						player2.processControl( player2ControlArray[0] );
						player2ControlArray = player2ControlArray.shift(); 
					}
					
					
					if( player3 && player3ControlArray.length > 0 )
					{
						player3.processControl( player3ControlArray[0] );
						player3ControlArray = player3ControlArray.shift(); 
					}
					
					if( player4 && player4ControlArray.length > 0 )
					{
						player4.processControl( player4ControlArray[0] );
						player4ControlArray = player4ControlArray.shift(); 
					}
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
			if( startTime <= 0 && roundStart )
			{
				timer -= FlxG.elapsed;
			}
			else
			{
				startTime -= FlxG.elapsed;
			}
			
			// Update timer text
			if( timer >= 0 )
			{
				if( seconds < 10 )
					timerText.text = "" + minutes + ":0" + seconds;
				else
					timerText.text = "" + minutes + ":" + seconds;
			}

//			// Check round Started
//			if( startTime <= 0 )
//			{
//				checkAnyKeyStart();					
//			}
//			else
//			{
//				startTime -= FlxG.elapsed;
//			}
			
			if( !roundStart )
			{
				return;
			}
			else
			{
				roundStartPlayerText.visible = false;
				roundStartExampleText.visible = false;
				roundStartForeground.visible = false;
				roundStartContinueText.visible = false;
			}
			
			// Check round end
			var player1Hit:Boolean = ( !player1 || player1.hit );
			var player2Hit:Boolean = ( !player2 || player2.hit );
			var player3Hit:Boolean = ( !player3 || player3.hit );
			var player4Hit:Boolean = ( !player4 || player4.hit );
			
			var player1Win:Boolean = ( player2Hit && player3Hit && player4Hit );
			var player2Win:Boolean = ( player1Hit && player3Hit && player4Hit );
			var player3Win:Boolean = ( player1Hit && player2Hit && player4Hit );
			var player4Win:Boolean = ( player1Hit && player2Hit && player3Hit );
			
			if( player1 && player1.hit )
				player1ControlText.text = "DEAD";
			if( player2 && player2.hit )
				player2ControlText.text = "DEAD";
			if( player3 && player3.hit )
				player3ControlText.text = "DEAD";
			if( player4 && player4.hit )
				player4ControlText.text = "DEAD";
			
			if( timer <= 0 || player1Win || player2Win || player3Win || player4Win )
			{
				// Music
				FlxG.music.stop();
				if( !roundEndSound )
				{	
					roundEndSound = true;
					FlxG.play(SndIntro,0.4);
				}
				
				if( player1Win )
				{
					player1ControlText.text = "WINNER";
					roundEndPlayerText.text = "BLUE WIN";
					roundEndPlayerText.color = 0x19b6d8;
				}
				else if( player2Win )
				{
					player2ControlText.text = "WINNER";
					roundEndPlayerText.text = "YELLO WIN";	
					roundEndPlayerText.color = 0xff9a00;
				}
				else if( player3Win )
				{
					player3ControlText.text = "WINNER";
					roundEndPlayerText.text = "RED WINS";	
					roundEndPlayerText.color = 0xcb3e4e;
				}
				else if( player4Win )
				{
					player4ControlText.text = "WINNER";
					roundEndPlayerText.text = "GREEN WIN";	
					roundEndPlayerText.color = 0x11d27a;
				}
				else
				{
					roundEndPlayerText.text = "DRAW";
				}
				
				showEndPrompt();
				if( endTime <= 0 )
				{
					roundEnd = true;				
				}
				else
				{
					endTime -= FlxG.elapsed;
				}
				return;
			}
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
			if( PlayState._currLevel.player1 ) PlayState._currLevel.player1.roundOver = true;
			if( PlayState._currLevel.player2 ) PlayState._currLevel.player2.roundOver = true;
			if( PlayState._currLevel.player3 ) PlayState._currLevel.player3.roundOver = true;
			if( PlayState._currLevel.player4 ) PlayState._currLevel.player4.roundOver = true;
			roundEndPlayerText.visible = true;
			roundEndForeground.visible = true;
//			roundEndText.visible = true;
		}
		
		private function checkAnyKeyStart():void 
		{
			roundStartContinueText.visible = true;	
			if (FlxG.keys.any())
			{
				if( !roundStart )
				{
					roundStart = true;
					
					// Music
					FlxG.play(SndIntro,0.4);
					FlxG.playMusic(SndSong,0.6);
				}
			}
		}
		
		private function checkAnyKeyEnd():void 
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
