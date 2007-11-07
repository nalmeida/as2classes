
class as2classes.util.TimeUtil{
	
	private static var interval:Number;
	
	private function TimeUtil(){}
	
	public static function setTimeout(scope, func, time:Number, arg):Void{
		clearTimeout()
		interval = setInterval(_setTimeoutFunction, time, {scope:scope, func:func, arg:arg});
	}
	
	public static function clearTimeout():Void{
		clearInterval(interval);
	}
	
	private static function _setTimeoutFunction(obj:Object):Void{
		
		var scope:Object = obj.scope;
		var func = obj.func;
		var arg = obj.arg || undefined;
		
		if(typeof func == "string"){
			scope[func].apply(scope, [arg]);
		} else if(typeof func == "function"){
			func(arg)
		}
		
		clearTimeout();
	}
	
	
}
