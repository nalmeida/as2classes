/*

USAGE:

	Server.setAddress("_VAR_NAME_", {local:"__LOCAL_VALUE__, web: _root.$server + "__WEB_VALUE__", extra:"__EXTRA_VALUE__"});
	Server.getVar("_VAR_NAME_", ["__USE_EXTRA__"]);
	Server.list();

*/

import as2classes.util.ObjectUtil;

class as2classes.util.Server{
	
	private static var obj:Object = {};
	private static var local:Boolean;
	private static var showMessage:Boolean = true;
		
		
		
	public static function setAddress(objItem, value){
		local = (_root._url.indexOf("file") == 0) ? true : false;
		obj[objItem] = value;
		if(showMessage){
			if(local) trace("\nRunning at LOCAL.\n");
			else trace("\nRunning on the SERVER.\n");
			showMessage = false;
		}
	}
	
	
	public static function getAddress(objItem, useExtra){
		if((obj[objItem].extra != "" && obj[objItem].extra != undefined) || useExtra)  // Se tiver um parâmetro "extra" ou se tiver forçado o useExtra ele usa o extra e não o local ou web
			return obj[objItem].extra;
			
		return (local) ? obj[objItem].local : obj[objItem].web;
	}
	
	
	
	public static function list(){
		trace("\nServer list:");
		trace("\tRunning local: " + local + "\n");
		
		ObjectUtil.reverseObject(obj); // reverse
		
		for(var i in obj)  trace("\t" + i + "\n\t\tlocal: \"" + obj[i].local+ "\"\n\t\tweb:   \"" + obj[i].web+ "\"\n\t\textra: \"" + obj[i].extra + "\"\n");
		
		ObjectUtil.reverseObject(obj); // undo reverse
	}
	
}