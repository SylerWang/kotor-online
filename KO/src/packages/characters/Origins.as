package packages.characters
{
	public class Origins extends Object
	{
		public static const UNDEFINED:int=0;
		public static const CORE:int=1;
		public static const MERCENARY:int=2;
		public static const PHILOSOPHY:int=3;
		public static const SCIENTIST:int=4;
		public static const SLAVE:int=5;
		
		public function Origins()
		{
			  return;
		}
		
		public static function originsString( value:int): String
		{
			switch( value)
			{
				case CORE:
				{
					return "Core";
				}
				case MERCENARY:
				{
					return "Mercenary";
				}
				case PHILOSOPHY:
				{
					return "Philosophy";
				}
				case SCIENTIST:
				{
					return "Scientist";
				}
				case SLAVE:
				{
					return "Slave";
				}
			}
			return null;
		}
		
		public static function originsValue( string: String):int
		{
			switch( string)
			{
				case "Core":
				case "core":
				{
					return CORE;
				}
				case "Mercenary":
				case "mercenary":
				{
					return MERCENARY;
				}
				case "Philosophy":
				case "philosophy":
				{
					return PHILOSOPHY;
				}
				case "Scientist":
				case "scientist":
				{
					return SCIENTIST;
				}
				case "Slave":
				case "slave":
				{
					return SLAVE;
				}
			}
			return UNDEFINED;
		}
	}
}