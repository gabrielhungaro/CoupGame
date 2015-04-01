package com.states
{
	import com.debug.Debug;
	
	import flash.display.Sprite;
	import flash.events.Event;

	public class StateManager extends Sprite
	{
		private static var _instance:StateManager;
		
		private var vectorOfStates:Vector.<AState>;
		private var currentState:AState;
		private var isPaused:Boolean = true;
		
		public function Singleton():void{
			if(_instance){
				Debug.message(Debug.ERROR, "Singleton... use getInstance()");
			} 
			_instance = this;
			
		}
		
		public static function getInstance():StateManager{
			if(!_instance){
				_instance = new StateManager();
			} 
			return _instance;
		}
		
		public function initialize():void
		{
			vectorOfStates = new Vector.<AState>();
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		
		protected function update(event:Event):void
		{
			if(!isPaused){
				currentState.update();
			}
		}
		
		public function Add(_state:AState, _stateName:String, _isDefault:Boolean = false):void
		{
			_state.setName(_stateName);
			vectorOfStates.push(_state);
			if(_isDefault == true){
				//changeState(_stateName);
				currentState = _state;
				addChild(currentState);
				currentState.initialize();
			}
		}
		
		private function changeState(_stateName:String):void
		{
			// TODO Auto Generated method stub
			
		}
	}
}