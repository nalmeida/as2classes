/*
* Class show Alert box
*
* @author		Nicholas Almeida
* @version		1.0
* @history		
*
* @usage		import Alert;
*
* 				new Alert("MESSAGE", "TITLE");
*/

class com.fbiz.util.Alert extends MovieClip{
	
	public var mcBg:MovieClip;
	public var mcBox:MovieClip;
	public var mcBt:MovieClip;

	public static var statBg:MovieClip;
	public static var statBox:MovieClip;
	
	public var minWidth:Number;
	public var minHeight:Number;
	
	function Alert(str, tit){
		
		minWidth = 250;
		minHeight = 150;
		
		_level0.createEmptyMovieClip("mcBg", 1990);
		mcBg= _level0.mcBg;
		mcBg.beginFill(0xFFFFFF);
		mcBg.moveTo(0, 0);
		mcBg.lineTo(Stage.width, 0);
		mcBg.lineTo(Stage.width, Stage.height);
		mcBg.lineTo(0, Stage.height);
		mcBg.lineTo(0, 0);
		mcBg.endFill();
		mcBg._alpha = 50;
		mcBg.onPress = null;
		mcBg.useHandCursor = null;
		
		_level0.createEmptyMovieClip("mcBox", 1991);
		
		var bWidth:Number = Stage.width/3;
		var bHeight:Number = Stage.height/3;
		
		mcBox = _level0.mcBox;
		mcBox.beginFill(0xCCCCCC);
		mcBox.lineStyle(1, 0xFFFFFF, 100);
		mcBox.moveTo(0, 0);
		mcBox.lineTo(minWidth, 0);
		mcBox.lineStyle(1, 0x666666, 100);
		mcBox.lineTo(minWidth, minHeight);
		mcBox.lineTo(0, minHeight);
		mcBox.lineStyle(1, 0xFFFFFF, 100);
		mcBox.lineTo(0, 0);
		mcBox.endFill();
		
		mcBox._x = (Stage.width/2) - (mcBox._width/2);
		mcBox._y = (Stage.height/2) - (mcBox._height/2);

		_level0.mcBox.createTextField("mcTit", 1992, 5, 5, minWidth-9, 22);
		_level0.mcBox.mcTit.selectable = false;
		_level0.mcBox.mcTit.background = true;
		_level0.mcBox.mcTit.backgroundColor = 0x0A246A;
		_level0.mcBox.mcTit.textColor = 0xFFFFFF;
		var titFormat:TextFormat = new TextFormat();
			titFormat.font = "Verdana";
			titFormat.size = 14;
			titFormat.bold = true;
		_level0.mcBox.mcTit.text = (tit) ? tit : "Aviso";
		_level0.mcBox.mcTit.setTextFormat(titFormat);
		
		_level0.mcBox.createTextField("mcText", 1993, 5, 5+30, minWidth-9, minHeight-65);
		_level0.mcBox.mcText.multiline = true;
		_level0.mcBox.mcText.wordWrap = true;
		var txtFormat:TextFormat = new TextFormat();
			txtFormat.font = "Verdana";
			txtFormat.size = 12;
		_level0.mcBox.mcText.text = str;
		_level0.mcBox.mcText.setTextFormat(txtFormat);
		
		_level0.mcBox.createEmptyMovieClip("mcBt", 1994);
		mcBt = _level0.mcBox.mcBt;
		mcBt.beginFill(0xCCCCCC);
		mcBt.lineStyle(1, 0xFFFFFF, 100);
		mcBt.moveTo(0, 0);
		mcBt.lineTo(40, 0);
		mcBt.lineStyle(1, 0x666666, 100);
		mcBt.lineTo(40, 22);
		mcBt.lineTo(0, 22);
		mcBt.lineStyle(1, 0xFFFFFF, 100);
		mcBt.lineTo(0, 0);
		mcBt.endFill();
		
		_level0.mcBox.mcBt.createTextField("mcOk", 1995, 0, 0, 40, 22);
		_level0.mcBox.mcBt.mcOk.selectable = false;

		var okFormat:TextFormat = new TextFormat();
			okFormat.font = "Verdana";
			okFormat.size = 14;
			okFormat.bold = true;
			okFormat.align = "center";
		_level0.mcBox.mcBt.mcOk.text = "OK";
		_level0.mcBox.mcBt.mcOk.setTextFormat(okFormat);
		
		
		mcBt._x = (mcBox._width/2) - (mcBt._width/2);
		mcBt._y = mcBox._height - mcBt._height - 4;
		
		mcBt.onRelease = function(){
			Alert.hideAlert();
		}
		
		statBg = mcBg;
		statBox = mcBox;
		
		
		Stage.align = "TL";
		Stage.scaleMode = "noScale";
		
		var alertListener:Object = new Object();
		alertListener.onResize = function(){
			Alert.statBg._width = Stage.width;
			Alert.statBg._height = Stage.height;
			
			Alert.statBox._x = (Stage.width/2) - (Alert.statBox._width/2);
			Alert.statBox._y = (Stage.height/2) - (Alert.statBox._height/2);
		}
		Stage.addListener(alertListener);

	}
	
	public static function hideAlert():Void{
		Alert.statBg.unloadMovie();
		Alert.statBox.unloadMovie();
	}
	
}