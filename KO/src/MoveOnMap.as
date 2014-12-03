package
{
	import away3d.entities.Mesh;
	
	import com.rocketmandevelopment.grid.AStar;
	import com.rocketmandevelopment.grid.Cell;
	import com.rocketmandevelopment.grid.Grid;
	import com.rocketmandevelopment.math.Vector2D;
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import packages.characters.Action;
	import packages.characters.Character;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	
	import sunag.sea3d.SEA3D;
	
	public class MoveOnMap extends MovieClip
    {
		/*private var newX:Number;
		private var newY:Number;
		private var tempX:Number=0;
		private var tempY:Number=0;*/
		
		private var sCell:Vector2D;
		private var eCell:Vector2D;
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
				
				for( var m:int=0;m<character.characterMesh.length;m++)
				{
					character.characterMesh[m].position =  character.routeVector;
				}

				//make sure the camera follows only the selected character and all the 3-D operations are applied for correct position of the camera
				if(character.selected == true)
					Main.away3dView.camera.position = (character.routeVector.add(Main.cameraDelta)).subtract(character.adjustVector);
				
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
					for( var m:int=0;m<character.characterMesh.length;m++)
					{
						//vector has to be X,Y,0 format
						character.characterMesh[m].position = new Vector3D(character.endPoint.x,character.endPoint.y,0);
					}
				}*/
			}
		}

		public function moving(character: Character):void
		{
			//var rotationRad:Number = Math.atan2(target.z - char.z, mouseX - target.x) ;
			//char.rotationY = rotationRad * (180 / Math.PI); // (180 / Math.PI) = radians to degrees
			
			var rotationRad:Number = Math.atan2(character.destinationVector.z - character.routeVector.z, Math.abs(character.destinationVector.x) - Math.abs(character.routeVector.x));
			
			//trace(rotationRad);
			//TO DO to fix party member rotation
			
			for( var m:int=0;m<character.characterMesh.length;m++)
			{
				character.characterMesh[m].rotationY = rotationRad * (180 / Math.PI) - 90;
			}
			
			//findPath();//TO DO, this broke when map tiles are now 3-D
			
			//trace("mouse was clicked", event.stageX, event.stageY, newX, newY);
		}
		
		public function cellSprite(c:int,r:int): void
		{
			var _grid:Grid = Main.currentGrid;
			var _sCell:Sprite = new Sprite;
			_sCell.name= "cellSprite";
			var _iCell:Image = new Image(Assets.getAtlas("SPECIALS").getTexture("square_red"));
			_iCell.alpha = 0.5;
			_iCell.width = Main.cellSize;
			_iCell.height = Main.cellSize;
			var _string: String = String(c) + " " + String(r);
			var _text:TextField = new TextField( Main.cellSize,Main.cellSize,_string, "Helvetica", 10, 0x000000);
			_sCell.x = _grid.grid[c][r].x;
			_sCell.y = _grid.grid[c][r].y;
			_sCell.addChild(_iCell);
			_sCell.addChild(_text);
			//StarlingMapSprite.getInstance().addChild(_sCell);
		}
		
		public function findPath(): void
		{
			var ArrayD:*=new Array();
			//handle the walking  grid, with a source and destination vector
			//var gRows:*=Math.ceil(Main.gameStage.stageHeight/Main.cellSize);
			//var gColumns:*=Math.ceil(Main.gameStage.stageWidth/Main.cellSize);
			
			if (sCell == null)		 
			{
				//trace( "vector starting cell empty, setting it as",Main.activePlayerCharacter.cells[0].gridC,Main.activePlayerCharacter.cells[0].gridR);
				//sCell = new Vector2D(Main.activePlayerCharacter.cells[0].gridC,Main.activePlayerCharacter.cells[0].gridR);
			}
			
			var _grid:Grid = Main.currentGrid;
			
			//reposition the grid cells
			for (var i:uint=0;i<_grid.grid.length;i++)
			{
				/*for (var m:uint=0;m<_grid.grid[0].length;m++)
				{
				//_grid.grid[i][m].x = _grid.grid[i][m].x + StarlingMapSprite.getInstance().x;
				//_grid.grid[i][m].y = _grid.grid[i][m].y + StarlingMapSprite.getInstance().y;
				
				//calculate and set best path array
				var tX:uint = Math.abs( Main.MAP._point.x - (_grid.grid[i][m].x + Main.cellSize/2));
				var tY:uint = Math.abs( Main.MAP._point.y - (_grid.grid[i][m].y + Main.cellSize/2));
				var tS:uint = tX*tX + tY*tY;
				
				ArrayD.push({columns:i, rows:m, temp:tS});
				}*/
			}
			
			ArrayD.sortOn("temp", Array.NUMERIC);
			//trace("destination is  vector",ArrayD[0].columns,ArrayD[0].rows);
			eCell = new Vector2D(ArrayD[0].columns,ArrayD[0].rows);
			
			//TEMP	 showing  best path
			/*var _imageRed:Image = new Image(Assets.getAtlas("SPECIALS").getTexture("square_red"));
			_imageRed.name= "cell";
			_imageRed.alpha = 0.5;
			
			_imageRed.x = _grid.grid[gColumns][gRows].x;
			_imageRed.y = _grid.grid[gColumns][gRows].y;*/
			
			//display cell destination
			cellSprite(ArrayD[0].columns,ArrayD[0].rows);
			
			//var _aStar:AStar =  new AStar();
			var bestPath: Array = AStar.aStar( sCell, eCell);
			//trace( bestPath.length);
			//trace( "starting vector is", sCell, "		||		destination vector is",eCell, "		||		best path is", bestPath.length);
			
			/*for (var k:uint=0;k<bestPath.length;k++)
			{
			var _imageCell:Image = new Image(Assets.getAtlas("SPECIALS").getTexture("square_red"));
			_imageCell.name= "cell";
			_imageCell.width = Main.cellSize;
			_imageCell.height = Main.cellSize;
			_imageCell.x = bestPath[k].x;
			_imageCell.y = bestPath[k].y;
			_imageCell.alpha = 0.5;
			StarlingMapSprite.getInstance().addChild(_imageCell);
			}*/
			
			/*//move the player along the best path
			if (startCell == null)	
			{
				startCell = Main.activePlayerCharacter.cells[0];//_grid.grid[gColumns][gRows];
				//trace( "start cell is  empty, setting it as",startCell.gridC, startCell.gridR);
			}
			endCell = _grid.grid[ArrayD[0].columns][ArrayD[0].rows];
			//TO DO moving NPC as well, not only the player
			if (_grid.grid[ArrayD[0].columns][ArrayD[0].rows].isWalkable)
				// && Main.MAP._pixel.toString(16) ==  "ff00")
			{
				//Main.movingPlayer = true;
				//updating starting cell for future calculations
				Main.activePlayerCharacter.cells.splice(0,1);
				Main.activePlayerCharacter.cells.push(endCell);
				//trace(Main.activePlayerCharacter.cells.length,Main.activePlayerCharacter.cells[0].gridC,Main.activePlayerCharacter.cells[0].gridR);
				Main.MAP.current.requestTravelTo(startCell, endCell, 30);	 
			}
			sCell = eCell; //this is a vector 2-D
			startCell = endCell; //this is a Cell
			*/
		}
	}
}