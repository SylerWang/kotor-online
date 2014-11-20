//TO DO
//do I need different gridID?
//How to use Sprite, copying as bitmap data to take dynamic snapshot of 3-D model  for portrait
package 
{
    import __AS3__.vec.*;
    
    import bootloader.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    
    public class RxBootloader extends flash.display.MovieClip
    {
		private static const _images:__AS3__.vec.Vector.<String>=new __AS3__.vec.Vector.<String>(4);
		private var _loaderInfo:YdcYSbaXt5c0d;
		private var _manifest:RxBootManifest;
		private var var7:Object;
		private var _imageCounter:int;
		private var _imagePreloader:YdWSFLaYvzPC;
		private var _loader:flash.display.Loader;
		private var var15:Boolean;

        public function RxBootloader()
        {
            var loc4:*=null;
            var7 = {};
            super();
            loaderInfo.uncaughtErrorEvents.addEventListener("uncaughtError", _error);
            _loaderInfo = new YdcYSbaXt5c0d(stage, loaderInfo);
            YdWSLxnP1g.SetInfo(_loaderInfo);
            YdeIQMeP7enakyu3.SetInfo(_loaderInfo);
            stage.frameRate = 60;
            stage.color = 0;
            stage.quality = "high";
            stage.scaleMode = "noScale";
            stage.align = "TL";
            stage.addEventListener("resize", _resize);
            if (flash.external.ExternalInterface.available) 
            {
                try 
                {
                    flash.external.ExternalInterface.call("function(){swfExecuted=true;}");
                }
                catch (e:Error)
                {
                    new YdWSLxnP1g("WARNING", "External interface not available");
                }
            }
            else 
            {
                new YdWSLxnP1g("WARNING", "External interface not found");
            }
            new YdeIQMeP7enakyu3("Funnel", "game_load", "game_load_05_bootloader_begins_executing");
            var loc1:*=YddLFZWOdOY_RC.GetPersistentData("KOTOROnlineSettings");
            if (loc1) 
            {
                var15 = loc1.musicDisabled;
            }
            var loc3:*="http://dhkgames.com/games/ko/assets/";
            _manifest = new RxBootManifest(loc3);
            _imageCounter = _images.length;
            var loc8:*=0;
            var loc7:*=_images;
			for each (var loc2:* in loc7) 
            {
				loc4 = _manifest.LookupFile(loc2);
				var7[loc2] = new YdTQFOW62NS_g(loc4);
                var7[loc2].Load(_resources);
            }
            return;
        }

        private function _resources():void
        {
            --_imageCounter;
            if (_imageCounter == 0) 
            {
                _load();
            }
            return;
        }

        private function _load():void
        {
            var SWFPath:String;
            var SWFSize:int;
            var swfLoader:YddAv3gLsRg;
            var OnSWFProgress:*;
            var OnSWFComplete:*;

            OnSWFProgress = function (arg1:Number):void
            {
                _imagePreloader.Update(arg1 / 1);
		        return;
            }
            OnSWFComplete = function ():void
            {
			    _imagePreloader.Update(1);
                var loc1:MovieClip=swfLoader.GetSWF();
				if (loc1 == null) 
                {
                    new YdLPJZlzxNa9V(stage, "An error occurred during loading. Please refresh and try again.");
                }
                else 
                {
                    loaderInfo.uncaughtErrorEvents.removeEventListener("uncaughtError", _error);
					addChild(loc1);
					HideBootloader();
                }
                return;
            }
            _loader = var7["ui/welcome/kr_logo.jxr"].GetLoader();
            if (_loader) 
            {
                addChild(_loader);
            }
            _imagePreloader = new YdWSFLaYvzPC(stage.stageWidth, stage.stageHeight, var7);
            addChild(_imagePreloader);
            SWFPath = _manifest.LookupFile("Main.swf");
            SWFSize = _manifest.LookupSize("Main.swf");
            swfLoader = new YddAv3gLsRg(SWFPath, SWFSize);
            swfLoader.Load(OnSWFComplete, OnSWFProgress);
			new OnScreenTrivia(stage, "Loading main SWF");
            _resize(null);
			return;
        }

        private function _error(arg1:flash.events.UncaughtErrorEvent):void
        {
            var loc1:*=null;
            var loc3:*=null;
            var loc2:*=null;
            if (arg1.error is Error) 
            {
                loc3 = arg1.error as Error;
                loc1 = "Uncaught Exception [" + loc3.errorID + "] : " + loc3.name + " : " + loc3.message;
                loc1 = loc1 + ("\n" + loc3.getStackTrace());
            }
            else if (arg1.error is flash.events.ErrorEvent) 
            {
                loc2 = arg1.error as flash.events.ErrorEvent;
                loc1 = "Uncaught Error Event [" + loc2.errorID + "] : " + loc2.text + " : on target; " + loc2.target.toString();
            }
            else 
            {
                loc1 = "Uncaught Exception on " + arg1.error.toString();
            }
            new YdWSLxnP1g("ERROR", loc1);
            return;
        }

        private function _resize(arg1:flash.events.Event):void
        {
            var loc1:*=stage.stageWidth;
            var loc2:*=stage.stageHeight;
            if (_loader) 
            {
                _loader.x = (loc1 - _loader.width) * 0.5;
                _loader.y = (loc2 - _loader.height) * 0.5;
                if (_imagePreloader) 
                {
                    _imagePreloader.x = (loc1 - _imagePreloader.width) * 0.5;
                    _imagePreloader.y = _loader.y + _loader.height;
                }
            }
            return;
        }

        public function HideBootloader():void
        {
			for (var i:uint = 0; i < stage.numChildren; i++)
				if(stage.getChildAt(i).toString().indexOf("Trivia") != -1)
					stage.removeChild(stage.getChildAt(i));
			
			stage.removeEventListener("resize", _resize);
            if (_loader && !(_loader.parent == null)) 
            {
                removeChild(_loader);
                _loader.unload();
                _loader = null;
            }
            if (_imagePreloader && !(_imagePreloader.parent == null)) 
            {
                removeChild(_imagePreloader);
                _imagePreloader.Delete();
                _imagePreloader = null;
            }
            return;
        }
		
		_images[0] = "ui/welcome/kr_logo.jxr";
		_images[1] = "ui/welcome/loader_bar.jxr";
		_images[2] = "ui/welcome/loader_frame.jxr";
		_images[3] = "ui/welcome/loader_lead.jxr";
    }
}