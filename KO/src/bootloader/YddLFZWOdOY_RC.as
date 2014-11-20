package bootloader
{
    import flash.events.*;
    import flash.net.*;
    
    public class YddLFZWOdOY_RC extends Object
    {
        public function YddLFZWOdOY_RC()
        {
            super();
            return;
        }

        public static function GetPersistentData(arg1:String):Object
        {
            var loc1:*=NK36MIjPsBQ4Tw_(arg1);
            if (loc1 && loc1.hasOwnProperty("data")) 
            {
                return loc1.data;
            }
            return null;
        }

        public static function FlushPersistentData(arg1:String):String
        {
            var name:String;
            var so:flash.net.SharedObject;
            var result:String;

            name = arg1;
            so = NK36MIjPsBQ4Tw_(name);
            if (so) 
            {
                so.addEventListener("asyncError", function (arg1:flash.events.AsyncErrorEvent):void
                {
                    return;
                }, false, 0, true)
                so.addEventListener("netStatus", function (arg1:flash.events.NetStatusEvent):void
                {
                    return;
                }, false, 0, true)
                try 
                {
                    result = so.flush();
                }
                catch (e:Error)
                {
                    result = null;
                }
            }
            return result;
        }

        private static function NK36MIjPsBQ4Tw_(arg1:String):flash.net.SharedObject
        {
            var loc1:*=null;
            try 
            {
                loc1 = flash.net.SharedObject.getLocal(arg1, "/");
            }
            catch (e:Error)
            {
                loc1 = null;
            }
            return loc1;
        }
    }
}
