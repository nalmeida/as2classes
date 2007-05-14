/*
* Class Tracker
*
* @author		Nicholas Almeida, nicholasalmeida.com
* @version		1.0
* @history		Created: 07/07/2006
*
* @usage		import Tracker;
* 				new Tracker("section", "subsection", "item");
* 				or
* 				var tracker:Tracker = new Tracker();
* 					tracker.send("section", "subsection", "item");
*/

class com.fbiz.util.Tracker{
	
	
	
	function Tracker(){
		if(arguments.length>0){
			send(arguments);
		}
	}
	
	
	
	public function send():Void{
		trace("-------------------------------------------------------");
		var strToSend:String="/";
		for(var i=0; i<arguments.length;i++){
			strToSend += arguments[i] + ((i<arguments.length-1) ? "/" : "");
		}
		trace(" >  Sending urchinTracker: " + strToSend);
		if(_url.indexOf("file") != 0) {
			getURL("javascript:urchinTracker('" + strToSend + "');");
		} else {
			trace("    WARINING: Running local file or StandAlone mode. \"" + "javascript:urchinTracker('" + strToSend + "');\" refused.");
		}
		delete strToSend;
		trace("-------------------------------------------------------");
	}
}