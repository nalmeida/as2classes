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

import as2classes.loader.SimpleLoader;
import as2classes.util.Delegate;
import as2classes.util.ArrayUtil;

/**
	SimpleLoaderQueue. Creates a queue of files to be loaded.
	
	@author Nicholas Almeida
	@version 08/06/2007
	@since Flash Player 8
	@example
		<code>
			var loaderQueue:SimpleLoaderQueue = new SimpleLoaderQueue();
	
			loaderQueue.addMovie("movie_1.swf", movie1);
			loaderQueue.addMovie("movie_2.swf", movie2);

			loaderQueue.onItemProgress = function(target:MovieClip, percent:Number){
				trace(target + " percent loaded = " + percent + "%");
			}

			loaderQueue.onItemFinish = function(target:MovieClip){
				trace(target + " loaed.");
			}

			loaderQueue.onQueueFinish = function(){
				trace("the end.");
			}

			loaderQueue.start();
		</code>
*/

class as2classes.loader.SimpleLoaderQueue {
	
	public var arrToLoad:Array;
	public var avoidTrace:Boolean;
	
	private var currentLoad:SimpleLoader;
	//private var currentLoadIndex:Number;
	
	public var onItemFinish:Function;
	public var onItemProgress:Function;
	public var onQueueFinish:Function;
	
	
	function SimpleLoaderQueue($avoidTrace:Boolean){
		avoidTrace = $avoidTrace;
		arrToLoad = [];
		//currentLoadIndex = 0;
	}
	
	/**
		Adds a new SWF to be loaded.
		
		@param movie:String - SWF path to be loaded.
		@param target:String - SWF MovieClip holder.
		@param priority:Number - Lower number loads first. 1 is the highest priority. Two loadings can have the same priority (the first one loads first). Default is 5.
		@return Return none.
	*/
	public function addMovie(movie:String, target:MovieClip, priority:Number):Void{
		arrToLoad.push({
			target: target,
			movie: movie,
			priority: priority || 5 // Priority is just a comparison number; two loadings can have the same priority (the first one loads first).
		});
	}
	
	/**
		Starts the loading queue process
		
		@return Return none.
	*/
	public function start():Void{
		arrToLoad.sortOn("priority");
		if(!avoidTrace) trace("-------------------------------------------------------\n *** Loader Queue STARTED");
		doLoad();
	}
	
	private function doLoad():Void{
		currentLoad = new SimpleLoader(avoidTrace);
		currentLoad.load(arrToLoad[0].movie, arrToLoad[0].target); 
		currentLoad.onProgress = Delegate.create(this, doOnPorgress);
		currentLoad.onFinish = Delegate.create(this, loadNext);
	}
	
	private function doOnItemFinish(target:MovieClip):Void{
		onItemFinish(arrToLoad[0].target);
		
		arrToLoad = ArrayUtil.removeFirst(arrToLoad); // Removes the first element;
	}
	
	private function doOnPorgress(target:MovieClip, percent:Number):Void{
		onItemProgress(arrToLoad[0].target, percent);
	}
	
	private function loadNext():Void{
		
		doOnItemFinish(arrToLoad[0].target);
		
		//currentLoadIndex++;
		if(arrToLoad[0]){
			doLoad();
		} else {
			if(!avoidTrace) trace(" >>> All Loader Queue COMPLETE\n-------------------------------------------------------");
			onQueueFinish();
		}
	}
	
}
