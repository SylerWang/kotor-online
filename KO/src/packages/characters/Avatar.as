package packages.characters
{
	import flash.geom.Vector3D;
	
	import away3d.animators.SkeletonAnimationSet;
	import away3d.animators.SkeletonAnimator;
	import away3d.animators.nodes.SkeletonClipNode;
	import away3d.entities.Mesh;
	import away3d.events.MouseEvent3D;
	import away3d.tools.utils.Bounds;
	
	import ru.inspirit.steering.SteerVector3D;
	import ru.inspirit.steering.Vehicle;
	
	import sunag.sea3d.SEA3D;
	
	public class Avatar extends Object
	{
		//character meshes/animation related
		public var activeAnimation: String;
		public var activeAnimationHead: String;
		public var activeAnimationBody: String;
		public var characterBody: String;
		public var characterHead: String;
		public var characterClass:Mesh;
		public var characterRace: Mesh;
		public var meshes: Array = new Array;
		public var animatorClass:SkeletonAnimator;
		public var animatorRace:SkeletonAnimator;
		
		private var currentCharacter:Character;
		private var selectedCharacter:Character;
		private var sea3dMesh:SEA3D;

		//vehicle
		public var vehicle:Vehicle;
		public var obstacles: Array = new Array;
		public var bounds:SteerVector3D = new SteerVector3D;
		
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
					
					if(charRef.dialog != -1)
						selectedCharacter.actions.unshift(Action.DIALOG);
					
					if (Main.MAP3D.zeroVector.equals(selectedCharacter.targetCharacter.routeVector.subtract(selectedCharacter.routeVector)) == false)
					{
						if( selectedCharacter.actions[0] != Action.MOVE)
							selectedCharacter.actions.unshift(Action.MOVE);
					}
				}
			}
		}
		
		private function onMouseOver( event:MouseEvent3D): void
		{
			if(Main.gameState)
			{
				Main.O2D.displayName(charRef);
			}
		}
		
		private function onMouseOut( event:MouseEvent3D): void
		{
			if(Main.gameState)
			{
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
					h = int(Main.STATES.randomNumber(0,headArray.length-1));
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
				characterClass = sea3dMesh.getMesh(characterClassMesh).clone() as Mesh;
				characterClass.mouseEnabled = true;
				characterClass.addEventListener(MouseEvent3D.MOUSE_OVER, onMouseOver);
				characterClass.addEventListener(MouseEvent3D.CLICK, onMouseClick);
				characterClass.addEventListener(MouseEvent3D.MOUSE_OUT, onMouseOut);
				Main.away3dView.scene.addChild(characterClass);
				
				if(isMisc==false)
				{
					characterRace = sea3dMesh.getMesh(characterRaceMesh).clone() as Mesh;
					Main.away3dView.scene.addChild(characterRace);
				}
			}
			else
			{
				characterClass = sea3dMesh.getMesh(characterClassMesh);
				if(isMisc==false)	characterRace = sea3dMesh.getMesh(characterRaceMesh);
			}

			animatorClass = characterClass.animator as SkeletonAnimator;
			if(isMisc==false)	animatorRace = characterRace.animator as SkeletonAnimator;
			
			//TO DO adding the meshes to an array. For ease of use later on
			meshes.push(characterClass);
			if(isMisc==false)	meshes.push(characterRace);
			
			if(Main.menuState || Main.characterCreationState)
			{
				//scale and position and X rotation meshes
				Main.MOVEONMAP.positionOriginalMeshes(sea3dMesh);
				
				if(Main.menuState)
				{
					Main.hideBootloader();
					for( var m:int=0;m<meshes.length;m++)
					{
						meshes[m].position = new Vector3D(-Main.APP_WIDTH/4,-Main.APP_HEIGHT/4,0);
						meshes[m].rotation = new Vector3D(0,45,0);
					}
				}
				if(Main.characterCreationState)
				{
					//TO DO handling the character position here because it changes many times
					for(m=0;m<meshes.length;m++)
					{
						var _d: Number;//apply some Delta on Y axis for better positioning
						if (Math.abs(Main.gameStage.stageWidth - 1280) < 100)	_d=80;
						else if (Math.abs(Main.gameStage.stageWidth - 1600) < 100) _d=70;
						else _d=50;
						meshes[m].position = new Vector3D(Main.APP_WIDTH/4,-Main.APP_HEIGHT/4+_d,0);
						meshes[m].rotation = new Vector3D(0,-45,0);
						meshes[m].scale = new Vector3D(2,2,2);//scale bigger
					}
				}
			}
			
			//if(isMisc==false)	buildAnimationSet(character);
			//else	
			buildAnimationSet(character);//build animation set for character
		}
		
		private function buildAnimationSet(character:Character): void
		{
			if(characterHead == null)	 characterHead = Gender.genderString(character.gender).toLowerCase() + "_head";
			if(characterBody == null)	 characterBody = Gender.genderString(character.gender).toLowerCase() + "_body_" + Classes.classString(Classes.getBaseClassOf(character.classes)).toLowerCase();
			
			//identify the correct animation resource in the array based on its string mirror
			for( var i:int=0;i<Main.sea3dResourcesString.length;i++)
			{
				if(Main.sea3dResourcesString[i].indexOf("animation") != -1)
				{
					var sea3dAnimation:SEA3D = Main.sea3dResources[i];
					
					var clipNodes:Vector.<SkeletonClipNode> = sea3dAnimation.getSkeletonAnimationNodes(characterBody);			
					var skeletonAnimationSet:SkeletonAnimationSet = animatorClass.animationSet as SkeletonAnimationSet;
					
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
					if(activeAnimation == null)	activeAnimation = Animation.animationString(Animation.IDLE);
					
					//play default animation for class/body
					activeAnimationBody = characterBody + "_" + activeAnimation;
					animatorClass.play(activeAnimationBody);
					
					//if the character has 2 meshes, the race is the head, usually human meshes
					if(character.race != Race.UNDEFINED)
					{
						clipNodes = sea3dAnimation.getSkeletonAnimationNodes(characterHead);			
						skeletonAnimationSet = animatorRace.animationSet as SkeletonAnimationSet;
						
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
						activeAnimationHead = characterHead + "_" + activeAnimation;
						animatorRace.play(activeAnimationHead);
					}
				}
			}
		}
		
		//TO DO there may be a better way to handle setting the bounds
		public function setbounds3d( character: Character):SteerVector3D
		{
			Bounds.getObjectContainerBounds(characterClass);
			var _w: Number=Bounds.width;
			var _h: Number=Bounds.height;
			var _d: Number=Bounds.depth;
			return new SteerVector3D(_w,_h,_d);
		}
	}
}