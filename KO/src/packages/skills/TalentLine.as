package packages.skills
{
	public class TalentLine extends Object
	{
		public var treeId:int=0;
		public var unlocked:int=0;
		public var skillIds:Array;
		public var type:int;
		public var description:String;
		
		public static const UNDEFINED:uint=0;
		public static const TYPE_BASE:uint=1;
		public static const TYPE_CLASS:uint=2;
		public static const TYPE_ADVANCEDCLASS:uint=3;
		public static const TYPE_SPECIALIZATION:uint=4;
		public static const TYPE_RACIAL:uint=5;
		public static const TYPE_ORIGIN:uint=6;
		public static const TYPE_WEAPON:uint=7;
		public static const TYPE_FORCE:uint=8;
		public static const TYPE_OTHER:uint=99;
		
		public static const JEDI:uint=101;
		public static const CONSULAR:uint=111;
		public static const GUARDIAN:uint=112;
		public static const SAGE:uint=121;
		public static const SHADOW:uint=122;
		public static const SENTINEL:uint=123;
		public static const PROTECTOR:uint=124;
		
		public static const SOLDIER:uint=201;
		public static const OFFICER:uint=211;
		public static const SCOUNDREL:uint=212;
		public static const COMMANDO:uint=221;
		public static const VANGUARD:uint=222;
		public static const GUNSLINGER:uint=223;
		public static const SMUGGLER:uint=224;
		
		public static const DUAL:uint=301;
		public static const TWO_HANDED:uint=302;
		public static const RANGE:uint=303;
		public static const ARMOR:uint=304;
		public static const IMPLANTS:uint=305;
		
		public static const CONTROL:uint=401;
		public static const SENSE:uint=402;
		public static const ALTER:uint=403;
		
		public function TalentLine(id:int, index:int)
		{
			skillIds = new Array();
			treeId = id;
			switch(treeId)
			{
				case JEDI:
				{
					skillIds = [ Skills.FORCEARMOR, Skills.AURAOFCERTAINTY, Skills.AURAOFRESISTANCE, Skills.CHARGEDUPFORCE, Skills.COOLHEAD, Skills.DISTURBANCE, Skills.ENERGYREBOUNDER, Skills.FORCESPEED];
					type = TYPE_BASE;
					description = "Experts in this style can do fancy stuff or something, I'm not a writer.";
					break;
				}
				case SOLDIER:
				{
					skillIds = [ Skills.CRIPPLINGFIRE, Skills.FIRSTAID, Skills.MEDICALCRATE, Skills.MEDSHIELD, Skills.MIRILANTRADER, Skills.MIRILANYOUTHLEADER, Skills.OUTERRIMVETERAN, Skills.TERMINATE];
					type = TYPE_BASE;
					description = "Experts in this style can do fancy stuff or something, I'm not a writer.";
					break;
				}
				case CONSULAR:
				{
					skillIds = [ Skills.AURAOFCERTAINTY, Skills.AURAOFRESISTANCE, Skills.CHARGEDUPFORCE, Skills.COOLHEAD, Skills.DISTURBANCE, Skills.ENERGYREBOUNDER, Skills.FORCESPEED, Skills.FORCEARMOR];
					type = TYPE_CLASS;
					description = "Experts in this style can do fancy stuff or something, I'm not a writer.";
					break;
				}
				case GUARDIAN:
				{
					skillIds = [ Skills.AURAOFRESISTANCE, Skills.CHARGEDUPFORCE, Skills.COOLHEAD, Skills.DISTURBANCE, Skills.ENERGYREBOUNDER, Skills.FORCESPEED, Skills.FORCEARMOR, Skills.AURAOFCERTAINTY];
					type = TYPE_CLASS;
					description = "Experts in this style can do fancy stuff or something, I'm not a writer.";
					break;
				}
				case OFFICER:
				{
					skillIds = [ Skills.FIRSTAID, Skills.MEDICALCRATE, Skills.MEDSHIELD, Skills.MIRILANTRADER, Skills.MIRILANYOUTHLEADER, Skills.OUTERRIMVETERAN, Skills.TERMINATE, Skills.CRIPPLINGFIRE];
					type = TYPE_CLASS;
					description = "Experts in this style can do fancy stuff or something, I'm not a writer.";
					break;
				}
				case SCOUNDREL:
				{
					skillIds = [ Skills.MEDICALCRATE, Skills.MEDSHIELD, Skills.MIRILANTRADER, Skills.MIRILANYOUTHLEADER, Skills.OUTERRIMVETERAN, Skills.TERMINATE, Skills.CRIPPLINGFIRE, Skills.FIRSTAID];
					type = TYPE_CLASS;
					description = "Experts in this style can do fancy stuff or something, I'm not a writer.";
					break;
				}
				case SAGE:
				{
					skillIds = [ Skills.CHARGEDUPFORCE, Skills.COOLHEAD, Skills.DISTURBANCE, Skills.ENERGYREBOUNDER, Skills.FORCESPEED, Skills.FORCEARMOR, Skills.AURAOFCERTAINTY, Skills.AURAOFRESISTANCE];
					type = TYPE_SPECIALIZATION;
					description = "Experts in this style can do fancy stuff or something, I'm not a writer.";
					break;
				}
				case SENTINEL:
				{
					skillIds = [ Skills.COOLHEAD, Skills.DISTURBANCE, Skills.ENERGYREBOUNDER, Skills.FORCESPEED, Skills.FORCEARMOR, Skills.AURAOFCERTAINTY, Skills.AURAOFRESISTANCE, Skills.CHARGEDUPFORCE];
					type = TYPE_SPECIALIZATION;
					description = "Experts in this style can do fancy stuff or something, I'm not a writer.";
					break;
				}
				case COMMANDO:
				{
					skillIds = [ Skills.MEDSHIELD, Skills.MIRILANTRADER, Skills.MIRILANYOUTHLEADER, Skills.OUTERRIMVETERAN, Skills.TERMINATE, Skills.CRIPPLINGFIRE, Skills.FIRSTAID, Skills.MEDICALCRATE];
					type = TYPE_SPECIALIZATION;
					description = "Experts in this style can do fancy stuff or something, I'm not a writer.";
					break;
				}
				case GUNSLINGER:
				{
					skillIds = [ Skills.MIRILANTRADER, Skills.MIRILANYOUTHLEADER, Skills.OUTERRIMVETERAN, Skills.TERMINATE, Skills.CRIPPLINGFIRE, Skills.FIRSTAID, Skills.MEDICALCRATE, Skills.MEDSHIELD];
					type = TYPE_SPECIALIZATION;
					description = "Experts in this style can do fancy stuff or something, I'm not a writer.";
					break;
				}
				case SHADOW:
				{
					skillIds = [ Skills.DISTURBANCE, Skills.ENERGYREBOUNDER, Skills.FORCESPEED, Skills.FORCEARMOR, Skills.AURAOFCERTAINTY, Skills.AURAOFRESISTANCE, Skills.CHARGEDUPFORCE, Skills.COOLHEAD];
					type = TYPE_ADVANCEDCLASS;
					description = "Experts in this style can do fancy stuff or something, I'm not a writer.";
					break;
				}
				case PROTECTOR:
				{
					skillIds = [ Skills.ENERGYREBOUNDER, Skills.FORCESPEED, Skills.FORCEARMOR, Skills.AURAOFCERTAINTY, Skills.AURAOFRESISTANCE, Skills.CHARGEDUPFORCE, Skills.COOLHEAD, Skills.DISTURBANCE];
					type = TYPE_ADVANCEDCLASS;
					description = "Experts in this style can do fancy stuff or something, I'm not a writer.";
					break;
				}
				case VANGUARD:
				{
					skillIds = [ Skills.MIRILANYOUTHLEADER, Skills.OUTERRIMVETERAN, Skills.TERMINATE, Skills.CRIPPLINGFIRE, Skills.FIRSTAID, Skills.MEDICALCRATE, Skills.MEDSHIELD, Skills.MIRILANTRADER];
					type = TYPE_ADVANCEDCLASS;
					description = "Experts in this style can do fancy stuff or something, I'm not a writer.";
					break;
				}
				case SMUGGLER:
				{
					skillIds = [ Skills.OUTERRIMVETERAN, Skills.TERMINATE, Skills.CRIPPLINGFIRE, Skills.FIRSTAID, Skills.MEDICALCRATE, Skills.MEDSHIELD, Skills.MIRILANTRADER, Skills.MIRILANYOUTHLEADER];
					type = TYPE_ADVANCEDCLASS;
					description = "Experts in this style can do fancy stuff or something, I'm not a writer.";
					break;
				}
			}
		}
		
		public function get length():int
		{
			return skillIds.length;
		}
		
		public static function talentString( value:int): String
		{
			switch( value)
			{
				case TYPE_BASE:
				{
					return "base";
				}
				case TYPE_CLASS:
				{
					return "class";
				}
				case TYPE_ADVANCEDCLASS:
				{
					return "advanced";
				}
				case TYPE_SPECIALIZATION:
				{
					return "specialization";
				}
				case TYPE_WEAPON:
				{
					return "weapon";
				}
				case TYPE_FORCE:
				{
					return "force";
				}
				case JEDI:
				{
					return "jedi";
				}
				case CONSULAR:
				{
					return "consular";
				}
				case GUARDIAN:
				{
					return "guardian";
				}
				case SAGE:
				{
					return "sage";
				}
				case SHADOW:
				{
					return "shadow";
				}
				case SENTINEL:
				{
					return "sentinel";
				}
				case PROTECTOR:
				{
					return "protector";
				}
				case SOLDIER:
				{
					return "soldier";
				}
				case OFFICER:
				{
					return "officer";
				}
				case SCOUNDREL:
				{
					return "scoundrel";
				}
				case COMMANDO:
				{
					return "commando";
				}
				case VANGUARD:
				{
					return "vanguard";
				}
				case GUNSLINGER:
				{
					return "gunslinger";
				}
				case SMUGGLER:
				{
					return "smuggler";
				}
				case DUAL:
				{
					return "dual";
				}
				case TWO_HANDED:
				{
					return "two_handed";
				}
				case RANGE:
				{
					return "range";
				}
				case ARMOR:
				{
					return "armor";
				}
				case IMPLANTS:
				{
					return "implants";
				}
				case CONTROL:
				{
					return "control";
				}
				case SENSE:
				{
					return "sense";
				}
				case ALTER:
				{
					return "alter";
				}
			}
			return null;
		}
	}
}