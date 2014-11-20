package packages.sprites
{
    import feathers.controls.Button;
    import feathers.themes.CharacterCreationMetalWorksTheme;
    
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.*;
    import starling.text.TextField;
    
    public class CharacterCreationSprite extends Sprite
    {
		private var genderButtons:Array=["Male", "Female"];
		private var raceButtons: Array=["Human", "Sith", "Chiss", "Kiffar"];
		private var classButtons: Array=["Guardian", "Consular", "Scoundrel", "Officer"];
		public var originButtons: Array= ["Core", "Mercenary", "Philosophy", "Scientist", "Slave"];
		public var buttonsType: Array=[ genderButtons, raceButtons,  classButtons, originButtons];
		private var buttonsName: Array=[ "Gender", "Race", "Class", "Origin"];
		public var buttons: Array = new Array;
		public var length:int = Math.max(genderButtons.length,raceButtons.length,classButtons.length,originButtons.length);
		
		public function CharacterCreationSprite()
		{
			this.addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
		}
		
		public function addedToStageHandler(event:Event ):void
		{
			this.removeEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
			var characterCreation:CharacterCreationMetalWorksTheme = new CharacterCreationMetalWorksTheme(this);
			
			for( var i:int=0;i< buttonsType.length;i++)
			{
				for( var j:int=0;j< buttonsType[i].length;j++)
				{
					var button: Button = new Button;
					var type:TextField = new TextField(0,0,buttonsName[i]);
					type.name="type";
					button.addChild( type);
					button.label = buttonsType[i][j];
					button.nameList.add(CharacterCreationMetalWorksTheme.ALTERNATE_NAME_CHARACTERCREATION_BUTTON);
					buttons.push( button);
					addChild( button);
				}
			}
		}
	}
}