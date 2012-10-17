package
{
	import org.flixel.*;
	
	public class IntroSplash extends FlxSprite
	{
		[Embed(source='../data/title.png')] private var ImgTitle:Class;
		
		public function IntroSplash(X:int,Y:int):void
		{
			super(X,Y);
			
			loadGraphic(ImgTitle, true, true, 352, 144);
			
			addAnimation("animate", [0,1], 6);
		}
		
		override public function update():void
		{
			play( "animate" );
			super.update();
		}
	}
}
