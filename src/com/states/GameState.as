package com.states
{
	import com.cards.ACard;
	import com.cards.CardFactory;
	import com.core.AAction;
	import com.core.APlayer;
	import com.core.ActionFactory;
	import com.core.Game;
	import com.core.Player;
	import com.core.PlayerFactory;
	import com.debug.Debug;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class GameState extends AState
	{
		private var loaderScreen:Sprite;
		private var turnInterface:Sprite;
		private var defensiveInterface:Sprite;
		private var chooseCardInterface:Sprite;
		
		private var cardFactory:CardFactory;
		private var playerFactory:PlayerFactory;
		private var actionFactory:ActionFactory;
		
		private var vectorOfPlayers:Vector.<APlayer>;
		private var vectorOfCards:Vector.<ACard>;
		private var playerTurn:APlayer;
		private var turnTarget:APlayer;
		private var turnAction:AAction;
		
		private var cardsDistributed:int;
		private var playerTurnId:int;
		private var count:int;
		private var seconds:int;
		private var minutes:int;
		private var totalSeconds:int;
		private var timeForResponse:int;
		private var actionResponseTimer:Boolean;
		
		private var turnType:String;
		private var TURN_ACTIVE:String =  "active";
		private var TURN_DEFENSIVE:String = "defensive";
		
		public function GameState()
		{
			super();
			Debug.message(Debug.STATE, StatesConstants.GAME_STATE);
		}
		
		public override function initialize():void
		{
			super.initialize();
			Debug.message(Debug.METHOD, "initialize " + StatesConstants.GAME_STATE);
			
			addLoaderScreen();
			
			playerFactory = new PlayerFactory();
			playerFactory.initialize();
			vectorOfPlayers = playerFactory.getVectorOfPlayers();
			
			actionFactory = new ActionFactory();
			actionFactory.createPullOfActions(vectorOfPlayers);
			
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
		}
		
		private function onCompleteLoadCards():void
		{
			Debug.message(Debug.INFO, "onCompleteLoadXMLCards - GameState");
			vectorOfCards = cardFactory.getVectorOfRandomCards().concat();
			removeLoadScreen();
			initGame();
		}
		
		private function initGame():void
		{
			setPlayersCallBacks();
			distributeCards();
			sortPlayerTurn();
		}
		
		private function setPlayersCallBacks():void
		{
			for(var i:int = 0; i < vectorOfPlayers.length; i++){
				vectorOfPlayers[i].actionChoosed.add(actionChoosed);
				vectorOfPlayers[i].responseAction.add(receiveActionResponse);
				if(vectorOfPlayers[i] == Player){
					(vectorOfPlayers[i] as Player).showChooseActionInterface.add(showTurnInterface);
					(vectorOfPlayers[i] as Player).showChooseDefensiveActionInterface.add(showDefensiveInterface);
					(vectorOfPlayers[i] as Player).showChooseCardInterface.add(showChooseCardInterface);
				}
				vectorOfPlayers[i].endTurn.add(endTurn);
			}
			
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
			var playerId:int = Math.floor(Math.random() * vectorOfPlayers.length);
			playerTurnId = playerId;
			playerTurnId = 0;
			changeTurn();
		}
		
		private function changeTurn():void
		{
			trace("player turn: " + playerTurnId + " " + vectorOfPlayers[playerTurnId].getName());
			playerTurn = vectorOfPlayers[playerTurnId];
			turnType = TURN_ACTIVE;
			if(playerTurn.getIsAI()){
				Debug.message(Debug.INFO, "Player: " + playerTurn.getName() + " || is AI");
			}
			playerTurn.initTurn();
			//calculatePlayerTurn();
		}
		
		private function calculatePlayerTurn():void
		{
			if(playerTurnId < vectorOfPlayers.length-1){
				playerTurnId++;
			}else{
				playerTurnId = 0;
			}
		}
		
		private function showTurnInterface():void
		{
			turnInterface = new Sprite();
			turnInterface.graphics.beginFill(0x505050,1);
			turnInterface.graphics.drawRect(50, 50, stage.stageWidth-50, stage.stageHeight-50);
			turnInterface.graphics.endFill();
			this.addChild(turnInterface);
			
			for(var i:int = 0; i < vectorOfPlayers[0].getVectorOfTurnActions().length; i++){
				var actionBtn:MovieClip = new MovieClip();
				actionBtn.graphics.beginFill(0x505080, 1);
				actionBtn.graphics.drawRect(0,00,100,50);
				actionBtn.graphics.endFill();
				actionBtn.name = vectorOfPlayers[0].getVectorOfTurnActions()[i].getName();
				turnInterface.addChild(actionBtn);
				
				var btnName:TextField = new TextField();
				btnName.text = actionBtn.name;
				btnName.selectable = false;
				actionBtn.addChild(btnName);
				actionBtn.addEventListener(MouseEvent.CLICK, onClickAction);
				actionBtn.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
				actionBtn.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
				
				actionBtn.x = turnInterface.width/2 - actionBtn.width/2;
				actionBtn.y = (i * 20) + i * actionBtn.height;
			}
		}
		
		private function onClickAction(event:MouseEvent):void
		{
			var choosedActionName:String = event.currentTarget.name;
			switch(turnType){
				case TURN_ACTIVE:
					playerTurn.doTurnAction(actionFactory.getActionByName(choosedActionName));
					removeTurnInterface();
				break;
				case TURN_DEFENSIVE:
					turnTarget.doDefensiveAction(actionFactory.getActionByName(choosedActionName));
					removeDefensiveInterface();
				break;
			}
		}
		
		private function removeTurnInterface():void
		{
			this.removeChild(turnInterface);
			turnInterface = null;
		}
		
		private function showDefensiveInterface():void
		{
			turnType = TURN_DEFENSIVE;
			defensiveInterface = new Sprite();
			defensiveInterface.graphics.beginFill(0x505050,1);
			defensiveInterface.graphics.drawRect(50, 50, stage.stageWidth-50, stage.stageHeight-50);
			defensiveInterface.graphics.endFill();
			this.addChild(defensiveInterface);
			
			for(var i:int = 0; i < vectorOfPlayers[0].getVectorOfDefensiveActions().length; i++){
				var actionBtn:MovieClip = new MovieClip();
				actionBtn.graphics.beginFill(0x505080, 1);
				actionBtn.graphics.drawRect(0,00,100,50);
				actionBtn.graphics.endFill();
				actionBtn.name = vectorOfPlayers[0].getVectorOfDefensiveActions()[i].getName();
				defensiveInterface.addChild(actionBtn);
				
				var btnName:TextField = new TextField();
				btnName.text = actionBtn.name;
				btnName.selectable = false;
				actionBtn.addChild(btnName);
				actionBtn.addEventListener(MouseEvent.CLICK, onClickAction);
				actionBtn.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
				actionBtn.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
				
				actionBtn.x = defensiveInterface.width/2 - actionBtn.width/2;
				actionBtn.y = (i * 20) + i * actionBtn.height;
			}
		}
		
		private function removeDefensiveInterface():void
		{
			this.removeChild(defensiveInterface);
			defensiveInterface = null;
		}
		
		private function showChooseCardInterface():void
		{
			chooseCardInterface = new Sprite();
			chooseCardInterface.graphics.beginFill(0x505050,1);
			chooseCardInterface.graphics.drawRect(50, 50, stage.stageWidth-100, stage.stageHeight-100);
			chooseCardInterface.graphics.endFill();
			this.addChild(chooseCardInterface);
			
			var vectorOfCards:Vector.<ACard>;
			if(turnType == TURN_ACTIVE){
				vectorOfCards = Game.getVectorOfActiveCards();
			}else if(turnType == TURN_DEFENSIVE){
				vectorOfCards = Game.getVectorOfDefensiveCards();
			}
			
			for(var i:int = 0; i < vectorOfCards.length; i++){
				var cardBtn:MovieClip = new MovieClip();
				cardBtn.graphics.beginFill(0x505080, 1);
				cardBtn.graphics.drawRect(0,00,100,50);
				cardBtn.graphics.endFill();
				cardBtn.name = vectorOfCards[i].getName();
				chooseCardInterface.addChild(cardBtn);
				
				var btnName:TextField = new TextField();
				btnName.text = cardBtn.name;
				btnName.selectable = false;
				cardBtn.addChild(btnName);
				cardBtn.addEventListener(MouseEvent.CLICK, onClickCard);
				cardBtn.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
				cardBtn.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
				
				cardBtn.x = chooseCardInterface.width/2 - cardBtn.width/2;
				cardBtn.y = (i * 20) + i * cardBtn.height;
			}
		}
		
		protected function onClickCard(event:MouseEvent):void
		{
			var cardName:String = event.currentTarget.name;
			if(turnType == TURN_ACTIVE){
				playerTurn.setActionCard(cardFactory.getCardByName(cardName));
				//playerTurn.setActiveCard(cardFactory.getCardByName(cardName));
			}else if(turnType == TURN_DEFENSIVE){
				turnTarget.setActionCard(cardFactory.getCardByName(cardName));
				//turnTarget.setDefensiveCard(cardFactory.getCardByName(cardName));
			}
			removeChooseCardInterface();
		}
		
		private function removeChooseCardInterface():void
		{
			this.removeChild(chooseCardInterface);
			chooseCardInterface = null;
		}
		
		private function onMouseOver(event:MouseEvent):void
		{
			event.currentTarget.scaleX = event.currentTarget.scaleY += .1;
		}
		
		private function onMouseOut(event:MouseEvent):void
		{
			event.currentTarget.scaleX = event.currentTarget.scaleY -= .1;
		}
		
		private function actionChoosed(_action:AAction):void
		{
			turnAction = _action;
			turnTarget = _action.getTarget();
			trace("acao escolhida: " + _action.getName());
			trace("target: " + turnTarget);
			sendAction(turnAction);
		}
		
		private function sendAction(_action:AAction):void
		{
			trace(_action, _action.getCanBeBlocked());
			if(_action.getCanBeBlocked() == true){
				turnType = TURN_DEFENSIVE;
				if(turnTarget == null){
					for each (var player:APlayer in vectorOfPlayers) 
					{
						if(player.getName() != playerTurn.getName()){
							player.receiveAction(turnAction);
						}
					}
				}else{
					turnTarget.receiveAction(turnAction);
					//playerTurn.doAction(turnAction);
				}
				timeForResponse = totalSeconds + Game.getTimeForResponse();
				actionResponseTimer = true;
			}else{
				trace("this action cant be blocked");
				playerTurn.doAction(turnAction);
				actionResponseTimer = false;
			}
		}
		
		private function receiveActionResponse(actionResponse:AAction):void
		{
			playerTurn.receiveResponse(actionResponse);
		}
		
		private function endTurn():void
		{
			trace("fim de turno");
			calculatePlayerTurn();
			changeTurn();
		}
		
		public override function update():void
		{
			super.update();
			count++;
			if(count >= Game.getFrameRate()){
				count = 0;
				seconds++;
				totalSeconds++;
			}
			if(seconds >= 60){
				minutes++;
			}
			if(actionResponseTimer){
				if(totalSeconds >= timeForResponse){
					actionResponseTimer = false;
					verifyActionResponses();
				}
			}
		}
		
		private function verifyActionResponses():void
		{
			if(turnAction == null){
				for each (var player:APlayer in vectorOfPlayers) 
				{
					if(player.getName() != playerTurn.getName()){
						if(player.getActionResponse()){
							
						}
					}
				}
				
			}else{
				
			}
		}
		
		private function doIncome():void
		{
			playerTurn.addCoins(Game.getCoinsPerIncome());
		}
		
		private function doForeignAid():void
		{
			playerTurn.addCoins(Game.getCoinsPerIncome());
		}
		
		private function doCoup():void
		{
			playerTurn.removeCoins(Game.getCoinsToCoup());
			turnTarget.removeCard();
		}
	}
}