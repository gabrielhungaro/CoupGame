package com.cards
{
	import com.debug.Debug;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.osflash.signals.Signal;

	public class CardFactory extends Sprite
	{
		private var xmlLoader:URLLoader;
		private var xml:XML;
		private var xmlPath:String = "../lib/cards.xml";
		public var onCompleteXmlLoad:Signal = new Signal();
		private var vectorOfCards:Vector.<ACard>;
		private var totalOfCards:int;
		private var numberOfEqualsCards:int = 3;
		private var sourcePath:String;
		private var poolCreated:Boolean;
		private var vectorOfRandomCards:Object;
		
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
			sourcePath = xml.@sourcePath;
			totalOfCards = xml.CARD.length();
			onCompleteXmlLoad.dispatch();
			createPoolOfCards();
		}
		
		protected function onError(event:IOErrorEvent):void
		{
			Debug.message(Debug.ERROR, event.text);
		}
		
		private function createPoolOfCards():void
		{
			vectorOfCards = new Vector.<ACard>();
			var cardName:String;
			var cardId:int;
			var cardDesc:String;
			var cardImg:String;
			
			for(var i:int = 0; i < totalOfCards; i++){
				for(var j:int = 0; j < numberOfEqualsCards; j++){
					cardName = xml.CARD[i].@name;
					cardId = xml.CARD[i].@id;
					cardDesc = xml.CARD[i].@description;
					cardImg = sourcePath + xml.CARD[i].@img;
					createCard(cardName, cardId, cardDesc, cardImg);
				}
			}
			
			poolCreated = true;
			randomizeCards();
		}
		
		private function createCard(_name:String, _id:int, _desc:String, _img:String):void
		{
			var card:ACard = new ACard();
			card.setName(_name);
			card.setId(_id);
			card.setDescription(_desc);
			card.setImagePath(_img);
			card.initialize();
			vectorOfCards.push(card);
			addChild(card);
		}
		
		private function randomizeCards():void
		{
			var teste1:Array = ["A", "Z", "G", "0", "P", "B"];
			var _tempArray:Array = teste1.concat();
			var _randomArray:Array = [];
			var _randomIndex:int;
			
			for(var i:int = 0; i < _tempArray.length; i++){
				_randomIndex = Math.ceil(Math.random() * _tempArray.length);
				trace("TESTE: " + _tempArray[_randomIndex]);
				if(_tempArray[_randomIndex] == null){
					_randomIndex = Math.ceil(Math.random() * _tempArray.length);
				}else{
					_randomArray.push(_tempArray[_randomIndex]);
					_tempArray[_randomIndex] = null;
				}
				/*while(_tempArray[_randomIndex] == null && _randomArray.length < _tempArray.length){
					_randomIndex = Math.ceil(Math.random() * _tempArray.length);
				}
				_randomArray.push(_tempArray[_randomIndex]);
				_tempArray[_randomIndex] = null;*/
			}
			
			//vectorOfRandomCards = new Vector.<ACard>();
		}
		
		private function verifyExistsIndex(_array:Array):int
		{
			var randomInt:int;
			if(_array[_index] == null){
				_randomIndex = Math.ceil(Math.random() * _array.length);
			}else{
				_randomArray.push(_tempArray[_randomIndex]);
				_tempArray[_randomIndex] = null;
			}
			return randomInt;
		}
	}
}