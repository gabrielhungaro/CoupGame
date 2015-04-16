package com.core
{
	public class AAction
	{
		private var name:String;
		private var cost:int;
		private var canBeBlocked:Boolean;
		private var target:APlayer;
		
		public function AAction()
		{
		}
		
		public function setName(value:String):void
		{
			name = value;
		}
		
		public function getName():String
		{
			return name;
		}
		
		public function setCost(value:int):void
		{
			cost = value;
		}
		
		public function getCost():int
		{
			return cost;
		}
		
		public function setCanBeBlocked(value:Boolean):void
		{
			canBeBlocked = value;
		}
		
		public function getCanBeBlocked():Boolean
		{
			return canBeBlocked;
		}
		
		public function setTarget(value:APlayer):void
		{
			target = value;
		}
		
		public function getTarget():APlayer
		{
			return target;
		}
	}
}