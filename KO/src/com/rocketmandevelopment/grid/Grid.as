package com.rocketmandevelopment.grid 
{
	public class Grid 
	{
		private static var theGrid:Grid;
		
		private var _height:int;
		private var _width:int;
		
		public var grid:Array;
		public var gridID:int=0;
		
		public function Grid(width:int, height:int) {
			_width = width;
			_height = height;
			grid = [];
			for(var x:int = 0; x < _width; x++) {
				grid[x] = [];
				for(var y:int = 0; y < _height; y++) {
					//if (x % 2 != 1) 	
					grid[x][y] = new Cell(-x*Main.cellSize,-Math.round(y*Main.cellSize*Main.MAP3D.say),Math.round(y*Main.cellSize*Main.MAP3D.caz));
					//else	grid[x][y] = new Cell(40+x*40,y*Main.cellSize);
					grid[x][y].gridC = x;
					grid[x][y].gridR = y;
				}
			}
		}
		
		public static function cellAt(x:int, y:int):Cell {
			if((x >= 0 && x < theGrid.grid.length) && y >= 0 && y < theGrid.grid[0].length) {
				return theGrid.grid[x][y];
			}
			return null;
		}
		
		public static function clear():void {
			if(!theGrid.grid) {
				return;
			}
			for(var x:int = 0; x < theGrid._width; x++) {
				for(var y:int = 0; y < theGrid._height; y++) {
					theGrid.grid[x][y].clear();
				}
			}
		}
		
		public static function createGrid(width:int, height:int):Grid {
			if(theGrid) {
				return theGrid;
			}
			var g:Grid = new Grid(width, height);
			theGrid = g;
			return g;
		}
		
		public static function getGrid():Grid {
			if(theGrid) {
				return theGrid;
			}
			return null;
		}
		
		public static function reset():void {
			if(!theGrid.grid) {
				return;
			}
			for(var x:int = 0; x < theGrid._width; x++) {
				for(var y:int = 0; y < theGrid._height; y++) {
					theGrid.grid[x][y].reset();
				}
			}
		}
	}
}