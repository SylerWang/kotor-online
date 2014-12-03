package packages.map
{
	import away3d.entities.Mesh;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.textures.BitmapTexture;
	import away3d.utils.Cast;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Vector3D;

	public class Map3d extends Object
	{
		public var zeroVector:Vector3D = new Vector3D;
		
		private var dw:int=1232;
		//TO DO stupid floating numbers sine and cosine are messed up in action script 3, or to be exact:  "Stupid me." :-), So I need to set the values manually
		//instead of sine and cosine of an angle
		private var dy:int=616;//instead of math.round( 1024* math.sin( main.camera.rotationX))
		private var dz:int=818;
		
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
					tile.name = String(rows) + String(columns);
					
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
					tile.name = String(rows) + String(columns);
					
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
			
			Main.warp = dw/1024;
			Main.mapTiles.position = new Vector3D(-512,-512-(3*Main.cellSize),0);//don't know why I need 3 cell size Delta
			Main.mapTilesPath.position = new Vector3D(-512,-512-(3*Main.cellSize),-1);
			
			Main.away3dView.scene.addChild(Main.mapTiles);
			Main.away3dView.scene.addChild(Main.mapTilesPath);
			Main.pathTilesListeners();
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