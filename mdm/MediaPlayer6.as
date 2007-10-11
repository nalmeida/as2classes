 /**
* @author 	MDM/Glactin
* @version 	1.0.1
*/
intrinsic class mdm.MediaPlayer6
{
	/* events */
	var onMPChangeState : Function;
	/* constructor */
	function MediaPlayer6 (x:Number, y:Number, width:Number, height:Number, file:String);
	/* methods */
	function close () : Void;
	function fastForward () : Void;
	function fastReverse () : Void;
	function fullscreen ():Void;
	function hide () : Void;
	function mute (muteFlag : Boolean) : Void;
	function noMenu () : Void;
	function pause () : Void;
	function play () : Void;
	function show () : Void;
	function stop () : Void;
	/* properties */
	var balance : Number;
	var canScan:Boolean;
	var canSeek:Boolean;
	var duration : Number;
	var height : Number;
	var isInstalled : Boolean;
	var position : Number;
	var volume : Number;
	var visible : Boolean;
	var width : Number;
	var x : Number;
	var y : Number;
}
