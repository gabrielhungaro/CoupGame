package com.cards
{
	import com.debug.Debug;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;

	public class ACard extends Sprite
	{
		private var name:String;
		private var description:String;
		private var id:int
		//private var image:Sprite;
		private var imagePath:String;
		private var canUseAbility:Boolean;
		private var hasActiveAbility:Object;
		private var hasDefensiveAbility:Boolean;
		private var coinsToBuy:int;
		private var loader:Loader;
		private var image:Bitmap;
		
		public function ACard()
		{
		}
		
		public function initialize():void
		{
			canUseAbility = true;
			coinsToBuy = 1;
			
			loadImage();
		}
		
		private function loadImage():void
		{
			Debug.message(Debug.METHOD, "loadImage - " + imagePath);
			loader = new Loader();
			loader.load(new URLRequest(imagePath));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteImageLoadHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
		}
		
		protected function onCompleteImageLoadHandler(event:Event):void
		{
			Debug.message(Debug.INFO, "[ CARD ] - " + name + " onCompleteImageLoadHandler");
			image = Bitmap(loader.content);
			addChild(image);
		}
		
		protected function onErrorHandler(event:IOErrorEvent):void
		{
			Debug.message(Debug.ERROR, event.text);
		}
		
		public function getImagePath():String
		{
			return imagePath;
		}
		
		public function setImagePath(value:String):void
		{
			imagePath = value;
		}

		public function getImage():Bitmap
		{
			return image;
		}

		public function setImage(value:Bitmap):void
		{
			image = value;
		}

		public function getDescription():String
		{
			return description;
		}

		public function setDescription(value:String):void
		{
			description = value;
		}

		public function getName():String
		{
			return name;
		}

		public function setName(value:String):void
		{
			name = value;
		}

		public function getId():int
		{
			return id;
		}

		public function setId(value:int):void
		{
			id = value;
		}

		public function setHasActiveAbility(value:Boolean):void
		{
			hasActiveAbility = value;
		}
		
		public function getHasActiveAbility(value:Boolean):Boolean
		{
			return hasActiveAbility;
		}

		public function setHasDefensiveAbility(value:Boolean):void
		{
			hasDefensiveAbility = value;
		}
		
		public function getHasDefensiveAbility(value:Boolean):Boolean
		{
			return hasDefensiveAbility;
		}
	}
}