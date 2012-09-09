package
{
	import org.flixel.*;
	
	public class Player extends FlxSprite
	{
		[Embed(source="data/player1.png")] private var ImgPlayer1:Class;
		[Embed(source="data/player2.png")] private var ImgPlayer2:Class;
		
		public var startTime:Number;
		
		public var tileX:Number = 0;
		public var tileY:Number = 0;
		
		public var moving:Boolean = false; 
		public var hit:Boolean = false; 
		public var hitTimer:Number = 2.0;
		public var moveTo:Tile;
		
		public var movementDistance:Number;
		public var movementSpeed:Number;
		public var movementUpDown:Boolean;
		
		public var roundOver:Boolean = false;
		private var _tileMatrix:Array;
		private var _otherPlayer:Player;
		
		public const MOVEMENT_SPEED:Number = 0.25;
		
		public function Player( number:int, X:int, Y:int, tileMatrix:Array )
		{
			super(X,Y);

			// Bounding box tweaks
			width = 32;
			height = 40;
			offset.y = 8;

			if( number == 1 )
				loadGraphic(ImgPlayer1,true,true,width,height);
			else
				loadGraphic(ImgPlayer2,true,true,width,height);
			
			_tileMatrix = tileMatrix;
			
			// Start time
			startTime = 3.0;

			// Basic player physics
			drag.x = MOVEMENT_SPEED*8;
			drag.y = MOVEMENT_SPEED*8;
			maxVelocity.x = MOVEMENT_SPEED;
			maxVelocity.y = MOVEMENT_SPEED;
			
			// Gravity
			acceleration.y = 0;
			
			addAnimation("idle", [0]);
			addAnimation("run", [0], 18);
			addAnimation("stun", [0], 15);
		}
		
		public function setOtherPlayer( otherPlayer:Player ):void
		{
			_otherPlayer = otherPlayer;
		}
		
		public function moveToTile( x:int, y:int ):void
		{
			if( x < _tileMatrix.length )
			{
				if( y < _tileMatrix[x].length )
				{
					var tile:Tile = _tileMatrix[x][y];	
					if( tile.type != 1 )
					{
						tileX = x;
						tileY = y;
						
						moveTo = tile;
						moving = true;
						movementDistance = Math.abs( FlxU.getDistance( this.getMidpoint(), moveTo.getMidpoint() ) );
						movementSpeed = ( movementDistance / MOVEMENT_SPEED );
						
						if( moveTo.x == this.x )
						{
							movementUpDown = true;
						}
						else
						{
							movementUpDown = false;
						}
					}
				}
			}
		}
		
		public function updateMovement():void
		{
//			if( !movementUpDown )
//			{
//				if( moveTo.y < this.y )
//				{
//					this.y -= 4;
//				}
//				else
//				{
//					this.y += 4;
//				}
//			}
//			else
//			{
//				if( moveTo.x < this.x )
//				{
//					this.x -= 4;
//				}
//				else
//				{
//					this.x += 4;
//				}
//			}
//			
//			if( movementDistance <= 0 )
//			{
//				moving = false;
//				this.x = moveTo.x;
//				this.y = moveTo.y;
//			}
//			movementDistance -= 1.0;
			
			x = moveTo.x;
			y = moveTo.y;	
			moving = false;
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
//			moving = false;
//			velocity.x = 0;
//			velocity.y = 0;
		}
		
		public function dropBomb():void
		{
			var bomb:Bomb = new Bomb( tileX, tileY, _tileMatrix, this, _otherPlayer);
			PlayState.groupCollects.add(bomb);
		}
		
		public function catchFire():void 
		{
			hit = true;
			hitTimer = 2.0;
		}
		
		public function updateHit():Boolean
		{
			if( hit )
			{
//				if( hitTimer <= 0.0 )
//				{
//					hit = false;
//				}
//				else
//				{
//					hitTimer -= FlxG.elapsed;
//				}
				return true;
			}
			return false;
		}
	
		public function processControl(control:String):void
		{
			if( hit )
			{
				return
			}
			
			if( startTime > 0 )
			{
				return;
			}
			
			if( control == "Left" )
			{
				facing = LEFT;
				moveToTile( tileX - 1, tileY );
			}
			else if ( control == "Right" )
			{
				facing = RIGHT;
				moveToTile( tileX + 1, tileY );
			}
			else if ( control == "Up" )
			{
				moveToTile( tileX, tileY + 1 );
			}
			else if ( control == "Down" )
			{
				moveToTile( tileX, tileY - 1 );
			}
			else if ( control == "Bomb" )
			{
				dropBomb();
			}
		}
		
		public function player2SetFacing():void
		{
			facing = LEFT;	
		}

		override public function update():void
		{		
			super.update();

			if( moving )
			{
				updateMovement();
			}
			
			if( startTime > 0 )
			{
				startTime -= FlxG.elapsed;
				return;
			}
			
			if( updateHit() )
			{
				play("stun");
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