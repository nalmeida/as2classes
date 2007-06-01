// orginal: http://labs.zeh.com.br/blog/?page_id=97

/**
 * Loading Queue
 * Controls loading queues
 *
 * @author		Zeh Fernando
 * @version		1.2.1
 *
 * 19 may 07 (1.2.1) - fixed bug - removing a movieclip while its content was being loaded caused that queue slot to freeze; thanks for Ricardo "Mr. Doob" Cabello for spotting the bug and fixing it
 * 17 mar 07 (1.2.0) - setSlots() method for queue instances for 
 * 15 mar 07 (1.1.0) - Added priority
 * 10 oct 06 (1.0.0) - First version
 */

/*
Usage:

import zeh.loading.LoadingQueue

var qm:LoadingQueue = new LoadingQueue(this); // parametro opcional
qm.addMovie(this.coisa, "a.jpg");
qm.start();

Additionally, with priority:
qm.addMovie(this.coisaa, "a.jpg", 5);
qm.addMovie(this.coisab, "b.jpg", 0);

Then coisab will load before coisaa, because it has a lower priority number.
Priority is just a comparison number; two loadings can have the same priority (the first one loads first).
Default priority is 5.

*/
class as2classes.bitmap.LoadingQueue {

	private var _scope:MovieClip;						// Where this LoadingQueue instance was created
	private var _queue:Array;							// Array of movies to load {mc:mc, url:String, isLoading:Boolean, priority:Number} - priority: default is 5. lower is top priority, higher is less priority
	private var _isLoading:Boolean;						// Whether or not it's already loading
	private var _maxSlots:Number;						// Number of maximum slots for simultaneous downloads (default 1)
	private var _usedSlots:Number;						// How many download slots are already taken

	// ================================================================================================================
	// INSTANCE functions ---------------------------------------------------------------------------------------------

	// Constructor
	public function LoadingQueue (p_scope:MovieClip, p_slots:Number) {
		if (!p_scope) p_scope = _root;
		_scope = p_scope;
		_queue = new Array();
		_isLoading = false;
		_usedSlots = 0;
		setSlots(p_slots);
	}

	public function setSlots(p_slots:Number): Void {
		// Sets the number of maximum slots for loading
		if (isNaN(p_slots) || p_slots < 1) p_slots = 1;
		_maxSlots = p_slots;
	}

	// Adds a new MovieClip to the loading queue
	public function addMovie (p_mc:MovieClip, p_url:String, p_priority:Number) {
		if (isNaN(p_priority)) p_priority = 5;
		_queue.push({mc:p_mc, url:p_url, isLoading:false, priority:p_priority});
	}

	// Start the queue
	public function start () {
		if (!_isLoading) {
//			trace ("LoadingQueue :: starting");
			_isLoading = true;
			_scope.createEmptyMovieClip("LoadingQueueController", _scope.getNextHighestDepth());
			_scope.LoadingQueueController.loadingInstance = this;
			_scope.LoadingQueueController.onEnterFrame = function() {
				this.loadingInstance.update();
			};
		}
	}

	// Checks if loading is fine or if anything's missing
	public function update() {
//		trace ("LoadingQueue :: onenterframe...");
		if (_isLoading) {
			if (_queue.length > 0) {
				// Continues...
				if (_usedSlots < _maxSlots) {
					// Can load another one
					// Find the next one
					var $nextSlot:Number;
					var $nextSlotPriority:Number;
					for (var i:Number = 0; i < _queue.length; i++) {
						if (!_queue[i].isLoading && ($nextSlotPriority == undefined || _queue[i].priority < $nextSlotPriority)) {
//							trace ("LoadingQueue :: next is "+i);
							$nextSlot = i;
							$nextSlotPriority = _queue[i].priority;
//							break;
						}
					}
					if (!isNaN($nextSlot)) {
						// There's at least one left, so load it
//						trace (" ...LoadingQueue :: loading "+_queue[$nextSlot].url + " at "+_queue[$nextSlot].mc);
						_queue[$nextSlot].mc.loadMovie(_queue[$nextSlot].url);
						_queue[$nextSlot].isLoading = true;
						_usedSlots++;
					}
				}

				// Checks to see if any of the slots in use has already been loaded

				var $tm:MovieClip;
				var $l:Number, $t:Number, $w:Number;

				for (var i:Number = 0; i < _queue.length; i++) {
					if (_queue[i].isLoading) {
						$tm = _queue[i].mc; // Movie being currently loaded
						$l = $tm.getBytesLoaded();
						$t = $tm.getBytesTotal();
						$w = $tm._width;
						if (($l >= $t && $t > 100 && $w > 0) || $tm == undefined) {
							// This one is already loaded, or has been removed during loading, so load the next one
//							trace (" ...LoadingQueue :: "+_queue[i].mc+" is done, next");
							_queue.splice(i, 1);
							i--;
							_usedSlots--;
						}
					}
				}
			} else {
				// Everything done
//				trace ("LoadingQueue :: finished");
				this.stop(); // só stop() dá erro....!
			}
		}
	}

	// Stops loading
	public function stop() {
		if (_isLoading) {
//			trace ("LoadingQueue :: stopped");
			_isLoading = false;
			_scope.LoadingQueueController.removeMovieClip();
		}
	}
}