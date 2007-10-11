 /**
* @author 	MDM/Glactin
* @version 	1.0.1
*/
intrinsic class mdm.MacShell
{
	/* events */
	/* constructor */
	/* methods */
	static function close () : Void;
	static function exec (script : String) : Void;
	/* properties */
	static var exitCode:String;
	static var isRunning:Boolean;
	static var output:String;
}
