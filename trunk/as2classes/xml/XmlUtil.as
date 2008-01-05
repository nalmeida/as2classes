
class as2classes.xml.XmlUtil{
	
	/**
		Returns a node contet;
		
		@param $inputXml: String or XML to get nodes from.
		@return XML ChildNodes.
	*/
	public static function getNodeContent($inputXml):XML{
		var x:XML = new XML($inputXml);
			x.ignoreWhite = true;
		var arr:Array = x.firstChild.childNodes;
		var str:String = "";
		for (var j:Number = 0; j < arr.length; j++) {
			str += arr[j];
		}
		return new XML(str);
	}
}