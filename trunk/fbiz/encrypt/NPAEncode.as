/*
* Class Delay
*
* @author		Nicholas Almeida, nicholasalmeida.com
* @version		1.0
* @history		Created: 06/01/2006
*
* @usage		trace(NPA.encode("YOUR_STRING"));
*/
class com.fbiz.encrypt.NPAEncode{
	
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

}