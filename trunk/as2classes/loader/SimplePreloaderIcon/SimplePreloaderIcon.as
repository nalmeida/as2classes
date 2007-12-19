
import as2classes.stage.StageAlign;
import as2classes.util.MovieclipUtil;

class SimplePreloaderIcon extends Preloader {
	static var registered:Boolean = Preloader.register(SimplePreloaderIcon);
	
	private static var mcLoader:MovieClip = _root.attachMovie("mcStandardLoader", "mcStandardLoader", 1, {_x: -5000, _y: -5000});
	private static var s = StageAlign.basic();
	private static var loaderObjListener:Object = {};
	private static var hasInit:Boolean = false;
	
	function onInit() {
		if(!hasInit){
			hasInit = true;
			
			// ---------------------------------------------------
			// If you want to change yhe loader color, do it here!
			// ---------------------------------------------------
			var color:Color = new Color(mcLoader); 
				color.setRGB(0x000000);
			// ---------------------------------------------------
		
			loaderObjListener.onResize = resetPosition;
			Stage.addListener(loaderObjListener);
			
			resetPosition();
		}
	}
	
	function onStatus(status:PreloadStatus) {
	}
	
	function onComplete(){
		Stage.removeListener(loaderObjListener);
		MovieclipUtil.removeChilds(mcLoader);
		MovieclipUtil.remove(mcLoader);
	}
	
	private static function resetPosition():Void{
		mcLoader._x = Stage.width * .5;
		mcLoader._y = Stage.height * .5;
	}
}
