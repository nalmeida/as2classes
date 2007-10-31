class as2classes.util.ObjectUtil{
	
	public static function reverseObject(o:Object):Void{
        var a:Array = [];
        var s:Object = {};
        var p:Object = {};

        for(var n:String in o){
			a.push(n);
		}
        a.reverse();
        var i:Number = a.length;
        while(i--) {
			p = a[i];
			s = o[p];
			delete o[p];
			o[p] = s;
        }
	}
	
	
	private static var objText:String;
	private static var tabs:String = "\t";
	
	/**
	 * Trace the details of an object.
	 * @param	o:Object Object to be listed
	 * @return	nothing.
	 */
	public static function list(o:Object):Void{
		objText = "";
		trace("\n--------ObjectUtil.listObject");
		for (var i:String in o)
			trace("\t"+i+": "+o[i]+" -- "+typeof(o[i]));
		trace("-------------------------\n");
	}
	
}
