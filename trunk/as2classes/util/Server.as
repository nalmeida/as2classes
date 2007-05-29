/*

USAGE:

	Server.setAddress("_VAR_NAME_", {local:"__LOCAL_VALUE__, web: _root.$server + "__WEB_VALUE__", extra:"__EXTRA_VALUE__"});
	Server.getVar("_VAR_NAME_", ["__USE_EXTRA__"]);
	Server.list();

*/


class as2classes.util.Server{
	
	private static var arr:Array = [];
	private static var local:Boolean;
	private static var showMessage:Boolean = true;
		
		
		
	public static function setAddress(arrItem, value){
		local = (_root._url.indexOf("file") == 0) ? true : false;
		arr[arrItem] = value;
		if(showMessage){
			if(local) trace("\nRunning at LOCAL.\n");
			else trace("\nRunning on the SERVER.\n");
			showMessage = false;
		}
	}
	
	
	
	public static function getAddress(arrItem, useExtra){
		if(arr[arrItem].extra != "" || useExtra)  // Se tiver um parâmetro "extra" ou se tiver forçado o useExtra ele usa o extra e não o local ou web
			return arr[arrItem].extra;
		return (local) ? arr[arrItem].local : arr[arrItem].web;
	}
	
	
	
	public static function list(){
		trace("\nServer list:");
		trace("\tRunning local: " + local + "\n");
		for(var i in arr) trace("\t" + i + "\n\t\tlocal: \"" + arr[i].local+ "\"\n\t\tweb:   \"" + arr[i].web+ "\"\n\t\textra: \"" + arr[i].extra + "\"\n");
	}
	
	
}