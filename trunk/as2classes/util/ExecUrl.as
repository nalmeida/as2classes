/*
USAGE:

	ExecUrl.run("__URL__", "_TARGET");
*/



class as2classes.util.ExecUrl{
	
	private static var arrSeq:Array = [];
	private static var interval:Number;
	private static var hasInit:Boolean;
	
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
	
	public static function sequence(url:String,targ:String):Void{
		arrSeq.push({url:url, targ:targ});
		if(!hasInit) init();
	}
	
	
	
	
	
	private static function init():Void{
		hasInit = true;
		interval = setInterval(doSequence, 300);
	}
	
	private static function doSequence():Void{
		if(arrSeq[0]){
			run(arrSeq[0].url, arrSeq[0].targ);
			arrSeq.shift();
		} else {
			clearInterval(interval);
			hasInit = false;
		}
	}
	
	private function ExecUrl(){} // Avoid instance creation
}