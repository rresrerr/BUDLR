package
{
	import org.flixel.*;
	
	public class Player extends FlxSprite
	{
		[Embed(source="data/darwin.png")] private var ImgDarwin:Class;
		
		public var startTime:Number;
		public var roundOver:Boolean;
		
		public const MOVEMENT_SPEED:int = 400.0;
		
		public function Player(X:int,Y:int)
		{
			super(X,Y);
			loadGraphic(ImgDarwin,true,true,32,32);
			
			// Bounding box tweaks
			width = 16;
			height = 16;
			offset.x = 8;
			offset.y = 16;
			
			// Init
			roundOver = false;
			
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
		
		public function stop():void
		{
			velocity.x = 0;
			velocity.y = 0;
		}
		
		public function processControl(control:String):void
		{
			if( control == "Left" )
			{
				velocity.x = -MOVEMENT_SPEED;
			}
			else if ( control == "Right" )
			{
				velocity.x = MOVEMENT_SPEED;
			}
			else if ( control == "Up" )
			{
				velocity.y = -MOVEMENT_SPEED;
			}
			else if ( control == "Down" )
			{
				velocity.y = MOVEMENT_SPEED;
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