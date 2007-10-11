/**
* @author 	MDM/Glactin
* @version 	1.0.1
*/
intrinsic class mdm.PDF6 {
	/* events */
	/* constructor */
	function PDF6(x:Number, y:Number, width:Number, height:Number, pdf:String);
	/* methods */
	function close():Void;
	function firstPage():Void;
	function hide():Void;
	function lastPage():Void;
	function loadFile(filePath:String):Void;
	function nextPage():Void;
	function print():Void;
	function printWithDialog():Void;
	function printAll():Void;
	function printPages(printFromPage:Number, printToPage:Number):Void;
	function previousPage():Void;
	function setCurrentPage(targetPage:Number):Void;
	function show():Void;
	/* properties */
	var height:Number;
	var scrollbars:Boolean;
	var toolbar:Boolean;
	var visible:Boolean;
	var width:Number;
	var x:Number;
	var y:Number;
}
