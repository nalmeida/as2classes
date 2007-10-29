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

import flash.net.FileReference;

/**
	Analytics. Send data do Google Analytics using getURL method.
	
	@author Nicholas Almeida
	@version 29/10/2007 16:35
	@since Flash Player 8
	@example
		<code>
			Download.force("FILE" [, "NAME.EXTENSION"]);
		</code>
*/

class as2classes.util.Download{
	
	private static var fileRef:FileReference  = new FileReference();
	
	/**
		Force a file Download
		
		@param url:String - Full path to file.
		@param fileName:String - Sugestion of a file name. If empty, original file name will be used. Default undefined.
		@return Return none.
	*/
	public static function force(url:String, fileName:String){
		if(!url) {
			trace("ERRO: Download canceled. url not defined.");
			return;
		}
		if(!fileRef.download(url, fileName || "")) {
			trace("ERRO: Download canceled. Failed to open.");
		}
	}
	
}