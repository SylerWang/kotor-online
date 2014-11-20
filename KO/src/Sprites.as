package
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	
	public class Sprites extends Sprite
	{
		public function Sprites()
		{
			super();
		}
		
		public function getGlobalToLocal(_x:Number,_y:Number):Point
		{
			var p: Point = globalToLocal(new Point(_x,_y));
			return p;
		}
		
		public function getLocalToGlobal(_x:Number,_y:Number):Point
		{
			var p: Point = localToGlobal(new Point(_x,_y));
			return p;
		}
		
		public function copyAsBitmapData(sprite:DisplayObject):BitmapData
		{
			
			if ( sprite == null) {
				return null;
			}
			
			var resultRect:Rectangle = new Rectangle();
			sprite.getBounds(sprite, resultRect);
			
			var context:Context3D = Starling.context;
			var scale:Number = Starling.contentScaleFactor;
			
			var nativeWidth:Number = Starling.current.stage.stageWidth;
			var nativeHeight:Number = Starling.current.stage.stageHeight;
			
			var support:RenderSupport = new RenderSupport();
			RenderSupport.clear();
			support.setOrthographicProjection(0,0,nativeWidth, nativeHeight);
			support.applyBlendMode(true);
			
			if (sprite.parent){
				support.transformMatrix(sprite.parent);
			}
			
			support.translateMatrix( -sprite.x + sprite.width / 2, -sprite.y + sprite.height / 2 );
			
			var result:BitmapData = new BitmapData(nativeWidth, nativeHeight, true, 0x00000000);
			
			support.pushMatrix();
			
			support.blendMode = sprite.blendMode;
			support.transformMatrix(sprite);
			sprite.render(support, 1.0);
			support.popMatrix();
			
			support.finishQuadBatch();
			
			context.drawToBitmapData(result);  
			
			var w:Number = sprite.width;
			var h:Number = sprite.height;
			
			if (w == 0 || h == 0) {
				return null;
			}
			
			var returnBMPD:BitmapData = new BitmapData(w, h, true, 0);
			var cropArea:Rectangle = new Rectangle(0, 0, sprite.width, sprite.height);
			
			returnBMPD.draw( result, null, null, null, cropArea, true );
			return returnBMPD;
		}
	}
}