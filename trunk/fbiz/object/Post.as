/*
* Class Post
*
* @author		Nicholas Almeida, nicholasalmeida.com
* @version		1.0
* @history		Created: 10/05/2006
*
* @usage		import Post;
* 				new Post({
						url:"URL", 
						parameters:"Object", 
						onInit:function(extra), 
						onFinish:function(answer, extra), 
						onError:function(answer, extra), 
						extra:extra
				});
*/
class com.fbiz.object.Post{
	private static var varsToSend:LoadVars;
	private static var varsLoader:LoadVars;
	public  static var arrQueue:Array;
	
	function Post(o:Object){
		if(!o.url){
			trace("ERROR: URL not defined.");
			return;
		}
		if(!o.parameters){
			trace("ERROR: Parameters not defined.");
			return;
		}
		
		if(!arrQueue) arrQueue = new Array();
		arrQueue.push(o);

		if(arrQueue[0]==o){
			send(arrQueue[0]);
		}
	}
	
	private static function send(o:Object){
		
		varsToSend = new LoadVars();
		for (var i in o.parameters)
			varsToSend[i] = o.parameters[i];
		
		varsLoader = new LoadVars();
		
		varsLoader.onLoad = function (success) {
			if (success) {
				delete (this.onLoad);
				o.onFinish(this, o.extra);
				arrQueue.shift();
				if(arrQueue.length > 0) {
					send(arrQueue[0]);
				}
				return;
				
			} else {
				o.onError("There was an error to parse the answer.", o.extra);
				arrQueue.shift();
				if(arrQueue.length > 0) {
					send(arrQueue[0]);
				}
			}
			delete this;
		};
		
		varsToSend.sendAndLoad(o.url, varsLoader, "POST");
		o.onInit(o.extra);
	}
	
	public static function help():Void{
		var h = "------------------------------------------------------------------------\n";
		h += "Post Class\n";
		h += "\n";
		h += "@author: Nichola Almeida, nicholasalmeida.com\n";
		h += "@version: 1.0\n";
		h += "@history: 10/05/2006\n";
		h += "\n";
		h += "Usage:\n";
		h += "new Post({\n";
		h += "	url:\"URL\", \n";
		h += "	parameters:\"Object\", \n";
		h += "	onInit:function(extra), \n";
		h += "	onFinish:function(answer, extra), \n";
		h += "	onError:function(answer, extra), \n";
		h += "	extra:extra\n";
		h += "});\n";
		h += "\n";
		h += "Parameters:\n";
		h += "	url:String = Path to server page.\n";
		h += "	parameters:Object = Object to send.\n";
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



