class DateUtil {
	private static var months:Array = [];
	public static function getMonthDays($month:Number, $year:Number):Number {
		months = [0, 31, isBissext($year) ? 29 : 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
		return months[$month];
	}
	public static function isBissext($year:Number):Boolean{
		if($year%4==0 && $year%100!=0 || $year%400==0){
			return true;
		}else {
			return false;
		}
	}
}