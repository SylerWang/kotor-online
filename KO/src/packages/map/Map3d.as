package packages.map
{
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.textures.BitmapTexture;
	import away3d.tools.utils.Ray;
	import away3d.utils.Cast;
	
	import com.rocketmandevelopment.grid.Cell;
	import com.rocketmandevelopment.grid.Grid;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Vector3D;

	public class Map3d extends Object
	{
		public var zeroVector:Vector3D = new Vector3D;
		public var adjustCamera:Vector3D = new Vector3D;
		
		private var dw:int=1232;
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
			Main.mapTilesPath.position = new Vector3D(-512,-512-(3*Main.cellSize),1);
			
			Main.away3dView.scene.addChild(Main.mapTiles);
			Main.away3dView.scene.addChild(Main.mapTilesPath);
			Main.pathTilesListeners();
		}

		public function getWalkable(astar: Array): Array
		{
			/*
			LT	Vector3D(0, -1232, 1636)
			LB	Vector3D(0, -1848, 2454)
			RB	Vector3D(-1024, -1848, 2454)
			
			LT	Vector3D(0, -1232, 1636)
			RT	Vector3D(-1024, -1232, 1636)
			RB	Vector3D(-1024, -1848, 2454)
			*/
			var ray:Ray = new Ray();
			for (var i:int=0;i<astar.length;i++)
			{
				var cell: Cell = astar[i];
				var source: Vector3D = cell.position.subtract(new Vector3D(0,dy/2-Main.cellSize/4,dz/2-Main.cellSize/4));
				for(var j:int=0;j<Main.mapTilesPath.numChildren;j++)
				{
					if(Math.abs(source.x) > Math.abs((Main.mapTilesPath.getChildAt(j) as Mesh).position.x) && 
						Math.abs(source.x) < Math.abs((Main.mapTilesPath.getChildAt(j) as Mesh).position.x) + dim.x &&
						Math.abs(source.y) > Math.abs((Main.mapTilesPath.getChildAt(j) as Mesh).position.y) && 
						Math.abs(source.y) < Math.abs((Main.mapTilesPath.getChildAt(j) as Mesh).position.y) + dim.y &&
						Math.abs(source.z) > Math.abs((Main.mapTilesPath.getChildAt(j) as Mesh).position.z) && 
						Math.abs(source.z) < Math.abs((Main.mapTilesPath.getChildAt(j) as Mesh).position.z) + dim.z)
					{
						if((Main.mapTilesPath.getChildAt(j) as Mesh).name)	 trace( "intersecting",(Main.mapTilesPath.getChildAt(j) as Mesh).name);
					}
				}
				var v0:Vector3D = source.add(new Vector3D(-200, 100, 60));
				var v1:Vector3D = source.add(new Vector3D(200, 100, 60));
				var v2:Vector3D = source.add(new Vector3D(-100, -200, 60));
				var dest: Vector3D = source.add(new Vector3D(0, 32, 0));
				var intersect:Vector3D = ray.getRayToTriangleIntersection(source, dest, v0, v1, v2 );
				trace("intersect ray: "+intersect);
			}
			return astar;
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
					trace(clone.position);
					path.addChild(clone);
			}
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