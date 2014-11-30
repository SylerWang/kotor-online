package packages.characters
{
	public class Action extends Object
	{
		public static const UNDEFINED:int=0;
		public static const IDLE:int=1;
		public static const MOVE:int=2;
		public static const ATTACK:int=11;
		public static const RANGE:int=12;
		public static const DIALOG:int=101;
		
		public function Action()
		{
			return;
		}
		
		/*// TO DO maybe not needed
		public static function actionString( value:int): String
		{
			switch( value)
			{
				case IDLE:
				case UNDEFINED:
				default:
				{
					return "idle";
				}
				case MOVE:
				{
					return "move";
				}
				case ATTACK:
				{
					return "attack";
				}
				case DIALOG:
				{
					return "dialog";
				}
			}
			return null;
		}
		
		public static function actionValue( string: String):int
		{
			switch( string)
			{
				case "idle":
				{
					return IDLE;
				}
				case "move":
				{
					return MOVE;
				}
				case "attack":
				{
					return ATTACK;
				}
				case "dialog":
				{
					return DIALOG;
				}
			}
			return UNDEFINED;
		}*/
	}
}