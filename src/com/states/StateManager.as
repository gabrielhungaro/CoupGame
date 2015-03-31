package com.states
{
	import com.debug.Debug;

	public class StateManager
	{
		private static var _instance:StateManager;
		
		private var vectorOfStates:Vector.<AState>;
		private var currentState:AState;
		
		public function Singleton():void{
			if(_instance){
				Debug.message(Debug.ERROR, "Singleton... use getInstance()");
			} 
			_instance = this;
		}
		
		public static function getInstance():StateManager{
			if(!_instance){
				new StateManager();
			} 
			return _instance;
		}
		
		public function Add(_state:AState, _stateName:String, _isDefault:Boolean = false):void
		{
			_state.setName(_stateName);
			vectorOfStates.push(_state);
			if(_isDefault == true){
				currentState = _state;
			}
		}
	}
}