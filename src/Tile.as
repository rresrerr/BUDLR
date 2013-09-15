package
{
	import org.flixel.*;
	
	public class Tile extends FlxSprite
	{
		[Embed(source='../data/block.png')] private var ImgTile1:Class;
		[Embed(source='../data/block.png')] private var ImgTile2:Class;
		
		[Embed(source='../data/explosion.png')] private var ImgTile4:Class;
		[Embed(source='../data/destruct.png')] private var ImgTile5:Class;
		
		public var type:int;
		public var tileX:int;
		public var tileY:int;
		
		public function Tile( tileType:Number, X:Number, Y:Number ):void
		{
			super(X,Y);
			
			addAnimation("fire", [0,1,2,3], 12, false);
			addAnimation("firespread", [1,2,3], 12, false);
			
			updateGraphic(tileType);
		}
		
		private function updateGraphic( tileType:int):void
		{
			width = 32;
			height = 36;
			offset.x = 0;
			offset.y = 4;
			alpha = 1;
			
			switch (tileType){
				case 0:
					loadGraphic(ImgTile1, true, true, width, height);
					alpha = 0;
					break;
				case 1:
					loadGraphic(ImgTile2, true, true, width, height);
					break;
				case 3:
					width = 33;
					height = 64;
					offset.x = 0;
					offset.y = 38;
					
					loadGraphic(ImgTile4, true, true, width, height);
					play("fire");
					break;
				case 4:
					width = 33;
					height = 64;
					offset.x = 0;
					offset.y = 38;
					
					loadGraphic(ImgTile4, true, true, width, height);
					play("firespread");
					break;
				case 5:
					height = 40;
					offset.y = 8;
					loadGraphic(ImgTile5, true, true, width, height);
					break;
			}
			type = tileType;
		}
		
		public function catchFire():void
		{
			updateGraphic( 3 );
		}
		
		public function spreadFire():void
		{
			updateGraphic( 4 );
		}
		
		override public function update():void
		{			
			super.update();
			if( finished )
			{
				updateGraphic( 0 );
			}
		}
	}
}