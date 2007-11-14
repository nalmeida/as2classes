
import as2classes.util.Delegate;

class as2classes.util.MovieclipUtil{
	/**
		removeChilds - removes the elements inside a MovieClip Object.
		@param $mc:MovieClip - Movieclip that contains objects to be removed.
		@return none
	*/
	public static function removeChilds($mc:MovieClip):Void{
		for(var i:String in $mc){
			$mc[i].swapDepths($mc.getNextHighestDepth());
			$mc[i].removeMovieClip();
		}
	}

	/**
		remove - removes the MovieClip Object.
		@param $mc:MovieClip - Movieclip to be removed.
		@return none
	*/
	public static function remove($mc:MovieClip):Void{
		$mc.swapDepths($mc.getNextHighestDepth());
		$mc.removeMovieClip();
	}
	
	/**
		playReverse - Play a Movieclip reversily.
		@param mc:MovieClip - Movieclip to be reversily played.
		@param frame:Number - Frame to stop. Optional param. Default 1.
		@return none
	*/
	public static function playReverse(mc:MovieClip, frame:Number):Void{
		mc.stop();
		mc.onEnterFrame = Delegate.create(mc, _reverse, {mc:mc, frame:frame || 1});
	}
	
	/**
		cancelPlayReverse - Cancel playReverse method. onEnterFrame = null.
		@param mc:MovieClip - Movieclip.
		@return none
	*/
	public static function cancelPlayReverse(mc:MovieClip):Void{
		mc.onEnterFrame = null;
	}
	
	// Private functions
	private static function _reverse(obj):Void{
		var prev:Number = obj.mc._currentframe - 1;
		if(prev <= obj.frame) obj.mc.onEnterFrame = null;
		obj.mc.gotoAndStop(prev);
		updateAfterEvent();
	}

}
