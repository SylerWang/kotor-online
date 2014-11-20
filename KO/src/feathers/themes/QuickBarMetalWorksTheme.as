package feathers.themes
{
	import feathers.controls.Button;
	import feathers.text.BitmapFontTextFormat;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;

	public class QuickBarMetalWorksTheme extends MetalWorksMobileTheme
	{
		public static const ALTERNATE_NAME_QUICKBAR_BUTTON:String = "quickBarbutton";
		private var texture:Texture = Texture.fromBitmap(new Assets.FontHelveticaTexture());
		private var xml:XML = XML(new Assets.FontHelveticaXml());
		
		public function QuickBarMetalWorksTheme(root:DisplayObjectContainer, scaleToDPI:Boolean=true)
		{
			super(root, scaleToDPI);
		}
 
		override protected function initialize():void
		{
			super.initialize();
 
			this.setInitializerForClass( Button,  quickBarButtonInitializer, ALTERNATE_NAME_QUICKBAR_BUTTON );
		}
 
		public function  quickBarButtonInitializer( button:Button):void
		{
			button.defaultSkin = new Image(Assets.getAtlas("QUICKBAR").getTexture("EmptyIcon"));
			var font:BitmapFont = new BitmapFont(texture, xml);
			button.defaultLabelProperties.textFormat = new BitmapFontTextFormat(font, 14, 0x6fbbd3);
			button.labelOffsetX = -Math.ceil(button.defaultSkin.width/3);
			button.labelOffsetY = -Math.ceil(button.defaultSkin.height/3);
		}
	}
}