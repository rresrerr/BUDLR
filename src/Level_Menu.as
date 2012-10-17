package    {
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxSpecialFX;
	
	public class Level_Menu extends Level{

		[Embed(source = '../data/menu-background.png')] private var ImgBackground:Class;
		[Embed(source = '../data/portraits.png')] private var ImgPortraits:Class;
		[Embed(source = '../data/stars.png')] private var ImgStars:Class;
		
		[Embed(source = '../data/blue-ready.png')] private var ImgReady1:Class;
		[Embed(source = '../data/orange-ready.png')] private var ImgReady2:Class;
		[Embed(source = '../data/red-ready.png')] private var ImgReady3:Class;
		[Embed(source = '../data/green-ready.png')] private var ImgReady4:Class;
		
		[Embed(source = '../data/Audio/player-ready.mp3')] private var SndPlayerReady:Class;
	
		public var startTime:Number;
		
		private var ready1Text:FlxText;
		private var ready2Text:FlxText;
		private var ready3Text:FlxText;
		private var ready4Text:FlxText;
		private var gameTitle:IntroSplash;
		
		private var player1Ready:FlxSprite;
		private var player2Ready:FlxSprite;
		private var player3Ready:FlxSprite;
		private var player4Ready:FlxSprite;
		
		private var player1Control:Boolean = false;
		private var player2Control:Boolean = false;
		private var player3Control:Boolean = false;
		private var player4Control:Boolean = false;
		private var playerGoControl:Boolean = false;
		
		private var player1NumberText:FlxText;
		private var player2NumberText:FlxText;
		private var player3NumberText:FlxText;
		private var player4NumberText:FlxText;
		
		private var starSprite1:FlxSprite;
		private var starSprite2:FlxSprite;

		private var go:Boolean = false;
		private var numPlayers:int = 0;
		
		public const TEXT_COLOR:uint = 0xFFFFFFFF;
		public const STAR_MOVE_SPEED:Number = 1.0;
		
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
	
			starSprite1 = new FlxSprite(0,0);
			starSprite1.loadGraphic(ImgStars, true, true, levelSizeX, levelSizeY);	
			starSprite2 = new FlxSprite(0,0);
			starSprite2.loadGraphic(ImgStars, true, true, levelSizeX, levelSizeY);	
			PlayState.groupBackground.add(starSprite1);
			PlayState.groupBackground.add(starSprite2);
			starSprite2.y = FlxG.height;
		
			gameTitle = new IntroSplash(0,0);
			gameTitle.x = FlxG.width/2 - 176;
			gameTitle.y = 0;
			PlayState.groupForeground.add(gameTitle);
			
			var portraitsSprite:FlxSprite;
			portraitsSprite = new FlxSprite(0,0);
			portraitsSprite.loadGraphic(ImgPortraits, true, true, 263, 271);	
			portraitsSprite.x = 40;
			portraitsSprite.y = 100;
			PlayState.groupForeground.add(portraitsSprite);
			
			var offset:int = 68;
			var numberY:int = 120;
			var readyY:int = 132;
			var readyX:int = 332;
			var readyXNumber:int = 132;
			
			player1Ready:FlxSprite;
			player1Ready = new FlxSprite(0,0);
			player1Ready.loadGraphic(ImgReady1, true, true, 82, 24);
			player1Ready.visible = false;
			player1Ready.x = readyX;
			player1Ready.y = readyY;
			PlayState.groupForeground.add(player1Ready);
			
			player1NumberText = new FlxText(readyXNumber, numberY, FlxG.width, "555-555-5555");
			player1NumberText.setFormat(null,8,0x19b6d8,"center");
			player1NumberText.visible = false;
			PlayState.groupForeground.add(player1NumberText);
			
			ready1Text = new FlxText(108, 110, FlxG.width, "Text \"READY\" to");
			ready1Text.setFormat(null,16,0x19b6d8,"left");
			ready1Text.visible = true;
			PlayState.groupForeground.add(ready1Text);
			
			player2Ready:FlxSprite;
			player2Ready = new FlxSprite(0,0);
			player2Ready.loadGraphic(ImgReady2, true, true, 82, 24);
			player2Ready.visible = false;
			player2Ready.x = readyX;
			player2Ready.y = readyY + offset;
			PlayState.groupForeground.add(player2Ready);
			
			player2NumberText = new FlxText(readyXNumber, numberY + offset, FlxG.width, "555-555-5555");
			player2NumberText.setFormat(null,8,0xff9a00,"center");
			player2NumberText.visible = false;
			PlayState.groupForeground.add(player2NumberText);
			
			ready2Text = new FlxText(108, 110 + offset, FlxG.width, "Text \"READY\" to");
			ready2Text.setFormat(null,16,0xff9a00,"left");
			ready2Text.visible = true;
			PlayState.groupForeground.add(ready2Text);
			
			player3Ready:FlxSprite;
			player3Ready = new FlxSprite(0,0);
			player3Ready.loadGraphic(ImgReady3, true, true, 82, 24);
			player3Ready.visible = false;
			player3Ready.x = readyX;
			player3Ready.y = readyY + offset * 2;
			PlayState.groupForeground.add(player3Ready);
			
			player3NumberText = new FlxText(readyXNumber, numberY + offset*2, FlxG.width, "555-555-5555");
			player3NumberText.setFormat(null,8,0xcb3e4e,"center");
			player3NumberText.visible = false;
			PlayState.groupForeground.add(player3NumberText);
			
			ready3Text = new FlxText(108, 110 + offset*2, FlxG.width, "Text \"READY\" to");
			ready3Text.setFormat(null,16,0xcb3e4e,"left");
			ready3Text.visible = true;
			PlayState.groupForeground.add(ready3Text);
			
			player4Ready:FlxSprite;
			player4Ready = new FlxSprite(0,0);
			player4Ready.loadGraphic(ImgReady4, true, true, 82, 24);
			player4Ready.visible = false;
			player4Ready.x = readyX;
			player4Ready.y = readyY + offset * 3;
			PlayState.groupForeground.add(player4Ready);
		
			player4NumberText = new FlxText(readyXNumber, numberY + offset*3, FlxG.width, "555-555-5555");
			player4NumberText.setFormat(null,8,0x11d27a,"center");
			player4NumberText.visible = false;
			PlayState.groupForeground.add(player4NumberText);
			
			ready4Text = new FlxText(108, 110 + offset*3, FlxG.width, "Text \"READY\" to");
			ready4Text.setFormat(null,16,0x11d27a,"left");
			ready4Text.visible = true;
			PlayState.groupForeground.add(ready4Text);
		}
		
		public function updateReadyText():void
		{
			if( numPlayers >= 2 )
			{
				if( BUDLR.player1Ready )
					ready1Text.text = "Text \"GO\" to";
				
				if( BUDLR.player2Ready )
					ready2Text.text = "Text \"GO\" to";
				
				if( BUDLR.player3Ready )
					ready3Text.text = "Text \"GO\" to";
				
				if( BUDLR.player4Ready )
					ready4Text.text = "Text \"GO\" to";
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
			if( starSprite1.y > -1*FlxG.height )
			{
				starSprite1.y -= STAR_MOVE_SPEED;
				starSprite2.y -= STAR_MOVE_SPEED;
			}
			else
			{
				starSprite1.y = 0;
				starSprite2.y = FlxG.height;
			}
			
			updateSQLControls();
			
			if( ( FlxG.keys.ONE || player1Control ) && !BUDLR.player1Ready )
			{
				numPlayers++;
				BUDLR.player1Ready = true;
				player1Ready.visible = true;
				FlxG.play(SndPlayerReady);
				player1NumberText.visible = true;
			}
			else if( ( FlxG.keys.TWO || player2Control ) && !BUDLR.player2Ready )
			{
				numPlayers++;
				BUDLR.player2Ready = true;
				player2Ready.visible = true;
				FlxG.play(SndPlayerReady);
				player2NumberText.visible = true;
			}
			else if( ( FlxG.keys.THREE || player3Control ) && !BUDLR.player3Ready )
			{
				numPlayers++;
				BUDLR.player3Ready = true;
				player3Ready.visible = true;
				FlxG.play(SndPlayerReady);
				player3NumberText.visible = true;
			}
			else if( ( FlxG.keys.FOUR || player4Control ) && !BUDLR.player4Ready )
			{
				numPlayers++;
				BUDLR.player4Ready = true;
				player4Ready.visible = true;
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
