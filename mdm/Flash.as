/**
* @author 	MDM/Glactin
* @version 	1.0.1
*/
intrinsic class mdm.Flash {
	/* events */
	/* constructor */
	/* methods */
	static function allowScale(scaleContent:Boolean, keepAspectRatio:Boolean):Void;
	static function baseURL(baseURLPath:String):Void;
	static function callFunction(functionName:String, parametersString:String, delimiter:String):Void;
	static function callFunctionUnicode(functionName:String, parametersString:String, delimiter:String):Void;
	static function getVar(variableName:String):String;
	static function getVarUnicode(variableName:String):String;
	static function loadMovie(targetLevel:Number, moviePath:String):Void;
	static function setShowAllMode():Void;
	static function setSWFDir():Void;
	static function setSWFDirAdv(swfDirectory:String):Void;
	static function setVar(variableName:String, variableValue:String):Void;
	static function setVarUnicode(variableName:String, variableValue:String):Void;
	/* properties */
}
