﻿package com.core
{
	import com.cards.ACard;
	import com.debug.Debug;
	
	import flash.display.Sprite;
	
	import org.osflash.signals.Signal;

	public class APlayer extends Sprite
	{
		protected var name:String;
		protected var lifes:int;
		protected var isDead:Boolean;
		protected var coins:int;
		protected var isAI:Boolean;
		
		protected var vectorOfCards:Vector.<ACard>;
		protected var vectorOfTurnActions:Vector.<AAction>;
		protected var vectorOfDefensiveActions:Vector.<AAction>;
		public var vectorOfRemovedCards:Vector.<ACard>;
		protected var vectorOfCardsToExchange:Vector.<ACard>;
		
		protected var turnAction:AAction;
		protected var actionTarget:APlayer;
		protected var actionResponse:AAction;
		protected var activeCard:ACard;
		protected var defensiveCard:ACard;
		
		public var actionChoosed:Signal = new Signal();
		public var cardChoosed:Signal = new Signal();
		public var waitingActionResponse:Signal = new Signal();
		public var responseAction:Signal = new Signal();
		public var endTurn:Signal = new Signal();
		public var exchangeCard:Signal = new Signal();
		public var doingAction:Signal = new Signal;
		public var cardRemoved:Signal = new Signal();
		
		
		public var doIncome:Signal = new Signal();
		public var doForeignAid:Signal = new Signal();
		public var doCardAbility:Signal = new Signal();
		public var doCoup:Signal = new Signal();
		
		protected var status:String;
		protected var STATUS_ON_TURN:String = "onTurn";
		protected var STATUS_DEFENSIVE:String = "defensive";
		protected var STATUS_WAINTING:String = "waiting";
		protected var exchangingCards:Boolean;
		protected var numberOfCardsToExchange:int;
		
		public function APlayer()
		{
		}
		
		public function initialize():void
		{
			numberOfCardsToExchange = Game.getNumberCardsToEnxchange();
			status = STATUS_DEFENSIVE;
			vectorOfCards = new Vector.<ACard>();
			vectorOfTurnActions = new Vector.<AAction>();
			vectorOfDefensiveActions = new Vector.<AAction>();
		}
		
		public function addTurnAction(action:AAction):void
		{
			vectorOfTurnActions.push(action);
		}
		
		public function addDefensiveAction(action:AAction):void
		{
			vectorOfDefensiveActions.push(action);
		}
		
		public function addCard(_card:ACard):void
		{
			if(_card != null){
				vectorOfCards.push(_card);
			}else{
				Debug.message(Debug.ERROR, "objeto carta é nulo");
			}
		}
		
		public function chooseCardToRemove():void
		{
			vectorOfRemovedCards = new Vector.<ACard>();
			switch(Game.AI_TYPE){
				case Game.AI_PERCENT:
					
					break;
				case Game.AI_RANDOM:
					removeRandomCard();
					break;
				default :
					removeRandomCard();
				break;
			}
		}
		
		public function chooseCardToExchange():void
		{
			exchangingCards = true;
			vectorOfCardsToExchange = null;
			vectorOfCardsToExchange = new Vector.<ACard>();
			vectorOfRemovedCards = null;
			vectorOfRemovedCards = new Vector.<ACard>();
			
			for (var i:int = 0; i < numberOfCardsToExchange; i++) 
			{
				switch(Game.AI_TYPE){
					case Game.AI_PERCENT:
						
						break;
					case Game.AI_RANDOM:
						//randomHandsCard();
						removeRandomCard();
						break;
					default :
						//randomHandsCard();
						removeRandomCard();
						break;
				}
			}
		}
		
		private function removeRandomCard():void
		{
			var card:ACard;
			var cardId:int = Math.floor(Math.random() * vectorOfCards.length);
			card = vectorOfCards[cardId];
			removeCard(card);
		}
		
		public function removeCard(card:ACard):void
		{
			vectorOfRemovedCards.push(card);
			vectorOfCards.splice(vectorOfCards.indexOf(card),1);
			if(exchangingCards == true){
				if(vectorOfRemovedCards.length == numberOfCardsToExchange){
					exchangeCards();
				}
			}else{
				cardRemoved.dispatch();
			}
		}
		
		private function exchangeCards():void
		{
			if(vectorOfRemovedCards){
				for(var i:int = 0; i < numberOfCardsToExchange; i++){
					vectorOfCardsToExchange.push(vectorOfRemovedCards[i]);
				}
			}
			exchangeCard.dispatch(vectorOfCardsToExchange);
			exchangingCards = false;
		}
		
		public function initTurn():void
		{
			trace("====================================");
			trace("Player [ " + name + " ] - initTurn");
			status = STATUS_ON_TURN;
			chooseAction();
		}
		
		protected function chooseAction():void
		{
			switch(Game.AI_TYPE){
				case Game.AI_PERCENT:
					percentAction();
					break;
				case Game.AI_RANDOM:
					randomAction();
					break;
				default :
					randomAction();
				break;
			}
		}
		
		private function percentAction():void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function randomAction():void
		{
			var randomIndex:int;
			if(status == STATUS_ON_TURN){
				trace("player vai realizar acao no proprio turno");
				randomIndex = Math.floor(Math.random() * vectorOfTurnActions.length);
				turnAction = vectorOfTurnActions[randomIndex];
				if(turnAction.getName() == Game.ACTION_CARD){
					chooseCardAbility();
				}else{
					doTurnAction(turnAction);
				}
			}else if(status == STATUS_DEFENSIVE){
				trace("acao defensiva do player [ " + name + " ]");
				randomIndex = Math.floor(Math.random() * vectorOfDefensiveActions.length);
				actionResponse = vectorOfDefensiveActions[randomIndex];
				if(actionResponse.getName() == Game.ACTION_CARD){
					chooseCardAbility();
				}else{
					doDefensiveAction(actionResponse);
				}
			}
		}
		
		public function doDefensiveAction(action:AAction):void
		{
			switch(action.getName()){
				case Game.ACTION_ACCEPT:
					acceptAction();
					break;
				case Game.ACTION_CARD:
					acceptAction();
					//counterAction;
					break;
				case Game.ACTION_NOT_ACCEPT:
					contestAction();
					break;
				default:
					acceptAction();
					break;
			}
			responseAction.dispatch(actionResponse);
		}
		
		public function doTurnAction(action:AAction):void
		{
			turnAction = action;
			var canDo:Boolean = verifyCanDoAction(action);
			if(canDo){
				Debug.message(Debug.INFO, "Player: [ " + this.getName() + " ] vai fazer acao: " + turnAction.getName());
				if(action.getMandatoryTarget() == true){
					chooseActionTarget();
				}else{
					actionChoosed.dispatch(action);
				}
			}else{
				chooseAction();
			}
		}
		
		protected function chooseActionTarget():void
		{
			switch(Game.AI_TYPE){
				case Game.AI_PERCENT:
					//percentAction();
					break;
				case Game.AI_RANDOM:
					randomTarget();
					break;
				default :
					randomTarget();
					break;
			}
		}
		
		private function randomTarget():void
		{
			var randomIndex:int;
			var _target:APlayer;
			randomIndex = Math.floor(Math.random() * Game.getVectorOfPlayers().length);
			_target = Game.getVectorOfPlayers()[randomIndex];
			if(_target.getName() == name){
				randomTarget();
				return;
			}
			setActionTarget(_target);
		}
		
		public function setActionTarget(_target:APlayer):void
		{
			actionTarget = _target;
			turnAction.setTarget(actionTarget);
			actionChoosed.dispatch(turnAction);
		}
		
		private function verifyCanDoAction(action:AAction):Boolean
		{
			if(action.getName() == Game.ACTION_CARD){
				action.setCost(action.getCard().getAbilityCost());
			}
			var canDo:Boolean;
			if(action.getCost() == 0){
				canDo = true;
			}else if(action.getCost() <= this.getCoins()){
				canDo = true;
			}else{
				canDo = false;
			}
			return canDo;
		}
		
		protected function chooseCardAbility():void
		{
			switch(Game.AI_TYPE){
				case Game.AI_PERCENT:
					//percentAction();
					break;
				case Game.AI_RANDOM:
					randomCard();
					break;
				default :
					randomCard();
					break;
			}
			//doTurnAction(turnAction);
		}
		
		private function randomCard():void
		{
			var randomIndex:int;
			if(status == STATUS_ON_TURN){
				randomIndex = Math.floor(Math.random() * Game.getVectorOfActiveCards().length);
				activeCard = Game.getVectorOfActiveCards()[randomIndex];
				setActionCard(activeCard);
			}else if(status == STATUS_DEFENSIVE){
				randomIndex = Math.floor(Math.random() * Game.getVectorOfDefensiveCards().length);
				defensiveCard = Game.getVectorOfDefensiveCards()[randomIndex];
				setActionCard(defensiveCard);
			}
		}
		
		public function setActionCard(card:ACard):void
		{
			if(status == STATUS_ON_TURN){
				turnAction.setCard(card);
				turnAction.setMandatoryTarget(card.getMandatoryTarget());
				
				doTurnAction(turnAction);
				cardChoosed.dispatch(turnAction);
			}else if(status == STATUS_DEFENSIVE){
				//verifica se carta escolhida é counter da que esta atacando
				var cardCountersTo:Array = card.getArrayOfCountersTo();
				var nameToCompar:String;
				
				if(turnAction.getName() == Game.ACTION_CARD){
					nameToCompar = turnAction.getCard().getName();
				}else{
					nameToCompar = turnAction.getName();
				}
				
				if(cardCountersTo != null){
					for(var i:int = 0; i<cardCountersTo.length; i++){
						if(cardCountersTo[i] == nameToCompar){
							//é counter
							actionResponse.setCard(card);
				
							cardChoosed.dispatch(actionResponse);
							doDefensiveAction(actionResponse);
							return;
						}
						
					}
					//não é counter escolhe outro
					chooseCardAbility();
				}else{
					//não é counter escolhe outro
					chooseCardAbility();
				}
			}
		}
		
		public function doAction(action:AAction):void
		{
			status = STATUS_DEFENSIVE;
			doingAction.dispatch(action);
		}
		
		private function acceptAction():void
		{
			trace("Player [ " + name + " ] accept action");
		}
		
		private function contestAction():void
		{
			trace("Player [ " + name + " ] contest action");
		}
		
		private function counterAction():void
		{
			
		}
		
		private function verifyIfCanDoAction(_action:String):void
		{
			
		}
		
		public function receiveAction(action:AAction):void
		{
			turnAction = action;
			chooseAction();
			//responseAction.dispatch(actionResponse);
		}
		
		public function receiveResponse(_response:AAction):void
		{
			switch(_response){
				case Game.ACTION_ACCEPT:
					//doAction(turnAction);
					//segue vida e verificacao
					break;
				case Game.ACTION_NOT_ACCEPT:
					//verifica se a acao for contestada acontece algo
					chooseCardToShow();
					break;
				case Game.ACTION_CARD:
					//escolhe se aceita a acao ou nao
					break;
			}
		}
		
		private function chooseCardToShow():void
		{
			//terminar
			switch(Game.AI_TYPE){
				case Game.AI_PERCENT:
					percentAction();
					break;
				case Game.AI_RANDOM:
					randomAction();
					break;
				default :
					randomAction();
				break;
			}
		}
		
		public function getName():String
		{
			return name;
		}

		public function setName(value:String):void
		{
			name = value;
		}

		public function getLifes():int
		{
			return lifes;
		}

		public function setLifes(value:int):void
		{
			lifes = value;
		}

		public function getIsDead():Boolean
		{
			return isDead;
		}

		public function setIsDead(value:Boolean):void
		{
			isDead = value;
		}

		public function getVectorOfCards():Vector.<ACard>
		{
			return vectorOfCards;
		}

		public function setVectorOfCards(value:Vector.<ACard>):void
		{
			vectorOfCards = value;
		}

		public function getCoins():int
		{
			return coins;
		}

		public function setCoins(value:int):void
		{
			coins = value;
		}
		
		public function addCoins(value:int):void
		{
			coins += value;
		}
		
		public function removeCoins(value:int):void
		{
			coins -= value;
		}

		public function getIsAI():Boolean
		{
			return isAI;
		}

		public function setIsAI(value:Boolean):void
		{
			isAI = value;
		}

		public function getActionResponse():AAction
		{
			return actionResponse;
		}

		public function setActionResponse(value:AAction):void
		{
			actionResponse = value;
		}
		
		public function getTurnAction():AAction
		{
			return turnAction;
		}

		public function setTurnAction(value:AAction):void
		{
			turnAction = value;
		}
		
		public function setVectorOfTurnActions(value:Vector.<AAction>):void
		{
			vectorOfTurnActions = value;
		}

		public function getVectorOfTurnActions():Vector.<AAction>
		{
			return vectorOfTurnActions;
		}
		
		public function setVectorOfDefensiveActions(value:Vector.<AAction>):void
		{
			vectorOfDefensiveActions = value;
		}

		public function getVectorOfDefensiveActions():Vector.<AAction>
		{
			return vectorOfDefensiveActions;
		}
		
		public function setActiveCard(value:ACard):void
		{
			activeCard = value;
		}
		
		public function getActiveCard():ACard
		{
			return activeCard;
		}
		
		public function setDefensiveCard(value:ACard):void
		{
			activeCard = value;
		}
		
		public function getDefensiveCard():ACard
		{
			return activeCard;
		}
	}
}