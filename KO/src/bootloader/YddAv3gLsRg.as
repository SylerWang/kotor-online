package bootloader
{
    import flash.display.*;
    import flash.events.*;
    import flash.system.*;
    
    public class YddAv3gLsRg extends YdWSFLWc
    {
        public function YddAv3gLsRg(arg1:String, arg2:int)
        {
            super(arg1, arg2);
            return;
        }

        public override function Load(arg1:Function, arg2:Function=null):void
        {
            super.Load(arg1, arg2);
            return;
        }

        public function GetSWF():flash.display.MovieClip
        {
            return var26;
        }

        protected override function VTNSRXdP7R(arg1:flash.events.Event):void
        {
            super.VTNSRXdP7R(arg1);
			///trace( "this is not super", var10.length);
            if (var10.length > 0) 
            {
                if (!(var10[0] == 67) && !(var10[0] == 90) || !(var10[1] == 87) || !(var10[2] == 83)) 
                {
                    //Ydd3v.Work2(var10);
                    if (var10.length == 0) 
                    {
                        new YdWSLxnP1g("ERROR", "RxSWFLoader: Error on SWF inflation");
						trace("ERROR", "RxSWFLoader: Error on SWF inflation");
                        if (var16 != null) 
                        {
							trace(" if 16", var16);
                            var16();
                        }
                        return;
                    }
                }
                var27 = new flash.display.Loader();
                var27.contentLoaderInfo.addEventListener("complete", VTTQUWjeTiT8i);
                var27.contentLoaderInfo.addEventListener("ioError", VTTQUWjeTiT8i);
                var27.contentLoaderInfo.addEventListener("securityError", VTTQUWjeTiT8i);
                var27.contentLoaderInfo.addEventListener("asyncError", VTTQUWjeTiT8i);
                try 
                {
					//trace("10");
                    var27.loadBytes(var10);
                }
                catch (error:Error)
                {
					trace("ERROR", "RxSWFLoader: Exception on SWF import", {"errorID":error.errorID, "errorMessage":error.message});
                    YKxSaMAX3bgE3Ely7_();
                    new YdWSLxnP1g("ERROR", "RxSWFLoader: Exception on SWF import", {"errorID":error.errorID, "errorMessage":error.message});
                    if (var16 != null) 
                    {
						trace( "catch16", var16);
                        var16();
                    }
                }
            }
            else if (var16 != null) 
            {
				trace( "else 16", var16);
                var16();
            }
            return;
        }

        private function YKxSaMAX3bgE3Ely7_():void
        {
            var27.contentLoaderInfo.removeEventListener("complete", VTTQUWjeTiT8i);
            var27.contentLoaderInfo.removeEventListener("ioError", VTTQUWjeTiT8i);
            var27.contentLoaderInfo.removeEventListener("securityError", VTTQUWjeTiT8i);
            var27.contentLoaderInfo.removeEventListener("asyncError", VTTQUWjeTiT8i);
            return;
        }

        private function VTTQUWjeTiT8i(arg1:flash.events.Event):void
        {
            YKxSaMAX3bgE3Ely7_();
            var loc1:*=arg1.type;
			//trace(loc1);
            if ("complete" === loc1) 
            {
                var26 = arg1.target.content;
				if (var16 != null) 
				{
					var16();
				}
				//trace( "complete",  var26);
            }
        }

        protected override function VTS787KepgjD(arg1:flash.events.HTTPStatusEvent):void
        {
            var loc4:*=NaN;
            var loc2:*=0;
            var loc5:*=null;
            var loc6:*=0;
            var loc3:*=0;
            var loc1:*=0;
            super.VTS787KepgjD(arg1);
			//trace( "argument one:", arg1.status);
            if (arg1.status != 200) 
            {
                new YdWSLxnP1g("WARNING", "RxSWFLoader: Unexpected HTTP response", {"httpStatus":arg1.status, "pageDomain":flash.system.Security.pageDomain});
            }
            else if ((loc4 = var13 - var57) > 0) 
            {
                loc2 = var8 * 8 / loc4;
                if (loc5 == YddLFZWOdOY_RC.GetPersistentData("KOTOROnlineBandwidth")) 
                {
                    if (loc5.hasOwnProperty("lastSize")) 
                    {
                        if (loc5.lastSize != var8) 
                        {
                            loc6 = loc5.samples;
                            loc3 = loc5.avgKbps;
                            loc1 = (loc2 + loc6 * loc3) / (loc6 + 1);
                            loc5.lastSize = var8;
                            loc5.avgKbps = loc1;
                            loc5.samples = loc6 + 1;
                            YddLFZWOdOY_RC.FlushPersistentData("KOTOROnlineBandwidth");
                        }
                    }
                    else 
                    {
                        loc5.lastSize = var8;
                        loc5.avgKbps = loc2;
                        loc5.samples = 1;
                        YddLFZWOdOY_RC.FlushPersistentData("KOTOROnlineBandwidth");
                    }
                }
            }
            return;
        }

        private var var26:flash.display.MovieClip;

        private var var27:flash.display.Loader;
    }
}
