/*
* Class Delay
*
* @author		Nicholas Almeida, nicholasalmeida.com
* @version		1.0
* @history		Created: 06/01/2006
*
* @usage		import Delay;
* 				var d:Delay = new Delay("FUNCTION", TIME, [ARGUMENTS]);
*/
class com.fbiz.util.Delay{
	private var f;
	private var t;
	private var a;
	
	function Delay($f,$t:Number,$a){
		
		if (!$t) {
			trace("Delay Error: Time should get a value.");
		}
		
		f = $f;
		t = $t;
		a = $a;
		
		var delayInt = setInterval(clearDelay, t, f, a);

		function clearDelay(f,a):Void{
			if(typeof(f) == "string"){
				eval(f)(a);
			} else if (typeof(f) == "function"){
				f(a);
			} else {
				trace("Delay Error: Function type isn't STRING or FUNCTION");
			}
			clearInterval(delayInt);
		}
	}
	
	public static function help():Void{
		var h = "------------------------------------------------------------------------\n";
		h += "Delay Class\n";
		h += "\n";
		h += "@author: Nichola Almeida, nicholasalmeida.com\n";
		h += "@version: 1.0\n";
		h += "@history: 06/01/2006\n";
		h += "\n";
		h += "Usage:\n";
		h += "	var d:Delay = new Delay(\"FUNCTION\", TIME, [ARGUMENTS]);\n";
		h += "\n";
		h += "Parameters:\n";
		h += "	FUNCTION = Name of your function. Should be STRING or FUNCTION.\n";
		h += "	TIME:Number = Delay time in miliseconds.\n";
		h += "	ARGUMENTS:(Object, Array or Value)[OPTIONAL] = Arguments sent to function.\n";
		h += "\n";
		h += "------------------------------------------------------------------------\n";
		trace(h);
	}
}