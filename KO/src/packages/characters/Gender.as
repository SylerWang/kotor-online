package packages.characters
{
	public class Gender extends Object
	{
		public static const MISC:int=1;
		public static const MALE:int=2;
		public static const FEMALE:int=3;
		
		public function Gender()
		{
			 return;
		}
		
		public static function genderString( value:int): String
		{
			switch( value)
			{
				case MISC:
				default:
				{
					return "misc";
				}
				case MALE:
				{
					return "m";
				}
				case FEMALE:
				{
					return "f";
				}
			}
			return null;
		}
		
		public static function genderValue(string: String): int
		{
			switch(string)
			{
				case MISC:
				default:
				{
					return MISC;
				}
				case "Male":
				case "m":
				{
					return MALE;
				}
				case "Female":
				case "f":
				{
					return FEMALE;
				}
			}
			return MISC;
		}
	}
}