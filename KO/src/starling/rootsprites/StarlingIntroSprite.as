package starling.rootsprites
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.*;
	import starling.text.TextField;
	import starling.textures.Texture;

	public class StarlingIntroSprite extends Sprite
	{
		private var _localTimerStarted: Boolean= false;
		private static var _instance : StarlingIntroSprite;
		private var _IntroVenatorImage:Image = new Image(Assets.getAtlas("VENATOR").getTexture("IntroVenator"));
		private var _IntroLongTimeImage:Image = new Image(Assets.getAtlas("INTROLONGTIME").getTexture("IntroLongTime"));
		private var _IntroStarsImage:Image = new Image(Assets.getAtlas("INTROSTARS").getTexture("IntroStars"));
		private var _IntroSWLogoImage:Image = new Image(Assets.getAtlas("INTROSWLOGO").getTexture("IntroSWLogo"));
		
		public static function getInstance():StarlingIntroSprite
		{
			return _instance;
		}
		
		/**
		 * Constructor.
		 */
		public function StarlingIntroSprite()
		{
			_instance = this;
			//we'll initialize things after we've been added to the stage
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		/**
		 * Where the magic happens. Start after the main class has been added
		 * to the stage so that we can access the stage property.
		 */
		protected function addedToStageHandler(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			initialize();
		}
		
		protected function onFrame( event: Event): void
		{
			if(Main.INTRO._timer >= 5)
			{
				_IntroLongTimeImage.alpha = _IntroLongTimeImage.alpha*0.85;
			}
			if(Main.INTRO._timer == 6 && !_localTimerStarted)
			{
				_localTimerStarted = true;
				ShortTimer();
				_IntroLongTimeImage.visible = false;
			}
			if(Main.INTRO._timer >= 7) 
			{
				_IntroSWLogoImage.scaleX = _IntroSWLogoImage.scaleX*0.9935;
				_IntroSWLogoImage.x = Main.APP_WIDTH/2 -_IntroSWLogoImage.width/2;
				_IntroSWLogoImage.scaleY = _IntroSWLogoImage.scaleY*0.9935;
				_IntroSWLogoImage.y = Main.APP_HEIGHT/2 -_IntroSWLogoImage.height/2;
			}
			if(Main.INTRO._timer >= 15)
			{
				_IntroSWLogoImage.alpha = _IntroSWLogoImage.alpha*0.85;
			}
			if(Main.INTRO._timer >= 93) 
			{
				_IntroVenatorImage.scaleX = _IntroVenatorImage.scaleX*0.9997;
				_IntroVenatorImage.x = Main.APP_WIDTH/2 -_IntroVenatorImage.width/2;
				_IntroVenatorImage.scaleY = _IntroVenatorImage.scaleY*0.9997;
				if (Math.abs(stage.stageWidth - 1280) < 100 || Math.abs(stage.stageWidth - 1600) < 100)	_IntroVenatorImage.y += 0.3;
				else if (Math.abs(stage.stageWidth - 1920) < 100)	_IntroVenatorImage.y += 0.4;
			}
			if(Main.INTRO._timer >= 125)
			{
				_IntroVenatorImage.alpha = _IntroVenatorImage.alpha*0.94;
				_IntroStarsImage.alpha = _IntroStarsImage.alpha*0.95;
			}
		}
		
		public function ShortTimer(): void  
		{ 
			var minuteTimer:Timer = new Timer(1000, 120); 
			
			minuteTimer.addEventListener(TimerEvent.TIMER, onTick); 
			//minuteTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete); 
			
			minuteTimer.start(); 
		} 
		
		public function onTick(event:TimerEvent):void  
		{ 
			if(Main.INTRO._timer == 7) 
			{
				_IntroStarsImage.visible = true;
				_IntroSWLogoImage.visible = true;
				_IntroSWLogoImage.scaleX = _IntroSWLogoImage.scaleX*1.5;
				_IntroSWLogoImage.scaleY = _IntroSWLogoImage.scaleY*1.5;
			}
			if(Main.INTRO._timer == 18)
			{
				_IntroSWLogoImage.visible = false;
			}
			if(Main.INTRO._timer == 93)
			{
				_IntroVenatorImage.visible = true;
				var _shift:Number=0.01;
				_IntroVenatorImage.y = -_IntroVenatorImage.height+_shift;
			}
			if (Main.INTRO._timer >= 126)	removeEventListener( Event.ENTER_FRAME, onFrame);
		} 
		
		/*public function onTimerComplete(event:TimerEvent):void 
		{ 
			//trace(" Starling Intro Sprite Time's Up!",Main.INTRO._timer); 
		} */
		
		public function initialize(): void
		{
			 trace("Starling Intro initialize");
			 _IntroLongTimeImage.scaleX = Main.APP_WIDTH/_IntroLongTimeImage.width;
			 _IntroLongTimeImage.scaleY = Main.APP_HEIGHT/_IntroLongTimeImage.height;
			 addChild(_IntroLongTimeImage);
			 _IntroStarsImage.scaleX = Main.APP_WIDTH/_IntroStarsImage.width;
			 _IntroStarsImage.scaleY = Main.APP_HEIGHT/_IntroStarsImage.height;
			 _IntroStarsImage.visible= false;
			 addChild(_IntroStarsImage);
			 _IntroSWLogoImage.scaleX = Main.APP_WIDTH/_IntroSWLogoImage.width;
			 _IntroSWLogoImage.scaleY = Main.APP_HEIGHT/_IntroSWLogoImage.height;
			 _IntroSWLogoImage.visible= false;
			 addChild(_IntroSWLogoImage);
			 _IntroVenatorImage.scaleX = Main.APP_WIDTH/_IntroVenatorImage.width;
			 _IntroVenatorImage.scaleY = Main.APP_HEIGHT/_IntroVenatorImage.height;
			 _IntroVenatorImage.visible= false;
			 addChild(_IntroVenatorImage);
		}
	}
}