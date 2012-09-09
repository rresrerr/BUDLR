package
{
	import org.flixel.*;
	
	public class Tile extends FlxSprite
	{
		[Embed(source='../data/block.png')] private var ImgTile1:Class;
		[Embed(source='../data/block.png')] private var ImgTile2:Class;
		[Embed(source='../data/barrel.png')] private var ImgTile3:Class;
		[Embed(source='../data/fire.png')] private var ImgTile4:Class;
		
		private var _player1:Player;
		private var _player2:Player;
		public var type:int;
		
		public function Tile( tileType:Number, X:Number, Y:Number, player1:Player, player2:Player ):void
		{
			super(X,Y);
			
			_player1 = player1;
			_player2 = player2;
			
			addAnimation("fire", [0,1,2,0,1,2], 8, false);
			
			updateGraphic(tileType);
		}
		
		private function updateGraphic( tileType:int):void
		{
			width = 32;
			height = 36;
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
				case 2:
					loadGraphic(ImgTile3, true, true, width, height);
					break;
				case 3:
					loadGraphic(ImgTile4, true, true, width, height);
					play("fire");
					break;
			}
			type = tileType;
		}
		
		public function catchFire():void
		{
			updateGraphic( 3 );
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