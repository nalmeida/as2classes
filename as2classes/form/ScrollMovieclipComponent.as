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
import gs.TweenLite;

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
				mcMasked:mcTest.mcContent,
				mcMaskedHeight: 470,
				skin: {
						arrowUp: "mcArrowUpCustom",
						arrowDown: "mcArrowDownCustom",
						track: "mcTrackCustom",
						slider: "mcSliderCustom"
					  }
					  
				});
			});
		</code>
*/

class as2classes.form.ScrollMovieclipComponent extends MovieClip{
	
	public var mc:MovieClip;
	private var mcArrowUp:MovieClip;
	private var mcArrowDown:MovieClip;
	private var mcTrack:MovieClip;
	private var mcSlider:MovieClip;
	private var initSize:Object;
	private var skin:Object;
	
	private var interval:Number;
	private var sliderBottomLimit:Number;
	private var difference:Number;
	
	private var mcMask:MovieClip;
	private var mcMasked:MovieClip;
	private var mcMaskedHeight:Number;
	private var maskedHeight:Number;
	
	private var mouseInstance:EventMouse;
	
	public var visibleStatus:String;
	public var easing:Boolean;
	public var easingSpeed:Number;
	
	/**
		ScrollMovieclip Component constructor.
		
		@param $mc:MovieClip - Movieclip to be used as the component.
		@return Return none.
	*/
	function ScrollMovieclipComponent($mc:MovieClip){
		mc = $mc || this;

		mcArrowUp = mc.mcArrowUp;
		mcArrowDown = mc.mcArrowDown;
		mcTrack = mc.mcTrack;
		mcSlider = mc.mcSlider;
			
		visibleStatus = "visible";
	}
	
	/**
		Initialize the Scroll Component.
		
		@param obj: Object notation to get the real parameters.
		@param obj.mcMask:MovieClip - MovieClip to use as mask.
		@param obj.mcMasked:MovieClip - MovieClip to use be masked.
		@param obj.mcMaskedHeight:Number - Forces de mcMasked height to a fized number.
		@param obj.skin:Object - Objects enales custom skin for each scroll. Uses attachMovie Method.
			   obj.skin.arrowUp:String
			   obj.skin.arrowDown:String
			   obj.skin.arrowTrack:String
			   obj.skin.arrowSlider:String
		@param obj.easing:Boolean - If you want to use an easing effect for scroll. Default false;
		@param obj.easingSpeed:Number - If you want to change the easing speed. Default .8;
		@return Return none.
	*/
	public function init(obj:Object):Void{
		
		mcMask = obj.mcMask;
		mcMasked = obj.mcMasked;
		mcMaskedHeight = obj.mcMaskedHeight;
		skin = obj.skin;
		
		if(!mcMask) trace("ERROR on ScrollComponent: " + mc + " parameter \"mcMask\" not defined.");
		if(!mcMasked) trace("ERROR on ScrollComponent: " + mc + " parameter \"mcMasked\" not defined.");
		
		mcMask.cacheAsBitmap = 
		mcMasked.cacheAsBitmap = true;
		
		mcMasked.setMask(mcMask);
		
		if(obj.easing) {
			easing = obj.easing;
		} else {
			easing = false;
		}
		
		if(obj.easingSpeed) {
			easingSpeed = obj.easingSpeed;
		} else {
			easingSpeed = .8;
		}
		
		if(skin){

			if(skin.arrowUp) {
				mcArrowUp.unloadMovie();
				mcArrowUp = mc.attachMovie(skin.arrowUp, "mcArrowUp", mc.getNextHighestDepth());
			}
			
			if(skin.track) {
				mcTrack.unloadMovie();
				mcTrack = mc.attachMovie(skin.track, "mcTrack", mc.getNextHighestDepth(), {_y: mcArrowUp._y + mcArrowUp._height});
			}
			
			if(skin.arrowDown) {
				mcArrowDown.unloadMovie();
				mcArrowDown = mc.attachMovie(skin.arrowDown, "mcArrowDown", mc.getNextHighestDepth(), {_y: mcTrack._y +  mcTrack._height});
			}
			
			if(skin.slider) {
				mcSlider.unloadMovie();
				mcSlider = mc.attachMovie(skin.slider, "mcSlider", mc.getNextHighestDepth(), {_y: mcTrack._y});
			}
			
		}
		
		initSize = {};
			initSize.w = mc._width;
			initSize.h = mc._height;
		
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
		
		var d:Number = 10;
		if(easing) d = 35;
		
		difference = d + (Math.ceil(getMaskedHeight() / mcMask._height)*2);
		delete d;
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
		
		if(getMaskedHeight() <= mcMask._height) {
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
		doScrollUp(mcMask, mcMasked, difference, mcSlider, mcTrack, easing, easingSpeed);
		interval = setInterval(Delegate.create(this, doScrollUp, mcMask, mcMasked, difference, mcSlider, mcTrack, easing, easingSpeed), 50);
	}

	private function doScrollUp(mcMask:MovieClip, mcMasked:MovieClip, difference:Number, mcSlider:MovieClip, mcTrack:MovieClip, easing:Boolean, easingSpeed:Number):Void{
		var calc:Number;
		if(Math.abs(mcMasked._y) > difference) {
			calc = mcMasked._y + difference;
			
			if(easing){
				TweenLite.to(mcMasked, easingSpeed, {_y:calc, overwrite:false});
			} else {
				mcMasked._y = calc;
			}
		} else {
			calc = 0;
			
			if(easing){
				TweenLite.to(mcMasked, easingSpeed, {_y:calc, overwrite:false});
			} else {
				mcMasked._y = calc;
			}
		}
		positionSlider(mcMask, mcMasked, mcSlider, mcTrack, easing, easingSpeed);
	}
	
	/**
		Scroll the content to DOWN.
		
		@return Return none.
	*/
	public function scrollDown():Void{
		pressArrow(mcArrowDown);
		doScrollDown(mcMask, mcMasked, difference, mcSlider, mcTrack, easing, easingSpeed);
		interval = setInterval(Delegate.create(this, doScrollDown, mcMask, mcMasked, difference, mcSlider, mcTrack, easing, easingSpeed), 50);
	}
	
	private function doScrollDown(mcMask:MovieClip, mcMasked:MovieClip, difference:Number, mcSlider:MovieClip, mcTrack:MovieClip, easing:Boolean, easingSpeed:Number):Void{
		var calc:Number;
		if(Math.abs(mcMasked._y) < getMaskedHeight() - mcMask._height - difference) {
			calc = mcMasked._y - difference;
			
			if(easing){
				TweenLite.to(mcMasked, easingSpeed, {_y:calc, overwrite:false});
			} else {
				mcMasked._y = calc;
			}
		} else {
			calc = -(getMaskedHeight() - mcMask._height);
			
			if(easing){
				TweenLite.to(mcMasked, easingSpeed, {_y:calc, overwrite:false});
			} else {
				mcMasked._y = calc;
			}
		}
		positionSlider(mcMask, mcMasked, mcSlider, mcTrack, easing, easingSpeed);
	}
	
	private function positionSlider(mcMask:MovieClip, mcMasked:MovieClip, mcSlider:MovieClip, mcTrack:MovieClip, easing:Boolean, easingSpeed:Number):Void{
		var track:Number = mcTrack._height - mcSlider._height;
		var h:Number = getMaskedHeight() - mcMask._height;
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
		interval = setInterval(Delegate.create(mc, doScollSlider, mcMask, mcMasked, getMaskedHeight(), mcSlider, mcTrack, easing, easingSpeed), 50);
	}
	
	private function doScollSlider(mcMask:MovieClip, mcMasked:MovieClip, getMaskedHeightResult:Number, mcSlider:MovieClip, mcTrack:MovieClip, easing:Boolean, easingSpeed:Number):Void{
		var calc:Number = -((((mcSlider._y - mcTrack._y) * (getMaskedHeightResult - mcMask._height)) / (mcTrack._height - mcSlider._height))-1);
		if(Math.abs(calc) < (difference/2)) {
			calc = 0;
		}
		if(mcSlider._y == Math.floor(sliderBottomLimit)){
			calc = -(getMaskedHeightResult - mcMask._height);
		}
		
		if(easing){
			TweenLite.to(mcMasked, easingSpeed, {_y:Math.round(calc), overwrite:false});
		} else {
			mcMasked._y = Math.round(calc); // without easing
		}
		
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
			mcSlider._y = mc._ymouse; // without easing
		else 
			mcSlider._y = sliderBottomLimit; // without easing
		doScollSlider(mcMask, mcMasked, getMaskedHeight(), mcSlider, mcTrack, easing, easingSpeed);
	}
	//}
	
	
	private function getMaskedHeight():Number{
		return (mcMaskedHeight) ? mcMaskedHeight : mcMasked._height;
	}
	
	/*
	* Wheel Stuff
	*/
	//{
	private function onMouseWheel(delta:Number, target:String):Void{
		if((mcMask._xmouse >=0 && mcMask._xmouse <= mcMask._width && mcMask._ymouse >=0 && mcMask._ymouse <= mcMask._height)  // over mask
			|| 
			(mc._xmouse >=0 && mc._xmouse <= mc._width && mc._ymouse >=0 && mc._ymouse <= mc._height) // over scroll
		  ){

			if(delta <0) doScrollDown(mcMask, mcMasked, difference, mcSlider, mcTrack, easing, easingSpeed);
			else doScrollUp(mcMask, mcMasked, difference, mcSlider, mcTrack, easing, easingSpeed);
		}
	}
	//}
}
