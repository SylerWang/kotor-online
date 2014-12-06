package packages.map
{
	import com.rocketmandevelopment.grid.Cell;

	public class MapObjects extends Object
	{
		public function MapObjects()
		{
			 return;
		}
		
		public static function getMapObjects( mapID:int): Array
		{
			var cells: Array = new Array();
			switch( mapID)
			{
				case 1:
				default:
				{
					var cell:Cell = new Cell(0,0,0);
					cell.gridC=25;
					cell.gridR=10;
					cell.encounterID=0;
					cells.push(cell);
					
					cell = new Cell(0,0,0);
					cell.gridC=43;
					cell.gridR=15;
					cell.encounterID=1;
					cells.push(cell);
					
					return cells;
				}
			}
			return null;
		}
	}
}