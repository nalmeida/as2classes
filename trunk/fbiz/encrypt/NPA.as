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
	
	public static function encode(w:String):String {
		var e:String;
		var dt = Number(new Date().getMilliseconds())+1;
		e = dt+"O";
		var i:Number=0;
		while(i<w.length) {
			e += (w.charCodeAt(i))*dt + "O";
			i++;
		}
		delete i;
		delete dt;
		return e;
	}
	
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
	
	public static function help():Void{
		var h = "------------------------------------------------------------------------\n";
		h += "Delay NPA\n";
		h += "\n";
		h += "@author: Nichola Almeida, nicholasalmeida.com\n";
		h += "@version: 1.0\n";
		h += "@history: 07/04/2006\n";
		h += "\n";
		h += "Usage:\n";
		h += "	trace(NPA.encode(\"YOUR_STRING\"));\n";
		h += "	trace(NPA.decode(\"YOUR_STRING\"));\n";
		h += "\n";
		h += "Parameters:\n";
		h += "	YOUR_STRING:String = String value to be encoded or decoded.\n";
		h += "\n";
		h += "------------------------------------------------------------------------\n";
		trace(h);
	}
}