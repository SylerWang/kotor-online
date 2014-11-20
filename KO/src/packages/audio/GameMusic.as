package packages.audio
{
    import flash.events.*;
    import flash.media.*;
    import flash.utils.*;
    
    public class GameMusic extends Object
    {
		public const fade_in_time:int=1000;
		public const fade_out_time:int=500;
		public const sound_fade_steps:int=25;
		public static const MUSIC_VOLUME_SCALER:Number=0.7;
		protected var fadeStepCount:int=0;
		protected var channel:SoundChannel;
		public var active:Boolean=false;
		protected var context:String;
		private var fadeInTimer:Timer;
		private var fadeOutTimer:Timer;
		public static var current:GameMusic;

        public function GameMusic(name:String="SILENTMUSIC",arg2:Boolean=true)
		{
			 var music:Sound = Assets.getMusic(name);
			 channel = music.play(0, 999999999);
			 if (channel == null) 
			 {
				 return;
			 }
			 active = true;
			 fadeIn();
			 /*if (arg2) 
			 {
				 fadeIn();
			 }
			 else 
			 {
				 setVolume(Options.current.volumeMusic);
			 }*/
			 setVolume(MUSIC_VOLUME_SCALER);
			 if (current != null) 
			 {
				 current.fadeOut();
			 }
			 context = name;
			 current = this;
			 return;
		}
		
		public function get Context():String
		{
			return context;
		}
		
		public function setVolume(arg1:Number):void
		{
			if (channel == null) 
			{
				return;
			}
			arg1 = Math.max(0, arg1);
			//arg1 = Math.min(Options.current.volumeMusic, arg1);
			channel.soundTransform = new SoundTransform(arg1 * MUSIC_VOLUME_SCALER);
			return;
		}

		public function mute():void
		{
			setVolume(0);
			return;
		}
		
		public function stop():void
		{
			if (channel != null) 
			{
				channel.stop();
			}
			if (current == this) 
			{
				current = null;
			}
			active = false;
			return;
		}
		
		public function fadeIn(arg1:int=1000):void
		{
			if (channel == null) 
			{
				return;
			}
			channel.soundTransform = new SoundTransform(0);
			fadeStepCount = 0;
			fadeInTimer = new Timer(arg1 / sound_fade_steps, sound_fade_steps);
			fadeInTimer.addEventListener(TimerEvent.TIMER, musicFadeInStep);
			fadeInTimer.addEventListener(TimerEvent.TIMER_COMPLETE, musicFadeInDone);
			fadeInTimer.start();
			return;
		}
		
		private function musicFadeInStep(arg1:TimerEvent):void
		{
			fadeStepCount++;
			var loc1:*=1 / sound_fade_steps;
			var loc2:*=fadeStepCount * loc1;
			//loc2 = loc2 * Options.current.volumeMusic * MUSIC_VOLUME_SCALER;
			if (channel != null) 
			{
				channel.soundTransform = new SoundTransform(loc2);
			}
			return;
		}
		
		private function musicFadeInDone(arg1:TimerEvent):void
		{
			fadeStepCount = sound_fade_steps;
			fadeInTimer.removeEventListener(TimerEvent.TIMER, musicFadeInStep);
			fadeInTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, musicFadeInDone);
			if (channel != null) 
			{
				//channel.soundTransform = new SoundTransform(Options.current.volumeMusic * MUSIC_VOLUME_SCALER);
				channel.soundTransform = new SoundTransform(MUSIC_VOLUME_SCALER);
			}
			return;
		}
		
		public function fadeOut(arg1:int=1000):void
		{
			if (channel == null) 
			{
				return;
			}
			active = false;
			if (fadeStepCount > sound_fade_steps) 
			{
				fadeStepCount = sound_fade_steps;
			}
			fadeOutTimer = new Timer(arg1 / fadeStepCount, fadeStepCount);
			fadeOutTimer.addEventListener(TimerEvent.TIMER, musicFadeOutStep);
			fadeOutTimer.addEventListener(TimerEvent.TIMER_COMPLETE, musicFadeOutDone);
			fadeOutTimer.start();
			return;
		}
		
		private function musicFadeOutStep(arg1:TimerEvent):void
		{
			fadeStepCount--;
			var loc1:*=1 / sound_fade_steps;
			var loc2:*=fadeStepCount * loc1;
			//loc2 = loc2 * Options.current.volumeMusic * MUSIC_VOLUME_SCALER;
			if (channel != null) 
			{
				channel.soundTransform = new SoundTransform(loc2);
			}
			return;
		}
		
		private function musicFadeOutDone(arg1:TimerEvent):void
		{
			fadeOutTimer.removeEventListener(TimerEvent.TIMER, musicFadeOutStep);
			fadeOutTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, musicFadeOutDone);
			stop();
			return;
		}
	}
}