package
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	
	public class BombDrop extends FlxSprite
	{
		[Embed(source='../data/bombdrop.png')] private var ImgBombDrop:Class;
		
		public function BombDrop ( x:Number, y:Number ):void
		{
			this.x = x;
			this.y = y;
			this.offset.y = 330;
			
			loadGraphic(ImgBombDrop, true, true, 32, 360);
			addAnimation("drop", [0,1,2,3,4,5], 15, false);
		}
		
		override public function update():void
		{
			if( finished )
			{
				kill();
				return;
			}
			else 
			{
				play( "drop" );
				
			}
			

			super.update();			
		}
	}
}