class as2classes.util.Debug{

	private var btDebug:MovieClip;
	private var counter:Number = 0;
	
	/**
		createButtom - create a Buttom with custom function.
		@param $obj:Object - Object with options.
		@return none
	*/
	public function Debug($obj:Object){
		/**
			$obj.onRelease
			$obj.onRollOver
			$obj.onRollOut
			$obj.onReleaseOutside
			$obj._width
			$obj._height
			$obj._x
			$obj._y
			$obj.color
			$obj.scope
		*/
		
		btDebug = _root.createEmptyMovieClip("teste123"+counter,_root.getNextHighestDepth()+2000000);
		counter++;
		
		btDebug.beginFill($obj.color || 0xFF0000);
		btDebug.moveTo(0,0);
		btDebug.lineTo(0,100);
		btDebug.lineTo(100,100);
		btDebug.lineTo(100,0);
		btDebug.lineTo(0,0);
		btDebug.endFill();
		
		btDebug.onRelease = function(){$obj.onRelease($obj.scope)};
		btDebug.onRollOver = function(){$obj.onRollOver($obj.scope)};
		btDebug.onRollOut = function(){$obj.onRollOut($obj.scope)};
		btDebug.onReleaseOutside = function(){$obj.onReleaseOutside($obj.scope)};
		btDebug._x = $obj._x || 0;
		btDebug._y = $obj._y || 0;
		
		if($obj._width)
			btDebug._width = $obj._width;
		if($obj._height)
			btDebug._height = $obj._height;
	}
	public function getButton(){
		return btDebug;
	}
}
