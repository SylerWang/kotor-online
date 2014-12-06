package packages.characters
{
	import away3d.animators.SkeletonAnimator;
	import away3d.entities.JointObject;
	import away3d.entities.Mesh;
	
	import com.rocketmandevelopment.grid.Cell;
	
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import packages.skills.Skill;
	import packages.skills.TalentLine;
	
	public class Character extends Object
	{
		public var level:int=1;
		public var talents: Array = new Array;
		public var activeAbilitiesType:int=0;
		public var skillPoints:int=4;
		
		private var _skills: Array = new Array;
		private var _allSkills: Array = new Array;
		private var _tempSkills: Array = new Array;
		private var _passiveSkills: Array = new Array;
		
		private var classId:int;
		private var genderId:int;
		private var raceId:int=0;//by default, no race
		private var originId:int;
		private var weaponId:int=-1;
		private var dialogId:int=-1;
		
		public var actions: Array = new Array;
		
		private var _strength:int;
		private var _dexterity:int;
		private var _constitution:int;
		private var _intelligence:int;
		private var _wisdom:int;
		private var _charisma:int;
		
		private var _selected: Boolean = false;
		
		public var characterName:String = "Character";
		public var avatar:Avatar;
		public var activeAnimation: String;
		public var activeAnimationHead: String;
		public var activeAnimationBody: String;
		public var characterBody: String;
		public var characterHead: String;
		public var characterClass:Mesh;
		public var characterRace: Mesh;
		public var characterMesh: Array = new Array;
		public var animatorClass:SkeletonAnimator;
		public var animatorRace:SkeletonAnimator;
		public var cells:Vector.<Cell> = new Vector.<Cell>();

		public var updateVector:Vector3D = new Vector3D;//per frame Delta coordinates to be used as addition to the current coordinates during the move
		public var destinationVector:Vector3D = new Vector3D;//destination coordinates for a move
		public var routeVector:Vector3D = new Vector3D;//current coordinates during the move
		public var ratioVector:Vector3D = new Vector3D;//used to store the 3-D ratios  of the 3 axis
		public var proxyVector:Vector3D = new Vector3D;//used to position the character in the proximity of its current target position
		
		public var targetCharacter:Character;
		
		//Weapons
		public var weaponMesh:Mesh;
		public var bladeMesh:Mesh;
		
		public var weaponJointObject:JointObject;
		public var bladeJointObject:JointObject;
		
		public var activeWeapon:int = -1;
		public var weaponActive: Boolean = false;
		
		public var bladesArray: Array = new Array;
		
		public function Character( classes:int, isMonster: Boolean)
		{
			classId = classes;
			if(Main.gameState)
			{
				talents = Classes.getTalentsForClass(this);
				//trace(Classes.classString( classes), talents.length);
				initializeSkills();
				
				//not really needed, if the actions array is empty will fall back on IDLE ANIMATION, just in case
				//set the default action to IDLE
				//actions.push(Action.IDLE);
			}
			return;
		}
		
		public function get skills():Array
		{
			if (_skills == null) 
			{
				_skills = getUnlockedTalents();
			}
			return _skills;
		}
		
		public function refreshSkills():void
		{
			_skills = getUnlockedTalents();
			return;
		}
		
		//this function and the next one may be merged…
		public function get unlockedSkills(): Array
		{
			var _unlockedSkills:Array = new Array();
			_unlockedSkills = getUnlockedTalents();
			 return _unlockedSkills;
		}
		
		private function getUnlockedTalents() : Array
		{
			var _skill:Skill = null;
			var _unlockedSkills:Array = new Array();
			for each (_skill in _allSkills)
			{
				//trace(_skill.skillName);
				if (isMonster())
				{
					_unlockedSkills.push(_skill);
				}
				if (_skill.unlocked)
				{
					_unlockedSkills.push(_skill);
				}
			}
			for each (_skill in _tempSkills)
			{
				_unlockedSkills.push(_skill);
			}
			//trace( "active character: " + characterName +  " has  skills " + _unlockedSkills.length + " of " +  _allSkills.length);
			return _unlockedSkills;
		}
		
		public function initializeSkills():void
		{
			var _talentLine:TalentLine = null;
			var _index:int;
			var _skill:Skill = null;
			for each (_talentLine in talents) 
			{
				_index = 0;
				while (_index < _talentLine.length) 
				{
					_skill = new Skill(_talentLine.skillIds[_index], this);
					_skill.talentLine = _talentLine;
					_allSkills.push(_skill);
					if (_skill.type == Skill.TYPE_PASSIVE) 
					{
						_passiveSkills.push(_skill);
					}
					++_index;
				}
			}
			return;
		}
		
		public function getSkillInShortcutSlot(id:int):Skill
		{
			var skill: Skill=null;
			for each (skill in skills) 
			{
				if (skill.shortcutSlot != id) 
				{
					continue;
				}
				return skill;
			}
			return null;
		}
		
		public function findSkillWithId(id:int):Skill
		{
			var skill: Skill=null;
			for each (skill in skills) 
			{
				if (skill.skillId != id) 
				{
					continue;
				}
				return skill;
			}
			return null;
		}
		
		public function setShortcutSlotById(id:int,slot:int):Boolean
		{
			var skill: Skill=findSkillWithId(id);
			if (skill) 
			{
				skill.shortcutSlot = slot;
				return true;
			}
			return false;
		}
		
		public function setTalentUnlocksById(arg1:int, arg2:int):Boolean
		{
			var loc1:*=getTalentLine(arg1);
			if (loc1) 
			{
				loc1.unlocked = arg2;
				return true;
			}
			return false;
		}
		
		public function getTalentLine(id:int):TalentLine
		{
			var talentLine:TalentLine=null;
			for each (talentLine in talents) 
			{
				if (talentLine.treeId != id) 
				{
					continue;
				}
				return talentLine;
			}
			return null;
		}
		
		public function get gender():int
		{
			return genderId;
		}
		
		public function get race():int
		{
			return raceId;
		}
		
		public function get origin():int
		{
			return originId;
		}
		
		public function get classes():int
		{
			return classId;
		}
		
		public function get dialog():int
		{
			return dialogId;
		}
		
		public function get weapon():int
		{
			return weaponId;
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set classes(id:int): void
		{
			classId = id;
			return;
		}
		
		public function set gender(id:int): void
		{
			genderId = id;
			return;
		}
		
		public function set race(id:int): void
		{
			raceId = id;
			return;
		}
		
		public function set origin(id:int): void
		{
			originId = id;
			return;
		}
		
		public function set dialog(id:int): void
		{
			dialogId = id;
			return;
		}
		
		public function set weapon(id:int): void
		{
			weaponId = id;
			return;
		}
		
		public function set selected( value: Boolean): void
		{
			_selected = value;
			return;
		}
		
		public function isMonster():Boolean
		{
			if (classId >= 100) 
			{
				return true;
			}
			return false;
		}
	}
}