// original: http://www.reflektions.com/miniml/template_permalink.asp?id=327
/**
* Test class for testing mtasc swf building in FlashDevelop.
* @mtasc -swf W:\INTERFACE\WWWInterface\AS_Packages\com\fbiz\bitmap\Pattern_test.swf -header 500:400:24:EFEFEF -main
*/ 


import flash.display.BitmapData;
import mx.utils.Delegate;

class com.fbiz.bitmap.Pattern extends MovieClip{

	private var mc:MovieClip;
	private var mcImg:MovieClip;
	private var img:BitmapData;
	
	private var stageListener:Object;
	
	function Pattern($mc:MovieClip, $img:String){
		
		mc = $mc;
		mcImg = mc.createEmptyMovieClip("image_mc",2);
		img  = BitmapData.loadBitmap($img);
		
		mc.attachBitmap(img,1);
		
		stageListener = {};
		stageListener.onResize = Delegate.create(this, refreshPattern);
		Stage.addListener(stageListener);

		draw();
	}
	
	private function draw():Void{
		
		mcImg.clear();
			
		mcImg.beginBitmapFill(img);
			mcImg.moveTo(0, 0);
			mcImg.lineTo(Stage.width, 0);
			mcImg.lineTo(Stage.width, Stage.height);
			mcImg.lineTo(0, Stage.height);
			mcImg.lineTo(0, 0);
		mcImg.endFill();
	}
	
	public function refreshPattern():Void{
		draw();
	}
	
}














