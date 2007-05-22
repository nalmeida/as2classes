
/*
USAGE:

	Global.setVar("_VAR_NAME_", _VALUE_);
	Global.getVar("_VAR_NAME_");
	Global.list();
*/


class as2classes.util.Global{
	
	private static var arr:Array = [];
		
	public static function setVar(arrItem, value){
		arr[arrItem] = value;
	}
	public static function getVar(arrItem){
		return arr[arrItem];
	}
	public static function list(){
		trace("\nGlobal list:");
		for(var i in arr) trace("\t" + i + ": " + arr[i] + " -- type: " + typeof(arr[i]));
	}
}