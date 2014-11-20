package bootloader
{
    import flash.display.*;
    import flash.text.*;
    
    public class OnScreenTrivia extends flash.display.Sprite
    {
        public function OnScreenTrivia(arg1:flash.display.Stage, arg2:String)
        {
            super();
            var loc2:*=224;
            var loc1:*=128;
            this.x = (arg1.stageWidth - loc2) / 2;
            this.y = (arg1.stageHeight - loc1) / 2 + 150;
            graphics.clear();
            //graphics.beginFill(0, 0.9);
            //graphics.drawRoundRect(0, 0, loc2, loc1, 32);
            var loc3:*;
            (loc3 = new flash.text.TextField()).x = 8;
            loc3.y = 32;
            loc3.width = loc2;
            loc3.height = loc1;
            loc3.autoSize = "center";
            loc3.selectable = false;
            loc3.wordWrap = false;
            var loc4:*;
            (loc4 = new flash.text.TextFormat()).color = 16768768;
            loc4.font = "Calibri";
            loc4.letterSpacing = 1;
            loc4.size = 22;
            loc3.defaultTextFormat = loc4;
            loc3.text = arg2;
            addChild(loc3);
            arg1.addChild(this);
            return;
        }
    }
}
