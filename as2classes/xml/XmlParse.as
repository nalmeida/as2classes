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
	
	@author Jack Doyle, jack@greensock.com // http://blog.greensock.com/xmlparseras2/
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
			
			trace(XmlParse.parse(str).Book[0].name);
			trace(XmlParse.parse(str).Novel[0].Description[0].value);
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
	
	
	/**
		objectToXML function 
		Allows us to translate an object (typically with arrays attached to it) back into an XML object. This is useful when we need to send it back to the server or save it somewhere.
		
		@param o:Object - Object to be converted to XML.
		@param rootNodeName_str:String - Root node name. Default "XML".
		@return Return XML.
	*/
	public static function objectToXML(o:Object, rootNodeName_str:String):XML {
		if (rootNodeName_str == undefined) {
			rootNodeName_str = "XML";
		}
		var xml:XML = new XML();
		var n:XMLNode = xml.createElement(rootNodeName_str);
		var props:Array = [];
		var prop, p, tn:XMLNode;
		for (p in o) {
			props.push(p);
		}
		for (p = props.length - 1; p >= 0; p--) { //By default, attributes are looped through in reverse, so we go the opposite way to accommodate for this.
			prop = props[p];
			if (typeof(o[prop]) == "object" && o[prop].length > 0) { //Means it's an array!
				arrayToNodes(o[prop], n, xml, prop);
			} else if (prop == "value") {
				tn = xml.createTextNode(o.value);
				n.appendChild(tn);
			} else {
				n.attributes[prop] = o[prop];
			}
		}
		xml.appendChild(n);
		return xml;
	}
	
	//Recursive function that walks through any sub-arrays as well...
	private static function arrayToNodes(ar:Array, parentNode:XMLNode, xml:XML, nodeName_str:String):Void {
		var chldrn:Array = [];
		var props:Array, prop, n:XMLNode, o:Object, i:Number, p;
		for (i = ar.length - 1; i >= 0; i--) {
			n = xml.createElement(nodeName_str);
			o = ar[i];
			props = [];
			for (p in o) {
				props.push(p);
			}
			for (p = props.length - 1; p >= 0; p--) { //By default, attributes are looped through in reverse, so we go the opposite way to accommodate for this.
				prop = props[p];
				if (typeof(o[prop]) == "object" && o[prop].length > 0) { //Means it's an array!
					arrayToNodes(o[prop], n, xml, prop);
				} else if (prop != "value") {
					n.attributes[prop] = o[prop];
				} else {
					var tn:XMLNode = xml.createTextNode(o.value);
					n.appendChild(tn);
				}
			}
			chldrn.push(n);
		}
		for (i = chldrn.length - 1; i >= 0; i--) {
			parentNode.appendChild(chldrn[i]);
		}
	}
}