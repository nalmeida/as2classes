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
	RadiobuttonComponent. A simple and lightweight Radiobutton Component.
	
	@author Nicholas Almeida
	@version 29/06/07
	@since Flash Player 8
	@example
		<code>
			mcTeste1 = new RadiobuttonComponent(mcTeste1);
			mcTeste2 = new RadiobuttonComponent(mcTeste2);

			mcTeste1.init({
				groupName:"outroGrupo", 
				label:"test test test test test test test test test test test test 1", 
				width: 100, 
				align:"left", 
				title: "Radio 1", 
				value:1
			});
			mcTeste2.init({
				groupName:"outroGrupo", 
				label:"test test  2", 
				align:"left", 
				title: "Radio 1", 
				value:2
			});

			mcTeste1.onGroupChanged = function(arr:Array){
				trace("onGroupChanged called. Selected Mc: " + arr[0] + " value: " + arr[1]);
			}
			
			btSet.onRelease = function(){
				mcTeste2.setSelected(true);
			}
			
			btGet.onRelease = function(){
				trace("Selected mc: " + mcTeste1.getSelected()[0] + " value: " + mcTeste1.getSelected()[1]);
			}
			
			btEnable.onRelease = function(){
				mcTeste1.enableGroup();
			}
			
			btDisable.onRelease = function(){
				mcTeste1.disableGroup();
			}
		</code>
*/
class as2classes.form.RadiobuttonComponent extends MovieClip{
	
	private var mc:MovieClip;
	private var mcState:MovieClip;
	
	private var label:String;
	private var value:String;
	private var selected:Boolean;
	private var enabled:Boolean;
	private var groupName:String;
	private var arrGroupName:Array = [];
	
	public var required:Boolean;
	public var title:Boolean;
	
	public var _type:String;
	public var customErrorMessage:String;

	/**
		Radiobutton Component constructor.
		
		@param $mc:MovieClip - Movieclip to be used as the component.
		@return Return none.
	*/
	function RadiobuttonComponent($mc:MovieClip, objectSetup:Object){
		this._type = "radiobutton";
		
		mc = $mc || this;
		mc.isFormField = true;
		mcState = mc.mcRadioButtonState;
		mc.useHandCursor = false;
		
		mc.onRelease =
		mc.onReleaseOutside = Delegate.create(this, setSelected, true);
		
		required = false;
		
		if(objectSetup) init(objectSetup);
	
	}
	
	/**
		Initialize the Radiobutton Component.
		
		@param obj:Object - Object notation to get the real parameters.
		@param obj.title:String - Title used to validade the form.
		@param obj.tabIndex:Number or Booblean - Number represents the tabIndex value. To disable the tabIndex, set it to false. Default value 1.
		@param obj.required:Boolean - Used on form validation to set the field as required.
		
		@param obj.selected:Booblean - If you need the Radiobutton starts as selected. Default false.
		@param obj.groupName:String - The name of the Radiobutton Group.
		@param obj.label:String - The text of Radiobutton.
		@param obj.value:String - The value of Radiobutton.
		@param obj.align:String - The align of textField. Valid values "left" or "right". Default "right".
		@param obj.width:Number - Combobox width. Default is undefined and it make the textField be autoSize = true.
		@param obj.customErrorMessage:String - Custom message to use with FormValidator class .
		@return Return none.
	*/
	public function init(obj:Object):Void{
		// Group name
		if(!obj.groupName) trace("ERROR on RadioButton: " + mc + " parameter \"groupName\" not defined.");
		groupName = obj.groupName;
		arrGroupName.push({theClass:this, groupName:groupName});
		
		// Label
		if(!obj.label) trace("ERROR on RadioButton: " + mc + " parameter \"label\" not defined.");
		mc.fld_label.text = label = obj.label;
		
		// Title
		if(!obj.title) trace("WARNING on RadioButton: " + mc + " parameter \"title\" not defined.");
		title = obj.title || mc._name;
		
		// Value
		if(!obj.value) trace("ERROR on RadioButton: " + mc + " parameter \"value\" not defined.");
		value = obj.value.toString() || mc._name;
		
			// Width
			if(obj.width){
				mc.fld_label.wordWrap = true;
				mc.fld_label.multiline = true;
				mc.fld_label._width = obj.width;
				mc.fld_label._width = 150;
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
		setSelected(obj.selected, true);
		
		// Tab
		if(obj.tabIndex === false){
			mc.tabEnabled = false;
			mc.tabChildren = false;
		} else {
			mc.tabEnabled = true;
			mc.tabChildren = false;
			mc.tabIndex = obj.tabIndex || 1;
		}
		
		if(obj.customErrorMessage) customErrorMessage = obj.customErrorMessage;
	}
	
	/**
		Set the Radiobutton to true or false.
		
		@param val:Boolean - True or false.
		@return Return none.
	*/
	public function setSelected(val:Boolean, avoidOnChangeEvent:Boolean):Void{
		if(val){ // Select = TRUE
			reset();
			mcState.gotoAndStop("selected");
			this.selected = true;
		} else { // Select = FALSE
			mcState.gotoAndStop("default");
			this.selected = false;
		}
		
		if(!avoidOnChangeEvent){
			var tmpArr:Array = getMyGroup();
			for(var i=0; i<tmpArr.length; i++){
				if(tmpArr[i].selected){
					getHandler("onGroupChanged").onGroupChanged([tmpArr[i].mc, tmpArr[i].value]);
					break;
				}
			}
			delete tmpArr;
		}
	}
	
	/**
		Get the MovieClip and the value of selected item at group
		
		@return Return Array. [Movieclip, Value]
	*/
	public function getSelected():Array{
		var tmpArr:Array = getMyGroup();
		for(var i=0; i<tmpArr.length; i++){
			if(tmpArr[i].selected){
				return [tmpArr[i].mc, tmpArr[i].value];
			}
		}
	}
	
	/**
		Unselect all Raddiobuttons of a group.
		
		@return Return none.
	*/
	public function reset():Void{
		for(var i=0; i<arrGroupName.length; i++){
			if(arrGroupName[i].groupName == groupName){
				arrGroupName[i].theClass.setSelected(false, true);
			}
		}
	}
	
	/**
		Enable all Radiobuttons of a group.
		
		@param avoidAlpha:Boolean - If you don't want to change the _alpha of Movieclip use true.
		@return Return none.
	*/
	public function enableGroup(avoidAlpha:Boolean):Void{
		var tmpArr:Array = getMyGroup();
		for(var i=0; i<tmpArr.length; i++){
			tmpArr[i].mc.enabled = true;
			if(avoidAlpha !== false) tmpArr[i].mc._alpha = 100;
		}
		delete tmpArr;	
	}
	
	/**
		Disable all Radiobuttons of a group.
		
		@return Return none.
	*/
	public function disableGroup(avoidAlpha:Boolean):Void{
		var tmpArr:Array = getMyGroup();
		for(var i=0; i<tmpArr.length; i++){
			tmpArr[i].mc.enabled = false;
			if(avoidAlpha !== false) tmpArr[i].mc._alpha = 50;
		}
		delete tmpArr;		
	}
	

	// Private Methods
	private function getMyGroup():Array{
		var tmpArr:Array = [];
		for(var i=0; i<arrGroupName.length; i++){
			if(arrGroupName[i].theClass.groupName == groupName){
				tmpArr.push(arrGroupName[i].theClass);
			}
		}
		return tmpArr;
	}
	
	private function getHandler(functionName:String){
		var tmpArr:Array = getMyGroup();
		for(var i=0; i<tmpArr.length; i++){
			if(tmpArr[i][functionName]){
				return tmpArr[i];
			}
		}
	}

}