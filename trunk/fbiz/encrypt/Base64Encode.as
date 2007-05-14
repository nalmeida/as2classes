/**
* Encodes and decodes a base64 string.
* @authors Mika Palmu
* @version 2.0
*
* Original Javascript implementation:
* Aardwulf Systems, www.aardwulf.com
* See: http://www.aardwulf.com/tutor/base64/base64.html
*/

class com.fbiz.encrypt.Base64Encode {

	/**
	* Variables
	* @exclude
	*/
	private static var base64chars:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

	/**
	* Encodes a base64 string.
	*/
	public static function encode(src:String):String {
		var i:Number = 0;
		var output:String = new String("");
		var chr1:Number, chr2:Number, chr3:Number;
		var enc1:Number, enc2:Number, enc3:Number, enc4:Number;
		while (i < src.length) {
			chr1 = src.charCodeAt(i++);
			chr2 = src.charCodeAt(i++);
			chr3 = src.charCodeAt(i++);
			enc1 = chr1 >> 2;
			enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
			enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
			enc4 = chr3 & 63;
			if(isNaN(chr2)) enc3 = enc4 = 64;
			else if(isNaN(chr3)) enc4 = 64;
			output += base64chars.charAt(enc1)+base64chars.charAt(enc2);
			output += base64chars.charAt(enc3)+base64chars.charAt(enc4)
		}
		return output;
	}

}