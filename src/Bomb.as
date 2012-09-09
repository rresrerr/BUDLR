package
{
	import org.flixel.*;
	
	public class Bomb extends FlxSprite
	{
		[Embed(source='../data/bomb.png')] private var ImgBomb:Class;

		private var _tileMatrix:Array;
		private var _player:Player;
		private var _otherPlayer:Player;
		
		private var tileX:int;
		private var tileY:int;
		private var explodeTimer:Number = 8.0;
		private var flashTimer:Number = 1.0;
		private var flashRate:uint = 0;
		private var fireTimer:Number = 0;
		private var fireCounter:int = 0;
		private var upDone:Boolean = false;
		private var downDone:Boolean = false;
		private var leftDone:Boolean = false;
		private var rightDone:Boolean = false;		
		
		public const FIRE_TIME:Number = 0.05;
		public const FIRE_DISTANCE:uint = 5;
		
		public function Bomb( x:Number, y:Number, tileMatrix:Array, player:Player, otherPlayer:Player ):void
		{
			_tileMatrix = tileMatrix;
			_otherPlayer = otherPlayer;
			_player = player;
			
			tileX = x;
			tileY = y;
			
			// Set position
			var tile:Tile = getTile(x,y);
			super(tile.x,tile.y);	
			
			width = 32;
			height = 32;
			offset.y = 6;
			loadGraphic(ImgBomb, true, true, width, height);
			
			addAnimation("ticktock0", [0,1], 2);
			addAnimation("ticktock1", [0,1], 2);
			addAnimation("ticktock2", [0,1], 4);
			addAnimation("ticktock3", [0,1], 4);
			addAnimation("ticktock4", [0,1], 8);
			addAnimation("ticktock5", [0,1], 8);
			addAnimation("ticktock6", [0,1], 16);
			addAnimation("ticktock7", [0,1], 32);
		}
		
		public function getTile( x:int, y:int ):Tile {
			return _tileMatrix[x][y];
		}
		
		private function updateFire():void 
		{
			if( fireTimer <= 0 )
			{
				alpha = 0;
				if( fireCounter == 0 )
				{
					catchFire(tileX, tileY, true);
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
						if( first )
						{
							tile.catchFire();
						}
						else 
						{
							tile.spreadFire();
						}
						
						if( _otherPlayer.tileX == x && _otherPlayer.tileY == y )
						{
							_otherPlayer.catchFire();	
						}
						
						if( _player.tileX == x && _player.tileY == y)
						{
							_player.catchFire();	
						}
						return false;
					}
				}
			}
			return true;
		}
		
		override public function update():void
		{		
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
			}
			super.update();
		}
	}
}