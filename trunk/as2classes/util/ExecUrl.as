/*
USAGE:

	ExecUrl.run("__URL__", "_TARGET");
*/



class as2classes.util.ExecUrl{
	
	private static var local:Boolean;

	public static function run(url:String,targ:String):Void{
		local = (_root._url.indexOf("file") == 0) ? true : false;
		targ = targ || "_self";
		if(local){
			trace(" > ExecUrl: " + url + " | target: " + targ);
		} else{
			getURL(url, targ);
		}
	}
	
}