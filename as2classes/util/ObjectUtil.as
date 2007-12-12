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
	
	/**
	 * Trace the details of an object.
	 * @param	o:Object Object to be listed
	 * @return	object length
	 */
	public static function list(o:Object):Number{
		var length:Number = 0;
		trace("\n-------- ObjectUtil.listObject");
		for (var i:String in o)
			trace("\t"+i+": "+o[i]+" -- "+typeof(o[i]));
			length ++;
		trace("-------------------------\n");
		return length;
	}
	
}
