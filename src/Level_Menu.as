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
		[Embed(source = '../data/panel.png')] private var ImgPanel:Class;
		[Embed(source = '../data/directions.png')] private var ImgDirections:Class;
		
		[Embed(source = '../data/blue-ready.png')] private var ImgReady1:Class;
		[Embed(source = '../data/orange-ready.png')] private var ImgReady2:Class;
		[Embed(source = '../data/red-ready.png')] private var ImgReady3:Class;
		[Embed(source = '../data/green-ready.png')] private var ImgReady4:Class;
		
		[Embed(source = '../data/Audio/player-ready.mp3')] private var SndPlayerReady:Class;
		[Embed(source = '../data/Audio/ready.mp3')] private var SndSong:Class;
	
		public var startTime:Number;
		
		private var ready1Text:FlxText;
		private var ready2Text:FlxText;
		private var ready3Text:FlxText;
		private var ready4Text:FlxText;
		private var gameTitle:IntroSplash;
		private var directionsSprite:FlxSprite;

		private var portraitsSprite:FlxSprite;
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
		private var minPlayers:int = 2;
		
		private var tutorialCountdownTimer:Number = 3;
		private var tutorialCountdownText:FlxText;
		private var tutorialCountdownDone:Boolean = false;
	
		public const TEXT_COLOR:uint = 0xa7f2cd;
		public const STAR_MOVE_SPEED:Number = 1.0;
		
		public const CONTROL_UPDATE_TIME:Number = 0.25;
		private var controlUpdateTimer:Number = CONTROL_UPDATE_TIME;
		
		public function Level_Menu( group:FlxGroup ) {
			
			super();
			
			levelSizeX = FlxG.width;
			levelSizeY = FlxG.height;
			
			BUDLR.player1Ready = false;
			BUDLR.player2Ready = false;
			BUDLR.player3Ready = false;
			BUDLR.player4Ready = false;
			
			startTime = 1.0;
			
			createForegroundAndBackground();
		}
		
		override public function nextLevel():Boolean
		{
			if( tutorialCountdownDone )
			{
				return true;
			}
			return false;
		}
		
		public function createForegroundAndBackground():void 
		{
			var backgroundSprite:FlxSprite;
			backgroundSprite = new FlxSprite(0,0);
			backgroundSprite.loadGraphic(ImgBackground, true, true, 960, 540);	
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
			gameTitle.y = 6;
			PlayState.groupForeground.add(gameTitle);
			
			directionsSprite:FlxSprite;
			directionsSprite = new FlxSprite(0,0);
			directionsSprite.visible = false;
			directionsSprite.loadGraphic(ImgDirections, true, true, 480, 261);	
			directionsSprite.x = FlxG.width / 2;
			directionsSprite.y = FlxG.height / 2;
			directionsSprite.offset.x = directionsSprite.width/2;
			directionsSprite.offset.y = directionsSprite.height/2;
			
			PlayState.groupForeground.add(directionsSprite);
			
			tutorialCountdownText = new FlxText(0, 0, FlxG.width, "5");
			tutorialCountdownText.x = 152;
			tutorialCountdownText.y = FlxG.height/2 - 64;
			tutorialCountdownText.setFormat(null,64,TEXT_COLOR,"center");
			tutorialCountdownText.visible = false;
			PlayState.groupForeground.add(tutorialCountdownText);
			
			portraitsSprite = new FlxSprite(0,0);
			portraitsSprite.loadGraphic(ImgPortraits, true, true, 240, 248);	
			portraitsSprite.x = FlxG.width / 2 - 200;
			portraitsSprite.y = FlxG.height / 2 - 70;
			PlayState.groupForeground.add(portraitsSprite);
			
			var offset:Number = 62.5;
			var numberY:int = 124;
			var readyY:int = FlxG.height / 2 - 41;
			var readyX:int = FlxG.width / 2 + 122;
			var textReadyX:int = FlxG.width / 2 - 140;
			var readyXNumber:int = FlxG.width / 2 + 124;
			var readyAlpha:Number = 0.1;
			
			player1Ready:FlxSprite;
			player1Ready = new FlxSprite(0,0);
			player1Ready.loadGraphic(ImgReady1, true, true, 82, 24);
			//player1Ready.visible = false;
			player1Ready.x = readyX;
			player1Ready.y = readyY;
			player1Ready.alpha = readyAlpha;
			PlayState.groupForeground.add(player1Ready);
			
			player1NumberText = new FlxText(readyXNumber, numberY, FlxG.width, "Waiting...");
			player1NumberText.setFormat(null,8,0x19b6d8,"left");
			player1NumberText.visible = true;
			PlayState.groupForeground.add(player1NumberText);
			
			ready1Text = new FlxText(textReadyX, 114, FlxG.width, "Text \"READY\" to");
			ready1Text.setFormat(null,16,0x19b6d8,"left");
			ready1Text.visible = true;
			PlayState.groupForeground.add(ready1Text);
			
			player2Ready:FlxSprite;
			player2Ready = new FlxSprite(0,0);
			player2Ready.loadGraphic(ImgReady2, true, true, 82, 24);
			//player2Ready.visible = false;
			player2Ready.x = readyX;
			player2Ready.y = readyY + offset;
			player2Ready.alpha = readyAlpha;
			PlayState.groupForeground.add(player2Ready);
			
			player2NumberText = new FlxText(readyXNumber, numberY + offset, FlxG.width, "Waiting...");
			player2NumberText.setFormat(null,8,0xff9a00,"left");
			player2NumberText.visible = true;
			PlayState.groupForeground.add(player2NumberText);
			
			ready2Text = new FlxText(textReadyX, 114 + offset, FlxG.width, "Text \"READY\" to");
			ready2Text.setFormat(null,16,0xff9a00,"left");
			ready2Text.visible = true;
			PlayState.groupForeground.add(ready2Text);
			
			player3Ready:FlxSprite;
			player3Ready = new FlxSprite(0,0);
			player3Ready.loadGraphic(ImgReady3, true, true, 82, 24);
			//player3Ready.visible = false;
			player3Ready.x = readyX;
			player3Ready.y = readyY + offset * 2;
			player3Ready.alpha = readyAlpha;
			PlayState.groupForeground.add(player3Ready);
			
			player3NumberText = new FlxText(readyXNumber, numberY + offset*2, FlxG.width, "Waiting...");
			player3NumberText.setFormat(null,8,0xcb3e4e,"left");
			player3NumberText.visible = true;
			PlayState.groupForeground.add(player3NumberText);
			
			ready3Text = new FlxText(textReadyX, 114 + offset*2, FlxG.width, "Text \"READY\" to");
			ready3Text.setFormat(null,16,0xcb3e4e,"left");
			ready3Text.visible = true;
			PlayState.groupForeground.add(ready3Text);
			
			player4Ready:FlxSprite;
			player4Ready = new FlxSprite(0,0);
			player4Ready.loadGraphic(ImgReady4, true, true, 82, 24);
			//player4Ready.visible = false;
			player4Ready.x = readyX;
			player4Ready.y = readyY + offset * 3;
			player4Ready.alpha = readyAlpha;
			PlayState.groupForeground.add(player4Ready);
		
			player4NumberText = new FlxText(readyXNumber, numberY + offset*3, FlxG.width, "Waiting...");
			player4NumberText.setFormat(null,8,0x11d27a,"left");
			player4NumberText.visible = true;
			PlayState.groupForeground.add(player4NumberText);
			
			ready4Text = new FlxText(textReadyX, 114 + offset*3, FlxG.width, "Text \"READY\" to");
			ready4Text.setFormat(null,16,0x11d27a,"left");
			ready4Text.visible = true;
			PlayState.groupForeground.add(ready4Text);
		}
		
		public function updateReadyText():void
		{
			if( numPlayers >= minPlayers )
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
			myLoader.load(new URLRequest("http://www.b-u-d-l-r.com/BUDLR/get-controls.php"));
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
						BUDLR.player4PhoneNumber = loader.data["phonenumber"+i];
						player4NumberText.text = stringToNumberString( loader.data["phonenumber"+i] );
						player4Control = true;
					}
					
					if( numPlayers >= minPlayers )
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
			var one:String = string.slice(1,4);
			var two:String = string.slice(4,7);
			var three:String = string.slice(7,11);
			var numberString:String = one + "-" + two + "-" + three;
			return numberString;
		}
		
		public function tutorialCountdown():void 
		{
			if( go )
			{
				tutorialCountdownTimer -= FlxG.elapsed;
				if( int(tutorialCountdownTimer) == 0 )
				{
					tutorialCountdownText.text = "!";
				}
				else
				{
					tutorialCountdownText.text = "" + int(tutorialCountdownTimer);
				}
				if( tutorialCountdownTimer <= 0 )
				{
					tutorialCountdownDone = true;
				}				
			}
		}
		
		override public function update():void
		{	
			tutorialCountdown();
			
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
			
			// Update SQL controls
			if( controlUpdateTimer <= 0 )
			{
				controlUpdateTimer = CONTROL_UPDATE_TIME;
				updateSQLControls();
			}
			else
			{
				controlUpdateTimer -= FlxG.elapsed;
			}
			
			if( ( FlxG.keys.ONE || player1Control ) && !BUDLR.player1Ready && !go )
			{
				numPlayers++;
				BUDLR.player1Ready = true;
				player1Ready.visible = true;
				player1Ready.alpha = 1.0;
				FlxG.play(SndPlayerReady);
				player1NumberText.visible = true;
			}
			else if( ( FlxG.keys.TWO || player2Control ) && !BUDLR.player2Ready && !go)
			{
				numPlayers++;
				BUDLR.player2Ready = true;
				player2Ready.visible = true;
				player2Ready.alpha = 1.0;
				FlxG.play(SndPlayerReady);
				player2NumberText.visible = true;
			}
			else if( ( FlxG.keys.THREE || player3Control ) && !BUDLR.player3Ready && !go )
			{
				numPlayers++;
				BUDLR.player3Ready = true;
				player3Ready.visible = true;
				player3Ready.alpha = 1.0;
				FlxG.play(SndPlayerReady);
				player3NumberText.visible = true;
			}
			else if( ( FlxG.keys.FOUR || player4Control ) && !BUDLR.player4Ready && !go )
			{
				numPlayers++;
				BUDLR.player4Ready = true;
				player4Ready.visible = true;
				player4Ready.alpha = 1.0;
				FlxG.play(SndPlayerReady);
				player4NumberText.visible = true;
			}
			else if( ( FlxG.keys.FIVE || playerGoControl ) && numPlayers >= minPlayers )
			{
				portraitsSprite.visible = false;
				player1Ready.visible = false;
				player2Ready.visible = false;
				player3Ready.visible = false;
				player4Ready.visible = false;
				
				player1NumberText.visible = false;
				player2NumberText.visible = false;
				player3NumberText.visible = false;
				player4NumberText.visible = false;
				
				ready1Text.visible = false;
				ready2Text.visible = false;
				ready3Text.visible = false;
				ready4Text.visible = false;
				
				gameTitle.visible = false;
				
				directionsSprite.visible = true;
				tutorialCountdownText.visible = true;
				
				if( !go )
				{
					FlxG.playMusic( SndSong, 0.2 );
				}
				
				go = true;
			}
			
			updateReadyText();
			super.update();
		}	
	}
}
