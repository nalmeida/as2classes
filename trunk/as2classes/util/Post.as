/*
	AS2classes Framework for ActionScript 2.0
	Copyright (C) 2007  Nicholas Almeida
	http://nicholasalmeida.com
	
	This library is free software; you can redistribute it and/or
	modify it under the terms of the GNU Lesser General Public
	License as published by the Free Software Foundation; either
	version 2.1 of the License, or (at your option) any later version.
	http://www.gnu.org/licenses/lgpl.html
	
	This library is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
	Lesser General Public License for more details.
*/

import as2classes.util.ObjectUtil;

/**
	Post Class. A static function to post data to server using the sendAndLoad method.
	
	@author Nicholas Almeida
	@version 31/07/2007
	@since Flash Player 8
	@example
		<code>
			Post.send({
				url: "http://farte/nicholas/log_post.asp",
				parameters: {firstName:"nicholas", lastName:"almeida", test:"!@#3уч"},
				onInit: function(extra){
					trace("init called: " + extra);
				},
				onError: function(answer, extra){
					trace("ERROR: Answer: " + answer + " extra: " + extra); 
				},
				onFinish: function(answer, extra){
					trace("Answer: " + answer + " extra: " + extra); 
				},
				extra: "test"
			});
		</code>
*/

class as2classes.util.Post{
	
	private static var url:String;
	private static var parameters:Object;
	private static var onInit:Function;
	private static var onFinish:Function;
	private static var onError:Function;
	private static var extra;
	
	private static var result:LoadVars;
	private static var sender:LoadVars;
	
	/**
		Send data to server.
		
		@param obj.url:String - URL server side page.
		@param obj.parameters:Object - Data will be sent do server.
		@param obj.method:String - Method to send data to server. Default "POST".
		@param obj.onInit:Function - Function invoqued when the class starts sending.
		@param obj.onError:Function - Function invoqued when some error ocurred.
		@param obj.onFinish:Function - Function invoqued when the chass receive data from server.
		@param obj.extra - Anything you want.
		@return Return none.
	*/
	public static function send(obj:Object):Void{
		
		url = obj.url;
		parameters = obj.parameters;
		
		onInit = obj.onInit;
		onFinish = obj.onFinish;
		onError = obj.onError;
		extra = obj.extra;
		
		
		if(!url){
			trace("ERROR: URL not defined.");
			return;
		}
		if(!parameters){
			trace("ERROR: Parameters not defined.");
			return;
		}
		
		result = new LoadVars();
		result.onLoad = _onFinish;
		
		sender = new LoadVars();
		addParams();
		sender.sendAndLoad(url, result, (obj.method || "POST"));
		
		trace("-------------------------------------------------------");
		trace(" ** New Post STARTED: " + url);
		onInit(extra);
	}
	
	/**
		Receive data from server.
		
		@param success:Boolean - If the server response.
		@return Return none.
	*/
	private static function _onFinish(success:Boolean){
		if(success){
			var answer:String = result.toString();
			answer = answer.split("&onLoad=%5Btype%20Function%5D")[0]; // removing the "&onLoad=%5Btype%20Function%5D" text
			trace(" >> Post COMPLETE: " + answer);
			trace("-------------------------------------------------------");			
			onFinish(answer, extra);
		} else {
			var errorNumber:Number;
			if(result.toString() == "onLoad=%5Btype%20Function%5D"){
				errorNumber = 404;
			}
			trace(" !! Loader ERROR: " + errorNumber + " -- url: " + url + " -- answer: " + result);
			trace("-------------------------------------------------------");
			onError(errorNumber, extra);
		}
	}
	
	/**
		Add the parameters data to sender.

		@return Return none.
	*/
	private static function addParams():Void{
		ObjectUtil.reverseObject(parameters);
		for (var i in parameters){
			sender[i] = parameters[i];
		}
	}
	
	private function Post(){} // Avoid instance creation.
	
}