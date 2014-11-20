package packages.sprites
{
    import feathers.controls.Button;
    import feathers.themes.QuickBarMetalWorksTheme;
    
    import flash.geom.Point;
    
    import packages.gui.QuickBarLogic;
    
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.*;
    import starling.text.TextField;
    
    public dynamic class QuickBarSprite extends Sprite
    {
		public var slots: Array = new Array;
		public var backgroundSprite: Sprite = new Sprite;
		public var lockButton:Sprite = new Sprite;
		public var paddingPoint:Point = new Point;
		public var fakeEmptyButton:Sprite = new Sprite;
		public var overFrameSprite:Sprite = new Sprite;
		
		public function QuickBarSprite()
		{
			this.addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
		}
		
		public function addedToStageHandler(event:Event ):void
		{
			this.removeEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
			var quickBarTheme:QuickBarMetalWorksTheme = new QuickBarMetalWorksTheme(this);
			
			var backgroundImage:Image = new Image(Assets.getAtlas("QUICKBAR").getTexture("QuickbarMain"));
			backgroundSprite.addChild(backgroundImage);
			addChild(backgroundSprite);
			
			//adding the lock button
			var lockedImage:Image = new Image(Assets.getAtlas("QUICKBAR").getTexture("locked"));
			var unlockedImage:Image = new Image(Assets.getAtlas("QUICKBAR").getTexture("unlocked"));
			lockedImage.name = "locked";
			unlockedImage.name = "unlocked";
			lockButton.addChild(lockedImage);
			lockButton.addChild(unlockedImage);
			lockButton.getChildByName("locked").visible = false;
			lockButton.getChildByName("unlocked").visible = !lockButton.getChildByName("locked").visible;
			lockButton.name = "lockButton";
			addChild(lockButton);
			
			for( var i:int=0;i<QuickBarLogic.MAX_SKILLS;i++)
			{
				var index:int=i+1;
				var button: Button = new Button;
				if(index<10)
					button.label = String(index);
				else
				{
					if(index==10)	button.label = "0";
					else if(index==11)	button.label = "-";
					else if(index==12)	button.label = "=";
				}
				button.nameList.add(QuickBarMetalWorksTheme.ALTERNATE_NAME_QUICKBAR_BUTTON);
				//trace(index);
				/*if(index==1 || index==4)
				{
					var highlight:Image = new Image(Assets.getAtlas("QUICKBAR").getTexture("QuickbarHighlight"));
					highlight.name = "highlight";
					//highlight.visible = false;
					highlight.width = highlight.width-2;
					highlight.height = highlight.height-2;
					highlight.x = highlight.y = -17;
					button.addChild(highlight);
				}*/
				slots[index] = button;
				addChild( button);
			}
			
			paddingPoint.x = Math.ceil((slots[1] as Button).defaultSkin.width / 3);
			paddingPoint.y = Math.ceil((slots[1] as Button).defaultSkin.height / 3);
			
			//adding a fake button and an over frame for future use when handling icons on quick bar in the main starling front Sprite
			//Firstly, the frame
			overFrameSprite.touchable = false;
			overFrameSprite.visible = false;
			
			var overFrameImage:Image = new Image(Assets.getAtlas("QUICKBAR").getTexture("QuickbarHighlight"));
			overFrameImage.width = overFrameImage.width-2;
			overFrameImage.height = overFrameImage.height-2;
			overFrameSprite.addChild(overFrameImage);
			
			addChild(overFrameSprite);
			
			//secondly, the fake button
			fakeEmptyButton.touchable = false;
			fakeEmptyButton.visible = false;
			
			var fakeEmptyIcon:Image = new Image(Assets.getAtlas("QUICKBAR").getTexture("EmptyIcon"));
			fakeEmptyButton.addChild(fakeEmptyIcon);
			
			var fakeEmptyLabel:TextField = new TextField(20,20,"","Helvetica",14,0x89cee4);
			fakeEmptyLabel.name = "fakeEmptyLabel";
			fakeEmptyButton.addChild(fakeEmptyLabel);
			
			addChild(fakeEmptyButton);
		}
	}
}