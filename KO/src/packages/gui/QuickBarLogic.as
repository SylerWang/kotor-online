package packages.gui
{
	import feathers.controls.Button;
	
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import packages.characters.Avatar;
	import packages.characters.Character;
	import packages.characters.Classes;
	import packages.characters.Gender;
	import packages.characters.Race;
	import packages.skills.Skill;
	import packages.sprites.QuickBarSprite;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.*;
	import starling.rootsprites.StarlingFrontSprite;
	import starling.text.TextField;
	import starling.textures.GradientTexture;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
    public class QuickBarLogic extends Object
    {
		public var clip:QuickBarSprite;
		private var _locked:Boolean = false;
		private var overLock: Boolean = false;
		private var overQuickBar: Boolean = false;
		public var character: Character;
		public static const MAX_SKILLS:int=12;
		private var mouseWord:*;
		public var currentButton: Button = null;
		public var previousButton: Button = null;
		public var startButton: Button = null;
		public var swapped: Boolean = false;
		public var alreadyIcon: Image = null;
		
		public function QuickBarLogic(arg1:QuickBarSprite)
        {
			clip = arg1;
			clip.addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
			return;
		}
		
		public function addedToStageHandler( event: Event): void
		{
			clip.removeEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
			//clip.addEventListener(TouchEvent.TOUCH, onTouch);
			//TO DO cool off state  for slots and highlight for toggled
			//rearrange	
			clip.x = Main.APP_WIDTH/2 - clip.width/2;
			clip.y = Main.APP_HEIGHT - clip.height;
			
			clip.lockButton.x = 7;
			clip.lockButton.y = 40;
			clip.lockButton.useHandCursor = true;
			
			//adding the clip.slots
			for( var i:int=0;i<MAX_SKILLS;i++)
			{
				var index:int=i+1;
				clip.slots[index].addEventListener(Event.TRIGGERED, triggeredHandler);
				clip.slots[index].horizontalAlign = Button.HORIZONTAL_ALIGN_CENTER;
				clip.slots[index].verticalAlign = Button.VERTICAL_ALIGN_MIDDLE;
				
				if (index==1)
				{
					clip.slots[index].x = 28;	 
					clip.slots[index].y = 7;
				}
				else
				{
					clip.slots[index].x = clip.slots[1].x + (clip.slots[1].defaultSkin.width + 3) * (index - 1);
					clip.slots[index].y = 7;
				}
			}
		}
		
		public function get locked():Boolean
		{
			return _locked;
		}
		
		public function set locked(value:Boolean): void
		{
			_locked = value;
			return;
		}
		
		public function handleLock(): void
		{
			locked = !locked;
			trace( "locked",locked);
			clip.lockButton.getChildByName("locked").visible = !clip.lockButton.getChildByName("locked").visible;
			clip.lockButton.getChildByName("unlocked").visible = !clip.lockButton.getChildByName("unlocked").visible;
		}
		
		//example of mouse word for future reference
		/*private function onTouchBad(event:TouchEvent):void
		{
			var touch:Touch;
			var touchBegan:Touch;
			var touchMoved:Touch;
			var touchEnded:Touch;
			var touchHover:Touch;
			var touchStationary:Touch;
			
			touch = event.getTouch(event.target as DisplayObject);
			if( touch)	trace( event.currentTarget, event.target, touch.globalX, touch.globalY, touch.phase);
			
			//handle  the lock button
			
			/*if(event.interactsWith(clip.lockButton) == false)
			{
				if(mouseWord)	StarlingFrontSprite.getInstance().removeChild(mouseWord);
				overLock = false;	
			}
			else if(overLock != true && event.interactsWith(clip.lockButton) == true) 
			{
				overLock = true;
				var string: String;
				if(_locked == true)	 string = "Allow dragging icons on Quick Bar";
				else	 string = "Lock icons on Quick Bar";
				Main.O2D.showMouseWord( string);
				mouseWord=StarlingFrontSprite.getInstance().getChildByName("mouseWord");
				mouseWord.x = mousePoint.x;
				mouseWord.y = mousePoint.y;
			}
		}*/
		
		public function getIconInSlot(button: Button): Image
		{
			if(button == null)	 return null;
			else
			{
				for(var j:int=0;j<button.numChildren;j++)
				{
					var child:* = button.getChildAt(j);
					if( child.name && child.name.indexOf("slot_") != -1)
					{
						var _image: Image = child as Image;
						return _image;
					}
				}
			}
			return null;
		}
		
		public function handleIcon(s: String, d: String= ""): void
		{
			var _split: Array = new Array;
			var icon: Image = null;
			if(d != "")
			{
				if(alreadyIcon)		currentButton.removeChild(alreadyIcon);
				var tempX:int = StarlingFrontSprite.getInstance().draggedIcon.x;
				var tempY:int = StarlingFrontSprite.getInstance().draggedIcon.y;
				StarlingFrontSprite.getInstance().removeChild(StarlingFrontSprite.getInstance().draggedIcon);
				//trace( "time to swap");
				_split = d.split("_");	
				StarlingFrontSprite.getInstance().draggedIcon = Skill.getSkillIconForClass( Main.activePlayerCharacter, _split[_split.length-1]);
				StarlingFrontSprite.getInstance().draggedIcon.name = d;
				StarlingFrontSprite.getInstance().draggedIcon.x = tempX;
				StarlingFrontSprite.getInstance().draggedIcon.y = tempY;
				StarlingFrontSprite.getInstance().draggedIcon.touchable = false;
				StarlingFrontSprite.getInstance().addChild(StarlingFrontSprite.getInstance().draggedIcon);
			}
			_split = s.split("_");
			var _label: String = currentButton.label;
			if(_label== "0")	_label= "10";
			if(_label== "-")	_label= "11";
			if(_label== "=")	_label= "12";
			icon = Skill.getSkillIconForClass( Main.activePlayerCharacter, _split[_split.length-1]);
			icon.name = "slot_" + _label + "_" + _split[_split.length-1];
			for(var k:int=0;k<currentButton.numChildren;k++)
			{
				var child:* = currentButton.getChildAt(k);
				if( child.name && child.name.indexOf("slot_") != -1)
					currentButton.removeChild( child);
			}
			currentButton.addChildAt(icon,1);
			var _i:int = parseInt(_label);
			for(var i:int=0;i< Main.activePlayerCharacter.skills.length;i++)
				if( Main.activePlayerCharacter.skills[i].skillName == _split[_split.length-1])
					Main.activePlayerCharacter.skills[i].shortcutSlot = _i;				
			trace(StarlingFrontSprite.getInstance().draggedIcon.name, " is now", icon.name);
		}
		
		public function removeIcon(s: String): void
		{
			var _split: Array = new Array;
			_split = s.split("_");
			for(var i:int=0;i< Main.activePlayerCharacter.skills.length;i++)
				if( Main.activePlayerCharacter.skills[i].skillName == _split[_split.length-1])
					Main.activePlayerCharacter.skills[i].shortcutSlot = -1;
			var iconOnQuickBar:int = 0;
			for(var j:int=0;j<Main.activePlayerCharacter.skills.length;j++)
				if(Main.activePlayerCharacter.skills[j].shortcutSlot != -1)
					iconOnQuickBar++;
			trace(StarlingFrontSprite.getInstance().draggedIcon.name, " is now removed and",iconOnQuickBar, "icons are  left on quick bar");
		}
		
		private function triggeredHandler( event:Event): void
		{
			if(StarlingFrontSprite.getInstance().draggedIcon == null)
			{
				var button:Button= Button(event.currentTarget);
				trace( "button clicked", button.label);
				//TO DO button toggle
				/*if(currentButton.isToggle)	 trace("already selected");
				else
				{
					 currentButton.isToggle = true;
				}*/
			}
		}
		
		public function setChar( char: Character): void
		{
			character = char;
			if( char == null || char.isMonster())
			{
				disable();
				return;
			}
			char.refreshSkills();
			enable();
			var index:int = 0;
			var skill:Skill;
			while( index < char.skills.length)
			{
				skill = char.skills[index] as Skill;
				if( skill != null)
				{
					//trace( "skill is not empty", skill.shortcutSlot);
					if( skill.shortcutSlot != -1)
					{
						//trace(char.characterName, "has skill", skill.skillName, "in slot", skill.shortcutSlot, "of class", Classes.classString(char.classes).toUpperCase());
						//var atlas: String = Classes.classString(char.classes).toUpperCase();
						var skillIcon: Image = Skill.getSkillIconForClass( char, skill.skillName); //new Image(Assets.getAtlas(atlas).getTexture(skill.skillName));
						skillIcon.name = "slot_" + skill.shortcutSlot + "_" + skill.skillName;
						trace( skillIcon.name);
						clip.slots[skill.shortcutSlot].addChild(skillIcon);
					}
				}
				index++;
			}
		}
		
		public function availableSlot():int
		{
			for( var i:int=0;i<MAX_SKILLS;i++)
			{
				var index:int=i+1;
				var image: Image = getIconInSlot(clip.slots[index]);
				if(image == null)	return index;
			}
			return -1;
		}
		
		public function update():void
		{
			if (character != null) 
			{
				setChar(character);
			}
			return;
		}
		
		public function disable(): void
		{
			//TO DO desaturation and remove mouse listeners
		}
		
		public function enable(): void
		{
			//TO DO saturation and add mouse listeners
		}
	}
}