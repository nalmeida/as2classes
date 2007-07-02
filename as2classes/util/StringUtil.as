class as2classes.util.StringUtil{

	private static var txtArrSt:Array;
	private static var txtSt:String;

	static public function wordCapitalize(txt:String):String{
		txtArrSt = txt.split(" ");
		txtSt = "";
		for(var i:Number = 0; i<txtArrSt.length; i++) {
			txtSt += txtArrSt[i].slice(0,1).toUpperCase() + "" + txtArrSt[i].slice(1).toLowerCase() + (i==(txtArrSt.length-1)?"":" ");
		}
		return txtSt;
	}
	static public function lowerCase(txt:String):String{
		return txt.toLowerCase();
	}
	static public function upperCase(txt:String):String{
		return txt.toUpperCase();
	}
	static public function capitalize(txt:String):String{
		return txt.slice(0,1).toUpperCase() + "" + txt.slice(1).toLowerCase();
	}
}
