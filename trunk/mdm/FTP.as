/**
* @author 	MDM/Glactin
* @version 	1.0.1
*/
intrinsic class mdm.FTP {
	/* events */
	var onAborted:Function;
	var onBusy:Function;
	var onConnected:Function;
	var onDirChanged:Function;
	var onDirCreated:Function;
	var onDirDeleted:Function;
	var onError:Function;
	var onFileDeleted:Function;
	var onFileReceived:Function;
	var onFileRenamed:Function;
	var onFileSent:Function;
	var onFileTransferred:Function;
	var onIndexFileReceived:Function;
	var onListingDone:Function;
	var onLoggedIn:Function;
	var onQuit:Function;
	var onReady:Function;
	var onResolvedLinks:Function;
	/* constructor */
	function FTP(server:String, port:Number);
	/* methods */
	function abort();
	function chDir(dir:String);
	function close();
	function deleteDir(dir:String);
	function deleteFile(filename:String);
	function dirExists(dir:String);
	function fileExists(filename:String);
	function getDirAttribs(dir:String);
	function getDirDateTime(dir:String);
	function getFile(remoteFile:String, localFile:String);
	function getFileList():Array;
	function getFileDateTime(filename:String);
	function getFileAttribs(filename:String);
	function getFileSize(filename:String);
	function getFolderList():Array;
	function login(username:String, password:String);
	function makeDir(dir:String);
	function moveFile(filename:String, dir:String);
	function refresh();
	function renameFile(currentFilename:String, newFilename:String);
	function resumePosition();
	function sendCommand(command:String);
	function sendFile(localFile:String, remoteFile:String);
	function setProxy(proxyType:String, proxyServer:String, proxyPort:Number, proxyUsername:String, proxyPassword:String);
	/* properties */
	var account;
	var async;
	var bytesTransferred:Number;
	var currentDir;
	var error:String;
	var initialDir;
	var isBusy:Boolean;
	var isConnected:Boolean;
	var lastReply:String;
	var loggerData:String;
	var NOOP;
	var passive;
	var serverType;
	var success:Boolean;
	var supportsResume:Boolean;
	var timeout;
	var transferMode;
	var transferTime:Number;
}
