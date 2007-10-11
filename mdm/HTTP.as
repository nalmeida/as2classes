 /**
* @author 	MDM/Glactin
* @version 	1.0.1
*/
intrinsic class mdm.HTTP
{
	/* events */
	var onBinaryTransferComplete : Function;
	var onError : Function;
	var onProgress : Function;
	var onTransferComplete : Function;
	/* constructor */
	function HTTP ();
	/* methods */
	function abort () : Void;
	function close () : Void;
	function getFile (url : String, username : String, password : String, localFilePath : String) : Void;
	function getString (url : String, username : String, password : String) : String;
	/* properties */
}
