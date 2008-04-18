import flash.display.BitmapData;   



// @original: http://www.actionscript.org/forums/showthread.php3?t=89255

class as2classes.util.Smooth {         
	
	private var bmd:BitmapData;    // the BitmapData instance that will smooth the image         
	
	public function Smooth(copy:MovieClip) {         
		bmd = new BitmapData(copy._width, copy._height, true, 0);  // create the instance to the right dimensions         
		bmd.draw(copy);                                            // copy the image into the instance                 
		copy.unloadMovie();                          // unload the original movie         
		copy.attachBitmap(bmd, 0, "auto", true);     // attach the bmd instance and apply smoothing     
	}
}