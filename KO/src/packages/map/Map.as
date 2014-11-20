package packages.map
{
	import com.rocketmandevelopment.grid.Cell;
	
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import packages.characters.Character;
	
    public class Map extends Object
    {
		public var current:Map;
		public var startVector:Vector3D = new Vector3D;
		
		public var mapID:int=0;
		public var pathSquares:Array = new Array();
		public var squares:Array = new Array();
		public var route:Array = new Array();
		public var mapImages:Array = new Array();
		public var mapPathImages:Array = new Array();
		//public var mapPathBitmapData:Array = new Array();
		public var targetLocation:Cell;
		public var currentLocation:Cell;
		public var midX:Number;
		public var midY:Number;
		public var currentMapX:Number = 0;
		public var currentMapY:Number = 0;
		//public var divider:int;
		public var _pixel:uint;
		public var _point:Point;
		public var _center:Point;
		public var _routePoint:Point;
		public var _tempPoint:Point = new Point;
		//public var _localPoint:Point = new Point;//not needed?
		public var runSpeed:Number;
		public var inTransit:Boolean=false;
		//public var _bestPath:Array = new Array();
		//public var counter:int=0;
		//public var deltaPoint:Point = new Point;
		
        public function Map()
        {
            current = this;
            return;
        }
		
		public function cleanup(): void
		{
			 mapID=0;
			 pathSquares=[];
			 squares=[];
			 route=[];
		}
		
		private function get moving():Boolean
		{
			return !(route == null) && route.length;
		}

		//TO DO do I need this?
		public function requestTravelTo(_source:Cell, _destination:Cell, _maxLength:int=-1):void
		{
			if (Main.suspendState == true) 
			{
				return;
			}
			
			targetLocation = _destination;
			if (route.length > 1) 
			{
				route.splice(0, 1);
			}
			inTransit = true;
			
			/*if (selectedChar && selectedChar.avatar) 
			{
				selectedChar.avatar.startWalkSound(0.2, 15);
			}
			movementIndicator.visible = true;
			movementIndicator.x = _destination.x;
			movementIndicator.y = _destination.y;*/
			return;
		}
		
		public function updateMapPoint(): void
		{
			if (_tempPoint.equals(_point.subtract(_center)) == false)
			{
				//trace(_tempPoint,_point.subtract(_center));
				inTransit = true;
				
				var _middlePoint: Point = new Point;
				_middlePoint.x = midX;
				_middlePoint.y = midY;
				
				if(Main.running)	 runSpeed=4.5;
				else	 runSpeed=3;
				
				_routePoint = moveAlongRoute(_point, _middlePoint, runSpeed);
				
				midX = _routePoint.x;// + _localPoint.x;
				midY = _routePoint.y;// + _localPoint.y;
			}
			else
			{
				Main.activePlayerCharacter.startVector = Main.activePlayerCharacter.characterClass.position;
				Main.cameraPosition = Main.away3dView.camera.position;
				//Main.MAP3D.mapTilesPosition = Main.mapTiles.position;
				
				//trace( "finished moving",Main.activePlayerCharacter.startVector, Main.MAP3D.mapTilesPosition);
				
				_tempPoint = new Point;
				
				inTransit = false;
			}
		}
		
		public function moveAlongRoute(destinationPoint:Point, middlePoint:Point, speed:Number):Point
		{
			var updatePoint:Point = null;
			if (destinationPoint == null) 
			{
				return middlePoint;
			}
			var deltaPoint:Point = new Point(destinationPoint.x - middlePoint.x, destinationPoint.y - middlePoint.y);
			
			deltaPoint.normalize(speed);
			updatePoint = middlePoint.add(deltaPoint);
			if (middlePoint.x < destinationPoint.x) 
			{
				updatePoint.x = Math.min(updatePoint.x, destinationPoint.x);
			}
			else 
			{
				updatePoint.x = Math.max(updatePoint.x, destinationPoint.x);
			}
			if (middlePoint.y < destinationPoint.y) 
			{
				updatePoint.y = Math.min(updatePoint.y, destinationPoint.y);
			}
			else 
			{
				updatePoint.y = Math.max(updatePoint.y, destinationPoint.y);
			}
			
			_tempPoint.x = updatePoint.x - _center.x;// + currentMapX;
			_tempPoint.y = updatePoint.y - _center.y;// + currentMapY;
			
			return updatePoint;
		}
	}
}