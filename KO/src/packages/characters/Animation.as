package packages.characters
{
	public class Animation extends Object
	{
		public static const UNDEFINED:int=0;
		public static const IDLE:int=1;
		public static const RUN:int=2;

		public function Animation()
		{
			return;
		}
		
		public static function animationString( value:int): String
		{
			switch( value)
			{
				case IDLE:
				default:
				{
					return "pause2";
				}
				case RUN:
				{
					return "runSS";
				}
			}
			return null;
		}
		
		public static function animationValue( string: String):int
		{
			switch( string)
			{
				case "pause2":
				{
					return IDLE;
				}
				case "runSS":
				{
					return RUN;
				}
			}
			return UNDEFINED;
		}
	}
}