package packages.gui
{
	import feathers.controls.Button;
	
	import packages.sprites.MainMenuSprite;
	
	import starling.events.*;
	
    public class MainMenuLogic extends Object
    {
		public var clip:MainMenuSprite;
		
		public function MainMenuLogic(arg1:MainMenuSprite)
        {
			clip = arg1;
			clip.addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
			return;
		}
			
		public function addedToStageHandler( event: Event): void
		{
			clip.removeEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
			//rearrange
			var _x:int = 100;
			clip.backgroundSprite.x = _x;
			clip.backgroundSprite.y = Main.APP_HEIGHT - clip.backgroundSprite.height + 40*clip.buttons.length;
			
			clip.volumeSprite.visible = false;
			clip.volumeSprite.x = Main.APP_WIDTH - clip.volumeSprite.width - 15;
			clip.volumeSprite.y = 15;
			//clip.volumeSprite.useHandCursor = true;
			
			clip.logoSprite.x = 50;
			clip.logoSprite.y = 50;
			
			//buttons
			for( var i:int=0;i< clip.buttons.length;i++)
			{
				clip.buttons[i].addEventListener(Event.TRIGGERED, triggeredHandler);
				//clip.buttons[i].useHandCursor = true;
				clip.buttons[i].x = _x+5;
				clip.buttons[i].y = Main.APP_HEIGHT - clip.buttons[i].defaultSkin.height * (clip.buttons.length - i);
			}
		}
		
		private function triggeredHandler( event:Event): void
		{
			var button:Button= Button(event.currentTarget);
			if(button.label == "New Game")	startNewGame();
		}
		
		private function startNewGame(): void
		{
			trace( "Starting a new game");
			Main.INTRO.intro = true;
		}
	}
}