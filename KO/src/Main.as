package 
{
	import __AS3__.vec.*;
	
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.LensBase;
	import away3d.cameras.lenses.OrthographicLens;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.*;
	import away3d.core.managers.*;
	import away3d.debug.*;
	import away3d.entities.*;
	import away3d.events.*;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.textures.BitmapTexture;
	
	import bootloader.*;
	
	import com.rocketmandevelopment.grid.Grid;
	
	import flash.display.*;
	import flash.display3D.Context3D;
	import flash.events.*;
	import flash.external.*;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.net.URLRequest;
	import flash.text.*;
	import flash.ui.Keyboard;
	
	import packages.characters.Action;
	import packages.characters.Avatar;
	import packages.characters.Character;
	import packages.characters.Characters;
	import packages.characters.Classes;
	import packages.characters.Gender;
	import packages.characters.Origins;
	import packages.characters.Party;
	import packages.characters.Race;
	import packages.map.Map;
	import packages.map.Map3d;
	import packages.map.MapLogic;
	
	import starling.core.*;
	import starling.display.Stage;
	import starling.rootsprites.*;
	
	import sunag.events.SEAEvent;
	import sunag.sea3d.SEA3D;
	import sunag.sea3d.config.DefaultConfig;
	import sunag.utils.TimeStep;
	
	public class Main extends MovieClip 
	{
		public static var isCharacterCreation: Boolean= false;
		public static var isMenu: Boolean= false;
		
		//initialize public static classes for future use
		public static var MAIN:Main;
		public static var CONDITIONS:Conditions = new Conditions();
		public static var INTRO:Intro = new Intro();
		public static var O2D:O2d = new O2d();//objects 2-D
		public static var STATES:States = new States();
		public static var CHARACTERS:Characters = new Characters();
		public static var MOVEONMAP:MoveOnMap = new MoveOnMap();
		public static var MAP:Map = new Map();
		public static var MAP3D:Map3d = new Map3d();
		public static var MAPLOGIC:MapLogic = new MapLogic();
		public static var SPRITES:Sprites = new Sprites();
		
		public static var APP_WIDTH:int;
		public static var APP_HEIGHT:int;
		public static var gameStage:flash.display.Stage;
		public static var currentGrid:Grid;
		public static var cellSize:int=32;
		//public static var intro: Boolean = false;
		
		//game states
		public static var introState: Boolean;
		public static var suspendState: Boolean;
		public static var gameState: Boolean;
		public static var characterCreationState: Boolean;
		public static var menuState: Boolean;
		
		// Stage manager and proxy instances
		private var stage3DManager : Stage3DManager;
		private var stage3DProxy : Stage3DProxy;
		
		// Away3D view instances
		public static var away3dView : View3D;
		public static var cameraDelta:Vector3D = new Vector3D;
		
		// SEA3D
		public static var playerParty:Party = new Party();
		//public static var activePlayerCharacter:Character;
		//Please note that the last string  "Camera" is a bogus, small resource that is needed only to make sure that the rest of the resources are getting loaded
		//the actual camera is an orthographic one, created manually somewhere else
		public static const sea3dResourcesString:Array = ["mesh_humanoid", "animation_navigation_pause2", "animation_navigation_runSS", "weapon_lightsaber", "Camera"];
		public static const sea3dResources:Array = new Array();
		private var sea3dCounter:int = 0;
		
		//UI windows
		public static var abilitiesWindowPosition:Point = new Point;
		
		//various ratios and other things
		public static var aspectRatio:Number;
		public static var reverseAspectRatio:Number;
		public static var keyState:Array = [];
		public static var timeStep:TimeStep;
		
		//away3D background map tiles
		public static var mapTiles: Mesh = new Mesh(new PlaneGeometry(0,0));
		public static var mapTilesPath: Mesh = new Mesh(new PlaneGeometry(0,0));
		
		// Starling instances
		public static var starlingMap:Starling;
		public static var starlingMenu:Starling;
		public static var starlingFront:Starling;
		public static var starlingCharacterCreation:Starling;
		public static var starlingIntro:Starling;
		public static var _scale:Number;
		public static var _scale1280:Number;
		public static var _scaleReverse:Number;
		
		public static var alreadyPressed:Boolean = false;
		
		//public static var saberOn:Boolean = true;
		//private var saberOpening:Boolean = false;
		//private var saberOpeningCounter:int = 0;
		//private var saberZScaleSpeed:int = 5;
		
		//public static var movingPlayer:Boolean = false;
		//public static var suspend: Boolean = true;
		//public static var runSpeed:Number;
		public static var running:Boolean = true;
		
		//map level Kings Road style
		private var currentMapImagesVector:Vector.<String> = new Vector.<String>();
		public static const currentMapImagesArray:Array = new Array();
		public static const currentMapPathImagesArray:Array = new Array();
		//public static const currentMapImagesGrid:Array = new Array();
		public static var currentMap:int = 1;
		//public static const currentMapScaleX:Number = 1;
		//public static const currentMapScaleY:Number = 1;
		private var imageMapCounter:int = -1;
		public static var mapGrids: Array = new Array;
		//public static var currentMapCharacters: Array = new Array;
		//public static var currentConversationOwner:Character;//TO DO. Unfortunately conversations/dialogues are currently statically assigned
		
		//Pre-loader resources
		_loaderImagesVector[0] = "ui/welcome/kr_logo.jxr";
		_loaderImagesVector[1] = "ui/welcome/loader_bar.jxr";
		_loaderImagesVector[2] = "ui/welcome/loader_frame.jxr";
		_loaderImagesVector[3] = "ui/welcome/loader_lead.jxr";
		
		private static const var0:Number=0.5;
		private static const var2:String="KOTOROnlineSettings";
		private static const _loaderImagesVector:Vector.<String> = new Vector.<String>(4);
		private var _loaderInfo:YdcYSbaXt5c0d;
		private var _manifest:RxBootManifest;
		private var _loaderObject:Object;
		private var _imageCounter:int;
		private var _imagePreloader:YdWSFLaYvzPC;
		private var _loader:flash.display.Loader;
		private var var15:Boolean;
		
		/**
		 * Constructor
		 */
		public function Main()
		{
			trace( " Main starting");
			if (stage) 
			{
				addToStage(null);
				gameStage = stage;
			}
			else 
			{
				addEventListener("addedToStage", addToStage);
			}
			return;
		}
		
		/**
		 * Global initialise function
		 */
		private function addToStage(event:Event):void
		{
			removeEventListener("addedToStage", addToStage);
			MAIN = this;
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.frameRate = 60;
			gameStage = stage;
			
			_scale = 1920 / stage.stageWidth;
			_scale1280 = stage.stageWidth / 1280;
			_scaleReverse = stage.stageWidth / 1920;
			timeStep = new TimeStep(parent.stage.frameRate);

			//STEP 1
			initProxies();
		}
		
		/**
		 * Initialise the Stage3D proxies
		 */
		private function initProxies():void
		{
			// Define a new Stage3DManager for the Stage3D objects
			stage3DManager = Stage3DManager.getInstance(stage);
			
			// Create a new Stage3D proxy to contain the separate views
			stage3DProxy = stage3DManager.getFreeStage3DProxy();
			stage3DProxy.addEventListener(Stage3DEvent.CONTEXT3D_CREATED, onContextCreated);
			stage3DProxy.antiAlias = 8;
			stage3DProxy.color = 0x0;
		}
		
		private function onContextCreated(event : Stage3DEvent) : void {
			//STEP 2
			initLoader();
		}
		
		private function initLoader(): void
		{
			var loc4:*=null;
			_loaderObject = {};
			loaderInfo.uncaughtErrorEvents.addEventListener("uncaughtError", _error);
			_loaderInfo = new YdcYSbaXt5c0d(stage, loaderInfo);
			YdWSLxnP1g.SetInfo(_loaderInfo);
			YdeIQMeP7enakyu3.SetInfo(_loaderInfo);
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
			_imageCounter = _loaderImagesVector.length;
			var loc8:*=0;
			var loc7:*=_loaderImagesVector;
			for each (var loc2:* in loc7) 
			{
				loc4 = _manifest.LookupFile(loc2);
				_loaderObject[loc2] = new YdTQFOW62NS_g(loc4);
				_loaderObject[loc2].Load(_resources);
			}
			return;
		}
		
		private function initResources(): void
		{
			_loader = _loaderObject["ui/welcome/kr_logo.jxr"].GetLoader();
			if (_loader) 
			{
				addChild(_loader);
			}
			
			_imagePreloader = new YdWSFLaYvzPC(stage.stageWidth, stage.stageHeight, _loaderObject);
			addChild(_imagePreloader);
			
			//assigning names to map images in the map vector
			var loc2:*=0;
			var loc3:*=0;
			var loc4:String;
			
			//injecting the map images
			while (loc2 < 4) 
			{
				loc3 = 0;
				while (loc3 < 4) 
				{
					loc4 = "maps/m" + currentMap + loc2 + loc3 + ".jpg";
					currentMapImagesVector.push(loc4);
					++loc3;
				}
				++loc2;
			}

			//injecting the map path images
			loc2 = 0;
			while (loc2 < 4) 
			{
				loc3 = 0;
				while (loc3 < 4) 
				{
					loc4 = "maps/p" + currentMap + loc2 + loc3 + ".png";
					currentMapImagesVector.push(loc4);
					++loc3;
				}
				++loc2;
			}

			//for (var i:uint=0;i<currentMapImagesVector.length;i++)	 trace(currentMapImagesVector[i],currentMapImagesVector.length);
			
			//STEP 4
			initAway3D();
			initSEA3D();
			//initStarling();
		}
		
		/**
		 * Initialise the Away3D views
		 */
		private function initAway3D() : void
		{
			// Create the first Away3D view which holds the cube objects.
			away3dView = new View3D();
			away3dView.stage3DProxy = stage3DProxy;
			away3dView.shareContext = true;
			
			//away3dView.camera.controller = hoverController = new HoverController(null, 45, 30, 1200, 5, 89.999);
			
			addChild(away3dView);
			
			addChild(new AwayStats(away3dView));
		}
		
		private function initSEA3D():void
		{
			var config:DefaultConfig = new DefaultConfig();
			
			/**
			 * use cpu
			 * */
			
			//config.forceSkeletonCPU = true;
			
			/**
			 * <sea3d.container> contains all elements loaded.
			 * add objects in scene container
			 * */
			
			config.container = away3dView.scene;
			config.updateGlobalPose = true;
			/**
			 * Init loader
			 * */			
			
			if(sea3dResources.length==0)	new OnScreenTrivia(stage, "Loading SEA3D scene");
			
			for each( var string: String in sea3dResourcesString)
			{
				var _sea3d:SEA3D = new SEA3D(config);
				sea3dResources.push(_sea3d);
			}
			
			for each(_sea3d in sea3dResources)
			{
				_sea3d.addEventListener(SEAEvent.PROGRESS, onProgress);
				_sea3d.addEventListener(SEAEvent.COMPLETE, onComplete);			
			}
			
			handleSea3d(sea3dCounter);
		}
		
		//handle the Sea 3-D resources
		private function handleSea3d(counter:int): void
		{
			var SEAPath:String;
			var SEASize:int;
			var name:String = sea3dResourcesString[counter] + ".sea";
			SEAPath = _manifest.LookupFile(name);
			SEASize = _manifest.LookupSize(name);
			
			var sea3dString: String = SEAPath.slice(-63,SEAPath.length);
			//trace( "loading next resource number",counter);
			//trace(sea3dString);
			_resize(null);
			
			var _sea3d:SEA3D = sea3dResources[counter]; 
			_sea3d.load(new URLRequest(sea3dString));
		}
		
		private function onProgress(e:SEAEvent):void
		{
			_imagePreloader.Update(e.progress);
		}
		
		private function onComplete(e:SEAEvent):void
		{	
			//trace(sea3dResourcesString[sea3dCounter]);
			if(sea3dCounter+1 == sea3dResources.length)
			{
				sea3dReady();//randomize
			}
			else
			{
				trace( "loading",sea3dResourcesString[sea3dCounter]);
				sea3dCounter++;
				handleSea3d(sea3dCounter);
			}
		}
		
		private function sea3dReady(): void
		{	
			//initialize3d();//not needed here, camera 3-D is initialized in STATES
			//STEP 5
			initStarling();
		}
		
		/*public static function initialize3d(): void
		{
			away3dView.camera = new Camera3D;
			var len :LensBase = new OrthographicLens();
			//var len :LensBase = new PerspectiveLens();
			away3dView.camera.lens = len;
			//(away3dView.camera.lens as PerspectiveLens).fieldOfView = 12;
			//away3dView.camera.rotation = new Vector3D(180,0,0);
		}*/
		
		/*private function onOnOffDone(e:AnimationStateEvent):void
		{			
			 if ( saberOn == false )
			 {
				 animatorClass.play("pause2", new CrossfadeTransition(.3));
			 }
			 else 
			 {
				 animatorClass.play("single_saber_melee_idle", new CrossfadeTransition(.3));				 
			 }
		}

		private function onSlashingDone(e:AnimationStateEvent):void
		{			
			animatorClass.play("single_saber_melee_idle", new CrossfadeTransition(.3));
		}*/
		
		/**
		 * Initialise the Starling sprites
		 */
		private function initStarling() : void
		{
			//removing the Sea 3-D loading message
			for (var i:uint = 0; i < stage.numChildren; i++)
				if(stage.getChildAt(i).toString().indexOf("Trivia") != -1)
					stage.removeChild(stage.getChildAt(i));
			
			new OnScreenTrivia(stage, "Loading Map Images");

			/*newX = stage.stageWidth/2;
			newY = stage.stageHeight/2;
			MAP.midX = newX;
			MAP.midY = newY;*/

			imageMapCounter = currentMapImagesVector.length;
			/*for (var i:uint=0;i<currentMapImagesVector.length;i++)
			{
				_loadMapImage(currentMapImagesVector[i], i);
			}*/
			
			_loadMapImage(currentMapImagesVector[0], 0);
		}
		
		private function _loadMapImage(name:String, counter:int):void
		{
			var MapImagePath:String;
			var MapImageSize:int;
			var mapImageLoader:YddAv3gLsRgP;
			var OnMapImageProgress:*;
			var OnMapImageComplete:*;
			
			OnMapImageProgress = function (arg1:Number):void
			{
				_imagePreloader.Update(arg1 / 1);
				//trace(name, arg1*100, "percent loaded");
				return;
			}
			OnMapImageComplete = function ():void
			{
				if ( counter < 16)	currentMapImagesArray.push(mapImageLoader.GetBitmap());
				else	currentMapPathImagesArray.push(mapImageLoader.GetBitmap());
				
				 //trace( counter);
				counter++;
				if ( counter < 32) 	_loadMapImage(currentMapImagesVector[counter], counter);
				//_imagePreloader.Update(1);
				--imageMapCounter;
				//trace(imageMapCounter, " images left to load");
				if (imageMapCounter == 0) 
				{
					//removing the  images loading message
					for (var i:uint = 0; i < stage.numChildren; i++)
						if(stage.getChildAt(i).toString().indexOf("Trivia") != -1)
							stage.removeChild(stage.getChildAt(i));
					
					new OnScreenTrivia(stage, "Please wait...");
					
					//setting map ID  to 1
					MAP.mapID = currentMap;
					
					Starling.multitouchEnabled = true;
					
					starlingMenu = new Starling(StarlingMenuSprite, stage, stage3DProxy.viewPort, stage3DProxy.stage3D);
					starlingFront = new Starling(StarlingFrontSprite, stage, stage3DProxy.viewPort, stage3DProxy.stage3D);
					starlingCharacterCreation= new Starling(StarlingCharacterCreationSprite, stage, stage3DProxy.viewPort, stage3DProxy.stage3D);
					starlingIntro = new Starling(StarlingIntroSprite, stage, stage3DProxy.viewPort, stage3DProxy.stage3D);
					
					/*//reposition the map squares so that the starting playerClass square is right under the playerClass in the middle of the screen -this is done manually and it's a cheat
					for (var i:uint = 0; i < MAP.squares.length; i++)
					{
					MAP.squares[i].x = MAP.squares[i].x - MAP.startX + stage.stageWidth/2 - MAP.squares[i].clip.width/2;
					MAP.squares[i].y = MAP.squares[i].y - MAP.startY + stage.stageHeight/2 - MAP.squares[i].clip.height/2;
					}*/
					
					//STEP 6 -this should be the last step as it's the one that actually renders  Starling and away 3-D  layers
					trace( "initializing listeners");
					initListeners();
				}
				return;
			}
			MapImagePath = _manifest.LookupFile(name);
			MapImageSize = _manifest.LookupSize(name);
			mapImageLoader = new YddAv3gLsRgP(MapImagePath, MapImageSize);
			mapImageLoader.Load(OnMapImageComplete, OnMapImageProgress);
			_resize(null);
			return;
		}

		/**
		 * Set up the rendering processing event listeners
		 */
		private function initListeners() : void {
			//addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			//addEventListener(MouseEvent.MOUSE_UP, onMouseUp);

			stage.addEventListener(MouseEvent.CLICK, onMouseClick);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			stage3DProxy.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			STATES.handleStates("menuState");
			//HideBootloader();
		}
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			keyState[e.keyCode] = true;
		}
		
		private function onKeyUp(e:KeyboardEvent):void
		{
			delete keyState[e.keyCode];
			alreadyPressed = false;
		}
		
		public static function getKeyState(code:int):Boolean
		{
			return keyState[code];
		}
		
		/**
		 * The main rendering loop
		 */
		private function onEnterFrame(event : Event) : void 
		{
			if (MAP.allCharacters.length>0) CHARACTERS.updateCharacters(MAP.allCharacters);
			
			if (INTRO.intro && !introState)
			{
				STATES.handleStates("introState");
				INTRO.ShortTimer();
				INTRO.intro = false;
			}
			
			// Render the Starling animation layer
			if(characterCreationState)	
			{
				starlingCharacterCreation.nextFrame();
				//starlingFront.nextFrame();
				away3dView.render();
				if(isCharacterCreation)
				{
					//default player male human guardian core
					var player:Character = new Character(0,false);
					player.gender = Gender.MALE;
					player.race = Race.HUMAN;
					player.classes = Classes.GUARDIAN;
					player.origin = Origins.CORE;
					//trace( "setting the player Main.playerCharacter to",Gender.genderString(Main.playerCharacter.genderId), Race.raceString(Main.playerCharacter.raceId), Classes.classString(Main.playerCharacter.classes));
					playerParty.members.splice(0,1);
					playerParty.members.push( player);//this is the first default
					if(player.avatar == null)
						var avatar: Avatar = new Avatar( player, true);
					avatar.setAvatar(player);
					isCharacterCreation=false;
				}
			}
			else if(menuState)			 
			{
				starlingMenu.nextFrame();
				//starlingFront.nextFrame();
				away3dView.render();
				if(isMenu)
				{
					var randomCharacter:Character = new Character(0, false);
					playerParty.members.push(randomCharacter);//randomize
					//this is not really needed, but is used to listen to skip the intro
					MAP.allCharacters.push(randomCharacter);
					if( randomCharacter.avatar == null)	var randomAvatar:Avatar = new Avatar(randomCharacter, true);
					randomAvatar.randomAvatar(randomCharacter);
					
					isMenu=false;
				}
			}
			else if(gameState)			
			{
				//all game related operations happen here
				
				/*//if the active character wants to initiate the conversation with an NPC that is further away, first, it needs to get closer to it
				if(activePlayerCharacter.currentTarget != null && activePlayerCharacter.currentTarget.dialog != -1)		
				{
					if(activePlayerCharacter.action != Action.MOVE)
						activePlayerCharacter.action = Action.MOVE;
					MOVEONMAP.moving(activePlayerCharacter.endPoint.x,activePlayerCharacter.endPoint.y);
				}*/
				
				for each(var character: Character in Main.MAP.allCharacters)
				{	
					if(character.actions[0] == Action.MOVE)
						MOVEONMAP.updatingMapPosition(character);
				}
				
				//starlingMap.nextFrame();
				away3dView.render();
				starlingFront.nextFrame();
			}
			else if(introState)			starlingIntro.nextFrame();
			else  trace( "no defined state");//this should never happen
		}

		//TO DO what a hack this is, I need to learn how to make it better. :-)
		public static function pathTilesListeners(): void
		{
			MAIN.pathListeners();
		}
		
		//TO DO what is the best naming convention
		public function pathListeners(): void
		{
			for(var i:int=0;i<mapTilesPath.numChildren;i++)
			{
				var pathTile: Mesh = mapTilesPath.getChildAt(i) as Mesh;
				pathTile.mouseEnabled = true;
				pathTile.addEventListener(MouseEvent3D.CLICK, onMouse3DClick);
			}
		}
		
		private function onMouse3DClick( event:MouseEvent3D): void
		{
			//TO DO currently destination vector is extrapolated from mouse coordinates on the  2-D stage, maybe we don't need them at all
			var material:TextureMaterial = ((event.currentTarget as Mesh).material as TextureMaterial);
			var texture:BitmapTexture = material.texture as BitmapTexture;
			var bitmapData:BitmapData = texture.bitmapData;

			var _x:int = event.localPosition.x + 512;
			var _y:int = - event.localPosition.z + 512;
			trace(event.localPosition,bitmapData.getPixel(_x,_y).toString(16),_x,_y);
			if(bitmapData.getPixel(_x,_y).toString(16) == "ff00")
			{
				//check against only party members
				for each( var partyMember: Character in playerParty.members)
				{
					if(partyMember.selected == true)
					{
						if (!suspendState)
						{
							//clear the target character and  actions queue
							if(partyMember.targetCharacter != null)
								partyMember.targetCharacter = null;
							partyMember.actions = [];
							
							//compute a vector 3-D destination based on current active player position and 2-D mouse stage coordinates
							partyMember.destinationVector = O2D.c2D3D();
							
							partyMember.actions.unshift(Action.MOVE);
						}
					}
				}
			}
			//trace( "main 3-D click on tiles");
		}
		
		private function onMouseClick( event:MouseEvent): void
		{
			if (gameState == true)
			{
				//trace( "2-D click on stage.");
				O2D.point = new Point( event.stageX, event.stageY);
			}
		}
		
		/**
		 * Internal functions
		 */
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
		
		private function _resources():void
		{
			--_imageCounter;
			if (_imageCounter == 0) 
			{
				//STEP 3
				initResources();
			}
			return;
		}
		public static function hideBootloader(): void
		{
			MAIN.HideBootloader();
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
			
			for (i = 0; i < stage.numChildren; i++)
				trace(stage,stage.getChildAt(i),i);
			
			//STATES.handleStates("menuState");
			return;
		}
		
		public static function get selectedCharacter(): Character
		{
			var partyMember: Character; 
			for (var i:int=0;i<playerParty.members.length;i++)
			{
				partyMember = playerParty.members[i];
				if(partyMember.selected = true)
				{
					//set the adjust camera position for future use
					var adjustment:int;
					if(partyMember.gender == Gender.FEMALE || partyMember.gender == Gender.MALE)
					{
						adjustment = Main.MAP3D.adjust(Gender.genderString(partyMember.gender));
						Main.MAP3D.adjustCamera = new Vector3D(0,Math.round(adjustment*Main.MAP3D.say),-Math.round(adjustment*Main.MAP3D.caz));
					}
					//TO DO get the adjustment when the character is not female or male humanoid
					return partyMember;
				}
			}
			//if for some reason no party members are selected,then fall back on the member at index zero
			return playerParty.members[0];//but this should never happen
		}
	}
}