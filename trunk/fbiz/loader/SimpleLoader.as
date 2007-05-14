import com.fbiz.util.Delegate;

class com.fbiz.loader.SimpleLoader{
	
	public var fileToLoad:String;
	public var target:MovieClip;
	public var timeout:Number;
	
	private var loadListener:Object;
	private var mcLoader:MovieClipLoader;
	private var timeoutListener:Number;
	private var tmpTimeoutListener;
	private var tmpInt;
	
	public var onProgress:Function;
	public var onFinish:Function;
	public var onInit:Function;
	public var onError:Function;
	public var onTimeout:Function;
	
	// Functions
	function SimpleLoader(){
		timeout = 10000; // 10s
		loadListener = {};
		mcLoader = new MovieClipLoader();
		
		if(arguments.length == 2) load(arguments[0], arguments[1]);
	}
	
	public function load($fileToLoad:String, $target:MovieClip):Void{

		doCancel();		

		tmpTimeoutListener = Delegate.create(this, doTimeout);
		timeoutListener = setInterval(tmpTimeoutListener, timeout);
		
		fileToLoad = $fileToLoad;
		target = $target;
		
		loadListener.onLoadStart = Delegate.create(this, doInit);
		loadListener.onLoadInit = Delegate.create(this, doFinish);
		loadListener.onLoadProgress  = Delegate.create(this, doProgress);
		loadListener.onLoadError = Delegate.create(this, doError);
		
		mcLoader.addListener(loadListener);
		mcLoader.loadClip(fileToLoad, target);		
	}
	
	public function cancel(){
		trace(" !! Loader CANCELED: " + fileToLoad + " -- movie:" + target + " CLEARED");
		doCancel();
	}
	
	public function changeLoad(){
		doCancel();
		load();
	}
	
	public function setTimeout(timer:Number):Void{
		timeout = timer;
	}
	
	
	public function clearTimeout(){
		clearInterval(tmpInt);
		clearInterval(timeoutListener);
		Delegate.destroy(tmpTimeoutListener);
	}	
	
	/***********************************************
	* Handlers
	***********************************************/
	
	private function doCancel():Void{
		tmpInt = setInterval(clearTimeout, 150);
		mcLoader.unloadClip(target);
		target.unloadMovie();
	}	
	
	private function doInit():Void{
		trace("-------------------------------------------------------");
		trace(" ** New loader STARTED: " + target);
		onInit(target);
	}
	
	private function doProgress(target, bytesLoaded:Number, bytesTotal:Number):Void{
		
		clearInterval();
		
		var p:Number = Math.round((bytesLoaded/ bytesTotal) *100);
		trace(" %% Loader PROGRESS: " + target + " -- Percent loaded: " + p);
		onProgress(target,p);
	}
	
	private function doFinish():Void{
		
		clearTimeout();
		
		trace(" >> Loader COMPLETE: " + target);
		trace("-------------------------------------------------------");
		onFinish(target);
	}
	
	private function doError(target_mc:MovieClip, errorCode:String, httpStatus:Number){
		trace(" !! Loader ERROR: " + fileToLoad + " -- Target: " + target + " -- Error: " + errorCode + " -- HttpStatus: " + httpStatus);
		trace("-------------------------------------------------------");
		
		clearInterval(tmpInt);
		clearInterval(timeoutListener);
		
		cancel();
		onError(target_mc, errorCode, httpStatus);
	}

	private function doTimeout(){
		trace(" !! Loader TIMEOUT: " + target);
		trace("-------------------------------------------------------");
		clearTimeout();
		onTimeout(target);
	}
}
























