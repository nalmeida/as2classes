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

/**
	TextfieldComponent. An extended and useful Textfield Component.
	
	@author Nicholas Almeida
	@version 5/7/2007
	@since Flash Player 8
	@example
		<code>
			var mcTest:TextfieldComponent = new TextfieldComponent(mcTest);
			var mcTest2:TextfieldComponent = new TextfieldComponent(mcTest2);
			
			mcTest.init({
				type:"password",
				maxChars:5,
				initText:"Your password goes here",
				title: "Your password"
			});

			mcTest2.init({
				maxChars:5,
				initText:"Zip code goes here",
				restrict:"num",
				title: "Zip Code",
				align: "center"
			});

			bt.onRelease = function(){
				trace("mcTest value: " + mcTeste.value + " -- isEmpty = "   + mcTest.isEmpty);
			}
		</code>
*/

class as2classes.form.TextfieldComponent extends MovieClip{
	
	public var mc:MovieClip;
	public var mcBg:MovieClip;
	public var textField:TextField;
	public var onSetFocus:Function;
	public var onKillFocus:Function;
	public var onChanged:Function;
	
	private var initSize:Object;
	private var initText:String;
	
	public var required:Boolean;
	public var maxChars:Number;
	public var minChars:Number;
	public var value:String;
	public var title:String;
	public var isEmpty:Boolean;
	public var type:String;
	public var restrict:String;
	public var border:Boolean;
	public var equal:TextfieldComponent;
	public var customErrorMessage:String;
	
	private var align:String;
	private var format:TextFormat;
	
	public var _type:String;
	
	/**
		Textfield Component constructor.
		
		@param $mc:MovieClip - Movieclip to be used as the component.
		@return Return none.
	*/
		function TextfieldComponent($mc:MovieClip, objectSetup:Object){
		this._type = "textfield";
		
		mc = $mc || this;
		mc.isFormField = true;
		textField = mc.fld_text;
		mcBg = mc.mcBg;
		
		initSize = {};
			initSize.w = mc._width;
			initSize.h = mc._height;
			
		border = true;
		
		if(objectSetup) init(objectSetup);
	}
	
	/**
		Initialize the CheckboxComponent Component.
		
		@param obj:Object - Object notation to get the real parameters.
		@param obj.title:String - Title used to validade the form.
		@param obj.tabIndex:Number or Booblean - Number represents the tabIndex value. To disable the tabIndex, set it to false. Default value 1.
		@param obj.required:Boolean - Used at form validation to set the field as required.
		
		@param obj.restrict::String - Restrict the characters of a Textfield. For the valid values, check TextfieldUtil.aplyRestriction method.
		@param obj.type:String - The Textfield type. Valid values: "input", "dynamic" or "password". Default: "input".
		@param obj.maxChars:Number - The maximum number of characters.
		@param obj.minChars:Number - The minumum number of characters.
		@param obj.text:String - The Textfield text.
		@param obj.initText:Number - If you need a initial value for the Textfield, set it here. When the user select the Textfield, the Textfield text is set to "".
		@param obj.align:String - The align of textField. Valid values "left", "center" or "right". Default "left".
		@param obj.equal:TextfieldComponent - The TextfieldComponent that must have the same value.
		@param obj.customErrorMessage:String - Custom message to use with FormValidator class .
		@return Return none.
	*/
	public function init(obj:Object):Void{
		
		// Title
		if(!obj.title) trace("WARNING on TextField: " + mc + " parameter \"title\" not defined.");
		title = obj.title || mc._name;
		
		type = obj.type || "input";
		
		if(type == "password" && !obj.initText)
			textField.password = true;
		else
			textField.type = type;

		border = (obj.border === false ? false : true);
		if(border == false){
			textField.border = false;
		}
			
		if(obj.restrict) {
			restrict = obj.restrict;
			TextfieldUtil.aplyRestriction(textField, restrict);
		}
		
		if(obj.equal) {
			equal = obj.equal;
		}
		
		
		required = (obj.required === true) ? true : false;
		
		if(obj.maxChars) setMaxChars(obj.maxChars);
		if(obj.minChars) setMinChars(obj.minChars);
		if(obj.text) {
			setText(obj.text);
			isEmpty = false;
		}
		
		//Apply custom functions
		onSetFocus = onSetFocus || (obj.onSetFocus || null);
		onKillFocus = onKillFocus || (obj.onKillFocus || null);

		if(obj.initText && (type == "input" || type == "password")) {
			setInitText(obj.initText);
			value = "";
			isEmpty = true;
		}else{
			textField.onSetFocus = onSetFocus;
			textField.onKillFocus = onKillFocus;
		}
		
		// Align
		align = (obj.align) ? obj.align : "left";
		setAlign(align);
		
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
		
		ajustSize();
		
		if(obj.customErrorMessage) customErrorMessage = obj.customErrorMessage;
	}
	
	/**
		Set the size of Textfield Component.
		
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
		
		mcBg._width = initSize.w;
		
		textField._width =
		textField.textWidth = initSize.w - (textField._x*2);
		
		textField._height =
		textField.textHeight =
		mcBg._height = initSize.h;
	}
	
	/**
		Set the maximum number of characters to Textfield.
		
		@param n:Number - Maximum number of characters.
		@return Return none.
	*/
	public function setMaxChars(n:Number):Void{
		textField.maxChars = maxChars = n;
	}
	
	/**
		Return the maximum number of Textfield characters.
		
		@return Return the maximum number of Textfield.
	*/
	public function getMaxChars():Number{
		return maxChars;
	}
	
	/**
		Set the minimum number of characters to Textfield.
		
		@param n:Number - Maximum number of characters.
		@return Return none.
	*/
	public function setMinChars(n:Number):Void{
		minChars = n;
	}
	
	/**
		Return the minimum number of Textfield characters.
		
		@return Return the maximum number of Textfield.
	*/
	public function getMinChars():Number{
		return minChars;
	}
	
	/**
		Set the text for Textfield.
		
		@param txt - The text.
		@return Return none.
	*/
	public function setText(txt):Void{
		textField.text = value = txt;
	}
	
	/**
		Set the initial text for Textfield.
		
		@param txt - The text.
		@return Return none.
	*/
	public function setInitText(txt:String):Void{
		if(txt) textField.text = initText = txt;
		textField.onSetFocus = Delegate.create(this, function(){
			if(this.onSetFocus)
				this.onSetFocus();
			this.clearField();
		});
		
		textField.onChanged = Delegate.create(this, function(){
			this.checkIfIsEmpty(true);
		});
		
		textField.onKillFocus = Delegate.create(this, function(){
			if(this.onKillFocus)
				this.onKillFocus();
			this.checkIfIsEmpty();
		});
	}
	
	/**
		Get the current text of Textfield.
		
		@return Return none.
	*/
	public function getText():String{
		value = textField.text;
		if(value === "" || value === initText) value = "";
		return value;
	}
	
	/**
		Enable Textfield.
		
		@return Return none
	*/
	public function enable():Void{
		TextfieldUtil.aplyRestriction(textField, restrict);
		textField.selectable = true;
		setInitText();
		mc._alpha = 100;
	}
	
	/**
		Disable Textfield.
		
		@return Return none
	*/
	public function disable():Void{
		TextfieldUtil.aplyRestriction(textField, "disable");
		textField.onSetFocus = function(){};
		textField.onKillFocus = function(){};
		textField.selectable = false;
		if(mc._alpha != 50) mc._alpha = 50;
	}
	
	/**
		Set Textfield text align.
		
		@param textAlignOption:String - Align option. Valid values: "right", "center" or "left".
		@return Return none
	*/
	public function setAlign(textAlignOption:String){
		format = new TextFormat();
		align = format.align = textAlignOption;
		textField.setTextFormat(format);
	}
	
	/**
		Set Textfield and value to "".
		
		@return Return none
	*/
	public function reset():Void{
		textField.text = value = "";
	}
	
	
	// Private methods
	private function clearField():Void{
		if(getText() == initText || getText().length == 0 || getText() == ""){
			if(type == "password") textField.password = true;
			textField.text = "";
			isEmpty = true;
			value = "";
		}
		setAlign(align);
	}
	
	private function checkIfIsEmpty(onchange:Boolean):Void{
		if(getText() == "") {
			if(type == "password") textField.password = false;
			if(!onchange)
				textField.text = initText || "";
			isEmpty = true;
			value = "";
		} else {
			isEmpty = false;
			value = textField.text;
		}
		setAlign(align);
	}
	
	public function addHandler(type:String,fnc:Function):Void{
		switch(type){
			case "onSetFocus":
				onSetFocus = fnc;
				break;
			case "onKillFocus":
				onKillFocus = fnc;
				break;
			default:
				textField[type] = fnc;
				return;
				break;
		}
		switch(type){
			case "onSetFocus":
			case "onKillFocus":
				if(initText){
					setInitText(initText);
				}else{
					textField[type] = fnc;
				}
				break;
		}
	}

}