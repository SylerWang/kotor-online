package starling.rootsprites
{
	import feathers.controls.Button;
	
	import flash.geom.Point;
	
	import packages.dialog.DialogLogic;
	import packages.gui.AbilitiesLogic;
	import packages.gui.QuickBarLogic;
	import packages.sprites.AbilitiesSprite;
	import packages.sprites.DialogSprite;
	import packages.sprites.QuickBarSprite;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.*;
	import starling.text.TextField;

	public class StarlingFrontSprite extends Sprite
	{
		private static var _instance : StarlingFrontSprite;
		
		public var dialogLogic:DialogLogic;
		public var dialogSprite:DialogSprite = new DialogSprite;
		
		public var bars: Sprite = new Sprite;
		public var quickBarLogic:QuickBarLogic;
		public var quickBarSprite:QuickBarSprite = new QuickBarSprite;
		
		public var abilitiesLogic:AbilitiesLogic;
		public var abilitiesSprite:AbilitiesSprite = new AbilitiesSprite;
		private var abilitiesWindow: Boolean = false;
		
		//variables to check various things
		public var previousPhase: String = "";
		public var previousEventTarget:DisplayObject;
		public var draggedIcon:Image = null;
		public var dragging: Boolean = false;
		
		public static function getInstance():StarlingFrontSprite
		{
			return _instance;
		}
		
		/**
		 * Constructor.
		 */
		public function StarlingFrontSprite()
		{
			_instance = this;
			//we'll initialize things after we've been added to the stage
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		/**
		 * Where the magic happens. Start after the main class has been added
		 * to the stage so that we can access the stage property.
		 */
		protected function addedToStageHandler(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			initialize();
		}
		
		public function initialize(): void
		{
			 trace( "Starling Front initialize");
			 
			 //create a fake invisible canvas to touch
			 var canvasQuad:Quad = new Quad(Main.APP_WIDTH,Main.APP_HEIGHT,0x000000);
			 canvasQuad.x = 0;
			 canvasQuad.y = 0;
			 canvasQuad.alpha = 0;
			 addChild(canvasQuad);

			 this.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		public function handleAbilities(): void
		{
			var child:* = getChildByName("Abilities");
			if(child)	removeChild(child);
			else
			{
				abilitiesSprite.name = "Abilities";
				abilitiesLogic = new AbilitiesLogic(abilitiesSprite);
				addChild(abilitiesSprite);
			}
			abilitiesWindow = !abilitiesWindow;
		}
		
		public function handleDialog(): void
		{
			dialogLogic = new DialogLogic(dialogSprite);
			addChild(dialogSprite);
		}
		
		public function handleBars(): void
		{
			quickBarLogic = new QuickBarLogic(quickBarSprite);
			bars.addChild(quickBarSprite);
			addChild(bars);
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touches:Vector.<Touch>;
			var touch: Touch = event.getTouch(this);
			if( touch)
			{
				//if event over quick bar or abilities window, etc., enables suspend state, so the player doesn't react to touches
				if(event.interactsWith(quickBarLogic.clip) == false && draggedIcon != null)
					Main.suspendState = true;
				else if(event.interactsWith(quickBarLogic.clip) == true || (abilitiesWindow == true && event.interactsWith(abilitiesLogic.clip) == true))
					Main.suspendState = true;
				else Main.suspendState = false;
				//move abilities window if onstage and  dragged/moved
				if(abilitiesWindow == true && event.interactsWith(abilitiesLogic.clip.movingBarSprite) == true)
				{
					touches = event.getTouches(this, TouchPhase.MOVED);
					if (touches.length == 1)
					{
						var delta:Point = touches[0].getMovement(parent);
						abilitiesLogic.clip.x += delta.x;
						abilitiesLogic.clip.y += delta.y;
						//Update window position for future reference
						Main.abilitiesWindowPosition.x = abilitiesLogic.clip.x;
						Main.abilitiesWindowPosition.y = abilitiesLogic.clip.y;
					}
				}
				//quick  bar related and if unlocked
				if(quickBarLogic.locked == false)
				{
					if(quickBarLogic.currentButton != null && (touch.globalX<quickBarLogic.clip.x+quickBarLogic.clip.slots[1].x || touch.globalX>quickBarLogic.clip.x+quickBarLogic.clip.slots[QuickBarLogic.MAX_SKILLS].x+quickBarLogic.clip.slots[1].defaultSkin.width || touch.globalY<quickBarLogic.clip.y+quickBarLogic.clip.slots[1].y || touch.globalY>quickBarLogic.clip.y+quickBarLogic.clip.slots[1].y+quickBarLogic.clip.slots[1].defaultSkin.height))
					{
						quickBarLogic.previousButton = quickBarLogic.currentButton;
						quickBarLogic.currentButton = null;
						//trace( "outside buttons area", touch.globalX, touch.globalY,quickBarLogic.currentButton,quickBarLogic.previousButton.label);
						quickBarLogic.clip.overFrameSprite.visible = false;
						quickBarLogic.clip.fakeEmptyButton.visible = false;
					}
					//if over quick bar and if over a button, then calculate  over which one
					if( event.target is Button && event.interactsWith(quickBarLogic.clip))
					{
						for( var i:int=0;i<QuickBarLogic.MAX_SKILLS;i++)
						{
							var index:int=i+1;
							var _x:int = quickBarLogic.clip.x + quickBarLogic.clip.slots[index].x;
							var _y:int = quickBarLogic.clip.y + quickBarLogic.clip.slots[index].y;
							var _xw:int = _x + quickBarLogic.clip.slots[1].defaultSkin.width;
							var _yh:int = _y + quickBarLogic.clip.slots[1].defaultSkin.height;
							if(touch.globalX > _x && touch.globalX < _xw && touch.globalY > _y && touch.globalY < _yh)
							{
								/*if(previousPhase != touch.phase)
								{
									if( touch.phase == "hover" && previousPhase == "ended")		 return;
									else
										trace( "phase changed while over button", (quickBarLogic.clip.slots[index] as Button).label,"is now", touch.phase, "and it was", previousPhase);
								}*/
								if(quickBarLogic.previousButton != quickBarLogic.clip.slots[index] as Button)
								{
									trace( "currently over button", (quickBarLogic.clip.slots[index] as Button).label);
									if(quickBarLogic.previousButton != null)	 trace("previous button was", quickBarLogic.previousButton.label);
									quickBarLogic.currentButton = quickBarLogic.clip.slots[index] as Button;
									
									if(quickBarLogic.startButton != null || draggedIcon != null)
									{
										quickBarLogic.alreadyIcon = quickBarLogic.getIconInSlot(quickBarLogic.currentButton);
										if(quickBarLogic.alreadyIcon != null)
										{
											quickBarLogic.clip.overFrameSprite.visible = true;
											quickBarLogic.clip.fakeEmptyButton.visible = false;
											quickBarLogic.clip.overFrameSprite.x = (quickBarLogic.clip.slots[index] as Button).x - quickBarLogic.clip.paddingPoint.x;
											quickBarLogic.clip.overFrameSprite.y = (quickBarLogic.clip.slots[index] as Button).y - quickBarLogic.clip.paddingPoint.y;
										}
										else
										{
											quickBarLogic.clip.fakeEmptyButton.visible = true;
											quickBarLogic.clip.overFrameSprite.visible = false;
											quickBarLogic.clip.fakeEmptyButton.x = (quickBarLogic.clip.slots[index] as Button).x;
											quickBarLogic.clip.fakeEmptyButton.y = (quickBarLogic.clip.slots[index] as Button).y;
											var fakeEmptyLabel:TextField = quickBarLogic.clip.fakeEmptyButton.getChildByName("fakeEmptyLabel") as TextField;
											if(fakeEmptyLabel)	fakeEmptyLabel.text = quickBarLogic.currentButton.label;
										}
									}
								}
							}
						}
					}
				}
				//handle phases and event targets
				if( touch.phase == "ended" && previousPhase == "began")
				{
					//trace( event.target);
					//handle abilities window clicks on arrows
					if(abilitiesWindow == true)
					{
						if(event.target is TextField && (event.target as TextField).name && (event.target as TextField).name.indexOf("arrow") != -1)
						{
							if((event.target as TextField).name == "arrowRight")
							{
								Main.activePlayerCharacter.activeAbilitiesType++;
								if(Main.activePlayerCharacter.activeAbilitiesType == Main.activePlayerCharacter.talents.length)	 Main.activePlayerCharacter.activeAbilitiesType = 0;
								abilitiesLogic.setAbilities();
								abilitiesLogic.setDetails();
							}
							else
							{
								Main.activePlayerCharacter.activeAbilitiesType--;
								if(Main.activePlayerCharacter.activeAbilitiesType == -1)	 Main.activePlayerCharacter.activeAbilitiesType = Main.activePlayerCharacter.talents.length-1;
								abilitiesLogic.setAbilities();
								abilitiesLogic.setDetails();
							}
						}
						//closing abilities window
						if(event.target is Quad && (event.target as Quad).name && (event.target as Quad).name == "abilitiesX")
							handleAbilities();
					}
					//if  clicking on the  lock button
					if(event.target is Image && (event.target as Image).name && (event.target as Image).name.indexOf("locked") != -1 && draggedIcon == null)
						quickBarLogic.handleLock();
					//quick  bar related and if unlocked
					if(quickBarLogic.locked == false)
					{
						//if clicking on the button while moving an icon (dragging state is handled somewhere else)
						if(quickBarLogic.currentButton != null)
						{
							if(draggedIcon != null)		dropOrSwap();
							//else return; //we handle button clicking on quick bar logic class
								//trace( "clicking", quickBarLogic.currentButton.label);
						}
						//if clicking outside buttons while having dragged icon, reset everything
						else if(quickBarLogic.currentButton == null && draggedIcon != null)
						{
							quickBarLogic.removeIcon(draggedIcon.name);
							removeChild(draggedIcon);
							draggedIcon = null;
							dragging = false;
							quickBarLogic.alreadyIcon = null;
							quickBarLogic.startButton = null;
							quickBarLogic.swapped = false;
						}
					}
				}
				if( touch.phase == "moved" && previousPhase == "began")
				{
					//quick  bar related and if unlocked
					if(quickBarLogic.locked == false)
					{
						if(quickBarLogic.currentButton != null)
						{
							quickBarLogic.alreadyIcon = quickBarLogic.getIconInSlot(quickBarLogic.currentButton);
							if(quickBarLogic.alreadyIcon == null)	return;
							else
							{
								trace( "dragging starts", quickBarLogic.currentButton.label);
								quickBarLogic.startButton = quickBarLogic.currentButton;
								if(draggedIcon != null)		quickBarLogic.swapped = true;
								dragging = true;
							}
						}
						//if dragging starts over abilities window
						//1010b_bad_abilities
					}
				}
				if( touch.phase == "ended" && previousPhase == "moved")
				{
					//quick  bar related and if unlocked
					if(quickBarLogic.locked == false)
					{
						if(quickBarLogic.currentButton != null)
						{
							trace( "dragging ended", quickBarLogic.currentButton.label);
							if(draggedIcon != null)		dropOrSwap();
						}
						else if(quickBarLogic.currentButton == null && draggedIcon != null)
						{
							//if dragging outside buttons while having dragged icon, reset everything
							quickBarLogic.removeIcon(draggedIcon.name);
							removeChild(draggedIcon);
							draggedIcon = null;
							dragging = false;
							quickBarLogic.alreadyIcon = null;
							quickBarLogic.startButton = null;
							quickBarLogic.swapped = false;
						}
					}
				}
				//quick  bar related and if unlocked
				if(quickBarLogic.locked == false)
				{
					//if start button is empty, then hide the fake button and/or the frame
					if((quickBarLogic.startButton == null && draggedIcon == null) && (quickBarLogic.clip.fakeEmptyButton.visible == true || quickBarLogic.clip.overFrameSprite.visible == true))
					{
						quickBarLogic.clip.fakeEmptyButton.visible = false;
						quickBarLogic.clip.overFrameSprite.visible = false;
					}
					//if dragging, and swapping true and it has a dragged icon, then swap
					if(dragging == true && draggedIcon != null && quickBarLogic.swapped)
					{
						quickBarLogic.alreadyIcon = quickBarLogic.getIconInSlot(quickBarLogic.currentButton);
						quickBarLogic.handleIcon(draggedIcon.name, quickBarLogic.alreadyIcon.name);
						quickBarLogic.swapped = false;
						quickBarLogic.alreadyIcon = null;
					}
					//if dragging, but no dragged icon, and the start button is not the current button, then create a dragged icon
					if( dragging == true && draggedIcon == null && quickBarLogic.startButton != quickBarLogic.currentButton)
					{
						for( var j:int=0;j<quickBarLogic.startButton.numChildren;j++)
						{
							var child:* = quickBarLogic.startButton.getChildAt(j);
							if( child.name)
							{
								if( child.name.indexOf("slot_") != -1)
								{
									draggedIcon = child as Image;
									draggedIcon.touchable = false;
									quickBarLogic.startButton.removeChild( child);
									addChild(draggedIcon);
								}
							}
						}	
					}
					//if there is a dragged icon on stage, make sure it follows the touch coordinates
					if(draggedIcon != null)	  
					{
						draggedIcon.x = touch.globalX;
						draggedIcon.y = touch.globalY;
					}
					/*//if( previousPhase != touch.phase || previousEventTarget != (event.target as DisplayObject))
					{
						if( event.target is Image)
						{
							var image: Image = event.target as Image;
							if( image.name)		trace( image.name);
						}
						if( event.target is  Button)
						{
							var button: Button = event.target as Button;
							if( button.label)	 trace( button.label);
						}
						trace( event.currentTarget, event.target, touch.globalX, touch.globalY, touch.phase);
					}*/
					//after all the drama, update the previous button for future reference
					quickBarLogic.previousButton = quickBarLogic.currentButton;
				}
				//same here, update the previous phase and the previous event target for future reference
				previousEventTarget = event.target as DisplayObject; 
				previousPhase = touch.phase;
			}
		}
		
		private function dropOrSwap(): void
		{
			quickBarLogic.alreadyIcon = quickBarLogic.getIconInSlot(quickBarLogic.currentButton);
			if(quickBarLogic.alreadyIcon == null)
			{
				trace( "drop on",quickBarLogic.currentButton.label);
				quickBarLogic.handleIcon(draggedIcon.name);
				removeChild(draggedIcon);
				draggedIcon = null;
				quickBarLogic.alreadyIcon = null;
				quickBarLogic.startButton = null;
				if(quickBarLogic.swapped == true)	quickBarLogic.swapped = false;
			}
			else
			{
				if(quickBarLogic.startButton != quickBarLogic.currentButton)
				{
					trace( "ending swap",quickBarLogic.currentButton.label);
					quickBarLogic.handleIcon(draggedIcon.name, quickBarLogic.alreadyIcon.name);
					//quickBarLogic.startButton = quickBarLogic.currentButton;
					quickBarLogic.swapped = true;
				}
			}
			dragging = false;
		}
	}
}