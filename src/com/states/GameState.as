package com.states
{
	import com.cards.ACard;
	import com.cards.CardFactory;
	import com.core.APlayer;
	import com.core.Game;
	import com.core.PlayerFactory;
	import com.debug.Debug;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;

	public class GameState extends AState
	{
		private var cardFactory:CardFactory;
		private var loaderScreen:Sprite;
		private var game:Game;
		private var playerFactory:PlayerFactory;
		private var vectorOfPlayers:Vector.<APlayer>;
		private var vectorOfCards:Vector.<ACard>;
		private var cardsDistributed:int;
		
		public function GameState()
		{
			super();
			Debug.message(Debug.STATE, StatesConstants.GAME_STATE);
		}
		
		public override function initialize():void
		{
			super.initialize();
			game = Game.getInstance();
			Debug.message(Debug.METHOD, "initialize " + StatesConstants.GAME_STATE);
			
			addLoaderScreen();
			
			playerFactory = new PlayerFactory();
			playerFactory.initialize(Game.getNumberOfPlayers());
			vectorOfPlayers = playerFactory.getVectorOfPlayers();
			
			cardFactory = new CardFactory();
			cardFactory.onCompleteLoadCards.addOnce(onCompleteLoadCards);
			cardFactory.initialize();
			addChild(cardFactory);
		}
		
		private function addLoaderScreen():void
		{
			loaderScreen = new Sprite();
			addChild(loaderScreen);
			var loaderText:TextField = new TextField();
			loaderText.text = "CARREGANDO";
			loaderText.x = stage.stageWidth/2 - loaderText.width/2;
			loaderText.y = stage.stageHeight/2 - (loaderText.height/2);
			loaderScreen.addChild(loaderText);
			
			var loader:MovieClip = new MovieClip();
			loader.graphics.beginFill(0x005500, 1);
			loader.graphics.drawRect(stage.stageWidth / 2 - 100, stage.stageHeight / 2 - 25, 200, 50);
			loader.graphics.endFill();
			loaderScreen.addChild(loader);
		}
		
		private function removeLoadScreen():void
		{
			this.removeChild(loaderScreen);
			loaderScreen = null;
			initGame();
		}
		
		private function onCompleteLoadCards():void
		{
			Debug.message(Debug.INFO, "onCompleteLoadXMLCards - GameState");
			vectorOfCards = cardFactory.getVectorOfRandomCards().concat();
			removeLoadScreen();
		}
		
		private function initGame():void
		{
			distributeCards();
		}
		
		private function distributeCards():void
		{
			trace("vectorOfCards: " + vectorOfCards.length);
			while(cardsDistributed < Game.getNumberOfCardsPerPlayer()){
				cardsDistributed++;
				for (var i:int = 0; i <= Game.getNumberOfPlayers(); i++) 
				{
					trace("player: " + vectorOfPlayers[i].getName() + " recebe a carta: " + vectorOfCards[i] + " - " + vectorOfCards[i].getName());
					vectorOfPlayers[i].addCard(vectorOfCards[i]);
					vectorOfCards[i] = null;
					vectorOfCards.splice(i, 1);
				}
				
			}
			sortPlayerTurn();
			//showPlayersCards();
		}
		
		private function shuffleCards():void
		{
			vectorOfCards = cardFactory.randomizeCards(cardFactory.getVectorOfRandomCards().concat());
		}
		
		private function showPlayersCards():void
		{
			for (var i:int = 0; i < vectorOfPlayers.length; i++) 
			{
				trace("======================");
				trace("name: " + vectorOfPlayers[i].getName());
				trace("cards: " + vectorOfPlayers[i].getVectorOfCards());
				trace("coins: " + vectorOfPlayers[i].getCoins());
				trace("======================");
			}
		}
		
		private function sortPlayerTurn():void
		{
			var player:int = Math.floor(Math.random() * vectorOfPlayers.length);
			trace("player turn: " + player + " " + vectorOfPlayers[player].getName());
		}
		
		public override function update():void
		{
			super.update();
		}
	}
}