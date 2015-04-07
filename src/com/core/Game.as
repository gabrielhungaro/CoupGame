package com.core
{
	import com.debug.Debug;

	public class Game
	{
		private static var _instance:Game;
		
		private static var numberOfPlayers:int = 3;
		private static var numberOfCardsPerPlayer:int = 2;
		private static var initialCoins:int = 2;
		private static var player:APlayer;
		
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


	}
}