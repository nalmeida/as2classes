class as2classes.util.ArrayUtil{
	
	

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
	
	private function ArrayUtil() {} // Prevents instance creation
}
