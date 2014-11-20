package packages.characters
{
	import packages.skills.TalentLine;

	public class Classes extends Object
	{
		public static const UNDEFINED:int=0;
		//base classes
		public static const JEDI:int=1;
		public static const SOLDIER:int=2;
		//regular classes
		public static const GUARDIAN:int=3;
		public static const CONSULAR:int=4;
		public static const OFFICER:int=5;
		public static const SCOUNDREL:int=6;
		//advanced classes
		//TO DO
		//monster classes -value above 100
		//TO DO
		
		public function Classes()
		{
			 return;
		}
		
		public static function getTalentsForClass( character:Character) : Array
		{
			var talents: Array = new Array;
			var index:int = 0;
			//TO DO is monster
			switch(character.classes)
			{
				case CONSULAR:
				{
					talents.push(new TalentLine(TalentLine.JEDI, index));
					talents.push(new TalentLine(TalentLine.CONSULAR, index));
					talents.push(new TalentLine(TalentLine.SHADOW, index));
					talents.push(new TalentLine(TalentLine.SAGE, index));
					break;
				}
				case GUARDIAN:
				{
					talents.push(new TalentLine(TalentLine.JEDI, index));
					talents.push(new TalentLine(TalentLine.GUARDIAN, index));
					talents.push(new TalentLine(TalentLine.PROTECTOR, index));
					talents.push(new TalentLine(TalentLine.SENTINEL, index));
					break;
				}
				case OFFICER:
				{
					talents.push(new TalentLine(TalentLine.SOLDIER, index));
					talents.push(new TalentLine(TalentLine.OFFICER, index));
					talents.push(new TalentLine(TalentLine.VANGUARD, index));
					talents.push(new TalentLine(TalentLine.COMMANDO, index));
					break;
				}
				case SCOUNDREL:
				{
					talents.push(new TalentLine(TalentLine.SOLDIER, index));
					talents.push(new TalentLine(TalentLine.SCOUNDREL, index));
					talents.push(new TalentLine(TalentLine.SMUGGLER, index));
					talents.push(new TalentLine(TalentLine.GUNSLINGER, index));
					break;
				}
			}
			return talents;
		}
		
		public static function getBaseClassOf( value:int):int
		{
			switch( value)
			{
				case GUARDIAN:
				case CONSULAR:
				{
					return JEDI;
				}
				case OFFICER:
				case SCOUNDREL:
				{
					return SOLDIER;
				}
				default:
				{
					break;
				}
			}
			return UNDEFINED;
		}
		
		public static function classString( value:int): String
		{
			switch( value)
			{
				case JEDI:
				{
					return "Jedi";
				}
				case SOLDIER:
				{
					return "Soldier";
				}
				case GUARDIAN:
				{
					return "Guardian";
				}
				case CONSULAR:
				{
					return "Consular";
				}
				case OFFICER:
				{
					return "Officer";
				}
				case SCOUNDREL:
				{
					return "Scoundrel";
				}
			}
			return null;
		}
		
		public static function classValue( string: String):int
		{
			switch( string)
			{
				case "Jedi":
				case "jedi":
				{
					return JEDI;
				}
				case "Soldier":
				case "soldier":
				{
					return SOLDIER;
				}
				case "Guardian":
				case "guardian":
				{
					return GUARDIAN;
				}
				case "Consular":
				case "consular":
				{
					return CONSULAR;
				}
				case "Officer":
				case "officer":
				{
					return OFFICER;
				}
				case "Scoundrel":
				case "scoundrel":
				{
					return SCOUNDREL;
				}
			}
			return UNDEFINED;
		}
	}
}