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
	
/**
	XML Parsre. Convert an XML data to an Object.
	
	@author Jack Doyle, jack@greensock.com
	@version 
	@since Flash Player 8
	@example
		<code>
			var str = "<Resources>"
				str+= "<Book name=\"Mary Poppins\" ISDN=\"1122563\" />"
				str+= "<Book name=\"The Bible\" ISDN=\"333777\" />"
				str+= "<Novel name=\"The Screwtape Letters\" ISDN=\"257896\">"
				str+= "		<Description>This is an interesting perspective</Description>"
				str+= "</Novel>"
				str+= "</Resources>"
			
			trace(XMLParser.parse(str).Book[0].name);
			trace(XMLParser.parse(str).Novel[0].Description[0].value);
		</code>
*/

class as2classes.xml.XmlParse {
	
	/**
		parse function 
		
		@param xml_obj:XML or String - XML or String.
		@param results_obj:Object - Object will receieve the result. Optional param.
		@param keepRootNode_bol:Boolean - If you neeed to preserve the root note. Optional param. Default false.
		@return Return Object.
	*/
	public static function parse(xml_obj, results_obj:Object, keepRootNode_bol:Boolean):Object { //results_obj is optional - it allows you to define an object to append all the properties/arrays to.
		var x;
		if(typeof(xml_obj) == "string"){
			x = new XML(xml_obj);
		} else {
			x = xml_obj; //To avoid typing errors
		}
		results_obj = results_obj || {};
		var c = x.firstChild; //"c" is for current_node
		var last_node = x.firstChild;
		x.obj = results_obj; //Allows us to tack on all the arrays and objects to this instance for easy retrieval by the user. If this causes a problem, we could create a public object variable that holds everything, but this simplifies things for the user.
		if (keepRootNode_bol != true) {
			c = c.firstChild;
			last_node = x.firstChild.lastChild;
			x.firstChild.obj = results_obj; //Allows us to tack on all the arrays and objects to this instance for easy retrieval by the user. If this causes a problem, we could create a public object variable that holds everything, but this simplifies things for the user.
		}
		while(c != undefined) {
			//We ran into an issue where Flash was creating an extra subnode anytime we had content in a node like <NODE>My Content</NODE>. The tip off is when the nodeName is null and the nodeType is 3 (text).
			if (c.nodeName == null && c.nodeType == 3) {
				c.parentNode.obj.value = c.nodeValue;
			} else {
				var o = {};
				for (var att in c.attributes) {
					o[att] = c.attributes[att];
				}
				var pn = c.parentNode.obj;
				if (pn[c.nodeName] == undefined) {
					pn[c.nodeName] = [];
				}
				c.obj = o;
				pn[c.nodeName].push(o);
			}
			
			if (c.childNodes.length > 0) {
				c = c.childNodes[0];
			} else {
				var next_node = c;
				while(next_node.nextSibling == undefined && next_node.parentNode != undefined) {
					next_node = next_node.parentNode;
				}
				c = next_node.nextSibling;
				if (next_node == last_node) {
					c = undefined;
				}
			}
		}
		return results_obj;
	}
}