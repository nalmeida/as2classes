/**
* @author 	MDM/Glactin
* @version 	1.0.1
*/
intrinsic class mdm.Network.TCP.ProxyHTTP {
	/* events */
	/* constructor */
	/* methods */
	function getFile(serverName:String, remoteFilePath:String, localFilePath:String):Void;
	function getString(serverName:String, remoteFilePath:String):Void;
	function setProxy(proxyType:String, proxyServerAddress:String, proxyServerPortNumber:Number, username:String, password:String):Void;
	/* properties */
}
