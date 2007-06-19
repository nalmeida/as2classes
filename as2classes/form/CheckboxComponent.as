﻿/**
* CheckBox Component
* @author Nicholas Almeida
* @version 0.1
*/

import as2classes.util.Delegate;

class as2classes.form.CheckboxComponent extends MovieClip{
	
	private var mc:MovieClip;
	private var mcState:MovieClip;
	
	private var label:String;
	private var value:String;
	private var selected:Boolean;
	private var enabled:Boolean;
	
	public var required:Boolean;
	public var title:Boolean;

	function CheckboxComponent(){
		mc = this;
		mc.isFormField = true;
		mcState = mc.mcCheckBoxState;
		mc.useHandCursor = false;
		
		mc.onRelease =
		mc.onReleaseOutside = Delegate.create(this, swapSelected, true);
		
		required = false;
	}
	
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
	}
	
	public function swapSelected():Void{
		if(selected) setSelected(false);
		else setSelected(true);
	}
	
	public function setSelected(val:Boolean):Void{
		if(val){ // Select = TRUE
			mcState.gotoAndStop("selected");
			mc.selected = true;
		} else { // Select = FALSE
			mcState.gotoAndStop("default");
			mc.selected = false;
		}
		if(mc.onChanged) mc.onChanged([mc, selected]);
	}
	
	public function getSelected():Boolean{
		return selected;
	}

	public function enable(avoidAlpha:Boolean):Void{
		mc.enabled = true;
		if(avoidAlpha !== false) mc._alpha = 100;
	}
	
	public function disable(avoidAlpha:Boolean):Void{
		mc.enabled = false;
		if(avoidAlpha !== false) mc._alpha = 50;
	}
	
}