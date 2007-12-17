/*
* Class XmlSender
*
* @author		Nicholas Almeida, nicholasalmeida.com
* @version		2.2
* @history		Created: 23/03/2006
* @history		History: 23/05/2007 - help method removed. MTASC compatible.
* @history		History: 11/06/2007 - new parameter added at the onFinish Method. objXml is the answer parsed by XmlParse class.
*
* @usage		import XmlSender;
* 				
				XmlSender.send({
					url:"URL", 
					xml:"XML", 
					onInit:function(extra){
					}, 
					onFinish:function(answer, extra, objXml){
					}, 
					onError:function(answer, extra){
					}, 
					extra:extra
				});
*/

import as2classes.xml.XmlParse;

class as2classes.xml.XmlSender{
	
	private static var xmlToSend:XML;
	private static var xmlLoader:XML;
	public  static var arrQueue:Array = [];
	
	function XmlSender(o:Object){
		if(!o.url){
			trace("ERROR: URL not defined.");
			return;
		}
		if(!o.xml){
			trace("ERROR: XML not defined.");
			return;
		}
		
		arrQueue.push(o);

		if(arrQueue[0] == o){
			send(arrQueue[0]);
		}
	}
	
	public static function send(o:Object){
		
		System.useCodepage = true; 
		
		xmlToSend = new XML(o.xml);
		xmlLoader = new XML();
		xmlLoader.ignoreWhite = true;
		
		xmlLoader.onLoad = function (success) {
			if (success) {
				var errorMessage:String;
				if (this.status == 0) {
					var parsedXml:Object = {};
						XmlParse.parse(this, parsedXml);
					o.onFinish(this, o.extra, parsedXml);
					delete parsedXml;
					XmlSender.arrQueue.shift();
					if(XmlSender.arrQueue.length > 0) {
						XmlSender.send(XmlSender.arrQueue[0]);
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
				XmlSender.arrQueue.shift();
				if(XmlSender.arrQueue.length > 0) {
					XmlSender.send(XmlSender.arrQueue[0]);
				}
			}
			delete this;
		};
		xmlToSend.sendAndLoad(o.url, xmlLoader, xmlToSend, "POST");
		o.onInit(o.extra);
	}
	
}



