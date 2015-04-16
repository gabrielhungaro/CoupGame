package com
{
	import com.core.Game;
	import com.debug.Debug;
	import com.states.GameState;
	import com.states.StateManager;
	import com.states.StatesConstants;
	
	import flash.display.Sprite;
	
	[SWF(width="1024", height="768", frameRate="24")]
	public class CoupGame extends Sprite
	{
		private var stateManager:StateManager;
		
		public function CoupGame()
		{
			Debug.message(Debug.INFO, "Init CoupGame");
			
			Game.setFrameRate(stage.frameRate);
			
			stateManager = StateManager.getInstance();
			addChild(stateManager);
			stateManager.initialize();
			stateManager.Add(new GameState(), StatesConstants.GAME_STATE, true);
		}
	}
}