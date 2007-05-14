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
import com.fbiz.encrypt.Base64Encode;
class com.fbiz.encrypt.NPA64Encode{
	
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
		return Base64Encode.encode(e);
	}
}