package packages.skills
{
	import packages.characters.Character;
	import packages.characters.Classes;
	
	import starling.display.Image;

	public class Skill extends Object
	{
		public var character: Character;
		
		public var skillId:int = 0;
		public var skillName:String="Skill";
		public var skillDisplayName:String="Display Name";
		public var description:String;
		public var shortcutSlot:int=-1;
		public var talentLine:TalentLine;
		
		public var damage:int=0;
		public var penetration:int=0;
		
		//if positive value refers to stamina/force cost, if negative value refers to health cost
		public var cost:int=0;
		
		//if array length is 1, then range is a sphere with a radius and a cell starting point as center
		//otherwise, range is a cone with length and radius
		public var range:Array=[];
		
		//for toggled skills
		public var upkeep:int=0;
		public var toggledOn: Boolean = false;
		
		public var fatigue:Number=0;//in percent
		public var cooldown:int=0;//in seconds
		
		private var requiresStrength:int=0;
		private var requiresDexterity:int=0;
		private var requiresConstitution:int=0;
		private var requiresIntelligence:int=0;
		private var requiresWisdom:int=0;
		private var requiresCharisma:int=0;
		
		public var type:int=-1;
		public static const TYPE_TARGETED:int=1;
		public static const TYPE_TOGGLED:int=2;
		public static const TYPE_PASSIVE:int=3;
		public static const TYPE_INSTANT:int=4;
		
		public function Skill(id:int,c:Character)
		{
			skillId = id;
			character = c;
			initialize();
			return;
		}
		
		private function initialize() : void
		{
			switch(skillId)
			{
				default:
				{
					break;
				}
				case Skills.CONSUMABLE:
				{
					skillName = "consumable";
					break;
				}
				case Skills.FORCEARMOR:
				{
					skillName = "forcearmor";
					type = TYPE_PASSIVE;
					break;
				}	
				case Skills.FORCESPEED:
				{
					skillName = "forcespeed";
					type = TYPE_INSTANT;
					break;
				}
				case Skills.FORCESTRIKE:
				{
					skillName = "forcestrike";
					type = TYPE_TARGETED;
					break;
				}
				case Skills.CRIPPLINGFIRE:
				{
					skillName = "cripplingfire";
					type = TYPE_TOGGLED;
					break;
				}
				case Skills.POWERCORE:
				{
					skillName = "powercore";
					type = TYPE_PASSIVE;
					break;
				}
				case Skills.STEALTH:
				{
					skillName = "stealth";
					type = TYPE_TOGGLED;
					break;
				}
				case Skills.BENEVOLENCE:
				{
					skillName = "benevolence";
					type = TYPE_PASSIVE;
					break;
				}
				case Skills.COOLHEAD:
				{
					skillName = "coolhead";
					type = TYPE_INSTANT;
					break;
				}
				case Skills.INTROSPECTION:
				{
					skillName = "introspection";
					type = TYPE_TARGETED;
					break;
				}
				case Skills.REFLECTION:
				{
					skillName = "reflection";
					type = TYPE_TOGGLED;
					break;
				}
				case Skills.AGONIZINGSABER:
				{
					skillName = "agonizingsaber";
					type = TYPE_PASSIVE;
					break;
				}
				case Skills.CLOUDMIND:
				{
					skillName = "cloudmind";
					type = TYPE_TOGGLED;
					break;
				}
				case Skills.DISTURBANCE:
				{
					skillName = "disturbance";
					type = TYPE_TARGETED;
					break;
				}
				case Skills.HUSTLE:
				{
					skillName = "hustle";
					type = TYPE_INSTANT;
					break;
				}
				case Skills.ARMORTECH:
				{
					skillName = "armortech";
					type = TYPE_PASSIVE;
					break;
				}
				case Skills.AURAOFLEADERSHIP:
				{
					skillName = "auraofleadership";
					type = TYPE_INSTANT;
					break;
				}
				case Skills.AURAOFCERTAINTY:
				{
					skillName = "auraofcertainty";
					type = TYPE_TOGGLED;
					break;
				}
				case Skills.AURAOFRESISTANCE:
				{
					skillName = "auraofresistance";
					type = TYPE_TARGETED;
					break;
				}
				case Skills.CHARGEDUPFORCE:
				{
					skillName = "chargedupforce";
					type = TYPE_INSTANT;
					break;
				}
				case Skills.ENERGYREBOUNDER:
				{
					skillName = "energyrebounder";
					type = TYPE_INSTANT;
					break;
				}
				case Skills.GUARDSTANCE:
				{
					skillName = "guardstance";
					type = TYPE_PASSIVE;
					break;
				}
				case Skills.JCFORCEPRODIGY:
				{
					skillName = "jcforceprodigy";
					type = TYPE_TOGGLED;
					break;
				}
				case Skills.JCJEDISCHOLAR:
				{
					skillName = "jcjedischolar";
					type = TYPE_TARGETED;
					break;
				}
				case Skills.JEDIGENERAL:
				{
					skillName = "jedigeneral";
					type = TYPE_INSTANT;
					break;
				}
				case Skills.JKFORCESENSITIVEORPHAN:
				{
					skillName = "jkforcesensitiveorphan";
					type = TYPE_INSTANT;
					break;
				}
				case Skills.MENTALACUITY:
				{
					skillName = "mentalacuity";
					type = TYPE_INSTANT;
					break;
				}
				case Skills.RAILSHOT:
				{
					skillName = "railshot";
					type = TYPE_PASSIVE;
					break;
				}
				case Skills.SALVATION:
				{
					skillName = "salvation";
					type = TYPE_TOGGLED;
					break;
				}
				case Skills.TELEKINETICBLAST:
				{
					skillName = "telekineticblast";
					type = TYPE_TARGETED;
					break;
				}
				case Skills.UNLEASHEDPALM:
				{
					skillName = "unleashedpalm";
					type = TYPE_INSTANT;
					break;
				}
				case Skills.FIRSTAID:
				{
					skillName = "firstaid";
					type = TYPE_INSTANT;
					break;
				}
				case Skills.MEDICALCRATE:
				{
					skillName = "medicalcrate";
					type = TYPE_PASSIVE;
					break;
				}
				case Skills.MEDSHIELD:
				{
					skillName = "medshield";
					type = TYPE_TOGGLED;
					break;
				}
				case Skills.MIRILANTRADER:
				{
					skillName = "mirilantrader";
					type = TYPE_TARGETED;
					break;
				}
				case Skills.MIRILANYOUTHLEADER:
				{
					skillName = "mirilanyouthleader";
					type = TYPE_INSTANT;
					break;
				}
				case Skills.OUTERRIMVETERAN:
				{
					skillName = "outerrimveteran";
					type = TYPE_INSTANT;
					break;
				}
				case Skills.ENERGYSHIELD:
				{
					skillName = "energyshield";
					type = TYPE_PASSIVE;
					break;
				}
				case Skills.HEAVYARMORS:
				{
					skillName = "heavyarmors";
					type = TYPE_TARGETED;
					break;
				}
				case Skills.AIMBOOST:
				{
					skillName = "aimboost";
					type = TYPE_PASSIVE;
					break;
				}
				case Skills.BRAVADO:
				{
					skillName = "bravado";
					type = TYPE_TOGGLED;
					break;
				}
				case Skills.PERFORATINGSHOT:
				{
					skillName = "perforatingshot";
					type = TYPE_INSTANT;
					break;
				}
				case Skills.TERMINATE:
				{
					skillName = "terminate";
					type = TYPE_INSTANT;
					break;
				}
			}
		}
		
		public function get unlocked():Boolean
		{
			//TO DO ability chain unlockSkill
			/*if (consumable != null) 
			{
				return true;
			}*/
			//trace(talentLine,(talentLine.unlocked > talentIndex),talentLine.unlocked, talentIndex);
			/*if (talentLine.type == TalentLine.TYPE_BASE || talentLine.type == TalentLine.TYPE_CLASS)
			{
				return true;
			}*/
			if (talentLine && talentLine.unlocked > talentIndex) 
			{
				return true;
			}
			return false;
		}
		
		public function get talentIndex():int
		{
			var _index:int = 0;
			while (_index < talentLine.length) 
			{
				if (talentLine.skillIds[_index] == skillId) 
				{
					return _index;
				}
				++_index;
			}
			return -1;
		}
		
		public static function getSkillIconForClass(char: Character, skillName: String):Image
		{
			var atlas: String = Classes.classString(char.classes).toUpperCase();
			var skillIcon: Image = new Image(Assets.getAtlas(atlas).getTexture(skillName));
			return skillIcon;
		}
		
		public static function skillString( value:int): String
		{
			switch( value)
			{
				case TYPE_INSTANT:
				{
					return "instant";
				}
				case TYPE_PASSIVE:
				{
					return "passive";
				}
				case TYPE_TOGGLED:
				{
					return "toggled";
				}
				case TYPE_TARGETED:
				{
					return "targeted";
				}
			}
			return null;
		}
		
		public function unlockRequirementsMet():Boolean
		{
			var index:*=0;
			//trace( talentIndex, talentLine.length);
			index = Math.max(1, talentIndex * talentLine.length);
			if (talentLine.unlocked < talentIndex)
			{
				trace("unlock requirements are NOT met!");
				return false;
			}
			//to be used at character level up
			/*if (character.level < index) 
			{
				return false;
			}*/
			return true;
		}
	}
}