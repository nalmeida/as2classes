// orginal: http://labs.zeh.com.br/blog/?page_id=97

/**
 * Image loader and cacher
 * Loads images with bitmap caching
 *
 * @author		Zeh Fernando
 * @version		1.3.3
 *
 * 17 may 07 (1.3.3) - new parameter for loadImage(), for bitmap smoothing (default true)
 * 17 apr 07 (1.3.2) - fix for not recognizing cached images after the cached ones were already loaded (thanks to Nick Shaw for pointing the error)
 * 21 mar 07 (1.3.1) - new loadings for an image that's already loading with a lower priority will mime but actually up the original priority
 * 20 mar 07 (1.3.0) - clearCache()
 * 17 mar 07 (1.2.0) - setSlots() method for the static class
 * 15 mar 07 (1.1.0) - Handles priority
 * 25 dec 06 (1.0.0) - First version
 */

/*
Usage:

import zeh.loading.ImageLoader;

var xx = new ImageLoader(whateverMC);
xx.onStart = function() {
};
xx.onUpdate = function(f:Number) {
};
xx.onComplete = function() {
};
xx.loadImage("whatever.jpg");

With priority:

loader1.loadImage("whatever1.jpg", 5);
loader2.loadImage("whatever2.jpg", 0);

Then yy will load before xx.
Priority is just a comparison number; two imageloaders can have the same priority (the first one loads first).
Default priority is 5.

*/

/*
TODO:
Same-priority management based on scope of the instance
*/

import as2classes.bitmap.LoadingQueue;
import flash.display.BitmapData;

class as2classes.bitmap.ImageLoader {

	private static var _queue:LoadingQueue;			// Queue which contains the images being loaded
	private static var _activeLoaders:Array;			// List of active loaders
	private static var _imageCache:Array;				// List of cached images {url:String, bmp:BitmapData}
	private static var _maxSlots:Number;				// Number of maximum global loading slots

	private var _mc:MovieClip;						// Where the image will be loaded
	private var _url:String;							// URL to be loaded
	private var _priority:Number;						// Priority order: ie, 0 is most urgent, 5/undefined is default, 10 is less urgent
	private var _container:MovieClip;					// Where this image is being loaded currently
	private var _isMime:Boolean;						// Whether this image loader is a mime of some other loader that's already taking place
	private var _smoothed:Boolean;					// Whether the image should be smoothed or not when attached

	public var onStart:Function;
	public var onUpdate:Function;
	public var onComplete:Function;


	// ================================================================================================================
	// INSTANCE functions ---------------------------------------------------------------------------------------------

	// Constructor
	public function ImageLoader(p_mc:MovieClip, p_smoothed:Boolean) {
		init();
		_mc = p_mc;
		_isMime = false;
		_smoothed = true;
	}

	// Adds a new MovieClip to the loading queue
	public function loadImage (p_url:String, p_priority:Number, p_smoothed:Boolean) {
		_url = p_url;
		_priority = p_priority;
		if (p_smoothed != undefined) _smoothed = p_smoothed;
		addActiveLoader(this);
	}

		

	// ================================================================================================================
	// STATIC functions -----------------------------------------------------------------------------------------------

	private static function init (): Void {
		// Initializes everything

		if (_root.__ImageLoader_Controller__ == undefined) {
			// Not started
			var $ic:MovieClip = _root.createEmptyMovieClip("__ImageLoader_Controller__", _root.getNextHighestDepth());
			$ic.onEnterFrame = function() {
				ImageLoader.tick();
			}

			if (_maxSlots == undefined) _maxSlots = 2;
			_queue = new LoadingQueue(_root, _maxSlots);
			_activeLoaders = new Array();
			if (_imageCache == undefined) _imageCache = new Array();
		}

	}

	private static function addActiveLoader (p_il:ImageLoader): Void {
		// Adds a loader to the list
		var $i:Number;

		// Checks if there's an equivalent on the cache already
		var $bmp:BitmapData = getBitmapFromURL(p_il._url);
		if ($bmp != null) {
			// Already found, so simply adds this image
			p_il.onStart.apply(p_il._mc);
			p_il.onUpdate.apply(p_il._mc, [1]);
			attachImage(p_il._mc, $bmp, p_il._smoothed);
			p_il.onComplete.apply(p_il._mc);
			deactivateIfNeeded();
			return;
		}

		// TODO: allow an overwrite of the url if a second loadImage is done?
		
		// Only if it doesn't exist
		for ($i = 0; $i < _activeLoaders.length; $i++) {
			if (_activeLoaders[$i] == p_il) return;
		}

		// Checks whether there's a loading already taking place for this image
		for ($i = 0; $i < _activeLoaders.length; $i++) {
			if (_activeLoaders[$i]._url == p_il._url) {
				// It's already loading somewhere else
				p_il.onStart.apply(p_il._mc);
				p_il._container = _activeLoaders[$i]._container;
				p_il._isMime = true;
				_activeLoaders.push(p_il);
				// Higher priority if needed
				if (_activeLoaders[$i]._priority > p_il._priority) {
					_activeLoaders[$i]._priority = p_il._priority;
				}
				return;
			}
		}

		// It's a really new loading, so adds it
		p_il.onStart.apply(p_il._mc);
		_activeLoaders.push(p_il);
		p_il._container = p_il._mc.createEmptyMovieClip("__img__", 10);
		p_il._container._visible = false;
		p_il._container._alpha = 0;

//		trace ("ImageLoader :: loading ["+p_il._url+"] in ["+p_il._mc.__img__+"]");
		_queue.addMovie(p_il._container, p_il._url, p_il._priority);
		_queue.start();
	}

	public static function tick(): Void {
		// Executes a check on everything
		var $i:Number;
		var $l:Number, $t:Number, $f:Number;
		var $hasFinishedAny:Boolean = false;
		for ($i = 0; $i < _activeLoaders.length; $i++) {
			if (_activeLoaders[$i]._isMime) {
				// It's a mime
				if (_activeLoaders[$i]._container._alpha != undefined) { // ugh
					// Still loading
					$l = _activeLoaders[$i]._container.getBytesLoaded();
					$t = _activeLoaders[$i]._container.getBytesTotal();
					$f = $t > 20 ? $l / $t : 0;
					_activeLoaders[$i].onUpdate.apply(_activeLoaders[$i]._mc, [$f]);
				} else {
					// Finished loading
					_activeLoaders[$i].onUpdate.apply(_activeLoaders[$i]._mc, [1]);
					var $bmp:BitmapData = getBitmapFromURL(_activeLoaders[$i]._url);
					attachImage(_activeLoaders[$i]._mc, $bmp, _activeLoaders[$i]._smoothed);
					_activeLoaders[$i]._container = undefined;
					_activeLoaders[$i].onComplete.apply(_activeLoaders[$i]._mc);
					_activeLoaders.splice($i, 1);
					$i--;
					$hasFinishedAny = true;
				}
			} else {
				// It's a normal loader
				$l = _activeLoaders[$i]._container.getBytesLoaded();
				$t = _activeLoaders[$i]._container.getBytesTotal();
				$f = $t > 20 ? $l / $t : 0;
				_activeLoaders[$i].onUpdate.apply(_activeLoaders[$i]._mc, [$f]);
				if ($f >= 1 && _activeLoaders[$i]._container._width > 0) {
					// It's loaded
					var $bmp:BitmapData = new BitmapData(_activeLoaders[$i]._container._width, _activeLoaders[$i]._container._height, true, 0x00ffffff);
					$bmp.draw(_activeLoaders[$i]._container);
					_activeLoaders[$i]._container.removeMovieClip();
					_imageCache.push({url:_activeLoaders[$i]._url, bmp:$bmp});
					attachImage(_activeLoaders[$i]._mc, $bmp, _activeLoaders[$i]._smoothed);
					_activeLoaders[$i].onComplete.apply(_activeLoaders[$i]._mc);
					_activeLoaders.splice($i, 1);
					$i--;
					$hasFinishedAny = true;
				}
			}
		}

		if ($hasFinishedAny) deactivateIfNeeded();
	}

	private static function deactivateIfNeeded(): Void {
		// Deactivates this if needed
		if (_activeLoaders.length == 0) {
			_activeLoaders = undefined;
			_queue = undefined;
			_root.__ImageLoader_Controller__.removeMovieClip();
		}
	}

	private static function attachImage(p_mc:MovieClip, p_bmp:BitmapData, p_smoothed:Boolean): Void {
		// Attaches the image to the movieclip
//		trace ("ImageLoader :: attaching "+p_bmp+" in "+p_mc);
		p_mc.attachBitmap(p_bmp, p_mc.getNextHighestDepth(), undefined, p_smoothed);
	}

	public static function setSlots(p_slots:Number): Void {
		// Sets the number of maximum slots for loading
		if (isNaN(p_slots) || p_slots < 1) p_slots = 1;
		_maxSlots = p_slots;
		_queue.setSlots(p_slots);
	}

	public static function getBitmapFromURL(p_url:String): BitmapData {
		// Basead on an url, returns a BitmapData instance
		for (var $i = 0; $i < _imageCache.length; $i++) {
			if (_imageCache[$i].url == p_url) {
				return _imageCache[$i].bmp;
			}
		}
		return null;
	}

	public static function clearCache(dispose:Boolean): Void {
		// Clears the cache of images
		// Dispose of images if needed
		if (dispose) {
			for (var i:Number = 0; i < _imageCache.length; i++) {
				_imageCache[i].bmp.dispose();
				_imageCache[i] = undefined;
			}
		}
		_imageCache = new Array();
	}

	/*
	public function get url():String		{ return _url; }
	*/
	
}