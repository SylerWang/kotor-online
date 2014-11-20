package feathers.themes
{
	import feathers.controls.Button;
	import feathers.text.BitmapFontTextFormat;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;

	public class CharacterCreationMetalWorksTheme extends MetalWorksMobileTheme
	{
		public static const ALTERNATE_NAME_CHARACTERCREATION_BUTTON:String = "characterCreationbutton";
		private var texture:Texture = Texture.fromBitmap(new Assets.FontHelveticaTexture());
		private var xml:XML = XML(new Assets.FontHelveticaXml());
		
		public function CharacterCreationMetalWorksTheme(root:DisplayObjectContainer, scaleToDPI:Boolean=true)
		{
			super(root, scaleToDPI);
		}
 
		override protected function initialize():void
		{
			super.initialize();
 
			this.setInitializerForClass( Button,  characterCreationButtonInitializer, ALTERNATE_NAME_CHARACTERCREATION_BUTTON );
		}
 
		public function  characterCreationButtonInitializer( button:Button):void
		{
			button.defaultSkin = new Image(Assets.getAtlas("CHARACTERCREATIONOBJECTS").getTexture("background"));
			//var font:BitmapFont = new BitmapFont(texture, xml);
			//button.defaultLabelProperties.textFormat = new BitmapFontTextFormat(font, 14, 0xddcba2);
		}
	}
}