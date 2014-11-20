package starling.rootsprites
{
	import packages.gui.MainMenuLogic;
	import packages.sprites.MainMenuSprite;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.*;

	public class StarlingMenuSprite extends Sprite
	{
		private static var _instance : StarlingMenuSprite;
		public var mainMenuLogic:MainMenuLogic;
		public var mainMenuSprite:MainMenuSprite = new MainMenuSprite;
		
		public static function getInstance():StarlingMenuSprite
		{
			return _instance;
		}
		
		/**
		 * Constructor.
		 */
		public function StarlingMenuSprite()
		{
			_instance = this;
			//we'll initialize things after we've been added to the stage
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		/**
		 * Where the magic happens. Start after the main class has been added
		 * to the stage so that we can access the stage property.
		 */
		protected function addedToStageHandler(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			initialize();
		}
		
		public function initialize(): void
		{
			 trace( "Starling Menu initialize");
			 var _menuImage:Image = new Image(Assets.getAtlas("MAINMENU").getTexture("MainMenu"));
			 _menuImage.scaleX = stage.stageWidth/_menuImage.width;
			 _menuImage.scaleY = stage.stageHeight/_menuImage.height;
			 addChild(_menuImage);
			 
			 //handle the extra objects
			 mainMenuLogic = new MainMenuLogic(mainMenuSprite);
			 addChild(mainMenuSprite);
		}
	}
}