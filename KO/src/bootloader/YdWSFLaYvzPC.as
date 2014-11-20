package bootloader
{
    import flash.display.*;
    
    public class YdWSFLaYvzPC extends flash.display.Sprite
    {
        public function YdWSFLaYvzPC(arg1:int, arg2:int, arg3:Object)
        {
            super();
            var19 = arg3["ui/welcome/loader_frame.jxr"].GetLoader();
            if (var19) 
            {
                addChild(var19);
            }
            var17 = arg3["ui/welcome/loader_bar.jxr"].GetLoader();
            if (var17) 
            {
                var17.x = 27;
                var17.y = 10;
                addChild(var17);
            }
            var22 = arg3["ui/welcome/loader_lead.jxr"].GetLoader();
            if (var22) 
            {
                var22.x = 27 - var22.width / 2;
                var22.y = 17 - var22.height / 2;
                addChild(var22);
            }
            Update(0);
            return;
        }

        public function Update(arg1:Number):void
        {
            if (var17) 
            {
                var17.width = 348 * arg1;
            }
            if (var22) 
            {
                var22.x = 27 + 348 * arg1 - var22.width / 2;
            }
            return;
        }

        public function Delete():void
        {
            if (var19) 
            {
                removeChild(var19);
                var19.unload();
                var19 = null;
            }
            if (var17) 
            {
                removeChild(var17);
                var17.unload();
                var17 = null;
            }
            if (var22) 
            {
                removeChild(var22);
                var22.unload();
                var22 = null;
            }
            return;
        }

        private var var19:flash.display.Loader;

        private var var17:flash.display.Loader;

        private var var22:flash.display.Loader;
    }
}
