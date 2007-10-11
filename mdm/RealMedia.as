﻿/**
* @author 	MDM
* @version 	1.0.0
* @verison 1.0.1 author Ashima Kohli
*/
intrinsic class mdm.RealMedia {
	/* events */
	/* constructor */
	function RealMedia(x:Number, y:Number, width:Number, height:Number, file:String):Void;
	/* methods */
	function close():Void;
	function hide():Void;
	function fullScreen():Void;
	function mute():Void;
	function play():Void;
	function pause():Void;
	function show():Void;
	function stop():Void;
	/* properties */
	var duration:Number;
	var height:Number;
	var isInstalled:Boolean;
	var position:Number;
	var visible:Boolean;
	var width:Number;
	var x:Number;
	var y:Number;
}
