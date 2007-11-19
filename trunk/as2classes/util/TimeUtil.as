
class as2classes.util.TimeUtil{
	
	private static var interval:Number;
	
	public static function setTimeout(f:Function,time:Number,args){
		args = arguments.slice(2);
		var ID, func = function(){
			f.apply(null, args);
			clearInterval(ID);
		}
		return ID = setInterval(func, time, args);
	}
	
	public static function clearTimeout(id):Void{
		clearInterval(id);
	}	
	
	public static function setGlobalTimeout(scope, func, time:Number, arg):Void{
		clearGlobalTimeout()
		interval = setInterval(_setTimeoutFunction, time, {scope:scope, func:func, arg:arg});
	}
	
	public static function clearGlobalTimeout():Void{
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
		
		clearGlobalTimeout();
	}
	
	
}
