package bootloader
{
    import flash.display.*;
    import flash.external.*;
    import flash.system.*;
    
    public class YdcYSbaXt5c0d extends Object
    {
        public function YdcYSbaXt5c0d(arg1:flash.display.Stage, arg2:flash.display.LoaderInfo)
        {
            var loc3:*=null;
            var loc1:*=0;
            var loc2:*=null;
            var loc4:*=null;
            super();
            var29 = arg1;
            var30 = arg2.parameters["game_gukey"];
			//trace( "var 30", var30);
            var31 = "RELEASE_2013-08-29 (33829)";
            var32 = arg2.parameters["server_host"];
            var33 = arg2.parameters["platform_url"];
            var34 = arg2.parameters["landing_url"];
            var40 = arg2.parameters["DHK_id"];
            var37 = arg2.parameters["DHK_channel"];
            var38 = arg2.parameters["DHK_token"];
            var39 = arg2.parameters["DHK_bucket"];
            var1 = arg2.parameters["DHK_graph_url"];
            var41 = arg2.parameters["DHK_chat_server"];
            var42 = arg2.parameters["requestId"];
            if (!var32) 
            {
                var32 = arg2.parameters["ssUrl"];
            }
            var43 = "n/a";
            var44 = "n/a";
            if (flash.external.ExternalInterface.available) 
            {
                try 
                {
                    loc3 = flash.external.ExternalInterface.call("window.navigator.userAgent.toString");
                }
                catch (e:Error)
                {
                    new YdWSLxnP1g("WARNING", "External interface not available");
                }
                if (loc3 != null) 
                {
                    loc1 = loc3.indexOf("MSIE");
                    if (loc1 == -1) 
                    {
                        loc1 = loc3.indexOf("Chrome");
                    }
                    if (loc1 == -1) 
                    {
                        loc1 = loc3.indexOf("Firefox");
                    }
                    if (loc1 == -1) 
                    {
                        loc1 = loc3.indexOf("Safari");
                    }
                    if (loc1 == -1) 
                    {
                        loc1 = loc3.indexOf("Opera");
                    }
                    if (loc1 == -1) 
                    {
                        var43 = loc3;
                    }
                    else if ((loc4 = (loc2 = loc3.slice(loc1)).split(new RegExp(" |\\/|;"))).length >= 2) 
                    {
                        var43 = loc4[0];
                        var44 = loc4[1];
                    }
                }
            }
            var loc5:*;
            if ((loc5 = flash.system.Capabilities.version.split(new RegExp(" |,"))).length >= 5) 
            {
                var45 = loc5[1] + "." + loc5[2] + "." + loc5[3] + "." + loc5[4];
            }
            else 
            {
                var45 = "n/a";
            }
            var46 = flash.system.Capabilities.playerType;
            var47 = flash.system.Capabilities.isDebugger;
            var48 = flash.system.Security.sandboxType;
            var49 = flash.system.Security.pageDomain;
            var50 = flash.system.Capabilities.os;
            var51 = flash.system.Capabilities.supports64BitProcesses ? 64 : 32;
            var52 = flash.system.Capabilities.cpuArchitecture;
            var53 = flash.system.Capabilities.screenResolutionX;
            var54 = flash.system.Capabilities.screenResolutionY;
            var55 = flash.system.Capabilities.language.toUpperCase();
            if (flash.system.Security.pageDomain != null) 
            {
                var56 = var33;
            }
            else 
            {
                var56 = "local";
            }
            return;
        }

        public function get gameServerHost():String
        {
            return var32;
        }

        public function get platformURL():String
        {
            return var33;
        }

        public function get landingURL():String
        {
            return var34;
        }

        public function get playerID():String
        {
            return var40;
        }

        public function get playerChannel():String
        {
            return var37;
        }

        public function get playerBucket():String
        {
            return var39;
        }

        public function get playerToken():String
        {
            return var38;
        }

        public function get graphURL():String
        {
            return var1;
        }

        public function get chatURL():String
        {
            return var41;
        }

        public function get pageViewRequestID():String
        {
            return var42;
        }

        public function get browserName():String
        {
            return var43;
        }

        public function get browserVersion():String
        {
            return var44;
        }

        public function get flashVersion():String
        {
            return var45;
        }

        public function get flashType():String
        {
            return var46;
        }

        public function get flashDebugger():Boolean
        {
            return var47;
        }

        public function get flashSandbox():String
        {
            return var48;
        }

        public function get flashPageDomain():String
        {
            return var49;
        }

        public function get osName():String
        {
            return var50;
        }

        public function get osArchitecture():int
        {
            return var51;
        }

        public function get cpuArchitecture():String
        {
            return var52;
        }

        public function get displayHeight():int
        {
            return var54;
        }

        public function get gameID():String
        {
            return var30;
        }

        public function get language():String
        {
            return var55;
        }

        public function get stageWidth():int
        {
            return var29.stageWidth;
        }

        public function get stageHeight():int
        {
            return var29.stageHeight;
        }

        public function get usedMemory():int
        {
            return flash.system.System.totalMemory - flash.system.System.freeMemory;
        }

        public function get totalMemory():int
        {
            return flash.system.System.totalMemory;
        }

        public function get deployment():String
        {
            return var56;
        }

        public function get displayWidth():int
        {
            return var53;
        }

        public function get gameVersion():String
        {
            return var31;
        }

        private var var29:flash.display.Stage;

        private var var30:String;

        private var var31:String;

        private var var32:String;

        private var var33:String;

        private var var34:String;

        private var var40:String;

        private var var37:String;

        private var var38:String;

        private var var39:String;

        private var var1:String;

        private var var41:String;

        private var var42:String;

        private var var43:String;

        private var var44:String;

        private var var45:String;

        private var var46:String;

        private var var47:Boolean;

        private var var48:String;

        private var var49:String;

        private var var51:int;

        private var var52:String;

        private var var53:int;

        private var var54:int;

        private var var55:String;

        private var var56:String;

        private var var35:String;

        private var var50:String;
    }
}
