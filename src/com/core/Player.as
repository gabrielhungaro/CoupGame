package com.core
{
	import org.osflash.signals.Signal;

	public class Player extends APlayer
	{
		public var responsePlayerAction:Signal = new Signal();
		public var showChooseActionTargetInterface:Signal = new Signal();
		public var showChooseDefensiveActionInterface:Signal = new Signal();
		public var showChooseActionInterface:Signal = new Signal();
		public var showChooseCardInterface:Signal = new Signal();
		
		public function Player()
		{
			super();
		}
		
		override protected function chooseAction():void
		{
			showChooseActionInterface.dispatch();
		}
		
		override protected function chooseActionTarget():void
		{
			showChooseActionTargetInterface.dispatch();
		}
		
		override protected function chooseCardAbility():void
		{
			showChooseCardInterface.dispatch();
		}
		
		override public function receiveAction(action:AAction):void
		{
			showChooseActionInterface.dispatch();
		}
		
		override public function doDefensiveAction(action:AAction):void
		{
			super.doDefensiveAction(action);
		}
	}
}