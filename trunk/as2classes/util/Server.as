
/*
USAGE:

	Server.setAddress("_VAR_NAME_", {local:"__LOCAL_VALUE__, web: _root.$server + "__WEB_VALUE__", extra:"__EXTRA_VALUE__"});
	Global.getVar("_VAR_NAME_");
*/


class as2classes.util.Server{
	
	private static var arr:Array = [];
	private static var local:Boolean;
		
	public static function setAddress(arrItem, value){
		local = (_root._url.indexOf("file") == 0) ? true : false;
		arr[arrItem] = value;
	}
	public static function getAddress(arrItem, useExtra){
		if(useExtra) return arr[arrItem].extra;
		return (local) ? arr[arrItem].local : arr[arrItem].web;
	}
}