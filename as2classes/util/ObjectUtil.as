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
	
}
