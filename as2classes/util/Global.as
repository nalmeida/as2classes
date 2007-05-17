
/*
USAGE:

	Global.setVar("_VAR_NAME_", _VALUE_);
	Global.getVar("_VAR_NAME_");
*/


class as2classes.util.Global{
	
	private static var arr:Array = [];
		
	public static function setVar(arrItem, value){
		arr[arrItem] = value;
	}
	public static function getVar(arrItem){
		return arr[arrItem];
	}
}