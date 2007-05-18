class SimplePreloader extends Preloader{
	static var registered:Boolean = Preloader.register(SimplePreloader);
	static var initCalled:Boolean = false;
	static var percentLoaded:Number = 0;

	function onInit(){
		if(!initCalled){ // Gambiarra feita pra não executar a onInit 2 vezes!
			trace(" * Preload started");
			initCalled = true;
		}
	}
	
	function onStatus(status:PreloadStatus){
		percentLoaded = Math.round((status.bytesLoaded * 100)/status.bytesTotal);
		trace(" % Percent loaded = " + percentLoaded)
	}
	
	function onComplete(){
		trace(" + Preload complete");
	}
}
