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
					cell.gridC=38;
					cell.gridR=99;
					cell.encounterID=0;
					cells.push(cell);
					
					cell = new Cell(0,0,0);
					cell.gridC=56;
					cell.gridR=105;
					cell.encounterID=1;
					cells.push(cell);
					
					cell = new Cell(0,0,0);
					cell.gridC=49;
					cell.gridR=102;
					cell.encounterID=100;
					cells.push(cell);
					
					/*cell = new Cell(0,0,0);
					cell.gridC=49;
					cell.gridR=103;
					cell.encounterID=100;
					cells.push(cell);*/
					
					//when done, return the cells
					return cells;
				}
			}
			return null;
		}
	}
}