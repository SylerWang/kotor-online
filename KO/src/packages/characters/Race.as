package packages.characters
{
	public class Race extends Object
	{
		public static const UNDEFINED:int=0;
		public static const CHISS:int=1;
		public static const HUMAN:int=2;
		public static const KIFFAR:int=3;
		public static const SITH:int=4;
		//TO DO add more races
		
		public function Race()
		{
			 return;
		}
		
		public static function raceString( value:int): String
		{
			switch( value)
			{
				case CHISS:
				{
					return "Chiss";
				}
				case HUMAN:
				{
					return "Human";
				}
				case KIFFAR:
				{
					return "Kiffar";
				}
				case SITH:
				{
					return "Sith";
				}
			}
			return null;
		}
		
		public static function raceValue( string: String):int
		{
			switch( string)
			{
				case "Chiss":
				case "chiss":
				{
					return CHISS;
				}
				case "Human":
				case "human":
				{
					return HUMAN;
				}
				case "Kiffar":
				case "kiffar":
				{
					return KIFFAR;
				}
				case "Sith":
				case "sith":
				{
					return SITH;
				}
			}
			return UNDEFINED;
		}
	}
}