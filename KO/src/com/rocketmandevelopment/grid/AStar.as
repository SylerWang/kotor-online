package com.rocketmandevelopment.grid 
{
	import away3d.entities.SegmentSet;
	import away3d.primitives.LineSegment;
	
	import com.math.Nurbs;
	import com.rocketmandevelopment.grid.Cell;
	
	import flash.geom.Vector3D;
	
	public class AStar {
		public static var heuristic:Function = manhattan;
		
		public function AStar() {
		}
		
		public static function aStar(start:Cell, end:Cell):Array {
			Grid.reset();
			var open:Array = [Grid.cellAt(start.gridC, start.gridR)];
			open[0].isOpen = true;
			var closed:Array = [];
			var currentCell:Cell;
			var path:Array;
			
			while(true) {
				if(open.length == 0) {
					break;
				}
				currentCell = getLowestF(open);
				if(currentCell.gridC == end.gridC && currentCell.gridR == end.gridR) {
					path = [currentCell];
					while(true) {
						path.push(currentCell.parent);
						currentCell = currentCell.parent;
						if(!currentCell.parent) {
							path.reverse();
							break;
						}
					}
					break;
				}
				closed.push(currentCell);
				currentCell.isClosed = true;
				//identify walkable cells from neighbors
				var n:Array = Main.MAP3D.getWalkable(currentCell.neighbors);
				for(var i:int = 0; i < n.length; i++) {
					if(n[i] == null || !n[i].isWalkable) {
						continue;
					}
					if(!n[i].isOpen && !n[i].isClosed) {
						open.push(n[i]);
						n[i].isOpen = true;
						if(isDiagonal(currentCell, n[i])) {
							n[i].g = 1.4;
						} else {
							n[i].g = 1;
						}
						n[i].parent = currentCell;
						n[i].g += n[i].parent.g;
						n[i].h = heuristic(n[i], end);
						n[i].f = n[i].g + n[i].h;
					} else {
						var tg:Number;
						if(isDiagonal(currentCell, n[i])) {
							tg = 1.4;
						} else {
							tg = 1;
						}
						tg += currentCell.g;
						if(tg < n[i].g) {
							n[i].g = tg;
							n[i].f = n[i].g + n[i].h;
							n[i].parent = currentCell;
						}
					}
				}
			}
			
			//nurbs it
			Main.MAP3D.nurbsCurve(path);
			
			return path;
		}
		
		public static function manhattan(current:Cell, end:Cell):Number {
			return Math.max(Math.abs(current.x - end.x), Math.abs( current.y - end.y), Math.abs( current.z - end.z));
		}
		
		private static function getLowestF(list:Array):Cell {
			list.sortOn("f", Array.NUMERIC | Array.DESCENDING);
			return list.pop();
		}
		
		private static function isDiagonal(center:Cell, other:Cell):Boolean {
			if(center.x != other.x && center.y != other.y && center.z != other.z) {
				return true;
			}
			return false;
		}
	}
}