/**
* @author 	MDM
* @version 	1.0.0
* @verison 1.0.1 author Ashima Kohli
*/
intrinsic class mdm.Process {
	/* events */
	/* constructor */
	/* methods */
	static function close():Void;
	static function create(title:String, xPos:Number, yPos:Number, width:Number, height:Number, appName:String, app:String, startInFolder:String, priority:Number, windowStatus:Number):Void;
	static function kill():Void;
	static function killById(id:Number, timeout:Number):Void;
	/* properties */
	static var isOpen:Boolean;
	static var lastId:Number;
}
