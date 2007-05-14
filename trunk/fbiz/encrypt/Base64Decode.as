/**
* Encodes and decodes a base64 string.
* @authors Mika Palmu
* @version 2.0
*
* Original Javascript implementation:
* Aardwulf Systems, www.aardwulf.com
* See: http://www.aardwulf.com/tutor/base64/base64.html
*/

class com.fbiz.encrypt.Base64Decode {

	/**
	* Variables
	* @exclude
	*/
	private static var base64chars:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

	/**
	* Decodes a base64 string.
	*/
	public static function decode(src:String):String {
		var i:Number = 0;
		var output:String = new String("");
		var chr1:Number, chr2:Number, chr3:Number;
		var enc1:Number, enc2:Number, enc3:Number, enc4:Number;
		while (i < src.length) {
			enc1 = base64chars.indexOf(src.charAt(i++));
			enc2 = base64chars.indexOf(src.charAt(i++));
			enc3 = base64chars.indexOf(src.charAt(i++));
			enc4 = base64chars.indexOf(src.charAt(i++));
			chr1 = (enc1 << 2) | (enc2 >> 4);
			chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
			chr3 = ((enc3 & 3) << 6) | enc4;
			output += String.fromCharCode(chr1);
			if (enc3 != 64) output = output+String.fromCharCode(chr2);
			if (enc4 != 64) output = output+String.fromCharCode(chr3);
		}
		return output;
	}

}