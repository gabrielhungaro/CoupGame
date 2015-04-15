package com.core
{
	import flash.display.Sprite;

	public class PlayerFactory extends Sprite
	{
		private var numberOfPlayers:int;
		private var vectorOfPlayers:Vector.<APlayer>;
		private var player:APlayer;
		
		public function PlayerFactory()
		{
			
		}
		
		public function initialize(_numberOfPlayers:int):void
		{
			numberOfPlayers = _numberOfPlayers;
			
			createPlayers();
			
		}
		
		private function createPlayers():void
		{
			vectorOfPlayers = new Vector.<APlayer>();
			
			createPlayerUser();
			
			for (var i:int = 0; i < numberOfPlayers; i++) 
			{
				var AIplayer:APlayer = new APlayer();
				AIplayer.setName("AI Player" + i);
				AIplayer.setLifes(Game.getNumberOfCardsPerPlayer());
				AIplayer.setCoins(Game.getInitialCoins());
				AIplayer.setIsAI(true);
				AIplayer.initialize();
				addChild(AIplayer);
				vectorOfPlayers.push(AIplayer);
			}
		}
		
		private function createPlayerUser():void
		{
			player = new Player();
			player.setName("macaco");
			player.setLifes(Game.getNumberOfCardsPerPlayer());
			player.setCoins(Game.getInitialCoins());
			player.initialize();
			player.setIsAI(false);
			addChild(player);
			vectorOfPlayers.push(player);
			Game.setPlayer(player);
		}

		public function getVectorOfPlayers():Vector.<APlayer>
		{
			return vectorOfPlayers;
		}

		public function setVectorOfPlayers(value:Vector.<APlayer>):void
		{
			vectorOfPlayers = value;
		}

		public function getPlayer():APlayer
		{
			return player;
		}

		public function setPlayer(value:APlayer):void
		{
			player = value;
		}


	}
}