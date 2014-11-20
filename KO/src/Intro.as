package
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import packages.audio.GameMusic;
	
    public class Intro
    {
		public var intro: Boolean = false;
		public var _timer:int;
		private var minuteTimer:Timer = new Timer(1000, 126); 
		
		public function Intro()
        {
            trace(" Intro");
        }
		
		public function skipIntro(): void
		{
			minuteTimer.removeEventListener(TimerEvent.TIMER, onTick);
			minuteTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete); 
			removeCrawl();
			characterCreation();
		}
		
		public function removeCrawl(): void
		{
			if(Main.MAIN.getChildByName("Crawl"))	Main.MAIN.removeChild(Main.MAIN.getChildByName("Crawl"));
			//trace( "Crawl removed");
		}
		
		public function characterCreation(): void
		{
			Main.STATES.handleStates("characterCreationState");
		}
		
		public function ShortTimer(): void  
		{ 
			minuteTimer.addEventListener(TimerEvent.TIMER, onTick);
			minuteTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete); 
			minuteTimer.start(); 
		} 
		
		public function onTick(event:TimerEvent):void  
		{ 
			_timer = event.target.currentCount;
			if(_timer == 7)		  var setMusic:* = new GameMusic("INTROMUSIC", true);
			if(_timer == 11 && Math.abs(Main.APP_WIDTH - 1280) < 100)	 addCrawl();
			else if(_timer == 10 && Math.abs(Main.APP_WIDTH - 1600) < 100 || _timer == 10 && Math.abs(Main.APP_WIDTH - 1920) < 100)	 addCrawl();
		}
		
		public function onTimerComplete(event:TimerEvent):void 
		{ 
			removeCrawl();
			//renderGame();
			characterCreation();
		} 
		
		public function addCrawl(): void
		{
			var _introCrawl:*= new IntroCrawlText;
			_introCrawl.name = "Crawl";
			Main.MAIN.addChild(_introCrawl);
		}
	}
}