package packages.characters
{
	import away3d.animators.SkeletonAnimationSet;
	import away3d.animators.SkeletonAnimator;
	import away3d.animators.nodes.SkeletonClipNode;
	import away3d.core.pick.PickingType;
	import away3d.entities.Mesh;
	import away3d.events.*;
	import away3d.tools.utils.Bounds;
	
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.rootsprites.StarlingFrontSprite;
	import starling.text.TextField;
	
	import sunag.sea3d.SEA3D;
	
	public class Avatar extends Object
	{
		private var currentCharacter:Character;
		private var selectedCharacter:Character;
		private var sea3dMesh:SEA3D;
		public var over: Boolean = false;
		
		public function Avatar(character:Character, hasAvatar: Boolean = false)
		{
			 currentCharacter = character;
			 if(hasAvatar==true)		 character.avatar = this;
			 return;
		}
		
		//important function, here are actions being assigned
		//TO DO.. Do I need to click listener here, maybe  for tablets, not for browsers on desktops
		//assuming that I can handle the click on avatar extrapolating in the main class as part of click on stage function?
		private function onMouseClick( event:MouseEvent3D): void
		{
			if(Main.gameState)
			{
				if(Main.suspendState)	 	trace( "suspend state!");
				else	
				{
					selectedCharacter = Main.selectedCharacter;
					//trace( "avatar 3-D mouse click.");
					selectedCharacter.targetCharacter = charRef;
					selectedCharacter.destinationVector = selectedCharacter.targetCharacter.routeVector;
					Main.MOVEONMAP.moving(selectedCharacter);
					
					if(charRef.dialog != -1)
						selectedCharacter.actions.unshift(Action.DIALOG);
					
					if (Main.MAP3D.zeroVector.equals(selectedCharacter.targetCharacter.routeVector.subtract(selectedCharacter.routeVector)) == false)
					{
						if( selectedCharacter.actions[0] != Action.MOVE)
							selectedCharacter.actions.unshift(Action.MOVE);
					}
				}
				/*else if(charRef.dialog != -1)	
				{
					Main.suspendState = true;
					Main.currentConversationOwner = charRef;
					StarlingFrontSprite.getInstance().bars.visible = false;
					StarlingFrontSprite.getInstance().handleDialog();
				}
				else	 trace("no dialog, ATTACK! :-)");
				//trace( "initiating dialog",charRef.characterName,charRef.dialog);*/
			}
		}
		
		private function onMouseOver( event:MouseEvent3D): void
		{
			if(Main.gameState)
			{
				if(over == false)	 over = true;
				Main.O2D.displayName(charRef);
			}
		}
		
		private function onMouseOut( event:MouseEvent3D): void
		{
			if(Main.gameState)
			{
				if(over == true)	 over = false;
				Main.O2D.removeSprites();
			}
		}
		
		public function get charRef(): Character
		{
			return currentCharacter;
		}
		
		public function animate( animation:int, character:Character): Boolean
		{
			//TO DO
			return false;
		}
				
		public function randomAvatar( character: Character): void
		{
			//manually set the sea3d container to refer to humanoid meshes
			for( var i:int=0;i<Main.sea3dResourcesString.length;i++)
				if(Main.sea3dResourcesString[i] == "mesh_humanoid")
					sea3dMesh = Main.sea3dResources[i];
			//scale and position and X rotation meshes
			Main.MOVEONMAP.positionOriginalMeshes(sea3dMesh);
			
			var bodyArray: Array = new Array;
			var headArray: Array = new Array;
			
			for(var l:int=0;l<sea3dMesh.meshes.length;l++)
			{
				if(sea3dMesh.meshes[l].name.indexOf("_body") != -1)		 
				{
					bodyArray.push(sea3dMesh.meshes[l]);
				}
				else if(sea3dMesh.meshes[l].name.indexOf("_head") != -1)
				{
					headArray.push(sea3dMesh.meshes[l]);
				}
			}
			var head:Function;
			var b:int = int(Main.STATES.randomNumber(0,bodyArray.length-1));
			var h:int = int(Main.STATES.randomNumber(0,headArray.length-1));
			var characterBody:String;
			var characterHead:String;
			
			head = function (h:int): void
			{
				characterBody = bodyArray[b].name;
				characterHead = headArray[h].name;
				if(characterBody.charAt()== characterHead.charAt())
				{
					var tempBody: Array = characterBody.split("_");
					var tempHead: Array = characterHead.split("_");
					character.gender = Gender.genderValue(characterBody.charAt());
					character.classes = Classes.classValue(tempBody[tempBody.length-1]);
					character.race = Race.raceValue(tempHead[tempHead.length-1]);
					setAvatar(character);
					//setAvatar(character);
				}
				else
				{
					var h:int = int(Main.STATES.randomNumber(0,headArray.length-1));
					//trace( "try again");// DHK in case no match
					head(h);
				}
			}
			head(h);
			//trace("Main Menu Character", Gender.genderString( character.gender), Classes.classString(character.classes), Race.raceString(character.race));
		}
		
		public function setAvatar(character: Character, isMisc:Boolean=false): void
		{
			//manually set the sea3d container to refer to humanoid meshes
			for( var i:int=0;i<Main.sea3dResourcesString.length;i++)
				if(Main.sea3dResourcesString[i] == "mesh_humanoid")
					sea3dMesh = Main.sea3dResources[i];
			Main.MOVEONMAP.positionOriginalMeshes(sea3dMesh);
			
			var characterRaceMesh: String = Gender.genderString(character.gender).toLowerCase() + "_head_" + Race.raceString(character.race).toLowerCase();
			var characterClassMesh: String = Gender.genderString(character.gender).toLowerCase() + "_body_" + Classes.classString(character.classes).toLowerCase();
			//trace( characterRaceMesh, characterClassMesh, characterRaceAnimator, characterClassAnimator);
			
			//only when in game It will create a clone, otherwise during character creation It will just shuffled them around
			if(Main.gameState)
			{
				trace( "setting avatar for character", character.characterName);
				character.characterClass = sea3dMesh.getMesh(characterClassMesh).clone() as Mesh;
				character.characterClass.mouseEnabled = true;
				character.characterClass.addEventListener(MouseEvent3D.MOUSE_OVER, onMouseOver);
				character.characterClass.addEventListener(MouseEvent3D.CLICK, onMouseClick);
				character.characterClass.addEventListener(MouseEvent3D.MOUSE_OUT, onMouseOut);
				Main.away3dView.scene.addChild(character.characterClass);
				
				if(isMisc==false)
				{
					character.characterRace = sea3dMesh.getMesh(characterRaceMesh).clone() as Mesh;
					Main.away3dView.scene.addChild(character.characterRace);
				}
			}
			else
			{
				character.characterClass = sea3dMesh.getMesh(characterClassMesh);
				if(isMisc==false)	character.characterRace = sea3dMesh.getMesh(characterRaceMesh);
			}

			character.animatorClass = character.characterClass.animator as SkeletonAnimator;
			if(isMisc==false)	character.animatorRace = character.characterRace.animator as SkeletonAnimator;
			
			//TO DO adding the meshes to an array. For ease of use later on
			character.characterMesh.push(character.characterClass);
			if(isMisc==false)	character.characterMesh.push(character.characterRace);
			
			if(Main.menuState || Main.characterCreationState)
			{
				//scale and position and X rotation meshes
				Main.MOVEONMAP.positionOriginalMeshes(sea3dMesh);
				
				if(Main.menuState)
				{
					Main.hideBootloader();
					for( var m:int=0;m<character.characterMesh.length;m++)
					{
						character.characterMesh[m].position = new Vector3D(-Main.APP_WIDTH/4,-Main.APP_HEIGHT/4,0);
						character.characterMesh[m].rotation = new Vector3D(0,45,0);
					}
				}
				if(Main.characterCreationState)
				{
					//TO DO handling the character position here because it changes many times
					for(m=0;m<character.characterMesh.length;m++)
					{
						character.characterMesh[m].position = new Vector3D(Main.APP_WIDTH/4,-Main.APP_HEIGHT/4,0);
						character.characterMesh[m].rotation = new Vector3D(0,-45,0);
						character.characterMesh[m].scale = new Vector3D(2,2,2);//scale bigger
					}
				}
			}
			
			//if(isMisc==false)	buildAnimationSet(character);
			//else	
			buildAnimationSet(character);//build animation set for character
		}
		
		private function buildAnimationSet(character:Character): void
		{
			if(character.characterHead == null)	 character.characterHead = Gender.genderString(character.gender).toLowerCase() + "_head";
			if(character.characterBody == null)	 character.characterBody = Gender.genderString(character.gender).toLowerCase() + "_body_" + Classes.classString(Classes.getBaseClassOf(character.classes)).toLowerCase();
			
			//identify the correct animation resource in the array based on its string mirror
			for( var i:int=0;i<Main.sea3dResourcesString.length;i++)
			{
				if(Main.sea3dResourcesString[i].indexOf("animation") != -1)
				{
					var sea3dAnimation:SEA3D = Main.sea3dResources[i];
					
					var clipNodes:Vector.<SkeletonClipNode> = sea3dAnimation.getSkeletonAnimationNodes(character.characterBody);			
					var skeletonAnimationSet:SkeletonAnimationSet = character.animatorClass.animationSet as SkeletonAnimationSet;
					
					for each(var node:SkeletonClipNode in clipNodes)
					{
						var index:int = skeletonAnimationSet.animationNames.indexOf(node.name);
						if (index >= 0)
						{
							//trace("animation node already present.");
						}
						else
						{
							//trace(node.name);
							skeletonAnimationSet.addAnimation(node);							
						}
					}
					
					//set default animation as IDLE
					if(character.activeAnimation == null)	character.activeAnimation = Animation.animationString(Animation.IDLE);
					
					//play default animation for class/body
					character.activeAnimationBody = character.characterBody + "_" + character.activeAnimation;
					character.animatorClass.play(character.activeAnimationBody);
					
					//if the character has 2 meshes, the race is the head, usually human meshes
					if(character.race != Race.UNDEFINED)
					{
						clipNodes = sea3dAnimation.getSkeletonAnimationNodes(character.characterHead);			
						skeletonAnimationSet = character.animatorRace.animationSet as SkeletonAnimationSet;
						
						for each(node in clipNodes)
						{
							index = skeletonAnimationSet.animationNames.indexOf(node.name);
							if (index >= 0)
							{
								//trace("animation node already present.");
							}
							else
							{
								//trace(node.name);
								skeletonAnimationSet.addAnimation(node);							
							}
						}
						
						//play default animation  for race/head
						character.activeAnimationHead = character.characterHead + "_" + character.activeAnimation;
						character.animatorRace.play(character.activeAnimationHead);
					}
				}
			}
		}
		
		public function getBounds( character: Character):Vector3D
		{
			Bounds.getObjectContainerBounds(character.characterClass);
			var _w: Number=Bounds.width;
			var _d: Number=Bounds.depth;
			var _h: Number=Bounds.height;
			//character.characterClass.showBounds = true;
			//trace(_w, _d, _h);
			return new Vector3D(_w,_d,_h);
		}
	}
}