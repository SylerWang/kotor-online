package bootloader
{
    import flash.events.*;
    import flash.media.*;
    import flash.net.*;
    
    public class YddSZVV62NS_g extends flash.media.Sound
    {
        public function YddSZVV62NS_g(arg1:String, arg2:int)
        {
            super();
            var6 = arg1;
            var loc1:*=new flash.net.URLRequest(arg1);
            addEventListener("complete", VTNSRXdP7R);
            addEventListener("ioError", VTT2uZjZ5);
            try 
            {
                load(loc1, new flash.media.SoundLoaderContext(arg2));
            }
            catch (error:Error)
            {
                YKxSaM6gtaihXB_p1ma5();
                new YdWSLxnP1g("ERROR", "RxSoundLoader: Exception on load()", {"url":var6, "errorID":error.errorID, "errorMessage":error.message});
            }
            return;
        }

        public function Play(arg1:Number, arg2:Function):void
        {
            var volume:Number;
            var callback:Function;
            var channel:flash.media.SoundChannel;
            var OnPlaybackComplete:*;

            var loc1:*;
            volume = arg1;
            callback = arg2;
            channel = play(0, 0, new flash.media.SoundTransform(volume, 0));
            if (channel != null) 
            {
                OnPlaybackComplete = function (arg1:flash.events.Event):void
                {
                    channel.removeEventListener("soundComplete", OnPlaybackComplete);
                    channel = null;
                    if (callback != null) 
                    {
                        callback();
                    }
                    return;
                }
                channel.addEventListener("soundComplete", OnPlaybackComplete);
            }
            else if (callback != null) 
            {
                callback();
            }
            return;
        }

        private function VTNSRXdP7R(arg1:flash.events.Event):void
        {
            YKxSaM6gtaihXB_p1ma5();
            return;
        }

        private function VTT2uZjZ5(arg1:flash.events.IOErrorEvent):void
        {
            YKxSaM6gtaihXB_p1ma5();
            return;
        }

        private function YKxSaM6gtaihXB_p1ma5():void
        {
            addEventListener("complete", VTNSRXdP7R);
            addEventListener("ioError", VTT2uZjZ5);
            return;
        }

        private var var6:String;
    }
}
