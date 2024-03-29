﻿/**
* @author 	MDM/Glactin
* @version 	1.0.1
*/
intrinsic class mdm.Network.TCP.FileServer {
	/* events */
	/* constructor */
	function FileServer();
	/* methods */
	function getFile(remoteIPAddress:String, remotePortNumber:Number, remoteFilePath:String, localFilePath:String):Void;
	function getFileList(remoteIPAddress:String, remotePortNumber:Number, remoteBaseFolder:String):String;
	function getFolderList(remoteIPAddress:String, remotePortNumber:Number, remoteBaseFolder:String):String;
	function sendFile(remoteIPAddress:String, remotePortNumber:Number, localIPAddress:String, localPortNumber:Number, localFilePath:String, remoteFilePath:String):Void;
	function startServer(localPortNumber:Number):Void;
	function stopServer():Void;
	/* properties */
}
