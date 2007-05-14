/*
* Class Delay
*
* @author		Nicholas Almeida, nicholasalmeida.com
* @version		1.0
* @history		Created: 06/01/2006
*
* @usage		trace(NPA.encode("YOUR_STRING"));
*				trace(NPA.decode("YOUR_STRING"));
*/
class com.fbiz.encrypt.NPA{

	public static function decode(w:String):String {
		var d:String = w.slice(0,w.indexOf("O"));
		var a:Array = w.split("O");
		var _s:String = "";
		a.shift();
		a.pop();
		var b:Number = 0;
		while(b<a.length) {
			var s = Number(a[b]/d);
			_s += String.fromCharCode(s);
			b++;
		}
		delete b;
		return _s;
	}
}