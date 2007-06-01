/**
* Textarea Component
* @author Nicholas Almeida
* @version 0.1
*/

import as2classes.util.Delegate;

class as2classes.form.TextareaComponent extends MovieClip{
	
	private var mc:MovieClip;
	private var textField:TextField;
	private var mcArrowUp:MovieClip;
	private var mcArrowDown:MovieClip;
	
	private var initSize:Object;
	private var interval:Number;
	
	public var required:Boolean;
	public var maxChars:Number;
	public var value:String;
	
	function TextareaComponent(){
		mc = this;
		mcArrowUp = mc.mcArrowUp;
		mcArrowDown = mc.mcArrowDown;
		textField = mc.fld_text;
		
		initSize = {};
			initSize.w = mc._width;
			initSize.h = mc._height;
			
		mcArrowUp.onPress = Delegate.create(this, scrollUp);
		mcArrowUp.onRelease = 
		mcArrowUp.onReleaseOutside = Delegate.create(this, releaseArrow, mcArrowUp);
		
		mcArrowDown.onPress = Delegate.create(this, scrollDown);
		mcArrowDown.onRelease = 
		mcArrowDown.onReleaseOutside = Delegate.create(this, releaseArrow, mcArrowDown);
			
		clearInterval(interval);
		required = false;
	}
	
	public function init(obj:Object):Void{
		// reset size
		ajustSize();
		
		if(obj.maxChars) setMaxChars(obj.maxChars);
		if(obj.text) setText(obj.text);
	}
	
	public function setSize(width:Number, height:Number):Void{
		initSize.w = width;
		initSize.h = height;
		
		ajustSize();
	}
	
	public function ajustSize():Void{
		mc._xscale = mc._yscale = 100;
		textField._width = initSize.w - mcArrowUp._width;
		textField._height = initSize.h - mcArrowUp._height;
		
		mcArrowDown._x = mcArrowUp._x = textField._width;
		mcArrowUp._y = 0;
		
		mcArrowDown._y = textField._height - mcArrowDown._height;
	}
	
	public function setMaxChars(n:Number):Void{
		textField.maxChars = maxChars = n;
	}
	
	public function getMaxChars():Number{
		return maxChars;
	}
	
	public function setText(txt):Void{
		textField.text = value = txt;
	}
	
	public function getText():String{
		value = textField.text;
		return value;
	}
	
	private function pressArrow(arrow:MovieClip):Void{
		arrow.gotoAndStop("release");
	}
	
	private function releaseArrow(arrow:MovieClip):Void{
		arrow.gotoAndStop("out");
		clearInterval(interval);
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
	
	private function doScrollDown():Void{
		textField.scroll++;
	}
	
	private function doScrollUp():Void{
		textField.scroll--;
	}	
	
}