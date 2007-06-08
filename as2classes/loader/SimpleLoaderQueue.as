/**
* Simple Loader Queue Class
* @author Nicholas Almeida
* @version 1.0
* @history 08/06/2007: Created
* 
* @usage
	
	import as2classes.loader.SimpleLoaderQueue;
	
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
		
*/

import as2classes.loader.SimpleLoader;
import as2classes.util.Delegate;

class as2classes.loader.SimpleLoaderQueue {
	
	public var arrToLoad:Array;
	
	private var currentLoad:SimpleLoader;
	private var currentLoadIndex:Number;
	
	public var onItemFinish:Function;
	public var onItemProgress:Function;
	public var onQueueFinish:Function;
	
	
	function SimpleLoaderQueue(){
		arrToLoad = [];
		currentLoadIndex = 0;
	}
	
	public function addMovie(movie:String, target:MovieClip, priority:Number):Void{
		arrToLoad.push({
						target: target,
						movie: movie,
						priority: priority || 5 // Priority is just a comparison number; two loadings can have the same priority (the first one loads first).
					});
	}
	
	public function start():Void{
		arrToLoad.sortOn("priority");
		trace("-------------------------------------------------------\n *** Loader Queue STARTED");
		doLoad();
	}
	
	
	
	
	
	
	
	private function doLoad():Void{
		currentLoad = new SimpleLoader();
		currentLoad.load(arrToLoad[currentLoadIndex].movie, arrToLoad[currentLoadIndex].target); 
		currentLoad.onProgress = Delegate.create(this, doOnPorgress);
		currentLoad.onFinish = Delegate.create(this, loadNext);
	}
	
	private function doOnItemFinish(target:MovieClip):Void{
		onItemFinish(arrToLoad[currentLoadIndex].target);
	}
	
	private function doOnPorgress(target:MovieClip, percent:Number):Void{
		onItemProgress(arrToLoad[currentLoadIndex].target, percent);
	}
	
	private function loadNext():Void{
		
		doOnItemFinish(arrToLoad[currentLoadIndex].target);
		
		currentLoadIndex++;
		if(arrToLoad[currentLoadIndex]){
			doLoad();
		} else {
			trace(" >>> All Loader Queue COMPLETE\n-------------------------------------------------------");
			onQueueFinish();
			delete arrToLoad;
		}
	}
	
}
