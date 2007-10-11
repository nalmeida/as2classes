/**
* @author 	MDM
* @version 	1.0.0
*/
intrinsic class mdm.Application.Timer {
	/* events */
	static var onTimerX:Function;
	/* constructor */
	/* methods */
	static function start(id:Number, interval:Number, cycle:Boolean):Void;
	static function stop(id:Number):Void;
	static function stopAll():Void;
	/* properties */
}
