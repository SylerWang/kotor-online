package bootloader
{
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;
    
    public class YdeIQMeP7enakyu3 extends Object
    {
        public function YdeIQMeP7enakyu3(arg1:String, arg2:String, arg3:String)
        {
            var event:String;
            var type:String;
            var step:String;
            var data:Object;
            var dataJSON:String;
            var data64:String;
            var variables:flash.net.URLVariables;
            var request:flash.net.URLRequest;
            var loader:flash.net.URLStream;
            var VTNSRXdP7R:*;
			//trace( "platform URL", var25.platformURL);

            var loc1:*;
            event = arg1;
            type = arg2;
            step = arg3;
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
            if (!var25.platformURL) 
            {
                return;
            }
            data = {"funnel_type":type, "funnel_step":step, "funnel_vm_time":flash.utils.getTimer(), "rumPlayer_gukey":var25.playerID, "page_request_id":var25.pageViewRequestID, "game_version":var25.gameVersion, "client_channel":var25.playerChannel};
			//trace( "data", data);
            dataJSON = JSON.stringify(data);
			//trace( "dataJSON", dataJSON);
            data64 = YdMEXMzq.EncodeString(dataJSON);
			//data64 =  "eyJwYWdlX3JlcXVlc3RfaWQiOiJkOTAxMGFlOGE3ZWQ0YjFiODVjMjQyZWUzOGVmNzc4ZSIsInJ1bVBsYXllcl9ndWtleSI6IjgwOTRmYTRhMzU1MTRlZDBiODllZjg0YjE4ZjZjNTNmIiwiZnVubmVsX3ZtX3RpbWUiOjE4LCJnYW1lX3ZlcnNpb24iOiJSRUxFQVNFXzIwMTMtMDgtMjkgKDM0OTM0KSIsImZ1bm5lbF9zdGVwIjoiZ2FtZV9sb2FkXzA1X2Jvb3Rsb2FkZXJfYmVnaW5zX2V4ZWN1dGluZyIsImNsaWVudF9jaGFubmVsIjoicmciLCJmdW5uZWxfdHlwZSI6ImdhbWVfbG9hZCJ9"
			trace( "data 64", data64);
            variables = new flash.net.URLVariables();
            variables.ts = -1;
            variables.event = event;
            variables.data = data64;
            variables.game = var25.gameID;
            request = new flash.net.URLRequest(var25.platformURL + "rapiEvent/noteEvent");
            request.method = "POST";
            request.data = variables;
            loader = new flash.net.URLStream();
            loader.addEventListener("complete", VTNSRXdP7R);
            loader.addEventListener("ioError", VTNSRXdP7R);
            loader.addEventListener("securityError", VTNSRXdP7R);
            try 
            {
                loader.load(request);
            }
            catch (error:Error)
            {
                new YdWSLxnP1g("WARNING", "RxTelemetryEvent: Exception", {"errorID":error.errorID, "errorMessage":error.message});
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
