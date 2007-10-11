/**
* @author 	Glactin
* @version 	1.0.1
*/
intrinsic class mdm.Audio {
	/* events */
	/* constructor */
	/* methods */
	static function isRecording():Boolean;
	static function startRecording(filename:String, sampleRate:Number, recordingMode:Number):Void;
	static function startRecordingWithAutoOff(filename:String, sampleRate:Number, recordingMode:Number, silenceThreshold:Number, silenceDuration:Number):Void;
	static function stopRecording():Void;
	/* properties */
}