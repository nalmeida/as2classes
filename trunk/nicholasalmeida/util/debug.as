/*
* Class show output on debug Console
*
* @author		Nicholas Almeida and Igor Almeida
* @version		2.0
* @history		Created the AS2 version
*
* @usage		import debug;
*
* 				//If you don't need internal output (trace), set showInternalTrace to false;
* 				debug.showInternalTrace = false;
*/

class com.nicholasalmeida.util.debug {

	static var debuggerSenderConnection:LocalConnection;
	static var showInternalTrace:Boolean = true; // if you don't need internal output (trace), set this var to false.

	/*
	* debug.trace(message);
	*
	* Send the message to debug Console using local connection.
	*
	* @param  s: your message
	* @return nothing
	*/
	public static function trace(s):Void{
		if(showInternalTrace) trace(s);
		debuggerSenderConnection = new LocalConnection();
		debuggerSenderConnection.connect("_debuggerConnection");
		debuggerSenderConnection.send("_debuggerConnectionReceipt", "onReceipt", s.toString())
	}

	/*
	* debug.line();
	*
	* Write a simple "line" using "-", like the <hr/> in HTML.
	*
	* @param  none
	* @return nothing
	*/
	public static function line():Void{
		debug.trace("-------------------------------------------------------");
	}

	/*
	* debug.doc(project, author, version);
	*
	* Write the to show the project, author and version information.
	*
	* @param  project: project name
	* @param  author: application author
	* @param  version: application version
	* @return nothing
	*/
	public static function doc(project:String, author:String, version:String):Void{
		if(arguments.length<3) {trace("debug.doc() requires (Project, Author, Version)."); return;}
		debug.trace("*******************************************************\n " + project + "\n @author:  " + author + "\n @version: " + version + "\n*******************************************************");
	}

	/*
	* debug.log(message);
	*
	* Write the current date and time before the message
	*
	* @param  s: your message
	* @return nothing
	*/
	public static function log(s:String):Void{
		var now:Date = new Date();
		debug.trace("[" + ((now.getHours()<10) ? ("0" + now.getHours()) : now.getHours()) + ":" + ((now.getMinutes()<10) ? ("0" + now.getMinutes()) : now.getMinutes()) + ":" + now.getMilliseconds() + "] " + s);
	}

	/*
	* debug.clear();
	*
	* Clear the debug Console
	*
	* @param  none
	* @return nothing
	*/
	public static function clear():Void{
		debuggerSenderConnection = new LocalConnection();
		debuggerSenderConnection.connect("_debuggerConnection");
		debuggerSenderConnection.send("_debuggerConnectionReceipt", "onClear");
	}
}