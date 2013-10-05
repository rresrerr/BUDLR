package
{
	import org.flixel.*;
	import org.flixel.FlxSortGroup;
	
	public class PlayState extends BasePlayState
	{
		public static var _currLevel:Level;
		
		public static var groupBackground:FlxGroup;
		public static var groupPlayer:FlxGroup;
		public static var groupBombDrop:FlxGroup;
		public static var groupCollects:FlxGroup;
		public static var groupCollectLabels:FlxGroup;
		public static var groupTiles:FlxSortGroup;
		public static var groupBlocks:FlxGroup;
		public static var groupForeground:FlxGroup;
		
		function PlayState():void
		{
			super();
			
			groupBackground = new FlxGroup;
			groupPlayer = new FlxGroup;
			groupCollects = new FlxGroup;
			groupCollectLabels = new FlxGroup;
			groupBombDrop = new FlxGroup;
			groupTiles = new FlxSortGroup;
			groupBlocks = new FlxGroup;
			groupForeground = new FlxGroup;
			
			// Create the level
			var currLevelClass:Class = levelArray[BUDLR.currLevelIndex];
			_currLevel = new currLevelClass( groupBackground );
			
			this.add(groupBackground);
			this.add(groupBombDrop);
			this.add(groupCollects);
			this.add(groupCollectLabels);
			this.add(groupTiles);
			this.add(groupPlayer);
			this.add(groupBlocks);
			this.add(groupForeground);
		}
		
		override public function update():void
		{			
			// Update level
			_currLevel.update();
			
			// Next level
			if( _currLevel.nextLevel() )
			{
				nextLevel();				
			}
			
			super.update();
		}
		
		public function nextLevel():void
		{
			_currLevel.destroy();
			
			BUDLR.currLevelIndex++;
			if( BUDLR.currLevelIndex > levelArray.length - 1 )
			{
				BUDLR.currLevelIndex = 0;
			}
			FlxG.switchState(new PlayState());
		}
		
		override public function create():void
		{
		}

		override public function destroy():void
		{
			// Update level
			_currLevel.destroy();
			
			super.destroy();
		}
	}
}