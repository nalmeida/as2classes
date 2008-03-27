/**
* Connects a flash movie from the ActiveX component to the FlashDevelop program.
* @author Mika Palmu
* @version 1.0
*/

import org.flashdevelop.utils.*;

class org.flashdevelop.utils.FlashViewer
{
	/**
	* Public properties of the class.
	*/
	public static var limit:Number = 1000;
	
	/**
	* Private properties of the class.
	*/
	private static var movie:String;
	private static var aborted:Boolean = false;
	private static var counter:Number = 0;
	
	/**
	* Sends a trace message to the ActiveX component.
	*/
	public static function trace(message:String, level:Number)
	{
		counter++;
		if (isNaN(level)) level = TraceLevel.DEBUG;
		if (counter > limit && !aborted)
		{
			aborted = true;
			var msg:String = new String("FlashViewer aborted. You have reached the limit of maximum messages.");
			fscommand("trace", "3:" + msg);
		} 
		if (!aborted) fscommand("trace", level.toString() + ":" + message.toString());
	}
	
	/**
	* Adds compatibility with MTASC's tracing facilities.
	*/
	public static function mtrace(message:Object, method:String, path:String, line:Number):Void 
	{
		if (path.indexOf(":") < 0) 
		{
			if (movie == undefined) 
			{
				var sp:Array = unescape(_level0._url).split("///");
				if (sp.length == 1) sp = unescape(_level0._url).split("//");
				if (sp[0] == "file:") 
				{
					movie = sp[1];
					movie = movie.substr(0, movie.lastIndexOf("\\") + 1).split("|").join(":");
				}
				else movie = new String("");
			}
			path = movie + path;
		}
		var fixed:String = path.split("/").join("\\");
		var formatted:String = fixed + ":" + line + ":" + message;
		FlashViewer.trace(formatted, TraceLevel.DEBUG);
	}
	
}
