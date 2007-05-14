// orginal from http://www.zefxis.gr/en/article-delegates/
/* usage


	class MyClass {
	
		private var interval:Number;
		private var intervalDelegate:Function;
	
		private function init():Void {
			intervalDelegate = Delegate.create(this, doStuff);
			interval = setInterval(intervalDelegate, 1000);
		}
	
		private function doStuff():Void {
			// do various stuff
			if (.......) {
				clearInterval(interval);
				Delegate.destroy(intervalDelegate);
				delete intervalDelegate;
			}
		}
	} 


*/
class com.fbiz.util.Delegate extends Object {
	
	public static var stack:Object = {};
	private static var _i:Number = 0;

	public static function create(obj:Object, _func:Function):Function {
		stack[_i] = function() {
			var self:Function = arguments.callee;
			var _scope:Object = self._scope;
			var _func:Function = self._func;
			var _arg:Array = self._arg;
	
			return _func.apply(_scope, arguments.concat(_arg));
		};
		
		var f = stack[_i];
		stack[_i]._scope = obj;
		stack[_i]._func = _func;
		stack[_i]._arg = arguments.splice(2);
		stack[_i]._i = _i;
		_i++;
		
		return f;
	}
	
	public static function destroy(f:Function):Void {
		if (!f || f._i == undefined) return;
		delete f._scope;
		delete f._func;
		delete f._arg;
		delete stack[f._i];
		delete f._i;
	}
	
}