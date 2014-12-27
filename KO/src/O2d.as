// TO DO Generalize  mouse word usage, maybe get mesh bounds as well
package
{
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Vector3D;
    
    import away3d.tools.utils.Bounds;
    
    import feathers.controls.Button;
    
    import packages.characters.Character;
    
    import starling.display.Image;
    import starling.display.Quad;
    import starling.display.Sprite;
    import starling.rootsprites.StarlingFrontSprite;
    import starling.text.TextField;
    import starling.textures.GradientTexture;
    import starling.textures.Texture;
    
    public class O2d extends Object
    {
		public var point:Point = new Point;
		
		public function O2d()
		{
			return;
		}
		
		public function gradient(w:int,h:int,tx:Number=0,ty:Number=0):Texture
		{
			var bgMatrix:Matrix = new Matrix();
			var boxRotation:Number = 0;// Math.PI/2; // 90� Rotation value in radians, in photoshop the angle was set to 90 degrees for me, 0 might be fine for you.
			//width,height,angle,offsetX,offsetY
			bgMatrix.createGradientBox(w, h, boxRotation, tx, ty);
			
			var bgGradientTexture:Texture = GradientTexture.create(
				w, 	//Define Width and Height to draw to, if less than defined in bgMatrix will clip the gradient
				h,
				"linear", 	//Gradient type
				[0x0a1c28, 0x235067], //Colours
				[1, 1], 	//Alpha values 0-1
				[0, 255], 	//Ratio, where the colour is input into the gradient space, 0 left, 255 right, can be placed anywhere between
				bgMatrix) 	//Matrix to use, optional but gives finer control of the gradient appearance
			return bgGradientTexture;
		}
		
		public function displayName( character:Character): void
		{
			var _textSize:int = 14;
			var _textWidth:int = character.characterName.length*_textSize*3/4;
			var _textHeight:int = Math.ceil(_textSize*1.5);
			var _text:TextField = new TextField(_textWidth,_textHeight,character.characterName, "Helvetica", _textSize, 0xddcba2);
			var _image:Image = new Image(Main.O2D.gradient(_textWidth,_textHeight));
			var _sprite:Sprite = new Sprite;
			
			_sprite.name = "displayName";
			_sprite.addChild(_image);
			_sprite.addChild(_text);
			
			Bounds.getObjectContainerBounds(character.avatar.characterClass);
			var _h:int=Math.round(Bounds.height);
			
			var p: Point = c3D2D( character.routeVector);
			
			_sprite.x = p.x - _textWidth/2;
			_sprite.y = p.y - _h;
			
			StarlingFrontSprite.getInstance().addChild(_sprite);
			if( character.dialog != -1)		 displayDialog( character);
			//trace("OVER", character.avatar.characterName, character.cells[0].gridC, character.cells[0].gridR,_sprite.x,_sprite.y);			
		}
		
		public function displayDialog( character:Character): void
		{
			var _iDialog:Image = new Image(Assets.getAtlas("SPECIALS").getTexture("dialog_icon"));
			_iDialog.width = _iDialog.height = 32;
			
			var _sprite:Sprite = new Sprite;
			_sprite.name = "displayDialog";
			_sprite.addChild(_iDialog);
			
			Bounds.getObjectContainerBounds(character.avatar.characterClass);
			var _h:int=Math.round(Bounds.height);
			
			var p: Point = c3D2D( character.routeVector);
			
			//_sprite.x = character.cells[0].x - _iDialog.width/2;
			//_sprite.y = character.cells[0].y - 90 - _iDialog.height;
			_sprite.x = p.x - _iDialog.width/2;
			_sprite.y = p.y - _h - _iDialog.height;
			
			StarlingFrontSprite.getInstance().addChild(_sprite);
		}
		
		public function removeSprites(): void
		{
			var _child:*=StarlingFrontSprite.getInstance().getChildByName("displayDialog");
			if(_child)		StarlingFrontSprite.getInstance().removeChild(_child);
			_child=StarlingFrontSprite.getInstance().getChildByName("displayName");
			if(_child)		StarlingFrontSprite.getInstance().removeChild(_child);
			_child=StarlingFrontSprite.getInstance().getChildByName("mouseWord");
			if(_child)		StarlingFrontSprite.getInstance().removeChild(_child);
			/*for(var f:int=0;f<StarlingFrontSprite.getInstance().numChildren;f++)
			{
				var _child:*=StarlingFrontSprite.getInstance().getChildAt(f);
				trace(_child.name);
				if(_child.name == "displayName" || _child.name == "displayDialog")
				{
					StarlingFrontSprite.getInstance().removeChild(_child);
				}
			}*/
			//trace("OUT", character.avatar.characterName);
		}
		
		public function disableButton( button:Button, padding:int=0): void
		{
			var child:* = button.getChildByName( "disabled");
			if(button.isEnabled == false)
			{
				if(! child)
				{
					var plainQuad:Quad = new Quad(button.defaultSkin.width, button.defaultSkin.height,0x000000);
					plainQuad.x = padding;
					plainQuad.y = padding;
					plainQuad.alpha = 0.75;
					plainQuad.name = "disabled";
					//plainQuad.visible = false;
					button.addChild(plainQuad);
				}
				else trace("button already disabled");
			}
			else
			{
				if(child)	
				{
					button.removeChild( child);	
				}
			}
		}
		
		public function unlockAbilitiesButton( button:Button, padding:int=0): void
		{
			var child:* = button.getChildByName( "disabled");
			if(button.isToggle == false)
			{
				if(! child)
				{
					var plainQuad:Quad = new Quad(button.defaultSkin.width, button.defaultSkin.height,0x000000);
					plainQuad.x = padding;
					plainQuad.y = padding;
					plainQuad.alpha = 0.75;
					plainQuad.name = "disabled";
					//plainQuad.visible = false;
					button.addChild(plainQuad);
				}
				else trace("button already disabled");
			}
			else
			{
				if(child)	
				{
					button.removeChild( child);	
				}
			}
		}
		
		public function showMouseWord(string:String): void
		{
			var _textSize:int = 14;
			var _textWidth:int = string.length*_textSize*3/4;
			var _textHeight:int = Math.ceil(_textSize*1.5);
			var _text:TextField = new TextField(_textWidth,_textHeight, string, "Helvetica", _textSize, 0xddcba2);
			var _image:Image = new Image(Main.O2D.gradient(_textWidth,_textHeight));
			var _sprite:Sprite = new Sprite;
			_sprite.name = "mouseWord";
			_sprite.addChild(_image);
			_sprite.addChild(_text);
			StarlingFrontSprite.getInstance().addChild(_sprite);
		}
		
		//convert 2-D point to 3-D coordinates
		public function c2D3D(p:Point=null,v:Vector3D=null):Vector3D
		{
			if(p == null)	p=point;
			if(v == null)
			{
				for each( var partyMember: Character in Main.playerParty.members)
				{
					if(partyMember.selected == true)
					{
						v = partyMember.avatar.characterClass.position;
					}
				}
			}
			
			var relativeX: Number = (Main.APP_WIDTH/2 - p.x) + v.x;
			var relativeY: Number = (Main.APP_HEIGHT/2 - p.y) * Main.MAP3D.say + v.y;
			var relativeZ: Number = -(Main.APP_HEIGHT/2 - p.y) * Main.MAP3D.caz + v.z;
			var vector3d: Vector3D = new Vector3D(relativeX, relativeY, relativeZ);
			return vector3d;
		}
		
		//convert 3-D coordinates to 2-D point
		public function c3D2D(v:Vector3D):Point
		{
			var p: Point = new Point;
			var middle: Vector3D = new Vector3D;
			for each( var partyMember: Character in Main.playerParty.members)
			{
				if(partyMember.selected == true)
				{
					middle = partyMember.avatar.characterClass.position;
				}
			}
			var _x: int = Math.round(-(v.x - middle.x - Main.APP_WIDTH/2));
			var _y: int = Math.round(-((v.y - middle.y - Main.APP_HEIGHT/2*Main.MAP3D.say)/Main.MAP3D.say));
			p = new Point(_x,_y);
			return p;
		}
	}
}