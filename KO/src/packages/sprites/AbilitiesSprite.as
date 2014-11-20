package packages.sprites
{
	import feathers.controls.Button;
	import feathers.themes.QuickBarMetalWorksTheme;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.*;
	import starling.text.TextField;
	
	public class AbilitiesSprite extends Sprite
	{
		public var backgroundSprite: Sprite = new Sprite;
		public var detailsSprite: Sprite = new Sprite;
		public var availablePointsSprite: Sprite = new Sprite;
		public var movingBarSprite: Sprite = new Sprite;
		public var abilitiesXSprite: Sprite = new Sprite;
		public var abilitiesTypeArray: Array = new Array;
		public var skillTreeArray: Array = new Array;
		private var abilitiesTypeLength:int = 3;
		private var skillTreeLength:int = 8;
		public var abilitiesTypeSlotPadding:int = 29;
		public var abilitiesTypeSlotSize:int = 80;
		public var arrowLeftSprite: Sprite = new Sprite;
		public var arrowRightSprite: Sprite = new Sprite;
		public var windowLabelText:TextField;
		
		public function AbilitiesSprite()
		{
			this.addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
		}
		
		public function addedToStageHandler(event:Event ):void
		{
			this.removeEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
			var quickBarTheme:QuickBarMetalWorksTheme = new QuickBarMetalWorksTheme(this);
			
			var backgroundImage:Image = new Image(Assets.getAtlas("ABILITIES").getTexture("background_skilltree"));
			//backgroundImage.height = backgroundImage.height*1.025;
			backgroundSprite.addChild(backgroundImage);
			backgroundSprite.touchable = false;
			addChild(backgroundSprite);
			
			//add text field skill tree and class name
			windowLabelText = new TextField(200,14,"","StarJedi",12,0x6fbbd3);
			//windowLabelText.x = 2;
			windowLabelText.y = 12;
			windowLabelText.touchable = false;
			addChild(windowLabelText);
			
			//create a fake invisible movingBar to touch/interact and drag/move, make sure it's always on top of background image/Sprite
			var movingBarQuad:Quad = new Quad(550,20,0x000000);
			movingBarQuad.alpha = 0;
			movingBarSprite.addChild(movingBarQuad);
			movingBarSprite.x = movingBarSprite.y = 10;
			addChild(movingBarSprite);
			
			//create a fake invisible abilitiesX to touch/interact and drag/move, make sure it's always on top of background image/Sprite
			var abilitiesXQuad:Quad = new Quad(12,12,0x000000);
			abilitiesXQuad.alpha = 0;
			abilitiesXQuad.name = "abilitiesX";
			abilitiesXSprite.addChild(abilitiesXQuad);
			abilitiesXSprite.x = backgroundSprite.width - 20;
			abilitiesXSprite.y = 7;
			addChild(abilitiesXSprite);
			
			//adding button slots for talent line icons
			for( var i:int=0;i<abilitiesTypeLength;i++)
			{
				var button:Button = new Button;
				button.nameList.add(QuickBarMetalWorksTheme.ALTERNATE_NAME_QUICKBAR_BUTTON);
				abilitiesTypeArray.push(button);
				addChild( button);
			}
			//adding button slots for skill  tree branch
			for(i=0;i<skillTreeLength;i++)
			{
				button = new Button;
				button.nameList.add(QuickBarMetalWorksTheme.ALTERNATE_NAME_QUICKBAR_BUTTON);
				skillTreeArray.push(button);
				addChild( button);
			}
			//adding left and right arrows
			var arrowLeft:TextField = new TextField(26,26, "<", "MyriadPro-Bold", 26, 0xddcba2, true);
			arrowLeft.name = "arrowLeft";
			arrowLeftSprite.addChild(arrowLeft);
			addChild(arrowLeftSprite);
			
			var arrowRight:TextField = new TextField(26,26, ">", "MyriadPro-Bold", 26, 0xddcba2, true);
			arrowRight.name = "arrowRight";
			arrowRightSprite.addChild(arrowRight);
			addChild(arrowRightSprite);
			
			/*var detailsQuad:Quad = new Quad(300,380,0x000000);
			detailsQuad.alpha = 0;
			detailsSprite.addChild(detailsQuad);*/
			
			var detailsAbilitiesType:TextField = new TextField(300,24,"","StarJedi",18,0xddcba2);
			detailsAbilitiesType.name = "detailsAbilitiesType";
			detailsSprite.addChild(detailsAbilitiesType);
			
			var detailsAbilitiesDescription: TextField = new TextField(300,60, "", "MyriadPro-Bold",14,0x6fbbd3);
			detailsAbilitiesDescription.name = "detailsAbilitiesDescription";
			detailsSprite.addChild(detailsAbilitiesDescription);
			
			var detailsSkillDescription: TextField = new TextField(300,300, "", "Helvetica",12, 0xddcba2);
			detailsSkillDescription.name = "detailsSkillDescription";
			detailsSprite.addChild(detailsSkillDescription);
			
			detailsSprite.touchable = false;
			addChild(detailsSprite);
			
			var availablePointsText:TextField = new TextField(300,16,"AVAILABLE POINTS","MyriadPro-Bold",14,0xddcba2);
			availablePointsText.name = "availablePointsText";
			availablePointsSprite.addChild(availablePointsText);
			
			var availablePointsValue:TextField = new TextField(32,16,"","MyriadPro-Bold",14,0xddcba2);
			availablePointsValue.name = "availablePointsValue";
			availablePointsSprite.addChild(availablePointsValue);
			
			addChild(availablePointsSprite);
		}
	}
}