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

/**
	CheckboxComponent. A simple and lightweight CheckboxComponent Component.
	
	@author Nicholas Almeida
	@version 03/07/07
	@since Flash Player 8
	@example
		<code>
			var mcTest:CheckboxComponent = new CheckboxComponent(mcTest);

			mcTest.init({
				title:"Check 1"
				label:"Checkbox Component label test", 
				width: 100, 
				align:"left", 
				value:"123"
			});

			mcTest.onChanged = function(arr:Array){
				trace("MovieClip: " + arr[0] + " changed! Selected: " +arr[1]);
			}
			
			btSwap.onRelease = function(){
				mcTest.swapSelected();
			}

			btEnable.onRelease = function(){
				mcTest.enable();
			}
			btDisable.onRelease = function(){
				mcTest.disable();
			}
		</code>
*/

class as2classes.form.CheckboxComponent extends MovieClip{
	
	private var mc:MovieClip;
	private var mcState:MovieClip;
	
	private var label:String;
	private var value:String;
	private var selected:Boolean;
	private var enabled:Boolean;
	
	public var required:Boolean;
	public var title:Boolean;
	
	public var onChanged:Function;
	
	public var _type:String;
	
	/**
		Checkbox Component constructor.
		
		@param $mc:MovieClip - Movieclip to be used as the component.
		@return Return none.
	*/
	function CheckboxComponent($mc:MovieClip, objectSetup:Object){
		this._type = "checkbox";
		
		mc = $mc || this;
		mc.isFormField = true;
		mcState = mc.mcCheckBoxState;
		mc.useHandCursor = false;
		
		mc.onRelease =
		mc.onReleaseOutside = Delegate.create(this, swapSelected, true);
		
		required = false;
		
		if(objectSetup) init(objectSetup);
	}
	
	/**
		Initialize the CheckboxComponent Component.
		
		@param obj:Object - Object notation to get the real parameters.
		@param obj.title:String - Title used to validade the form.
		@param obj.tabIndex:Number or Booblean - Number represents the tabIndex value. To disable the tabIndex, set it to false. Default value 1.
		@param obj.required:Boolean - Used on form validation to set the field as required.
		
		@param obj.selected:Booblean - If you need the Checkbox starts as selected. Default false.
		@param obj.label:String - The text of Radiobutton.
		@param obj.value:String - The value of Radiobutton.
		@param obj.align:String - The align of textField. Valid values "left" or "right". Default "right".
		@param obj.width:Number - Combobox width. Default is undefined and it make the textField be autoSize = true.
		@return Return none.
	*/
	public function init(obj:Object):Void{
		// Label
		if(!obj.label) trace("ERROR on CheckBox: " + mc + " parameter \"label\" not defined.");
		mc.fld_label.text = label = obj.label;
		
		// Title
		if(!obj.title) trace("WARNING on CheckBox: " + mc + " parameter \"title\" not defined.");
		title = obj.title || mc._name;
		
		// Value
		if(!obj.value) trace("ERROR on CheckBox: " + mc + " parameter \"value\" not defined.");
		value = obj.value.toString() || mc._name;
		
			// Width
			if(obj.width){
				mc.fld_label.wordWrap = true;
				mc.fld_label.multiline = true;
				mc.fld_label._width = obj.width;
			}
			mc.fld_label.autoSize = true;
			
			// Align
			if(obj.align == "left"){
				var format:TextFormat = new TextFormat();
					format.align = "right";
	
				mc.fld_label._x = -(mc.fld_label._width+2);
				mc.fld_label.setTextFormat(format);
				delete format;
			}

		if(obj.required != undefined) required = obj.required;
		
		// Selection
		setSelected(obj.selected);
		
		// Tab
		mc.tabEnabled = true;
		mc.tabIndex = obj.tabIndex || 1;
		
		if(obj.tabIndex === false){
			mc.tabEnabled = false;
		} else {
			mc.tabEnabled = true;
			mc.tabIndex = obj.tabIndex || 1;
		}
	}
	
	/**
		If the CheckBox is selected, changes to unselected, else to selected.
		
		@return Return none.
	*/
	public function swapSelected():Void{
		if(this.selected) setSelected(false);
		else setSelected(true);
	}
	
	/**
		Set the CheckboxComponent to true or false.
		
		@param val:Boolean - True or false.
		@return Return none.
	*/
	public function setSelected(val:Boolean):Void{
		if(val){ // Select = TRUE
			mcState.gotoAndStop("selected");
			this.selected = true;
		} else { // Select = FALSE
			mcState.gotoAndStop("default");
			this.selected = false;
		}
		if(this.onChanged) this.onChanged([mc, getSelected()]);
	}
	
	/**
		Get the MovieClip and the value of selected item at group
		
		@return Return Boolean.
	*/
	public function getSelected():Boolean{
		return selected;
	}
	
	/**
		Enable the CheckboxComponent.
		
		@param avoidAlpha:Boolean - If you don't want to change the _alpha of Movieclip use true.
		@return Return none.
	*/
	public function enable(avoidAlpha:Boolean):Void{
		mc.enabled = true;
		if(avoidAlpha !== false) mc._alpha = 100;
	}
	
	/**
		Disable the CheckboxComponent.
		
		@param avoidAlpha:Boolean - If you don't want to change the _alpha of Movieclip use true.
		@return Return none.
	*/
	public function disable(avoidAlpha:Boolean):Void{
		mc.enabled = false;
		if(avoidAlpha !== false) mc._alpha = 50;
	}
	
}