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
}
