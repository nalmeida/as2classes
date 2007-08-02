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
	MP3 loader is usefull class to load, stream and watch the loader progress.
	
	@author Nicholas Almeida
	@version 01/08/07
	@since Flash Player 8
	@example
		<code>
			var mySound:Sound = new Sound();
		
			var soundLoader:soundLoader = new MP3Loader();
				soundLoader.load("your_mp3_file.mp3", true, mySound);
				
				soundLoader.onProgress = function(sndObj:Sound, percentLoaded:Number, url:String){
					trace(percentLoaded + " % loaded.");
				}
				soundLoader.onFinish = function(sndObj:Sound){
					sndObj.start();
				}
				soundLoader.onError = function(url:String, errorNumber:Number){
					trace("Error: " + errorNumber + " -- File: " + url);
				}
		</code>
*/

class as2classes.loader.MP3Loader{
	
	private var mc:MovieClip;
	private var snd:Sound;
	private var url:String;
	private var interval:Number;
	private var attempt:Number;
	
	public var onProgress:Function;
	public var onFinish:Function;
	public var onInit:Function;
	public var onError:Function;

	function MP3Loader(){}
	
	/**
		Starts the MP3 loading process.
		
		@param $fileToLoad:String - Path to file to be loaded.
		@param isStreaming:Boolean - If you want to stream the MP3. Default false;
		@param [$sndObj:Sound] - Sound object will receive the MP3 file;
		@return Return none.
	*/
	public function load($fileToLoad:String, isStreaming:Boolean, sndObj:Sound):Void{
		
		url = $fileToLoad;
		mc = _root.createEmptyMovieClip("mc_" + url, _root.getNextHighestDepth());
		
		if(sndObj){
			snd = sndObj;
		} else {
			snd = new Sound();
		}
		snd.loadSound(url, isStreaming || false);
		snd.stop();
		
		trace("-------------------------------------------------------");
		trace(" ** New MP3 loader STARTED: " + url + " -- streaming: " + isStreaming);
		onInit(url);
		
		attempt = 0;
		interval = setInterval(Delegate.create(this, watchProgress), 50);
	}
	
	/**
		Return the used sound object.
		
		@return Return sound object.
	*/
	public function getSound():Sound{
		return snd;
	}
	
	/**
		Return the used movieclip. This movieclip is created at _root with the MP3 url filename.
		
		@return Return Movieclip.
	*/
	public function getMovieclip():MovieClip{
		return mc;
	}
	
	private function watchProgress():Void{
		var total:Number = snd.getBytesTotal();
		var loaded:Number = snd.getBytesLoaded();
		var percentLoaded:Number = Math.round((loaded/total) * 100);

		attempt++;
		
		if(percentLoaded < 100 || snd.duration == 0){
			if(snd.duration == 0) percentLoaded = 0;
			trace(" %% MP3 Loader PROGRESS: " + percentLoaded);
			onProgress(snd, percentLoaded, url);
		}  else if(percentLoaded >=100 && snd.duration > 0){
			clearInterval(interval);
			onFinish(snd);
			trace(" >> MP3 Loader COMPLETE: " + url);
			trace("-------------------------------------------------------");
		}
		if(attempt > 250 && snd.duration == 0){
			clearInterval(interval);
			trace("ERROR 404: File \"" + url + "\" not found.");
			trace("-------------------------------------------------------");
			onError(url, 404);
		}
	}
}
