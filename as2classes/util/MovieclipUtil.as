
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
	
	//
	public static function playReverse(mc:MovieClip, frame:Number):Void{
		mc.stop();
		mc.onEnterFrame = Delegate.create(mc, function(frame){
			var prev:Number = mc._currentframe - 1;
			if(prev <= frame) mc.onEnterFrame = null;
			mc.gotoAndStop(prev);
			updateAfterEvent();
		}, frame);
	}
	
	public static function cancelPlayReverse(mc:MovieClip):Void{
		mc.onEnterFrame = null;
	}

}
