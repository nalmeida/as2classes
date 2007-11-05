class as2classes.util.NumberUtil{
	
	/**
		Rounds a number's decimal value to a specific place.
		
		@param num: The number to round.
		@param place: The decimal place to round.
		@return Returns the value rounded to the defined place. 
		@example
			<code>
				trace(NumberUtil.roundToPlace(3.14159, 2)); // Traces 3.14
				trace(NumberUtil.roundToPlace(3.14159, 3)); // Traces 3.142
			</code>
	*/
	public static function roundDecimal(num:Number, afterComa:Number):Number {
		var p:Number = Math.pow(10, Math.round(afterComa));
		return Math.round(num * p) / p;
	}
	
	public function NumberUtil(){} // Avoid instance creation
}