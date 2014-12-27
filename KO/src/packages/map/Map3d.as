package packages.map
{
	import com.math.Nurbs;
	import com.rocketmandevelopment.grid.Cell;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Vector3D;
	
	import away3d.entities.Mesh;
	import away3d.entities.SegmentSet;
	import away3d.materials.ColorMaterial;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.LineSegment;
	import away3d.primitives.PlaneGeometry;
	import away3d.textures.BitmapTexture;
	import away3d.tools.utils.Ray;

	public class Map3d extends Object
	{
		public var zeroVector:Vector3D = new Vector3D;
		public var adjustCamera:Vector3D = new Vector3D;
		
		//private var dw:int=1232;
		//TO DO stupid floating numbers sine and cosine are messed up in action script 3, or to be exact:  "Stupid me." :-), So I need to set the values manually
		//instead of sine and cosine of an angle
		private var dy:int=616;//instead of math.round( 1024* math.sin( main.camera.rotationX))
		private var dz:int=818;
		
		private var dim:Vector3D = new Vector3D(1024,616,818);
		
		public var say: Number = 0.60181502315204827991797700044149;//sine angle for y
		public var caz: Number = 0.79863551004729284628400080406894;//cosine angle for z
		
		public function Map3d()
		{
			super();
		}
		
		public function setMapPlanes(): void
		{
			//set the planes images
			var rows:*=0;
			var columns:*;
			var increment:*=0;
			while (rows < 4) 
			{
				columns = 0;
				while (columns < 4) 
				{
					var bitmap:Bitmap = Main.currentMapImagesArray[increment] as Bitmap;
					var bitmapData:BitmapData = bitmap.bitmapData;
					var tile:Mesh = new Mesh(new PlaneGeometry(bitmap.width,bitmap.height), new TextureMaterial(new BitmapTexture(bitmapData)));
					tile.name = "m" + String(rows) + String(columns);
					
					tile.x = - columns * bitmap.width;
					tile.y = - rows * dy;
					tile.z = rows * dz;

					tile.rotation = new Vector3D(-Main.away3dView.camera.rotationX,-Main.away3dView.camera.rotationY,-Main.away3dView.camera.rotationZ);
					
					Main.mapTiles.addChild(tile);
					++columns;
					++increment;
				}
				++rows;
			}
			
			//set the planes  path
			rows=0;
			increment=0;
			while (rows < 4) 
			{
				columns = 0;
				while (columns < 4) 
				{
					bitmap = Main.currentMapPathImagesArray[increment] as Bitmap;
					bitmapData = bitmap.bitmapData;
					var bitmapTexture:BitmapTexture = new BitmapTexture(bitmapData);
					var material:TextureMaterial = new TextureMaterial(bitmapTexture);
					material.alphaBlending = true;
					tile = new Mesh(new PlaneGeometry(bitmap.width,bitmap.height), material );
					tile.name = "p" + String(rows) + String(columns);
					//tile.showBounds = true;
					tile.x = - columns * bitmap.width;
					tile.y = - rows * dy;
					tile.z = rows * dz;
					
					tile.rotation = new Vector3D(-Main.away3dView.camera.rotationX,-Main.away3dView.camera.rotationY,-Main.away3dView.camera.rotationZ);
					
					Main.mapTilesPath.addChild(tile);
					++columns;
					++increment;
				}
				++rows;
			}
			
			//TO DO ADJUST POSITION BASED ON CAMERA ADJUSTMENT
			Main.mapTiles.position = new Vector3D(-512,-512-(3*Main.cellSize),0);
			Main.mapTilesPath.position = new Vector3D(-512,-512-(3*Main.cellSize),-1);
			
			Main.away3dView.scene.addChild(Main.mapTiles);
			Main.away3dView.scene.addChild(Main.mapTilesPath);
			Main.pathTilesListeners();
		}

		public function getWalkable(astar: Array, start: Cell, end: Cell): Array
		{
			var ray:Ray = new Ray;
			for (var i:int=0;i<astar.length;i++)
			{
				var cell: Cell = astar[i];

				//create  the corner vectors of the plane, this plane is the image for the path
				var lt:Vector3D = new Vector3D;
				var rb:Vector3D = new Vector3D;
				var lb:Vector3D = new Vector3D;
				var rt:Vector3D = new Vector3D;
				
				//this is temporary needed to hold the plane to get the material later on
				var planes: Array = new Array;
				//trace( "coordinates",cell.x,cell.y, "grid",cell.gridC,cell.gridR);
				
				//check to see which planes is the cell supposed to intersect/be part of
				//if found, then set its vector corners for future triangulation
				for(var j:int=0;j<Main.mapTilesPath.numChildren;j++)
				{
					if(Math.abs(cell.x) > Math.abs((Main.mapTilesPath.getChildAt(j) as Mesh).position.x) && 
						Math.abs(cell.x) < Math.abs((Main.mapTilesPath.getChildAt(j) as Mesh).position.x) + dim.x &&
						Math.abs(cell.y) > Math.abs((Main.mapTilesPath.getChildAt(j) as Mesh).position.y) && 
						Math.abs(cell.y) < Math.abs((Main.mapTilesPath.getChildAt(j) as Mesh).position.y) + dim.y &&
						Math.abs(cell.z) > Math.abs((Main.mapTilesPath.getChildAt(j) as Mesh).position.z) && 
						Math.abs(cell.z) < Math.abs((Main.mapTilesPath.getChildAt(j) as Mesh).position.z) + dim.z)
					{
						//if((Main.mapTilesPath.getChildAt(j) as Mesh).name)	 trace( "intersecting",(Main.mapTilesPath.getChildAt(j) as Mesh).name);
						lt = (Main.mapTilesPath.getChildAt(j) as Mesh).position;
						rb = (Main.mapTilesPath.getChildAt(j) as Mesh).position.add(new Vector3D(-dim.x,-dim.y,dim.z));
						lb = (Main.mapTilesPath.getChildAt(j) as Mesh).position.add(new Vector3D(0,-dim.y,dim.z));
						rt = (Main.mapTilesPath.getChildAt(j) as Mesh).position.add(new Vector3D(-dim.x,0,0));
						//if a plane is found. Keep a future reference to get the material later on
						planes.push((Main.mapTilesPath.getChildAt(j) as Mesh));
					}
				}
				//this is the destination vector when checking the ray intersection, it's a simple line on the Z axis starting from the  cell position
				var dest: Vector3D = cell.position.add(new Vector3D(0,0,Main.cellSize));

				/*//draw some lines for visual representation of the  rays, not needed in final production
				//be advised that the calculations for path and the lines have a Delta, which is the camera position
				//this means that calculations for path are relative to the absolute position  of the cells and meshes
				//the lines are displayed relative to the camera, so they appear to be "under" the actual cells
				var line:LineSegment = new LineSegment(cell.position.subtract(adjustCamera),dest.subtract(adjustCamera),0x00ffff,0x0000ff);
				var lineSet:SegmentSet = new SegmentSet();
				lineSet.addSegment(line);
				Main.away3dView.scene.addChild(lineSet);*/

				//because we have to check the intersection with a plane, we first split the plane into 2 triangles, if all goes well then either there is no intersection,  or at most there is only one
				var intersectL:Vector3D = ray.getRayToTriangleIntersection(cell.position, dest, lt, lb, rb);
				var intersectR:Vector3D = ray.getRayToTriangleIntersection(cell.position, dest, lt, rt, rb);
				var intersect: Vector3D = new Vector3D;
				if(intersectL != null)		
				{
					intersect = intersectL;
					//trace("LEFT intersect ray: "+intersectL);
				}
				if(intersectR != null)		
				{
					intersect = intersectR;
					//trace("RIGHT intersect ray: "+intersectR);
				}
				
				//here, if an intersecting plane is found, we actually take the image path and evaluate the value of the pixel where the cell intersects
				//if the value is zero, then the intersection was with a transparent pixel, otherwise it should be GREEN
				if(planes.length > 0)
				{
					var material:TextureMaterial = ((planes[0] as Mesh).material as TextureMaterial);
					var texture:BitmapTexture = material.texture as BitmapTexture;
					var bitmapData:BitmapData = texture.bitmapData;
					
					//we need to convert global to local and 3-D to 2-D coordinates, and remember the camera Delta. :-)
					var local:Vector3D = lt.subtract(intersect);
					var _x:int = local.x;
					var _y:int = -local.z/caz + Math.round(adjustCamera.y/say);
					
					//If the pixel is GREEN, this means the cell should be made walkable as  it's on  "path"
					if(bitmapData.getPixel(_x,_y).toString(16) == "ff00")
					{
						cell.isWalkable = true;
						astar[i] = cell;
						//trace((astar[i] as Cell).isWalkable,bitmapData.getPixel(_x,_y).toString(16),_x,_y,Math.round(adjustCamera.y/say));
					}
				}
			}
			
			//maybe not needed, trying to implement steering
			/*//double check to make sure GREEN  cells are not obstructed by  NPCs
			for(i=0;i<astar.length;i++)
			{
				for each( var character:Character in Main.MAP.allCharacters)
				{
					if(Main.MAP3D.zeroVector.equals(astar[i].position.subtract(character.routeVector)))
					{
						//trace( "found cell on the character", character.characterName);
						astar[i].isWalkable = false;
						if((astar[i].gridC == start.gridC && astar[i].gridR == start.gridR) || (astar[i].gridC == end.gridC && astar[i].gridR == end.gridR))
						{
							//trace( "cell matches start or end",astar[i].gridC,astar[i].gridR, start.gridC, start.gridR,end.gridC,end.gridR);
							astar[i].isWalkable = true;
						}
					}
				}
			}*/
			
			return astar;
		}
		
		public function shortcutter(vectors: Array): Boolean
		{
			var ray:Ray = new Ray;
			for (var i:int=0;i<vectors.length;i++)
			{
				var vector: Vector3D = vectors[i];
				
				//create  the corner vectors of the plane, this plane is the image for the path
				var lt:Vector3D = new Vector3D;
				var rb:Vector3D = new Vector3D;
				var lb:Vector3D = new Vector3D;
				var rt:Vector3D = new Vector3D;
				
				//this is temporary needed to hold the plane to get the material later on
				var planes: Array = new Array;
				//trace( "coordinates",vector.x,vector.y, "grid",vector.gridC,vector.gridR);
				
				//check to see which planes is the vector supposed to intersect/be part of
				//if found, then set its vector corners for future triangulation
				for(var j:int=0;j<Main.mapTilesPath.numChildren;j++)
				{
					if(Math.abs(vector.x) > Math.abs((Main.mapTilesPath.getChildAt(j) as Mesh).position.x) && 
						Math.abs(vector.x) < Math.abs((Main.mapTilesPath.getChildAt(j) as Mesh).position.x) + dim.x &&
						Math.abs(vector.y) > Math.abs((Main.mapTilesPath.getChildAt(j) as Mesh).position.y) && 
						Math.abs(vector.y) < Math.abs((Main.mapTilesPath.getChildAt(j) as Mesh).position.y) + dim.y &&
						Math.abs(vector.z) > Math.abs((Main.mapTilesPath.getChildAt(j) as Mesh).position.z) && 
						Math.abs(vector.z) < Math.abs((Main.mapTilesPath.getChildAt(j) as Mesh).position.z) + dim.z)
					{
						//if((Main.mapTilesPath.getChildAt(j) as Mesh).name)	 trace( "intersecting",(Main.mapTilesPath.getChildAt(j) as Mesh).name);
						lt = (Main.mapTilesPath.getChildAt(j) as Mesh).position;
						rb = (Main.mapTilesPath.getChildAt(j) as Mesh).position.add(new Vector3D(-dim.x,-dim.y,dim.z));
						lb = (Main.mapTilesPath.getChildAt(j) as Mesh).position.add(new Vector3D(0,-dim.y,dim.z));
						rt = (Main.mapTilesPath.getChildAt(j) as Mesh).position.add(new Vector3D(-dim.x,0,0));
						//if a plane is found. Keep a future reference to get the material later on
						planes.push((Main.mapTilesPath.getChildAt(j) as Mesh));
					}
				}
				//this is the destination vector when checking the ray intersection, it's a simple line on the Z axis starting from the  vector position
				var dest: Vector3D = vector.add(new Vector3D(0,0,Main.cellSize));
				
				/*//draw some lines for visual representation of the  rays, not needed in final production
				//be advised that the calculations for path and the lines have a Delta, which is the camera position
				//this means that calculations for path are relative to the absolute position  of the vectors and meshes
				//the lines are displayed relative to the camera, so they appear to be "under" the actual vectors
				var line:LineSegment = new LineSegment(vector.subtract(adjustCamera),dest.subtract(adjustCamera),0x00ffff,0x0000ff);
				var lineSet:SegmentSet = new SegmentSet();
				lineSet.addSegment(line);
				Main.away3dView.scene.addChild(lineSet);*/
				
				//because we have to check the intersection with a plane, we first split the plane into 2 triangles, if all goes well then either there is no intersection,  or at most there is only one
				var intersectL:Vector3D = ray.getRayToTriangleIntersection(vector, dest, lt, lb, rb);
				var intersectR:Vector3D = ray.getRayToTriangleIntersection(vector, dest, lt, rt, rb);
				var intersect: Vector3D = new Vector3D;
				if(intersectL != null)		
				{
					intersect = intersectL;
					//trace("LEFT intersect ray: "+intersectL);
				}
				if(intersectR != null)		
				{
					intersect = intersectR;
					//trace("RIGHT intersect ray: "+intersectR);
				}
				
				//here, if an intersecting plane is found, we actually take the image path and evaluate the value of the pixel where the vector intersects
				//if the value is zero, then the intersection was with a transparent pixel, otherwise it should be GREEN
				if(planes.length > 0)
				{
					var material:TextureMaterial = ((planes[0] as Mesh).material as TextureMaterial);
					var texture:BitmapTexture = material.texture as BitmapTexture;
					var bitmapData:BitmapData = texture.bitmapData;
					
					//we need to convert global to local and 3-D to 2-D coordinates, and remember the camera Delta. :-)
					var local:Vector3D = lt.subtract(intersect);
					var _x:int = local.x;
					var _y:int = -local.z/caz + Math.round(adjustCamera.y/say);
					
					//If the pixel is GREEN, this means the vector should be made walkable as  it's on  "path"
					if(bitmapData.getPixel(_x,_y).toString(16) != "ff00")
					{
						trace( "invalid shortcutter!");
						return false;
						/*vector.isWalkable = true;
						vectors[i] = vector;
						//trace((vectors[i]).isWalkable,bitmapData.getPixel(_x,_y).toString(16),_x,_y,Math.round(adjustCamera.y/say));*/
					}
				}
			}
			return true;
		}
		
		public function showPath(array: Array): void
		{
			var plane:Mesh = new Mesh(new PlaneGeometry(Main.cellSize,Main.cellSize), new ColorMaterial(0xFF0000));
			var path:Mesh = new Mesh(new PlaneGeometry(0,0));
			path.name = "path";
			
			for each(var cell:Cell in array)
			{
					var clone: Mesh = new Mesh(plane.geometry.clone(), plane.material);
					clone.position = cell.position.subtract(new Vector3D(0,dy/2-Main.cellSize/4,dz/2-Main.cellSize/4));
					clone.rotation = cell.rotation;
					path.addChild(clone);
			}
			path.position = path.position.subtract(adjustCamera);
			Main.away3dView.scene.addChild(path);
		}
		
		public function removePath(): void
		{
			for(var i:int=0;i<Main.away3dView.scene.numChildren;i++)
			{
				var child:* = Main.away3dView.scene.getChildAt(i);
				if(child.name && child.name == "path")
					Main.away3dView.scene.removeChild(child);
			}
		}

		private function hillClimbing( pathCells: Array): Array
		{
			var pathVectors: Array = new Array;
			for(var k:int=0;k<pathCells.length;k++)
			{
				pathVectors.push(pathCells[k].position);
			}
			trace( "path length before", pathVectors.length);
			
			var linear_segment: Array = new Array;
			var MAX_TIMESTEPS:int = 25;
			// Shortcut the pathVectors until a max number of timesteps is reached
			for (var t:int=0;t<MAX_TIMESTEPS;t++)
			{
				var shortcut: Array = new Array;
				
				// Get two random pathVectors indices to shortcut between, so ignore 0 and pathVectors.length-1,
				var i:int = int(Main.STATES.randomNumber(0, pathVectors.length-2));
				var j:int = int(Main.STATES.randomNumber(i+1, pathVectors.length-1));
				// Create a straight line between the two pathVectors points
				if(pathVectors[i] != null && pathVectors[j] != null) 
				{
					//trace( "selected cell",i,pathVectors[i], "AND",j,pathVectors[j]);
					linear_segment = InterpolateLine(pathVectors[i], pathVectors[j]);
				}
				//else	trace( "a cell is empty",i,j,pathVectors[i],pathVectors[j]);
				
				// The new pathVectors is one that is the same up to index i, then linear, 
				// then the rest of the pathVectors
				//shortcut = [pathVectors(1 : i), linear_segment, pathVectors(j : pathVectors.length())];
				//if linear segments returned is not null, then we can create a shortcut using it
				if(linear_segment != null)
				{
					//trace("linear_segment length", linear_segment.length);
					for(k=0;k<i;k++)
					{
						shortcut.push(pathVectors[k]);
					}
					shortcut = shortcut.concat(linear_segment);
					/*//add the first and the last vector from the linear segment
					 shortcut.push(linear_segment[0]);
					 shortcut.push(linear_segment[linear_segment.length-1]);*/
					 for(k=j+1;k<pathVectors.length;k++)
					 {
						 shortcut.push(pathVectors[k]);
					 }
					 
					 //set the updated path  as the shortcut
					 //trace( "after iteration",t, "The path length is", shortcut.length);
					 pathVectors = shortcut;
				}
					
				// Check the linear segment to see if it goes outside of the green region.
				// If it does, continue shortcutting. Otherwise, modify the pathVectors to contain
				// the new segment
					//if (!CollisionCheck(linear_segment))
						//pathVectors = shortcut;
			}
			
			/*// Returns whether any point in a pathVectors is invalid
			function bool CollisionCheck(Path pathVectors):
			foreach node in pathVectors:
			if (!IsWalkable(node)) return false;
			return true;*/
			
			// Creates a straight line between the start and the end with a given step size
			function InterpolateLine(start:Vector3D, end:Vector3D, step:int = 16): Array
			{
				var toReturn: Array = new Array;
				var dir: Vector3D = end.subtract(start);
				var ratio: Vector3D = new Vector3D;
				var _length:Number = dir.length;
				//trace("dir length",dir.length);
				// Just step along a line from the start to the end.
				var max: Number = Math.max(Math.abs(end.x - start.x),Math.abs(end.y - start.y),Math.abs(end.z - start.z));
				
				if(ratio.x == 0 && ratio.y == 0 && ratio.z == 0)
				{
					ratio.x = (end.x - start.x)/max;
					ratio.y = (end.y - start.y)/max;
					ratio.z = (end.z - start.z)/max;
				}
				
				for (var dPath: Number = 0; dPath < _length; dPath += step)
				{
					var result: Vector3D = start.add(new Vector3D(dPath*ratio.x,dPath*ratio.y,dPath*ratio.z));
					//trace( "resulting step", result);
					toReturn.push(result);
				}

				//check to see if the  vectors generated are completely on path or not
				if( shortcutter(toReturn))
				{
					//trace( "the return length",toReturn.length);
					return toReturn;
				}
				else
				{
					trace( "shortcutter not valid");
					return null;
				}
			}
			// When we're done shortcutting, the new path is returned. ideally it would never have less than 4 vectors
			//trace( "updated path contains", pathVectors.length, "vectors for nurbs");
			return pathVectors;
		}
		
		public function nurbsCurve(pathCells: Array): void
		{
			//before nurbs,  do a stochastic hillclimbing
			var pathVectors: Array = new Array; 
			pathVectors = hillClimbing(pathCells);
			/*for(var k:int=0;k<pathCells.length;k++)
			{
				pathVectors.push(pathCells[k].position);
			}*/
			trace( "hillclimbing done",pathVectors.length);
			
			var i:int;//set it here to be used later in for loops
			var controlPoints:Vector.<Vector3D> = new Vector.<Vector3D>();
			//evaluate all  cell position in the array path
			for(i=0;i<pathVectors.length;i++)
			{
				var vector:Vector3D = pathVectors[i];
				controlPoints.push(vector);
			}
			
			/*//set only few control points
			controlPoints.push(pathVectors[0]);
			controlPoints.push(pathVectors[int(Math.floor(pathVectors.length/3))]);
			controlPoints.push(pathVectors[int(Math.floor(pathVectors.length/3))*2]);
			controlPoints.push(pathVectors[pathVectors.length-1]);
			trace( "control points length", controlPoints.length);*/
			/*for(i=0;i<controlPoints.length;i++)
				trace(controlPoints[i]);*/
			
			var result:Vector.<Vector3D> = new Vector.<Vector3D>();
			var increment: Number = 0;
			while (increment <= 1)
			{
				var out:Vector3D = new Vector3D;
				out = Nurbs.nurbs(increment,controlPoints);//use only with 4 or more control points
				//out = Nurbs.nurbs(increment,controlPoints,2,1);//use only with 3 or less control points
				result.push(out);
				increment+=0.002;
			}
			
			trace( "number of nurbs", result.length);//statically 500 due to increment value
			
			for(i=0;i<result.length;i++)
			{
				var l:Vector3D = result[i].subtract(Main.MAP3D.adjustCamera);
				var line:LineSegment = new LineSegment(l,l.subtract(new Vector3D(0,0,32)),0x00ffff,0x0000ff);
				var lineSet:SegmentSet = new SegmentSet();
				lineSet.addSegment(line);
				Main.away3dView.scene.addChild(lineSet);
				//trace( "results", result[i], result.length);
			}
		}

		public function adjust( string: String):int
		{
			switch( string)
			{
				case "f"://if female humanoid
				{
					return 64;
				}
				case "m"://if male humanoid
				{
					return 72;
				}
			}
			return 0;
		}
	}
}