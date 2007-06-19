/**
* ScrollMovieclip Component
* @author Nicholas Almeida
* @version 0.1
* @history 15/07/2007 : Created
*/

import as2classes.util.Delegate;
import org.casaframework.mouse.EventMouse;

class as2classes.form.ScrollMovieclipComponent extends MovieClip{
	
	private var mc:MovieClip;
	private var mcArrowUp:MovieClip;
	private var mcArrowDown:MovieClip;
	private var mcTrack:MovieClip;
	private var mcSlider:MovieClip;
	private var initSize:Object;
	
	private var interval:Number;
	private var sliderBottomLimit:Number;
	private var difference:Number;
	
	private var mcMask:MovieClip;
	private var mcMasked:MovieClip;
	
	private var mouseInstance:EventMouse;
	
	function ScrollMovieclipComponent(){
		mc = this;

		mcArrowUp = mc.mcArrowUp;
		mcArrowDown = mc.mcArrowDown;
		mcTrack = mc.mcTrack;
		mcSlider = mc.mcSlider;
		
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
		
		mouseInstance = EventMouse.getInstance();
		mouseInstance.addEventObserver(this, EventMouse.EVENT_MOUSE_WHEEL);
		
	}
	
	public function init(obj:Object):Void{
		
		mcMask = obj.mcMask;
		mcMasked = obj.mcMasked;
		
		if(!mcMask) trace("ERROR on ScrollComponent: " + mc + " parameter \"mcMask\" not defined.");
		if(!mcMasked) trace("ERROR on ScrollComponent: " + mc + " parameter \"mcMasked\" not defined.");
		
		mcMasked.setMask(mcMask);
		
		ajustSize();

		difference = 10 + (Math.ceil(mcMasked._height / mcMask._height)*2);
	}
	
	public function setHeight(newHeight:Number):Void{
		initSize.h = newHeight;
		ajustSize();
	}
	
	public function ajustSize():Void{
		mc._xscale = mc._yscale = 100;
		
		mcTrack._y = mcArrowUp._height-1;
		mcTrack._height = initSize.h - mcArrowUp._height - mcArrowDown._height;
		mcArrowDown._y = mcTrack._height + mcArrowDown._height-1;
		
		sliderBottomLimit = (mcTrack._y + mcTrack._height - mcSlider._height)+1;
		
		if(mcMasked._height <= mcMask._height) {
			mc._visible = false;
			mouseInstance.removeEventObserver();
		}
		
		if(mcSlider._height > mcTrack._height) hideSlider();
	}
	
	public function hideSlider():Void{
		mcSlider._visible = false;
		mcTrack.onPress = null;
	}
	
	public function enable():Void{
		mcArrowDown.enabled = 
		mcArrowUp.enabled = 
		mcSlider.enabled = 
		mcTrack.enabled = true;
		mouseInstance.addEventObserver(this, EventMouse.EVENT_MOUSE_WHEEL);
		mc._alpha = 100;
	}
	
	public function disable():Void{
		mcArrowDown.enabled = 
		mcArrowUp.enabled = 
		mcSlider.enabled = 
		mcTrack.enabled = false;
		mouseInstance.removeEventObserver();
		mc._alpha = 50;
	}
	
	public function hide():Void{
		mc._visible = false;
	}
	
	public function show():Void{
		mc._visible = true;
	}	
	
	/*
	* Arrows Stuff
	*/
	//{
	public function scrollUp():Void{
		pressArrow(mcArrowUp);
		doScrollUp();
		interval = setInterval(Delegate.create(mc, doScrollUp), 50);
	}
	
	private function doScrollUp():Void{
		if(Math.abs(mcMasked._y) > difference) {
			mcMasked._y += difference;
		} else {
			mcMasked._y = 0;
		}
		positionSlider();
	}
	
	public function scrollDown():Void{
		pressArrow(mcArrowDown);
		doScrollDown();
		interval = setInterval(Delegate.create(mc, doScrollDown), 50);
	}
	
	private function doScrollDown():Void{
		if(Math.abs(mcMasked._y) < mcMasked._height - mcMask._height - difference) {
			mcMasked._y -= difference;
		} else {
			mcMasked._y = -(mcMasked._height - mcMask._height);
		}
		positionSlider();
	}
	
	private function positionSlider():Void{

		var track:Number = mcTrack._height - mcSlider._height;
		var h:Number = mcMasked._height - mcMask._height;
		var currPos:Number = mcMasked._y;
		
		var calc:Number = mcTrack._y - ((currPos * track) / h);
		
		mcSlider._y = calc + 1;
	}
	
	private function pressArrow(arrow:MovieClip):Void{
		arrow.gotoAndStop("release");
	}
	
	private function releaseArrow(arrow:MovieClip):Void{
		arrow.gotoAndStop("out");
		clearInterval(interval);
	}
	
	//}
	
	
	/*
	* Slider Stuff
	*/
	//{
	private function slideScroll():Void{
		mcSlider.startDrag(false,0,mcTrack._y+1,0,sliderBottomLimit);
		clearInterval(interval);
		
		interval = setInterval(Delegate.create(mc, doScollSlider), 50);
	}
	
	private function doScollSlider():Void{
		var calc:Number = -((((mcSlider._y - mcTrack._y) * (mcMasked._height - mcMask._height)) / (mcTrack._height - mcSlider._height))-1);

		if(Math.abs(calc) < (difference/2)) {
			calc = 0;
		}
		if(mcSlider._y == Math.floor(sliderBottomLimit)){
			calc = -(mcMasked._height - mcMask._height);
		}
		mcMasked._y = calc;
	}
	
	private function releaseSlider():Void{
		mcSlider.stopDrag();
		clearInterval(interval);
	}
	//}
	
	
	/*
	* Track Stuff
	*/
	//{
	private function pressTrack():Void{
		if(this._ymouse <= sliderBottomLimit)
			mcSlider._y = this._ymouse;
		else 
			mcSlider._y = sliderBottomLimit;
			
		doScollSlider();
	}
	//}
	
	
	/*
	* Wheel Stuff
	*/
	//{
	private function onMouseWheel(delta:Number, target:String):Void{
		
		if((mcMask._xmouse >=0 && mcMask._xmouse <= mcMask._width && mcMask._ymouse >=0 && mcMask._ymouse <= mcMask._height)  // over mask
			|| 
			(mc._xmouse >=0 && mc._xmouse <= mc._width && mc._ymouse >=0 && mc._ymouse <= mc._height) // over scroll
		  ){

			if(delta <0) doScrollDown();
			else doScrollUp();
		}
	}
	//}
}
