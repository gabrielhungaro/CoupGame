package com.debug
{
	public class Debug
	{
		
		public static const INFO:String =	"[ INFO ] - ";
		public static const ERROR:String =	"[ ERROR ] - ";
		public static const METHOD:String =	"[ METHOD ] - ";
		public static const STATE:String =	"[ STATE ] - ";
		public static const ALERT:String =	"[ ALERT ] - ";
		
		public static var debbugin:Boolean = true; 
		
		public function Debug()
		{
		}
		
		public static function message(_type:String, _message:String):void
		{
			if(debbugin){
				switch(_type){
					case ERROR:
						trace(_type, _message);
						//throw new Error(ERROR + _message);
						break;
					default:
						trace(_type, _message);
						break;
				}
				
			}
		}
		
		public static function Alert(_message:String):void
		{
			message(ALERT, _message);
		}
	}
}