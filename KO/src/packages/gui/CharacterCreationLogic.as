package packages.gui
{
	import feathers.controls.Button;
	
	import flash.geom.Matrix;
	
	import packages.characters.Avatar;
	import packages.characters.Character;
	import packages.characters.Classes;
	import packages.characters.Origins;
	import packages.characters.Gender;
	import packages.characters.Race;
	import packages.sprites.CharacterCreationSprite;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.*;
	import starling.text.TextField;
	import starling.textures.GradientTexture;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
    public class CharacterCreationLogic extends Object
    {
		public var clip:CharacterCreationSprite;
		private var previous: String = "";
		
		public function CharacterCreationLogic(arg1:CharacterCreationSprite)
        {
			clip = arg1;
			//clip.useHandCursor = false;
			clip.addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
			return;
		}
		
		public function addedToStageHandler( event: Event): void
		{
			clip.removeEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
			//rearrange	//color 0xddcba2
			var sprite:Sprite;// = new Sprite;
			var type:TextField;
			var content:TextField;
			var info:TextField;
			var s: String = "";
			var mX:Number=1.1;
			var mY:Number=1.7;
			var row:int = 0;
			var columns:int = 0;
			var frame:Image;
			var w:int=clip.buttons[columns].defaultSkin.width*mX*clip.length;
			var image:Image;
			var header:Function;
			
			header = function (button: Button):void
			{
				sprite = new Sprite;
				sprite.name = s;
				type = new TextField(120, 25, s, "Helvetica", 14, 0xddcba2);
				content = new TextField(120, 25, button.label, "StarJedi", 14, 0xddcba2);
				content.name = "content";
				content.x = 60*(clip.length-2);
				//add gradient
				image = new Image(Main.O2D.gradient(w,25));
				sprite.addChild(image);
				sprite.addChild(type);
				sprite.addChild(content);
				//sprite.x = Main.APP_WIDTH - (button.defaultSkin.width * (clip.length - columns) * mX);
				sprite.y = (button.defaultSkin.height * row + 50) * mY - 30;
				clip.addChild(sprite);
			}
			
			for( var i:int=0;i< clip.buttons.length;i++)
			{
				//add frame
				frame = new Image(Assets.getAtlas("CHARACTERCREATIONOBJECTS").getTexture("icon_frame"));
				frame.name = "frame";
				frame.visible = false;
				clip.buttons[i].addChild(frame);
				
				if(s == "")		//handle the first instance as a starting point
				{
					s = (clip.buttons[i].getChildByName( "type") as TextField).text;
					header(clip.buttons[i] as Button);
					switchButtons(clip.buttons[i] as Button);
				}
				else if (s != (clip.buttons[i].getChildByName( "type") as TextField).text)
				{
					s = (clip.buttons[i].getChildByName( "type") as TextField).text;
					row++;
					columns = 0;
					header(clip.buttons[i] as Button);
					switchButtons(clip.buttons[i] as Button);
				}
				
				//handle buttons position
				clip.buttons[i].addEventListener(Event.TRIGGERED, triggeredHandler);
				clip.buttons[i].addEventListener(TouchEvent.TOUCH, onButtonTouch);
				clip.buttons[i].useHandCursor = true;
				clip.buttons[i].horizontalAlign = Button.HORIZONTAL_ALIGN_CENTER;
				clip.buttons[i].verticalAlign = Button.VERTICAL_ALIGN_MIDDLE;
				
				var string: String = (clip.buttons[i].getChildByName( "type") as TextField).text + "_" + clip.buttons[i].label;
				if((clip.buttons[i].getChildByName( "type") as TextField).text != "Race")
				{
					string = string.toLowerCase();
					clip.buttons[i].defaultIcon = new Image(Assets.getAtlas("CHARACTERCREATIONOBJECTS").getTexture(string));
				}
				else //handle race images for both genders
				{
					var stringMale: String = string + "_male";
					stringMale = stringMale.toLowerCase();
					clip.buttons[i].defaultIcon = new Image(Assets.getAtlas("CHARACTERCREATIONOBJECTS").getTexture(stringMale));
					var stringFemale: String = string + "_female";
					stringFemale = stringFemale.toLowerCase();
					var femaleIcon: Image = new Image(Assets.getAtlas("CHARACTERCREATIONOBJECTS").getTexture(stringFemale));
					femaleIcon.name = "female";
					femaleIcon.x=5;
					femaleIcon.y=5;
					femaleIcon.visible = false;
					clip.buttons[i].addChild(femaleIcon);
				}
				//clip.buttons[i].x = Main.APP_WIDTH - (clip.buttons[i].defaultSkin.width * (clip.length - columns) * mX);
				clip.buttons[i].x = clip.buttons[i].defaultSkin.width * columns * mX;
				clip.buttons[i].y = (clip.buttons[i].defaultSkin.height * row + 50) * mY;
				if(i>0)	 var maxY:int = Math.max(clip.buttons[i-1].y+clip.buttons[i-1].defaultSkin.height,clip.buttons[i].y+clip.buttons[i].defaultSkin.height);
				columns++;
			}
			//add info
			info = new TextField(w, w/2, "", "Helvetica", 11, 0xddcba2);
			info.name = "info";
			info.hAlign = HAlign.LEFT;
			info.vAlign = VAlign.TOP;
			info.y = maxY;
			clip.addChild(info);
		}
		
		private function triggeredHandler( event:Event): void
		{
			var button:Button= Button(event.currentTarget);
			var type: String = (button.getChildByName( "type") as TextField).text;
			if(button.isToggle)	 trace( type," already selected");
			else
			{
				switchButtons(button);
			}
			//if(button.label == "Next")	startGame();
		}
		
		private function onButtonTouch(event:TouchEvent):void
		{
			var button:Button= Button(event.currentTarget);
			if(event.interactsWith(button) == false)	 
			{
				previous = "";
				setInfo("NO");
			}
			else if( previous != button.label)
			{
				setInfo(button.label);
				previous = button.label;
			}
		}
		
		private function switchButtons(button: Button): void
		{
			if( button.label== "Male"||button.label== "Female")
			{
				//trace( button.label, "gender, skipping restrictions");
			}
			else
			{
				//trace( button.label, "applying restrictions");
				restrictions( button);
			}
			var type:String=(button.getChildByName( "type") as TextField).text;
			var frame:*;
			for( var i:int=0;i<clip.buttons.length;i++)
			{
				if((clip.buttons[i].getChildByName( "type") as TextField).text == type)
				{
					clip.buttons[i].isToggle = false;
					frame = clip.buttons[i].getChildByName( "frame");
					if( frame)	frame.visible = false;
				}
				if(type=="Gender")
				{
					if((clip.buttons[i].getChildByName( "type") as TextField).text == "Race")
					{
						if(clip.buttons[i].defaultIcon)		clip.buttons[i].defaultIcon.visible=!clip.buttons[i].defaultIcon.visible;
						var alternateIcon:* = clip.buttons[i].getChildByName("female");
						if(alternateIcon)	alternateIcon.visible = !alternateIcon.visible;
					}
				}
			}
			button.isToggle = true;
			frame = button.getChildByName( "frame");
			if( frame)		frame.visible = true;
			var sprite:* = clip.getChildByName(type);
			var content:* = sprite.getChildByName( "content");
			if(content)		(content as TextField).text = button.label.toLowerCase();
			//update character and avatar
			var character: Character = new Character(0, false);
			var counter:int;
			for(i=0;i<clip.buttons.length;i++)
			{
				if(clip.buttons[i].isToggle)
				{
					counter++;
					type = (clip.buttons[i].getChildByName( "type") as TextField).text;
					button = clip.buttons[i];
					if( type== "Gender")	 character.gender = Gender.genderValue(button.label);
					if( type== "Race")	 character.race = Race.raceValue(button.label);
					if( type== "Class")	 character.classes = Classes.classValue(button.label);
					if( type== "Origin")	 character.origin = Origins.originsValue(button.label);
				}
			}
			//trace( "counter of toggled buttons is", counter);
			if(counter==4 && Main.characterCreationState)		
			{
				//Main.playerCharacter = character;
				//trace( "setting the player Main.playerCharacter to",Gender.genderString(Main.playerCharacter.genderId), Race.raceString(Main.playerCharacter.raceId), Classes.classString(Main.playerCharacter.classes));
				Main.playerParty.members.splice(0,1);
				Main.playerParty.members.push(character);
				if( character.avatar == null)	var avatar: Avatar = new Avatar(character, true);
				avatar.setAvatar(character);
				//avatar.setAvatar(character);
				counter=0;
			}
		}
		
		private function restrictions( button: Button): void
		{
			var i:int;
			var _button: Button;
			
			switch( button.label)
			{
				case "Twilek_":
				{
					for(i=0;i<clip.buttons.length;i++)
					{
						_button = clip.buttons[i] as Button;
						if(_button.label=="Core"||_button.label=="Philosophy")
						{
							_button.isEnabled=false;
							Main.O2D.disableButton(_button,5);
						}
						else
						{
							_button.isEnabled=true;
							Main.O2D.disableButton(_button,5);
						}
					}
					break;
				}
				default:
				{
					for(i=0;i<clip.buttons.length;i++)
					{
						_button = clip.buttons[i] as Button;
						_button.isEnabled=true;
						Main.O2D.disableButton(_button,5);
					}
					break;
				}
			}
		}
		
		private function setInfo(details:String): void
		{
			var info:* = clip.getChildByName( "info");
			switch(details)
			{
				case "NO":
				{
					if(info)		(info as TextField).text = "";
					break;
				}
				case "Male":
				{
					if(info)		(info as TextField).text = "That's a dude :-)";
					break;
				}
				case "Female":
				{
					if(info)		(info as TextField).text = "That's a dudette :-)";
					break;
				}
				default:
				{
					if(info)		(info as TextField).text = details + " is this and that, I'm not the writer, so we can all get an opportunity to use our imagination. :-)";
					break;
				}
			}
		}
	}
}