﻿package com.core
{
	import com.cards.ACard;
	import com.debug.Debug;

	public class Game
	{
		private static var _instance:Game;
		
		private static var coinsToCoup:int = 7;
		private static var numberOfPlayers:int = 3;
		private static var numberOfCardsPerPlayer:int = 2;
		private static var initialCoins:int = 2;
		private static var coinsPerIncome:int = 1;
		private static var coinsPerForeignAid:int = 2;
		private static var numberCardsToEnxchange:int = 2;
		private static var player:APlayer;
		private static var frameRate:Number;
		private static var timeForResponse:int = 10;
		private static var vectorOfPlayers:Vector.<APlayer>;
		private static var vectorOfActiveCards:Vector.<ACard>;
		private static var vectorOfDefensiveCards:Vector.<ACard>;
		
		public static const ACTION_CARD:String = "Card";
		public static const ACTION_INCOME:String = "Income";
		public static const ACTION_FOREIGN_AID:String = "ForeignAid";
		public static const ACTION_COUP:String = "Coup";
		
		public static const ACTION_ACCEPT:String = "Accept";
		public static const ACTION_NOT_ACCEPT:String = "NotAccept";
		
		public static const AI_RANDOM:String = "random";
		public static const AI_PERCENT:String = "percent";
		public static var AI_TYPE:String = AI_RANDOM;
		
		
		public function Singleton():void{
			if(_instance){
				Debug.message(Debug.ERROR, "Singleton... use getInstance()");
			} 
			_instance = this;
			
		}
		
		public static function getInstance():Game{
			if(!_instance){
				_instance = new Game();
			} 
			return _instance;
		}
		
		public static function initialize():void
		{
			vectorOfPlayers = new Vector.<APlayer>();
			vectorOfActiveCards = new Vector.<ACard>();
			vectorOfDefensiveCards = new Vector.<ACard>();
		}

		public static function getNumberOfPlayers():int
		{
			return numberOfPlayers;
		}

		public static function setNumberOfPlayers(value:int):void
		{
			numberOfPlayers = value;
		}

		public static function getNumberOfCardsPerPlayer():int
		{
			return numberOfCardsPerPlayer;
		}

		public static function setNumberOfCardsPerPlayer(value:int):void
		{
			numberOfCardsPerPlayer = value;
		}

		public static function getInitialCoins():int
		{
			return initialCoins;
		}

		public static function setInitialCoins(value:int):void
		{
			initialCoins = value;
		}

		public static function getPlayer():APlayer
		{
			return player;
		}

		public static function setPlayer(value:APlayer):void
		{
			player = value;
		}

		public static function getCoinsPerIncome():int
		{
			return coinsPerIncome;
		}

		public static function setCoinsPerIncome(value:int):void
		{
			coinsPerIncome = value;
		}

		public static function getCoinsPerForeignAid():int
		{
			return coinsPerForeignAid;
		}

		public static function setCoinsPerForeignAid(value:int):void
		{
			coinsPerForeignAid = value;
		}

		public static function getCoinsToCoup():int
		{
			return coinsToCoup;
		}

		public static function setCoinsToCoup(value:int):void
		{
			coinsToCoup = value;
		}

		public static function getFrameRate():Number
		{
			return frameRate;
		}

		public static function setFrameRate(value:Number):void
		{
			frameRate = value;
		}

		public static function getTimeForResponse():int
		{
			return timeForResponse;
		}

		public static function setTimeForResponse(value:int):void
		{
			timeForResponse = value;
		}

		public static function getVectorOfPlayers():Vector.<APlayer>
		{
			return vectorOfPlayers;
		}

		public static function setVectorOfPlayers(value:Vector.<APlayer>):void
		{
			vectorOfPlayers = value;
		}

		public static function getVectorOfActiveCards():Vector.<ACard>
		{
			return vectorOfActiveCards;
		}

		public static function setVectorOfActiveCards(value:Vector.<ACard>):void
		{
			vectorOfActiveCards = value;
		}

		public static function getVectorOfDefensiveCards():Vector.<ACard>
		{
			return vectorOfDefensiveCards;
		}

		public static function setVectorOfDefensiveCards(value:Vector.<ACard>):void
		{
			vectorOfDefensiveCards = value;
		}

		public static function getNumberCardsToEnxchange():int
		{
			return numberCardsToEnxchange;
		}

		public static function setNumberCardsToEnxchange(value:int):void
		{
			numberCardsToEnxchange = value;
		}


	}
}