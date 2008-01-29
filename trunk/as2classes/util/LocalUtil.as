class as2classes.util.LocalUtil {
		
	public static function isWeb():Boolean {
		return _root._url.substr(0, 4) == 'http';
	}
}