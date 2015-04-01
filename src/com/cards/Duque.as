package com.cards
{
	public class Duque extends ACard
	{
		public function Duque()
		{
			super();
		}
		
		public override function initialize():void
		{
			super.initialize();
			super.setName(CardConstants.DUQUE);
			super.setDescription();
		}
	}
}