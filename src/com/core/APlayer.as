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
		private var vectorOfCards:Vector.<ACard>;
		private var coins:int;
		private var isAI:Boolean;
		private var vectorOfTurnActions:Vector.<String>;
		private var vectorOfDefensiveActions:Vector.<String>;
		public var endTurn:Signal = new Signal();
		private var actionTarget:APlayer;
		private var actionResponse:String;
		
		
		private var status:String;
		private var STATUS_ON_TURN:String = "active";
		private var STATUS_DEFENSIVE:String = "defensive";
		private var STATUS_WAINTING:String = "waiting";
		
		public function APlayer()
		{
		}
		
		public function initialize():void
		{
			vectorOfCards = new Vector.<ACard>();
			vectorOfTurnActions = new Vector.<String>();
			vectorOfDefensiveActions = new Vector.<String>();
			
			vectorOfTurnActions.push(Game.ACTION_CARD);
			vectorOfTurnActions.push(Game.ACTION_INCOME);
			vectorOfTurnActions.push(Game.ACTION_FOREIGN_AID);
			vectorOfTurnActions.push(Game.ACTION_COUP);
			
			vectorOfDefensiveActions.push(Game.ACTION_ACCEPT);
			vectorOfDefensiveActions.push(Game.ACTION_NOT_ACCEPT);
			vectorOfDefensiveActions.push(Game.ACTION_CARD);
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
		
		public function chooseTurnAction():void
		{
			switch(Game.AI_TYPE){
				case Game.AI_PERCENT:
					percentAction();
					break;
				case Game.AI_RANDOM:
					randomAction();
					break;
				default :
					
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
				randomIndex = Math.floor(Math.random() * vectorOfTurnActions.length);
				doTurnAction(randomIndex);
			}else if(status == STATUS_DEFENSIVE){
				randomIndex = Math.floor(Math.random() * vectorOfDefensiveActions.length);
				actionResponse = doDefensiveAction(randomIndex);
			}
			return randomIndex;
		}
		
		private function doDefensiveAction(actionId:int):String
		{
			var action:String = vectorOfDefensiveActions[actionId];
			switch(action){
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
		
		private function doTurnAction(actionId:int):String
		{
			var action:String = vectorOfTurnActions[actionId];
			switch(action){
				case Game.ACTION_CARD:
					//doCardHability()
					break;
				case Game.ACTION_COUP:
					doCoup();
					break;
				case Game.ACTION_FOREIGN_AID:
					//doForeignAid();
					break;
				case Game.ACTION_INCOME:
					doIncome();
					break;
				default:
					doIncome();
					break;
			}
			endTurn.dispatch(actionTarget, action);
			status = STATUS_WAINTING;
			return action;
		}
		
		private function doAccept():void
		{
			return;
		}
		
		private function doNotAccept():void
		{
			
		}
		
		private function doIncome():void
		{
			this.addCoins(Game.getCoinsPerIncome());
		}
		
		private function doCoup():void
		{
			if(coins >= Game.getCoinsToCoup()){
				this.removeCoins(Game.getCoinsToCoup());
			}else{
				chooseTurnAction();
			}
		}

		private function verifyIfCanDoAction(_action:String):void
		{
			
		}
		
		public function receiveAction(action:String):String
		{
			chooseTurnAction();
			return actionResponse;
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

		public function getActionResponse():String
		{
			return actionResponse;
		}

		public function setActionResponse(value:String):void
		{
			actionResponse = value;
		}


	}
}