//TO DO currently The dialogue is a statically assigned, it needs to be dynamically evaluated based on dialogue ID from the character/NPC
//also consider adding a banter feature. :-)
package packages.dialog
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import packages.audio.GameSound;
	import packages.characters.Character;
	import packages.sprites.DialogSprite;
	
	import starling.display.Sprite;
	import starling.events.*;
	import starling.rootsprites.StarlingFrontSprite;
	import starling.text.TextField;
	import starling.utils.HAlign;
	 
	public class DialogLogic extends Object
	{
		private var clip:DialogSprite;
		private var dlgLoader:URLLoader = new URLLoader();
		private var talkLoader:URLLoader = new URLLoader();
		private var talkXml:XML = new XML;
		private var _textSize:int = 14;
		
		private var entryListStringRefArray: Array = new Array;
		private var entryListRepliesArray: Array = new Array;
		private var replyListStringRefArray: Array = new Array;
		private var replyListEntriesArray: Array = new Array;
		private var repliesOrder: Array = new Array;
		private var activeImagesSprites: Array = new Array;
		private var activeTextSprites: Array = new Array;
		private var activeEntry:int=0;
		private var previous: String = "";
		
		public function DialogLogic(sprite:DialogSprite)
		{
			//TO DO dynamic dialogue and talk XML files using variables
			//TO DO, adding quest or take action based on choices
			clip = sprite;
			clip.addEventListener(starling.events.Event.ADDED_TO_STAGE, addedToStageHandler );
			return;
		}
		
		public function addedToStageHandler( event:starling.events.Event): void
		{
			clip.removeEventListener(starling.events.Event.ADDED_TO_STAGE, addedToStageHandler );
			handleTalkXml();
			//handle the dialogue XML after the talk  XML was fully parsed or/and loaded
			addDialog();
		}
		
		public function handleTalkXml(): void
		{
			var urlTalk:URLRequest = new URLRequest("assets/xml/000_talk.xml");
			talkLoader.load(urlTalk);
			//TO DO MP3
			talkLoader.addEventListener(flash.events.Event.COMPLETE, onTalkLoad);
		}
		
		public function handleDlgXml(): void
		{
			var urlDlg:URLRequest = new URLRequest("assets/xml/000_dlg.xml");
			dlgLoader.load(urlDlg);
			//TO DO MP3
			dlgLoader.addEventListener(flash.events.Event.COMPLETE, onDlgLoad);
		}
		
		public function addDialog(): void
		{
			trace("adding dialog");
			//TO DO handle scale
			/*clip.scaleX = 1.5;
			clip.scaleY = 1.5;*/
			clip.backgroundSprite.x = clip.wheelSprite.x = clip.textSprites.x = clip.textReferenceSprites.x = Main.APP_WIDTH/2 - clip.backgroundSprite.width/2;
			clip.backgroundSprite.y = clip.wheelSprite.y = clip.textSprites.y = clip.textReferenceSprites.y = Main.APP_HEIGHT - clip.backgroundSprite.height;
			//trace(clip.x, clip.y);
			/*for( var i:int=0;i< clip.images_sprites.length;i++)
			{
				//trace( clip.images_sprites[i].name, clip.images_sprites[i].x+ clip.x, clip.images_sprites[i].y+ clip.y);
				for( var j:int=0;j< clip.images_sprites[i].numChildren;j++)
				{
					var _child:*=clip.images_sprites[i].getChildAt(j);
					//trace(_child.name,_child.name.substring(0,2));
				}
			}*/
		}
		
		public function onTalkLoad( event:flash.events.Event):void 
		{
			//this has to be public/private so we can be accessed from other functions
			talkXml = new XML(talkLoader.data);
			handleDlgXml();
		}
		
		public function onDlgLoad( event:flash.events.Event):void 
		{
			var dlgXml:XML = new XML(dlgLoader.data);
			parseDlgXml(dlgXml);
		}
		
		public function getString(i:int): String
		{
			var s: String = String(i);
			var stringList:XML =  talkXml.element.(@id==s)[0];
			return stringList.string;
		}
			
		public function parseDlgXml(dlgXml:XML): void
		{
			var fieldElements:XMLList = dlgXml.Field;
			
			//handle Entry List
			var entryList:XML = dlgXml.Field.(@Label=="EntryList")[0];
			var entryListElements:XMLList = entryList.Value;
			var entryListLength:int = entryListElements.length();
			for( var i:int=0;i<entryListLength;i++)
			{
				var entryListElement:XML = entryListElements[i];
				var entryListElementFields:XMLList = entryListElement.Field;
				var entryListElementText:XML = entryListElement.Field.(@Label=="Text")[0];
				entryListStringRefArray.push(parseInt(entryListElementText.Value.@StringRef));
				var repliesList:XML = entryListElement.Field.(@Label=="RepliesList")[0];
				var repliesListElements:XMLList = repliesList.Value;
				var repliesListLength:int = repliesListElements.length();
				var repliesListIndexArray: Array = new Array;
				if(repliesList.toString() == "")	 repliesListIndexArray.push(-1);
				else
				{
					for( var j:int=0;j<repliesListLength;j++)
					{
						var repliesListElement: XML = repliesListElements[j];
						if((repliesListElement.Field.(@Label=="Active").@Value) == "")
							repliesListIndexArray.push(parseInt(repliesListElement.Field.(@Label=="Index").@Value));
						else	//cr=condition_replies
						{
							var cr: String = (repliesListElement.Field.(@Label=="Active").@Value);
							if((repliesListElement.Field.(@Label=="Not").@Value) == "1")
							{
								if(Main.CONDITIONS[cr]==false)
									repliesListIndexArray.push(parseInt(repliesListElement.Field.(@Label=="Index").@Value));
							}
							else
							{
								if(Main.CONDITIONS[cr]==true)
									repliesListIndexArray.push(parseInt(repliesListElement.Field.(@Label=="Index").@Value));
							}
							
						}
					}
				}
				entryListRepliesArray.push(repliesListIndexArray);
			}
			
			//handle Reply List
			//TO DO Journal/quest triggers
			var replyList:XML = dlgXml.Field.(@Label=="ReplyList")[0];
			var replyListElements:XMLList = replyList.Value;
			var replyListLength:int = replyListElements.length();
			for(i=0;i<replyListLength;i++)
			{
				var replyListElement:XML = replyListElements[i];
				var replyListElementFields:XMLList = replyListElement.Field;
				var replyListElementText:XML = replyListElement.Field.(@Label=="Text")[0];
				replyListStringRefArray.push(parseInt(replyListElementText.Value.@StringRef));
				var entriesList:XML = replyListElement.Field.(@Label=="EntriesList")[0];
				var entriesListElements:XMLList = entriesList.Value;
				var entriesListLength:int = entriesListElements.length();
				var entriesListIndexArray: Array = new Array;
				if(entriesList.toString() == "")	 entriesListIndexArray.push(-1);
				else
				{	
					for(j=0;j<entriesListLength;j++)
					{
						var entriesListElement: XML = entriesListElements[j];
						if((entriesListElement.Field.(@Label=="Active").@Value) == "")
							entriesListIndexArray.push(parseInt(entriesListElement.Field.(@Label=="Index").@Value));
						else	//ce= condition_entries
						{
							var ce: String = (entriesListElement.Field.(@Label=="Active").@Value);
							if((entriesListElement.Field.(@Label=="Not").@Value) == "1")
							{
								if(Main.CONDITIONS[ce]==false)
									entriesListIndexArray.push(parseInt(entriesListElement.Field.(@Label=="Index").@Value));
							}
							else
							{
								if(Main.CONDITIONS[ce]==true)
									entriesListIndexArray.push(parseInt(entriesListElement.Field.(@Label=="Index").@Value));
							}
						}
					}
					if(entriesListIndexArray.length != 1)
						throw new Error("There cannot be more or less than 1 actual NPC entry after all the conditions are evaluated!");
				}
				replyListEntriesArray.push(entriesListIndexArray);
			}
			
			/*//for each entry and reply show the response string
			for(i=0;i<entryListRepliesArray.length;i++)
			{
				trace( " ");
				trace( "ENTRY",i,entryListStringRefArray[i], getString(entryListStringRefArray[i]));
				trace( "-------REPLIES-----------------");
				for each( var r:int in entryListRepliesArray[i])
				{
					if(r!=-1)	trace(r,replyListStringRefArray[r], getString(replyListStringRefArray[r]));
					else	 trace("ENTRY End Dialogue");
				}
			}
			
			for(i=0;i<replyListEntriesArray.length;i++)
			{
				trace( " ");
				trace( "REPLY",i,replyListStringRefArray[i], getString(replyListStringRefArray[i]));
				trace( "--------ENTRIES----------------");
				for each( var e:int in replyListEntriesArray[i])
				{
					if(e!=-1)	trace(e,entryListStringRefArray[e], getString(entryListStringRefArray[e]));
					else	 trace("REPLY End Dialogue");
				}
			}*/
			
			showDialogLines(activeEntry);
		}
		
		public function showDialogLines(c:int): void
		{
			//Order replies
			var _length:int=entryListRepliesArray[c].length;
			if(_length<= 6)
			{
				orderReplies(_length);
				//trace( repliesOrder);
			}
			else throw new Error("Replies cannot be more than 6!");
			
			/*for( var i:int=0;i<repliesOrder.length;i++)
			{
				var _child:*=clip.getChildByName(repliesOrder[i]);
				_child.visible = true;
			}*/
			
			//handle the active text by calling a function
			//this is the first entry, and belongs to an NPC-is this needed Here?
			var selectedCharacter: Character = Main.selectedCharacter;
			activeText(selectedCharacter.targetCharacter.characterName);
			
			//handle entry Replies
			for(var j:int=0;j<entryListRepliesArray[c].length;j++)
			{
				var r:int = entryListRepliesArray[c][j];
				//trace( "reply",r, "has",replyListEntriesArray[r], "following entry");
				if(r!=-1)	
				{
					var _childImagesSprite:*=clip.wheelSprite.getChildByName(repliesOrder[j]);
					if(_childImagesSprite)
					{
						activeImagesSprites.push(_childImagesSprite);
						_childImagesSprite.visible = true;
					}
					//add text Sprite
					var textSprite: Sprite = new Sprite;
					textSprite.name = repliesOrder[j] + "_TEXT";
					var _textReply:TextField = new TextField(2000,_textSize*1.5, "", "MyriadPro-Bold", _textSize, 0xffffff);
					_textReply.name= "textField";
					if(repliesOrder[j].charAt() == "L")
						_textReply.hAlign = HAlign.RIGHT;
					else	_textReply.hAlign = HAlign.LEFT;
					//_textReply.border = true;
					if(replyListEntriesArray[r]==-1)
						_textReply.text = getString(replyListStringRefArray[r]) + "[End]";
					else
						_textReply.text = getString(replyListStringRefArray[r]);
					_textReply.width = _textReply.textBounds.width + 2 * (2 + 2);
					textSprite.addChild(_textReply);
					var _textEntries:TextField = new TextField(0,0, "");
					_textEntries.name= "textEntries";
					_textEntries.visible= false;
					_textEntries.text = String(replyListEntriesArray[r]);
					textSprite.addChild(_textEntries);
					clip.textSprites.addChild(textSprite);
					activeTextSprites.push(textSprite);
						
					//position the text
					var _childTextReferenceSprite:*=clip.textReferenceSprites.getChildByName(repliesOrder[j]+ "_REFERENCE");
					if(textSprite.name.charAt() == "L")
					{
						textSprite.x = _childTextReferenceSprite.x - textSprite.width;
						textSprite.y = _childTextReferenceSprite.y;
					}
					else
					{
						textSprite.x = _childTextReferenceSprite.x;
						textSprite.y = _childTextReferenceSprite.y;
					}
					textSprite.addEventListener(TouchEvent.TOUCH, onNodeTouch);
					textSprite.useHandCursor = true;
				}
				//TO DO refine the end of dialogue when NPC entry is the trigger, not the player reply
				else	 trace(entryListStringRefArray[c],"End Dialogue");
			}
		}
		
		public function  cleanup(c:int): void
		{
			//TO DO, make sure active entry has replies associated
			//remove active text sprite
			var a:*=clip.textSprites.getChildByName("ACTIVE_TEXT");
			if(a)	 clip.textSprites.removeChild(a);
			else	 trace( "active text sprite not found");
			for( var i:int=0;i<activeImagesSprites.length;i++)
				activeImagesSprites[i].visible = false;
			for(i=0;i<activeTextSprites.length;i++)
			{
				var t:*=activeTextSprites[i]
				if(t)	 clip.textSprites.removeChild(t);
			}
			
			//emptied the arrays
			repliesOrder = new Array;
			activeImagesSprites = new Array;
			activeTextSprites = new Array;
			
			if(c==-1)	 
			{
				activeEntry = 0;
				//may not be needed
				entryListStringRefArray = new Array;
				entryListRepliesArray = new Array;
				replyListStringRefArray = new Array;
				replyListEntriesArray = new Array;
				
				GameSound.sndChannel.stop();
				StarlingFrontSprite.getInstance().removeChild(clip);
				Main.suspendState = false;
				StarlingFrontSprite.getInstance().bars.visible = true;
				/*var dialog:*=StarlingFrontSprite.getInstance().getChildByName("Dialog");
				if(dialog)
					StarlingFrontSprite.getInstance().removeChild(dialog);
				else	 trace( "dialogue not found");*/
			}
			else
			{
				showDialogLines(activeEntry);
			}
		}
		
		private function onNodeTouch(event:TouchEvent):void
		{
			//trace( event.currentTarget, event.target);
			var tf:TextField = event.target as TextField;
			var node: Sprite = Sprite(event.currentTarget);
			var name: String = node.name.substring(0,2);
			
			//get and assign  wheel images
			var _child:*=clip.wheelSprite.getChildByName(name);
			var _base:*=_child.getChildByName(name+"_Base");
			var _highlight:*=_child.getChildByName(name+"_Highlight");
			
			if(event.interactsWith(node) == false)	 
			{
				tf.color = 16777215;
				_base.visible = true;
				_highlight.visible = false;
				previous = "";
			}
			else if(previous != name) 
			{
				tf.color = 14535586;
				//trace(_base,_highlight);
				_base.visible = false;
				_highlight.visible = true;
				previous = name;
			}
			else
			{
				 var touchBegan:Touch = event.getTouch(node, TouchPhase.BEGAN);
				 if(touchBegan)	
				 {
					 //restore the visual branch to original colors and settings
					 tf.color = 16777215;
					 _base.visible = true;
					 _highlight.visible = false;
					 previous = "";
					 //handle the replies next entries if any, or -1
					 var tfe:TextField = node.getChildByName("textEntries") as TextField;
					 activeEntry = parseInt(tfe.text);
					 cleanup(activeEntry);
					 
					 /*if(activeEntry == -1)
					 {
						 cleanup(activeEntry);
						 trace(activeEntry, "time to end the dialogue");
					 }
					 else	
					 {
						 cleanup(activeEntry);
						 trace(activeEntry, "move to the next node");
					 }*/
				 }
			}
		}
		
		public function activeText(s: String): void
		{
			//play NPC Voice Over sound
			GameSound.playSound(String(entryListStringRefArray[activeEntry]));
			
			//Handle active text line
			var activeTextSprite: Sprite = new Sprite;
			activeTextSprite.name = "ACTIVE_TEXT";
			var _textField:TextField = new TextField(2000,_textSize*1.5, "", "MyriadPro-Bold", _textSize, 0x6fbbd3);
			_textField.name= "textField";
			_textField.hAlign = HAlign.CENTER;
			//_textField.border = true;
			activeTextSprite.addChild(_textField);
			_textField.text = s.toUpperCase() + ": " + getString(entryListStringRefArray[activeEntry]);
			_textField.width = _textField.textBounds.width + 2 * (2 + 2);
			var activeTextReferenceSprite:*=clip.textReferenceSprites.getChildByName("ACTIVE_REFERENCE");
			if(activeTextReferenceSprite)
			{
				activeTextSprite.x = activeTextReferenceSprite.x - activeTextSprite.width/2;
				activeTextSprite.y = -activeTextSprite.height*2;
			}
			else trace( "active text reference Sprite not found!");
			clip.textSprites.addChild(activeTextSprite);
		}
		
		public function orderReplies(o:int): void
		{
			 switch(o)
			 {
				 case 1:
				 {
					 repliesOrder = ["RT"];
					 break;
				 }
				 case 2:
				 {
					 repliesOrder = ["RT", "RB"];
					 break;
				 }
				 case 3:
				 {
					 repliesOrder = ["RT", "RM", "RB"];
					 break;
				 }
				 case 4:
				 {
					 repliesOrder = ["RT", "RM", "RB", "LM"];
					 //repliesOrder = ["LT", "LB", "RT", "RB"];
					 //repliesOrder = ["LT", "LM", "LB", "RM"];
					 break;
				 }
				 case 5:
				 {
					 repliesOrder = ["RT", "RM", "RB", "LT", "LB"];
					 break;
				 }
				 case 6:
				 {
					 repliesOrder = ["RT", "RM", "RB", "LT", "LM", "LB"];
					 break;
				 }
			 }
		}
	}
}