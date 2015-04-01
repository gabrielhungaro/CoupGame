package com.cards
{
	import flash.display.Sprite;

	public class ACard
	{
		private var name:String;
		private var description:String;
		private var id:int
		private var image:Sprite;
		private var canUseAbility:Boolean;
		private var coinsToBuy:int;
		
		public function ACard()
		{
		}
		
		public function initialize():void
		{
			canUseAbility = true;
			coinsToBuy = 1;
		}

		public function getImage():Sprite
		{
			return image;
		}

		public function setImage(value:Sprite):void
		{
			image = value;
		}

		public function getDescription():String
		{
			return description;
		}

		public function setDescription(value:String):void
		{
			description = value;
		}

		public function getName():String
		{
			return name;
		}

		public function setName(value:String):void
		{
			name = value;
		}

		public function getId():int
		{
			return id;
		}

		public function setId(value:int):void
		{
			id = value;
		}


	}
}