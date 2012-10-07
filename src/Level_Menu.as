package    {
	
	import org.flixel.*;
	
	public class Level_Menu extends Level{

		[Embed(source = '../data/menu-background.png')] private var ImgBackground:Class;
	
		public var startTime:Number;
		
		private var gameText:FlxText;
		private var readyText:FlxText;
		
		private var player1ReadyText:FlxText;
		private var player2ReadyText:FlxText;
		private var player3ReadyText:FlxText;
		private var player4ReadyText:FlxText;
		
		private var player1NumberText:FlxText;
		private var player2NumberText:FlxText;
		private var player3NumberText:FlxText;
		private var player4NumberText:FlxText;
		
		private var player1Ready:Boolean = false;
		private var player2Ready:Boolean = false;
		private var player3Ready:Boolean = false;
		private var player4Ready:Boolean = false;
		private var go:Boolean = false;
		private var numPlayers:int = 0;
		
		public const TEXT_COLOR:uint = 0xFFFFFFFF;
		
		public function Level_Menu( group:FlxGroup ) {
			
			super();
			
			levelSizeX = 480;
			levelSizeY = 400;
			
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
			var numberY:int = 110;
			var readyY:int = 128;
			var readyX:int = 140;
			player1ReadyText = new FlxText(readyX, readyY, FlxG.width, "READY");
			player1ReadyText.setFormat(null,32,0xcb3e4e,"center");
			player1ReadyText.visible = false;
			PlayState.groupForeground.add(player1ReadyText);
			
			player1NumberText = new FlxText(readyX, numberY, FlxG.width, "555-555-5555");
			player1NumberText.setFormat(null,16,0xcb3e4e,"center");
			player1NumberText.visible = false;
			PlayState.groupForeground.add(player1NumberText);
			
			player2ReadyText = new FlxText(readyX, readyY + offset, FlxG.width, "READY");
			player2ReadyText.setFormat(null,32,0x19b6d8,"center");
			player2ReadyText.visible = false;
			PlayState.groupForeground.add(player2ReadyText);
			
			player2NumberText = new FlxText(readyX, numberY + offset, FlxG.width, "555-555-5555");
			player2NumberText.setFormat(null,16,0x19b6d8,"center");
			player2NumberText.visible = false;
			PlayState.groupForeground.add(player2NumberText);
			
			player3ReadyText = new FlxText(readyX, readyY + offset*2, FlxG.width, "READY");
			player3ReadyText.setFormat(null,32,0xff9a00,"center");
			player3ReadyText.visible = false;
			PlayState.groupForeground.add(player3ReadyText);
			
			player3NumberText = new FlxText(readyX, numberY + offset*2, FlxG.width, "555-555-5555");
			player3NumberText.setFormat(null,16,0xff9a00,"center");
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
		
		override public function update():void
		{	
			if( FlxG.keys.ONE && !player1Ready )
			{
				numPlayers++;
				player1Ready = true;
				player1ReadyText.visible = true;
				player1NumberText.visible = true;
			}
			else if( FlxG.keys.TWO && !player2Ready )
			{
				numPlayers++;
				player2Ready = true;
				player2ReadyText.visible = true;
				player2NumberText.visible = true;
			}
			else if( FlxG.keys.THREE && !player3Ready )
			{
				numPlayers++;
				player3Ready = true;
				player3ReadyText.visible = true;
				player3NumberText.visible = true;
			}
			else if( FlxG.keys.FOUR && !player4Ready )
			{
				numPlayers++;
				player4Ready = true;
				player4ReadyText.visible = true;
				player4NumberText.visible = true;
			}
			else if( FlxG.keys.FIVE && numPlayers >= 2 )
			{
				go = true;
			}
			
			updateReadyText();
			super.update();
		}	
	}
}
