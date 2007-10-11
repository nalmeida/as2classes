 /**
* @author	MDM/Glactin
* @version	1.0.1
*/
intrinsic class mdm.DLL
{
	/* events */
	/* constructor */
	function DLL(dll:String):Boolean;
	/* methods */
	static function addParameter (parameterType : String, parameterValue : String) : Number;
	static function call (returnType : String, procedureName : String);
	static function clear () : Void;
	static function close () : Void;
	/* properties */
}
