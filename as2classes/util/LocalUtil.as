class as2classes.util.LocalUtil {
		
	/**
		Determines if the SWF is being served on the internet.
		
		@param location: MovieClip to get location of.
		@return Returns <code>true</code> if SWF is being served on the internet; otherwise <code>false</code>.
		@usage
			<code>
				trace(LocationUtil.isWeb());
			</code>
	*/
	public static function isWeb():Boolean {
		return _root._url.substr(0, 4) == 'http';
	}
	
	/**
		Determines if the SWF is running in a browser plug-in.
		
		@return Returns <code>true</code> if SWF is running in the Flash Player browser plug-in; otherwise <code>false</code>.
	*/
	public static function isPlugin():Boolean {
		return System.capabilities.playerType == 'PlugIn' || System.capabilities.playerType == 'ActiveX';
	}
	
	/**
		Determines if the SWF is running in the IDE.
		
		@return Returns <code>true</code> if SWF is running in the Flash Player version used by the external player or test movie mode; otherwise <code>false</code>.
	*/
	public static function isIde():Boolean {
		return System.capabilities.playerType == 'External';
	}

	/**
		Determines if the SWF is running in the StandAlone player.
		
		@return Returns <code>true</code> if SWF is running in the Flash StandAlone Player; otherwise <code>false</code>.
	*/
	public static function isStandAlone():Boolean {
		return System.capabilities.playerType == 'StandAlone';
	}
}