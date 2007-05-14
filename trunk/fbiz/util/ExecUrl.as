class com.fbiz.util.ExecUrl{
	
	private static var local:Boolean;
	
	function ExecUrl(url:String,targ:String){
		local = (_url.indexOf("file") == 0) ? true : false;
		if(arguments.length>0) run(url, targ);
	}
	
	public function run(url:String,targ:String):Void{
		targ = targ || "_self";
		if(local){
			trace(" > ExecUrl: " + url + " | target: " + targ);
		} else{
			getURL(url, targ);
		}
	}
	
}