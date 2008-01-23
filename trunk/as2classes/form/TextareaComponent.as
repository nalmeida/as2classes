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
import as2classes.form.TextfieldUtil;
import org.casaframework.mouse.EventMouse;

/**
	TextareaComponent. An useful component to use as an extended Textfield.
	
	@author Nicholas Almeida
	@version 5/7/2007
	@since Flash Player 8
	@example
		<code>
			mcTest = new TextareaComponent(mcTest);
			mcTestBig = new TextareaComponent(mcTestBig);
			mcTestSmall = new TextareaComponent(mcTestSmall);

			mcTest.init({
				title: "Text",
				restrict: "alpha",
				required: true,
				title: "Textarea default"
			});

			mcTestBig.init({
				type:"dynamic",
				textColor:0xFF0000,
				title: "Big Textarea"
			});
			mcTestSmall.init({
				htmlText: true,
				title: "Small Textarea"
			});
			
			mcTestSmall.setText("<b>asd</b>");

			mcTestBig.setText("Maecenas nulla lorem, rhoncus ac, blandit vel, tempus id, felis. Quisque arcu. Quisque tristique, mi nec rhoncus imperdiet, urna nisi sagittis tortor, a interdum nulla lectus eu sapien. Nullam vestibulum blandit massa. Morbi nec nisl. Ut at nibh at eros placerat venenatis. Curabitur pretium molestie nisl. Phasellus ultricies dui in augue. Duis at dolor. Etiam congue tellus a ipsum. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec pellentesque pulvinar urna. Praesent in tellus quis nibh sollicitudin lobortis.\n\nIn auctor. Praesent non felis ac turpis lobortis aliquam. Nam bibendum eleifend elit. Phasellus ac lorem. Suspendisse facilisis adipiscing tellus. Pellentesque turpis elit, auctor eu, lacinia sed, congue euismod, ligula. Curabitur porta nibh dapibus tortor. Sed eu nibh. Fusce vel turpis. Nam cursus.\n\nMorbi sem neque, laoreet ut, nonummy ut, pulvinar id, magna. Nulla facilisi. Nunc sed libero. In condimentum dolor et lacus. Integer a nunc. Curabitur eu felis. Fusce lacinia nunc. Morbi tellus nisl, tempus non, feugiat ac, tempor sed, libero. Curabitur dictum. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec condimentum posuere nisi. Sed lacinia, justo id dignissim varius, lorem ante tristique sem, sit amet suscipit diam felis vel pede. Mauris tincidunt risus sed dolor. Quisque rutrum lobortis leo.\n\nFusce ullamcorper varius quam. In vitae libero ut sem feugiat pulvinar. Sed ligula. Proin dolor. Integer semper. Integer sit amet diam nec eros imperdiet molestie. Maecenas vulputate, enim id egestas nonummy, odio tellus sodales augue, non fermentum leo leo eu leo. Aenean blandit sem et neque. Aliquam erat volutpat. Etiam sollicitudin. Phasellus nec mauris. Pellentesque sed metus at lorem porttitor volutpat. Nulla posuere tincidunt mi. In placerat justo id arcu dignissim varius. Morbi quam quam, pretium ac, mattis a, molestie non, odio. Sed eget felis. Quisque pretium nunc et magna. Nulla lobortis felis sit amet ante lacinia accumsan. Donec auctor mauris vel risus.\n\nAliquam volutpat lectus vitae purus. Fusce purus eros, mollis non, iaculis vitae, congue sed, ante. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Duis neque elit, tincidunt in, faucibus aliquam, bibendum vel, odio. Aliquam erat volutpat. Sed luctus leo ac neque. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Pellentesque tristique nunc cursus lacus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Duis nonummy nibh condimentum orci. Mauris vulputate lorem.\n\nSuspendisse iaculis sodales metus. Vestibulum tincidunt urna non leo. Morbi elit. Maecenas quis sapien. Aliquam bibendum, arcu nec congue posuere, nulla eros sagittis nulla, sit amet tincidunt justo tellus ac lectus. Fusce et sem. Nullam nonummy dignissim ante. Donec nulla arcu, accumsan et, sagittis ac, euismod blandit, lacus. Phasellus varius leo. Praesent viverra pede a tellus. Integer in enim. Aliquam venenatis. Etiam nec nisl. Aenean convallis mi eget sapien. \n -- MEIO\nMaecenas nulla lorem, rhoncus ac, blandit vel, tempus id, felis. Quisque arcu. Quisque tristique, mi nec rhoncus imperdiet, urna nisi sagittis tortor, a interdum nulla lectus eu sapien. Nullam vestibulum blandit massa. Morbi nec nisl. Ut at nibh at eros placerat venenatis. Curabitur pretium molestie nisl. Phasellus ultricies dui in augue. Duis at dolor. Etiam congue tellus a ipsum. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec pellentesque pulvinar urna. Praesent in tellus quis nibh sollicitudin lobortis.\n\nIn auctor. Praesent non felis ac turpis lobortis aliquam. Nam bibendum eleifend elit. Phasellus ac lorem. Suspendisse facilisis adipiscing tellus. Pellentesque turpis elit, auctor eu, lacinia sed, congue euismod, ligula. Curabitur porta nibh dapibus tortor. Sed eu nibh. Fusce vel turpis. Nam cursus.\n\nMorbi sem neque, laoreet ut, nonummy ut, pulvinar id, magna. Nulla facilisi. Nunc sed libero. In condimentum dolor et lacus. Integer a nunc. Curabitur eu felis. Fusce lacinia nunc. Morbi tellus nisl, tempus non, feugiat ac, tempor sed, libero. Curabitur dictum. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec condimentum posuere nisi. Sed lacinia, justo id dignissim varius, lorem ante tristique sem, sit amet suscipit diam felis vel pede. Mauris tincidunt risus sed dolor. Quisque rutrum lobortis leo.\n\nFusce ullamcorper varius quam. In vitae libero ut sem feugiat pulvinar. Sed ligula. Proin dolor. Integer semper. Integer sit amet diam nec eros imperdiet molestie. Maecenas vulputate, enim id egestas nonummy, odio tellus sodales augue, non fermentum leo leo eu leo. Aenean blandit sem et neque. Aliquam erat volutpat. Etiam sollicitudin. Phasellus nec mauris. Pellentesque sed metus at lorem porttitor volutpat. Nulla posuere tincidunt mi. In placerat justo id arcu dignissim varius. Morbi quam quam, pretium ac, mattis a, molestie non, odio. Sed eget felis. Quisque pretium nunc et magna. Nulla lobortis felis sit amet ante lacinia accumsan. Donec auctor mauris vel risus.\n\nAliquam volutpat lectus vitae purus. Fusce purus eros, mollis non, iaculis vitae, congue sed, ante. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Duis neque elit, tincidunt in, faucibus aliquam, bibendum vel, odio. Aliquam erat volutpat. Sed luctus leo ac neque. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Pellentesque tristique nunc cursus lacus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Duis nonummy nibh condimentum orci. Mauris vulputate lorem.\n\nSuspendisse iaculis sodales metus. Vestibulum tincidunt urna non leo. Morbi elit. Maecenas quis sapien. Aliquam bibendum, arcu nec congue posuere, nulla eros sagittis nulla, sit amet tincidunt justo tellus ac lectus. Fusce et sem. Nullam nonummy dignissim ante. Donec nulla arcu, accumsan et, sagittis ac, euismod blandit, lacus. Phasellus varius leo. Praesent viverra pede a tellus. Integer in enim. Aliquam venenatis. Etiam nec nisl. Aenean convallis mi eget sapien. \n -- FIM");
		</code>
*/

class as2classes.form.TextareaComponent extends MovieClip{
	
	public var mc:MovieClip;
	private var mcBg:MovieClip;
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
	public var alphaWhenScrollDisabled:Number;
	
	private var mouseInstance:EventMouse;
	
	public var _type:String;
	
	/**
		Textarea Component constructor.
		
		@param $mc:MovieClip - Movieclip to be used as the component.
		@return Return none.
	*/
	function TextareaComponent($mc:MovieClip, objectSetup:Object){
		this._type = "textarea";
		
		mc = $mc || this;
		mc.isFormField = true;
		textField = mc.fld_text;
		mcBg = mc.mcBg;
		
		mcScrollBar = mc.mcScrollBar;
		mcArrowUp = mcScrollBar.mcArrowUp;
		mcArrowDown = mcScrollBar.mcArrowDown;
		mcTrack = mcScrollBar.mcTrack;
		mcSlider = mcScrollBar.mcSlider;
		
		initSize = {};
			initSize.w = mc._width;
			initSize.h = mc._height;
			
		if(objectSetup) init(objectSetup);
	}
	
	/**
		Initialize the TextareaComponent Component.
		
		@param obj:Object - Object notation to get the real parameters.
		@param obj.title:String - Title used to validade the form.
		@param obj.tabIndex:Number or Booblean - Number represents the tabIndex value. To disable the tabIndex, set it to false. Default value 1.
		@param obj.required:Boolean - Used on form validation to set the field as required.
		
		@param obj.restrict::String - Restrict the characters of a Textfield. For the valid values, check TextfieldUtil.aplyRestriction method.
		@param obj.type:String - The Textfield type. Valid values: "input", "dynamic" or "password". Default: "input".
		@param obj.maxChars:Number - The maximum number of characters.
		@param obj.minChars:Number - The minumum number of characters.
		@param obj.text:String - The Textfield text.
		@param obj.initText:Number - If you need a initial value for the Textfield, set it here. When the user select the Textfield, the Textfield text is set to "".
		@param obj.htmlText:Boolean - Enables htmlText for TextField.
		@param obj.textColor:Color - The text color.
		@param obj.border:Boolean - If you need disables the textfield border, set it to false. Default true.
		@param obj.alphaWhenScrollDisabled:Number - The value when scroll is disabled or not necessary. Default 50.
		@return Return none.
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
		
		if(htmlText === true && obj.textColor) trace("WARNING on TextField: " + mc + ". If you are using htmlText, the textColor property doesn't work.");
		
		
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
		alphaWhenScrollDisabled = obj.alphaWhenScrollDisabled || 50;
		
		
		sliderBottomLimit = (mcTrack._y + mcTrack._height - mcSlider._height);
		
		required = (obj.required == undefined) ? false  : obj.required;

		checkIfNeedScroll();
		
		// Tab
		if(obj.tabIndex === false){
			mc.tabEnabled = false;
			mc.tabChildren = false;
			textField.tabEnabled = false;
		} else {
			mc.tabEnabled = false;
			mc.tabChildren = true;
			textField.tabEnabled = true;
			textField.tabIndex = obj.tabIndex || 1;
		}
		
		
		// Events
		
		mcArrowUp.onPress = Delegate.create(this, scrollUp, this);
		mcArrowUp.onRelease =
		mcArrowUp.onReleaseOutside = Delegate.create(this, releaseArrow, mcArrowUp);
		
		mcArrowDown.onPress = Delegate.create(this, scrollDown, this);
		mcArrowDown.onRelease =
		mcArrowDown.onReleaseOutside = Delegate.create(this, releaseArrow, mcArrowDown);
		
		mcSlider.onPress = Delegate.create(this, slideScroll, this);
		mcSlider.onMouseUp = Delegate.create(this, releaseSlider);
		
		mcTrack.onPress = Delegate.create(this, pressTrack, this);
		
		mcArrowUp.useHandCursor = mcArrowDown.useHandCursor = mcSlider.useHandCursor = mcTrack.useHandCursor = false;
		
		textField.onChanged = Delegate.create(this, onChange);
		
		textField.mouseWheelEnabled = false;
		

		mouseInstance = EventMouse.getInstance();
		mouseInstance.addEventObserver(this, EventMouse.EVENT_MOUSE_WHEEL);

		lineHeight = getLinheHeight();
		
		clearInterval(interval);
		minSliderHeight = 24;
	}
	
	/**
		Set the size of Textarea Component.
		
		@param width:Number - Width.
		@param height:Number - Height.
		@return Return none.
	*/
	public function setSize(width:Number, height:Number):Void{
		initSize.w = width;
		initSize.h = height;
		
		ajustSize();
	}
	
	/**
		Ajust the Scroll size avoiding the Movieclip deformation.
		
		@return Return none.
	*/
	public function ajustSize():Void{
		mc._xscale = mc._yscale = 100;
		
		mcBg._width =
		textField.textWidth =
		textField._width = initSize.w - mcScrollBar._width + 1;
		
		mcBg._height =
		textField.textHeight =
		textField._height = initSize.h;
		
		mcScrollBar._x = textField._width + 1;
		mcArrowDown._y = textField._height - mcArrowDown._height;
		
		mcTrack._y = mcArrowUp._height - 1;
		mcTrack._height = initSize.h - mcArrowDown._height - mcArrowUp._height + 2;

		onChange();
	}
	
	/**
		Enable Textarea.
		
		@return Return none
	*/
	public function enable():Void{
		TextfieldUtil.aplyRestriction(textField, restrict);
		textField.selectable = true;
		//enableScroll();
		textField.onChanged = Delegate.create(this, onChange);
		setInitText();
		mc._alpha = 100;
	}
	
	/**
		Enable disable.
		
		@return Return none
	*/
	public function disable():Void{
		TextfieldUtil.aplyRestriction(textField, "disable");
		textField.selectable = false;
		//disableScroll();
		textField.onChanged = function(){};
		textField.onSetFocus = function(){};
		textField.onKillFocus = function(){};
		if(mc._alpha != 50) mc._alpha = 50;
	}
	
	/**
		Set the maximum number of characters to Textarea.
		
		@param n:Number - Maximum number of characters.
		@return Return none.
	*/
	public function setMaxChars(n:Number):Void{
		textField.maxChars = maxChars = n;
	}
	
	/**
		Return the maximum number of Textarea characters.
		
		@return Return the maximum number of Textarea.
	*/
	public function getMaxChars():Number{
		return maxChars;
	}
	
	/**
		Set the minimum number of characters to Textarea.
		
		@param n:Number - Maximum number of characters.
		@return Return none.
	*/
	public function setMinChars(n:Number):Void{
		minChars = n;
	}
	
	/**
		Return the minimum number of Textarea characters.
		
		@return Return the minimum number of Textarea.
	*/
	public function getMinChars():Number{
		return minChars;
	}
	
	/**
		Set the text for Textarea.
		
		@param txt - The text.
		@return Return none.
	*/
	public function setText(txt):Void{
		if(htmlText) textField.htmlText = value = txt;
		else textField.text = value = txt;
		ajustSize();
	}
	
	/**
		Set the initial text for Textarea.
		
		@param txt - The text.
		@return Return none.
	*/
	public function setInitText(txt:String):Void{
		if(txt) {
			if(htmlText) textField.htmlText = initText = txt;
			else textField.htmlText = initText = txt;
		}
		textField.onSetFocus = Delegate.create(this, clearField);
		textField.onKillFocus = Delegate.create(this, checkIfIsEmpty);
	}
	
	/**
		Get the current text of Textarea.
		
		@return Return none.
	*/
	public function getText():String{
		if (value === "" || value === initText) value = "";
		else {
			if (htmlText) {
				value = textField.htmlText;
			} else {
				value = textField.text;
			}
		}
		return value;
	}
	
	/**
		Scroll the content to UP.
		
		@param theClass:TextareaComponent - The class.
		@return Return none.
	*/
	public function scrollUp(theClass:TextareaComponent):Void{
		theClass.pressArrow(theClass.mcArrowUp);
		theClass.doScrollUp();
		theClass.interval = setInterval(Delegate.create(theClass, doScrollUp, theClass), 80);
	}
	
	/**
		Scroll the content to DOWN.
		
		@param theClass:TextareaComponent - The class.
		@return Return none.
	*/
	public function scrollDown(theClass:TextareaComponent):Void{
		theClass.pressArrow(theClass.mcArrowDown);
		theClass.doScrollDown();
		theClass.interval = setInterval(Delegate.create(theClass, doScrollDown, theClass), 80);
	}
	
	/**
		Check if the scroll is needed or not. If not, disables the scroll.
		
		@return Return none.
	*/
	public function checkIfNeedScroll():Void{
		if(textField.textHeight - textField._height <=0) disableScroll();
		else enableScroll();
	}
	
	/**
		Disables the scroll
		
		@return Return none.
	*/
	public function disableScroll():Void{
		for (var i in mcScrollBar) {
			mcScrollBar[i].enabled = false;
		}
		mcSlider._visible = false;
		mcScrollBar._alpha = alphaWhenScrollDisabled;
	}
	
	/**
		Enables the scroll
		
		@return Return none.
	*/
	public function enableScroll():Void{
		for (var i in mcScrollBar) {
			mcScrollBar[i].enabled = true;
		}
		mcSlider._visible = true;
		mcScrollBar._alpha = 100;
	}
	
	/**
		Set Textfield and value to "".
		
		@return Return none
	*/
	public function reset():Void{
		if(htmlText) textField.htmlText = value = "";
		else textField.text = value = "";
		resetScroll();
	}
	
	/**
		Reposition scroll elements to initial state.
		
		@return Return none
	*/
	public function resetScroll():Void{
		textField.scroll = 0;
		positionSlider();
	}
	
	
	// Private methods
	
	private function releaseSlider():Void{
		mcSlider.stopDrag();
		clearInterval(interval);
	}
	
	private function slideScroll(theClass:TextareaComponent):Void{
		theClass.mcSlider.startDrag(false,0,theClass.mcTrack._y+1,0,theClass.sliderBottomLimit);
		clearInterval(theClass.interval);
		
		theClass.interval = setInterval(Delegate.create(theClass, doScollSlider, theClass), 50);
	}
	
	private function doScollSlider(theClass:TextareaComponent):Void{
		var sobra:Number = theClass.textField.textHeight - theClass.textField._height;
		if(sobra <= theClass.textField._height) sobra = theClass.textField._height;

		var altTrack:Number = theClass.mcTrack._height - theClass.mcSlider._height;
		// ERA:  theClass.mcSlider._y - theClass.mcSlider._height + theClass.mcArrowUp._height
		var posSlider:Number = theClass.mcSlider._y - theClass.mcArrowUp._height;

		var calc:Number = (sobra * posSlider) / altTrack;
		var final:Number = Math.abs(calc / theClass.lineHeight);
		
		if(final > theClass.textField.maxscroll) final = theClass.textField.maxscroll;
		theClass.textField.scroll = Math.ceil(final);
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
			if(htmlText) textField.htmlText = initText || "";
			else textField.text = initText || "";
			isEmpty = true;
			value = "";
		} else {
			isEmpty = false;
			if(htmlText) value = textField.htmlText;
			else value = textField.text;
		}
	}
	
	private function pressTrack(theClass:TextareaComponent):Void{
		
		if(theClass.mc._ymouse <= theClass.sliderBottomLimit)
			theClass.mcSlider._y = theClass.mc._ymouse;
		else
			theClass.mcSlider._y = theClass.sliderBottomLimit;
			
		theClass.doScollSlider(theClass);
	}
	
	private function pressArrow(arrow:MovieClip):Void{
		arrow.gotoAndStop("release");
	}
	
	private function releaseArrow(arrow:MovieClip):Void{
		arrow.gotoAndStop("out");
		clearInterval(interval);
	}
	
	
	
	private function doScrollDown(theClass:TextareaComponent):Void{
		theClass.textField.scroll++;
		theClass.positionSlider();
	}
	
	private function doScrollUp(theClass:TextareaComponent):Void{
		theClass.textField.scroll--;
		theClass.positionSlider();
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
	
	private function onMouseWheel(delta:Number, target:String):Void{
		if(mc._xmouse >=0 && mc._xmouse <= mc._width && mc._ymouse >=0 && mc._ymouse <= mc._height){
			if(delta <0) doScrollDown(this);
			else doScrollUp(this);
			positionSlider(this);
		}
	}
	
}