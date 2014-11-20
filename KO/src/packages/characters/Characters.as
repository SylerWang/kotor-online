package packages.characters
{
	import away3d.animators.transitions.CrossfadeTransition;
	
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	
	import starling.rootsprites.StarlingFrontSprite;
	
	public class Characters
    {
		public function Characters()
        {
            trace(" Characters");
        }
		
		public function updateCharacter(party: Party):void
		{
			//handle shortcuts
			if (Main.getKeyState(Keyboard.K))
			{
				if (Main.alreadyPressed == false)
				{
					Main.alreadyPressed = true;
					StarlingFrontSprite.getInstance().handleAbilities();
				}
			}
			//handle shortcuts during game
			if (Main.suspendState == true)
			{
				if (Main.activePlayerCharacter.animatorClass.activeAnimationName != Animation.animationString(Animation.IDLE))
				{
					Main.activePlayerCharacter.activeAnimationBody = Main.activePlayerCharacter.characterBody + "_" + Animation.animationString(Animation.IDLE);
					Main.activePlayerCharacter.activeAnimationHead = Main.activePlayerCharacter.characterHead + "_" + Animation.animationString(Animation.IDLE);
					Main.activePlayerCharacter.animatorClass.play(Main.activePlayerCharacter.activeAnimationBody, new CrossfadeTransition(.3));
					if(Main.activePlayerCharacter.race != Race.UNDEFINED)	Main.activePlayerCharacter.animatorRace.play(Main.activePlayerCharacter.activeAnimationHead, new CrossfadeTransition(.3));
				}
			}
			else if (Main.suspendState != true)
			{
				//TO DO perhaps it should be only for active character in player party
				for each (var character: Character in party.members)
				{	
					character.animatorClass.playbackSpeed = 1;
					if(character.race != Race.UNDEFINED)	character.animatorRace.playbackSpeed = 1;
					
					if (character.animatorClass.activeAnimationName == "single_saber_attack_1" || character.animatorClass.activeAnimationName == "single_saber_wield_idle_to_melee")
					{
						
					}			
					else //if (character.animatorClass.activeAnimationName == "run" || character.animatorClass.activeAnimationName == "pause2")
					{			
						if (Main.getKeyState(Keyboard.LEFT))
						{
							for( var m:int=0;m<character.characterMesh.length;m++)
							{
								character.characterMesh[m].rotationY -= 5 * Main.timeStep.delta;
							}
							character.activeRotation.y -= 5 * Main.timeStep.delta;
						}
						if (Main.getKeyState(Keyboard.RIGHT))
						{
							for(m=0;m<character.characterMesh.length;m++)
							{
								character.characterMesh[m].rotationY += 5 * Main.timeStep.delta;
							}
							character.activeRotation.y += 5 * Main.timeStep.delta;
						}
						
						/*else
						{
						if (character.animatorClass.activeAnimationName != "pause2") 
						{
						character.animatorClass.play("pause2", new CrossfadeTransition(.3));	
						}
						}*/
						
						/*if (Main.getKeyState(Keyboard.SPACE))
						{
							if (Main.alreadyPressed == false)
							{
								Main.alreadyPressed = true;
								Main.swapPlayer();
							}
						}*/
						
						//test a condition
						if (Main.getKeyState(Keyboard.COMMA))
						{
							if (Main.alreadyPressed == false)
							{
								Main.alreadyPressed = true;
								//trace("before",Main.CONDITIONS.ATTON_JOIN);
								Main.CONDITIONS.ATTON_JOIN=!Main.CONDITIONS.ATTON_JOIN;
								//trace("after",Main.CONDITIONS.ATTON_JOIN);
							}
						}
						
						/*if (Main.getKeyState(Keyboard.SPACE))
						{
							if (Main.alreadyPressed == false)
							{
								Main.alreadyPressed = true;
								Main.saberOn = !Main.saberOn;
								if ( Main.saberOn )
								{
									character.animatorClass.play("single_saber_wield_idle_to_melee", new CrossfadeTransition(.3), 0);
								}
								else
								{
									character.animatorClass.playbackSpeed = -1;
									character.animatorClass.play("single_saber_wield_idle_to_melee", new CrossfadeTransition(.3), 0);
								}
								Main.weaponJointObject.visible = !Main.weaponJointObject.visible;
								Main.hiltJointObject.visible = !Main.hiltJointObject.visible;
							}
						}*/
						
						if (Main.gameState && !Main.movingPlayer)
						{
							//TO DO  set animation based on active weapon //&& character.saberOn
							//if (character.animatorClass.activeAnimationName != "single_saber_melee_idle")
							if (character.animatorClass.activeAnimationName != Animation.animationString(Animation.IDLE))
							{
								character.activeAnimationBody = character.characterBody + "_" + Animation.animationString(Animation.IDLE);
								character.activeAnimationHead = character.characterHead + "_" + Animation.animationString(Animation.IDLE);
								//character.animatorClass.play("single_saber_melee_idle", new CrossfadeTransition(.3));
								character.animatorClass.play(character.activeAnimationBody, new CrossfadeTransition(.3));
								if(character.race != Race.UNDEFINED)	character.animatorRace.play(character.activeAnimationHead, new CrossfadeTransition(.3));
							}
						}
						else if (Main.movingPlayer)
						{
							if (character.animatorClass.activeAnimationName != Animation.animationString(Animation.RUN)) 
							{
								character.activeAnimationBody = character.characterBody + "_" + Animation.animationString(Animation.RUN);
								character.activeAnimationHead = character.characterHead + "_" + Animation.animationString(Animation.RUN);
								character.animatorClass.play(character.activeAnimationBody, new CrossfadeTransition(.3));
								if(character.race != Race.UNDEFINED)	character.animatorRace.play(character.activeAnimationHead, new CrossfadeTransition(.3));	
							}
						}
						else
						{
							if (character.animatorClass.activeAnimationName != character.activeAnimationBody) 
							{
								character.animatorClass.play(character.activeAnimationBody, new CrossfadeTransition(.3));
								if(character.race != Race.UNDEFINED)	character.animatorRace.play(character.activeAnimationHead, new CrossfadeTransition(.3));
							}
						}
						
						/*if (Main.getKeyState(Keyboard.COMMA))
						{
							if (Main.alreadyPressed == false)
							{
								Main.alreadyPressed = true;
								character.animatorClass.play("single_saber_attack_1", new CrossfadeTransition(.3), 0);
							}
						}*/
						
						//skip intro
						if (Main.getKeyState(Keyboard.ESCAPE) && Main.introState)
							Main.INTRO.skipIntro();
					}
				}
			}
			/*else
			{
				
			}*/
		}
	}
}