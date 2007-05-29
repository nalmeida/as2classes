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
class as2classes.util.Delay{
	private var f;
	private var t:Number;
	private var a;
	private var delayInt:Number;
	
	function Delay($f,$t:Number,$a){
		
		if (!$t) {
			trace("Delay Error: Time should get a value.");
		}
		
		f = $f;
		t = $t;
		a = $a;
		
		delayInt = setInterval(clearDelay, t, f, a);
	}
	
	private function clearDelay(f,a):Void{
		if(typeof(f) == "string"){
			this[f](a);
		} else if (typeof(f) == "function"){
			f(a);
		} else {
			trace("Delay Error: Function type isn't STRING or FUNCTION");
		}
		clearInterval(delayInt);
	}
}