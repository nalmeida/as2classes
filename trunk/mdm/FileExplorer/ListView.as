/**
* @author	MDM/Glactin
* @version	1.0.1
*/
intrinsic class mdm.FileExplorer.ListView {
	/* events */
	/* constructor */
	/* methods */
	static function dblClickExecutes(flag:Boolean):Void;
	static function getItems():Array;
	static function getSelected():String;
	static function hide():Void;
	static function hideHiddenFiles():Void;
	static function showHiddenFiles():Void;
	static function setViewStyle(viewType:String):Void;
	static function show(x:Number, y:Number, width:Number, height:Number, basePath:String):Void;
	/* properties */
}
