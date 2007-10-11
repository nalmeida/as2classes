/**
* @author	MDM/Glactin
* @version	1.0.1
*/
intrinsic class mdm.FileExplorer.TreeView {
	/* events */
	/* constructor */
	/* methods */
	static function getItems():Array;
	static function getSelected():String;
	static function getPath():String;
	static function hide():Void;
	static function hideHiddenFiles():Void;
	static function setPath(basePath:String):Void;
	static function show(x:Number, y:Number, width:Number, height:Number, basePath:String):Void;
	static function showHiddenFiles():Void;
	/* properties */
}
