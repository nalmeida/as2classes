/**
* Connects a flash movie to the FlashDevelop program.
* @author Mika Palmu
* @version 2.7
*/

class org.flashdevelop.utils.FlashConnect 
{
	/**
	* Variables
	*/
	private static var socket:XMLSocket;
	private static var messages:Array;
	private static var interval:Number;
	private static var swfUrl:String;
	public static var status:Number = 0;
	public static var host:String = "localhost";
	public static var port:Number = 6969;
	public static var onConnection:Function;
	public static var onReturnData:Function;

	/**
	* Constants
	*/
	public static var INFO:Number = 0;
	public static var DEBUG:Number = 1;
	public static var WARNING:Number = 2;
	public static var ERROR:Number = 3;
	public static var FATAL:Number = 4;

	/**
	* Opens the connection to the FlashDevelop program.
	*/
	public static function initialize():Void 
	{
		messages = new Array();
		socket = new XMLSocket();
		socket.onData = function(data:String) 
		{
			FlashConnect.status = 1;
			FlashConnect.onReturnData();
		}
		socket.onConnect = function(success:Boolean) 
		{
			if (success) FlashConnect.status = 1;
			else FlashConnect.status = -1;
			FlashConnect.onConnection();
		}
		interval = setInterval(sendStack, 50);
		socket.connect(host, port);
	}

	/**
	* Sends all messages in message stack to FlashDevelop.
	*/
	private static function sendStack() 
	{
		if (messages.length > 0 && status == 1) 
		{
			var message:XML = new XML();
			var rootNode:XMLNode = message.createElement("flashconnect");
			while (messages.length != 0) 
			{
				var msgNode:XMLNode = XMLNode(messages.shift());
				rootNode.appendChild(msgNode);
			}
			message.appendChild(rootNode);
			socket.send(message);
		}
	}

	/**
	* Adds a custom message to the message stack.
	*/
	public static function send(message:XMLNode):Void 
	{
		if (messages == null) initialize();
		messages.push(message);
	}

	/**
	* Adds compatibility with MTASC's tracing facilities.
	*/
	public static function mtrace(msg:Object, method:String, path:String, line:Number):Void 
	{
		if (path.indexOf(":") < 0) 
		{
			if (swfUrl == undefined) 
			{
				var sp:Array = unescape(_level0._url).split("///");
				if (sp[0] == "file:") 
				{
					swfUrl = sp[1];
					swfUrl = swfUrl.substr(0, swfUrl.lastIndexOf("/")+1).split("|").join(":");
				}
				else swfUrl = "";
			}
			path = swfUrl+path;
		}
		var message:String = path+":"+line+":"+msg;
		FlashConnect.trace(message, DEBUG);
	}

	/**
	* Adds a trace command to the message stack.
	*/
	public static function trace(msg:String, state:Number):Void 
	{
		
		if (isNaN(state)) state = DEBUG;
		var msgNode:XMLNode = new XMLNode(1, null);
		var txtNode:XMLNode = new XMLNode(3, escape(msg));
		msgNode.attributes.state = state;
		msgNode.attributes.cmd = "trace";
		msgNode.nodeName = "message";
		msgNode.appendChild(txtNode);
		send(msgNode);
		
		/*
		var debuggerSenderConnection = new LocalConnection();
			debuggerSenderConnection.connect("_debuggerConnection");
			debuggerSenderConnection.send("_debuggerConnectionReceipt", "onReceipt", msg);
		*/
	}

}
