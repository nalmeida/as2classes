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

/**
	FlvLoader. Provides an easy way to load FLVs.
	
	@author Nicholas Almeida
	@version 27/06/07
	@since Flash Player 8
	@example
		<code>
			var flvLoader = new FlvLoader();
		
			flvLoader.onInit = function(target){
				//trace("começou " + target);
			}
			flvLoader.onProgress = function(target, percent){
				//trace("target = " + target + " -- " + percent);
			}
			flvLoader.onFinish = function(target){
				//trace("fim " + target);
			}
			flvLoader.onError = function(target, code){
				//trace("Erro " + target + " code " + code);
			}
			
			flvLoader.load("http://p.download.uol.com.br/espnbrasil/videos/selebra.flv", mcVideoHolder);
		</code>
*/

class as2classes.loader.FlvLoader {
	
	public var fileToLoad:String;
	public var target:Video;
	
	private var tmpInt:Number;
	
	public var onProgress:Function;
	public var onFinish:Function;
	public var onInit:Function;
	public var onError:Function;
	
	private var total:Number;
	private var percentLoaded:Number;
	private var nc:NetConnection;
	private var loader:NetStream;
	
	private var attempt:Number;
	public var isPaused:Boolean;
	private var duration:Number;
	
	function FlvLoader(){
		nc = new NetConnection();
		nc.connect(null);
		loader = new NetStream(nc);
		
		attempt = 0;
		isPaused = true;
	}
	
	/**
		Starts the FLV loading process.
		
		@param $fileToLoad:String - Path to file to be loaded.
		@param $target:Video - Target where the FLV will be loaded.
		@param [$disableCache:Video] - Optional parameter to avoid video cache.
		@return Return none.
	*/
	public function load($fileToLoad:String, $target:Video, $disableCache:Boolean){
		
		fileToLoad = $fileToLoad;
		target = $target;
		
		if(fileToLoad.slice(-3).toLowerCase() != "flv") {
			trace("ERROR 1: File to load MUST be a FLV file");
			onError(target, 1);
			return false;
		}
		
		if($disableCache){
			var d:Date = new Date();
			fileToLoad += "?cacheBuster=" + Math.random(d.getMilliseconds());
		}
		
		target.attachVideo(loader);
		loader.onMetaData = Delegate.create(this, onMetaData);
		loader.play(fileToLoad);
		loader.pause(); // Stops autoplay
		
		trace("-------------------------------------------------------");
		trace(" ** New FLV loader STARTED: " + target + " -- file to load: " + fileToLoad);
		onInit(target);
		
		tmpInt = setInterval(Delegate.create(this, watchProgress), 50);
		
	}
	/**
		Cancel the FLV loading.
		
		@return Return none.
	*/
	public function cancel():Void{
		if(loader){
			trace(" !! FLV Loader CANCELED: " + fileToLoad);
			trace("-------------------------------------------------------");
			clearInterval(tmpInt);
			loader.close();
		}
	}
	
	/**
		Play the Video.
		
		@return Return none.
	*/
	public function play():Void{
		isPaused = false;
		loader.pause(false);
	}
	
	/**
		Pause the Video.
		
		@return Return none.
	*/
	public function pause():Void{
		isPaused = true;
		loader.pause(true);
	}
	
	/**
		If the Video is playing, pause it else play.
		
		@return Return none.
	*/
	public function playPause():Void{
		if(isPaused) play();
		else pause();
	}
	
	/**
		Get the NetStream.
		
		@return Returns the NetStream.
	*/
	public function getStream():NetStream{
		return loader;
	}
	
	/**
		Get the Video target.
		
		@return Returns the Video target.
	*/
	public function getTarget():Video{
		return target;
	}
	
	/**
		Get the Video time in seconds.
		
		@return Returns the Video time in seconds.
	*/
	public function getTime():Number{
		return loader.time;
	}
	
	/**
		Get the total Video duration.
		
		@return Returns the Video duration in seconds.
	*/
	public function getDuration():Number{
		return duration;
	}
	
	private function onMetaData(infoObject:Object){
		duration = infoObject.duration;
	}
	
	private function watchProgress():Void{
		total  = loader.bytesTotal;
		percentLoaded = Math.round((loader.bytesLoaded/total) * 100);
		attempt++;
		if(percentLoaded < 100){
			trace(" %% FLV Loader PROGRESS: " + target + " -- Percent loaded: " + percentLoaded);
			onProgress(target, percentLoaded);
		} 
		else if(percentLoaded >=100){
			clearInterval(tmpInt);
			onFinish(target);
			trace(" >> FLV Loader COMPLETE: " + target);
			trace("-------------------------------------------------------");
		}
		
		if(attempt > 250 && total == 0){
			cancel();
			trace("ERROR 404: File \"" + fileToLoad + "\" not found.");
			onError(target, 404);
		}
	}
}
