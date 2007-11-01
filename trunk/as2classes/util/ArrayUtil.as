class as2classes.util.ArrayUtil{
	
	public static function remove(inArray:Array, elementToRemove):Array {
		var i:Number = -1;
		var t:Array  = [];
		
		while (++i < inArray.length)
			if (inArray[i] != elementToRemove)
				t.push(inArray[i]);
		
		return t;
	}

	public static function moveFirstToLast(arr:Array):Array{
		var first = arr.slice(0,1);
		arr.shift();
		arr.push(first);
		delete first;
		return arr;
	}
	
	public static function moveLastToFirst(arr:Array):Array{
		var last = arr.slice(-1);
		arr.pop();
		var newArr:Array = [];
		newArr.push(last);
		for (var i:Number = 0; i<arr.length; i++) {
			newArr.push(arr[i]);
		}
		delete last;
		return newArr;
	}
	
	public static function clear():Array{
		return [];
	}
	
	public static function removeFirst(inArray:Array):Array{
		return inArray.slice(1, inArray.length);
		
	}
	
	private function ArrayUtil() {} // Prevents instance creation
}
