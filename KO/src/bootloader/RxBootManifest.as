package bootloader
{
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;
    
    public class RxBootManifest extends flash.utils.ByteArray
    {
		[Embed(source = "../blob_manifest.txt", mimeType = "application/octet-stream")]
		protected var manifest:Class;
		
        public function RxBootManifest(arg1:String)
        {
            var loc1:String=null;
            super();
            var20 = arg1;
			var tmp:ByteArray = new manifest();
			var result:* = tmp.readUTFBytes(tmp.bytesAvailable);
			//result.position = 0;
			this.writeObject(result);
			this.position = 3;//this is to ignore some weird characters
			
			trace(this.length, var20);
            
			if (this.length != 0) 
            {
                //Ydd3v.Work3(this);
                if (this.length != 0) 
                {
                    loc1 = this.readUTFBytes(this.length-3);
					var21 = loc1.split("|");
                }
            }
            if (var20 && !var21) 
            {
                new YdWSLxnP1g("ERROR", "RxBootManifest: manifest is missing");
            }
            return;
        }

        public function LookupFile(arg1:String):String
        {
            var loc1:*=0;
            if (var20) 
            {
                if (var21) 
                {
                    loc1 = var21.indexOf(arg1);
					//trace( "loc1 is", loc1,  var20, arg1, var21[0], var21.length);
					//trace(var21[0]);
					//for(  var i:uint =0;i< var21.length;i++)
						 //trace(i, var21[i]);
                    if (loc1 != -1) 
                    {
						trace(var20 + var21[loc1 + 1]);
                        return var20 + var21[loc1 + 1];
                    }
                    new YdWSLxnP1g("ERROR", "RxBootManifest: Unable to find " + arg1);
                }
            }
            return "assets/" + arg1;
        }

        public function LookupSize(arg1:String):int
        {
            var loc1:*=0;
            if (var20) 
            {
                if (var21) 
                {
                    loc1 = var21.indexOf(arg1);
                    if (loc1 != -1) 
                    {
                        return var21[loc1 + 2];
                    }
                    new YdWSLxnP1g("ERROR", "RxBootManifest: Unable to find " + arg1);
                }
            }
            return 0;
        }

		private function completeHandler(event:Event):void 
		{ 
			var loader:URLLoader = URLLoader(event.target);
			this.writeObject(loader.data);
			trace(this.length); 
		} 
		
		private var var20:String;

        private var var21:Array;
    }
}
