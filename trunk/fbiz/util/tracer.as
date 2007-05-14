/*
* Class show output on debug Console
*
* @author		Nicholas Almeida and Igor Almeida
* @version		1.0
* @history		Created the AS2 version
*
* @usage		import tracer;
*
*/

class com.fbiz.util.tracer {
	public static function line():Void{
		trace("-------------------------------------------------------");
	}
	public static function doc(project:String, author:String, version:String):Void{
		if(arguments.length<3) {trace("debug.doc() requires (Project, Author, Version)."); return;}
		trace("*******************************************************\n " + project + "\n @author:  " + author + "\n @version: " + version + "\n*******************************************************");
	}
	public static function log(s:String):Void{
		var now:Date = new Date();
		trace("[" + ((now.getHours()<10) ? ("0" + now.getHours()) : now.getHours()) + ":" + ((now.getMinutes()<10) ? ("0" + now.getMinutes()) : now.getMinutes()) + ":" + now.getMilliseconds() + "] " + s);
	}
}