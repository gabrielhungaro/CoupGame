package com.states
{
	import com.cards.CardFactory;
	import com.debug.Debug;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;

	public class GameState extends AState
	{
		private var cardFactory:CardFactory;
		private var loaderScreen:Sprite;
		
		public function GameState()
		{
			super();
			Debug.message(Debug.STATE, StatesConstants.GAME_STATE);
		}
		
		public override function initialize():void
		{
			super.initialize();
			Debug.message(Debug.METHOD, "initialize " + StatesConstants.GAME_STATE);
			
			addLoaderScreen();
			
			
			
			cardFactory = new CardFactory();
			cardFactory.onCompleteXmlLoad.addOnce(onCompleteLoadXMLCards);
			cardFactory.initialize();
		}
		
		private function addLoaderScreen():void
		{
			loaderScreen = new Sprite();
			addChild(loaderScreen);
			var loaderText:TextField = new TextField();
			loaderText.text = "CARREGANDO";
			loaderText.x = stage.stageWidth/2 - loaderText.width/2;
			loaderText.y = stage.stageHeight/2 - (loaderText.height/2);
			loaderScreen.addChild(loaderText);
			
			var loader:MovieClip = new MovieClip();
			loader.graphics.beginFill(0x005500, 1);
			loader.graphics.drawRect(stage.stageWidth / 2 - 100, stage.stageHeight / 2 - 25, 200, 50);
			loader.graphics.endFill();
			loaderScreen.addChild(loader);
		}
		
		private function removeLoadScreen():void
		{
			this.removeChild(loaderScreen);
			loaderScreen = null;
			initGame();
		}
		
		private function onCompleteLoadXMLCards():void
		{
			Debug.message(Debug.INFO, "onCompleteLoadXMLCards - GameState");
			removeLoadScreen();
		}
		
		private function initGame():void
		{
			
		}
		
		public override function update():void
		{
			super.update();
		}
	}
}