//cell has Encounter ID and character has Dialogue ID and party has Get Party By Encounter ID
package packages.map
{
	import com.rocketmandevelopment.grid.Cell;
	import com.rocketmandevelopment.grid.Grid;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import packages.characters.*;
	
	import starling.events.*;
	import starling.rootsprites.StarlingFrontSprite;
	
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
			Grid.createGrid(128,128);
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
					
					var _x: Number = -Grid.cellAt(cell.gridC, cell.gridR).x;
					var _y: Number = -Grid.cellAt(cell.gridC, cell.gridR).y;
					
					selectedCharacter.routeVector = new Vector3D(_x,_y*Main.MAP3D.say,-_y*Main.MAP3D.caz);
					for( var m:int=0;m<selectedCharacter.characterMesh.length;m++)
					{
						selectedCharacter.characterMesh[m].position = new Vector3D(_x,_y*Main.MAP3D.say,-_y*Main.MAP3D.caz);
						selectedCharacter.characterMesh[m].position = selectedCharacter.characterMesh[m].position.add(selectedCharacter.adjustVector);
					}
					Main.away3dView.camera.position = selectedCharacter.routeVector.add(Main.cameraDelta);
				}
				else
				{
					var character: Character = NPC.getNPCByEncounterID(cell.encounterID);
					character.cells.push(cell);
					if( character.avatar == null)	var avatar: Avatar = new Avatar( character, true);
					avatar.setAvatar(character);
					
					//adjust position
					var adjustment:int;
					if(character.gender == Gender.FEMALE || character.gender == Gender.MALE)
					{
						adjustment = Main.MAP3D.adjust(Gender.genderString(selectedCharacter.gender));
						character.adjustVector = new Vector3D(0,adjustment*Main.MAP3D.say,-adjustment*Main.MAP3D.caz);
					}
					//TO DO get the adjustment when the character is not female or male humanoid
					
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
				//trace( "before", character.cells[0].x,character.cells[0].y);
				cell.x = Main.mapGrids[Main.MAP.mapID].grid[cell.gridC][cell.gridR].x;
				cell.y = Main.mapGrids[Main.MAP.mapID].grid[cell.gridC][cell.gridR].y;
				//TO DO maybe there's a better way
				character.cells.splice(0,1);
				character.cells.push(cell);
				
				character.routeVector = new Vector3D(-character.cells[0].x,-character.cells[0].y*Main.MAP3D.say,character.cells[0].y*Main.MAP3D.caz);
				character.routeVector = character.routeVector.add(character.adjustVector);
				
				//startCell(cell);
				if(character.selected == false)
				{
					for( var m:int=0;m< character.characterMesh.length;m++)
					{
						//vector has to be -X,-Y,0 format
						character.characterMesh[m].position = character.routeVector;
						character.characterMesh[m].rotation = new Vector3D(0,45,0);
						//trace(cell.encounterID,character.characterName,new Vector3D(cell.gridC*Main.cellSize,cell.gridR*Main.cellSize,0));
					}
				}
			}
		}
		
		/*public function startCell(cell:Cell): void
		{
		var _sStart:Sprite = new Sprite;
		_sStart.name= "cellStart";
		var _iStart:Image = new Image(Assets.getAtlas("SPECIALS").getTexture("square_red"));
		_iStart.alpha = 0.5;
		_iStart.width = Main.cellSize;
		_iStart.height = Main.cellSize;
		var _string: String = String(cell.gridC) + " " +  String(cell.gridR);
		var _text:TextField = new TextField( Main.cellSize,Main.cellSize,_string, "Helvetica", 10, 0x000000);
		_sStart.x = Main.mapGrids[Main.MAP.mapID].grid[cell.gridC][cell.gridR].x;
		_sStart.y = Main.mapGrids[Main.MAP.mapID].grid[cell.gridC][cell.gridR].y;
		//trace( "Sprite",_sStart.x,_sStart.y, "out of",Main.APP_WIDTH,Main.APP_HEIGHT);
		_sStart.addChild(_iStart);
		_sStart.addChild(_text);
		addChild(_sStart);
		}*/
		
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