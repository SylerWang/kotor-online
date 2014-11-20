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
			selectCharacter(Main.activePlayerCharacter);
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
					//Main.activePlayerCharacter.cells.splice(0,1);
					Main.activePlayerCharacter.cells.push(cell);
					
					var _x: Number = -Grid.cellAt(cell.gridC, cell.gridR).x;
					var _y: Number = -Grid.cellAt(cell.gridC, cell.gridR).y;
					
					Main.activePlayerCharacter.startVector = new Vector3D(_x,_y*Main.MAP3D.say,-_y*Main.MAP3D.caz);
					for( var m:int=0;m<Main.activePlayerCharacter.characterMesh.length;m++)
					{
						Main.activePlayerCharacter.characterMesh[m].position = new Vector3D(_x,_y*Main.MAP3D.say,-_y*Main.MAP3D.caz); 
					}
					Main.away3dView.camera.position = Main.cameraPosition.add(Main.activePlayerCharacter.startVector);
					Main.cameraPosition = Main.away3dView.camera.position;
				}
				else
				{
					var character: Character = NPC.getNPCByEncounterID(cell.encounterID);
					character.cells.push(cell);
					if( character.avatar == null)	var avatar: Avatar = new Avatar( character, true);
					avatar.setAvatar(character);
					Main.currentMapCharacters[cell.encounterID] = character;
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
			for each (var character: Character in Main.currentMapCharacters)
			{
				var cell: Cell = character.cells[0];
				//trace( "before", character.cells[0].x,character.cells[0].y);
				cell.x = Main.mapGrids[Main.MAP.mapID].grid[cell.gridC][cell.gridR].x;
				cell.y = Main.mapGrids[Main.MAP.mapID].grid[cell.gridC][cell.gridR].y;
				//TO DO maybe there's a better way
				character.cells.splice(0,1);
				character.cells.push(cell);
				character.startPoint = Main.SPRITES.getGlobalToLocal(character.cells[0].x, character.cells[0].y);
				//trace( "after", character.cells[0].x,character.cells[0].y, character.startPoint);
				//startCell(cell);
				for( var m:int=0;m< character.characterMesh.length;m++)
				{
					//vector has to be -X,-Y,0 format
					character.characterMesh[m].position = new Vector3D(-character.cells[0].x,-character.cells[0].y*Main.MAP3D.say,character.cells[0].y*Main.MAP3D.caz);
					character.characterMesh[m].rotation = new Vector3D(0,45,0);
					//trace(cell.encounterID,character.characterName,new Vector3D(cell.gridC*Main.cellSize,cell.gridR*Main.cellSize,0));
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
		
		public function selectCharacter(char:Character):void
		{
			//clearPortraitHighlights();
			if (char == null) 
			{
				trace( " selected character missing! Falling back on default player at index 0");
				char = Main.playerParty.members[0];
			}
			//char.portrait.setHighlight(true);
			StarlingFrontSprite.getInstance().quickBarLogic.setChar(char);
			return;
		}
		
		public function setWeapons(): void
		{
			//setting weapon for characters in player party
			for each (var player: Character in Main.playerParty.members)
			{
				if(player.activeWeapon != -1)
					Weapon.setWeapon(player,player.activeWeapon);
			}
			
			//setting weapon for active NPC on current map
			for each (var character: Character in Main.currentMapCharacters)
			{
				if(character.activeWeapon != -1)
					Weapon.setWeapon(character,character.activeWeapon);
			}
		}
	}
}