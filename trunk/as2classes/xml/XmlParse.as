
// original from: http://flvz.com/downloads/classes/as2/quickparse.zip

// debug: mx.data.binding.ObjectDumper.toString(content_obj)

class as2classes.xml.XmlParse {
	
	function QuickParse () {
	
	}
	
	static function parse(currentObj:Object, currentNode:XMLNode):Void {
		
		var id:Number;
		var nodeName:Object;
		
		var i:Number;
		
		var currentNodeLength:Number;
		
		var nextNodeLength:Number;
		var nextNodeLength2:Number;
		
		currentNodeLength = currentNode.childNodes.length;
		
		for (i = 0; i < currentNodeLength; i++) {
			
			id = (currentNode.childNodes[i].attributes.id == undefined) ? "" : currentNode.childNodes[i].attributes.id;
			
			nodeName = currentNode.childNodes[i].nodeName + id;
			
			nextNodeLength = currentNode.childNodes[i].childNodes.length;
			nextNodeLength2 = currentNode.childNodes[i].firstChild.childNodes.length;
			
			currentObj[nodeName] = new Object();
			currentObj[nodeName]._name = nodeName;
			currentObj[nodeName].length = nextNodeLength;
			currentObj[nodeName].value = currentNode.childNodes[i].childNodes[0].nodeValue;
			
			//trace (currentObj[nodeName]._name + " : " + currentObj[nodeName].value);
			
			// checks if nextNode has more than 1 node
			// or if the firstChild of nextNode has more than 1 node
			if (nextNodeLength > 1 || nextNodeLength2 > 1) {
				parse(currentObj[nodeName], currentNode.childNodes[i]);
			}
			
		}
		
	}
}