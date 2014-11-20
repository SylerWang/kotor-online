package bootloader
{
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;
    
    public class YdWSFLWc extends flash.net.URLStream
    {
        public function YdWSFLWc(arg1:String, arg2:int)
        {
            super();
            var6 = arg1;
            var8 = arg2;
            return;
        }

        public function Load(arg1:Function, arg2:Function=null):void
        {
            var9 = 5;
            var16 = arg1;
            var18 = arg2;
            var14 = new flash.net.URLRequest(var6);
            addEventListener("open", VTZTJV);
            addEventListener("httpStatus", VTS787KepgjD);
            addEventListener("progress", VTaVTOjP6f);
            addEventListener("complete", VTNSRXdP7R);
            addEventListener("ioError", VTT2uZjZ5);
            addEventListener("securityError", VTdIHcjT7l3Cg7y);
            try 
            {
                load(var14);
            }
            catch (error:Error)
            {
                YKxSaM6gtaihXB_p1ma5();
                new YdWSLxnP1g("ERROR", "RxLoader: Exception on load", {"url":var6, "errorID":error.errorID, "errorMessage":error.message});
                if (var16 != null) 
                {
                    var16();
                }
            }
            return;
        }

        protected function VTaVTOjP6f(arg1:flash.events.ProgressEvent):void
        {
            var loc2:*=arg1.bytesLoaded;
            var loc3:*=arg1.bytesTotal;
            var loc1:*=loc2 / loc3;
            if (var18 != null) 
            {
                var18(loc1);
            }
            return;
        }

        protected function VTNSRXdP7R(arg1:flash.events.Event):void
        {
			//trace( " this is super", arg1);
            YKxSaM6gtaihXB_p1ma5();
            var loc1:*=bytesAvailable;
            var10 = new flash.utils.ByteArray();
            try 
            {
                readBytes(var10);
            }
            catch (error:Error)
            {
                new YdWSLxnP1g("ERROR", "RxLoader: Exception on data read", {"url":var6, "bytes":loc1, "errorID":error.errorID, "errorMessage":error.message});
                var10.length = 0;
            }
            return;
        }

        protected function VTT2uZjZ5(arg1:flash.events.IOErrorEvent):void
        {
			//trace( var9 );
            if (var9 > 0) 
            {
                --var9;
                try 
                {
                    close();
                }
                catch (e:Error)
                {
                };
                try 
                {
                    load(var14);
                }
                catch (error:Error)
                {
                    YKxSaM6gtaihXB_p1ma5();
                    new YdWSLxnP1g("ERROR", "RxLoader: Exception on retry", {"url":var6, "errorID":error.errorID, "errorMessage":error.message});
                    if (var16 != null) 
                    {
                        var16();
                    }
                }
            }
            else 
            {
                YKxSaM6gtaihXB_p1ma5();
                new YdWSLxnP1g("ERROR", "RxLoader: I/O error", {"url":var6, "errorID":arg1.errorID});
                if (var16 != null) 
                {
                    var16();
                }
            }
            return;
        }

        protected function VTdIHcjT7l3Cg7y(arg1:flash.events.SecurityErrorEvent):void
        {
            YKxSaM6gtaihXB_p1ma5();
            new YdWSLxnP1g("ERROR", "RxLoader: Security error", {"url":var6, "errorID":arg1.errorID});
            if (var16 != null) 
            {
                var16();
            }
            return;
        }

        protected function VTZTJV(arg1:flash.events.Event):void
        {
            var57 = flash.utils.getTimer();
            return;
        }

        protected function VTS787KepgjD(arg1:flash.events.HTTPStatusEvent):void
        {
            var13 = flash.utils.getTimer();
            return;
        }

        private function YKxSaM6gtaihXB_p1ma5():void
        {
            removeEventListener("open", VTZTJV);
            removeEventListener("httpStatus", VTS787KepgjD);
            removeEventListener("progress", VTaVTOjP6f);
            removeEventListener("complete", VTNSRXdP7R);
            removeEventListener("ioError", VTT2uZjZ5);
            removeEventListener("securityError", VTdIHcjT7l3Cg7y);
            return;
        }

        protected var var6:String;

        protected var var8:int;

        protected var var9:int;

        protected var var10:flash.utils.ByteArray;

        protected var var57:int;

        protected var var13:int;

        protected var var14:flash.net.URLRequest;

        protected var var16:Function;

        protected var var18:Function;
    }
}
