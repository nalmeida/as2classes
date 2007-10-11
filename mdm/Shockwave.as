/**
* @author 	MDM
* @version 	1.0.0
* @verison 1.0.1 author Ashima Kohli
*/
intrinsic class mdm.Shockwave {
	/* events */
	/* constructor */
	function Shockwave(x:Number, y:Number, width:Number, height:Number, file:String):Void;
	/* methods */
	
	static function close():Void;

	static function evaluateScript(scriptString:String):Void;
	static function gotoFrame(frame:Number):Void;
	static function gotoMovie(filePath:String):Void;
	static function play():Void;
	static function rewind():Void;
	static function	stop():Void;

	static function swBackColor(backgroundColor:Number):Void;
	static function swBanner(bannerText:String):Void;
	static function swColor(instanceColor:Number):Void;
	static function swForeColor(foregroundColor:Number):Void;
	static function swFrame(frame:Number):Void;
	static function swAudio(filePath:String):Void;
	static function swList(delimitedKeys:String):Void;
	static function swName(nameValue:String):Void;
	static function swPassword(passwordValue:String):Void;
	static function swPreLoadTime(preloadTime:Number):Void;
	static function swSound(filePath:String):Void;
	static function swText(nameValue:String):Void;
	static function swVolume(soundLevel:Number):Void;
	/* properties */
	var bgcolor:Void;
	var currentFrame:Number;
	var height:Number;
	var visible:Boolean;
	var width:Number;
	var x:Number;
	var y:Number;
}
