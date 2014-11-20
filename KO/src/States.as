package
{
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.LensBase;
	import away3d.cameras.lenses.OrthographicLens;
	//import away3d.cameras.lenses.PerspectiveLens;
	
	import flash.geom.Vector3D;
	
	import packages.audio.GameMusic;
	
	import sunag.sea3d.SEA3D;
	
    public class States
    {
		private var len :LensBase = new OrthographicLens();
		private var minusZ: Number;
		private var minusZHypotenuse: Number;
		private var fov:int;
		private var camera:Camera3D;
		
		public function States()
        {
            trace(" States");
        }
		
		public function handleStates(state: String): void
		{
			var setMusic:*;
			switch(state)
			{
				case "characterCreationState":
				{
					Main.starlingCharacterCreation.start();
					Main.starlingFront.stop(true);
					Main.starlingIntro.stop(true);
					Main.starlingMenu.stop(true);
					setMusic = new GameMusic("MAINMUSIC", true);
					Main.introState = false;
					Main.suspendState = false;
					Main.gameState = false;
					Main.characterCreationState = true;
					Main.isCharacterCreation = true;
					Main.menuState = false;
					trace("character creation State On");
					
					Main.away3dView.camera = new Camera3D;
					Main.away3dView.camera.lens = len;
					
					Main.away3dView.camera.position = new Vector3D(0, 0, minusZHypotenuse);
					Main.away3dView.camera.lookAt(new Vector3D(0,0,0));
					
					break;
				}
				case "menuState":
				{
					//Start and stop various stage3d layers
					Main.starlingCharacterCreation.stop(true);
					Main.starlingFront.stop(true);
					Main.starlingIntro.stop(true);
					Main.starlingMenu.start();
					
					//set music
					setMusic = new GameMusic("MAINMUSIC", true);
					
					//set stage dimension
					if(Main.APP_WIDTH==0)	 Main.APP_WIDTH = Main.gameStage.stageWidth;
					if(Main.APP_HEIGHT==0)	 Main.APP_HEIGHT = Main.gameStage.stageHeight;
					
					//set states
					Main.introState = false;
					Main.suspendState = false;
					Main.gameState = false;
					Main.characterCreationState = false;
					Main.menuState = true;
					Main.isMenu = true;
					
					//set ratio, if needed
					Main.aspectRatio = Main.APP_WIDTH / Main.APP_HEIGHT;
					Main.reverseAspectRatio = Main.APP_HEIGHT / Main.APP_WIDTH;
					
					//set camera
					Main.away3dView.camera = new Camera3D;
					Main.away3dView.camera.lens = len;
					
					fov = 60;//25=338; 60=323
					//(Main.away3dView.camera.lens as PerspectiveLens).fieldOfView = fov;
					minusZ = Math.ceil((Main.APP_HEIGHT * 0.5) / Math.tan((Math.PI / 180) * (fov * 0.5)));
					minusZHypotenuse = Math.ceil(Math.sqrt((Main.APP_HEIGHT * Main.APP_HEIGHT) + (minusZ * minusZ)));
					Main.away3dView.camera.position = new Vector3D(0, Main.APP_HEIGHT, minusZHypotenuse);
					Main.away3dView.camera.rotation = new Vector3D(-323,180,0);
					//Main.away3dView.camera.lookAt( new Vector3D);
					//trace(Main.away3dView.camera.position,Main.away3dView.camera.rotation);
					(Main.away3dView.camera.lens as OrthographicLens).projectionHeight = Main.APP_HEIGHT;
					Main.cameraPosition = Main.away3dView.camera.position;
					camera = Main.away3dView.camera;
					
					//move source geometry out of view
					for( var j:int=0;j<Main.sea3dResourcesString.length;j++)
					{
						if( Main.sea3dResourcesString[j].indexOf("weapon_") != -1 ||
							Main.sea3dResourcesString[j].indexOf("mesh_") != -1)
						{
							var sea3d:SEA3D = Main.sea3dResources[j];
							Main.MOVEONMAP.positionOriginalMeshes(sea3d);
						}
					}
					
					trace("menu State On");
					break;
				}
				case "introState":
				{
					Main.starlingCharacterCreation.stop(true);
					Main.starlingFront.stop(true);
					Main.starlingIntro.start();
					Main.starlingMenu.stop(true);
					setMusic = new GameMusic("SILENTMUSIC", true);
					Main.introState = true;
					Main.suspendState = false;
					Main.gameState = false;
					Main.characterCreationState = false;
					Main.menuState = false;
					trace("intro State On");
					break;
				}
				case "gameState":
				{
					Main.starlingCharacterCreation.stop(true);
					Main.starlingFront.start();
					Main.starlingIntro.stop(true);
					Main.starlingMenu.stop(true);
					
					setMusic = new GameMusic("MAINMUSIC", true);
					
					Main.introState = false;
					Main.suspendState = false;
					Main.gameState = true;
					Main.characterCreationState = false;
					Main.menuState = false;
					
					Main.away3dView.camera = new Camera3D;
					Main.away3dView.camera.lens = len;
					
					Main.away3dView.camera = camera;
					
					trace("game State On");
					break;
				}
			}
		}
		
		public function randomNumber(low:Number=0, high:Number=1):Number
		{
			return Math.floor(Math.random() * (1+high-low)) + low;
		} 
	}
}