//cell has Encounter ID and character has Dialogue ID and party has Get Party By Encounter ID
package packages.map
{
	import com.rocketmandevelopment.grid.Cell;
	import com.rocketmandevelopment.grid.Grid;
	
	import flash.geom.Vector3D;
	
	import packages.characters.Avatar;
	import packages.characters.Character;
	import packages.characters.NPC;
	import packages.characters.Weapon;
	
	import ru.inspirit.steering.SteerVector3D;
	import ru.inspirit.steering.Vehicle;
	
	public class MapLogic extends Object
	{
		public function MapLogic()
		{
			return;
		}
		
		public function initializeMap(): void
		{
			populateMap();
			setWeapons();
		}
			
		//TO DO         private function portraitClick(arg1:flash.events.MouseEvent):void

		public function populateMap(): void
		{
			//create the grid,  the cells  in the grid have 3-D coordinates, but the grid basically is one plane at an angle, with no depth
			Grid.createGrid(128,128);
			
			//get the statically assigned objects for the current map
			//TO DO programmatically create objects on map
			var cells: Array = MapObjects.getMapObjects(Main.MAP.mapID);
			trace( "map",Main.MAP.mapID, "has",  cells.length, "special cells");
			
			for each (var cell:Cell in cells)
			{
				//trace( "encounter ID",  cell.encounterID);
				Grid.cellAt(cell.gridC, cell.gridR).encounterID = cell.encounterID;
				if(cell.encounterID == 0)//this is starting point in the map
				{
					var selectedCharacter: Character = Main.selectedCharacter;
					//selectedCharacter.cells.splice(0,1);
					selectedCharacter.cells.push(cell);
					Main.MAP.allCharacters.push(selectedCharacter);
				}
				else
				{
					var character: Character = NPC.getNPCByEncounterID(cell.encounterID);
					character.cells.push(cell);
					if( character.avatar == null)	var avatar: Avatar = new Avatar( character, true);
					avatar.setAvatar(character);
					
					//Main.MAP.allCharacters[cell.encounterID] = character;
					Main.MAP.allCharacters.push(character);
				}
			}
			
			//setting current grid
			var _grid:Grid = Grid.getGrid();
			_grid.gridID = Main.MAP.mapID;
			Main.mapGrids[Main.MAP.mapID] = _grid;
			Main.currentGrid = Main.mapGrids[Main.MAP.mapID];
			positionObjects();
		}
		
		public function positionObjects(): void
		{
			for each (var character: Character in Main.MAP.allCharacters)
			{
				var cell: Cell = character.cells[0];

				character.routeVector = Grid.cellAt(cell.gridC, cell.gridR).position;
				
				//create new vehicle for future use in steering
				//get the current position  to set the vehicle position
				var _p: Vector3D = character.routeVector;
				character.avatar.vehicle = new Vehicle(new SteerVector3D(_p.x,_p.y,_p.z));
				//get the  bounds to set vehicle and  bounds radius
				character.avatar.bounds = character.avatar.setbounds3d(character);
				character.avatar.vehicle.vehicleRadius = character.avatar.bounds.z;
				character.avatar.vehicle.boundsRadius = character.avatar.vehicle.vehicleRadius + 5;
				//trace( character.characterName,character.avatar.vehicle.vehicleRadius);
				
				if(character.selected == false)
				{
					for( var m:int=0;m< character.avatar.meshes.length;m++)
					{
						character.avatar.meshes[m].position = character.routeVector;
						character.avatar.meshes[m].rotation = new Vector3D(0,45,0);
					}
				}
				else//this is the selected character, so the camera is positioned relative to its position
				{
					for(m=0;m<character.avatar.meshes.length;m++)
					{
						character.avatar.meshes[m].position = character.routeVector;
					}
					Main.away3dView.camera.position = character.routeVector.add(Main.cameraDelta).subtract(Main.MAP3D.adjustCamera);
				}
			}
		}
		
		public function setWeapons(): void
		{
			//setting weapon for active characters on current map
			for each (var character: Character in Main.MAP.allCharacters)
			{
				if(character.activeWeapon != -1)
					Weapon.setWeapon(character,character.activeWeapon);
			}
		}
	}
}