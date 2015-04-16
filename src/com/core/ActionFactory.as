package com.core
{
	public class ActionFactory
	{
		private var vectorOfTurnActions:Vector.<AAction>;
		private var vectorOfDefensiveActions:Vector.<AAction>;
		
		public function ActionFactory()
		{
		}
		
		public function createPullOfActions(vector:Vector.<APlayer>):void
		{
			vectorOfTurnActions = new Vector.<AAction>();
			vectorOfDefensiveActions = new Vector.<AAction>();
			
			vectorOfTurnActions.push(createAction(new AAction(), Game.ACTION_INCOME, 0, false, null));
			vectorOfTurnActions.push(createAction(new AAction(), Game.ACTION_FOREIGN_AID, 0, true, null));
			vectorOfTurnActions.push(createAction(new AAction(), Game.ACTION_CARD, 0, true, null));
			vectorOfTurnActions.push(createAction(new AAction(), Game.ACTION_COUP, 0, false, null));
			
			vectorOfDefensiveActions.push(createAction(new AAction(), Game.ACTION_ACCEPT, 0, false, null));
			vectorOfDefensiveActions.push(createAction(new AAction(), Game.ACTION_NOT_ACCEPT, 0, false, null));
			vectorOfDefensiveActions.push(createAction(new AAction(), Game.ACTION_CARD, 0, false, null));
			
			
			for each(var player:APlayer in vector){
				player.setVectorOfTurnActions(vectorOfTurnActions);
				player.setVectorOfDefensiveActions(vectorOfDefensiveActions);
			}
		}
		
		private function createAction(_action, _actionName, _actionCost, _canBeBlocked, _actionTarget):AAction
		{
			var action:AAction = _action;
			action.setName(_actionName);
			action.setCost(_actionCost);
			action.setCanBeBlocked(_canBeBlocked);
			action.setTarget(_actionTarget);
			return action;
		}
		
		public function getActionByName(actioName:String):AAction
		{
			var action:AAction = null;
			for each(action in vectorOfTurnActions){
				if(action.getName() == actioName){
					return action;
				}
			}
			for each(action in vectorOfDefensiveActions){
				if(action.getName() == actioName){
					return action;
				}
			}
			if(action == null){
				//todo
				trace("não existe essa acao");
			}
			return action;
		}
	}
}