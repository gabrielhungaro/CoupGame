package com.states
{
	import com.debug.Debug;
	
	import mx.core.mx_internal;

	public class GameState extends AState
	{
		public function GameState()
		{
			super();
			Debug.message(Debug.STATE, StatesConstants.GAME_STATE);
		}
		
		public override function initialize():void
		{
			super.initialize();
			Debug.message(Debug.METHOD, "initialize " + StatesConstants.GAME_STATE);
		}
	}
}