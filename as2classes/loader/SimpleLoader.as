/*
	AS2classes Framework for ActionScript 2.0
	Copyright (C) 2007  Nicholas Almeida
	http://nicholasalmeida.com
	
	This library is free software; you can redistribute it and/or
	modify it under the terms of the GNU Lesser General Public
	License as published by the Free Software Foundation; either
	version 2.1 of the License, or (at your option) any later version.
	http://www.gnu.org/licenses/lgpl.html
	
	This library is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
	Lesser General Public License for more details.
*/

import as2classes.util.Delegate;
import as2classes.util.TimeUtil;

/**
	SimpleLoader. An easy way to load an external SWF file and monitor the loading process.
	
	@author Nicholas Almeida
	@version 28/6/2007
	@since Flash Player 8
	@example
		<code>
			loaderManager:SimpleLoader = new SimpleLoader();
			loaderManager.onInit = function(target){
				trace("onInit called. Target: " + target);
			}
			loaderManager.onProgress = function(target, percent){
				trace("onProgress called. Target: " + target + " percent loaded: " + percent + "%");
			}
			loaderManager.onError = function(target, errorCode, httpStatus){
				trace("onError called. Target: " + target + " errorCode: " + errorCode + " httpStatus: " + httpStatus);
			}
			loaderManager.onFinish = function(target){
				trace("onFinish called. Target: " + target);
			}
			loaderManager.load("http://localhost:81/upload/img/deds.jpg", mcTarget)
		</code>
*/

class as2classes.loader.SimpleLoader{
	
	public var fileToLoad:String;
	public var target:MovieClip;
	public var timeout:Number;
	public var loaded:Boolean;
	
	private var loadListener:Object;
	private var mcLoader:MovieClipLoader;
	private var timeoutListener:Number;
	private var tmpTimeoutListener;
	private var tmpInt;
	private var avoidTrace:Boolean;
	
	public var onProgress:Function;
	public var onFinish:Function;
	public var onInit:Function;
	public var onError:Function;
	public var onTimeout:Function;
	
	// Functions
	function SimpleLoader($avoidTrace:Boolean){
		avoidTrace = $avoidTrace;
		timeout = 10 * 1000; // 10s
		loadListener = {};
		mcLoader = new MovieClipLoader();
		
		if(arguments.length == 2) load(arguments[0], arguments[1]);
	}
	
	/**
		Starts the load process.
		
		@param $fileToLoad:String - SWF path to be loaded.
		@param $target:MovieClip - SWF MovieClip holder.
		@return Return none.
	*/
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
	
	/**
		Cancel the loading process and unload de Target MovieClip.
		
		@return Return none.
	*/
	public function cancel():Void{
		if(!avoidTrace) trace(" !! Loader CANCELED: " + fileToLoad + " -- movie:" + target + " CLEARED");
		doCancel();
	}
	
	/**
		Sets a timeout for the loading process. Default is 10000 (10s).
		
		@param Timer:Number - Time in miliseconds.
		@return Return none.
	*/
	public function setTimeout(timer:Number):Void{
		timeout = timer;
	}
	
	/**
		Clear the timeout interval.
		
		@return Return none.
	*/
	public function clearTimeout():Void{
		clearInterval(tmpInt);
		clearInterval(timeoutListener);
	}	
	
	/***********************************************
	* Handlers
	***********************************************/
	
	private function doCancel():Void{
		tmpInt = setInterval(Delegate.create(this, clearTimeout), 150);
		mcLoader.unloadClip(target);
		target.unloadMovie();
	}	
	
	private function doInit():Void{
		if(!avoidTrace) {
			trace("-------------------------------------------------------");
			trace(" ** New loader STARTED: " + target);
		}
		loaded= false;
		onInit(target);
	}
	
	private function doProgress(target, bytesLoaded:Number, bytesTotal:Number):Void{
		
		clearTimeout();
		
		var p:Number = Math.round((bytesLoaded/ bytesTotal) *100);
		
		if(isNaN(p)) { // Recursive loader when percet is undefined. Good for simultaneous connections.
			trace(" !! Loader ERROR: Restarting loading process: " + fileToLoad + " -- Target: " + target + " -- percent: " + p);
			load(fileToLoad, target, avoidTrace);
		}
		
		if(!avoidTrace) trace(" %% Loader PROGRESS: " + target + " -- Percent loaded: " + p);
		onProgress(target,p);
	}
	
	private function doFinish():Void{
		
		clearTimeout();
		if(!avoidTrace) {
			trace(" >> Loader COMPLETE: " + target);
			trace("-------------------------------------------------------");
		}
		loaded = true;
		onFinish(target);
	}
	
	private function doError(target_mc:MovieClip, errorCode:String, httpStatus:Number){
		if(!avoidTrace) {
			trace(" !! Loader ERROR: " + fileToLoad + " -- Target: " + target + " -- Error: " + errorCode + " -- HttpStatus: " + httpStatus);
			trace("-------------------------------------------------------");
		}
		
		clearInterval(tmpInt);
		clearInterval(timeoutListener);
		loaded = false;
		cancel();
		onError(target_mc, errorCode, httpStatus);
	}

	private function doTimeout(){
		trace(" !! Loader TIMEOUT: " + target);
		trace("-------------------------------------------------------");
		loaded = false;
		clearTimeout();
		onTimeout(target);
	}
}
























