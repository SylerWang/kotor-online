package
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.PerspectiveProjection;
    import flash.geom.Point;
    
    public class IntroCrawlText extends Sprite
    {
		[Embed(source="embeds/SpriteIntroCrawl.png")]
		private var Picture:Class;

		private var _output:Bitmap;
        private var _primitive:Sprite;
        
        public function IntroCrawlText()
        {
            addEventListener(Event.ADDED_TO_STAGE, init);
        }
		
        private function init(evt:Event = null):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, init);
            
            var pp:PerspectiveProjection = this.parent.transform.perspectiveProjection;
            pp.projectionCenter = new Point(stage.stageWidth/2, 0);
            
            _primitive = addChild(new Sprite()) as Sprite;
			
			var pic:Bitmap = new Picture();
			var picData:BitmapData = pic.bitmapData;
			var _scale: Number =  stage.stageWidth / pic.height;
			_output = new Bitmap(picData);
			_output.width = stage.stageWidth*0.5625;
			_output.height = stage.stageWidth;
			_primitive.addChild(_output);
            
			_primitive.rotationX = -90;
			var _shift:int;
			if (Math.abs(stage.stageWidth - 1280) < 100)	_shift = 45;
			else if (Math.abs(stage.stageWidth - 1600) < 100)	_shift = 25;
            _primitive.x = Math.sqrt(stage.stageWidth)*10*_scale+_shift;
			_primitive.y = stage.stageHeight/2;
            _primitive.z = -Math.sqrt(stage.stageHeight)*10;
            _primitive.mouseEnabled = _primitive.mouseChildren = false;
            
            onChange();
            
            addEventListener(Event.ENTER_FRAME, onEnter);
        }
        
		private function onChange(evt:Event=null):void
        {
			_output.smoothing = true;
            _primitive.z = -Math.sqrt(stage.stageHeight)*10;
        }
        
        private function onEnter(evt:Event):void
        {
			if(Main.introState)
			{
				if(Main.INTRO._timer == 92)		 this.alpha = this.alpha*0.95;
				if(Main.INTRO._timer == 94)		 this.alpha = 0;
				if( this.alpha <= 0.05)	removeEventListener(Event.ENTER_FRAME, onEnter);
				if (Math.abs(stage.stageWidth - 1280) < 100)	_primitive.z += 0.45;
				else if (Math.abs(stage.stageWidth - 1600) < 100)	_primitive.z += 0.5;
				else if (Math.abs(stage.stageWidth - 1920) < 100)	_primitive.z += 0.55;
			}
			else	removeEventListener(Event.ENTER_FRAME, onEnter);
        }
    }
}