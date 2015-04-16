package com.core
{
	import com.cards.ACard;
	import com.debug.Debug;
	
	import flash.display.Sprite;
	
	import org.osflash.signals.Signal;

	public class APlayer extends Sprite
	{
		private var name:String;
		private var lifes:int;
		private var isDead:Boolean;
		private var coins:int;
		private var isAI:Boolean;
		
		private var vectorOfCards:Vector.<ACard>;
		private var vectorOfTurnActions:Vector.<AAction>;
		private var vectorOfDefensiveActions:Vector.<AAction>;
		
		private var turnAction:AAction;
		private var actionTarget:APlayer;
		private var actionResponse:AAction;
		
		public var actionChoosed:Signal = new Signal();
		public var responseAction:Signal = new Signal();
		public var endTurn:Signal = new Signal();
		
		public var doIncome:Signal = new Signal();
		public var doForeignAid:Signal = new Signal();
		public var doCardHability:Signal = new Signal();
		public var doCoup:Signal = new Signal();
		
		private var status:String;
		private var STATUS_ON_TURN:String = "onTurn";
		private var STATUS_DEFENSIVE:String = "defensive";
		private var STATUS_WAINTING:String = "waiting";
		
		public function APlayer()
		{
		}
		
		public function initialize():void
		{
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
				if(lifes <= Game.getNumberOfCardsPerPlayer()){
					vectorOfCards.push(_card);
				}else{
					Debug.Alert("Não é possível ter mais do que duas cartas na mão.");
				}
			}else{
				Debug.message(Debug.ERROR, "objeto carta é nulo");
			}
		}
		
		public function removeCard():void
		{
			switch(Game.AI_TYPE){
				case Game.AI_PERCENT:
					
					break;
				case Game.AI_RANDOM:
					removeRandomCard();
					break;
				default :
					
				break;
			}
		}
		
		private function removeRandomCard():ACard
		{
			var card:ACard;
			var cardId:int = Math.floor(Math.random() * vectorOfCards.length); 
			card = vectorOfCards[cardId]; 
			vectorOfCards.splice(cardId, 1);
			return card;
		}
		
		public function initTurn():void
		{
			status = STATUS_ON_TURN;
			chooseAction();
		}
		
		private function chooseAction():void
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
		
		public function randomAction():int
		{
			var randomIndex:int;
			if(status == STATUS_ON_TURN){
				trace("player vai realizar acao no proprio turno");
				randomIndex = Math.floor(Math.random() * vectorOfTurnActions.length);
				doTurnAction(vectorOfTurnActions[randomIndex]);
			}else if(status == STATUS_DEFENSIVE){
				trace("acao defensiva");
				randomIndex = Math.floor(Math.random() * vectorOfDefensiveActions.length);
				doDefensiveAction(vectorOfDefensiveActions[randomIndex]);
			}
			return randomIndex;
		}
		
		private function doDefensiveAction(action:AAction):AAction
		{
			actionResponse = action;
			switch(action.getName()){
				case Game.ACTION_ACCEPT:
					doAccept();
					break;
				case Game.ACTION_CARD:
					//doCardHability();
					break;
				case Game.ACTION_NOT_ACCEPT:
					doNotAccept();
					break;
				default:
					doAccept();
					break;
			}
			return action;
		}
		
		public function doTurnAction(action:AAction):AAction
		{
			turnAction = action;
			var canDo:Boolean = verifyCanDoAction(action);
			if(canDo){
				Debug.message(Debug.INFO, "Player: [ " + this.getName() + " ] vai fazer acao: " + turnAction.getName());
				actionChoosed.dispatch(action);
			}else{
				chooseAction();
			}
			return action;
		}
		
		private function verifyCanDoAction(action:AAction):Boolean
		{
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
		
		public function doAction(action:AAction):void
		{
			switch(action.getName()){
				case Game.ACTION_CARD:
					//doCardHability.dispatch()
					break;
				case Game.ACTION_COUP:
					doCoup.dispatch();
					break;
				case Game.ACTION_FOREIGN_AID:
					doForeignAid.dispatch();
					break;
				case Game.ACTION_INCOME:
					doIncome.dispatch();
					break;
				default:
					doIncome.dispatch();
					break;
			}
			status = STATUS_DEFENSIVE;
			endTurn.dispatch();
		}
		
		private function doAccept():void
		{
			return ;
		}
		
		private function doNotAccept():void
		{
			return;
		}
		
		private function verifyIfCanDoAction(_action:String):void
		{
			
		}
		
		public function receiveAction(action:AAction):AAction
		{
			chooseAction();
			responseAction.dispatch(actionResponse);
			return actionResponse;
		}
		
		public function receiveResponse(_response:AAction):void
		{
			var targetResponse:AAction = actionTarget.getActionResponse();
			
			switch(targetResponse){
				case Game.ACTION_ACCEPT:
					doAction(turnAction);
					break;
				case Game.ACTION_NOT_ACCEPT:
					break;
				case Game.ACTION_CARD:
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
	}
}