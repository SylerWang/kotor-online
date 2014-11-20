package packages.sprites
{
    import feathers.controls.Button;
    import feathers.themes.MenuMetalWorksTheme;
    
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.*;
    //import starling.text.TextField;
    
    public dynamic class MainMenuSprite extends Sprite
    {
		public var newGameButton: Button = new Button;
		public var loadButton: Button = new Button;
		public var optionsButton: Button = new Button;
		public var creditsButton: Button = new Button;
		public var volumeSprite:Sprite = new Sprite;
		public var backgroundSprite:Sprite = new Sprite;
		public var logoSprite:Sprite = new Sprite;
		public var buttons:Array=[newGameButton,loadButton,optionsButton,creditsButton];
		public var buttonsName:Array=["New Game", "Load Game", "Options", "Credits"];
		
		public function MainMenuSprite()
		{
			this.addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
		}
		
		public function addedToStageHandler(event:Event ):void
        {
			this.removeEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
			var menu:MenuMetalWorksTheme = new MenuMetalWorksTheme(this);
			
			//adding the background image
			var backgroundImage:Image = new Image(Assets.getAtlas("MAINMENUOBJECTS").getTexture("Background"));
			backgroundSprite.addChild(backgroundImage);
			addChild(backgroundSprite);

			//adding the logo image
			var logoImage:Image = new Image(Assets.getAtlas("MAINMENUOBJECTS").getTexture("Logo"));
			logoSprite.addChild(logoImage);
			addChild(logoSprite);
			
			//adding the volume image
			var volumeImageOn:Image = new Image(Assets.getAtlas("MAINMENUOBJECTS").getTexture("Volume_ON"));
			var volumeImageOff:Image = new Image(Assets.getAtlas("MAINMENUOBJECTS").getTexture("Volume_OFF"));
			volumeImageOn.name= "volumeImageOn";
			volumeImageOff.name= "volumeImageOff";
			volumeSprite.addChild(volumeImageOn);
			volumeSprite.addChild(volumeImageOff);
			volumeSprite.getChildByName("volumeImageOn").visible = true;
			volumeSprite.getChildByName("volumeImageOff").visible = !volumeSprite.getChildByName("volumeImageOn").visible;
			addChild(volumeSprite);
			
			//adding the buttons
			for( var i:int=0;i< buttons.length;i++)
			{
				buttons[i].label = buttonsName[i];
				buttons[i].nameList.add(MenuMetalWorksTheme.ALTERNATE_NAME_MENU_BUTTON);
				addChild( buttons[i]);
			}
		}
	}
}