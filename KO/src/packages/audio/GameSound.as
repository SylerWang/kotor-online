package packages.audio
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;

	public class GameSound extends Object
	{
		public static var sndChannel:SoundChannel = new SoundChannel();

		public function GameSound()
		{
			super();
		}
		
		public static function playSound( name: String): void
		{
			sndChannel.stop();
			var snd:Sound = new Sound();
			var sndS: String = "assets/mp3/"+ name + ".mp3";
			var req:URLRequest = new URLRequest(sndS);
			var context:SoundLoaderContext = new SoundLoaderContext(1000, true);
			snd.load(req, context);
			sndChannel = snd.play();
		}
	}
}