
/*
USAGE:

	Global.setVar("_VAR_NAME_", _VALUE_);
	Global.getVar("_VAR_NAME_");
	Global.list();
*/

import as2classes.util.ObjectUtil;

class as2classes.util.Global{
	
	private static var obj:Object = {};
		
	public static function setVar(objItem, value){
		obj[objItem] = value;
	}
	public static function getVar(objItem){
		return obj[objItem];
	}
	public static function list(){
		trace("\nGlobal list:");
		
		ObjectUtil.reverseObject(obj); // reverse
		
		for(var i in obj) trace("\t" + i + ": " + obj[i] + " -- type: " + typeof(obj[i]));
		
		ObjectUtil.reverseObject(obj); // undo reverse
	}
}