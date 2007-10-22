class as2classes.util.StringUtil{

	private static var txtArrSt:Array;
	private static var txtSt:String;

	public static function wordCapitalize(txt:String):String{
		txtArrSt = txt.split(" ");
		txtSt = "";
		for(var i:Number = 0; i<txtArrSt.length; i++) {
			txtSt += txtArrSt[i].slice(0,1).toUpperCase() + "" + txtArrSt[i].slice(1).toLowerCase() + (i==(txtArrSt.length-1)?"":" ");
		}
		return txtSt;
	}
	public static function lowerCase(txt:String):String{
		return txt.toLowerCase();
	}
	public static function upperCase(txt:String):String{
		return txt.toUpperCase();
	}
	public static function capitalize(txt:String):String{
		return txt.slice(0,1).toUpperCase() + "" + txt.slice(1).toLowerCase();
	}
	
	/**
		Replaces target characters with new characters.
		
		@param source: String to replace characters from.
		@param remove: String describing characters to remove.
		@param replace: String to replace removed characters.
		@return String with characters replaced.
	*/
	public static function replace(source:String, remove:String, replace:String):String {
		return source.split(remove).join(replace);
	}
}
