package
{
	import flash.display.Bitmap;
	import flash.media.Sound;
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class Assets
	{
		//music
		[Embed(source="embeds/sounds/introMusic.mp3")]
		public static var IntroMusic:Class; 
		
		[Embed(source="embeds/sounds/silentMusic.mp3")]
		public static var SilentMusic:Class; 
		
		[Embed(source="embeds/sounds/mainMusic.mp3")]
		public static var MainMusic:Class;
		
		//fonts
		[Embed(source="embeds/Starjedi.ttf", fontFamily="StarJedi", embedAsCFF="false")]
		public static var StarJediFont:Class;
		
		[Embed(source="embeds/MyriadPro-Bold.otf", fontFamily="MyriadPro-Bold", embedAsCFF="false")]
		public static var MyriadProRegularFont:Class;
		
		[Embed(source="embeds/Helvetica.fnt", mimeType="application/octet-stream")]
		public static const FontHelveticaXml:Class;
		
		[Embed(source = "embeds/Helvetica.png")]
		public static const FontHelveticaTexture:Class;
		
		private static var gameTextures:Dictionary = new Dictionary();

		private static var tempBitmap:Bitmap;

		private static var gameTextureAtlasSpecials:TextureAtlas;
		private static var gameTextureAtlasAbilities:TextureAtlas;
		private static var gameTextureAtlasDialog:TextureAtlas;
		private static var gameTextureAtlasCharacterGuardian:TextureAtlas;
		private static var gameTextureAtlasCharacterConsular:TextureAtlas;
		private static var gameTextureAtlasCharacterOfficer:TextureAtlas;
		private static var gameTextureAtlasCharacterScoundrel:TextureAtlas;
		private static var gameTextureAtlasQuickBar:TextureAtlas;
		private static var gameTextureAtlasIntroLongTime:TextureAtlas;
		private static var gameTextureAtlasIntroStars:TextureAtlas;
		private static var gameTextureAtlasIntroSWLogo:TextureAtlas;
		private static var gameTextureAtlasMainMenu:TextureAtlas;
		private static var gameTextureAtlasMainMenuObjects:TextureAtlas;
		private static var gameTextureAtlasVenator:TextureAtlas;
		private static var gameTextureAtlasCharacterCreation:TextureAtlas;
		private static var gameTextureAtlasCharacterCreationObjects:TextureAtlas;
		
		[Embed(source="embeds/SpriteCharacterCreationObjects.png")]
		public static const AtlasTextureGameCharacterCreationObjects:Class;
		
		[Embed(source="embeds/SpriteCharacterCreationObjects.xml", mimeType="application/octet-stream")]
		public static const AtlasXmlGameCharacterCreationObjects:Class;
		
		[Embed(source="embeds/SpriteCharacterCreation.jpg")]
		public static const AtlasTextureGameCharacterCreation:Class;
		
		[Embed(source="embeds/SpriteCharacterCreation.xml", mimeType="application/octet-stream")]
		public static const AtlasXmlGameCharacterCreation:Class;
		
		[Embed(source="embeds/SpriteIntroVenator.png")]
		public static const AtlasTextureGameVenator:Class;
		
		[Embed(source="embeds/SpriteIntroVenator.xml", mimeType="application/octet-stream")]
		public static const AtlasXmlGameVenator:Class;
		
		[Embed(source="embeds/SpriteMainMenu.jpg")]
		public static const AtlasTextureGameMainMenu:Class;
		
		[Embed(source="embeds/SpriteMainMenu.xml", mimeType="application/octet-stream")]
		public static const AtlasXmlGameMainMenu:Class;
				
		[Embed(source="embeds/SpriteMainMenuObjects.png")]
		public static const AtlasTextureGameMainMenuObjects:Class;
		
		[Embed(source="embeds/SpriteMainMenuObjects.xml", mimeType="application/octet-stream")]
		public static const AtlasXmlGameMainMenuObjects:Class;
		
		[Embed(source="embeds/SpriteIntroSWLogo.png")]
		public static const AtlasTextureGameIntroSWLogo:Class;
		
		[Embed(source="embeds/SpriteIntroSWLogo.xml", mimeType="application/octet-stream")]
		public static const AtlasXmlGameIntroSWLogo:Class;
		
		[Embed(source="embeds/SpriteIntroStars.jpg")]
		public static const AtlasTextureGameIntroStars:Class;
		
		[Embed(source="embeds/SpriteIntroStars.xml", mimeType="application/octet-stream")]
		public static const AtlasXmlGameIntroStars:Class;
		
		[Embed(source="embeds/SpriteIntroLongTime.jpg")]
		public static const AtlasTextureGameIntroLongTime:Class;
		
		[Embed(source="embeds/SpriteIntroLongTime.xml", mimeType="application/octet-stream")]
		public static const AtlasXmlGameIntroLongTime:Class;
		
		[Embed(source="embeds/SpriteDialog.png")]
		public static const AtlasTextureGameDialog:Class;
		
		[Embed(source="embeds/SpriteDialog.xml", mimeType="application/octet-stream")]
		public static const AtlasXmlGameDialog:Class;
		
		[Embed(source="embeds/SpriteAbilities.png")]
		public static const AtlasTextureGameAbilities:Class;
		
		[Embed(source="embeds/SpriteAbilities.xml", mimeType="application/octet-stream")]
		public static const AtlasXmlGameAbilities:Class;
		
		[Embed(source="embeds/SpriteSpecials.png")]
		public static const AtlasTextureGameSpecials:Class;
		
		[Embed(source="embeds/SpriteSpecials.xml", mimeType="application/octet-stream")]
		public static const AtlasXmlGameSpecials:Class;
		
		[Embed(source="embeds/SpriteCharacterGuardian.jpg")]
		public static const AtlasTextureGameCharacterGuardian:Class;
		
		[Embed(source="embeds/SpriteCharacterGuardian.xml", mimeType="application/octet-stream")]
		public static const AtlasXmlGameCharacterGuardian:Class;
		
		[Embed(source="embeds/SpriteCharacterConsular.jpg")]
		public static const AtlasTextureGameCharacterConsular:Class;
		
		[Embed(source="embeds/SpriteCharacterConsular.xml", mimeType="application/octet-stream")]
		public static const AtlasXmlGameCharacterConsular:Class;
		
		[Embed(source="embeds/SpriteCharacterOfficer.jpg")]
		public static const AtlasTextureGameCharacterOfficer:Class;
		
		[Embed(source="embeds/SpriteCharacterOfficer.xml", mimeType="application/octet-stream")]
		public static const AtlasXmlGameCharacterOfficer:Class;
		
		[Embed(source="embeds/SpriteCharacterScoundrel.jpg")]
		public static const AtlasTextureGameCharacterScoundrel:Class;
		
		[Embed(source="embeds/SpriteCharacterScoundrel.xml", mimeType="application/octet-stream")]
		public static const AtlasXmlGameCharacterScoundrel:Class;
		
		[Embed(source="embeds/SpriteQuickBar.png")]
		public static const AtlasTextureGameQuickBar:Class;
		
		[Embed(source="embeds/SpriteQuickBar.xml", mimeType="application/octet-stream")]
		public static const AtlasXmlGameQuickBar:Class;
		
		public static function getMusic(name:String):Sound
		{
			var music: Sound;
			switch(name)
			{
				case "INTROMUSIC":
				{
					music = new IntroMusic as Sound;
					return music;
				}
				case "MAINMUSIC":
				{
					music = new MainMusic as Sound;
					return music;
				}
				case "SILENTMUSIC":
				default:
				{
					music = new SilentMusic as Sound;
					return music;
				}
			}
		}
		
		public static function getAtlas(name:String):TextureAtlas
		{
			var texture:Texture;
			var xml:XML;
			
			switch(name)
			{
				case "CHARACTERCREATION":
				{
					if (gameTextureAtlasCharacterCreation == null)
					{
						texture = getTexture("AtlasTextureGameCharacterCreation");
						xml = XML(new AtlasXmlGameCharacterCreation());
						gameTextureAtlasCharacterCreation = new TextureAtlas(texture, xml);
					}
					return gameTextureAtlasCharacterCreation;
				}
				case "CHARACTERCREATIONOBJECTS":
				{
					if (gameTextureAtlasCharacterCreationObjects == null)
					{
						texture = getTexture("AtlasTextureGameCharacterCreationObjects");
						xml = XML(new AtlasXmlGameCharacterCreationObjects());
						gameTextureAtlasCharacterCreationObjects = new TextureAtlas(texture, xml);
					}
					return gameTextureAtlasCharacterCreationObjects;
				}
				case "VENATOR":
				{
					if (gameTextureAtlasVenator == null)
					{
						texture = getTexture("AtlasTextureGameVenator");
						xml = XML(new AtlasXmlGameVenator());
						gameTextureAtlasVenator = new TextureAtlas(texture, xml);
					}
					return gameTextureAtlasVenator;
				}
				case "MAINMENU":
				{
					if (gameTextureAtlasMainMenu == null)
					{
						texture = getTexture("AtlasTextureGameMainMenu");
						xml = XML(new AtlasXmlGameMainMenu());
						gameTextureAtlasMainMenu = new TextureAtlas(texture, xml);
					}
					return gameTextureAtlasMainMenu;
				}
				case "MAINMENUOBJECTS":
				{
					if (gameTextureAtlasMainMenuObjects == null)
					{
						texture = getTexture("AtlasTextureGameMainMenuObjects");
						xml = XML(new AtlasXmlGameMainMenuObjects());
						gameTextureAtlasMainMenuObjects = new TextureAtlas(texture, xml);
					}
					return gameTextureAtlasMainMenuObjects;
				}
				case "INTROSWLOGO":
				{
					if (gameTextureAtlasIntroSWLogo == null)
					{
						texture = getTexture("AtlasTextureGameIntroSWLogo");
						xml = XML(new AtlasXmlGameIntroSWLogo());
						gameTextureAtlasIntroSWLogo = new TextureAtlas(texture, xml);
					}
					return gameTextureAtlasIntroSWLogo;
				}
				case "INTROSTARS":
				{
					if (gameTextureAtlasIntroStars == null)
					{
						texture = getTexture("AtlasTextureGameIntroStars");
						xml = XML(new AtlasXmlGameIntroStars());
						gameTextureAtlasIntroStars = new TextureAtlas(texture, xml);
					}
					return gameTextureAtlasIntroStars;
				}
				case "INTROLONGTIME":
				{
					if (gameTextureAtlasIntroLongTime == null)
					{
						texture = getTexture("AtlasTextureGameIntroLongTime");
						xml = XML(new AtlasXmlGameIntroLongTime());
						gameTextureAtlasIntroLongTime = new TextureAtlas(texture, xml);
					}
					return gameTextureAtlasIntroLongTime;
				}
				case "DIALOG":
				{
					if (gameTextureAtlasDialog == null)
					{
						texture = getTexture("AtlasTextureGameDialog");
						xml = XML(new AtlasXmlGameDialog());
						gameTextureAtlasDialog = new TextureAtlas(texture, xml);
					}
					return gameTextureAtlasDialog;
				}
				case "ABILITIES":
				{
					if (gameTextureAtlasAbilities == null)
					{
						texture = getTexture("AtlasTextureGameAbilities");
						xml = XML(new AtlasXmlGameAbilities());
						gameTextureAtlasAbilities = new TextureAtlas(texture, xml);
					}
					return gameTextureAtlasAbilities;
				}
				case "SPECIALS":
				{
					if (gameTextureAtlasSpecials == null)
					{
						texture = getTexture("AtlasTextureGameSpecials");
						xml = XML(new AtlasXmlGameSpecials());
						gameTextureAtlasSpecials = new TextureAtlas(texture, xml);
					}
					return gameTextureAtlasSpecials;
				}
				case "QUICKBAR":
				{
					if (gameTextureAtlasQuickBar == null)
					{
						texture = getTexture("AtlasTextureGameQuickBar");
						xml = XML(new AtlasXmlGameQuickBar());
						gameTextureAtlasQuickBar = new TextureAtlas(texture, xml);
					}
					return gameTextureAtlasQuickBar;
				}
				case "GUARDIAN":
				{
					if (gameTextureAtlasCharacterGuardian == null)
					{
						texture = getTexture("AtlasTextureGameCharacterGuardian");
						xml = XML(new AtlasXmlGameCharacterGuardian());
						gameTextureAtlasCharacterGuardian = new TextureAtlas(texture, xml);
					}
					return gameTextureAtlasCharacterGuardian;
				}
				case "CONSULAR":
				{
					if (gameTextureAtlasCharacterConsular == null)
					{
						texture = getTexture("AtlasTextureGameCharacterConsular");
						xml = XML(new AtlasXmlGameCharacterConsular());
						gameTextureAtlasCharacterConsular = new TextureAtlas(texture, xml);
					}
					return gameTextureAtlasCharacterConsular;
				}
				case "OFFICER":
				{
					if (gameTextureAtlasCharacterOfficer == null)
					{
						texture = getTexture("AtlasTextureGameCharacterOfficer");
						xml = XML(new AtlasXmlGameCharacterOfficer());
						gameTextureAtlasCharacterOfficer = new TextureAtlas(texture, xml);
					}
					return gameTextureAtlasCharacterOfficer;
				}
				case "SCOUNDREL":
				{
					if (gameTextureAtlasCharacterScoundrel == null)
					{
						texture = getTexture("AtlasTextureGameCharacterScoundrel");
						xml = XML(new AtlasXmlGameCharacterScoundrel());
						gameTextureAtlasCharacterScoundrel = new TextureAtlas(texture, xml);
					}
					return gameTextureAtlasCharacterScoundrel;
				}
			}
			return null;
		}
		
		public static function getTexture(name:String):Texture
		{
			if (gameTextures[name] == undefined)
			{
				var bitmap:Bitmap = new Assets[name]();
				tempBitmap = bitmap;
				gameTextures[name] = Texture.fromBitmap(bitmap);
			}
			return gameTextures[name];
		}
	}
}