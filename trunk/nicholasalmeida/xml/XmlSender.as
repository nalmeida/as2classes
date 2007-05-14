/*
* Class Delay
*
* @author		Nicholas Almeida, nicholasalmeida.com
* @version		1.0
* @history		Created: 23/03/2006
*
* @usage		import XmlSender;
* 				new XmlSender({
						url:"URL", 
						xml:"XML", 
						onInit:function(extra), 
						onFinish:function(answer, extra), 
						onError:function(answer, extra), 
						extra:extra
				});
*/
class com.nicholasalmeida.xml.XmlSender{
	private static var xmlToSend:XML;
	private static var xmlLoader:XML;
	public static var arrQueue:Array;
	
	function XmlSender(o:Object){
		if(!o.url){
			trace("ERROR: URL not defined.");
			return;
		}
		if(!o.xml){
			trace("ERROR: XML not defined.");
			return;
		}
		
		if(!arrQueue) arrQueue = new Array();
		arrQueue.push(o);

		if(arrQueue[0]==o){
			send(arrQueue[0]);
		}
	}
	
	private static function send(o:Object){
		
		xmlToSend = new XML(o.xml);
		xmlLoader = new XML();
		xmlLoader.ignoreWhite = true;
		
		xmlLoader.onLoad = function (success) {
			if (success) {
				var errorMessage:String;
				if (this.status == 0) {
					o.onFinish(this, o.extra);
					arrQueue.shift();
					if(arrQueue.length > 0) {
						send(arrQueue[0]);
					}
					return;
				} else {
					errorMessage = "<root>XML was loaded successfully, but was unable to be parsed. ERROR: ";
				}
				switch (this.status) {
					case 0 :
						errorMessage += "No error; parse was completed successfully.";
						break;
					case -2 :
						errorMessage += "A CDATA section was not properly terminated.";
						break;
					case -3 :
						errorMessage += "The XML declaration was not properly terminated.";
						break;
					case -4 :
						errorMessage += "The DOCTYPE declaration was not properly terminated.";
						break;
					case -5 :
						errorMessage += "A comment was not properly terminated.";
						break;
					case -6 :
						errorMessage += "An XML element was malformed.";
						break;
					case -7 :
						errorMessage += "Out of memory.";
						break;
					case -8 :
						errorMessage += "An attribute value was not properly terminated.";
						break;
					case -9 :
						errorMessage += "A start-tag was not matched with an end-tag.";
						break;
					case -10 :
						errorMessage += "An end-tag was encountered without a matching start-tag.";
						break;
					default :
					errorMessage += "An unknown error has occurred.";
					break;
				}
				o.onError(errorMessage+"</root>", o.extra);
			} else {
				o.onError("<root>There was an error parsing the XML data</root>", o.extra);
			}
			delete this;
		};
		
		xmlToSend.sendAndLoad(o.url, xmlLoader, xmlToSend, "POST");
		o.onInit(o.extra);
	}
	
	public static function help():Void{
				var h = "------------------------------------------------------------------------\n";
		h += "XmlSender Class\n";
		h += "\n";
		h += "@author: Nichola Almeida, nicholasalmeida.com\n";
		h += "@version: 1.0\n";
		h += "@history: 23/03/2006\n";
		h += "\n";
		h += "Usage:\n";
		h += "new XmlSender({\n";
		h += "	url:\"URL\", \n";
		h += "	xml:\"XML\", \n";
		h += "	onInit:function(extra), \n";
		h += "	onFinish:function(answer, extra), \n";
		h += "	onError:function(answer, extra), \n";
		h += "	extra:extra\n";
		h += "});\n";
		h += "\n";
		h += "Parameters:\n";
		h += "	url:String = Path to server page.\n";
		h += "	xml:String or XML = XML to send.\n";
		h += "	onInit:Function = Function to be executed when the send proccess starts. Receive the extra parameter.\n";
		h += "	onFinish:Function = Function to be executed when the send proccess finishes. Receive the answer of the request and the extra parameter.\n";
		h += "	onError:Function = Function to be executed when the send proccess have some problem. Receive the answer of the request and the extra parameter.\n";
		h += "	extra = Any extra parameter. Can be a String, Array, Object, MovieClip, etc\n\n";
		h += "	Method: \"POST\"\n";
		h += "\n";
		h += "------------------------------------------------------------------------\n";
		trace(h);
	}
	
}



