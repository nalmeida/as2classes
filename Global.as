class as2classes.Global{
	
	private static var arr:Array = [];
		
	public static function setVar(arrItem, value){
		arr[arrItem] = value;
	}
	public static function getVar(arrItem){
		return arr[arrItem];
	}
}