package com.core
{
	import com.cards.ACard;
	import com.debug.Debug;
	
	import flash.display.Sprite;

	public class APlayer extends Sprite
	{
		private var name:String;
		private var lifes:int;
		private var isDead:Boolean;
		private var vectorOfCards:Vector.<ACard>;
		private var coins:int;
		private var isAI:Boolean;
		
		public function APlayer()
		{
		}
		
		public function initialize():void
		{
			vectorOfCards = new Vector.<ACard>();
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

		public function getIsAI():Boolean
		{
			return isAI;
		}

		public function setIsAI(value:Boolean):void
		{
			isAI = value;
		}

	}
}