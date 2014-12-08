package com.rocketmandevelopment.grid 
{
	import flash.geom.Vector3D;
	
	public class Cell {
		public var f:Number = 0;
		public var g:Number = 0;
		public var h:Number = 0;
		public var isClosed:Boolean = false;
		public var isStart:Boolean = false;
		public var isOpen:Boolean = false;
		public var isWalkable:Boolean = false;
		
		public var encounterID:int = -1;
		
		public var gridC:int;
		public var gridR:int;
		
		private var _neighbors:Array;
		public var parent:Cell;
		public var possibleActions:Array = [];
		public var visited:Boolean = false;
		
		public function Cell(x:int, y:int, z:int) {
			_x = x;
			_y = y;
			_z = z;
		}
		
		public function get position():Vector3D {
			return new Vector3D(_x, _y, _z);
		}
		
		public function get rotation():Vector3D {
			return new Vector3D(-Main.away3dView.camera.rotationX,-Main.away3dView.camera.rotationY,-Main.away3dView.camera.rotationZ);
		}
		
		public function get neighbors():Array {
			if(!_neighbors) {
				_neighbors = [];
				_neighbors.push(Grid.cellAt(gridC - 1, gridR - 1));
				_neighbors.push(Grid.cellAt(gridC, gridR - 1));
				_neighbors.push(Grid.cellAt(gridC + 1, gridR - 1));
				_neighbors.push(Grid.cellAt(gridC + 1, gridR));
				_neighbors.push(Grid.cellAt(gridC + 1, gridR + 1));
				_neighbors.push(Grid.cellAt(gridC, gridR + 1));
				_neighbors.push(Grid.cellAt(gridC - 1, gridR + 1));
				_neighbors.push(Grid.cellAt(gridC - 1, gridR));
				var len:int = _neighbors.length
				for(var i:int = len - 1; i >= 0; i--) {
					if(_neighbors[i] == null) {
						//trace( "if neighbors null");
						_neighbors.splice(i, 1);
					}
				}
			}
			return _neighbors;
		}
		
		/**
		 * setting and getting x and y
		 **/
		private var _x:int;
		
		public function set x(value:int):void {
			_x = value;
		}
		public function get x():int {
			return _x;
		}
		
		private var _y:int;
		
		public function set y(value:int):void {
			_y = value;
		}
		
		public function get y():int {
			return _y;
		}
		
		private var _z:int;
		
		public function set z(value:int):void {
			_z = value;
		}
		
		public function get z():int {
			return _z;
		}
		
		public function clear():void {
			f = 0;
			g = 0;
			h = 0;
			isClosed = false;
			isOpen = false;
			parent = null;
			isWalkable = true;
		}
		
		/*public function draw(g:Graphics, w:Number, h:Number):void {
			if(!isWalkable) {
				g.beginFill(0x000088);
			}
			g.drawRect(_x * w, _y * h, w, h);
			g.endFill();
		}*/
		
		public function reset():void {
			f = 0;
			g = 0;
			h = 0;
			isClosed = false;
			isOpen = false;
			parent = null;
		}
		
		public function toString():String {
			return "Cell(x: " + _x + " y: " + _y + " z: " + _z + ")"; // " f: "+ f +" g: "+g+" h: "+h + ")";
		}
	}
}