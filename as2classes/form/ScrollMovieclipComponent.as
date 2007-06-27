/*
	AS2classes Framework for ActionScript 2.0
	Copyright (C) 2007  Nicholas Almeida
	http://nicholasalmeida.com
	
	This library is free software; you can redistribute it and/or
	modify it under the terms of the GNU Lesser General Public
	License as published by the Free Software Foundation; either
	version 2.1 of the License, or (at your option) any later version.
	http://www.gnu.org/licenses/lgpl.html
	
	This library is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
	Lesser General Public License for more details.
*/

import as2classes.util.Delegate;
import org.casaframework.mouse.EventMouse;

/**
	ScrollMovieclip Component. A lightweight scroll component for movieclips.
	
	@author Nicholas Almeida
	@version 27/06/07
	@since Flash Player 8
	@example
		<code>
			import as2classes.form.ScrollMovieclipComponent;

			var mcScroll:ScrollMovieclipComponent = new ScrollMovieclipComponent(mcScroll);
			
			mcScroll.init({
				mcMask:mcTest.mcMasck, 
				mcMasked:mcTest.mcContent
			});
		</code>
*/

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
	
	public var visibleStatus:String;
	
	function ScrollMovieclipComponent($mc:MovieClip){
		mc = $mc || this;

		mcArrowUp = mc.mcArrowUp;
		mcArrowDown = mc.mcArrowDown;
		mcTrack = mc.mcTrack;
		mcSlider = mc.mcSlider;
		
		initSize = {};
			initSize.w = mc._width;
			initSize.h = mc._height;
			
		visibleStatus = "visible";
	}
	
	/**
		Initialize the Scroll Component.
		
		@param obj: Object notation to get the real parameters.
		@param obj.mcMask:MovieClip - MovieClip to use as mask.
		@param obj.mcMasked:MovieClip - MovieClip to use be masked.
		@return Return none.
	*/
	public function init(obj:Object):Void{
		
		mcMask = obj.mcMask;
		mcMasked = obj.mcMasked;
		
		if(!mcMask) trace("ERROR on ScrollComponent: " + mc + " parameter \"mcMask\" not defined.");
		if(!mcMasked) trace("ERROR on ScrollComponent: " + mc + " parameter \"mcMasked\" not defined.");
		
		mcMasked.setMask(mcMask);
		
		// Handlers
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
		//
		
		ajustSize();

		difference = 10 + (Math.ceil(mcMasked._height / mcMask._height)*2);
	}
	
	/**
		Set the Scroll Height
		
		@param newHeight:Number - Scroll height.
		@return Return none.
	*/
	public function setHeight(newHeight:Number):Void{
		initSize.h = newHeight;
		ajustSize();
	}
	
	/**
		Ajust the Scroll size avoiding the Movieclip deformation.
		
		@return Return none.
	*/
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
	
	/**
		Reset the Slider and mcMasked postiond to 0.
		
		@return Return none.
	*/
	public function reset():Void{
		mcMasked._y = mcMask._y;
		mcSlider._y = mcArrowUp._height;
		if(mcSlider._height > mcTrack._height) hideSlider();
		else showSlider();
	}
	
	/**
		Hide the slider
		
		@return Return none.
	*/
	public function hideSlider():Void{
		mcSlider._visible = false;
		mcTrack.onPress = null;
	}
	
	/**
		Show the slider
		
		@return Return none.
	*/
	public function showSlider():Void{
		mcSlider._visible = true;
		mcTrack.onPress = Delegate.create(this, pressTrack);
	}
	
	/**
		Enable the Scroll funcions and set de _alpha to 100.
		
		@return Return none.
	*/
	public function enable():Void{
		mcArrowDown.enabled = 
		mcArrowUp.enabled = 
		mcSlider.enabled = 
		mcTrack.enabled = true;
		mouseInstance.addEventObserver(this, EventMouse.EVENT_MOUSE_WHEEL);
		mc._alpha = 100;
	}
	
	/**
		Disable the Scroll funcions and set de _alpha to 50.
		
		@return Return none.
	*/
	public function disable():Void{
		mcArrowDown.enabled = 
		mcArrowUp.enabled = 
		mcSlider.enabled = 
		mcTrack.enabled = false;
		mouseInstance.removeEventObserver();
		mc._alpha = 50;
	}
	
	/**
		Hide the Scroll.
		
		@return Return none.
	*/
	public function hide():Void{
		mc._visible = false;
		visibleStatus = "hidden";
	}
	
	/**
		Show the Scroll.
		
		@return Return none.
	*/
	public function show():Void{
		mc._visible = true;
		visibleStatus = "visible";
	}	
	
	/*
	* Arrows Stuff
	*/
	//{
	
	/**
		Scroll the content to UP.
		
		@return Return none.
	*/
	public function scrollUp():Void{
		pressArrow(mcArrowUp);
		doScrollUp(mcMask, mcMasked, difference, mcSlider, mcTrack);
		interval = setInterval(Delegate.create(this, doScrollUp, mcMask, mcMasked, difference, mcSlider, mcTrack), 50);
	}

	private function doScrollUp(mcMask:MovieClip, mcMasked:MovieClip, difference:Number, mcSlider:MovieClip, mcTrack:MovieClip):Void{
		if(Math.abs(mcMasked._y) > difference) {
			mcMasked._y += difference;
		} else {
			mcMasked._y = 0;
		}
		positionSlider(mcMask, mcMasked, mcSlider, mcTrack);
	}
	
	/**
		Scroll the content to DOWN.
		
		@return Return none.
	*/
	public function scrollDown():Void{
		pressArrow(mcArrowDown);
		doScrollDown(mcMask, mcMasked, difference, mcSlider, mcTrack);
		interval = setInterval(Delegate.create(this, doScrollDown, mcMask, mcMasked, difference, mcSlider, mcTrack), 50);
	}
	
	private function doScrollDown(mcMask:MovieClip, mcMasked:MovieClip, difference:Number):Void{
		if(Math.abs(mcMasked._y) < mcMasked._height - mcMask._height - difference) {
			mcMasked._y -= difference;
		} else {
			mcMasked._y = -(mcMasked._height - mcMask._height);
		}
		positionSlider(mcMask, mcMasked, mcSlider, mcTrack);
	}
	
	private function positionSlider(mcMask:MovieClip, mcMasked:MovieClip, mcSlider:MovieClip, mcTrack:MovieClip):Void{
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
		
		interval = setInterval(Delegate.create(mc, doScollSlider, mcMask, mcMasked), 50);
	}
	
	private function doScollSlider(mcMask:MovieClip, mcMasked:MovieClip):Void{
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
		if(mc._ymouse <= sliderBottomLimit)
			mcSlider._y = mc._ymouse;
		else 
			mcSlider._y = sliderBottomLimit;
		doScollSlider(mcMask, mcMasked);
	}
	//}
	
	
	/*
	* Wheel Stuff
	*/
	//{
	private function onMouseWheel(delta:Number, target:String):Void{
		/*
		mcMask = Global.getVar("mcMask");
		mcMasked = Global.getVar("mcMasked");
		*/
		if((mcMask._xmouse >=0 && mcMask._xmouse <= mcMask._width && mcMask._ymouse >=0 && mcMask._ymouse <= mcMask._height)  // over mask
			|| 
			(mc._xmouse >=0 && mc._xmouse <= mc._width && mc._ymouse >=0 && mc._ymouse <= mc._height) // over scroll
		  ){

			if(delta <0) doScrollDown(mcMask, mcMasked, difference, mcSlider, mcTrack);
			else doScrollUp(mcMask, mcMasked, difference, mcSlider, mcTrack);
		}
	}
	//}
}
