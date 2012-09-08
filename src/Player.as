package
{
	import org.flixel.*;
	
	public class Player extends FlxSprite
	{
		[Embed(source="data/darwin.png")] private var ImgDarwin:Class;
		
		public var startTime:Number;
		
		public var tileX:Number = 0;
		public var tileY:Number = 0;
		
		public var moving:Boolean = false; 
		public var moveTo:FlxSprite;
		
		public var roundOver:Boolean = false;
		private var _tileMatrix:Array;
		
		public const MOVEMENT_SPEED:int = 400.0;
		
		public function Player(X:int,Y:int,tileMatrix:Array)
		{
			super(X,Y);
			loadGraphic(ImgDarwin,true,true,32,32);
			
			_tileMatrix = tileMatrix;
			
			// Bounding box tweaks
			width = 32;
			height = 32;

			// Start time
			startTime = 0.5;

			// Basic player physics
			drag.x = MOVEMENT_SPEED*8;
			drag.y = MOVEMENT_SPEED*8;
			maxVelocity.x = MOVEMENT_SPEED;
			maxVelocity.y = MOVEMENT_SPEED;
			
			// Gravity
			acceleration.y = 0;
			
			addAnimation("idle", [0]);
			addAnimation("run", [1,2,3,4], 18);
			addAnimation("dig", [5,6,7], 32);
			addAnimation("jump", [8,9,10], 18, false);
			addAnimation("land", [8], 20);
			addAnimation("stun", [11,12], 15);
		}
		
		public function moveToTile( x:int, y:int ):void
		{
			if( x < _tileMatrix.length )
			{
				if( y < _tileMatrix[x].length )
				{
					var tile:Tile = _tileMatrix[x][y];	
					if( tile.type == 0 )
					{
						tileX = x;
						tileY = y;
						
						this.x = tile.x;
						this.y = tile.y;
					}
				}
			}
		}
		
		public function setTilePosition( x:int, y:int ):void
		{
			tileX = x;
			tileY = y;
			
			var tile:Tile = _tileMatrix[tileX][tileY];	
			this.x = tile.x;
			this.y = tile.y;
			super.update();
		}
		
		public function stop():void
		{
			moving = false;
			velocity.x = 0;
			velocity.y = 0;
		}
		
		public function processControl(control:String):void
		{
			if( control == "Left" )
			{
				moving = true;
				moveToTile( tileX - 1, tileY);
			}
			else if ( control == "Right" )
			{
				moving = true;
				moveToTile( tileX + 1, tileY);
			}
			else if ( control == "Up" )
			{
				moving = true;
				moveToTile( tileX, tileY + 1);
			}
			else if ( control == "Down" )
			{
				moving = true;
				moveToTile( tileX, tileY - 1);
			}
			else if ( control == "Bomb" )
			{
			}
		}

		override public function update():void
		{		
			super.update();

			if( startTime > 0 )
			{
				startTime -= FlxG.elapsed;
				return;
			}
			
			if( roundOver )
			{
				play("idle");
				return;
			}

			// Animation
			if( !velocity.y )
			{
				if(velocity.x == 0)
				{
					play("idle");
				}
				else
				{
					play("run");
				}
			}
		}
	}
}