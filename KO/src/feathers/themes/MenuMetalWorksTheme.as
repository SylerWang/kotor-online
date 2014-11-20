package feathers.themes
{
	import feathers.controls.Button;
	import feathers.text.BitmapFontTextFormat;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;

	public class MenuMetalWorksTheme extends MetalWorksMobileTheme
	{
		public static const ALTERNATE_NAME_MENU_BUTTON:String = "menubutton";
		private var texture:Texture = Texture.fromBitmap(new Assets.FontHelveticaTexture());
		private var xml:XML = XML(new Assets.FontHelveticaXml());
		
		public function MenuMetalWorksTheme(root:DisplayObjectContainer, scaleToDPI:Boolean=true)
		{
			super(root, scaleToDPI);
		}
 
		override protected function initialize():void
		{
			super.initialize();
 
			this.setInitializerForClass( Button,  menuButtonInitializer, ALTERNATE_NAME_MENU_BUTTON );
		}
 
		public function  menuButtonInitializer( button:Button):void
		{
			button.defaultSkin = new Image(Assets.getAtlas("MAINMENUOBJECTS").getTexture("Button_Up"));
			button.hoverSkin = new Image(Assets.getAtlas("MAINMENUOBJECTS").getTexture("Button_Over"));
			button.downSkin = new Image(Assets.getAtlas("MAINMENUOBJECTS").getTexture("Button_Down"));
			var font:BitmapFont = new BitmapFont(texture, xml);
			button.defaultLabelProperties.textFormat = new BitmapFontTextFormat(font, 14, 0xddcba2);
		}
	}
}