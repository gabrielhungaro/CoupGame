package com.cards
{
	import com.debug.Debug;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.osflash.signals.Signal;

	public class CardFactory
	{
		private var xmlLoader:URLLoader;
		private var xml:XML;
		private var xmlPath:String = "../lib/cards.xml";
		public var onCompleteXmlLoad:Signal = new Signal();
		private var vectorOfCards:Vector.<ACard>;
		private var totalOfCards:int;
		private var numberOfEqualsCards:int;
		
		public function CardFactory()
		{
		}
		
		/**
		 * @param completeCallback callback called when xml loader is completed, this param cam be set bay this form or through var onCompleteXmlLoad
		 */
		public function initialize(completeCallback:Function = null):void
		{
			if(completeCallback !=null){
				onCompleteXmlLoad.addOnce(completeCallback);
			}
			loadXML();
		}
		
		private function loadXML():void
		{
			xmlLoader = new URLLoader();
			xmlLoader.load(new URLRequest(xmlPath));
			xmlLoader.addEventListener(Event.COMPLETE, onCompleteLoad);
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
		}
		
		protected function onCompleteLoad(event:Event):void
		{
			xml = new XML(event.target.data);
			totalOfCards = xml.CARD.length();
			onCompleteXmlLoad.dispatch();
			createPullOfCards();
		}
		
		protected function onError(event:IOErrorEvent):void
		{
			Debug.message(Debug.ERROR, event.text);
		}
		
		private function createPullOfCards():void
		{
			for(var i:int = 0; i < totalOfCards; i++){
				for(var j:int = 0; j < numberOfEqualsCards; j++){
					var cardName:String = xml.CARD[i].@name;
					var cardId:int = xml.CARD[i].@id;
					var cardDesc:String = xml.CARD[i].@description;
					var cardImg:String = xml.CARD[i].@img;
					createCard(cardName, cardId, cardDesc, cardImg);
				}
			}
		}
		private function createCard(_name:String, _id:int, _desc:String, _img:String):void
		{
			
		}
	}
}