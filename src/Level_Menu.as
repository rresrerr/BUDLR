package    {
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	import org.flixel.*;
	
	public class Level_Menu extends Level{

		[Embed(source = '../data/menu-background.png')] private var ImgBackground:Class;
		[Embed(source = '../data/Audio/player-ready.mp3')] private var SndPlayerReady:Class;
	
		public var startTime:Number;
		
		private var gameText:FlxText;
		private var readyText:FlxText;
		
		private var player1ReadyText:FlxText;
		private var player2ReadyText:FlxText;
		private var player3ReadyText:FlxText;
		private var player4ReadyText:FlxText;
		
		private var player1Control:Boolean = false;
		private var player2Control:Boolean = false;
		private var player3Control:Boolean = false;
		private var player4Control:Boolean = false;
		private var playerGoControl:Boolean = false;
		
		private var player1NumberText:FlxText;
		private var player2NumberText:FlxText;
		private var player3NumberText:FlxText;
		private var player4NumberText:FlxText;

		private var go:Boolean = false;
		private var numPlayers:int = 0;
		
		public const TEXT_COLOR:uint = 0xFFFFFFFF;
		
		public function Level_Menu( group:FlxGroup ) {
			
			super();
			
			levelSizeX = 480;
			levelSizeY = 400;
			
			BUDLR.player1Ready = false;
			BUDLR.player2Ready = false;
			BUDLR.player3Ready = false;
			BUDLR.player4Ready = false;
			
			startTime = 1.0;
			
			createForegroundAndBackground();
		}
		
		override public function nextLevel():Boolean
		{
			if( go )
			{
				return true;
			}
			return false;
		}
		
		public function createForegroundAndBackground():void 
		{
			var backgroundSprite:FlxSprite;
			backgroundSprite = new FlxSprite(0,0);
			backgroundSprite.loadGraphic(ImgBackground, true, true, levelSizeX, levelSizeY);	
			PlayState.groupBackground.add(backgroundSprite);
			
			gameText = new FlxText(0, 0, FlxG.width, "B U D L R");
			gameText.setFormat(null,64,TEXT_COLOR,"center");
			gameText.visible = true;
			PlayState.groupForeground.add(gameText);
			
			readyText = new FlxText(0, 66, FlxG.width, "Text \"READY\" to");
			readyText.setFormat(null,32,TEXT_COLOR,"center");
			readyText.visible = true;
			PlayState.groupForeground.add(readyText);
			
			var offset:int = 71;
			var numberY:int = 118;
			var readyY:int = 136;
			var readyX:int = 140;
			player1ReadyText = new FlxText(readyX, readyY, FlxG.width, "READY");
			player1ReadyText.setFormat(null,32,0x19b6d8,"center");
			player1ReadyText.visible = false;
			PlayState.groupForeground.add(player1ReadyText);
			
			player1NumberText = new FlxText(readyX, numberY, FlxG.width, "555-555-5555");
			player1NumberText.setFormat(null,16,0x19b6d8,"center");
			player1NumberText.visible = false;
			PlayState.groupForeground.add(player1NumberText);
			
			player2ReadyText = new FlxText(readyX, readyY + offset, FlxG.width, "READY");
			player2ReadyText.setFormat(null,32,0xff9a00,"center");
			player2ReadyText.visible = false;
			PlayState.groupForeground.add(player2ReadyText);
			
			player2NumberText = new FlxText(readyX, numberY + offset, FlxG.width, "555-555-5555");
			player2NumberText.setFormat(null,16,0xff9a00,"center");
			player2NumberText.visible = false;
			PlayState.groupForeground.add(player2NumberText);
			
			player3ReadyText = new FlxText(readyX, readyY + offset*2, FlxG.width, "READY");
			player3ReadyText.setFormat(null,32,0xcb3e4e,"center");
			player3ReadyText.visible = false;
			PlayState.groupForeground.add(player3ReadyText);
			
			player3NumberText = new FlxText(readyX, numberY + offset*2, FlxG.width, "555-555-5555");
			player3NumberText.setFormat(null,16,0xcb3e4e,"center");
			player3NumberText.visible = false;
			PlayState.groupForeground.add(player3NumberText);
			
			player4ReadyText = new FlxText(readyX, readyY + offset*3, FlxG.width, "READY");
			player4ReadyText.setFormat(null,32,0x11d27a,"center");
			player4ReadyText.visible = false;
			PlayState.groupForeground.add(player4ReadyText);
			
			player4NumberText = new FlxText(readyX, numberY + offset*3, FlxG.width, "555-555-5555");
			player4NumberText.setFormat(null,16,0x11d27a,"center");
			player4NumberText.visible = false;
			PlayState.groupForeground.add(player4NumberText);
		}
		
		public function updateReadyText():void
		{
			if( numPlayers >= 2 )
			{
				readyText.text = "Text \"GO\" to";
			}
		}
		
		private function updateSQLControls():void {
			
			var myLoader:URLLoader = new URLLoader();
			myLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
			myLoader.load(new URLRequest("http://travis.aristomatic.com/games/BUDLR/get-controls.php"));
			myLoader.addEventListener(Event.COMPLETE, onDataLoad);
			
			function onDataLoad(event:Event):void {
				
				var loader:URLLoader = URLLoader(event.target);
				
				for(var i:uint=0; i < loader.data.count; i++) {
					if( loader.data["player"+i] == 1 && loader.data["control"+i] == "Ready" )
					{
						BUDLR.player1PhoneNumber = loader.data["phonenumber"+i];
						player1NumberText.text = stringToNumberString( loader.data["phonenumber"+i] );
						player1Control = true;
					}
					if( loader.data["player"+i] == 2 && loader.data["control"+i] == "Ready" )
					{
						BUDLR.player2PhoneNumber = loader.data["phonenumber"+i];
						player2NumberText.text = stringToNumberString( loader.data["phonenumber"+i] );
						player2Control = true;
					}
					if( loader.data["player"+i] == 3 && loader.data["control"+i] == "Ready" )
					{
						BUDLR.player3PhoneNumber = loader.data["phonenumber"+i];
						player3NumberText.text = stringToNumberString( loader.data["phonenumber"+i] );
						player3Control = true;
					}
					if( loader.data["player"+i] == 4 && loader.data["control"+i] == "Ready" )
					{
						BUDLR.player3PhoneNumber = loader.data["phonenumber"+i];
						player4NumberText.text = stringToNumberString( loader.data["phonenumber"+i] );
						player4Control = true;
					}
					
					if( numPlayers >= 2 )
					{
						if( loader.data["player"+i] == 1 && loader.data["control"+i] == "Go" )
							playerGoControl = true;
						if( loader.data["player"+i] == 2 && loader.data["control"+i] == "Go" )
							playerGoControl = true;
						if( loader.data["player"+i] == 3 && loader.data["control"+i] == "Go" )
							playerGoControl = true;
						if( loader.data["player"+i] == 4 && loader.data["control"+i] == "Go" )
							playerGoControl = true;
					}
				}
				
			}	
		}
		
		public function stringToNumberString( string:String ):String
		{	
			var one:String = string.slice(2,5);
			var two:String = string.slice(5,8);
			var three:String = string.slice(8,12);
			var numberString:String = one + "-" + two + "-" + three;
			return numberString;
		}
		
		override public function update():void
		{	
			updateSQLControls();
			
			if( ( FlxG.keys.ONE || player1Control ) && !BUDLR.player1Ready )
			{
				numPlayers++;
				BUDLR.player1Ready = true;
				player1ReadyText.visible = true;
				FlxG.play(SndPlayerReady);
				player1NumberText.visible = true;
			}
			else if( ( FlxG.keys.TWO || player2Control ) && !BUDLR.player2Ready )
			{
				numPlayers++;
				BUDLR.player2Ready = true;
				player2ReadyText.visible = true;
				FlxG.play(SndPlayerReady);
				player2NumberText.visible = true;
			}
			else if( ( FlxG.keys.THREE || player3Control ) && !BUDLR.player3Ready )
			{
				numPlayers++;
				BUDLR.player3Ready = true;
				player3ReadyText.visible = true;
				FlxG.play(SndPlayerReady);
				player3NumberText.visible = true;
			}
			else if( ( FlxG.keys.FOUR || player4Control ) && !BUDLR.player4Ready )
			{
				numPlayers++;
				BUDLR.player4Ready = true;
				player4ReadyText.visible = true;
				FlxG.play(SndPlayerReady);
				player4NumberText.visible = true;
			}
			else if( ( FlxG.keys.FIVE || playerGoControl ) && numPlayers >= 2 )
			{
				go = true;
			}
			
			updateReadyText();
			super.update();
		}	
	}
}
