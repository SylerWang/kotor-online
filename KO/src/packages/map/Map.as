package packages.map
{
	import com.rocketmandevelopment.grid.Cell;
	
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import packages.characters.Character;
	
    public class Map extends Object
    {
		public var current:Map;
		public var allCharacters: Array = new Array;
		public var enemies: Array = new Array;
		
		public var mapID:int=0;
		public var pathSquares:Array = new Array;
		public var squares:Array = new Array;
		public var route:Array = new Array;

		public var targetLocation:Cell;
		public var currentLocation:Cell;
		
		public var runSpeed:Number;
		
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
			 allCharacters=[];
			 enemies=[];
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
			
			/*if (selectedChar && selectedChar.avatar) 
			{
				selectedChar.avatar.startWalkSound(0.2, 15);
			}
			movementIndicator.visible = true;
			movementIndicator.x = _destination.x;
			movementIndicator.y = _destination.y;*/
			return;
		}
		
		public function updateMapLocation(character: Character): void
		{
			//if there is any difference in between current vector and destination vector, it still needs to move
			if (Main.MAP3D.zeroVector.equals(character.destinationVector.subtract(character.routeVector)) == false)
			{
				if(Main.running)	 runSpeed=4.5;
				else	 runSpeed=3;
				//TO DO consolidate running/walking/stealth speed in character class with a getter
				
				character.routeVector = moveAlongRoute(character.destinationVector, character.routeVector, runSpeed);
			}
			else
			{
				//reached the destination from the MOVE action, so time to prepare for the next queued action
				character.actions.shift();
				character.ratioVector = new Vector3D;
				character.startVector = character.characterClass.position;
				
				//trace( "finished moving",character.startVector);
			}
			
			function moveAlongRoute(destinationVector:Vector3D,  middleVector:Vector3D, speed:Number):Vector3D
			{
				if (destinationVector == null) 
				{
					return  middleVector;
				}
				
				//this approach might be a hack
				var deltaX: Point = new Point(destinationVector.x - middleVector.x,0);
				var deltaY: Point = new Point(destinationVector.y - middleVector.y,0);
				var deltaZ: Point = new Point(destinationVector.z - middleVector.z,0);
				
				var max: Number = Math.max(Math.abs(deltaX.x),Math.abs(deltaY.x),Math.abs(deltaZ.x));
				
				if(character.ratioVector.x == 0 && character.ratioVector.y == 0 && character.ratioVector.z == 0)
				{
					character.ratioVector.x = Math.abs(destinationVector.x - character.startVector.x)/max;
					character.ratioVector.y = Math.abs(destinationVector.y - character.startVector.y)/max;
					character.ratioVector.z = Math.abs(destinationVector.z - character.startVector.z)/max;
					//trace( ratioX, ratioY, ratioZ,deltaX,deltaY,deltaZ);
				}
				
				deltaX.normalize(speed*character.ratioVector.x);
				deltaY.normalize(speed*character.ratioVector.y);
				deltaZ.normalize(speed*character.ratioVector.z);
				
				character.updateVector = middleVector.add(new Vector3D(deltaX.x,deltaY.x,deltaZ.x));
				
				//the following is needed to make sure that eventually the character.update vector will have the exact values with the destination vector, so that the zero vector condition becomes true and the move action stops
				if ( middleVector.x < destinationVector.x) 
				{
					character.updateVector.x = Math.min(character.updateVector.x, destinationVector.x);
				}
				else 
				{
					character.updateVector.x = Math.max(character.updateVector.x, destinationVector.x);
				}
				if ( middleVector.y < destinationVector.y) 
				{
					character.updateVector.y = Math.min(character.updateVector.y, destinationVector.y);
				}
				else 
				{
					character.updateVector.y = Math.max(character.updateVector.y, destinationVector.y);
				}
				if ( middleVector.z < destinationVector.z) 
				{
					character.updateVector.z = Math.min(character.updateVector.z, destinationVector.z);
				}
				else 
				{
					character.updateVector.z = Math.max(character.updateVector.z, destinationVector.z);
				}
				
				return character.updateVector;
			}
		}
	}
}