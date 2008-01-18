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
	
	public static function isBetween(iniNumber:Number, endNumber:Number, number:Number):Boolean{
		if(number <= endNumber && number >= iniNumber) return true;
		return false;
	}
	
	/**
		Creates a random integer within the defined range.
		
		@param min: The minimum number the random integer can be.
		@param min: The maximum number the random integer can be.
		@return Returns a random integer within the range.
	*/
	public static function randomInteger(min:Number, max:Number):Number {
		return min + Math.floor(Math.random() * (max + 1 - min));
	}
	
	public function NumberUtil(){} // Avoid instance creation
}