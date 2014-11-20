//TO DO drag-and-drop, and maybe frame the click skill
package packages.gui
{
	import feathers.controls.Button;
	
	import packages.characters.Classes;
	import packages.skills.Skill;
	import packages.skills.TalentLine;
	import packages.sprites.AbilitiesSprite;
	
	import starling.animation.DelayedCall;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.*;
	import starling.rootsprites.StarlingFrontSprite;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	public class AbilitiesLogic extends Object
	{
		public var clip:AbilitiesSprite;
		private var abilitiesString: String;
		private var abilitiesIndex:int;
		private var abilitiesIcon:Image;
		private var delayedOneTap:DelayedCall = null;
 		private var talentLine:TalentLine;
		private var selectedSkill:Skill;
		public var selectedButton: Button;
		
		public function AbilitiesLogic(arg1:AbilitiesSprite)
		{
			clip = arg1;
			clip.addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
			return;
		}
		
		public function addedToStageHandler( event: Event): void
		{
			clip.removeEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
			if( Main.abilitiesWindowPosition.x == 0 && Main.abilitiesWindowPosition.y == 0)
			{
				clip.x = Main.APP_WIDTH/2 - clip.width/2;
				clip.y = 50;
			}
			else
			{
				clip.x = Main.abilitiesWindowPosition.x;
				clip.y = Main.abilitiesWindowPosition.y;
			}
			
			//rearrange
			clip.detailsSprite.x = 360;
			clip.detailsSprite.y = 40;
			
			clip.availablePointsSprite.x = 24;
			clip.availablePointsSprite.y = 432;
			
			//abilities type slots
			for( var i:int=0;i<clip.abilitiesTypeArray.length;i++)
			{
				clip.abilitiesTypeArray[i].width = clip.abilitiesTypeArray[i].height = clip.abilitiesTypeSlotSize;
				if(i==0)
					clip.abilitiesTypeArray[i].x = clip.abilitiesTypeSlotPadding;
				else
				{
					clip.abilitiesTypeArray[i].x = clip.abilitiesTypeArray[i-1].x + clip.abilitiesTypeArray[i].width + clip.abilitiesTypeSlotPadding;
				}
				clip.abilitiesTypeArray[i].y = 34;
			}
			//slots in skill tree branch
			var row:int=0;
			for(i=0;i<clip.skillTreeArray.length;i++)
			{
				//handle button  tapped once or twice
				//clip.skillTreeArray[i].addEventListener(Event.TRIGGERED, triggeredHandler);
				clip.skillTreeArray[i].addEventListener(TouchEvent.TOUCH, onTouchEvent);
				
				//if skill is first 
				if(i==0) //
				{
					clip.skillTreeArray[i].x = clip.abilitiesTypeArray[1].x + clip.abilitiesTypeSlotSize/2 - clip.skillTreeArray[i].defaultSkin.width/2;
					clip.skillTreeArray[i].y = clip.abilitiesTypeArray[1].y + clip.abilitiesTypeSlotSize + Math.ceil(clip.skillTreeArray[i].defaultSkin.height/5);
				}
				else
				{
					clip.skillTreeArray[i].y = clip.skillTreeArray[0].y + Math.floor(clip.skillTreeArray[i].defaultSkin.height*5/4)*(row+1);
					if (i % 2 == 0) //even
					{
						clip.skillTreeArray[i].x = clip.skillTreeArray[0].x + Math.ceil(clip.skillTreeArray[i].defaultSkin.width*4/3);
						++row;
					}
					else //odd
					{
						clip.skillTreeArray[i].x = clip.skillTreeArray[0].x - Math.ceil(clip.skillTreeArray[i].defaultSkin.width*4/3);
					}
				}
				if(i==clip.skillTreeArray.length-1) //last in tree
					clip.skillTreeArray[i].x = clip.skillTreeArray[0].x;
			}
			
			//rearrange the left and right arrows
			clip.arrowLeftSprite.x = clip.abilitiesTypeArray[1].x - clip.arrowLeftSprite.width;
			clip.arrowRightSprite.x = clip.abilitiesTypeArray[1].x + clip.abilitiesTypeSlotSize;
			clip.arrowLeftSprite.y = clip.arrowRightSprite.y = clip.abilitiesTypeArray[1].y + clip.abilitiesTypeSlotSize/2 - clip.arrowLeftSprite.height/2 - 2;
			
			//set abilities icons
			setAbilities();
			setDetails();
			handleAvailablePoints();
			
			//add class name to window label
			var className: String = Classes.classString( Main.activePlayerCharacter.classes);
			//clip.windowLabelText.text = "";//reset the text
			clip.windowLabelText.text = "skilltree: " + className;
			
			/*trace( "talent lines available for active character:", Main.activePlayerCharacter.talents.length);
			for(i=0;i<Main.activePlayerCharacter.talents.length;i++)
				 trace(TalentLine.talentString(Main.activePlayerCharacter.talents[i].type)+"_"+TalentLine.talentString(Main.activePlayerCharacter.talents[i].treeId));*/
		}
		
		//populate icons for active character
		public function setAbilities(): void
		{
			for(var i:int=0;i<clip.abilitiesTypeArray.length;i++)
			{
				//set the icon type in abilities slot when abilities window added to button
				if(i==0)
				{
					abilitiesIndex = Main.activePlayerCharacter.activeAbilitiesType-1;
					if(abilitiesIndex==-1)	 abilitiesIndex = Main.activePlayerCharacter.talents.length-1;
					getAbilities(i, abilitiesIndex);
				}
				if(i==1)
				{
					abilitiesIndex = Main.activePlayerCharacter.activeAbilitiesType;
					getAbilities(i, abilitiesIndex);
					talentLine = Main.activePlayerCharacter.talents[abilitiesIndex] as TalentLine;
				}
				if(i==2)
				{
					abilitiesIndex = Main.activePlayerCharacter.activeAbilitiesType+1;
					if(abilitiesIndex==Main.activePlayerCharacter.talents.length)	 abilitiesIndex = 0;
					getAbilities(i, abilitiesIndex);
				}
			}
			
			function getAbilities( slot:int, index:int): void
			{
				abilitiesString = TalentLine.talentString(Main.activePlayerCharacter.talents[index].type)+"_"+TalentLine.talentString(Main.activePlayerCharacter.talents[index].treeId);
				//if active visible abilities slot, then display skill tree associated with abilities tree ID
				if(slot==1)
				{
					var skills: Array = Main.activePlayerCharacter.talents[index].skillIds;
					//trace( "active tree has", skills.length, "elements out of", clip.skillTreeArray.length);
					if( skills.length > clip.skillTreeArray.length)
						trace( "there are more talents in this tree then available icons to display them.");
					for(var j:int=0;j<skills.length;j++)
					{
						var button:Button = clip.skillTreeArray[j] as Button;
						
						//cleanup previous icons frames or disable images
						for (var m:uint = 0; m < button.numChildren; m++)
						{
							var childIcon:*=button.getChildAt(m);
							if(childIcon && (childIcon is Image) && (childIcon as Image).name && (childIcon as Image).name.indexOf("slot_") != -1)
								button.removeChild(childIcon);
						}
						
						var childLocked:*=button.getChildByName("disabled");
						if(childLocked)	button.removeChild(childLocked);
						
						var childFrame:*=button.getChildByName("skillFrame");
						if(childFrame)	button.removeChild(childFrame);
						
						var skill:Skill = new Skill(skills[j], Main.activePlayerCharacter);
						
						//evaluate skill type to set  colored frame
						var skillFrame: Image;
						if( skill.type == Skill.TYPE_PASSIVE)
							skillFrame = new Image(Assets.getAtlas("SPECIALS").getTexture("icon_frame_blue"));
						else if( skill.type == Skill.TYPE_TOGGLED)
							skillFrame = new Image(Assets.getAtlas("SPECIALS").getTexture("icon_frame_red"));
						else if( skill.type == Skill.TYPE_TARGETED)
							skillFrame = new Image(Assets.getAtlas("SPECIALS").getTexture("icon_frame_yellow"));
						else if( skill.type == Skill.TYPE_INSTANT)
							skillFrame = new Image(Assets.getAtlas("SPECIALS").getTexture("icon_frame_green"));
						else trace( "skill type not found/defined");
						
						//skillFrame.width = skillFrame.width - 2;
						//skillFrame.height = skillFrame.height - 2;
						skillFrame.x = skillFrame.y = -5;
						skillFrame.alpha = 0.5;
						skillFrame.name = "skillFrame";
						button.addChild(skillFrame);
						
						//add skill icon
						var skillIcon: Image = Skill.getSkillIconForClass( Main.activePlayerCharacter, skill.skillName);
						skillIcon.name = "slot_" + String(skill.skillId) + "_" + skill.skillName;
						button.addChild(skillIcon);
						
						//first  lock them all
						button.isToggle = false;
						Main.O2D.unlockAbilitiesButton(button);

						//evaluate unlocked skill state
						var unlocked: Array = Main.activePlayerCharacter.unlockedSkills;
						if(unlocked.length > 0)
						{
							for(var d:int=0;d<unlocked.length;d++)
							{
								if( unlocked[d].skillId == skill.skillId)
								{
									button.isToggle = true;
									Main.O2D.unlockAbilitiesButton(button);
								}
							}
						}
					}
				}
				
				//handle abilities icon
				var child:*=clip.abilitiesTypeArray[slot].getChildByName("abilitiesIcon");
				if(child)	clip.abilitiesTypeArray[slot].removeChild(child);
				
				abilitiesIcon = new Image(Assets.getAtlas("ABILITIES").getTexture(abilitiesString));
				abilitiesIcon.name = "abilitiesIcon";
				clip.abilitiesTypeArray[slot].addChild(abilitiesIcon);
			}
		}
		
		public function setDetails(): void
		{
			 var abilitiesTypeString: String = TalentLine.talentString(talentLine.treeId);
			 var abilitiesTypeText:TextField = clip.detailsSprite.getChildByName( "detailsAbilitiesType") as TextField;
			 if(abilitiesTypeText)
			 {
				//abilitiesTypeText.text = "";
			 	abilitiesTypeText.text = abilitiesTypeString;
			 }
			 else trace( "abilities type text field not found!");
			 
			 var abilitiesDescriptionString: String = talentLine.description;
			 var abilitiesDescriptionText:TextField = clip.detailsSprite.getChildByName( "detailsAbilitiesDescription") as TextField;
			 if(abilitiesDescriptionText)
			 {
				 abilitiesDescriptionText.y = abilitiesTypeText.y + abilitiesTypeText.height;
				 //abilitiesDescriptionText.text = "";
				 abilitiesDescriptionText.text = abilitiesDescriptionString;
			 }
			 else trace( "abilities description text field not found!");

			 //clear the skill description
			 var detailsSkillDescription:TextField = clip.detailsSprite.getChildByName("detailsSkillDescription") as TextField;
			 if(detailsSkillDescription)	detailsSkillDescription.text = "";
		}
		
		public function handleAvailablePoints(): void
		{
			var availablePointsValue:TextField = clip.availablePointsSprite.getChildByName("availablePointsValue") as TextField;
			if(availablePointsValue)	availablePointsValue.text = String(Main.activePlayerCharacter.skillPoints);
			
			var availablePointsText:TextField = clip.availablePointsSprite.getChildByName("availablePointsText") as TextField;
			if(availablePointsText)	
			{
				availablePointsText.hAlign = HAlign.LEFT;
				availablePointsText.x = availablePointsValue.x + availablePointsValue.width;
			}
		}
		
		private function onOneTap():void
		{
			clearDelayedTap();
			selectedSkill = getSkillInSlot(selectedButton);
			displaySkillDescription();
			//trace( "one tap", selectedSkill.skillName);
		}
		
		private function clearDelayedTap():void 
		{
			if (delayedOneTap) 
			{
				Starling.juggler.remove(delayedOneTap);
				delayedOneTap = null;
			}
		}
		
		private function onTouchEvent(event:TouchEvent):void
		{
			var button: Button = event.target as Button;
			var touch:Touch = event.getTouch(button);
			if (touch == null) return;
			
			if (touch.phase == TouchPhase.ENDED)
			{
				clearDelayedTap();
				if (touch.tapCount > 1) 
				{
					selectedSkill = getSkillInSlot(button);
					displaySkillDescription();
					handleSkillUnlock();
					//trace( "two taps",selectedSkill.skillName);
				}
				else 
				{
					//to make sure we don't confuse one Tap with a trigger from drag-and-drop
					if(StarlingFrontSprite.getInstance().dragging == false)
					{
						selectedButton = button;
						delayedOneTap = new DelayedCall(onOneTap, 0.3);
						Starling.juggler.add(delayedOneTap);
					}
				}
			}
		}
		
		private function displaySkillDescription(): void
		{
			//handle details skill description
			var abilitiesDescriptionText:* = clip.detailsSprite.getChildByName("detailsAbilitiesDescription");
			var detailsSkillDescription:TextField = clip.detailsSprite.getChildByName("detailsSkillDescription") as TextField;
			if(detailsSkillDescription && abilitiesDescriptionText)
			{
				detailsSkillDescription.y = abilitiesDescriptionText.y + abilitiesDescriptionText.height;
				//detailsSkillDescription.text = "";
				detailsSkillDescription.hAlign = HAlign.LEFT;
				detailsSkillDescription.vAlign = VAlign.TOP;
				detailsSkillDescription.text = "here you can put a lot of creative and wonderful information about "
					+ selectedSkill.skillName.toUpperCase()
					+ " and remember to make it very relevant!"
					+ " Information such as: cooldown, upkeep, cost, etc.";
			}
			//var button:Button= Button(event.currentTarget);
		}
		
		private function getSkillInSlot( button: Button): Skill
		{
			var skill: Skill;
			var string: String;
			var split: Array = new Array;
			
			for (var m:uint = 0; m < button.numChildren; m++)
			{
				var childIcon:*=button.getChildAt(m);
				if(childIcon && (childIcon is Image) && (childIcon as Image).name && (childIcon as Image).name.indexOf("slot_") != -1)
					 string = (childIcon as Image).name;
			}
			
			split = string.split("_");
			
			skill = new Skill(parseInt(split[1]), Main.activePlayerCharacter);
			skill.talentLine = talentLine;
			
			return skill;
		}
		
		private function handleSkillUnlock(): void
		{
			if( Main.activePlayerCharacter.skillPoints <= 0)
			{
				trace( "no available points left!");
				return;
			}
			var index:int = 0;
			while (index < talentLine.unlocked) 
			{
				if (talentLine.skillIds[index] == selectedSkill.skillId) 
				{
					trace(selectedSkill.skillName,"is already unlocked!");
					return;
				}
				++index;
			}
			if (selectedSkill.unlockRequirementsMet()) 
			{
				unlockSkill();
			}
		}
		
		private function unlockSkill():void
		{
			trace( "unlocking", selectedSkill.skillName);
			
			selectedButton.isToggle = true;
			Main.O2D.unlockAbilitiesButton(selectedButton);
			
			Main.activePlayerCharacter.skillPoints--;
			handleAvailablePoints();
			
			talentLine.unlocked++;
			
			Main.activePlayerCharacter.refreshSkills();
			
			//place new unlocked skill in quick bar slot if available and not PASSIVE
			if(selectedSkill.type != Skill.TYPE_PASSIVE)
			{
				var index:int = StarlingFrontSprite.getInstance().quickBarLogic.availableSlot();
				if(index != -1)//available slot on quick bar found
				{
					//trace("found available slot",index);
					var icon:Image = Skill.getSkillIconForClass( Main.activePlayerCharacter, selectedSkill.skillName);
					icon.name = "slot_" + String(index) + "_" + selectedSkill.skillName;
					var slot: Button = StarlingFrontSprite.getInstance().quickBarLogic.clip.slots[index];
					slot.addChildAt(icon,1);
					for(var i:int=0;i< Main.activePlayerCharacter.skills.length;i++)
						if( Main.activePlayerCharacter.skills[i].skillName == selectedSkill.skillName)
							Main.activePlayerCharacter.skills[i].shortcutSlot = index;
				}
				else trace( "all slots on Quick Bar are in use!");
			}
		}
	}
}