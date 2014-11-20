package starling.rootsprites
{
 	import feathers.controls.Button;
 	
 	import flash.geom.Vector3D;
 	
 	import packages.characters.*;
 	import packages.gui.CharacterCreationLogic;
 	import packages.sprites.CharacterCreationSprite;
 	
 	import starling.display.Image;
 	import starling.display.Sprite;
 	import starling.events.*;
 	import starling.text.TextField;
 	
 	import sunag.sea3d.SEA3D;

	public class StarlingCharacterCreationSprite extends Sprite
	{
		private static var _instance : StarlingCharacterCreationSprite;
		public var characterCreationLogic:CharacterCreationLogic;
		public var characterCreationSprite:CharacterCreationSprite = new CharacterCreationSprite;
		
		public static function getInstance():StarlingCharacterCreationSprite
		{
			return _instance;
		}
		
		/**
		 * Constructor.
		 */
		public function StarlingCharacterCreationSprite()
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
			 trace( "Starling CharacterCreation initialize");
			 var _characterCreationImage:Image = new Image(Assets.getAtlas("CHARACTERCREATION").getTexture("CharacterCreation"));
			 _characterCreationImage.scaleX = stage.stageWidth/_characterCreationImage.width;
			 _characterCreationImage.scaleY = stage.stageHeight/_characterCreationImage.height;
			 //_characterCreationImage.alpha = .5;
			 addChild(_characterCreationImage);

			 var logoImage:Image = new Image(Assets.getAtlas("MAINMENUOBJECTS").getTexture("Logo"));
			 logoImage.x = 50;
			 logoImage.y = 50;
			 addChild(logoImage);
			 
			 //handle the extra objects
			 characterCreationSprite.scaleX = characterCreationSprite.scaleX*Main._scale1280;
			 characterCreationSprite.scaleY = characterCreationSprite.scaleY*Main._scale1280;
			 characterCreationLogic = new CharacterCreationLogic(characterCreationSprite);
			 characterCreationSprite.x = Main.APP_WIDTH/2;
			 addChild(characterCreationSprite);
			 
			 //add the next button
			 var nextButton:Button = new Button;
			 var buttonDownState:Image = new Image(Assets.getAtlas("MAINMENUOBJECTS").getTexture("Button_Down"));
			 var buttonUpState:Image = new Image(Assets.getAtlas("MAINMENUOBJECTS").getTexture("Button_Up"));
			 var buttonOverState:Image = new Image(Assets.getAtlas("MAINMENUOBJECTS").getTexture("Button_Over"));
			 var _width:int = buttonUpState.width;
			 var _height:int = buttonUpState.height;
			 var _label:TextField = new TextField(_width, _height, "Next", "Helvetica", 14, 0xddcba2);
			 _label.name = "_label";
			 nextButton.addChild(_label);
			 nextButton.defaultSkin = buttonUpState;
			 nextButton.hoverSkin = buttonOverState;
			 nextButton.downSkin = buttonDownState;	
			 nextButton.x = Main.APP_WIDTH*0.75;
			 nextButton.y = Main.APP_HEIGHT - _height;
			 nextButton.addEventListener(Event.TRIGGERED, triggeredHandler);
			 addChild( nextButton);
		}
		
		private function triggeredHandler( event:Event): void
		{
			//TO DO this can be cleaned up, it's not very pretty currently
			trace( "Setting game state  and loading map");
			var cid:int = Main.playerParty.members[0].classes;
			
			Main.STATES.handleStates("gameState");
			
			Main.activePlayerCharacter = new Character(cid, false);
			Main.activePlayerCharacter.characterName = "Boske Tar";
			Main.activePlayerCharacter.race = Main.playerParty.members[0].race;
			Main.activePlayerCharacter.gender = Main.playerParty.members[0].gender;
			Main.activePlayerCharacter.origin = Main.playerParty.members[0].origin;
			
			//manually set the sea3d container to refer to humanoid meshes
			for( var i:int=0;i<Main.sea3dResourcesString.length;i++)
				if(Main.sea3dResourcesString[i] == "mesh_humanoid")
					var sea3dMesh:SEA3D = Main.sea3dResources[i];
			//scale and position and X rotation meshes
			Main.MOVEONMAP.positionOriginalMeshes(sea3dMesh);
			
			//up until now, this was used temporarily, but now it needs to be populated with a final chosen character
			Main.playerParty.members.splice(0,1);
			Main.playerParty.members.push(Main.activePlayerCharacter);
			
			//empty and re-create the chosen character avatar
			Main.activePlayerCharacter.avatar = null;
			Main.activePlayerCharacter.characterMesh = new Array;
			var avatar: Avatar = new Avatar(Main.activePlayerCharacter, true);
			avatar.setAvatar(Main.activePlayerCharacter);
			
			//set the active character in the middle of the screen
			for( var m:int=0;m<Main.activePlayerCharacter.characterMesh.length;m++)
			{
				Main.activePlayerCharacter.characterMesh[m].position = new Vector3D(0,0,0);
				Main.activePlayerCharacter.characterMesh[m].rotation = new Vector3D(0,-45,0);
				Main.activePlayerCharacter.characterMesh[m].scale = new Vector3D(1,1,1);
			}
			
			//if player is Jedi, give it the light saber
			if(Main.activePlayerCharacter.classes == Classes.GUARDIAN || Main.activePlayerCharacter.classes == Classes.CONSULAR)
				Main.activePlayerCharacter.activeWeapon = Weapon.LIGHTSABER;
			
			trace( "setting the player Main.activePlayerCharacter to",Gender.genderString(Main.activePlayerCharacter.gender), Race.raceString(Main.activePlayerCharacter.race), Classes.classString(Main.activePlayerCharacter.classes), Origins.originsString(Main.activePlayerCharacter.origin), "with meshes",Main.activePlayerCharacter.characterMesh.length);

			//at this point, character is ready, so we can move on to the next
			Main.MAP3D.setMapPlanes();
			StarlingFrontSprite.getInstance().handleBars();
			Main.MAPLOGIC.initializeMap();
		}			
	}
}