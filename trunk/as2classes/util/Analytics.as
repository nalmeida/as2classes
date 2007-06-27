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

import flash.external.ExternalInterface;

/**
	Analytics. Send data do Google Analytics using ExternalInterface method.
	
	@author Nicholas Almeida
	@version 27/06/07
	@since Flash Player 8
	@example
		<code>
			Analytics.call("home", "_open");
		</code>
*/

class as2classes.util.Analytics{

	public static function call():Void{
		trace("-------------------------------------------------------");
		var strToSend:String="/";
		for(var i=0; i<arguments.length;i++){
			strToSend += arguments[i] + ((i<arguments.length-1) ? "/" : "");
		}
		trace(" >  Sending urchinTracker: " + strToSend);
		if(_root._url.indexOf("file") != 0) {
			ExternalInterface.call("urchinTracker", strToSend);
		} else {
			trace("    WARINING: Running local file or StandAlone mode. \"" + "urchinTracker('" + strToSend + "');\" refused.");
		}
		delete strToSend;
		trace("-------------------------------------------------------");
	}
	
	function Analytics(){ } // Prevents instance creation
}
