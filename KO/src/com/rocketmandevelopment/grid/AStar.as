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
				//var n:Array = currentCell.neighbors;
				var n:Array = Main.MAP3D.getWalkable(currentCell.neighbors);//identify walkable cells
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
			var controlPoints:Vector.<Vector3D> = new Vector.<Vector3D>();
			trace( "path length", path.length);
			for(i=0;i<path.length;i++)
			{
				var cell: Cell = path[i];
				controlPoints.push(cell.position);
			}
			
			var result:Vector.<Vector3D> = new Vector.<Vector3D>();
			var increment: Number = 0;
			while (increment <= 1)
			{
				var out:Vector3D = new Vector3D;
				out = Nurbs.nurbs(increment, controlPoints);
				result.push(out);
				increment+=0.002;
			}
			
			for(i=0;i<result.length;i++)
			{
				var l:Vector3D = result[i].subtract(Main.MAP3D.adjustCamera);
				var line:LineSegment = new LineSegment(l,l.subtract(new Vector3D(0,0,32)),0x00ffff,0x0000ff);
				var lineSet:SegmentSet = new SegmentSet();
				lineSet.addSegment(line);
				Main.away3dView.scene.addChild(lineSet);
				//trace( "results", result[i], result.length);
			}
			
			return path;
		}
		
		public static function diagonal(current:Cell, end:Cell):Number {
			var xDistance:int = Math.abs(current.x - end.x);
			var yDistance:int = Math.abs(current.y - end.y);
			if(xDistance > yDistance) {
				return yDistance + (xDistance - yDistance);
			} else {
				return xDistance + (yDistance - xDistance);
			}
			return 0;
		}
		
		public static function manhattan(current:Cell, end:Cell):Number {
			return Math.max(Math.abs(current.x - end.x), Math.abs( current.y - end.y));
		}
		
		private static function getLowestF(list:Array):Cell {
			list.sortOn("f", Array.NUMERIC | Array.DESCENDING);
			return list.pop();
		}
		
		private static function isDiagonal(center:Cell, other:Cell):Boolean {
			if(center.x != other.x && center.y != other.y) {
				return true;
			}
			return false;
		}
	}
}