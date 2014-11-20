package bootloader
{
    import flash.utils.*;
    
    public class Ydd3v extends Object
    {
        public function Ydd3v()
        {
            super();
            return;
        }

        public static function Work1(arg1:flash.utils.ByteArray):void
        {
			var loc2:*=0;
            var loc1:*=arg1.length / 2;
            if (loc1 > 64) 
            {
                loc1 = 64;
            }
            loc2 = 0;
            while (loc2 < loc1) 
            {
                arg1[loc2] = arg1[loc2] ^ arg1[arg1.length - loc2 - 1];
                ++loc2;
            }
            return;
        }

        public static function Work2(arg1:flash.utils.ByteArray):void
        {
			//trace(  "work to");
            Work1(arg1);
            try 
            {
                arg1.inflate();
				//arg1.position = 0;
				trace(arg1.bytesAvailable, arg1.length);
				//trace(arg1.readUTFBytes(arg1.bytesAvailable));
            }
            catch (e:Error)
            {
				trace( "work to error");
                arg1.length = 0;
            }
            return;
        }

        public static function Work3(arg1:flash.utils.ByteArray):void
        {
			//trace( " works three");
            Work1(arg1);
            try 
            {
                arg1.uncompress("lzma");
            }
            catch (e:Error)
            {
				//trace("Ydd3v: error on work three");
                arg1.length = 0;
            }
            return;
        }
    }
}
