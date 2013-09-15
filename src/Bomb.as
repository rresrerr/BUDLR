package
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	
	public class Bomb extends FlxSprite
	{
		[Embed(source='../data/bomb.png')] private var ImgBomb:Class;
		[Embed(source = '../data/Audio/explosion.mp3')] private var SndExplosion:Class;

		private var _tileMatrix:Array;
		private var _player1:Player;
		private var _player2:Player;
		private var _player3:Player;
		private var _player4:Player;
		
		private var timerText:FlxText;
		
		public var tileX:int;
		public var tileY:int;
		private var explodeTimer:Number = 11.0;
		private var flashTimer:Number = 1.0;
		private var flashRate:uint = 0;
		private var fireTimer:Number = 0;
		private var fireCounter:int = 0;
		private var upDone:Boolean = false;
		private var downDone:Boolean = false;
		private var leftDone:Boolean = false;
		private var rightDone:Boolean = false;		
		
		private var _level:Level_Main;
		
		public const TEXT_COLOR:uint = 0xFFFFFF;
		
		public const FIRE_TIME:Number = 0.05;
		public const FIRE_DISTANCE:uint = 5;
		
		public function Bomb( x:Number, y:Number, tileMatrix:Array, player1:Player, player2:Player, player3:Player, player4:Player, level:Level_Main ):void
		{
			_tileMatrix = tileMatrix;
			_player1 = player1;
			_player2 = player2;
			_player3 = player3;
			_player4 = player4;
			_level = level;
			
			tileX = x;
			tileY = y;
			
			// Set position
			var tile:Tile = getTile(x,y);
			super(tile.x,tile.y);	
			
			width = 32;
			height = 32;
			offset.y = 6;
			loadGraphic(ImgBomb, true, true, width, height);
			
			timerText = new FlxText(0, 0, 64, "10");
			timerText.x = 0;
			timerText.y = 0;
			timerText.offset.x = timerText.width/2 - 14;
			timerText.offset.y = timerText.height/2 - 9;
			timerText.setFormat(null,16,TEXT_COLOR,"center",20);
			timerText.visible = true;
			PlayState.groupCollectLabels.add(timerText);
			
			addAnimation("ticktock0", [0,1], 2);
			addAnimation("ticktock1", [0,1], 2);
			addAnimation("ticktock2", [0,1], 2);
			addAnimation("ticktock3", [0,1], 4);
			addAnimation("ticktock4", [0,1], 4);
			addAnimation("ticktock5", [0,1], 4);
			addAnimation("ticktock6", [0,1], 8);
			addAnimation("ticktock7", [0,1], 8);
			addAnimation("ticktock8", [0,1], 8);
			addAnimation("ticktock9", [0,1], 16);
			addAnimation("ticktock10", [0,1], 32);
			
//			addAnimation("ticktock0", [0,1], 2);
//			addAnimation("ticktock1", [0,1], 2);
//			addAnimation("ticktock2", [0,1], 2);
//			addAnimation("ticktock3", [0,1], 2);
//			addAnimation("ticktock4", [0,1], 4);
//			addAnimation("ticktock5", [0,1], 4);
//			addAnimation("ticktock6", [0,1], 4);
//			addAnimation("ticktock7", [0,1], 4);
//			addAnimation("ticktock8", [0,1], 8);
//			addAnimation("ticktock9", [0,1], 8);
//			addAnimation("ticktock10", [0,1], 8);
//			addAnimation("ticktock11", [0,1], 8);
//			addAnimation("ticktock12", [0,1], 16);
//			addAnimation("ticktock13", [0,1], 16);
//			addAnimation("ticktock14", [0,1], 32);
//			addAnimation("ticktock15", [0,1], 32);
		}
		
		public function getTile( x:int, y:int ):Tile {
			return _tileMatrix[x][y];
		}
		
		private function updateFire():void 
		{
			if( fireTimer <= 0 )
			{
				alpha = 0;
				timerText.visible = false;
				
				if( fireCounter == 0 )
				{
					FlxG.play(SndExplosion,1.0);
					catchFire(tileX, tileY, true);
					
					// Remove bomb from array
					_level.bombArray.splice( _level.bombArray.indexOf( this ), 1 );
				}
				else
				{
					if( !rightDone )
					{
						if( catchFire(tileX + fireCounter, tileY, false) )
							rightDone = true;
					}
					
					if( !leftDone )
					{
						if( catchFire(tileX - fireCounter, tileY, false) )
							leftDone = true;
						
					}
					
					if( !upDone )
					{
						if( catchFire(tileX, tileY + fireCounter, false) )
							upDone = true;
					}
					
					if( !downDone )
					{
						if( catchFire(tileX, tileY - fireCounter, false) )
							downDone = true;
					}
				}
				fireCounter++;
				fireTimer = FIRE_TIME;
				
				if( fireCounter >= FIRE_DISTANCE )
				{
					kill();
				}
			}
			else
			{
				fireTimer -= FlxG.elapsed;
			}
		}
		
		public function catchFire( x:int, y:int, first:Boolean ):Boolean
		{
			if( x < _tileMatrix.length && x >= 0 )
			{
				if( y < _tileMatrix[x].length && y >= 0 )
				{
					var tile:Tile = _tileMatrix[x][y];	
					if( tile && tile.type != 1 )
					{
						// Destruct
						if( tile.type == 5 )
						{
							tile.spreadFire();
							return true;
						}
						
						if( first )
						{
							tile.catchFire();
						}
						else 
						{
							tile.spreadFire();
						}
						
						if( _player1 && _player1.tileX == x && _player1.tileY == y )
						{ 
							_player1.catchFire();	
						}
						
						if( _player2 && _player2.tileX == x && _player2.tileY == y)
						{
							_player2.catchFire();	
						}
						
						if( _player3 && _player3.tileX == x && _player3.tileY == y)
						{
							_player3.catchFire();	
						}
						
						if( _player4 && _player4.tileX == x && _player4.tileY == y)
						{
							_player4.catchFire();	
						}
						return false;
					}
				}
			}
			return true;
		}
		
		override public function update():void
		{		
			timerText.x = this.x;
			timerText.y = this.y;
			
			play("ticktock"+flashRate);
			
			if( explodeTimer <= 0 )
			{
				updateFire();
			}
			else
			{
				explodeTimer -= FlxG.elapsed;
				
				if( flashTimer <= 0 )
				{
					flashTimer = 1.0;
					flashRate++;
				}
				else
				{
					flashTimer -= FlxG.elapsed;
				}
				
				var explodeTimerInt:int = explodeTimer;
				timerText.text = "" + explodeTimerInt + "";
			}
			super.update();
		}
	}
}