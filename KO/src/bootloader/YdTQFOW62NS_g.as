package bootloader
{
	import flash.display.*;
	import flash.events.*;
	import flash.system.*;
	
	public class YdTQFOW62NS_g extends YdWSFLWc
	{
		private var var28:Loader;
		private var var23:LoaderContext;
		
		public function YdTQFOW62NS_g(param1:String)
		{
			super(param1, 0);
			return;
		}// end function
		
		override public function Load(param1:Function, param2:Function = null) : void
		{
			super.Load(param1);
			return;
		}// end function
		
		public function GetLoader() : Loader
		{
			return var28;
		}// end function
		
		override protected function VTNSRXdP7R(event:Event) : void
		{
			super.VTNSRXdP7R(event);
			if (var10.length > 0)
			{
				var28 = new Loader();
				var28.contentLoaderInfo.addEventListener("complete", VTTQUWjeTiT8i);
				var28.contentLoaderInfo.addEventListener("ioError", VTTQUWjeTiT8i);
				var28.contentLoaderInfo.addEventListener("securityError", VTTQUWjeTiT8i);
				var28.contentLoaderInfo.addEventListener("asyncError", VTTQUWjeTiT8i);
				var23 = new LoaderContext();
				var23.imageDecodingPolicy = "onLoad";
				try
				{
					var28.loadBytes(var10, var23);
				}
				catch (error:Error)
				{
					YKxSaMAX3bgE3Ely7_();
					new YdWSLxnP1g("ERROR", "RxImageLoader: Exception on image import", {url:var6, errorID:error.errorID, errorMessage:error.message});
					if (var16 != null)
					{
						this.var16();
					}
				}
			}
			else if (var16 != null)
			{
				this.var16();
			}
			return;
		}// end function
		
		private function YKxSaMAX3bgE3Ely7_() : void
		{
			var28.contentLoaderInfo.removeEventListener("complete", VTTQUWjeTiT8i);
			var28.contentLoaderInfo.removeEventListener("ioError", VTTQUWjeTiT8i);
			var28.contentLoaderInfo.removeEventListener("securityError", VTTQUWjeTiT8i);
			var28.contentLoaderInfo.removeEventListener("asyncError", VTTQUWjeTiT8i);
			return;
		}// end function
		
		private function VTTQUWjeTiT8i(event:Event) : void
		{
			YKxSaMAX3bgE3Ely7_();
			var _loc_2:* = event.type;
			if (_loc_2 === "complete")
			{
				var10.clear();
				var10 = null;
				var23 = null;
				if (var16 != null)
				{
					this.var16();
				}
			}
			else if (_loc_2 === "ioError")
			{
				new YdWSLxnP1g("ERROR", "RxImageLoader: I/O Error on import", {url:var6});	
			}
			else if (_loc_2 === "securityError")
			{
				new YdWSLxnP1g("ERROR", "RxImageLoader: Security Error on import", {url:var6});
			}
			else if (_loc_2 === "asyncError")
			{
				new YdWSLxnP1g("ERROR", "RxImageLoader: Async Error on import", {url:var6});
			}
			else trace( "unknown event" );
			return;
		}// end function
	}
}