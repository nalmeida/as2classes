/*
* Class Delay
*
* @author		Nicholas Almeida, nicholasalmeida.com
* @version		1.0
* @history		Created: 03/12/2006
*
* @usage		trace(NPA64.encode("YOUR_STRING"));
*				trace(NPA64.decode("YOUR_STRING"));
*/
import com.fbiz.encrypt.Base64Decode;
class com.fbiz.encrypt.NPA64Decode{
	
	public static function decode(w:String):String {
		w = Base64Decode.decode(w);
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