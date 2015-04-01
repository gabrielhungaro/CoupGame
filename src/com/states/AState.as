package com.states
{
	import flash.display.Sprite;

	public class AState extends Sprite
	{
		private var name:String;
		private var id:int;
		private var isActive:Boolean;
		
		public function AState()
		{
			
		}
		
		public function initialize():void
		{
			
		}
		
		public function update():void
		{
			
		}
		
		public function getIsActive():Boolean
		{
			return isActive;
		}

		public function setIsActive(value:Boolean):void
		{
			isActive = value;
		}

		public function getName():String
		{
			return name;
		}
		
		public function setName(value:String):void
		{
			name = value;
		}
		
	}
}