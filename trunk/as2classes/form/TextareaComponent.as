/**
* Textarea Component
* @author Nicholas Almeida
* @version 0.1
* 
* TODO: BUG: o slider, quando muito grande dá problema dpois da metade
*/

import as2classes.util.Delegate;
import as2classes.form.TextfieldUtil;

class as2classes.form.TextareaComponent extends MovieClip{
	
	private var mc:MovieClip;
	public  var textField:TextField;
	private var mcScrollBar:MovieClip;
	private var mcArrowUp:MovieClip;
	private var mcArrowDown:MovieClip;
	private var mcTrack:MovieClip;
	private var mcSlider:MovieClip;
	
	private var initSize:Object;
	private var interval:Number;
	private var initText:String;
	private var textHeightToScroll:Number;
	private var lineHeight:Number;
	private var needScroll:Boolean;
	private var minSliderHeight:Number;
	private var sliderBottomLimit:Number;
	private var mouseListener:Object;
		
	public var required:Boolean;
	public var maxChars:Number;
	public var minChars:Number;
	public var value:String;
	public var title:String;
	public var isEmpty:Boolean;
	public var type:String;
	public var restrict:String;
	public var border:Boolean;
	public var htmlText:Boolean;
	
	function TextareaComponent(){
		mc = this;
		mc.isFormField = true;
		textField = mc.fld_text;
		
		mcScrollBar = mc.mcScrollBar;
		mcArrowUp = mcScrollBar.mcArrowUp;
		mcArrowDown = mcScrollBar.mcArrowDown;
		mcTrack = mcScrollBar.mcTrack;
		mcSlider = mcScrollBar.mcSlider;
		
		initSize = {};
			initSize.w = mc._width;
			initSize.h = mc._height;
			
		mcArrowUp.onPress = Delegate.create(this, scrollUp);
		mcArrowUp.onRelease = 
		mcArrowUp.onReleaseOutside = Delegate.create(this, releaseArrow, mcArrowUp);
		
		mcArrowDown.onPress = Delegate.create(this, scrollDown);
		mcArrowDown.onRelease = 
		mcArrowDown.onReleaseOutside = Delegate.create(this, releaseArrow, mcArrowDown);
		
		mcSlider.onPress = Delegate.create(this, slideScroll);
		mcSlider.onMouseUp = Delegate.create(this, releaseSlider);
		
		mcTrack.onPress = Delegate.create(this, pressTrack);
		
		mcArrowUp.useHandCursor = mcArrowDown.useHandCursor = mcSlider.useHandCursor = mcTrack.useHandCursor = false;
		
		textField.onChanged = Delegate.create(this, onChange);
		
		textField.mouseWheelEnabled = false;
		
		mouseListener = {};
		mouseListener.onMouseWheel = Delegate.create(this, moveUsingWheel);
		Mouse.addListener(mouseListener);
			
		lineHeight = getLinheHeight();
		
		clearInterval(interval);
		required = false;
		minSliderHeight = 24;
		
	}
	
	/**
	* @param type:String. Values: "input"(default) or "dynamic"
	* @param maxChars:Number. Default = ""
	* @param minChars:Number. Default = ""
	* @param text:String. Default = ""
	* @param initText:String. Default = ""
	* @param restrict:String. Default = ""
	* @param title:String. Default = ""
	* @param htmlText:Boolean. Default = false
	*/
	public function init(obj:Object):Void{
		
		// Title
		if(!obj.title) trace("WARNING on TextField: " + mc + " parameter \"title\" not defined.");
		title = obj.title || mc._name;
		
		lineHeight = getLinheHeight();
		
		// reset size
		ajustSize();
		
		type = obj.type || "input";
		
		textField.type = type;
		
		border = (obj.border === false ? false : true);
		
		htmlText = (obj.htmlText === true) ? true : false;
		
		if(obj.textColor) {
			textField.textColor = obj.textColor;
		}
		
		if(htmlText === true && obj.textColor) trace("WARNING on TextField: " + mc + ". If you are using htmlText, the textColor property don't work.");
		
		
		if(htmlText){
			textField.html = true;
		}
		
		if(border == false){
			textField.border = false;
		}

		
		if(obj.restrict) {
			restrict = obj.restrict;
			TextfieldUtil.aplyRestriction(textField, restrict);
		}
		
		if(obj.maxChars) setMaxChars(obj.maxChars);
		if(obj.minChars) setMinChars(obj.minChars);
		if(obj.text) {
			setText(obj.text);
			isEmpty = false;
		}
		if(obj.initText && type == "input") {
			setInitText(obj.initText);
			value = "";
			isEmpty = true;
		}
		
		sliderBottomLimit = (mcTrack._y + mcTrack._height - mcSlider._height);
		
		if(obj.required != undefined) required = obj.required;

		checkIfNeedScroll();
		
		// Tab
		mc.tabEnabled = false;
		mc.tabChildren = true;
		textField.tabEnabled = true;
		textField.tabIndex = obj.tabIndex || 1;
	}
	
	public function setSize(width:Number, height:Number):Void{
		initSize.w = width;
		initSize.h = height;
		
		ajustSize();
	}
	
	public function ajustSize():Void{
		mc._xscale = mc._yscale = 100;
		textField._width = initSize.w - mcScrollBar._width;
		textField._height = initSize.h;
		
		mcScrollBar._x = textField._width + 1;
		mcArrowDown._y = textField._height - mcArrowDown._height;
		
		mcTrack._y = mcArrowUp._height - 1;
		mcTrack._height = initSize.h - mcArrowDown._height - mcArrowUp._height + 2;
		
		//mcSlider._height = mcTrack._height;
		
		onChange();
	}
	
	public function enable():Void{
		TextfieldUtil.aplyRestriction(textField, restrict);
		textField.selectable = true;
		enableScroll();
		textField.onChanged = Delegate.create(this, onChange);
		setInitText();
		mc._alpha = 100;
	}
	
	public function disable():Void{
		TextfieldUtil.aplyRestriction(textField, "disable");
		textField.selectable = false;
		disableScroll();
		textField.onChanged = function(){};
		textField.onSetFocus = function(){};
		textField.onKillFocus = function(){};
		if(mc._alpha != 50) mc._alpha = 50;
	}
	
	public function setMaxChars(n:Number):Void{
		textField.maxChars = maxChars = n;
	}
	
	public function getMaxChars():Number{
		return maxChars;
	}
	
	public function setMinChars(n:Number):Void{
		minChars = n;
	}
	
	public function getMinChars():Number{
		return minChars;
	}
	
	public function setText(txt):Void{
		if(htmlText) textField.htmlText = value = txt;
		else textField.text = value = txt;
		ajustSize();
	}
	
	public function setInitText(txt:String):Void{
		if(txt) {
			if(htmlText) textField.htmlText = initText = txt;
			else textField.htmlText = initText = txt;
		}
		textField.onSetFocus = Delegate.create(this, clearField);
		textField.onKillFocus = Delegate.create(this, checkIfIsEmpty);
	}
	
	public function getText():String{
		if(htmlText) value = textField.htmlText;
		else value = textField.text;
		return value;
	}
		
	public function scrollUp():Void{
		pressArrow(mcArrowUp);
		doScrollUp();
		interval = setInterval(Delegate.create(mc, doScrollUp), 80);
	}
	
	public function scrollDown():Void{
		pressArrow(mcArrowDown);
		doScrollDown();
		interval = setInterval(Delegate.create(mc, doScrollDown), 80);
	}
	
	
	public function checkIfNeedScroll():Void{
		if(textField.textHeight - textField._height <=0) disableScroll();
		else enableScroll();
	}
	
	public function disableScroll():Void{
		for (var i in mcScrollBar) {
			mcScrollBar[i].enabled = false;
		}
		mcSlider._visible = false;
		mcScrollBar._alpha = 50;
		Mouse.removeListener(mouseListener);
	}
	
	public function enableScroll():Void{
		for (var i in mcScrollBar) {
			mcScrollBar[i].enabled = true;
		}
		mcSlider._visible = true;
		mcScrollBar._alpha = 100;
		Mouse.addListener(mouseListener);
		
		/*
		var calc = textField.textHeight - textField._height;
		if(calc>0){
			if(mcSlider._height > minSliderHeight)
				mcSlider._height -= (calc/2);
			else 
				mcSlider._height = minSliderHeight;
		}
		*/
	}	
	
	private function releaseSlider():Void{
		mcSlider.stopDrag();
		clearInterval(interval);
	}
	
	private function slideScroll():Void{
		mcSlider.startDrag(false,0,mcTrack._y+1,0,sliderBottomLimit);
		clearInterval(interval);
		
		interval = setInterval(Delegate.create(mc, doScollSlider), 50);
	}
	
	private function doScollSlider():Void{
		var sobra:Number = textField.textHeight - textField._height;
		if(sobra <= textField._height) sobra = textField._height;

		var altTrack:Number = mcTrack._height - mcSlider._height;
		var posSlider:Number = mcSlider._y - mcSlider._height + mcArrowUp._height;

		var calc:Number = (sobra * posSlider) / altTrack;
		var final:Number = Math.abs(calc / lineHeight);
		
		if(final > textField.maxscroll) final = textField.maxscroll;
		textField.scroll = Math.ceil(final);
	}
	
	private function onChange():Void{
		checkIfNeedScroll();
		positionSlider();
		
		if(htmlText) value = (textField.htmlText != initText) ? textField.htmlText : "";
		else value = (textField.text != initText) ? textField.text : "";
	}
	
	
	private function positionSlider():Void{
		
		// editando área "escondida"
		if(textField.scroll >1) {
			if(textField.scroll == textField.maxscroll ) {
				mcSlider._y = sliderBottomLimit;
			} else {
				mcSlider._y = Math.round((((textField.scroll * lineHeight) * (mcTrack._y + mcTrack._height)) / (textField.textHeight - textField._height)) + mcSlider._height);
				if(mcSlider._y >= sliderBottomLimit) mcSlider._y = sliderBottomLimit;
			}
			
		}
		
		// editando área do começo do texto
		else 
			mcSlider._y = mcArrowUp._height;
	}
	
	
	private function clearField():Void{
		if(getText() == initText || getText().length == 0){
			if(htmlText) textField.htmlText = "";
			else textField.text = "";
			isEmpty = true;
			value = "";
		}
	}
	
	private function checkIfIsEmpty():Void{
		if(getText() == "") {
			if(htmlText) textField.htmlText = initText;
			else textField.text = initText;
			isEmpty = true;
			value = "";
		} else {
			isEmpty = false;
			if(htmlText) value = textField.htmlText;
			else value = textField.text;
		}
	}
	
	private function pressTrack():Void{
		
		if(this._ymouse <= sliderBottomLimit)
			mcSlider._y = this._ymouse;
		else 
			mcSlider._y = sliderBottomLimit;
			
		doScollSlider();
	}
	
	private function pressArrow(arrow:MovieClip):Void{
		arrow.gotoAndStop("release");
	}
	
	private function releaseArrow(arrow:MovieClip):Void{
		arrow.gotoAndStop("out");
		clearInterval(interval);
	}
	
	
	
	private function doScrollDown():Void{
		textField.scroll++;
		positionSlider();
	}
	
	private function doScrollUp():Void{
		textField.scroll--;
		positionSlider();
	}
	
	private function getLinheHeight():Number{
		var temp = mc.duplicateMovieClip("temp", 10, {_x: 150, _visible: false});
			temp._xscale = temp._yscale = 100;
			temp.fld_text.text = "Wg";
			temp.fld_text.autoSize = true;
		
		lineHeight = Math.round(temp.fld_text.textHeight - 2);
		temp.unloadMovie();
		
		return lineHeight;
	}
	
	private function moveUsingWheel(delta:Number):Void{
		
			if(mc._xmouse >=0 && mc._xmouse <= mc._width && mc._ymouse >=0 && mc._ymouse <= mc._height){
				if(delta <0) doScrollDown();
				else doScrollUp();
				positionSlider();
			}
	}
	
}