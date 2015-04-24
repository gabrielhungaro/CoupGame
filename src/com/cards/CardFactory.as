package com.cards
{
	import com.core.AAction;
	import com.core.Game;
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
		public var onCompleteLoadCards:Signal = new Signal();
		private var totalOfCards:int;
		private var numberOfEqualsCards:int = 3;
		private var sourcePath:String;
		private var poolCreated:Boolean;
		private var vectorOfCards:Vector.<ACard>;
		private var vectorOfRandomCards:Vector.<ACard>;
		private var vectorOfActiveCards:Vector.<ACard>;
		private var vectorOfDefensiveCards:Vector.<ACard>;
		
		public function CardFactory()
		{
		}
		
		/**
		 * @param completeCallback callback called when xml loader is completed, this param cam be set bay this form or through var onCompleteXmlLoad
		 */
		public function initialize(completeCallback:Function = null):void
		{
			if(completeCallback != null){
				onCompleteLoadCards.addOnce(completeCallback);
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
			createPoolOfCards();
		}
		
		protected function onError(event:IOErrorEvent):void
		{
			Debug.message(Debug.ERROR, event.text);
		}
		
		private function createPoolOfCards():void
		{
			vectorOfCards = new Vector.<ACard>();
			vectorOfActiveCards = new Vector.<ACard>();
			vectorOfDefensiveCards = new Vector.<ACard>();
			
			var cardName:String;
			var cardId:int;
			var cardDesc:String;
			var cardImg:String;
			var cardActiveAbility:Boolean;
			var cardDefensiveAbility:Boolean;
			var cardMandatoryTarget:Boolean;
			var cardAbilityCost:int;
			var cardCounterTo:String;
			
			for(var i:int = 0; i < totalOfCards; i++){
				for(var j:int = 0; j < numberOfEqualsCards; j++){
					cardName = xml.CARD[i].@name;
					cardId = xml.CARD[i].@id;
					cardDesc = xml.CARD[i].@description;
					cardImg = sourcePath + xml.CARD[i].@img;
					cardActiveAbility = (xml.CARD[i].@activeAbility == "true");
					cardDefensiveAbility = (xml.CARD[i].@defensiveAbility == "true");
					cardMandatoryTarget = (xml.CARD[i].@mandatoryTarget == "true");
					cardAbilityCost = xml.CARD[i].@abilityCost;
					cardCounterTo = xml.CARD[i].@counterTo;
					createCard(cardName,
							   cardId,
							   cardDesc, 
							   cardImg, 
							   cardActiveAbility, 
							   cardDefensiveAbility, 
							   cardMandatoryTarget,
							   cardAbilityCost,
							   cardCounterTo);
				}
			}
			
			Game.setVectorOfActiveCards(vectorOfActiveCards);
			Game.setVectorOfDefensiveCards(vectorOfDefensiveCards);
			vectorOfRandomCards = randomizeCards(vectorOfCards);
			poolCreated = true;
			onCompleteLoadCards.dispatch();
		}
		
		private function createCard(_name:String,
									_id:int,
									_desc:String, 
									_img:String, 
									_activeAbility:Boolean, 
									_defensiveAbility:Boolean, 
									_mandatoryTarget:Boolean, 
									_abilityCost:int, 
									_counterTo:String):void
		{
			var card:ACard = new ACard();
			card.setName(_name);
			card.setId(_id);
			card.setDescription(_desc);
			card.setImagePath(_img);
			card.setHasActiveAbility(_activeAbility);
			card.setHasDefensiveAbility(_defensiveAbility);
			card.setMandatoryTarget(_mandatoryTarget);
			card.setAbilityCost(_abilityCost);
			card.setCounterTo(_counterTo);
			card.initialize();
			vectorOfCards.push(card);
			if(_activeAbility == true){
				//nulo criar antes
				vectorOfActiveCards.push(card);
			}
			if(_defensiveAbility == true){
				vectorOfDefensiveCards.push(card);
			}
			//addChild(card);
		}
		
		public function randomizeCards(_array:Vector.<ACard> = null):Vector.<ACard>
		{
			var _tempArray:Vector.<ACard> = _array.concat();
			var _randomArray:Vector.<ACard> = new Vector.<ACard>();
			var _randomIndex:int;
			
			for(var i:int = 0; i < _tempArray.length; i++){
				if(_randomArray.length < _array.length){
					_randomIndex = getRandomIndexInArray(_tempArray);
					_randomArray.push(_tempArray[_randomIndex]);
					_tempArray[_randomIndex] = null;
					_tempArray.slice(_randomIndex, 0);
				}
			}
			return _randomArray;
		}
		
		private function getRandomIndexInArray(_array:Vector.<ACard>):int
		{
			var randomInt:int = Math.floor(Math.random() * _array.length);
			if(_array[randomInt] != null || _array[randomInt] != undefined){
				return randomInt;
			}
			randomInt = getRandomIndexInArray(_array);
			return randomInt;
		}

		public function getVectorOfRandomCards():Vector.<ACard>
		{
			return vectorOfRandomCards;
		}

		public function setVectorOfRandomCards(value:Vector.<ACard>):void
		{
			vectorOfRandomCards = value;
		}
		
		public function getCardByName(cardName:String):ACard
		{
			var card:ACard = null;
			for each(card in vectorOfCards){
				if(card.getName() == cardName){
					return card;
				}
			}
			if(card == null){
				//todo
				trace("não existe essa acao");
			}
			return card;
		}

	}
}