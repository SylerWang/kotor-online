package packages.characters
{
	import flash.ui.Keyboard;
	
	import away3d.animators.transitions.CrossfadeTransition;
	
	import starling.rootsprites.StarlingFrontSprite;
	
	public class Characters
    {
		public function Characters()
        {
            trace(" Characters");
        }
		
		public function updateCharacters(characters: Array):void
		{
			//skip intro
			if (Main.getKeyState(Keyboard.ESCAPE) && Main.introState)
				Main.INTRO.skipIntro();
			
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
				for each (var character: Character in characters)
				{
					if (character.avatar.animatorClass.activeAnimationName != Animation.animationString(Animation.IDLE))
					{
						character.avatar.activeAnimationBody = character.avatar.characterBody + "_" + Animation.animationString(Animation.IDLE);
						character.avatar.activeAnimationHead = character.avatar.characterHead + "_" + Animation.animationString(Animation.IDLE);
						character.avatar.animatorClass.play(character.avatar.activeAnimationBody, new CrossfadeTransition(.3));
						if(character.race != Race.UNDEFINED)	character.avatar.animatorRace.play(character.avatar.activeAnimationHead, new CrossfadeTransition(.3));
					}
				}
			}
			else if (Main.suspendState != true)
			{
				//TO DO perhaps it should be only for active character in player party
				for each (character in characters)
				{	
					character.avatar.animatorClass.playbackSpeed = 1;
					if(character.race != Race.UNDEFINED)	character.avatar.animatorRace.playbackSpeed = 1;
					
					if (character.avatar.animatorClass.activeAnimationName == "single_saber_attack_1" || character.avatar.animatorClass.activeAnimationName == "single_saber_wield_idle_to_melee")
					{
						
					}			
					else //if (character.avatar.animatorClass.activeAnimationName == "run" || character.avatar.animatorClass.activeAnimationName == "pause2")
					{	
						//use keyboard only on active/selected party member
						if( character.selected == true)
						{
							if (Main.getKeyState(Keyboard.LEFT))
							{
								for( var m:int=0;m<character.avatar.meshes.length;m++)
								{
									character.avatar.meshes[m].rotationY -= 5 * Main.timeStep.delta;
								}
							}
							if (Main.getKeyState(Keyboard.RIGHT))
							{
								for(m=0;m<character.avatar.meshes.length;m++)
								{
									character.avatar.meshes[m].rotationY += 5 * Main.timeStep.delta;
								}
							}
							
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
						}
						
						if (Main.gameState)//TO DO. Do I need this here? Or should I replace it with !suspendState
						{
							if(character.actions[0] == Action.IDLE || character.actions[0] == Action.DIALOG || character.actions.length == 0)
							{
								//TO DO  set animation based on active weapon //&& character.saberOn
								//if (character.avatar.animatorClass.activeAnimationName != "single_saber_melee_idle")
								if (character.avatar.animatorClass.activeAnimationName != Animation.animationString(Animation.IDLE))
								{
									character.avatar.activeAnimationBody = character.avatar.characterBody + "_" + Animation.animationString(Animation.IDLE);
									character.avatar.activeAnimationHead = character.avatar.characterHead + "_" + Animation.animationString(Animation.IDLE);
									//character.avatar.animatorClass.play("single_saber_melee_idle", new CrossfadeTransition(.3));
									character.avatar.animatorClass.play(character.avatar.activeAnimationBody, new CrossfadeTransition(.3));
									if(character.race != Race.UNDEFINED)	character.avatar.animatorRace.play(character.avatar.activeAnimationHead, new CrossfadeTransition(.3));
								}
							}
							else if (character.actions[0] == Action.MOVE)
							{
								if (character.avatar.animatorClass.activeAnimationName != Animation.animationString(Animation.RUN)) 
								{
									character.avatar.activeAnimationBody = character.avatar.characterBody + "_" + Animation.animationString(Animation.RUN);
									character.avatar.activeAnimationHead = character.avatar.characterHead + "_" + Animation.animationString(Animation.RUN);
									character.avatar.animatorClass.play(character.avatar.activeAnimationBody, new CrossfadeTransition(.3));
									if(character.race != Race.UNDEFINED)	character.avatar.animatorRace.play(character.avatar.activeAnimationHead, new CrossfadeTransition(.3));	
								}
							}
							else
							{
								if (character.avatar.animatorClass.activeAnimationName != character.avatar.activeAnimationBody) 
								{
									character.avatar.animatorClass.play(character.avatar.activeAnimationBody, new CrossfadeTransition(.3));
									if(character.race != Race.UNDEFINED)	character.avatar.animatorRace.play(character.avatar.activeAnimationHead, new CrossfadeTransition(.3));
								}
							}
						}
						
						/*if (Main.getKeyState(Keyboard.COMMA))
						{
							if (Main.alreadyPressed == false)
							{
								Main.alreadyPressed = true;
								character.avatar.animatorClass.play("single_saber_attack_1", new CrossfadeTransition(.3), 0);
							}
						}*/
					}
				}
			}
			/*else
			{
				
			}*/
		}
	}
}