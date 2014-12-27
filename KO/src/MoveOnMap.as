package
{
	import com.rocketmandevelopment.grid.Cell;
	
	import flash.display.MovieClip;
	import flash.geom.Vector3D;
	
	import away3d.entities.Mesh;
	
	import packages.characters.Action;
	import packages.characters.Character;
	
	import ru.inspirit.steering.SteerVector3D;
	import ru.inspirit.steering.Vehicle;
	import ru.inspirit.steering.behavior.BehaviorList;
	import ru.inspirit.steering.behavior.Seek;
	import ru.inspirit.steering.behavior.UnalignedCollisionAvoidance;
	
	import sunag.sea3d.SEA3D;
	
	public class MoveOnMap extends MovieClip
    {
		private var startCell:Cell;
		private var endCell:Cell;
		
		public function MoveOnMap()
        {
            trace(" MoveOnMap");
        }
		
		public function positionOriginalMeshes(sea3d:SEA3D): void
		{
			//scale and position meshes //scale may not be needed, as the relative distance and apparent size is now handled by orthographic camera equation
			for( var k:int=0;k<sea3d.meshes.length;k++)
			{
				//if mesh parent is also a mesh, assume a joint dependency, so no need to relocate it, as the mesh parent  will be moved
				var mesh:Mesh = sea3d.meshes[k] as Mesh;
				if((mesh.parent is Mesh) == false)
				{
					mesh.position = new Vector3D(10000, 10000, 0);
					mesh.rotation = new Vector3D(0, 0, 0);
					mesh.scale = new Vector3D(1,1,1);
				}
			}
		}
		
		//if character current action is MOVE
		public function updatingMapPosition(character: Character): void
		{
			Main.MAP.updateMapLocation(character);//this updates the moving characters position per frame
			
			if (character.actions[0] == Action.MOVE && Main.suspendState != true)
			{
				//starling map Sprite not needed anymore, remove all its references
				
				var rotationRad:Number = Math.atan2(character.destinationVector.z - character.routeVector.z, Math.abs(character.destinationVector.x) - Math.abs(character.routeVector.x));
				for( var m:int=0;m<character.avatar.meshes.length;m++)
				{
					character.avatar.meshes[m].position =  character.routeVector;
					//the following condition is needed to make sure rotation doesn't apply when roused and destination vectors are equal, otherwise the rotation jumps to coordinates zero, and looks weird. :-)
					if (Main.MAP3D.zeroVector.equals(character.destinationVector.subtract(character.routeVector)) == false)
						character.avatar.meshes[m].rotationY = rotationRad * (180 / Math.PI) - 90;
				}
				
				//make sure the camera follows only the selected character and all the 3-D operations are applied for correct position of the camera
				if(character.selected == true)
					Main.away3dView.camera.position = (character.routeVector.add(Main.cameraDelta)).subtract(Main.MAP3D.adjustCamera);
				
				/*//moving the NPC
				//TO DO updating  cell for player party as well
				for each (var character: Character in Main.currentMapCharacters)
				{
					var _movePoint: Point = new Point(-Main.MAP._tempPoint.x,-Main.MAP._tempPoint.y);
					character.endPoint = character.startPoint.add(_movePoint);
					
					//updating  idle NPC cell on grid location
					character.cells[0].x = character.endPoint.x;
					character.cells[0].y = character.endPoint.y;
					
					//updating NPC meshes coordinates
					for( var m:int=0;m<character.avatar.meshes.length;m++)
					{
						//vector has to be X,Y,0 format
						character.avatar.meshes[m].position = new Vector3D(character.endPoint.x,character.endPoint.y,0);
					}
				}*/
			}
		}

		public function moving(character: Character):void
		{
			var _o:SteerVector3D = character.avatar.vehicle.position;
			var _t:SteerVector3D = character.targetCharacter.avatar.vehicle.position;
			if(Math.abs(_t.x-_o.x)>(character.avatar.bounds.z/2+character.targetCharacter.avatar.bounds.z/2)
				|| Math.abs(_t.y-_o.y)>(character.avatar.bounds.z/2+character.targetCharacter.avatar.bounds.z/2)
				|| Math.abs(_t.z-_o.z)>(character.avatar.bounds.z/2+character.targetCharacter.avatar.bounds.z/2))
			{
				character.avatar.vehicle.allForces = _t.diff(_o);
				//character.avatar.vehicle.allForces = new SteerVector3D(Math.min(_o.x-_t.x,_t.x-_o.x),Math.min(_o.y-_t.y,_t.y-_o.y),Math.max(_o.z-_t.z,_t.z-_o.z));
				//trace(_t.diff(_o));
				
				//DELETE this function
				//updatingMapPosition(character);
				
				//if moving and obstacles not set, set them excluding the character and its target
				//TO DO this may be needed dynamically, checked on every frame to update position of moving obstacles
				//if(character.avatar.obstacles.length == 0)
				{
					for each(var _char:Character in Main.MAP.allCharacters)
					{
						if(character != _char && character.targetCharacter != _char)
							character.avatar.obstacles.push(_char.avatar.vehicle);
					}
				}
				
				//after character obstacles are set, set the behavior
				//first  seek the target
				var seek:Seek = new Seek(character.targetCharacter.avatar.vehicle.position);
				character.avatar.vehicle.behaviorList = new BehaviorList(seek);
				seek.target = character.targetCharacter.avatar.vehicle.position;
				seek.apply(character.avatar.vehicle);
				character.avatar.vehicle.update();
				
				//avoid NPCs
				for each( var _v: Vehicle in character.avatar.obstacles)
				{
					var avoid:UnalignedCollisionAvoidance = new UnalignedCollisionAvoidance(_v);
					character.avatar.vehicle.behaviorList = new BehaviorList(avoid);
					avoid.avoidList = _v;
					avoid.apply(character.avatar.vehicle);
				}
				//TO DO is the update  done per obstacle or it's done as the final step, ofor all the obstacles?
				character.avatar.vehicle.update();
				
				//avoid obstacles set above
				//character.avatar.vehicle.velocity.scaleBy(character.avatar.vehicle.maxSpeed);
				
				//update meshes position to match seeking/avoiding position 3-D from vehicle class
				var _p:SteerVector3D = character.avatar.vehicle.position;
				for(var m:int=0;m<character.avatar.meshes.length;m++)
					character.avatar.meshes[m].position = new Vector3D(_p.x,_p.y,_p.z);
				
				//TO DO something fishy with the first reposition frame/S? look into it
				//trace(_p);
				
				//trace(character.avatar.vehicle.position,character.avatar.characterClass.position);
				
				//handle rotation//for now, this will change probably when enabling avoiding obstacles
				character.routeVector = new Vector3D(_p.x,_p.y,_p.z);
				var rotationRad:Number = Math.atan2(character.targetCharacter.routeVector.z - character.routeVector.z, Math.abs(character.targetCharacter.routeVector.x) - Math.abs(character.routeVector.x));
				for(m=0;m<character.avatar.meshes.length;m++)
				{
					character.avatar.meshes[m].rotationY = rotationRad * (180 / Math.PI) - 90;
				}
				
				//make sure the camera follows only the selected character and all the 3-D operations are applied for correct position of the camera
				character.routeVector = new Vector3D(_p.x,_p.y,_p.z);
				if(character.selected == true)
					Main.away3dView.camera.position = (character.routeVector.add(Main.cameraDelta)).subtract(Main.MAP3D.adjustCamera);
			}
			//reached the destination from the MOVE action, so time to prepare for the next queued action
			else
			{
				//reset vehicle
				character.avatar.vehicle.identity();
				character.avatar.vehicle.position = new SteerVector3D(character.routeVector.x,character.routeVector.y,character.routeVector.z);
				character.avatar.obstacles = new Array;
				
				character.actions.shift();
				if(character.actions.length == 0)
					character.targetCharacter = null;
			}
		}
	}
}