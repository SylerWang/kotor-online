package bootloader
{
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;
    
    public class YdWSLxnP1g extends Object
    {
        public function YdWSLxnP1g(arg1:String, arg2:String, arg3:Object=null)
        {
            var type:String;
            var message:String;
            var data:Object;
            var event:Object;
            var url:String;
            var request:flash.net.URLRequest;
            var loader:flash.net.URLLoader;
            var VTNSRXdP7R:*;

            var loc1:*;
            type = arg1;
            message = arg2;
            data = arg3;
			//trace( type, message, data );
            VTNSRXdP7R = function (arg1:flash.events.Event):void
            {
                loader.removeEventListener("complete", VTNSRXdP7R);
                loader.removeEventListener("ioError", VTNSRXdP7R);
                loader.removeEventListener("securityError", VTNSRXdP7R);
                return;
            }
            super();
            if (!var25) 
            {
                return;
            }
            event = {"type":type.toUpperCase(), "rumPlayer":var25.playerID, "deployment":var25.deployment, "message":message, "data":data, "executionTime_ms":flash.utils.getTimer(), "os":var25.osName + " (" + var25.osArchitecture.toString() + "-bit)", "cpu":var25.cpuArchitecture, "flashVersion":var25.flashVersion, "flashType":var25.flashType, "flashDebugger":var25.flashDebugger.toString(), "browserName":var25.browserName, "browserVersion":var25.browserVersion};
            url = "https://logs.loggly.com/inputs/eddc27c6-e457-4020-bc56-6b55468e5fd8";
            request = new flash.net.URLRequest(url);
            request.method = "POST";
            request.data = JSON.stringify(event);
			trace( request.data);
            loader = new flash.net.URLLoader();
            loader.addEventListener("complete", VTNSRXdP7R);
            loader.addEventListener("ioError", VTNSRXdP7R);
            loader.addEventListener("securityError", VTNSRXdP7R);
            try 
            {
                loader.load(request);
            }
            catch (e:Error)
            {
                trace("Exception on log event submission");
            }
            return;
        }

        public static function SetInfo(arg1:YdcYSbaXt5c0d):void
        {
            var25 = arg1;
            return;
        }

        private static var var25:YdcYSbaXt5c0d;
    }
}
