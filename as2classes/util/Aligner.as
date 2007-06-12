/*
* Stage Aligner
*
* @author		Nicholas Almeida
* @version		1.0
* @history		
*
* @usage		import Aligner;
* 				new Aligner(mc:MovieClip, "ALIGN:String"[, host:MovieClip]);
*/

class as2classes.util.Aligner extends MovieClip{
	
	private static var arrAllMcs:Array = [];
	private static var stageListener:Object = {};	
	
	function Aligner($mc:MovieClip, $align:String, $host:MovieClip){
		if (Stage.scaleMode != "noScale" || Stage.align != "TL") {
			Stage.scaleMode = "noScale";	
			Stage.align = "TL";
			
			stageListener.onResize = updateAll;
			Stage.addListener(stageListener);
		}
		arrAllMcs.push({mc:$mc, align: $align, host:$host, easing:$host});
		
		updateAll();
	}
	
	public static function updateAll():Void{
		for(var i:Number=0; i<arrAllMcs.length;i++){
			var p:String = arrAllMcs[i].align.toLowerCase();
			var m:MovieClip = arrAllMcs[i].mc;
			
			var host:Object = {};
				host.who = arrAllMcs[i].host || Stage;
			
				host.w = (host.who==Stage) ? Stage.width : host.who._width;
				host.h = (host.who==Stage) ? Stage.height : host.who._height;
				host.x = (host.who==Stage) ? 0 : host.who._x;
				host.y = (host.who==Stage) ? 0 : host.who._y;
			
			var mcW:Number = arrAllMcs[i].mc._width;
			var mcH:Number = arrAllMcs[i].mc._height;
			
			with (m) {
				switch (p) {
					case "tl" :
						_x = host.who._x || 0;
						_y = host.who._y || 0;
						break;
					case "tc" :
						_x = (host.w/2)-(mcW/2)+host.x;
						_y = host.who._y || 0;
						break;
					case "tr" :
						_x = host.w-mcW+host.x;
						_y = host.who._y || 0;
						break;
					case "ml" :
						_x = host.who._x || 0;
						_y = (host.h/2)-(mcH/2)+host.y;
						break;
					case "mc" :
						_x = (host.w/2)-(mcW/2)+host.x;
						_y = (host.h/2)-(mcH/2)+host.y;
						break;
					case "mr" :
						_x = host.w-mcW+host.x;
						_y = (host.h/2)-(mcH/2)+host.y;
						break;
					case "bl" :
						_x = host.who._x || 0;
						_y = host.h-mcH+host.y;
						break;
					case "bc" :
						_x = (host.w/2)-(mcW/2)+host.x;
						_y = host.h-mcH+host.y;
						break;
					case "br" :
						_x = host.w-mcW+host.x;
						_y = host.h-mcH+host.y;
						break;
					default :
						trace("Wrong align parameter for: "+ m);
					}
			}
		}
		updateAfterEvent();
	}
	
	public static function help():Void{
		var h = "------------------------------------------------------------------------\n";
		h += "Aligner Class\n";
		h += "\n";
		h += "@author: Nichola Almeida, nicholasalmeida.com\n";
		h += "@version: 1.0\n";
		h += "@history: 18/09/2006\n";
		h += "\n";
		h += "Usage:\n";
		h += "	new Aligner(mc:MovieClip, \"ALIGN\" [, host]);\n";
		h += "\n";
		h += "Parameters:\n";
		h += "	mc:MovieClip = MovieClip to align.\n";
		h += "	ALIGN:String = position to align. \n";
		h += "		TL: Top Left \n";
		h += "		TC: Top Center \n";
		h += "		TR: Top Right \n";
		
		h += "		ML: Middle Left \n";
		h += "		MC: Middle Center \n";
		h += "		MR: Middle Right \n";
		
		h += "		BL: Bottom Left \n";
		h += "		BC: Bottom Center \n";
		h += "		BR: Bottom Right \n";
		
		h += "	host:MovieClip [OPTIONAL] = reference to align. Default Stage.\n";
		h += "\n";
		h += "------------------------------------------------------------------------\n";
		trace(h);
	}
}