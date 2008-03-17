/**
* ...
* @author Default
* @version 0.1
*/

import as2classes.loader.FlvLoader;
import as2classes.util.Delegate;
import as2classes.util.MovieclipUtil;
import as2classes.util.SO;

class as2classes.video.VideoPlayerComponent extends MovieClip{

	private var mcVideoPlayer:MovieClip;
	private var btStartLoading:MovieClip;
	private var mcControls:MovieClip;
	private var btRewind:MovieClip;
	private var mcPlayPause:MovieClip;
		private var btPause:MovieClip;
		private var btPlay:MovieClip;
	private var fileToLoad:String;
	
	private var mcTrack:MovieClip;
		private var mcSlider:MovieClip;
		private var mcMask:MovieClip;
		private var mcProgress:MovieClip;
		private var mcTrackBg:MovieClip;
	private var sliderPressed:Boolean;
	
	private var mcVolume:MovieClip;
		private var mcVolumeTrack:MovieClip;
		private var mcVolumeSlider:MovieClip;
		private var mcVolumeStatus:MovieClip;
	
	private var autoLoad:Boolean;
	private var autoPlay:Boolean;
	private var startAfter:Number;
	
	private var loaderManager:FlvLoader;
	private var soundObj:Sound;

	public 	var mcVideo:Video;
	public 	var state:String;
	public 	var interval:Number;
	public 	var started:Boolean;
	
	// Handlers
	public var onInit:Function;
	public var onFinish:Function;
	public var onProgress:Function;
	
	public function VideoPlayerComponent($mc:MovieClip, $fileToLoad:String, obj:Object) {
		
		fileToLoad = $fileToLoad;
		
		mcVideoPlayer = $mc;
		mcVideo = mcVideoPlayer.mcVideo;
		btStartLoading = mcVideoPlayer.btStartLoading;
		mcControls = mcVideoPlayer.mcControls;
			btRewind = mcControls.btRewind;
			mcPlayPause = mcControls.mcPlayPause;
				btPlay = mcPlayPause.btPlay;
				btPause = mcPlayPause.btPause;
			
			mcTrack = mcControls.mcTrack;
			mcSlider = mcTrack.mcSlider;
			mcProgress = mcTrack.mcProgress;
			mcTrackBg = mcTrack.mcTrackBg;
			mcMask = mcTrack.mcMask;
			
			mcVolume = mcControls.mcVolume;
				mcVolumeTrack = mcVolume.mcVolumeTrack;
				mcVolumeSlider = mcVolume.mcVolumeSlider;
				mcVolumeStatus = mcVolume.mcVolumeStatus;
		
		
		loaderManager = new FlvLoader();
		soundObj = new Sound(this.createEmptyMovieClip("soundHolder_mc", 2));
		
		/* Options */
		autoLoad = (obj.autoLoad != undefined) ? obj.autoLoad : true;
		autoPlay = (obj.autoPlay != undefined) ? obj.autoPlay : true;
		startAfter = (obj.startAfter != undefined) ? obj.startAfter : 100;
		//
		
		if(autoLoad) {
			initLoad();
			mcPlayPause.onRelease = mcPlayPause.onReleaseOutside = Delegate.create(this, playPause);
		} else {
			btStartLoading.onRelease = mcPlayPause.onRelease = mcPlayPause.onReleaseOutside = Delegate.create(this, initLoad);
		}
		
		// buttons
		btRewind.onRelease = btRewind.onReleaseOutside = Delegate.create(this, rewind);
		
		// Slider
		started = false;
		state = "paused";
		
		if(!SO.get("VideoPlayerComponentVolume", mcVideoPlayer._name)){
			SO.set("VideoPlayerComponentVolume", mcVideoPlayer._name, "100");
		} else {
			setVolume(Number(SO.get("VideoPlayerComponentVolume", mcVideoPlayer._name)));
		}
		
		setVolumeSliderPosition();
		disableAll();
	}
	
	public function clear():Void{
		stopInterval();
		started = false;
		state = "paused";
		disableAll();
		goTo(0);
		
		mcVideo._visible = false;
		mcSlider._x = 0;
		mcProgress._xscale = 0;
		
		pause();
		loaderManager.getStream().close();
	}
	
	// Loader 
	//{
	public function initLoad():Void{
		MovieclipUtil.remove(btStartLoading);
		mcPlayPause.onRelease = mcPlayPause.onReleaseOutside = Delegate.create(this, playPause);
		
		loaderManager.load(fileToLoad, mcVideo);
		loaderManager.onFinish = Delegate.create(this, afterLoadFinish);
		loaderManager.onProgress = Delegate.create(this, onLoadProgress);
		
		startInterval();
	}
	
	private function onLoadProgress(mc, percent):Void{
		mcProgress._xscale = percent;
		
		if(percent >= startAfter && state == "paused" && !started) {
			
			afterLoadFinish = null;
			mcVideo._visible = true;
			started = true;
			onProgress(mcVideoPlayer);
			enableAll();
			
			play();
		}
	}
	
	private function afterLoadFinish():Void{
		onLoadProgress(null, 100);
	}
	//}
	
	private function startInterval():Void{
		stopInterval();
		interval = setInterval(Delegate.create(this, checkProgress), 300);
	}
	
	private function stopInterval():Void{
		clearInterval(interval);
	}
	
	// Slider
	private function pressSlider():Void{
		
		stopInterval();
		//pause();
		mcSlider.startDrag(false,0,0,mcProgress._width,0);
		
		mcVolumeSlider.onMouseUp = 
		mcVolumeSlider.onMouseMove = null;
		
		mcSlider.onMouseUp = Delegate.create(this, releaseSlider);
		sliderPressed = true;
		
		
	}
	
	private function releaseSlider():Void{
		startInterval();
		
		mcSlider.stopDrag();
		sliderPressed = false;
		
		goTo(getSliderTime());
		if(state == "paused") pause();
		else play();
	}
	
	private function checkProgress():Void{
		var calc:Number = mcMask._x + ((mcMask._width * loaderManager.getTime()) / loaderManager.getDuration());
		if(!sliderPressed) mcSlider._x = calc;
		
		if(checkEnd() && state != "paused" && loaderManager.getTime() > 1) {
			stopInterval();
			pause();
		}
	}
	
	public function checkEnd():Boolean{
		var pos = (loaderManager.getTime());
		var tot = Math.round(loaderManager.getDuration());
		if(!pos || !tot) return false;
			
		if(pos >= tot){
			goTo(loaderManager.getDuration());
			return true;
		}
		return false;
	}
	
	// Track
	private function moveSlider():Void{
		stopInterval();
		
		mcSlider._x = (mcMask._xmouse < (mcProgress._width) ? mcMask._xmouse : mcProgress._width);
		sliderPressed = true;
		goTo(getSliderTime());
		sliderPressed = false;
		
		startInterval();
	}
	
	// Enable and Disable
	public function enableTrack():Void{
		mcSlider.onPress = Delegate.create(this, pressSlider);
		mcTrackBg.onPress = Delegate.create(this, moveSlider);
		
		mcVolumeSlider.onPress = Delegate.create(this, pressVolumeSlider);
		mcVolumeStatus.onRelease = Delegate.create(this, muteUnMute);
		
		mcVolumeSlider.useHandCursor = mcTrackBg.useHandCursor = false;
	}
	
	public function disableTrack():Void{
		mcTrack.enabled = 
		mcSlider.enabled = false;
	}
	
	// Basic controls
	//{
	public function play():Void{
		//trace("play called");
		if(checkEnd()) {
			rewind();
		} 
		loaderManager.play();
		state = "playing";
		mcPlayPause.gotoAndStop("_pause");
	}
	
	public function pause():Void{
		//trace("pause called");
		loaderManager.pause();
		state = "paused";
		mcPlayPause.gotoAndStop("_play");
	}
	
	public function playPause():Void{
		stopInterval();
		if(getState() == "paused"){
			play();
		} else {
			pause();
		}
		startInterval();
	}
	
	public function goTo(time:Number):Void{
		loaderManager.getStream().seek(time);
	}
	//}
	
	public function rewind():Void{
		goTo(.1);
	}
	
	// Sound
	//{
	public function mute():Void{
		setVolume(0);
		mcVolumeSlider._x = 0;
	}
	
	public function unMute():Void{
		setVolume(Number(SO.get("VideoPlayerComponentVolume", mcVideoPlayer._name)));
		setVolumeSliderPosition();
	}
	
	public function muteUnMute():Void{
		if(getVolume() > 0) mute();
		else unMute();
	}
	
	private function setVolumeSliderPosition():Void{
		var val:Number = Number(SO.get("VideoPlayerComponentVolume", mcVideoPlayer._name));
		mcVolumeSlider._x = (mcVolumeTrack._width * val) / 100;
	}
	
	private function pressVolumeSlider():Void{
		mcVolumeSlider.startDrag(false, mcVolumeTrack._x,0,mcVolumeTrack._x + mcVolumeTrack._width, 0);
		
		mcSlider.onMouseUp = null;
		
		mcVolumeSlider.onMouseUp = Delegate.create(this, releaseVolumeSlider);
		mcVolumeSlider.onMouseMove = Delegate.create(this, moveVolumeSlider);
	}
	
	private function moveVolumeSlider():Void{
		var calc:Number = Math.ceil((mcVolumeSlider._x *100) / (mcVolumeTrack._x + mcVolumeTrack._width));
		setVolume(calc);
	}
	
	private function releaseVolumeSlider():Void{
		mcVolumeSlider.stopDrag();
		mcVolumeSlider.onMouseUp = 
		mcVolumeSlider.onMouseMove = null;
		
		SO.set("VideoPlayerComponentVolume", mcVideoPlayer._name, getVolume().toString());
	}
	
	//}
	
	// Getters
	//{
	
	private function getSliderTime():Number{
		return Math.round((loaderManager.getDuration() * mcSlider._x) / mcMask._width);
	}
	
	public function getState():String{
		return state;
	}
	
	public function getTotalTime():Number{
		try{
			return loaderManager.getDuration();
		}catch(e){
			trace("Error getting total time: "+e);
			return null;
		}
	}
	
	public function getActualTime():Number{
		try{
			return loaderManager.getTime();
		}catch(e){
			trace("Error getting actual time: "+e);
			return null;
		}
	}
	
	public function setVolume(volume:Number):Void{
		soundObj.setVolume(volume);
		if(volume <= 5){
			mcVolumeStatus.gotoAndStop(1);
		} else if(volume > 5 && volume <= 60){
			mcVolumeStatus.gotoAndStop(2);
		} else if(volume > 60){
			mcVolumeStatus.gotoAndStop(3);
		}
	}
	
	public function getVolume():Number{
		return soundObj.getVolume();
	}
	
	public function enableAll():Void{
		
		
		btRewind._alpha = 
		mcPlayPause._alpha = 
		mcSlider._alpha = 
		mcVolume._alpha = 100;
		
		btRewind.enabled = 
		mcPlayPause.enabled = 
		mcSlider.enabled = 
		mcTrack.enabled = 
		mcVolumeSlider.enabled = 
		mcVolumeStatus.enabled = true;
		
		enableTrack();
	}
	
	public function disableAll():Void{
		
		
		btRewind._alpha = 
		mcPlayPause._alpha = 
		mcSlider._alpha = 
		mcVolume._alpha = 50;
		
		btRewind.enabled = 
		mcPlayPause.enabled = 
		mcSlider.enabled = 
		mcTrack.enabled = 
		mcVolumeSlider.enabled = 
		mcVolumeStatus.enabled = false;
		
		disableTrack();
	}
	//}
	
}