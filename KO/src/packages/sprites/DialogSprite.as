package packages.sprites
{
	import flash.geom.Point;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.*;
	import starling.text.TextField;
	import starling.utils.HAlign;
	
	public class DialogSprite extends Sprite
	{
		public var backgroundSprite:Sprite = new Sprite;
		public var wheelSprite: Sprite = new Sprite;
		public var textSprites: Sprite = new Sprite;
		public var textReferenceSprites: Sprite = new Sprite;
		
		public function DialogSprite()
		{
			this.addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
		}
		
		public function addedToStageHandler(event:Event ):void
		{
			this.removeEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
			
			//add background  wheel
			var backgroundImage:Image = new Image(Assets.getAtlas("DIALOG").getTexture("Wheel_Base"));
			backgroundSprite.addChild(backgroundImage);
			addChild(backgroundSprite);
		
			var prtSprite: Sprite = new Sprite;
			var pltSprite: Sprite = new Sprite;
			var prmSprite: Sprite = new Sprite;
			var plmSprite: Sprite = new Sprite;
			var prbSprite: Sprite = new Sprite;
			var plbSprite: Sprite = new Sprite;
			var pActiveSprite: Sprite = new Sprite;
			
			var pActiveImage:Image = new Image(Assets.getAtlas("DIALOG").getTexture("Reference"));
			pActiveSprite.addChild(pActiveImage);
			pActiveSprite.x = 127.5;
			pActiveSprite.y = 0;
			pActiveSprite.name= "ACTIVE_REFERENCE";
			pActiveSprite.visible = false;
			textReferenceSprites.addChild(pActiveSprite);
			
			var prtImage:Image = new Image(Assets.getAtlas("DIALOG").getTexture("Reference"));
			prtSprite.addChild(prtImage);
			prtSprite.x = 232;
			prtSprite.y = -8;
			prtSprite.name= "RT_REFERENCE";
			prtSprite.visible = false;
			textReferenceSprites.addChild(prtSprite);
			
			var prmImage:Image = new Image(Assets.getAtlas("DIALOG").getTexture("Reference"));
			prmSprite.addChild(prmImage);
			prmSprite.x = 242;
			prmSprite.y = 30;
			prmSprite.name= "RM_REFERENCE";
			prmSprite.visible = false;
			textReferenceSprites.addChild(prmSprite);
			
			var prbImage:Image = new Image(Assets.getAtlas("DIALOG").getTexture("Reference"));
			prbSprite.addChild(prbImage);
			prbSprite.x = 237;
			prbSprite.y = 85;
			prbSprite.name= "RB_REFERENCE";
			prbSprite.visible = false;
			textReferenceSprites.addChild(prbSprite);
			
			var pltImage:Image = new Image(Assets.getAtlas("DIALOG").getTexture("Reference"));
			pltSprite.addChild(pltImage);
			pltSprite.x = 22;
			pltSprite.y = -8;
			pltSprite.name= "LT_REFERENCE";
			pltSprite.visible = false;
			textReferenceSprites.addChild(pltSprite);
			
			var plmImage:Image = new Image(Assets.getAtlas("DIALOG").getTexture("Reference"));
			plmSprite.addChild(plmImage);
			plmSprite.x = 12;
			plmSprite.y = 30;
			plmSprite.name= "LM_REFERENCE";
			plmSprite.visible = false;
			textReferenceSprites.addChild(plmSprite);
			
			var plbImage:Image = new Image(Assets.getAtlas("DIALOG").getTexture("Reference"));
			plbSprite.addChild(plbImage);
			plbSprite.x = 17;
			plbSprite.y = 85;
			plbSprite.name= "LB_REFERENCE";
			plbSprite.visible = false;
			textReferenceSprites.addChild(plbSprite);
			
			addChild(textReferenceSprites);
			
			var rtSprite: Sprite = new Sprite;
			var ltSprite: Sprite = new Sprite;
			var rmSprite: Sprite = new Sprite;
			var lmSprite: Sprite = new Sprite;
			var rbSprite: Sprite = new Sprite;
			var lbSprite: Sprite = new Sprite;
			
			//right top side
			var rtbImage:Image = new Image(Assets.getAtlas("DIALOG").getTexture("RT_Base"));
			rtbImage.name = "RT_Base";
			rtbImage.x = 20.5;
			rtbImage.y = -3;
			var rthImage:Image = new Image(Assets.getAtlas("DIALOG").getTexture("RT_Highlight"));
			rthImage.name = "RT_Highlight";
			rthImage.visible= false;
			rtSprite.addChild(rtbImage);
			rtSprite.addChild(rthImage);
			rtSprite.x = 120;
			rtSprite.y = -4.5;
			rtSprite.name= "RT";
			rtSprite.visible = false;
			wheelSprite.addChild(rtSprite);
			
			//left top side
			var ltbImage:Image = new Image(Assets.getAtlas("DIALOG").getTexture("LT_Base"));
			ltbImage.name = "LT_Base";
			ltbImage.x = -10;
			ltbImage.y = -0.5;
			var lthImage:Image = new Image(Assets.getAtlas("DIALOG").getTexture("LT_Highlight"));
			lthImage.name = "LT_Highlight";
			lthImage.visible= false;
			ltSprite.addChild(ltbImage);
			ltSprite.addChild(lthImage);
			ltSprite.x = 19.5;
			ltSprite.y = -5;
			ltSprite.name= "LT";
			ltSprite.visible = false;
			wheelSprite.addChild(ltSprite);
			
			//right middle side
			var rmbImage:Image = new Image(Assets.getAtlas("DIALOG").getTexture("RM_Base"));
			rmbImage.name = "RM_Base";
			rmbImage.x = 30;
			rmbImage.y = 22.5;
			var rmhImage:Image = new Image(Assets.getAtlas("DIALOG").getTexture("RM_Highlight"));
			rmhImage.name = "RM_Highlight";
			rmhImage.visible= false;
			rmSprite.addChild(rmbImage);
			rmSprite.addChild(rmhImage);
			rmSprite.x = 138.5;
			rmSprite.y = 11;
			rmSprite.name= "RM";
			rmSprite.visible = false;
			wheelSprite.addChild(rmSprite);
			
			//left middle side
			var lmbImage:Image = new Image(Assets.getAtlas("DIALOG").getTexture("LM_Base"));
			lmbImage.name = "LM_Base";
			lmbImage.x = 19;
			lmbImage.y = 20.5;
			var lmhImage:Image = new Image(Assets.getAtlas("DIALOG").getTexture("LM_Highlight"));
			lmhImage.name = "LM_Highlight";
			lmhImage.visible= false;
			lmSprite.addChild(lmbImage);
			lmSprite.addChild(lmhImage);
			lmSprite.x = 3.5;
			lmSprite.y = 11;
			lmSprite.name= "LM";
			lmSprite.visible = false;
			wheelSprite.addChild(lmSprite);
			
			//right bottom side
			var rbbImage:Image = new Image(Assets.getAtlas("DIALOG").getTexture("RB_Base"));
			rbbImage.name = "RB_Base";
			rbbImage.x = 22;
			rbbImage.y = 20;
			var rbhImage:Image = new Image(Assets.getAtlas("DIALOG").getTexture("RB_Highlight"));
			rbhImage.name = "RB_Highlight";
			rbhImage.visible= false;
			rbSprite.addChild(rbbImage);
			rbSprite.addChild(rbhImage);
			rbSprite.x = 113.5;
			rbSprite.y = 51;
			rbSprite.name= "RB";
			rbSprite.visible = false;
			wheelSprite.addChild(rbSprite);
			
			//left bottom side
			var lbbImage:Image = new Image(Assets.getAtlas("DIALOG").getTexture("LB_Base"));
			lbbImage.name = "LB_Base";
			lbbImage.x = -10;
			lbbImage.y = 20.5;
			var lbhImage:Image = new Image(Assets.getAtlas("DIALOG").getTexture("LB_Highlight"));
			lbhImage.name = "LB_Highlight";
			lbhImage.visible= false;
			lbSprite.addChild(lbbImage);
			lbSprite.addChild(lbhImage);
			lbSprite.x = 17;
			lbSprite.y = 51.5;
			lbSprite.name= "LB";
			lbSprite.visible = false;
			wheelSprite.addChild(lbSprite);
			
			addChild(wheelSprite);
			
			addChild(textSprites);
		}
		
		public function getGlobal(sprite:Sprite):Point
		{
			var p:Point = localToGlobal(new Point(sprite.x,sprite.y));
			return p;
		}
	}
}