class as2classes.number.NumberUtil{
	
	public static function getNumberFormatToDecimal(number:Number):String{
		return String((number<10) ? "0"+number : number);
	}
	
}